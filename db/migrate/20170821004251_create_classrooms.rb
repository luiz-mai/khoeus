class CreateClassrooms < ActiveRecord::Migration[5.0]
  def change
    create_table :classrooms do |t|
      t.string :name
      t.string :password_digest
      t.boolean :has_grades
      t.boolean :has_attendance
      t.float :minimum_grade

      t.timestamps
    end
  end
end
