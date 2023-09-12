class AddCurrencyCodeToInvoice < ActiveRecord::Migration[7.0]
  def change
    add_column :invoices, :currency_code, :string
  end
end
