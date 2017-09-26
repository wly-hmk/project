class Page < ApplicationRecord
  belongs_to :site
  validates :name, :slug, presence: true
  validates :order, numericality: { only_integer: true }

  has_many :element, :dependent => :delete_all
end
