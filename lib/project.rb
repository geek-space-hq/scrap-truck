# frozen_string_literal: true

class Project
  def initialize(data)
    @id = data[:id]
    @name = data[:name]
  end
end
