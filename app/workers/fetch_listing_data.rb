class FetchListingData < ApplicationController
  extend HerokuResqueAutoScale

  # require 'nokogiri'
  # require 'open-uri'

  @broker_parsing_nodes = {
    :streeteasy_nodes => {
      :desc_node => "#description_full, p",
      :desc_node_alt => "",
      :price_text_node => ".price .price",
      :price_text_node_alt => "",
      :address_node => "h1 span:nth-child(2)",
      :date_listed_string_node => ".labels_80 dt",
      :days_on_market_string_node => ".price_stats",
      :open_house_date_node => ".open_house b"
    },

    :brown_harris_nodes => {
      :desc_node => ".notes",
      :desc_node_alt => "",
      :price_text_node => "",
      :price_text_node_alt => "strong:nth-child(1)",
      :address_node => ".section-left",
      :date_listed_string_node => "",
      :days_on_market_string_node => "",
      :open_house_date_node => ".open-house-times"
    },

    :corcoran_nodes => {
      :desc_node => "",
      :desc_node_alt => "#Table8 span",
      :price_text_node => "#Table5 td:nth-child(2)
                          tr:nth-child(1) td:nth-child(2)",
      :price_text_node_alt => "",
      :address_node => ".head18px33333",
      :date_listed_string_node => "",
      :days_on_market_string_node => "",
      :open_house_date_node => ".text11px .text11px"
    },

    :brooklyn_bridge_nodes => {
      :desc_node => "p",
      :desc_node_alt => "",
      :price_text_node => ".essentials b",
      :price_text_node_alt => "",
      :address_node => ".essentials:nth-child(4)",
      :date_listed_string_node => "",
      :days_on_market_string_node => "",
      :open_house_date_node => ".ohTime"
    },

    :elliman_nodes => {
      :desc_node => "#listing_item p",
      :desc_node_alt => "",
      :price_text_node => ".listing_price",
      :price_text_node_alt => "",
      :address_node => ".listing_address",
      :date_listed_string_node => "",
      :days_on_market_string_node => "",
      :open_house_date_node => "nobr"
    },

    :halstead_nodes => {
      :desc_node => ".notes",
      :desc_node_alt => "",
      :price_text_node => ".right p:nth-child(3)",
      :price_text_node_alt => "",
      :address_node => "h2",
      :date_listed_string_node => "",
      :days_on_market_string_node => "",
      :open_house_date_node => ".oh:nth-child(2) p:nth-child(1)"
    },

    :realtor_nodes => {
      :desc_node => "",
      :desc_node_alt => "",
      :price_text_node => ".price em",
      :price_text_node_alt => "",
      :address_node => "#address .ellipsis",
      :date_listed_string_node => "",
      :days_on_market_string_node => "",
      :open_house_date_node => ""
    },

    :nyt_nodes => {
      :desc_node => ".comments",
      :desc_node_alt => "",
      :price_text_node => "h3 span",
      :price_text_node_alt => "",
      :address_node => "h1",
      :date_listed_string_node => ".date",
      :days_on_market_string_node => "",
      :open_house_date_node => ""
    },

    :century_21_nodes => {
      :desc_node => "#propertyDescCollapse",
      :desc_node_alt => "",
      :price_text_node => ".mainPropPrice b",
      :price_text_node_alt => "",
      :address_node => "#propertyLocationAddress",
      :date_listed_string_node => "",
      :days_on_market_string_node => "",
      :open_house_date_node => ""
    }

  }
  @default_value = ""
  @queue = :listing_queue
  def self.perform(listing_id)
    @listing = Listing.find(listing_id)
    url = (Listing.find(listing_id)).url
    http_response = Net::HTTP.get_response(URI.parse(url))

    if http_response.code.match(/2[0-9]{2}|3[0-9]{2}/) #check HTTP header response code
      @doc = Nokogiri::HTML(open(url, "User-Agent" => 'ruby' ))
      if url.include?("corcoran")
        broker_hash = @broker_parsing_nodes[:corcoran_nodes]
      elsif url.include?("streeteasy")
        broker_hash = @broker_parsing_nodes[:streeteasy_nodes]
      elsif url.include?("bhsusa")
        broker_hash = @broker_parsing_nodes[:brown_harris_nodes]
      elsif url.include?("brooklynbridgerealty")
        broker_hash = @broker_parsing_nodes[:brooklyn_bridge_nodes]
      elsif url.include?("elliman")
        broker_hash = @broker_parsing_nodes[:elliman_nodes]
      elsif url.include?("halstead")
        broker_hash = @broker_parsing_nodes[:halstead_nodes]
      elsif url.include?("realtor")
        broker_hash = @broker_parsing_nodes[:realtor_nodes]
      elsif url.include?("nytimes")
        broker_hash = @broker_parsing_nodes[:nyt_nodes]
      elsif url.include?("century21")
        broker_hash = @broker_parsing_nodes[:century_21_nodes]
      else
        parsed_params = unknown_broker
      end

      if broker_hash.present?
        parsed_params = broker_parse(broker_hash)
      end

    else
      parsed_params = bad_url
    end
    @listing.update_attributes(parsed_params)
  end

  def self.broker_parse(broker_hash)
    description = get_description(broker_hash)
    price = get_price(broker_hash)
    address = get_address(broker_hash)
    date = Time.now
    date_listed = get_date_listed(broker_hash)
    open_house_date = get_open_house_date(broker_hash)

    parsed_params = {:listed_description => description, :listed_price => price, :address => address, :date_entered => date, :date_listed => date_listed, :open_house_date => open_house_date}

    return parsed_params
  end


  def self.get_description(broker_hash)
    if (broker_hash[:desc_node]).present?
      description = @doc.at_css(broker_hash[:desc_node])
    elsif (broker_hash[:desc_node_alt]).present?
      description = @doc.at_css(broker_hash[:desc_node_alt])
    end

    if description.present?
      description = description.text.strip
    else
      description = "Could not read link. Bad?"
    end
  end

  def self.get_price(broker_hash)
    if (broker_hash[:price_text_node]).present?
      price_text = @doc.at_css(broker_hash[:price_text_node])
    elsif
      price_text = @doc.css(broker_hash[:price_text_node_alt])
    end

    if price_text.present?
      price_text = price_text.text
      price = price_text.gsub(/[^\d\.]/, '')
    end
  end

  def self.get_address(broker_hash)
    if (broker_hash[:address_node]).present?
      address = @doc.at_css(broker_hash[:address_node])
    end

    if address.present?
      address = address.text
    else
      address = "Could not read link. Bad link?"
    end
  end

  def self.get_date_listed(broker_hash)
    if (broker_hash[:date_listed_string_node]).present?
      date_listed_array = @doc.css(broker_hash[:date_listed_string_node])
    end

    if date_listed_array.present?
      date_listed_string = date_listed_array.last.text
      date_listed = Chronic.parse(date_listed_string).to_date
    end
  end

  def self.get_open_house_date(broker_hash)
    if (broker_hash[:open_house_date_node]).present?
      open_house_date = @doc.at_css(broker_hash[:open_house_date_node])
    end
    open_house_date = open_house_date.text if open_house_date.present?
  end

  def self.bad_url
    note = @listing.notes.build(:note_text => "This appears to be a dead URL")
    address = "Listing is missing or bad URL"
    note.save
    parsed_params = {:address => address, :active_flag => false}
    return parsed_params
  end

  def self.unknown_broker
    description = "My robot brain is inadequate to divine in the information for this listing.  I probably don't recognize the broker and need to be taught how to read this type of listing."
    address = "Unfamiliar broker - see link for listing details"
    date = Time.now

    parsed_params = {:listed_description => description, :address => address, :date_entered => date}

    return parsed_params
  end

  def send_error_message
  end


end