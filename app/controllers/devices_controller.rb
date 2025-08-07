# frozen_string_literal: true

class DevicesController < ApplicationController
  before_action :authenticate_user!, only: %i[assign unassign]

  def assign
  new_owner_id = params[:new_owner_id].to_i

  if new_owner_id != @current_user.id
    render json: { error: 'Unauthorized' }, status: :unprocessable_entity
    return
  end

  serial_number = params[:serial_number]
  AssignDeviceToUser.new(
    user: @current_user,
    serial_number: serial_number
  ).call

  head :ok
rescue StandardError => e
  render json: { error: e.message }, status: :unprocessable_entity
end

  def unassign
    # TODO: implement the unassign action
  end

  private

  def authenticate_user!
    token = request.headers['Authorization']&.split(' ')&.last
    api_key = ApiKey.find_by(token: token)
    if api_key
      @current_user = api_key.bearer
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  def device_params
    params.permit(:new_owner_id, device: [:serial_number])
  end
end