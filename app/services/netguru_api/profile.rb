module NetguruApi::Profile
  class << self
    def fetch_users_with_skills
      HTTParty.get(url, query: { token: token }, cookies: { staging_auth: profile_staging_auth })
    end

    private

    def url
      "#{AppConfig.profile_api_url}/skills"
    end

    def token
      AppConfig.profile_api_token
    end

    def profile_staging_auth
      Rails.env.staging? ? AppConfig.profile_staging_auth : ''
    end
  end
end
