class Person < ActiveRecord::Base
  attr_accessible :about, :favourite_music, :favourite_quotes, :favourite_websites, :name, :sub_headline, :photo
  
  validates_presence_of :about, :favourite_music, :favourite_quotes, :favourite_websites, :name, :sub_headline
  
  # photo uploading code
  after_save :store_photo
  
  # File.join is a cross-platform way of joining directories,
  # we could have written "#{Rails.root}/public/photo_store"
  PHOTO_STORE = File.join Rails.root, 'public', 'photo_store'
  
  # when photo data is assigned via the upload, store the file data
  # for later and assign the file extension, e.g. ".jpg"
  def photo=(file_data)
    unless file_data.blank?
      # store the uploaded data into a private instance variable
      @file_data = file_data
      # figure out the last part of the file name and use this as
      # the file extension. e.g. from "me.jpg" will return "jpg"
      self.extension = file_data.original_filename.split('.').last.downcase
    end
  end
  
  # if a photo file exists, then we have a photo
  def has_photo?
    File.exists? photo_filename
  end
  
  # return a path we can use in HTML for the image
  def photo_path
    "/photo_store/#{id}.#{extension}"
  end
  
  # where to write the image file to
  def photo_filename
    File.join PHOTO_STORE, "#{id}.#{extension}"
  end
   
  private
  
  # called after saving, to write the uploaded image to the filesystem
  def store_photo
    if @file_data
      # make the photo_store directory if it doesn't exist already
      FileUtils.mkdir_p PHOTO_STORE
      # write out the image data to the file
      File.open(photo_filename, 'wb') do |f|
        f.write(@file_data.read)
      end
      # avoid repeat-saving
      @file_data = nil
    end
  end
end
