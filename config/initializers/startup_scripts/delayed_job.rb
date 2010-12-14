DELAYED_JOB_PID_PATH = "#{Rails.root}/tmp/pids/delayed_job.pid"

def start_delayed_job
  puts "Starting Delayed Job....."
  Thread.new do
    `ruby script/delayed_job start`
  end
end

def stop_delayed_job
  puts "Stopping Delayed Job....."
  Thread.new do
    `ruby script/delayed_job stop`
  end
end

def process_is_dead?
  begin
    puts "Looking for Process...."
    pid = File.read(DELAYED_JOB_PID_PATH).strip
    Process.kill(0, pid.to_i)
    false
  rescue
    true
  end
end

if !File.exist?(DELAYED_JOB_PID_PATH) && process_is_dead?
 stop_delayed_job
 start_delayed_job
end





