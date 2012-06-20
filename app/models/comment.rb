class Comment < ActiveRecord::Base
  attr_accessible :body, :commentable_id, :commentable_type, :comments_attributes

  belongs_to :commentable, :polymorphic => true
  has_many :comments, :as => :commentable
end
