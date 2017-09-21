# frozen_string_literal: true

require "mysql2"
require "uri"
require_relative "../migrate/migration_manager"

class Fetcher
  attr_accessor :url

  def initialize(url)
    self.url = url
  end

  def perform
    puts "Performing fetching from #{self.url}"
    yield
  end
end

namespace :migration do
  desc "Migrate old database to the new one"
  task start: :environment do

  end

  desc "Download database from the old system"
  task fetch: :environment do
    Fetcher.new(ENV["LEGACY_DB_REMOTE_ADDR"], ENV["LEGACY_DB_SOURCE_FILE"]).perform do
      puts "Database fetched"
    end
  end

  desc "Build local MySQL database"
  task setup: :environment do
    connection = ActiveRecord::Base.establish_connection(ENV["CLEARDB_DATABASE_URL"])

    sql = File.read(ENV["LEGACY_DB_SOURCE_FILE"])
    statements = sql.split(/;\s*$/)
    statements.pop  # the last empty statement

    connection.connection.transaction do
      statements.each do |statement|
        connection.connection.execute(statement)
      end
    end
  end

  desc "Run migration"
  task run: :environment do
    config = URI.parse ENV["CLEARDB_DATABASE_URL"]

    connection = Mysql2::Client.new(username: config.user,
      password: config.password,
      port: config.port,
      database: config.path.sub(%r{^/}, ""),
      host: config.hostname)

    MigrationManager.new(connection).perform
  end
end
