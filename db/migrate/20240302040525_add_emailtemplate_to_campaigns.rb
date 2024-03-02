class AddEmailtemplateToCampaigns < ActiveRecord::Migration[7.0]
  def change
    add_reference :campaigns, :emailtemplate, null: false, foreign_key: true
  end
end
