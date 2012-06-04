require 'spec_helper'
require_relative '../../app/models/user'

module LunchZone
  describe 'user' do
    let(:user)        { User.create(:nickname => 'hungryguy',
                                   :email => 'a@example.com') }
    let(:restaurant1) { Restaurant.create(:name => 'QQ Sushi') }
    let(:restaurant2) { Restaurant.create(:name => 'Academic') }

    it 'has restaurants via cravings' do
      user.new_craving(restaurant1)
      user.new_craving(restaurant2)

      user.restaurants.all.should == [restaurant1, restaurant2]
    end
  end
end
