class Post < ApplicationRecord
  belongs_to :author, class_name: "User"

  has_many :likes, dependent: :destroy
  has_many :users_who_liked, through: :likes, source: :user

  has_many :comments, dependent: :destroy
  
  validates :body, presence: true
end
