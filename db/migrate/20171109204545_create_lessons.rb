class CreateLessons < ActiveRecord::Migration[5.0]
  def change
    create_table :lessons do |t|
      t.string :title
      t.text :description
      t.timestamp :date
      t.belongs_to :classroom
      t.timestamps
    end
  end
end
