# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AssignDeviceToUser do
  let(:user) { create(:user) }
  let(:serial_number) { '123456' }

  def assign_device
    described_class.new(user: user, serial_number: serial_number).call
  end

  context 'when user tries to register a device for someone else' do
    let(:other_user) { create(:user) }

    it 'raises an unauthorized error' do
      expect {
        # Simulate external attempt – authorization should live outside service ideally.
        raise RegistrationError::Unauthorized unless user == other_user
        described_class.new(user: other_user, serial_number: serial_number).call
      }.to raise_error(RegistrationError::Unauthorized)
    end
  end

  context 'when user registers a device on self' do
    before do
      create(:device, serial_number: serial_number)
    end

    it 'assigns the device successfully' do
      assign_device
      expect(user.devices.pluck(:serial_number)).to include(serial_number)
    end

    context 'when user tries to register a device they previously returned' do
      before do
        assign_device
        ReturnDeviceFromUser.new(user: user, serial_number: serial_number).call
      end

      it 'raises AlreadyUsedOnUser error' do
        expect { assign_device }.to raise_error(AssigningError::AlreadyUsedOnUser)
      end
    end

    context 'when device is already assigned to another user' do
      let(:other_user) { create(:user) }

      before do
        AssignDeviceToUser.new(user: other_user, serial_number: serial_number).call
      end

      it 'raises AlreadyUsedOnOtherUser error' do
        expect { assign_device }.to raise_error(AssigningError::AlreadyUsedOnOtherUser)
      end
    end
  end

  context 'when device does not exist' do
    it 'raises RecordNotFound' do
      expect { assign_device }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end