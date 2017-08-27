class CreateLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :logs do |t|

      t.string :action
      t.string :subject
      t.integer :subject_id
      t.belongs_to :user, index: true
      t.belongs_to :classroom, index: true, null: true

      t.timestamps
    end
  end
end
