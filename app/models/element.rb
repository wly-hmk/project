class Element < ApplicationRecord
  belongs_to :page

  validates_presence_of :element, :content, :order
  validate :element_attributes_is_json

private
  def element_attributes_is_json
    begin
      JSON.parse(self.element_attributes)
    rescue
      errors[:base] << "Element Attributes is not valid JSON"
    end
  end
end
