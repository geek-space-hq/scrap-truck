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

  def search(event)
    keyword = event.content.delete_prefix('$search ')
    if keyword.match?(/<#\d+>/)
      mention = keyword.match(/<#\d+>/).to_s
      channel = @discord_bot.channel(mention.match(/\d+/).to_s.to_i)
      keyword = keyword.gsub(mention, "##{channel.name}")
    end

    pages = @scrapbox_bot.search_pages(keyword)
    event.send_embed('', pages_to_embed(pages))
  end

  def pages_to_embed(pages)
    fields = pages[..7].map do
      Discordrb::Webhooks::EmbedField.new(inline: false, name: _1.title, value: _1.url)
    end

    footer = Discordrb::Webhooks::EmbedFooter.new(text: 'And more...') if pages.size > 8
    description = '見つからんかった 👀' if pages.size == 0

    Discordrb::Webhooks::Embed.new(
      fields: fields,
      footer: footer,
      description: description
    )
  end

  def setup
    @discord_bot.message(content: '$projects', &method(:projects))
    @discord_bot.message(start_with: '$search', &method(:search))
  end

  def run
    setup
    @discord_bot.run
  end
end
