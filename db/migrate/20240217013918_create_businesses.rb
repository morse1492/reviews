class CreateBusinesses < ActiveRecord::Migration[7.0]
  def change
    create_table :businesses do |t|
      t.string :email
      t.string :business_name
      t.string :password
      t.text :contact_info

      t.timestamps
    end
  end
end
