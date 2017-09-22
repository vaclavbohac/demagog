# frozen_string_literal: true

require_relative "./veracity_migration"
require_relative "./party_migration"
require_relative "./speaker_migration"
require_relative "./statement_migration"

class MigrationManager
  attr_accessor :connection

  def initialize(connection)
    self.connection = connection
  end

  def perform
    tasks = [
      VeracityMigration,
      PartyMigration,
      SpeakerMigration,
      StatementMigration
    ]

    tasks.each { |task| task.new(connection).perform }
  end
end
