class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.references :creditor, foreign_key: { to_table: :users }
      t.references :debtor, foreign_key: { to_table: :users }
      t.money :amount
      t.references :order, index: true, foreign_key: true

      t.timestamps
    end
  end
end
