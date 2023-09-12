class InvoicesController < ApplicationController
  include ApplicationHelper
  include InvoicesHelper
  require 'xero-ruby'
  
  before_action :authenticate_user!
  before_action :xero_client
  
  def index
    # TODO if last pull from xero was more than 24 hours ago, pull again
    # if current_user.last_pull_from_xero > 24.hours.ago
    # else

    puts current_user.inspect

    @invoices = Invoice.where(user_id: current_user.id)
  end

  def connect
    redirect_to @xero_client.authorization_url, allow_other_host: true
  end

  def pull_from_xero
  
    if token_expired()
      @token_set = @xero_client.refresh_token_set(current_user.token_set)
    else
      puts "token not expired"
      @xero_client.set_token_set(current_user.token_set)
      @token_set = current_user.token_set
    end

    current_user.token_set = @token_set
    current_user.active_tenant_id = latest_connection(@xero_client.connections)
    current_user.save!

    xero_invoices = @xero_client.accounting_api.get_invoices(current_user.active_tenant_id).invoices
    invoice_db_records = xero_invoices_to_db(xero_invoices)

    Invoice.upsert_all(invoice_db_records, unique_by: :xero_invoice_id)

    redirect_to "/"

  end


  def connect_callback
    if params['code']
      @token_set = @xero_client.get_token_set_from_callback(params)
      # you can use `@xero_client.connections` to fetch info about which orgs
      # the user has authorized and the most recently connected tenant_id

      puts "@token_set = @xero_client.get_token_set_from_callback(params) #{@token_set}"

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
