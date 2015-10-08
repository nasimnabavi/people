require 'spec_helper'

describe GravatarDownloader do
  let(:user) { create(:user) }
  subject { described_class.new(user) }

  describe '#call' do
    it 'sets remote_gravatar_url field for user' do
      gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
      expected = "https://www.gravatar.com/avatar/#{gravatar_id}?size=100"
      subject.call
      expect(user.reload.remote_gravatar_url).to eql(expected)
    end
  end
end
