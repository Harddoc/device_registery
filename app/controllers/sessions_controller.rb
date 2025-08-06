class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      # Example: simple token, not secure for production
      token = SecureRandom.hex(16)
      user.api_keys.create!(token: token) # assuming you have api_keys set up

      render json: { token: token, user: user.email }, status: :ok
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end
end