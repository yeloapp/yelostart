class CreateReferrals < ActiveRecord::Migration
  def change
    create_table :referrals do |t|
      t.string :user_id
      t.string :referral_id

      t.timestamps
    end
  end
end
