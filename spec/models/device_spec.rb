require 'rails_helper'

RSpec.describe Device, type: :model do
  it 'is valid with valid attributes' do
    device = Device.new(serial_number: 'ABC123')
    expect(device).to be_valid
  end

  it 'is not assigned by default' do
    device = Device.new(serial_number: 'ABC123')
    expect(device.assigned?).to be false
  end
end