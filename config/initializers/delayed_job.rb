# Configure Delayed Job

Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.sleep_delay         = 2
Delayed::Worker.max_attempts        = 3
Delayed::Worker.max_run_time        = 30.minutes
Delayed::Worker.read_ahead          = 5
Delayed::Worker.default_queue_name  = 'default'
Delayed::Worker.delay_jobs          = true

# Print full stack trace

if Rails.env.development?
  class Delayed::Worker
    def handle_failed_job_with_loggin(job, error)
      handle_failed_job_without_loggin(job,error)
      Delayed::Worker.logger.error(error.message)
      Delayed::Worker.logger.error(error.backtrace.join("\n"))
    end
    alias_method_chain :handle_failed_job, :loggin
  end
end
