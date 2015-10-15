module Api
  module V2
    class ProjectSerializer < ActiveModel::Serializer
      attributes :id, :name, :url

      def url
        "/projects/#{object.id}"
      end
    end
  end
end
