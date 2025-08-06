# frozen_string_literal: true


require 'rails_helper'

RSpec.describe AssignDeviceToUser do
  subject(:assign_device) do
    described_class.new(
      user: user,
      serial_number: serial_number
    ).call
  end

  let(:user) { create(:user) }
  let(:serial_number) { '123456' }

  before { create(:device, serial_number: serial_number) }

  context 'when user registers a device to self' do
    it 'assigns the device to the user' do
      assign_device
      expect(user.devices.pluck(:serial_number)).to include(serial_number)
    end
  end

  context 'when device is already assigned to another user' do
    let(:other_user) { create(:user) }

    before do
      device = Device.find_by(serial_number: serial_number)
      device.update!(owner: other_user)
    end

    it 'raises an error' do
      expect { assign_device }.to raise_error(StandardError, /already assigned to another user/)
    end
  end

  context 'when user returned device in the past' do
    before do
      device = Device.find_by(serial_number: serial_number)
      DeviceAssignmentHistory.create!(device: device, user: user, status: :returned)
    end

    it 'raises an error' do
      expect { assign_device }.to raise_error(StandardError, /previously returned/)
    end
  end
end