require 'spec_helper'
require_relative '../../app/models/restaurant'

module LunchZone
  describe 'user' do
    let(:today)      { Date.today }
    let(:yesterday)  { Date.today - (1 * 60 * 60 * 24) }
    let(:user1)      { User.create(:nickname => 'joe',
                                   :email => 'a@example.com') }

    let(:user2)      { User.create(:nickname => 'hungryguy',
                                   :email => 'b@example.com') }

    let(:restaurant) { Restaurant.create(:name => 'QQ Sushi') }

    before do
      user1.new_craving(restaurant, today)
      user2.new_craving(restaurant, today)

      user1.new_craving(restaurant, yesterday)
    end

    it 'has users via cravings, for a particular day' do
      restaurant.users_on_date(today).should == [user1, user2]
      restaurant.users_on_date(yesterday).should == [user1]
    end
  end
end
