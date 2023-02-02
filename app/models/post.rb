class Post < ApplicationRecord

  #attachment :image

  belongs_to :user
  has_many :comments#, dependent: :destroy  #この行を追記


  validates :content, {presence: true, length: {maximum:140}}
  validates :user_id, {presence: true}

  def user
    return User.find_by(id: self.user_id)
  end
  
end
