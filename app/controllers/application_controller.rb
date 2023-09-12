class ApplicationController < ActionController::Base
    include ApplicationHelper
    require 'xero-ruby'
    # before_action :xero_client
end
