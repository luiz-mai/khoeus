class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email, unique: true
      t.string :password
      t.string :cep
      t.string :address
      t.integer :number
      t.string :complement
      t.string :neighborhood
      t.string :city
      t.string :state
      t.string :country
      t.string :photo_name
      t.string :language
      t.string :timezone
      t.string :password_digest
      t.string :remember_digest
      t.string :activation_digest
      t.string :reset_digest
      t.datetime :reset_sent_at
      t.boolean :admin
      t.boolean :confirmed
      t.datetime :confirmed_at
      t.datetime :last_access

      t.timestamps
    end
  end
end
