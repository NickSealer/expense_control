class AddPriorityToCategories < ActiveRecord::Migration[7.0]
  def change
    add_column :categories, :priority, :integer, default: 0
    add_column :categories, :color, :string, default: 'white'
  end
end
