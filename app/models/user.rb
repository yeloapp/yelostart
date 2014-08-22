class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  before_save :ensure_share_token
  before_validation :ensure_password

 private

 def ensure_share_token
    if share_token.blank?
      self.auth_token = generate_share_token
    end
 end

 def ensure_password
    return if self.password.present?
    self.password = SecureRandom.random_number(8888888888)
  end

 private
    
    def generate_share_token
      loop do
        token = Devise.friendly_token
        break token unless User.where(share_token: token).first
      end
    end

end
