# frozen_string_literal: true

class DuplicationTester
  DUPLICATED_IDS = {
    164 => 163, # Jan Fisher
    182 => 181, # Vaclav Klaus
  }

  def duplicate?(speaker_id)
    DUPLICATED_IDS.key?(speaker_id)
  end

  def duplicated_id(speaker_id)
    DUPLICATED_IDS[speaker_id] || speaker_id
  end
end
