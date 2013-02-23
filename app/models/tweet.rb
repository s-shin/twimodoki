class Tweet < ActiveRecord::Base
  attr_accessible :content, :user_id
  belongs_to :user
  
  default_scope :order => 'created_at DESC'
  paginates_per 10
  
  validates :content, :user_id, presence: true
  validates :content, length: {
    maximum: 140
  }
end
