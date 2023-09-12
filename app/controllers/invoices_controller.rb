class InvoicesController < ApplicationController
  include ApplicationHelper
  include InvoicesHelper
  require 'xero-ruby'
  
  before_action :authenticate_user!
  before_action :xero_client
  
  def index
    @invoices = Invoice.where(user_id: current_user.id)
  end

  def connect
    redirect_to @xero_client.authorization_url, allow_other_host: true
  end

  def connect_callback
    if params['code']
      @token_set = @xero_client.get_token_set_from_callback(params)
      # you can use `@xero_client.connections` to fetch info about which orgs
      # the user has authorized and the most recently connected tenant_id
      current_user.token_set = @token_set if !@token_set["error"]
      current_user.token_set['connections'] = @xero_client.connections
      current_user.active_tenant_id = latest_connection(current_user.token_set['connections'])
      current_user.xero_connected = true
      current_user.save!

      # fetch invoices for the connected org
      xero_invoices = @xero_client.accounting_api.get_invoices(current_user.active_tenant_id).invoices
      invoice_db_records = xero_invoices_to_db(xero_invoices)

      Invoice.create(invoice_db_records)
      redirect_to "/"

    else
      redirect_to "/"
      flash.notice = "Failed to received Xero Token Set"
    end
  
  end

end
