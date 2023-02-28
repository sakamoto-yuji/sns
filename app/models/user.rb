class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, 
         :lockable, :timeoutable, :trackable # :omniauthable, omniauth_providers:[:twitter]
 validates :name,{presence:true}

 validates :email,{presence:true , uniqueness:true}

 VALID_PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?[\d])[a-z\d]+\z/i.freeze
 with_options on: create do |create|
 validates :password,{presence:true, allow_nil:true } 
 validates :password,{length: { minimum: 8, allow_blank:true }, 
                      format: { with: VALID_PASSWORD_REGEX}, allow_blank:true  }
 end

# with_options on: registration_update do
# validates :password,{presence:true, }
# validates :password,{length: { minimum: 8, allow_blank:true },
#                      format: { with: VALID_PASSWORD_REGEX}, allow_blank:true  }
# end
                     

 has_many :posts, dependent: :destroy
 has_many :likes, dependent: :destroy
end
