# Rails 3 jQuery Install Rakefile
# by Aaron Kalin
# Compiled from http://www.railsinside.com/tips/451-howto-unobtrusive-javascript-with-rails-3.html
# 
# Note: this assumes you use git, if not then use the optional usage
# 
# Usage: rake install_query
# 
# Optional usage: rake install_jquery[nogit]
# 
# Install: drop this file into lib/tasks, then run rake install_jquery

desc "replace prototype with jQuery (via git)"
task :install_jquery, :nogit do |t, args|
  puts "Ripping out Prototype"
  # Prototype files to remove
  proto = ["public/javascripts/prototype.js",
           "public/javascripts/dragdrop.js",
           "public/javascripts/effects.js",
           "public/javascripts/controls.js"].join(" ")
  # check for git
  if args.nogit
    remove = "rm"
  else
    remove = "git rm"
  end
  # Remove files
  system "#{remove} #{proto}"
  
  # Setup jQuery
  puts "Downloading jQuery"
  system "curl -L http://code.jquery.com/jquery-1.4.2.min.js > public/javascripts/jquery.js"
  system "curl -L http://github.com/rails/jquery-ujs/raw/master/src/rails.js > public/javascripts/rails.js"
  
  # Install initializer
  puts "Installing Initializer"
  assetstring = %{
module ActionView::Helpers::AssetTagHelper
  remove_const :JAVASCRIPT_DEFAULT_SOURCES
  JAVASCRIPT_DEFAULT_SOURCES = %w(jquery.js rails.js)

  reset_javascript_include_default
end
}
  File.open("config/initializers/jquery.rb", "w") do |f|
    f.write assetstring
  end
end
