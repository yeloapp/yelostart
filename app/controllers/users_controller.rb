class UsersController < ApplicationController

  before_action :skip_first_page, :only => :register
  
  # GET /register
  def register
    @user = User.new
  end
  
  # POST /users 
  def create
    @user = User.find_by(email: params[:user][:email])
    if(@user.blank?)
      return redirect_to root_url unless ip_ok
      @user = User.new(user_params)
      @user.total_points = 1
      error = true unless @user.save
      referral_register
    end
    respond_to do |format|
      if(error)
        format.html { render :register }
      else
        cookies[:u_email] = { :value => @user.email }
        format.html { redirect_to welcome_path, notice: 'Great!' }
      end
    end
  end

  def ip_ok
    ip = IpAddress.where(address: request.remote_ip).first_or_create
    if((ip.count > 100))
      return false
    else
     ip.count = (ip.count += 1)
     ip.save
     return true
    end
  end

  def referral_register
  	if(cookies[:u_share_token])
  	  @referred_user = User.find_by(share_token: cookies[:u_share_token])
  	  return unless @referred_user.present?
  	  @referral = @referred_user.referrals.create(referral_id: @user.id)
      @referred_user.total_referrals =  (@referred_user.total_referrals += 1)
      @referred_user.total_points =  (@referred_user.total_points += 10)
      @referred_user.save
  	end
  end

  # GET /welcome
  def welcome
    email = cookies[:u_email]
    @user = User.find_by(email: email)
    respond_to do |format|
      if(@user.present?)
        @referrals = @user.referrals
        @referral_count = @referrals.count
        @point_count = @user.total_points
        all_users = User.all.order(total_points: :desc)
        @queue = all_users.index{ |u| u.id == @user.id }
        @queue += 1
        format.html
      else
        cookies.delete :u_email       
        format.html { redirect_to root_path, notice: 'Error' }
      end
    end
  end

  private
  
  def user_params
    params.require(:user).permit(:email)
  end

  def skip_first_page
      email = cookies[:u_email]
      if email and !User.find_by(email: email).nil?
          redirect_to welcome_path()
      else
          cookies.delete :u_email
      end
    end
end
