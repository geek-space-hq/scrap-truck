# frozen_string_literal: true

require 'json'
require 'rest-client'
require_relative 'project'

module ScrapBox
  class Client
    attr_reader :projects, :token

    def initialize(token)
      @token = token

      @projects = set_projects
    end

    def search_pages(keyword)
      @projects.map { _1.search(keyword) }.flatten
    end

    private

    def set_projects
      response = RestClient.get(
        'https://scrapbox.io/api/projects',
        { cookies: { 'connect.sid': @token } }
      )

      return [] unless response.code == 200

      JSON.parse(response.body)['projects'].map do
        Project.new({ id: _1['id'], name: _1['name'] }, self)
      end
    end
  end
end
