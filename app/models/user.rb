class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:google_oauth2]
         
  has_many :guide, dependent: :destroy
  has_many :review, dependent: :destroy  

  #constraints
  validates :uid, :presence => true
  
  #canard
  acts_as_user :roles => [ :writer, :admin ]

  def is_writer?
    return (self.roles_mask & 1) == 1
  end

  def set_writer
    self.roles_mask = (self.roles_mask | 1)
    self.save
  end

  def is_admin?
    return (self.roles_mask & 2) == 2
  end

  def set_admin
    self.roles_mask = (self.roles_mask | 2)
    self.save
  end

  def unset_user
    self.roles_mask = 0
    self.save
  end

  #omniauth

  def self.from_omniauth(auth) 
		where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
			user.email = auth.info.email
			user.password = Devise.friendly_token[0,20]
		end
	end

  def self.new_with_session(params, session) 
		super.tap do |user|
			if data = session["devise.google_data"] && session["devise.google_data"]["extra"]["raw_info"]
				user.email = data["email"] if user.email.blank?
	      	end
    	end
	end


    

end
