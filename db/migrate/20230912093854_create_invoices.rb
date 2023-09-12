class CreateInvoices < ActiveRecord::Migration[7.0]
  def change
    create_table :invoices do |t|
      t.string :client
      t.string :xero_id
      t.integer :outstanding_amount
      t.integer :total_amount
      t.datetime :due_date

      t.timestamps
    end
  end
end
