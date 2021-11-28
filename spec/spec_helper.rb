# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require 'simplecov'
SimpleCov.start

require 'yaml'

require 'minitest/autorun'
require 'minitest/rg'
require 'vcr'
require 'webmock'

require_relative '../init'

VIDEO_ID = 'cmSbXsFE3l8'
YOUTUBE_TOKEN = HeadlineConnector::App.config.YOUTUBE_TOKEN # From config/environment.rb
CORRECT = YAML.safe_load(File.read('spec/fixtures/youtube_results.yml'))
TOPIC_NAME = 'surfing'