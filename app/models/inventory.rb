class Inventory < ApplicationRecord
  has_many :inventory_items, dependent: :destroy
  has_many :tasks, dependent: :destroy


  def get_parsed_message
    puts "in parsed mess"
    message = ""
    if inventory_items != nil && inventory_items.length >= 1
      puts "inventory items not null"
      puts inventory_items
      puts inventory_items.all
      self.inventory_items.each do |inventory_item|
        puts inventory_item.item.formated_name
        message << "#{inventory_item.item.formated_name},#{inventory_item.amount},#{inventory_item.buy_amount};"
      end
    end
    puts "out of parsed mess"
    return message
  end

  def to_json

    items = {}
    if inventory_items != nil && inventory_items.length >= 1
      inventory_items.each do |p|
        items[p.item.item_name] = { id: p.item.item_id, amount:p.amount, buy_amount: p.buy_amount}
      end
    end
    return items
  end
end
