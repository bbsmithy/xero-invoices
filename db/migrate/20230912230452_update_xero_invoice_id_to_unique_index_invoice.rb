class UpdateXeroInvoiceIdToUniqueIndexInvoice < ActiveRecord::Migration[7.0]
  def change
    add_index :invoices, :xero_invoice_id, unique: true
  end
end
