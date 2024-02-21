class AddGooglePlaceIdToBusinesses < ActiveRecord::Migration[7.0]
  def change
    add_column :businesses, :google_place_id, :string
  end
end
