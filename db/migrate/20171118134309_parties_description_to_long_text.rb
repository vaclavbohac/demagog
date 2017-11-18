class PartiesDescriptionToLongText < ActiveRecord::Migration[5.1]
  def up
    change_column :parties, :description, :longtext
  end

  def down
    change_column :parties, :description, :text
  end
end
