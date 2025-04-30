class CreateMusics < ActiveRecord::Migration[8.0]
  def change
    create_table :musics do |t|
      t.string :title
      t.text :description
      t.string :mp3_url
      t.references :user, null: false, foreign_key: true
      t.integer :stream_count

      t.timestamps
    end
  end
end
