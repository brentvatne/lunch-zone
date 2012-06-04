require_relative 'user'
require_relative 'restaurant'
require_relative "../../config/data_mapper"

module LunchZone
  class Craving
    include DataMapper::Resource

    property   :id,   Serial
    property   :date, Date

    belongs_to :user
    belongs_to :restaurant

    def public_attributes
      attributes
    end

    def to_json
      public_attributes.to_json
    end
  end
end
