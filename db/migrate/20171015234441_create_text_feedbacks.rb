class CreateTextFeedbacks < ActiveRecord::Migration[5.0]
  def change
    create_table :text_feedbacks do |t|
      t.string :feedback
      t.belongs_to :test_text_response
      t.belongs_to :test_alternative_response
      t.belongs_to :submission

      t.timestamps
    end
  end
end
