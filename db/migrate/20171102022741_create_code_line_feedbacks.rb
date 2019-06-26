class CreateCodeLineFeedbacks < ActiveRecord::Migration[5.0]
  def change
    create_table :code_line_feedbacks do |t|
      t.text :feedback
      t.belongs_to :code_line
      t.timestamps
    end
  end
end
