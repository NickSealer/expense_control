class CreateRevenues < ActiveRecord::Migration[5.2]
  def change
    create_table :revenues do |t|
      t.decimal :value
      t.string :concept
      t.integer :category, default: 0
      t.belongs_to :budget

      t.timestamps
    end

    add_index :revenues, :concept
  end
end
