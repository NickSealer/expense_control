class CreateCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :categories do |t|
      t.string :name
      t.string :description
      t.integer :parent_id
      t.references :user, foreing_key: true

      t.timestamps
    end
  end
end
