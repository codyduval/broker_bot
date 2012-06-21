class Photo < ActiveRecord::Base
  attr_accessible :photo_url, :photo_attributes
  belongs_to :listing
end
