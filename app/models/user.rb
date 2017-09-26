require 'securerandom'

class User < ApplicationRecord
  has_secure_password
  validates_presence_of :name, :email, :password
  before_create :create_token

  has_many :site
  has_many :page, :through => :site
  has_many :element, :through => :page

private
  def create_token
    self.api_token = SecureRandom.urlsafe_base64(nil, false)
  end

end
