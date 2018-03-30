class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.string :address
      t.string :latitude
      t.string :longitude
      t.string :aasm_state
      t.float :value
      t.references :store, index: true, foreign_key: { to_table: :users }
      t.references :courier, index: true, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
