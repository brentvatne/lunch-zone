require_relative "user"
require_relative "craving"
require_relative "../../config/data_mapper"

module LunchZone
  class Restaurant
    include DataMapper::Resource

    property :id,   Serial
    property :name, String, :unique => true

    has n, :cravings
    has n, :users, :through => :cravings

    # Unfortunately left outer joins are not supported by
    # DataMapper so we need to do tons of queries here
    def self.all_for_date(date)
      Restaurant.all.map do |restaurant|
        { :restaurant => restaurant,
          :users      => restaurant.users_on_date(date) }
      end
    end

    def users_on_date(date)
      users.all(User.cravings.date => date)
    end

    def public_attributes
      attributes
    end

    def to_json
      public_attributes.to_json
    end
  end
end
