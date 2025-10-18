class AddVariousFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :bio, :text
    add_column :users, :age, :integer
    add_column :users, :salary, :decimal
    add_column :users, :active, :boolean
    add_column :users, :birth_date, :date
    add_column :users, :last_login, :datetime
    add_column :users, :gender, :integer
    add_column :users, :profile_picture, :string
    add_column :users, :country_id, :integer
    add_column :users, :role, :string
    add_column :users, :preference, :string
  end
end
