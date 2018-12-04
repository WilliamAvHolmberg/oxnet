class AddProxyToAccount < ActiveRecord::Migration[5.2]
  def change
    add_reference :accounts, :proxy, foreign_key: true
  end
end
