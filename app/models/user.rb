class User < ApplicationRecord
 validates :name,{presence:true}

 validates :email,{presence:true , uniqueness:true}

 VALID_PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?[\d])[a-z\d]+\z/i.freeze
 validates :password, { presence:true, allow_nil:true,
                      length: { minimum: 8, allow_blank:true }, 
                      format: { with: VALID_PASSWORD_REGEX}, allow_blank:true  }

 has_secure_password
 has_many :posts, dependent: :destroy
 has_many :likes, dependent: :destroy
end
