class CreateDeviceAssignmentHistories < ActiveRecord::Migration[7.1]
  def change
    create_table :device_assignment_histories do |t|
      t.references :device, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
