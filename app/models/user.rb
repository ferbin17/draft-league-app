class User < ApplicationRecord
  attr_accessor :password, :confirm_password
  validates_presence_of :username, :phone_number, :password, :confirm_password
  validates :username, :email_id, :phone_number, uniqueness: { scope: :is_deleted, message: "already taken" , case_sensitive: true }
  validate :password_match, if: Proc.new{|user| user.password.present?}
  before_save :hash_password
  scope :active, -> { where(is_deleted: false) }
  
  def authenticate
    user = User.active.where("username = ?", self.username).first
    if user.present?
      return user.hashed_password == Digest::SHA1.hexdigest(user.password_salt.to_s + self.password)
    end
    return false
  end
    
  private
    def hash_password
      self.password_salt =  SecureRandom.base64(8) if self.password_salt == nil
      self.hashed_password = Digest::SHA1.hexdigest(self.password_salt + self.password) unless self.password.nil?
    end
    
    def password_match      
      if password != confirm_password
        errors.add(:password, "and Conformed password doesnt match")
        return false
      end
      if hashed_password == Digest::SHA1.hexdigest(password_salt.to_s + password)
        errors.add(:password, "must not be the last used one")
        return false
      end
      return true
    end
end
