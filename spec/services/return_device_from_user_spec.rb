# frozen_string_literal: true

require 'rails_helper'

module ReturnError
  class Unauthorized < StandardError; end
  class NotFound < StandardError; end
end

RSpec.describe ReturnDeviceFromUser do
  let(:user) { create(:user) }
  let(:serial_number) { '123456' }

  before do
    create(:device, serial_number: serial_number, owner: user)
  end

  subject(:return_device) do
    described_class.new(user: user, serial_number: serial_number).call
  end

  context 'when user owns the device' do
    it 'removes the device ownership' do
      return_device
      device = Device.find_by(serial_number: serial_number)

      expect(device.owner).to be_nil
    end

    it 'logs the return in assignment history' do
      expect {
        return_device
      }.to change { DeviceAssignmentHistory.where(user: user, device: Device.find_by(serial_number: serial_number), status: :returned).count }.by(1)
    end
  end

  context 'when user tries to return a device they do not own' do
    let(:other_user) { create(:user) }

    subject(:unauthorized_return) do
      described_class.new(user: other_user, serial_number: serial_number).call
    end

    it 'raises an unauthorized error' do
      expect {
        unauthorized_return
      }.to raise_error(ReturnError::Unauthorized)
    end
  end

  context 'when the device does not exist' do
    let(:invalid_serial) { 'invalid-serial' }

    subject(:missing_device_return) do
      described_class.new(user: user, serial_number: invalid_serial).call
    end

    it 'raises a not found error' do
      expect {
        missing_device_return
      }.to raise_error(ReturnError::NotFound)
    end
  end
end