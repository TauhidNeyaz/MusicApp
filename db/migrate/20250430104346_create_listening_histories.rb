class CreateListeningHistories < ActiveRecord::Migration[8.0]
  def change
    create_table :listening_histories do |t|
      t.references :user, null: false, foreign_key: true
      t.references :music, null: false, foreign_key: true
      t.datetime :listened_at

      t.timestamps
    end
  end
end
