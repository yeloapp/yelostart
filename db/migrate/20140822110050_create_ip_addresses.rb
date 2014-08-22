class CreateIpAddresses < ActiveRecord::Migration
  def change
    create_table :ip_addresses do |t|
      t.integer :count, default: 0
      t.string :address

      t.timestamps
    end
  end
end
