class Note < ActiveRecord::Base
  attr_accessible :note_text, :note_author, :note_attributes
  belongs_to :listing
end
