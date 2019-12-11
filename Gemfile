source "https://rubygems.org"

gem 'cocoapods'
gem 'fastlane'
gem 'simplecov'
gem 'rspec_junit_formatter'
gem 'rubocop'
gem 'rubocop-require_tools'
gem 'pry'
gem 'rake'
gem 'rspec'
gem 'toml-rb'
gem 'down', '>=4.8.1'

## plugin references
plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval_gemfile(plugins_path) if File.exist?(plugins_path)
