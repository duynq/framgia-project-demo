class Entry < ActiveRecord::Base
  belongs_to :user
  has_many :comments, dependent: :destroy
  
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  
  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 140 }
  validates :content, presence: true
  validate  :picture_size

  #Validates the size of an uploaded picture
	def picture_size
	  if picture.size > 5.megabytes
	    errors.add(:picture, "should be less than 5MB")
	  end
	end
end
