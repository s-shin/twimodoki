class Tweet < ActiveRecord::Base
  attr_accessible :content, :user_id, :photo
  belongs_to :user
  has_attached_file :photo, {
    default_url: "assets/logo.png"
  }

  default_scope :order => 'created_at DESC'
  paginates_per 10
  
  validates :content, :user_id, presence: true
  validates :content, length: {
    maximum: 140
  }
  validates_attachment :photo, {
    content_type: {
      content_type: [
        "image/jpg", "image/jpeg", "image/pjpeg",
        "image/gif",
        "image/png", "image/x-png",
      ]
    },
    size: { in: 0..1.megabytes }
  }
end
