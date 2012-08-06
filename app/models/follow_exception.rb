class FollowException < ActiveRecord::Base

  attr_accessible :artist, :status

  belongs_to :user
  belongs_to :artist

end