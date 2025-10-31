class Post < ApplicationRecord
  belongs_to :author, class_name: "User"

  has_many :likes, dependent: :destroy
  has_many :users_who_liked, through: :likes, source: :user
  
  validates :body, presence: true
end
