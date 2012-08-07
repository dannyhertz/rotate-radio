class Provider < ActiveRecord::Base

  attr_accessible :uid, :service, :url, :username, :token, :secret

  belongs_to :user

  scope :for_service, lambda { |provider| where(:service => provider) }
  
end