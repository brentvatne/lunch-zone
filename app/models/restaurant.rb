require_relative "../../config/data_mapper"

module LunchZone
  class Restaurant
    include DataMapper::Resource

    property :id,   Serial
    property :name, String, :unique => true
  end
end
