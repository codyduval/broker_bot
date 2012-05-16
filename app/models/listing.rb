class Listing < ActiveRecord::Base
  attr_accessible :address, :url, :date_entered, :listed_price, :open_house_date, :map_url, :listed_description, :date_listed, :days_on_market

  has_many :notes
  has_many :photos

  def self.create_from_postmark(mitt)
    listing = Listing.new
    message_body = mitt.text_body
    parsed_uri_array = URI.extract(message_body, "http")
    parsed_uri_messy = parsed_uri_array[0].to_s
    parsed_uri = parsed_uri_messy.gsub(/[*]/,'')
    listing.url = parsed_uri
    listing.save
  end
  
end

