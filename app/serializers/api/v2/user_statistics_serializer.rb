module Api
  module V2
    class UserStatisticsSerializer < ActiveModel::Serializer
      attributes :id, :name, :url

      def name
        "#{object.last_name} #{object.first_name}"
      end

      def url
        "/users/#{object.id}"
      end
    end
  end
end
