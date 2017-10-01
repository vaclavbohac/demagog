# frozen_string_literal: true

class ArticleTypeMigration
  attr_accessor :connection

  def initialize(connection)
    self.connection = connection
  end

  def perform
    ArticleType.bulk_insert(:name, :created_at, :updated_at) do |worker|
      worker.add(["default", Time.now, Time.now])
      worker.add(["static", Time.now, Time.now])
    end
  end
end
