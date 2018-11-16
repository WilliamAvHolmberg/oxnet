class RsItem < ApplicationRecord
  has_many :tasks
  has_many :gears
  has_many :inventory_items

  def formated_name
    return "#{itemName},#{itemId}"
  end
end
