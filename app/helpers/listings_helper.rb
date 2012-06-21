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
      on_the_spot_edit @listing, :open_house_date
    else
      on_the_spot_edit @listing, :open_house_date
    end
  end

  def google_map_helper
    google_map_link = "http://maps.google.com/maps?q=#{@listing.address}"
  end

  def date_entered_formatted(listing)
    if listing.date_entered.present?
      date_listed = listing.date_entered.to_formatted_s(:long)
    end
  end

  def days_since_updated
    if @listing.date_entered.present?
      number_days_since_updated = "(#{time_ago_in_words(@listing.updated_at, Time.now)} ago.)"
    else
      number_days_since_updated = ""
    end
  end

  def show_notes_index(listing)
    if listing.notes.present?
      truncate(listing.notes.last.note_text, :length =>100, :separator => ' ')
    else
      return
    end
  end

  def add_note_from_index (listing)
    semantic_form_for listing do |f|
      f.inputs do
        link_to_add_association 'New', f, :notes, :partial => 'short_note_fields'
      end
    end
  end


  def show_notes_full
    if @listing.notes.present?
      truncate(@listing.notes.last.note_text, :length =>500, :separator => ' ')
    else
      return
    end
  end

  def show_photo_if_exist
    if @listing.photos.present?
      photo_url = @listing.photos.last.photo_url
      return_html = "<a href='#{@listing.url}' target='_blank'><img src='#{photo_url}' ></a>"
      return return_html
    else
      return
    end
  end

  def show_photo_link_if_exist(listing)
    if listing.photos.present?
      photo_url = listing.photos.last.photo_url
      return_html = "<a href='#{listing.url}' class='screenshot' rel='#{photo_url}' target='_blank'> pic </a>"
      return return_html
    else
      return
    end
  end

end
