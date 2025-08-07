class AddOwnerToDevices < ActiveRecord::Migration[7.1]
  def change
   add_reference :devices, :owner, foreign_key: { to_table: :users }, index: true, null: true
  end
end
