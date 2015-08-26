module NetguruApi::Profile
  class << self
    def fetch_users_with_skills
      HTTParty.get(url, query: { token: token })
    end

    private

    def url
      "#{AppConfig.profile_api_url}/skills"
    end

    def token
      AppConfig.profile_api_token
    end
  end
end
