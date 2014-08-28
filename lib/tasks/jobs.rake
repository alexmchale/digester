require 'net/ssh/gateway'

namespace :jobs do

  task :create_port_tunnel do
    # Make sure the use rhas specified where we're connecting.
    (username, hostname) = ENV["REMOTE_HOST"].to_s.split("@", 2)
    if [ username, hostname ].any? &:blank?
      puts "Please specify env var REMOTE_HOST containing a hostname like 'bob@example.com'."
      exit 1
    end

    # Create two pipes - one will be used to get the port number from the child
    # process, the other will be used to tell the child process when it's time
    # to exit.
    ( $gateway_in_rd  , $gateway_in_wr  ) = IO.pipe
    ( $gateway_out_rd , $gateway_out_wr ) = IO.pipe

    # The child process will establish the SSH connection to the database server.
    fork {
      $gateway_ssh  = Net::SSH::Gateway.new(hostname, username)
      $gateway_port = $gateway_ssh.open("localhost", 5432)

      puts "CHILD: Notifying parent process of gateway port number #{ $gateway_port }."

      $gateway_out_rd.close
      $gateway_out_wr.write($gateway_port.to_s)
      $gateway_out_wr.close

      puts "CHILD: Waiting for parent to close pipe."

      $gateway_in_wr.close
      $gateway_in_rd.read
      $gateway_in_rd.close

      puts "CHILD: Parent closed pipe. Exiting."

      $gateway_ssh.shutdown!
    }

    # Get the port number back from the child process once the SSH connection is established.
    puts "PARENT: Reading port number from child."
    $gateway_out_wr.close
    $gateway_port = Integer($gateway_out_rd.read)
    $gateway_out_rd.close

    # Log and proceed with the next task.
    puts "PARENT: Received port number #{ $gateway_port } from child. Proceeding with execution."
  end

  task :connect_to_tunneled_postgresql do
    # Load just ActiveRecord. Do this before any part of the native Rails project is loaded.
    require "active_record"

    # Make sure that the user has specified the database details.
    (dbname, dbuser, dbpass) = ENV.to_h.slice("DBNAME", "DBUSER", "DBPASS").values
    if [ dbname, dbuser, dbpass ].any? &:nil?
      puts "Please specify env vars DBNAME, DBUSER, DBPASS containing connection details."
      exit 1
    end

    # Connect to the remote Postgres database.
    ActiveRecord::Base.establish_connection({
      :adapter  => "postgresql"  ,
      :host     => "127.0.0.1"   ,
      :port     => $gateway_port ,
      :encoding => "unicode"     ,
      :database => dbname        ,
      :username => dbuser        ,
      :password => dbpass        ,
    })

    # Log a simple query just to verify that we actually have a connection.
    puts "Connected to remote Postgres. Found #{ User.count } users in the remote database."
  end

  task :destroy_port_tunnel do
    # Close the pipe with the gateway, indicating that it should close.
    puts "PARENT: Closing pipe with child to terminate gateway."
    $gateway_in_wr.close
    $gateway_in_rd.close
  end

  task :remote_work => %w(
    jobs:create_port_tunnel
    jobs:connect_to_tunneled_postgresql
    jobs:work
    jobs:destroy_port_tunnel
  )

  task :remote_workoff => %w(
    jobs:create_port_tunnel
    jobs:connect_to_tunneled_postgresql
    jobs:workoff
    jobs:destroy_port_tunnel
  )

end
