class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, 
         :lockable, :timeoutable, :trackable # :omniauthable, omniauth_providers:[:twitter]
 validates :name,{presence:true}

 #VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
 validates :email, presence: true,
                   uniqueness: { case_sensitive: false },
 #                  format: { with: VALID_EMAIL_REGEX },
                   length: { maximum: 255 }

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

 has_many :active_relationships, class_name:  "Relationship",
                                 foreign_key: "follower_id",
                                 dependent:   :destroy
 has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
 has_many :following, through: :active_relationships, source: :followed
 has_many :followers, through: :passive_relationships, source: :follower

 # ユーザーをフォローする
 def follow(other_user)
   following << other_user
 end

 # ユーザーをフォロー解除する
 def unfollow(other_user)
   active_relationships.find_by(followed_id: other_user.id).destroy
 end

 # 現在のユーザーがフォローしてたらtrueを返す
 def following?(other_user)
   following.include?(other_user)
 end

 def current_user?(current_user)
   self == current_user
 end

end

