class CreateFavoriteLinks < ActiveRecord::Migration[7.2]
  def change
    create_table :favorite_links do |t|
      t.references :user, null: false, foreign_key: true
      t.string  :label, null: false
      t.string  :url,   null: false
      t.integer :position, null: false, default: 0
      t.integer :clicks, null: false, default: 0

      t.timestamps
    end

    add_index :favorite_links, [ :user_id, :position ]
  end
end
