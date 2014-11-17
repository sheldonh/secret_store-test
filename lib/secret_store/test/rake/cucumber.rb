require 'rubygems'
require 'cucumber'
require 'cucumber/rake/task'

=begin
Example usage in the Rakefile of an implementation that provides an imperative test runner for our declarative cucumber tests:

  require 'rubygems'
  require 'bundler'
  Bundler.setup

  begin
    require 'secret_store/test/rake/cucumber'

    SecretStore::Test::Rake::Cucumber.new(:features) do |t|
      #t.implementation_path = File.expand_path('../features', __FILE__)
      t.cucumber_opts = "--format=pretty"
    end
  rescue LoadError
    desc 'Cucumber rake task not available'
    task :features do
      abort 'Cucumber not installed, rake task not available.'
    end
  end
=end

module SecretStore

  module Test

    module Rake

      class Cucumber < Cucumber::Rake::Task
        def initialize(task_name = "cucumber", desc = "Run Cucumber features")
          @cucumber_opts = ""
          @implementation_path = "features"
          yield self if block_given?
          super do |t|
            features_path = File.expand_path("../../../../../features", __FILE__)
            step_definitions = File.join(features_path, "step_definitions")
            support = File.join(features_path, "support")
            t.cucumber_opts = [
              features_path,
              "--require=#{step_definitions}",
              "--require=#{support}",
              "--require=#{@implementation_path}",
              @cucumber_opts
            ].join(" ")
          end
        end

        def cucumber_opts=(opts)
          @cucumber_opts = opts
        end

        def implementation_path=(path)
          @implementation_path = path
        end
      end

    end

  end

end
