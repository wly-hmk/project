class Element < ApplicationRecord
  belongs_to :page

  validates :element, :content, presence: true
  validates :order, numericality: { only_integer: true }
  validate :element_attributes_is_json

  def attributes_hash
    if element_attributes && !element_attributes.empty?
      JSON.parse element_attributes
    else
      []
    end
  end

private
  def element_attributes_is_json
    begin
      unless element_attributes.empty?
        JSON.parse(self.element_attributes)
      end
    rescue
      errors[:base] << "Element Attributes is not valid JSON"
    end
  end
end
