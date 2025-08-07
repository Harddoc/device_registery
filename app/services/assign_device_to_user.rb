# frozen_string_literal: true

class AssignDeviceToUser
  def initialize(user:, serial_number:)
    @user = user
    @serial_number = serial_number
  end

  def call
    device = Device.find_by(serial_number: @serial_number)
    raise ActiveRecord::RecordNotFound, "Device not found" unless device

    # Check if device is assigned to someone else
    if device.assigned? && device.owner != @user
      raise AssigningError::AlreadyUsedOnOtherUser, "Device is already assigned to another user"
    end

    # Check if user returned this device before
    if DeviceAssignmentHistory.where(device: device, user: @user, status: :returned).exists?
      raise AssigningError::AlreadyUsedOnUser, "You cannot re-assign a device you previously returned"
    end

    # Assign device
    device.owner = @user

    ActiveRecord::Base.transaction do
      device.save!

      DeviceAssignmentHistory.create!(
        device: device,
        user: @user,
        status: :assigned
      )
    end

    device
  end
end
