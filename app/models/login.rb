class Login < ActiveRecord::Base
  rolify
  
  has_many :managers
  has_many :neuropsychologists
  has_many :secretaries
  has_many :patients
  belongs_to :type
  has_many :administrators

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

    # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :type_id
end