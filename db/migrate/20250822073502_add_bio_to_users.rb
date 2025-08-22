class AddBioToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :bio, :text
  end
end
