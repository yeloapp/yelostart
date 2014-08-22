class UsersController < ApplicationController
  
  # GET /register
  def register
    
  end
  
  # POST /users 
  def create
    @user = User.find_by(email: params[:user][:email])
    if(@user.blank?)-
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
        format.html { redirect_to welcome_path, notice: 'Great!' }
      end
    end
  end

  def ip_ok
    ip = IpAddress.where(address: request.remote_ip).first_or_create
    if(ip.address.count > 3)
      return false
    else
     ip.count = (ip.count += 1)
     ip.save
     return true
    end
  end

  def referral_register
  	if(params[:share_token].present?)
  	  @referred_user = User.find_by(share_token: params[:share_token])
  	  return unless @referred_user.present?
  	  @referral = @referred_user.referrals.create(referral_id: @user.id)
      @referred_user.total_referrals =  (referred_user.total_referrals += 1)
      @referred_user.total_points =  (referred_user.total_referrals += 10)
      @referred_user.save
  	end
  end

  private
  
  def user_params
    params.require(:user_params).permit(:email)
  end

end
