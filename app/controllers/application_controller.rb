class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :ref_to_cookie

    def mobile_device?
        if session[:mobile_param]
            session[:mobile_param] == "1"
        else
            request.user_agent =~ /Mobile|webOS/
        end
    end

    protected
    def ref_to_cookie
        if params[:share_token] 
            if User.find_by(share_token: params[:share_token]).present?
                cookies[:u_share_token] = { :value => params[:share_token], :expires => 1.week.from_now }
            end

            if request.env["HTTP_USER_AGENT"] and !request.env["HTTP_USER_AGENT"].include?("facebookexternalhit/1.1")
                redirect_to proc { url_for(params.except(:share_token)) }  
            end
        end
    end
end
