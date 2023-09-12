class AddXeroInvoiceNumberToInvoice < ActiveRecord::Migration[7.0]
  def change
    add_column :invoices, :xero_invoice_number, :string
  end
end
