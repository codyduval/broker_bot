class Listing < ActiveRecord::Base
  attr_accessible :address, :url, :date_entered, :listed_price, :open_house_date, :map_url, :listed_description, :date_listed, :days_on_market

  has_many :notes
  has_many :photos
  
end

