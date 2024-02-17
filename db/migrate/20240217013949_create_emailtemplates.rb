class CreateEmailtemplates < ActiveRecord::Migration[7.0]
  def change
    create_table :emailtemplates do |t|
      t.text :content
      t.string :subjectline
      t.references :business, null: false, foreign_key: true

      t.timestamps
    end
  end
end
