class RsItem < ApplicationRecord
  has_many :tasks
  has_many :gears
  has_many :inventory_items

  def self.search(search)
    if search
      where('UPPER(item_name) LIKE ?', "%#{search.upcase}%")
    else
      nil
    end
  end
  def formated_name
    return "#{item_name},#{item_id}"
  end

  @@cache = {}
  def self.find_quick(name, stackable)
    key = "#{name}:#{stackable}"
    return @@cache[key] if @@cache[key] != nil
    result = RsItem.where(item_name: name, stackable: stackable).first
    @@cache[key] = result
    return result
  end
end
