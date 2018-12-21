class TaskLog < ApplicationRecord
  belongs_to :account
  belongs_to :task

  def self.search(search)
    if search
      where('UPPER(name) LIKE ?', "%#{search.upcase}%")
    else
      nil
    end
  end
end
