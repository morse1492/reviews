class AddYelpBusinessIdToBusinesses < ActiveRecord::Migration[7.0]
  def change
    add_column :businesses, :yelp_business_id, :string
  end
end
