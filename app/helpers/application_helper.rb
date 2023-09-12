module ApplicationHelper
    # require 'jwt'

    # def token_expired
    #     # token_expiry = Time.at(access_token['exp'])
    #     # exp_text = time_ago_in_words(token_expiry)
    #     # puts "token_expiry #{token_expiry}"
    #     # puts "Time.now #{Time.now}"    
    #     # token_expiry > Time.now ? "in #{exp_text}" : "#{exp_text} ago" 
    #     xero_client.token_expired?
    # end

    # def id_token
    #     JWT.decode(current_user.token_set['id_token'], nil, false)[0] if current_user && current_user.token_set
    # end

    # def access_token
    #     JWT.decode(current_user.token_set['access_token'], nil, false)[0] if current_user && current_user.token_set
    # end

    # def current_user
    #     @current_user ||= User.find(session[:user_id]) if session[:user_id]
    # end

    def xero_client
        
        @xero_client = XeroRuby::ApiClient.new(credentials: {
            client_id: '3C32F4B4DA3B46C3B56D2B4D8C574068',
            client_secret: 'GCB9SesCl4SK-csORBBTPrfnJVITR7_UB5f1kas9Pg3U4dAJ',
            redirect_uri: 'http://localhost:3000/xero/callback',
            scopes: 'openid profile email accounting.transactions offline_access'
        })

        # if current_user&.token_set
        #     @xero_client.set_token_set(current_user.token_set)
        # end

        return @xero_client
    end

    # def has_token_set?
    #     unless current_user
    #         if current_user && current_user.token_set
    #         redirect_to authorization_url
    #         return
    #         else
    #         redirect_to '/users/new'
    #         return
    #         end
    #     end
    # end

    def authorization_url
        @authorization_url ||= xero_client.authorization_url 
    end

    def latest_connection(connections)
        if !connections.empty?
            connections.sort { |a,b|
            DateTime.parse(a['updatedDateUtc']) <=> DateTime.parse(b['updatedDateUtc'])
            }.first['tenantId']
        else
            nil
        end
    end

end
