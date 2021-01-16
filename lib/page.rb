# frozen_string_literal: true

module ScrapBox
  class Page
    attr_reader :id, :title, :descriptions, :project, :url

    def initialize(data)
      @id = data[:id]
      @title = data[:title]
      @descriptions = data[:descriptions]
      @project = data[:project]
      @url = "https://scrapbox.io/#{@project.name}/#{title.gsub(' ', '_')}"
    end
  end
end
