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
  
  def set_base64_image(photo_data, photo_name)
    if photo_data && photo_name && photo_data != "" && photo_name != ""
      scheme, base64_data = photo_data.split(",")
      # scheme = "data:image/png;base64," なはず
      /:([^;]+);/ =~ scheme
      mime = $1
      # デコード
      sio = StringIO.new(Base64.decode64(base64_data))
      file = Paperclip.io_adapters.for(sio)
      file.original_filename = photo_name
      file.content_type = mime
      self.photo = file
    end
  end
  
end
