# frozen_string_literal: true

require_relative '../../helpers/spec_helper'
require_relative '../../helpers/database_helper'
require_relative '../../helpers/vcr_helper'

# require 'headless'
require 'webdrivers/chromedriver'
require 'watir'

describe 'Acceptance Tests' do
  before do
    DatabaseHelper.wipe_database
    # @headless = Headless.new
    @browser = Watir::Browser.new
  end

  after do
    @browser.close
    # @headless.destroy
  end

  describe 'Homepage' do

    describe 'Generate Text Cloud' do
      it '(HAPPY) should be able to generate a text cloud' do
        # GIVEN: user is on the home page
        @browser.goto homepage

        # WHEN: they type in a topic and submit
        good_topic = TOPIC_NAME
        @browser.text_field(id: 'topic_input').set(surfing)
        @browser.button(id: 'repo-form-submit').click

        # THEN: they should find themselves on the topic's page
        @browser.url.include? "topic"
        @browser.url.include? TOPIC_NAME
      end
    end
  end
end
