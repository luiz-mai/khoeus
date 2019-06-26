class CreateGradeCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :grade_categories do |t|
      t.string :title
      t.integer :weight
      t.belongs_to :classroom
      t.timestamps
    end
  end
end
