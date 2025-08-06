class User < ApplicationRecord
  has_many :api_keys, as: :bearer
  has_secure_password

  has_many :devices, foreign_key: 'owner_id', dependent: :nullify
  has_many :assignment_histories, class_name: 'DeviceAssignmentHistory', dependent: :destroy
end
