class CreatePresences < ActiveRecord::Migration[5.0]
  def change
    create_table :presences do |t|
      t.boolean :present
      t.belongs_to :user
      t.belongs_to :lesson
      t.timestamps
    end
  end
end
