require "#{Rails.root}/config/environment.rb"
MONIT_SOURCE='http://mmonit.com/monit/dist/monit-5.2.3.tar.gz' # r1234

namespace :monit do
  desc "Install Monit from source"
  task :install do
    build_dir = "#{ENV['HOME']}/ROR/personal/trendy/tmp"
    system "rm -rf #{build_dir}"
    system "mkdir -p #{build_dir}"
    puts "Downloading Monit  from #{MONIT_SOURCE}"
    cd build_dir do
      uri = URI.parse(MONIT_SOURCE)
      tarball = File.basename(uri.path)
      Net::HTTP.start(uri.host) do |http|
        resp = http.get(uri.path)
        open(tarball, "wb") do |file|
          file.write(resp.body)
        end
      end
      system("tar -xzf #{tarball}")
      cd "#{build_dir}/#{tarball.gsub('.tar.gz','')}" do
        system("./configure --prefix=#{ENV['HOME']}/ROR/personal/trendy/servers/monit")
        system("make")
        puts "\nRunning 'sudo make install' - this will install Nginx."
        system("sudo make install")
      end
    end
  end
end
