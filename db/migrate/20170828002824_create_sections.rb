class CreateSections < ActiveRecord::Migration[5.0]
  def change
    create_table :sections do |t|
      t.string :title
      t.text :description
      t.integer :position
      t.belongs_to :classroom

      t.timestamps
    end
  end
end
