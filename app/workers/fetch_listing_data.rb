class FetchListingData < ActiveRecord::Base

  require 'nokogiri'
  require 'open-uri'

  @queue = :listing_queue
  def self.perform(listing_id)
    url = (Listing.find(listing_id)).url
    if url.include?("corcoran")
      corcoran_parse(listing_id)
    elsif url.include?("streeteasy")
      streeteasy_parse(listing_id)
    else
      send_error_message
    end
  end

  def self.streeteasy_parse(listing_id)
    listing = Listing.find(listing_id)
    url = (Listing.find(listing_id)).url
    doc = Nokogiri::HTML(open(url))

    desc_node = "#description_full, p"
    price_text_node = ".price .price"
    address_node = "h1 span:nth-child(2)"
    date_listed_string_node = ".labels_80 dt"
    days_on_market_string_node = ".price_stats"
    open_house_date_node = ".open_house b"

    description = doc.at_css(desc_node).text
    price_text = doc.at_css(price_text_node).text
    price = price_text.gsub(/[^\d\.]/, '')
    address = doc.at_css(address_node).text
    date = Time.now.to_date
    date_listed_string = doc.css(date_listed_string_node).last.text
    date_listed = Chronic.parse(date_listed_string).to_date
    days_on_market_string= doc.css(days_on_market_string_node).last.text
    days_on_market = days_on_market_string.gsub(/[^0-9]/, '')
    if doc.at_css(open_house_date_node)
      open_house_date = doc.at_css(open_house_date_node).text
    end

    parsed_params = {:listed_description => description, :listed_price => price, :address => address, :date_entered => date, :date_listed => date_listed, :days_on_market =>days_on_market, :open_house_date => open_house_date}

    listing.update_attributes(parsed_params)
  end

  def self.corcoran_parse(listing_id)
    listing = Listing.find(listing_id)
    url = (Listing.find(listing_id)).url
    doc = Nokogiri::HTML(open(url))

    desc_node = "#Table8 span"
    price_text_node = "#Table5 td:nth-child(2) tr:nth-child(1) td:nth-child(2)"
    address_node = ".head18px33333"
    open_house_date_node = ".text11px .text11px"

    description = doc.css(desc_node).last.text
    price_text = doc.at_css(price_text_node).text
    price = price_text.gsub(/[^\d\.]/, '')
    address = doc.at_css(address_node).text
    date = Time.now.to_date
    date_listed_string = ""
    date_listed = ""
    days_on_market_string= ""
    days_on_market = ""

    if doc.at_css(open_house_date_node)
      open_house_date = doc.at_css(open_house_date_node).text
    end

    parsed_params = {:listed_description => description, :listed_price => price, :address => address, :date_entered => date, :date_listed => date_listed, :days_on_market =>days_on_market, :open_house_date => open_house_date}

    listing.update_attributes(parsed_params)
  end

  def send_error_message
  end


end