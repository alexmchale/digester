class Instapaper

  attr_reader :username, :password

  def initialize(username, password)
    if consumer_key == nil || consumer_secret == nil
      raise "instapaper api key not initialized"
    end

    @username = username
    @password = password
  end

  def valid?
    uri = uri_base
    options = { method: :post, body: "Blargh!" }
    oauth_params = { consumer: oauth_consumer, token: oauth_access_token }
    req = Typhoeus::Request.new(uri, options)
    auth_header = SimpleOAuth::Header.new(:post, uri, options[:params] || {}, oauth_access_token).to_s
    req.options[:headers]["Authorization"] = auth_header
    p req.options
    p req
    response = req.run
  end

  def request_access_token
    uri = URI.parse(uri_access_token)
    req = Net::HTTP::Post.new(uri)
    req.set_form_data(access_token_params)
    req["Authorization"] = access_token_auth
    http = Net::HTTP.new(uri.hostname, uri.port)
    http.use_ssl = true
    res = http.start { http.request(req) }

    if res.code == "200" && res.body =~ /\Aoauth_token_secret=([0-9a-f]+)&oauth_token=([0-9a-f]+)\z/
      { oauth_token_secret: $1, oauth_token: $2 }
    end
  end

  protected

  def uri_base
    "https://www.instapaper.com/api/1"
  end

  def uri_access_token
    "#{ uri_base }/oauth/access_token"
  end

  def access_token_params
    {
      :x_auth_mode     => "client_auth",
      :x_auth_password => password,
      :x_auth_username => username,
    }
  end

  def access_token_auth
    oauth = { consumer_key: consumer_key, consumer_secret: consumer_secret }
    SimpleOAuth::Header.new(:post, uri_access_token, access_token_params, oauth).to_s
  end

  def oauth_header
  end

  def consumer_key
    ENV["INSTAPAPER_KEY"]
  end

  def consumer_secret
    ENV["INSTAPAPER_SECRET"]
  end

end
