class CreateCodeLines < ActiveRecord::Migration[5.0]
  def change
    create_table :code_lines do |t|
      t.integer :line_number
      t.text :content
      t.belongs_to :code_submission
      t.timestamps
    end
  end
end
