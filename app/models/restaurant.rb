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

    def users_on_date(date)
      User.all(User.cravings.date => date)
    end
  end
end
