class AddRatingToListing < ActiveRecord::Migration
  def change
    add_column :listings, :property_rating, :integer
    add_column :listings, :active_flag, :boolean
  end
end
