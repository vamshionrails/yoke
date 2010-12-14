set :application, "set your application name here"
set :repository,  "set your repository location here"

set :scm, :subversion
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "your web-server here"                          # Your HTTP server, Apache/etc
role :app, "your app-server here"                          # This may be the same as your `Web` server
role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
role :db,  "your slave db-server here"


#SPHINX
namespace :sphinx do
  task :install do
    puts "Installing Sphinx....."
  end
  task :start do
   puts "Starting Sphinx......"
  end
  task :stop do
    puts "Stopping Sphinx....."
  end
  task :restart do
    puts "Restarting Sphinx...."
  end
end

#NGINX

namespace :nginx do
  task :install do
    puts "Installing Nginx....."
  end
  task :start do
   puts "Starting Nginx......"
  end
  task :stop do
    puts "Stopping Nginx....."
  end
  task :restart do
    puts "Restarting Nginx...."
  end
end

#MEMCACHED

namespace :memcached do
  task :install do
    puts "Installing Memcached....."
  end
  task :start do
   puts "Starting Memcached......"
  end
  task :stop do
    puts "Stopping Memcached....."
  end
  task :restart do
    puts "Restarting Memcached...."
  end
end


#DELAYED JOB

namespace :delayed_job do
  task :install do
    puts "Installing Delayed Job....."
  end
  task :start do
   puts "Starting Delayed Job......"
  end
  task :stop do
    puts "Stopping Delayed Job....."
  end
  task :restart do
    puts "Restarting Delayed Job...."
  end

end
