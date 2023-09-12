class InvoicesController < ApplicationController
  include ApplicationHelper
  include InvoicesHelper
  require 'xero-ruby'
  
  before_action :authenticate_user!
  before_action :xero_client
  
  def index
    @invoices = Invoice.all
  end

  def connect
    redirect_to @xero_client.authorization_url, allow_other_host: true
  end

  def connect_callback
    @xero_client.get_token_set_from_callback(params)
    tenant_id = @xero_client.connections.last['tenantId']
    User.update(current_user.id, xero_connected: true).save

    puts "tenant_id #{tenant_id}"

    xero_invoices = @xero_client.accounting_api.get_invoices(tenant_id).invoices

    invoice_db_records = xero_invoices_to_db(xero_invoices)

    for invoice in invoice_db_records do
      puts "-----------------------------------------"
      puts "invoice #{invoice}"
    end

    Invoice.create(invoice_db_records)

    @invoices = invoice_db_records

    render "index"

  end

end
