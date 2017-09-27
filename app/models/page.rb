class Page < ApplicationRecord
  belongs_to :site
  validates :name, :slug, presence: true
  validates :slug, uniqueness: {scope: :site_id}
  validates :order, numericality: { only_integer: true }

  has_many :element, :dependent => :delete_all
end
