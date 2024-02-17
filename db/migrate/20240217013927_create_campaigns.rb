class CreateCampaigns < ActiveRecord::Migration[7.0]
  def change
    create_table :campaigns do |t|
      t.time :delaytime
      t.string :name
      t.references :business, null: false, foreign_key: true

      t.timestamps
    end
  end
end
