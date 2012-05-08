class CreateListings < ActiveRecord::Migration
  def change
    create_table :listings do |t|
      t.string :address
      t.string :url
      t.string :date_entered
      t.integer :listed_price
      t.string :open_house_date
      t.string :map_url
      t.text :listed_description
      t.timestamps
    end
  end
end
