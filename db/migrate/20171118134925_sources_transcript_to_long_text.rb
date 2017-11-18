class SourcesTranscriptToLongText < ActiveRecord::Migration[5.1]
  def up
    change_column :sources, :transcript, :longtext
  end

  def down
    change_column :sources, :transcript, :text
  end
end
