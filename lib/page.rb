# frozen_string_literal: true

class Page
  attr_reader :id, :title, :descriptions

  def initialize(data)
    @id = data[:id]
    @title = data[:title]
    @descriptions = data[:descriptions]
    @project = data[:project]
    @url = "https://scrapbox.io/#{@project}/#{title}"
  end
end
