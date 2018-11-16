class InventoryItem < ApplicationRecord
  belongs_to :inventory, optional:true
  belongs_to :item, :class_name => "RsItem"
end
