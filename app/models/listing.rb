class Listing < ActiveRecord::Base
  attr_accessible :address, :url, :date_entered, :listed_price, :open_house_date, :map_url, :listed_description, :date_listed, :days_on_market, :notes_attributes, :property_rating, :active_flag

  has_many :notes, :dependent => :destroy
  has_many :photos
  has_many :comments, :as => :commentable
  accepts_nested_attributes_for :notes, allow_destroy: true

  validates :url, :presence => true
  before_validation :default_values

  def default_values
    self.active_flag  ||= 'true' if active_flag.nil?
    self.address      ||= 'Looking up...'
    self.date_entered ||= Time.now
    self.property_rating ||= '3'

  end


  def self.create_from_postmark(mitt)
    message_body = mitt.text_body
    from_email = mitt.from_email
    parsed_uri_array = URI.extract(message_body, "http")
    listings = Array.new
    if parsed_uri_array.present?
      parsed_uri_array.each do |single_parsed_uri|
        cleaned_uri = single_parsed_uri.to_s.gsub(/[*]/,'')
        listing = Listing.find_or_initialize_by_url(cleaned_uri)
        unless listing.notes.present?
          note = listing.notes.build(:note_text => "Sent via email from #{from_email}")
          note.save
        end
        listing.url = cleaned_uri
        listings.push(listing)
      end
      return listings
    else
      listing = Listing.new
      listings = [listing]
      return listings
    end
  end
end
