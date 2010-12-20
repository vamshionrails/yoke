class Thumbnail < ActiveRecord::Base

  has_one :video

  has_attached_file :source,
   :url => "/assets/videos/:id/:style/:basename.:extension",
   :path => ":rails_root/public/assets/videos/:id/:style/:basename.:extension"


  def self.create!(vpath)
      tpath =  vpath + ".jpg"
      system "ffmpeg -i #{vpath} -ss 20 -s 150x100 -vframes 1 -f image2 -an #{tpath}"
      t = Thumbnail.new(:filename => File.basename(tpath), :content_type => 'image/jpeg')
      t.save ? t : false
  end
end

