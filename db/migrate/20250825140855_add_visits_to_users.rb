class AddVisitsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :visits, :integer, default: 0
  end
end
