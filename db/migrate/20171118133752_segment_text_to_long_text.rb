class SegmentTextToLongText < ActiveRecord::Migration[5.1]
  def up
    change_column :segments, :text, :longtext
  end

  def down
    change_column :segments, :text, :text
  end
end
