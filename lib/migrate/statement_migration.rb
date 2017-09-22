# frozen_string_literal: true

require "date"
require_relative "./helpers/duplication_tester"

class StatementMigration
  attr_accessor :connection

  def initialize(connection)
    self.connection = connection
    @tester = DuplicationTester.new
  end

  def perform
    old_statements = self.connection.query("SELECT * FROM vyrok")

    keys = [
      :id,
      :source_id,
      :speaker_id,
      :content,
      :questionables,
      :count_in_statistics,
      :important,
      :published,
      :excerpted_at,
      :created_at,
      :updated_at
    ]

    Statement.bulk_insert(*keys) do |worker|
      old_statements.each do |old_statement|
        worker.add([
                     old_statement["id"],
                     old_statement["id_diskusia"],
                     @tester.duplicated_id(old_statement["id_politik"]),
                     old_statement["vyrok"],
                     old_statement["poznamka"],
                     old_statement["evaluate"] == 1,
                     old_statement["dolezity"] == 1,
                     old_statement["status"] == 1,
                     old_statement["timestamp"],
                     Time.now,
                     Time.now
                   ])
      end
    end
  end
end
