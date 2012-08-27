class AddRotationStatusToUser < ActiveRecord::Migration
  def change
    add_column :users, :rotation_status, :integer, :default => 1
  end
end
