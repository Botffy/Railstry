#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Firstapp::Application.load_tasks


desc "Starting Spork"
task :startspork do
	sh "bundle exec spork &"
end


desc "Running all tests with rspec"
task :testit do
	sh "bundle exec rspec --format specdoc"
end
