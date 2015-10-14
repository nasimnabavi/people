module Api
  class ApiController < ActionController::Base
    include ContextFreeRepos

    before_filter :authenticate_api!
    respond_to :json

    decent_configuration do
      strategy DecentExposure::StrongParametersStrategy
    end

    private

    def authenticate_api!
      unauthorized! unless params[:token] == AppConfig.api_token
    end

    def authenticate_admin!
      unauthorized!  unless current_user.try(:admin?)
    end

    def unauthorized!
      render(nothing: true, status: 403)
    end
  end
end
