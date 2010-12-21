require File.expand_path('../boot', __FILE__)

require 'rails/all'
Bundler.require(:default, Rails.env) if defined?(Bundler)

module TravisRails
  class Application < Rails::Application
    def self.javascript_expansions(*types)
      types.inject({}) { |expansions, type| expansions.merge(type => javascripts(type)) }
    end

    def self.javascripts(dir)
      root = Rails.root.join('public/javascripts')
      Dir[root.join(dir.to_s).join('**/*.js')].map { |file| file.sub("#{root.to_s}/", '') }
    end

    vendor  = %w(jquery-1.4.4.min.js jquery-ui-1.8.6.min.js underscore.js handlebars.js backbone.js socky.js)
    jasmine = %w(jasmine.js jasmine-html.js)
    expansions = javascript_expansions(:lib, :app, :tests)
    expansions.merge!(:vendor => vendor.map { |name| "vendor/#{name}" })
    expansions.merge!(:jasmine => jasmine.map { |name| "vendor/#{name}" })

    config.autoload_paths << config.paths.app.views.to_a.first
    config.action_view.javascript_expansions = expansions

    config.encoding = "utf-8"
    config.filter_parameters += [:password]
  end
end