class CreateExperiences < ActiveRecord::Migration[7.1]
  def change
    create_table :experiences do |t|
      t.references :user, null: false, foreign_key: true

      t.string  :company,  null: false
      t.string  :role,     null: false
      t.string  :location
      t.date    :start_date, null: false
      t.date    :end_date

      # Store as free text; you can parse by lines in the component
      t.text    :highlights
      # Comma-separated tech stack
      t.text    :tech

      t.timestamps
    end
    add_index :experiences, [ :user_id, :start_date ]
  end
end
