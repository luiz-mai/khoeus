class CreateActivities < ActiveRecord::Migration[5.0]
  def change
    create_table :activities do |t|
      t.float :grade
      t.belongs_to :user
      t.belongs_to :external_activity
      t.timestamps
    end
  end
end
