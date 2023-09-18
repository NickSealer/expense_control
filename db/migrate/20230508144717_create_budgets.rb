class CreateBudgets < ActiveRecord::Migration[5.2]
  def change
    create_table :budgets do |t|
      t.belongs_to :user
      t.date :from_date
      t.date :to_date
      t.boolean :enable_dynamic_cash_flow, default: false

      t.timestamps
    end
  end
end
