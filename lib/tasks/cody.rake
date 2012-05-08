desc "SAY HELLO WORLD"
task :greet => :environment do
  require 'nokogiri'
  require 'open-uri'  
  Listing.find(1) do |listing|
    url = "http://streeteasy.com/nyc/sale/680055-townhouse-181-ashland-place-fort-greene-brooklyn"
    doc = Nokogiri::HTML(open(url))
    description = doc.at_css("#description_full, p").text
    listing.update_attribute(:listed_description, description)
    
  end
end