#RAILS_ROOT="#{Rails.root}"
NGINX_BIN_PATH = "#{Rails.root}/servers/nginx/sbin/nginx"
NGINX_PID_PATH = "#{Rails.root}/tmp/pids/nginx.pid"
NGINX_CONFIG_PATH = "#{Rails.root}/servers/nginx/conf/nginx.conf"

def start_nginx
    puts "Stopping Nginx....."
	stop_nginx
   puts "Starting Nginx....."
   Thread.new do
    system "cd #{RAILS_ROOT} && #{NGINX_BIN_PATH} -c #{NGINX_CONFIG_PATH} -g 'pid #{NGINX_PID_PATH};'|| echo -en '\n already running.'"
  end
end

def stop_nginx
  puts "Stopping Nginx Job....."
  Thread.new do
    system "cd #{RAILS_ROOT} && kill -HUP '#{NGINX_PID_PATH}' || echo -en '\n not running'"
  end
end

def reload_nginx
  puts "Reloading Nginx ....."
  Thread.new do
    system "cd #{RAILS_ROOT} && kill -HUP `#{NGINX_PID_PATH}` || echo -en '\n cannot reload'"
  end
end

def process_is_dead?
  begin
    puts "Looking for Process...."
    pid = File.read(NGINX_PID_PATH).strip
    Process.kill(0, pid.to_i)
    false
  rescue
    true
  end
end

if !File.exist?(NGINX_PID_PATH) && process_is_dead?
 start_nginx
end





