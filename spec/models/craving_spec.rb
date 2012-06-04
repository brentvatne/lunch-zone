require 'spec_helper'
require_relative '../../app/models/craving'

module LunchZone
  describe 'craving' do
    let(:date)       { Date.today }
    let(:craving)    { Craving.create(:date => date) }
    let(:user)       { User.create(:nickname => 'hungryguy',
                                   :email => 'a@example.com') }
    let(:restaurant) { Restaurant.create(:name => 'QQ Sushi') }

    it 'belongs to a user' do
      craving.user = user
      craving.save
      craving.reload

      craving.user.should == user
    end

    it 'is for a restaurant' do
      craving.restaurant = restaurant
      craving.save
      craving.reload

      craving.restaurant.should == restaurant
    end

    it 'is for a particular day only' do
      craving.date.should == date
    end
  end
end
