class Page < ApplicationRecord
  belongs_to :site
  validates_presence_of :name, :slug, :order

  has_many :element, :dependent => :delete_all
end
