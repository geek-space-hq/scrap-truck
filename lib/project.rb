# frozen_string_literal: true

require 'json'
require 'rest-client'
require_relative 'page'

module ScrapBox
  class Project
    attr_reader :id, :name, :url

    def initialize(data, client)
      @id = data[:id]
      @name = data[:name]
      @url = "https://scrapbox.io/#{@name}"

      @client = client
    end

    def search(keyword)
      response = RestClient.get(
        "https://scrapbox.io/api/pages/#{@name}/search/query?q=#{keyword}",
        { cookies: { 'connect.sid': @client.token } }
      )

      return [] unless response.code == 200

      JSON.parse(response.body)['pages'].map do
        Page.new(id: _1['id'], title: _1['title'], descriptions: _1['descriptions'], project: self)
      end
    end
  end
end
