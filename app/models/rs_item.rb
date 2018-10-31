class RsItem < ApplicationRecord
  has_many :tasks

  def formated_name
    return "#{itemName}, #{itemId}"
  end
end
