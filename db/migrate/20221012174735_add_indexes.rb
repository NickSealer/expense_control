class AddIndexes < ActiveRecord::Migration[5.2]
  def change
    add_index :expenses, :month
    add_index :expenses, :year
  end
end
