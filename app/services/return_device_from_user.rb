# frozen_string_literal: true

class ReturnDeviceFromUser
  def initialize(user:, serial_number:)
    @user = user
    @serial_number = serial_number
  end

  def call
    device = Device.find_by(serial_number: @serial_number)
    raise ReturnError::NotFound, "Device not found" unless device

    # Make sure device is assigned to this user
    if device.owner != @user
      raise ReturnError::Unauthorized, "You can only return a device you own"
    end

    ActiveRecord::Base.transaction do
      # Clear ownership
      device.update!(owner: nil)

      # Log return in history
      DeviceAssignmentHistory.create!(
        device: device,
        user: @user,
        status: :returned
      )
    end

    device
  end
end