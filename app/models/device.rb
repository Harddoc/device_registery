class Device < ApplicationRecord
  belongs_to :owner, class_name: 'User', optional: true

  has_many :assignment_histories, class_name: 'DeviceAssignmentHistory', dependent: :destroy

  def assigned?
    owner_id.present?
  end
end