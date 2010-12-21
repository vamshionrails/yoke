module Paperclip
  class VideoThumbnail < Processor

    attr_accessor :geometry, :whiny

    def initialize(file, options = {}, attachment = nil)
      super
      @file = file

      unless options[:geometry].nil? || (@geometry =
Geometry.parse(options[:geometry])).nil?
        @geometry.width = (@geometry.width / 2.0).floor * 2.0
        @geometry.height = (@geometry.height / 2.0).floor * 2.0
        @geometry.modifier = ''
      end
      @whiny = options[:whiny].nil? ? true : options[:whiny]
      @basename = File.basename(file.path, File.extname(file.path))
    end

    def make

     dst = Tempfile.new([ @basename, 'jpg' ].compact.join("."))
     dst.binmode

     cmd = "ffmpeg -itsoffset -4 -i #...@file.path} -y -vcodec mjpeg -
vframes 1 -an -f rawvideo -s #{geometry.to_s}
#{File.expand_path(dst.path)}"

      begin
        success = Paperclip.run(cmd)
      rescue PaperclipCommandLineError
        raise PaperclipError, "There was an error processing the
thumbnail for #{@basename}" if whiny
      end
     dst
    end
  end
end 
