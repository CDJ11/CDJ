if Rails.env.test? || Rails.env.development?
  Delayed::Worker.delay_jobs = false
else
  Delayed::Worker.delay_jobs = true
end
Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.sleep_delay = 2
Delayed::Worker.max_attempts = 3
Delayed::Worker.max_run_time = 1500.minutes
Delayed::Worker.read_ahead = 10
Delayed::Worker.default_queue_name = 'default'
Delayed::Worker.raise_signal_exceptions = :term
Delayed::Worker.logger = Logger.new(File.join(Rails.root, 'log', 'delayed_job.log'))


# Custom script to launch delayed job on startup, if server is to reboot
# cf https://stackoverflow.com/questions/2580871/start-or-ensure-that-delayed-job-runs-when-an-application-server-restarts
DELAYED_JOB_PID_PATH = "#{Rails.root}/tmp/pids/delayed_job.pid"

def start_delayed_job
  Thread.new do
    `ruby script/delayed_job start`
  end
end

def process_is_dead?
  begin
    pid = File.read(DELAYED_JOB_PID_PATH).strip
    Process.kill(0, pid.to_i)
    false
  rescue
    true
  end
end

if !File.exist?(DELAYED_JOB_PID_PATH) && process_is_dead?
  start_delayed_job
end
