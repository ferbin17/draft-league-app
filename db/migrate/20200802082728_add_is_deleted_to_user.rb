class AddIsDeletedToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :is_deleted, :boolean, default: false
  end
end
