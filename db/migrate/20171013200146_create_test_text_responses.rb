class CreateTestTextResponses < ActiveRecord::Migration[5.0]
  def change
    create_table :test_text_responses do |t|
      t.float :grade
      t.text :response
      t.belongs_to :user
      t.belongs_to :test_question
      t.timestamps
    end
  end
end
