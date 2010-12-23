class Video < ActiveRecord::Base
  # Paperclip
  # http://www.thoughtbot.com/projects/paperclip
  before_save :save_thumbnail
  belongs_to :thumbnail
  belongs_to :user
  has_many :replies, :class_name => 'VideoReply'
 has_attached_file :source,
   :url => "/assets/videos/:id/:style/:basename.:extension",
   :path => ":rails_root/public/assets/videos/:id/:style/:basename.:extension"

  # Paperclip Validations
  #validates_attachment_presence :source
  #validates_attachment_content_type :source, :content_type => 'video/quicktime'

  # Acts as State Machine
  # http://elitists.textdriven.com/svn/plugins/acts_as_state_machine
  acts_as_state_machine :initial => :pending
  state :pending
  state :converting
  #state :converted, :enter => :set_new_filename
  state :converted
state :error

  event :convert do
    transitions :from => :pending, :to => :converting
  end

  event :converted do
    transitions :from => :converting, :to => :converted
  end

  event :failed do
    transitions :from => :converting, :to => :error
  end

  def save_thumbnail
    logger.info "Saving thumbnail of Video..."
    t = Thumbnail.create!("/public/")
    self.thumbnail = t
    t
end


  # Conversion Methods
  def convert
    self.convert!
    success = system(convert_command)
    if success && $?.exitstatus == 0
      self.converted!
    else
      self.failed!
    end
  end

  protected

  def convert_command
    flv = File.join(File.dirname(source.path), "#{id}.flv")
    File.open(flv, 'w')

    # -ar 22050 -ab 32 -acodec mp3
    command = <<-end_command
      ffmpeg -i #{ source.path } -an
      -s 480x360 -vcodec flv -r 25 -qscale 8 -f flv -y #{ flv }
    end_command
    command.gsub!(/\s+/, " ")
  end

  def set_new_filename
    update_attribute(:source_file_name, "#{id}.flv")
  end
end
