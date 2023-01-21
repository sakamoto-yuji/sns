class User < ApplicationRecord
 validates :name,{presence:true}

 validates :email,{presence:true}
 validates :email,{uniqueness:true}

 validates :password,{presence:true}
 valid_password = /\A(?=.*?[a-z])(?=.*?[\d])[a-z\d]+\z/i.freeze
 validates :password, format: { with:valid_password}

 has_many :posts, dependent: :destroy
 has_many :likes, dependent: :destroy
# def posts
#   return Post.where(user_id: self.id)
# end
end
