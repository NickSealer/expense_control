class AddExpensesCountToCategory < ActiveRecord::Migration[7.0]
  def change
    add_column :categories, :expenses_count, :integer

    # Category.find_each do |category|
    #   Category.reset_counters(category.id, :expenses)
    # end
  end
end
