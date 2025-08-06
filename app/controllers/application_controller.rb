class ApplicationController < ActionController::API
  before_action :set_current_user

  private

  def authenticate_user!
    render json: { error: "Unauthorized" }, status: :unauthorized unless @current_user
  end

  def set_current_user
    # Expecting Authorization header in the format: "Bearer TOKEN"
    auth_header = request.headers['Authorization']
    token = auth_header&.split(' ')&.last
    return unless token

    api_key = ApiKey.find_by(token: token)
    @current_user = api_key&.bearer
  end
end