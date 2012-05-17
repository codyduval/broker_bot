module ListingsHelper

  def days_since_listed
    if @listing.date_listed
      number_days_since_listed = distance_of_time_in_words_to_now(@listing.date_listed, include_seconds = false)
    else
      number_days_since_listed = "Unknown"
    end
  end

  def open_house_helper
    if @listing.open_house_date.present?
      @listing.open_house_date
    else
      open_house_date = "Unknown"
    end
  end

  def google_map_helper
    google_map_link = "http://maps.google.com/maps?q=#{@listing.address}"
  end

  def date_entered_formatted(listing)
    if listing.date_entered.present?
      date_listed = listing.date_entered.to_formatted_s(:long)
    else
      date_listed = ""
    end
  end

  def days_since_updated
    if @listing.date_entered.present?
      number_days_since_updated = "(#{time_ago_in_words(@listing.updated_at, Time.now)} ago.)"
    else
      number_days_since_updated = ""
    end
  end



end
