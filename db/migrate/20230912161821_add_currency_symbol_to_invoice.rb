class AddCurrencySymbolToInvoice < ActiveRecord::Migration[7.0]
  def change
    add_column :invoices, :currency_symbol, :string
  end
end
