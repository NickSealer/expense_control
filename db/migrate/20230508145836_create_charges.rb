class CreateCharges < ActiveRecord::Migration[5.2]
  def change
    create_table :charges do |t|
      t.decimal :value
      t.string :concept
      t.integer :category, default: 0
      t.date :date
      t.belongs_to :budget

      t.timestamps
    end

    add_index :charges, :concept
  end
end
