# frozen_string_literal: true

require 'bundler/setup'
require 'discordrb'
require_relative 'scrapbox'

class ScrapTruck
  def initialize(discord_token, scrapbox_token)
    @discord_bot = Discordrb::Bot.new token: discord_token
    @scrapbox_bot = ScrapBox::Client.new scrapbox_token
  end

  def projects(event)
    scrapbox_projects = @scrapbox_bot.projects.map { _1.url }
    event.respond(scrapbox_projects.join("\n"))
    scrapbox_projects
  end

  def setup
    @discord_bot.message(content: '$projects', &method(:projects))
  end

  def run
    setup
    @discord_bot.run
  end
end
