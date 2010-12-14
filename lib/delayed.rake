require 'rake'
require 'fileutils'

class DelayedRake
  def initialize(task, options = {})
     @task     = task
     @options  = options
 end

  ##
  # Called by Delayed::Job.
  def perform
    FileUtils.cd RAILS_ROOT

    @rake = Rake::Application.new
    Rake.application = @rake
    ### Load all the Rake Tasks.
     Dir[ "./lib/tasks/**/*.rake" ].each { |ext| load ext }
     @options.stringify_keys!.each do |key, value|
      ENV[key] = value  
     end
    begin
       @rake[@task].invoke
    rescue => e
       RAILS_DEFAULT_LOGGER.error "[ERROR]: task \"#{@task}\" failed.  #{e}"
    end
 end
end

