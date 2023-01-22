class Post < ApplicationRecord
    validates :content,{presence:true}
    validates :content,{length:{maximum:140}}

    validates :user_id,{presence: true}

    has_many :likes, dependent: :destroy
    belongs_to :user

    def likes_count
      return Like.where(post_id: self.id).count
    end
end
