require 'rails_helper'

RSpec.describe DeviceAssignmentHistory, type: :model do
  it 'has a valid factory' do
    user = create(:user)
    device = create(:device)
    history = DeviceAssignmentHistory.new(device: device, user: user)
    expect(history).to be_valid
  end
end