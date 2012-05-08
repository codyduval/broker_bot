module ListingsHelper

  def days_since_listed
    if @listing.date_listed
      number_days_since_listed = distance_of_time_in_words_to_now(@listing.date_listed, include_seconds = false)
    else
      number_days_since_listed = "Unknown"
    end
  end

end
