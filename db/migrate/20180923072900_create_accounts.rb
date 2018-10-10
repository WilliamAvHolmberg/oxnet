class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.string :login
      t.string :password

      t.timestamps
    end
    create_table :proxies do |t|
      t.belongs_to :account, index: true;
      t.string :location
      t.string :ip
      t.string :username
      t.string :password


      t.timestamps
    end
  end
end
