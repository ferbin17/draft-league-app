class ApplicationController < ActionController::Base
  before_action :login_required, except: [:login, :signup]
  
  private
    def login_required
      unless session[:user_id].present?
        redirect_to :login_user_index
      else
        @current_user ||= User.find_by_id(session[:user_id])
      end
    end
end
