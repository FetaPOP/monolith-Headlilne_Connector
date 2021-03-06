# frozen_string_literal: true

require 'rake/testtask'

CODE = 'lib/'

task :default do
  puts `rake -T`
end

desc 'Run unit and integration tests'
Rake::TestTask.new(:spec) do |t|
  t.pattern = 'spec/tests/{integration,unit}/**/*_spec.rb'
  t.warning = false
end

desc 'Run application console (irb)'
task :console do
  sh 'pry -r ./init.rb'
end

desc 'run tests'
task :spec do
  sh 'ruby spec/gateway_youtube_spec.rb'
end

desc 'Keep rerunning unit/integration tests upon changes'
task :respec do
  sh "rerun -c 'rake spec' --ignore 'coverage/*'"
end

desc 'Run acceptance tests'
task :spec_accept do
  puts 'NOTE: run app in test environment in another process'
  sh 'ruby spec/tests/acceptance/acceptance_spec.rb'
end

desc 'Keep restarting web app upon changes'
task :rerack do
  sh "rerun -c rackup --ignore 'coverage/*'"
end

namespace :db do
  task :config do
    require 'sequel'
    require_relative 'config/environment' # load config info
    require_relative 'spec/helpers/database_helper'

    def app() = HeadlineConnector::App
  end

  desc 'Run migrations'
  task migrate: :config do
    Sequel.extension :migration
    puts "Migrating #{app.environment} database to latest"
    Sequel::Migrator.run(app.DB, 'app/infrastructure/database/migrations')
  end

  desc 'Wipe records from all tables'
  task wipe: :config do
    if app.environment == :production
      puts 'Do not damage production database!'
      return
    end

    DatabaseHelper.wipe_database
  end

  desc 'Delete dev or test database file (set correct RACK_ENV)'
  task drop: :config do
    if app.environment == :production
      puts 'Do not damage production database!'
      return
    end

    FileUtils.rm(HeadlineConnector::App.config.DB_FILENAME)
    puts "Deleted #{HeadlineConnector::App.config.DB_FILENAME}"
  end
end

namespace :test do
  desc 'run tests (alias to: "rake spec")'
  task :spec do
    sh 'ruby spec/gateway_youtube_spec.rb'
  end

  desc 'run youtube api tests after deleting all VCR cassettes files'
  task :noVCR do
    sh 'rm spec/fixtures/cassettes/*.yml' do |ok, _|
      puts(ok ? 'Cassettes deleted' : 'No cassettes found')
    end
    sh 'ruby spec/gateway_youtube_spec.rb'
  end

  desc 'Generate the correct answer for gateway-youtubeapi tests'
  task :youtubeapi_testcase do
    sh 'ruby spec/fixtures/generate_youtubeapi_testcase.rb'
  end
end

namespace :vcr do
  desc 'delete cassette fixtures'
  task :wipe do
    sh 'rm spec/fixtures/cassettes/*.yml' do |ok, _|
      puts(ok ? 'Cassettes deleted' : 'No cassettes found')
    end
  end
end

namespace :quality do
  only_app = 'config/ app/'

  desc 'run all static-analysis quality checks'
  task all: %i[rubocop flog reek]

  desc 'code style linter'
  task :rubocop do
    sh 'rubocop'
  end

  desc 'code smell detector'
  task :reek do
    sh 'reek'
  end

  desc 'complexiy analysis'
  task :flog do
    sh "flog -m #{only_app}"
  end
end
