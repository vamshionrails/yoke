require "#{RAILS_ROOT}/config/environment.rb"
NGINX_SOURCE='http://nginx.org/download/nginx-0.8.53.tar.gz' # r1234

namespace :nginx do
  desc "Install Nginx from source"
  task :install do
    build_dir = "#{ENV['HOME']}/ROR/personal/trendy/tmp"
    system "rm -rf #{build_dir}"
    system "mkdir -p #{build_dir}"
    puts "Downloading Nginx  from #{NGINX_SOURCE}"
    cd build_dir do
      uri = URI.parse(NGINX_SOURCE)
      tarball = File.basename(uri.path)
      Net::HTTP.start(uri.host) do |http|
        resp = http.get(uri.path)
        open(tarball, "wb") do |file|
          file.write(resp.body)
        end
      end
      system("tar -xzf #{tarball}")
      cd "#{build_dir}/#{tarball.gsub('.tar.gz','')}" do
        system("./configure --prefix=#{ENV['HOME']}/ROR/personal/trendy/servers/nginx")
        system("make")
        puts "\nRunning 'sudo make install' - this will install Nginx."
        system("sudo make install")
      end
    end
  end
end
