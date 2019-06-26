class CreateTestAlternativeResponses < ActiveRecord::Migration[5.0]
  def change
    create_table :test_alternative_responses do |t|
      t.belongs_to :user
      t.belongs_to :test_alternative
      t.timestamps
    end
  end
end
