class ChangeDefaultValueOfXeroConnected < ActiveRecord::Migration[7.0]
  def change
    change_column_default :users, :xero_connected, from: nil, to: false
  end
end
