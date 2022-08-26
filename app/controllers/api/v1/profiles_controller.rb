class Api::V1::ProfilesController < Api::V1::BaseController
  authorize_resource class: User

  skip_before_action :authenticate_user!
  skip_authorization_check

  def me
    render json: current_resource_owner
  end

  def index
    render json: User.where.not(id: current_resource_owner)
  end
end