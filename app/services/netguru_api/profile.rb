module NetguruApi::Profile
  class << self
    def fetch_users_with_skills
      HTTParty.get(url, query: { token: token })
    end

    private

    def url
      base_url = AppConfig.profile_api_url.send(Rails.env)
      "#{base_url}/skills"
    end

    def token
      AppConfig.profile_api_token
    end
  end
end
