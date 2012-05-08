class AddDaysOnMarketToListings < ActiveRecord::Migration
  def change
    add_column :listings, :days_on_market, :integer
  end
end
