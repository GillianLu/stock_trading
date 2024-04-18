class ApplicationController < ActionController::Base
    before_action :authenticate_user!
    before_action :set_client

    #raise error when access denied
    rescue_from CanCan::AccessDenied do |exception|
        flash[:error] = "You are not authorized to access this page."
        redirect_to root_url
    end
    
    private
    
    #memoization
    def set_client
        @client ||= IEX::Api::Client.new
    end
end
