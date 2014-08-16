# Configure Delayed Job

Delayed::Worker.destroy_failed_jobs = true
Delayed::Worker.sleep_delay         = 2
Delayed::Worker.max_attempts        = 3
Delayed::Worker.max_run_time        = 30.minutes
Delayed::Worker.read_ahead          = 5
Delayed::Worker.default_queue_name  = 'default'
Delayed::Worker.delay_jobs          = true
