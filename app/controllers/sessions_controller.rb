class SessionsController < ApplicationController
def create
  user = User.find_by(email: params[:email])

  if user&.authenticate(params[:password])
    token = SecureRandom.hex(16)
    begin
      api_key = user.api_keys.create!(token: token)
      Rails.logger.info("API key created: #{api_key.token}")
      render json: { token: token, user: user.email }, status: :ok
    rescue => e
      Rails.logger.error("Failed to create API key: #{e.message}")
      render json: { error: "Failed to create token" }, status: :internal_server_error
    end
  else
    render json: { error: "Invalid email or password" }, status: :unauthorized
  end
end

  def destroy
    token = request.headers['Authorization']&.split(' ')&.last
    api_key = ApiKey.find_by(token: token)

    if api_key&.destroy
      render json: { message: 'Logged out successfully' }, status: :ok
    else
      render json: { error: 'Invalid token' }, status: :unauthorized
    end
  end
end