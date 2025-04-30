class CreateSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :subscriptions do |t|
      t.references :listener, null: false, foreign_key: { to_table: :users }
      t.references :artist, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :subscriptions, [:listener_id, :artist_id], unique: true
  end
end
