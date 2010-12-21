class Video < ActiveRecord::Base
  # Paperclip
before_save :save_thumbnail
  belongs_to :thumbnail
belongs_to :user
has_many :replies, :class_name => 'VideoReply'

  # http://www.thoughtbot.com/projects/paperclip
  has_attached_file :source,
   :url => "/assets/videos/:id/:style/:basename.:extension",
   :path => ":rails_root/public/assets/videos/:id/:style/:basename.:extension",
  :processors => [:video_thumbnail]


  def video?
    [ 'application/x-mp4',
      'video/mpeg',
      'video/quicktime',
      'video/x-la-asf',
      'video/x-ms-asf',
      'video/x-msvideo',
      'video/x-sgi-movie',
      'video/x-flv',
      'flv-application/octet-stream',
      'video/3gpp',
      'video/3gpp2',
      'video/3gpp-tt',
      'video/BMPEG',
      'video/BT656',
      'video/CelB',
      'video/DV',
      'video/H261',
      'video/H263',
      'video/H263-1998',
      'video/H263-2000',
      'video/H264',
      'video/JPEG',
      'video/MJ2',
      'video/MP1S',
      'video/MP2P',
      'video/MP2T',
      'video/mp4',
      'video/MP4V-ES',
      'video/MPV',
      'video/mpeg4',
      'video/mpeg4-generic',
      'video/nv',
      'video/parityfec',
      'video/pointer',
      'video/raw',
      'video/rtx' ].include?(asset.content_type)
  end

  # Paperclip Validations
  validates_attachment_presence :source
 # validates_attachment_content_type :source,
 # :content_type => ['video/x-msvideo','video/avi','video/quicktime',
 #                   'video/3gpp','video/x-ms-wmv','video/mp4','video/mpeg',
 #                   'application/x-flash-video']

  # Acts as State Machine
  # http://elitists.textdriven.com/svn/plugins/acts_as_state_machine
  acts_as_state_machine :initial => :pending
  state :pending
  state :converting
  state :converted, :enter => :set_new_filename
  state :error

  event :convert do
    transitions :from => :pending, :to => :converting
  end

  event :converted do
    transitions :from => :converting, :to => :converted
  end

  event :failure do
    transitions :from => :converting, :to => :error
  end

  # Conversion Methods
  def convert
    self.convert!
    success = system(convert_command)
    if success && $?.exitstatus == 0
      self.converted!
    else
      self.failure!
    end
  end
def save_thumbnail
logger.info "Saving thumbnail of Video..."
t = Thumbnail.create!("/public/")
self.thumbnail = t
t
  end


  protected

  def convert_command
    flv = File.join(File.dirname(source.path), "#{id}.flv")
    File.open(flv, 'w')

    command = <<-end_command
      ffmpeg -i #{ source.path }  -ar 22050 -ab 32 -acodec mp3
      -s 480x360 -vcodec flv -r 25 -qscale 8 -f flv -y #{ flv }
    end_command
    command.gsub!(/\s+/, " ")


  end

  def set_new_filename
    update_attribute(:source_file_name, "#{id}.flv")
  end
end
