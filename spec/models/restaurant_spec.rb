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

    let!(:qq_sushi)  { Restaurant.create(:name => 'QQ Sushi') }
    let!(:memphis)   { Restaurant.create(:name => 'Memphis') }

    before do
      user1.new_craving(qq_sushi, today)
      user2.new_craving(qq_sushi, today)

      user1.new_craving(qq_sushi, yesterday)
      user1.new_craving(memphis, yesterday)
    end

    describe 'users_on_date' do
      it 'has users via cravings, for a particular day' do
        qq_sushi.users_on_date(today).should == [user1, user2]
        qq_sushi.users_on_date(yesterday).should == [user1]
      end

      it 'is specific to the restaurant' do
        memphis.users_on_date(today).should     == []
        memphis.users_on_date(yesterday).should == [user1]
      end
    end

    describe 'all_for_date' do
      let(:all_data)       { Restaurant.all_for_date(today) }
      let!(:qq_sushi_data) { all_data.first }
      let!(:memphis_data)  { all_data.last }

      it 'returns the restaurant and the people for each' do
        qq_sushi_data.should have_key(:restaurant)
        qq_sushi_data.should have_key(:users)
      end

      it 'includes users who crave it on the date' do
        first_craver = qq_sushi_data[:users].first
        first_craver.nickname.should == user1.nickname
      end

      it 'gets the correct number for each restaurant' do
        qq_sushi_data[:users].count.should == 2
        memphis_data[:users].count.should  == 0
      end
    end
  end
end
