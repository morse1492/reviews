class AddTemplateNameToEmailtemplate < ActiveRecord::Migration[7.0]
  def change
    add_column :emailtemplates, :template_name, :string
  end
end
