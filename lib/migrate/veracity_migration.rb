# frozen_string_literal: true

class VeracityMigration
  attr_accessor :connection

  def initialize(connection)
    self.connection = connection
  end

  def perform
    old_veracities = self.connection.query("SELECT * FROM pravdivostna_hodnota")

    old_veracities.each do |old_veracity|
      veracity = Veracity.new(id: old_veracity["id"],
        name: old_veracity["pravdivostna_hodnota"],
        description: old_veracity["popis"],
        key: Veracity.default_name(old_veracity["id"]))

      veracity.save!
    end
  end
end
