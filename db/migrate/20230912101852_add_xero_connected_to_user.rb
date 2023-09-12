class AddXeroConnectedToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :xero_connected, :boolean
  end
end
