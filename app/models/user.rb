# encoding: utf-8

class User < ActiveRecord::Base
  attr_accessible :email, :name, :another_name, :private, :password, :password_confirmation

  has_secure_password
  paginates_per 10
  
  #---------------------------------
  # Validations
  #---------------------------------
  
  validates :email, :name, :another_name, presence: true
  validates :name, uniqueness: true
  validates :name, length: {
    maximum: 15
  }
  validates :name, format: {
    with: /[a-z0-9_]+/
  }
  
  #---------------------------------
  # Relations
  #---------------------------------

  attr_accessible :followers, :friends, :tweets

  # friend (followee/following)
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships
  
  # follower
  has_many :followerships, class_name: "Friendship", foreign_key: :friend_id, dependent: :destroy
  has_many :followers, through: :followerships, source: :user
  
  # tweets
  has_many :tweets
  
end
