class MuleLog < ApplicationRecord
  belongs_to :account
  after_initialize :custom_init


  def custom_init
    if self.new_record? && account != nil
      update_account
    end
  end

  def update_account
    money_made = account.money_made
    if money_made == nil
      money_made = item_amount
    else
      money_made = money_made + item_amount
    end
    account.update(money_made: money_made)
    # account.save
  end

end
