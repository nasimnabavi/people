module Api
  module V2
    class ProjectStatisticsSerializer < ActiveModel::Serializer
      attributes :id, :name, :url

      def url
        "/projects/#{object.id}"
      end
    end
  end
end
