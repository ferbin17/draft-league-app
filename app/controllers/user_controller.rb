class UserController < ApplicationController
  
  def dashboard
  end
  
  def login
    @user = User.new
    if request.post?
      @user = User.new(user_params)
      if @user.authenticate
        user = User.active.where("username = ?", @user.username).first
        session[:user_id] = user.id
        flash[:notice] = "Welcome #{user.username}" 
      else
        flash[:danger] = "Wrong Credentials"
      end
      redirect_to :root
    end
  end
  
  def signup
    @user = User.new
    if request.post?
      @user = User.new(user_params)
      if @user.save
        session[:user_id] = @user.id
        redirect_to :root
      end
    end
  end
  
  def logout
    reset_session
    redirect_to :root
  end
  
  private
    
    def user_params
      params.require(:user).permit(:username, :password, :confirm_password, :email_id, :phone_number, :full_name)
    end
    
    def reset_session
      session[:user_id] = nil
    end
end
