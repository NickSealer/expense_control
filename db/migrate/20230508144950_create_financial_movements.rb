class CreateFinancialMovements < ActiveRecord::Migration[5.2]
  def change
    create_table :financial_movements do |t|
      t.belongs_to :financiable, polymorphic: true, index: { name: 'index_financial_moves_on_financiable_type_and_financiable_id' }

      t.timestamps
    end
  end
end
