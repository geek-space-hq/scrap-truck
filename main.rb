# frozen_string_literal: true

require 'bundler/setup'
require 'dotenv'
require_relative './lib/scrap_truck'

Dotenv.load
scrap_truck = ScrapTruck.new(ENV['SCRAPTRUCK_TOKEN'], ENV['SCRAPBOX_TOKEN'])
scrap_truck.run
