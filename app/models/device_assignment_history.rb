class DeviceAssignmentHistory < ApplicationRecord
  belongs_to :device
  belongs_to :user

  enum status: {assigned: 0, returned: 1}
end
