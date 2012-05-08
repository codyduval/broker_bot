class AddNewDateColumnToListings < ActiveRecord::Migration
  def change
    add_column :listings, :date_entered, :date
  end
end
