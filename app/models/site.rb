class Site < ApplicationRecord
  belongs_to :user
  validates :title, :url, presence: true
  validates :published, inclusion: { in: [ true, false ] }

  has_many :page, :dependent => :destroy
  has_many :element, :through => :page
end
