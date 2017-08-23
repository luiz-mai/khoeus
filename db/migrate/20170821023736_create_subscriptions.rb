class CreateSubscriptions < ActiveRecord::Migration[5.0]
  def change
    create_table :subscriptions do |t|

      t.belongs_to :user, index: true
      t.belongs_to :classroom, index: true
      t.string :role

      t.timestamps
    end
  end
end
