# frozen_string_literal: true

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'
require 'rusky/task' if Rails.env.development?

Rails.application.load_tasks
Rusky::Task.install if Rails.env.development?
