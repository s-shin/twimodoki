class AddAttachmentPhotoToTweets < ActiveRecord::Migration
  def self.up
    change_table :tweets do |t|
      t.attachment :photo
    end
  end

  def self.down
    drop_attached_file :tweets, :photo
  end
end
