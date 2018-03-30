class CreateTeams < ActiveRecord::Migration[5.1]
  def change
    create_table :teams do |t|
      t.references :store, index: true, foreign_key: { to_table: :users }
      t.references :courier, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
