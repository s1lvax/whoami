class CreateSubscriptions < ActiveRecord::Migration[8.0]
  def change
    create_table :subscriptions do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :subscriber_email
      t.string :token
      t.boolean :confirmed, default: false
      t.datetime :confirmed_at
      t.boolean :canceled, default: false
      t.datetime :canceled_at

      t.timestamps
    end
  end
end
