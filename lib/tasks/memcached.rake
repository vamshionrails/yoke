require "#{Rails.root}/config/environment.rb"
MEMCACHED_SOURCE='http://memcached.googlecode.com/files/memcached-1.4.5.tar.gz'

namespace :memcached do
  desc "Install memcached from source"
  task :install do
    build_dir = "#{ENV['HOME']}/ROR/personal/trendy/tmp"
    system "rm -rf #{build_dir}"
    system "mkdir -p #{build_dir}"
    puts "Downloading Memcached  from #{MEMCACHED_SOURCE}"
    cd build_dir do
      uri = URI.parse(MEMCACHED_SOURCE)
      tarball = File.basename(uri.path)
      Net::HTTP.start(uri.host) do |http|
        resp = http.get(uri.path)
        open(tarball, "wb") do |file|
          file.write(resp.body)
        end
      end
      system("tar -xzf #{tarball}")
      cd "#{build_dir}/#{tarball.gsub('.tar.gz','')}" do
        system("./configure --prefix=#{ENV['HOME']}/ROR/personal/trendy/servers/memcached")
        system("make")
        puts "\nRunning 'sudo make install' - this will install memcached."
        system("sudo make install")
      end
    end
  end

  desc "Starting memcached ....."
  task :start do
    if memcached_installed?
      puts "starting memcached"
    end

  end



end
