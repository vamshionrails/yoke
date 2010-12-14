require File.expand_path('../boot', __FILE__)

require 'rails/all'

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

module Authlogic
  class Application < Rails::Application

    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    config.themes_for_rails.themes_dir = "trendy"



  end
end

#LOCALIZATION
I18n.default_locale = 'English'
LOCALES_DIRECTORY = "#{::Rails.root.to_s}/config/locales"
LOCALES_AVAILABLE = Dir["#{LOCALES_DIRECTORY}/*.{rb,yml}"].collect do |locale_file|
  I18n.load_path << locale_file
  File.basename(File.basename(locale_file, ".rb"), ".yml")
end.uniq.sort

#CONFIGURATIONS

APP_CONFIG = YAML::load(ERB.new((IO.read("#{::Rails.root}/config/settings.yml"))).result)
