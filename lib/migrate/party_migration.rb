# frozen_string_literal: true

class PartyMigration
  attr_accessor :connection

  def initialize(connection)
    self.connection = connection
  end

  def perform
    old_parties = self.connection.query("SELECT id, nazov, skratka, popis, logo FROM politicka_strana")

    old_parties.each do |old_party|
      party = Party.new(
        id: old_party["id"],
        name: old_party["nazov"],
        short_name: old_party["skratka"],
        description: old_party["popis"],
      )

      if old_party["logo"]
        party.attachment = Attachment.create(
          attachment_type: Attachment::TYPE_PARTY_LOGO,
          file: old_party["logo"]
        )
      end

      party.save!
    end
  end
end
