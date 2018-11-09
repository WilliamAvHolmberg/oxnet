class MuleWithdrawTask < ApplicationRecord
  belongs_to :area
  belongs_to :task_type
  belongs_to :account
end
