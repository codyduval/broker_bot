class AddListingToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :listing_id, :integer
  end
end
