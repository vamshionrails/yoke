require "#{RAILS_ROOT}/config/environment.rb"
SPHINX_SOURCE='http://www.sphinxsearch.com/downloads/sphinx-0.9.9.tar.gz' # r1234

namespace :sphinx do  
  desc "Install Sphinx from source"
  task :install do
    build_dir = "#{ENV['HOME']}/ROR/personal/trendy/tmp"
    system "rm -rf #{build_dir}"
    system "mkdir -p #{build_dir}"
    puts "Downloading Sphinx indexer from #{SPHINX_SOURCE}"
    cd build_dir do 
      uri = URI.parse(SPHINX_SOURCE)
      tarball = File.basename(uri.path)
      Net::HTTP.start(uri.host) do |http|
        resp = http.get(uri.path)
        open(tarball, "wb") do |file|
          file.write(resp.body)
        end
      end
      system("tar -xzf #{tarball}")
      cd "#{build_dir}/#{tarball.gsub('.tar.gz','')}" do
        system("./configure --prefix=#{ENV['HOME']}/ROR/personal/trendy/servers/sphinx --with-mysql --with-pgsql ")
        system("make")
        puts "\nRunning 'sudo make install' - this will install Sphinx."
        system("sudo make install")
      end
    end  
  system("sudo mkdir -p  #{ENV['HOME']}/ROR/personal/trendy/db/sphinx")
  system("sudo chown -R `whoami` #{ENV['HOME']}/ROR/personal/trendy/db/sphinx")
  end 
end
