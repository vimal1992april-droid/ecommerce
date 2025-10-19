class MakeEmailNotNullInUsers < ActiveRecord::Migration[7.0]
  def change
    # Ensure all existing email fields are not null before adding constraint
    User.where(email: nil).update_all(email: "example@example.com")

    # Change the column to NOT NULL
    change_column_null :users, :email, false
  end
end
