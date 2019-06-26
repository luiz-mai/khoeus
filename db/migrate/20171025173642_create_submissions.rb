class CreateSubmissions < ActiveRecord::Migration[5.0]
  def change
    create_table :submissions do |t|
      t.string :type
      t.float :grade
      t.string :language
      t.text :content
      t.attachment :assignment_file
      t.belongs_to :assignment
      t.belongs_to :user
      t.timestamps
    end
  end
end
