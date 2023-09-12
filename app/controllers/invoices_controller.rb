class InvoicesController < ApplicationController
  include ApplicationHelper
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
    @invoices = @xero_client.accounting_api.get_invoices(tenant_id).invoices
  end

end
