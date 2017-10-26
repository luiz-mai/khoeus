class CreateBoardItems < ActiveRecord::Migration[5.0]
  def change
    create_table :board_items do |t|
      t.string :type
      t.string :title
      t.text :description
      t.integer :position
      t.timestamp :start_time
      t.timestamp :end_time
      t.string :uri
      t.string :assignment_type
      t.integer :file_limit
      t.belongs_to :section

      t.timestamps
    end
  end
end
