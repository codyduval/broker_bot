class AddListedDateToListing < ActiveRecord::Migration
  def change
    add_column :listings, :date_listed, :date
  end
end
