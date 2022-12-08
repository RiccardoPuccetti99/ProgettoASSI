class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  has_many :guide, dependent: :delete_all 
  has_many :review  
  
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


    

end
