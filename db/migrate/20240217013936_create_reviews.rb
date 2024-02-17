class CreateReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :reviews do |t|
      t.string :platform
      t.integer :rating
      t.text :content
      t.boolean :responded
      t.references :business, null: false, foreign_key: true

      t.timestamps
    end
  end
end
