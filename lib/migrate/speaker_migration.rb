# frozen_string_literal: true

# Migrates speakers and their portraits
class SpeakerMigration
  attr_accessor :connection

  def initialize(connection)
    self.connection = connection
  end

  def get_status(id)
    # self::VERSION_SK => [72, 74, 90, 93, 109, 113, 116, 136, 149],
    deleted_ids = [
      204, 200, 216, 219, 232
    ]

    deleted_ids.include?(id.to_i)
  end

  def duplicate?(speaker)
    # TODO: Add check for SK version
    duplicate_ids = {
      164 => 163, # Jan Fisher
      182 => 181, # Vaclav Klaus
    }

    duplicate_ids.has?(speaker.id)
  end

  def create_speaker(old_speaker)
    Speaker.new(
      id: old_speaker["id"],
      first_name: old_speaker["meno"],
      last_name: old_speaker["priezvisko"],
      before_name: old_speaker["titul_pred_menom"],
      after_name: old_speaker["titul_za_menom"],
      bio: old_speaker["zivotopis"],
      website_url: old_speaker["web"],
      status: get_status(old_speaker["id"])
    )
  end

  def perform
    old_speakers = connection.query("SELECT * FROM politik")

    old_speakers.each do |old_speaker|
      speaker = create_speaker old_speaker

      next if duplicate?(speaker)

      party.save!
    end
  end
end
