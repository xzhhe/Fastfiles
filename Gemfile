source "https://rubygems.org"
ruby '2.4.1'
gem 'bundler', '2.1.2'
gem 'cocoapods'
gem 'fastlane'
gem 'ruby_extensions', git: 'https://github.com/xzhhe/ruby_extensions.git', branch: 'master'
gem 'dotenv', '>=2.7.5', '<3.0'
gem 'jenkins_api_client', '>=1.5.3', '<2.0'
gem 'formatador', '>=0.2.5', '<1.0'
gem 'toml-rb'
gem 'gitlab', '>=4.11.0'
#
# gem 'pry'
# gem 'simplecov'
#
gem 'rake'
gem 'rspec_junit_formatter'
gem 'rspec'

## plugin references
plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval_gemfile(plugins_path) if File.exist?(plugins_path)
