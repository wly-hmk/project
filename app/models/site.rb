class Site < ApplicationRecord
  belongs_to :user
  validates_presence_of :title, :url
  validates :published, inclusion: { in: [ true, false ] }

  has_many :page
  has_many :element, :through => :page
end
