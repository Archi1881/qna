class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    oauth_authentication
  end

  def vkontakte
    oauth_authentication
  end

  def twitter
    oauth_authentication
  end

  private

  def auth
    request.env['omniauth.auth']
  end

  def oauth_authentication
    user = User.find_for_oauth(auth)

    if user&.confirmed?
      sign_in_and_redirect user, event: :authentication
      set_flash_message_for_action
    elsif user
      session[:provider] = auth.provider
      session[:uid] = auth.uid
      redirect_to new_user_confirmation_path
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end

  def set_flash_message_for_action
    set_flash_message(:notice, :success, kind: action_name) if is_navigational_format?
  end
end