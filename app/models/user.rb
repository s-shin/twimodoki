# encoding: utf-8

class User < ActiveRecord::Base
  attr_accessible :email, :name, :another_name, :private, :password, :password_confirmation

  has_secure_password
  paginates_per 10
  
  #---------------------------------
  # Validations
  #---------------------------------
  
  validates :another_name, presence: true,
    length: {
      minimum: 4,
      maximum: 20
    },
    format: {
      # TODO: 本当にこれでいいのか確認する
      # http://blog.goo.ne.jp/j_adversaria/e/474436565cd3d53d4ca4de22f594948b
      with: /^([a-zA-Z0-9_-]|[^ -~｡-ﾟ])+$/
    }
  validates :name, presence: true, uniqueness: true,
    length: {
      minimum: 4,
      maximum: 20
    },
    format: {
      with: /^[a-zA-Z0-9_-]+$/
    }
  validates :password, presence: true,
    length: {
      # NOTE: 仕様ではこうだが、現実的には…
      minimum: 4,
      maximum: 8
    },
    format: {
      with: /^[a-zA-Z0-9]+$/
    }
  validates :password_confirmation, presence: true
  validates :email, presence: true, email: true,
    length: { maximum: 100 }
  
  # password_digestのエラーは非表示
  after_validation :hide_password_digest, on: :create
  def hide_password_digest
    self.errors.messages.delete(:password_digest)
  end
  
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
