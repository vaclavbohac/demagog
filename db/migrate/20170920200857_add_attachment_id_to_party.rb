class AddAttachmentIdToParty < ActiveRecord::Migration[5.1]
  def change
    add_reference :parties, :attachment, index: true
  end
end
