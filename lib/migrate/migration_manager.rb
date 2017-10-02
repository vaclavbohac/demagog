# frozen_string_literal: true

require_relative "./article_migration"
require_relative "./article_type_migration"
require_relative "./medium_migration"
require_relative "./membership_migration"
require_relative "./party_migration"
require_relative "./speaker_migration"
require_relative "./statement_migration"
require_relative "./veracity_migration"

class MigrationManager
  attr_accessor :connection

  def initialize(connection)
    self.connection = connection
  end

  def perform
    tasks = [
      ArticleTypeMigration,
      ArticleMigration,
      VeracityMigration,
      PartyMigration,
      SpeakerMigration,
      StatementMigration,
      MembershipMigration,
      MediumMigration
    ]

    tasks.each { |task| task.new(connection).perform }
  end
end
