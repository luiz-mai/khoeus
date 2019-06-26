class AddAttachmentDocumentToBoardItems < ActiveRecord::Migration
  def self.up
    change_table :board_items do |t|
      t.attachment :document_file
    end
  end

  def self.down
    remove_attachment :board_items, :document_file
  end
end
