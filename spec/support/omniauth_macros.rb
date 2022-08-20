module OmniauthMacros
  def github_mock
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
      provider: 'github',
      uid: '123456',
      info: {
        nickname: 'mockuser',
        email: 'mockuser@github.com'
      }
    )
  end

  def vkontakte_mock
    OmniAuth.config.mock_auth[:vkontakte] = OmniAuth::AuthHash.new(
      provider: 'vkontakte',
      uid: '777777',
      info: { email: nil }
    )
  end
end