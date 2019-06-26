class CreateTestAlternatives < ActiveRecord::Migration[5.0]
  def change
    create_table :test_alternatives do |t|
      t.string :content
      t.boolean :correct
      t.belongs_to :test_question
      t.timestamps
    end
  end
end
