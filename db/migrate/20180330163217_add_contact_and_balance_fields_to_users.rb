class AddContactAndBalanceFieldsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :business_name, :string
    add_column :users, :phone, :string
    add_column :users, :balance, :money
  end
end
