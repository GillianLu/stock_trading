class ApplicationController < ActionController::Base
    before_action :authenticate_user!
    before_action :set_client
    
    private
    
    #memoization
    def set_client
        @client ||= IEX::Api::Client.new
    end
end
