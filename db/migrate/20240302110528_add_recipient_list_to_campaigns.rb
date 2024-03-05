class AddRecipientListToCampaigns < ActiveRecord::Migration[7.0]
  def change
    add_column :campaigns, :recipient_list, :string
  end
end
