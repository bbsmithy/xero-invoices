module ApplicationHelper
    require 'jwt'

    def token_expired
        token_expiry = Time.at(access_token['exp'])
        puts "token_expiry #{token_expiry}"
        puts "Time.now #{Time.now}"    
        return token_expiry < Time.now
    end

    def id_token
        JWT.decode(current_user.token_set['id_token'], nil, false)[0] if current_user && current_user.token_set
    end

    def access_token
        JWT.decode(current_user.token_set['access_token'], nil, false)[0] if current_user && current_user.token_set
    end

    def xero_client
        
        @xero_client = XeroRuby::ApiClient.new(credentials: {
            client_id: '3C32F4B4DA3B46C3B56D2B4D8C574068',
            client_secret: 'GCB9SesCl4SK-csORBBTPrfnJVITR7_UB5f1kas9Pg3U4dAJ',
            redirect_uri: 'http://localhost:3000/xero/callback',
            scopes: 'openid profile email accounting.transactions offline_access'
        })

        return @xero_client
    end

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
