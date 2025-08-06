# frozen_string_literal: true

class AssignDeviceToUser
  def initialize(requesting_user:, serial_number:, new_device_owner_id:)
    @requesting_user = requesting_user
    @serial_number = serial_number
    @new_device_owner_id = new_device_owner_id.to_i
  end

  def call
    unless @new_device_owner_id == @requesting_user.id
      raise StandardError.new("You can only assign devices to yourself")
    end

    device = Device.find_by(serial_number: @serial_number)
    raise ActiveRecord::RecordNotFound, "Device not found" unless device

    device.owner_id = @new_device_owner_id

    if device.save
      device
    else
      raise StandardError.new(device.errors.full_messages.join(", "))
    end
  end
end