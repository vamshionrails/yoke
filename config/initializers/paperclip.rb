
Paperclip.interpolates :artist_id do |attachment, style|
  attachment.instance.artist.id
end

# Ensures that files have the proper extensions. i.e. thumbnails with jpgs
Paperclip.interpolates :extension do |attachment, style_name|
  case attachment.instance.class.to_s
    when "Video"
      if style_name.to_s == 'original'
        'flv'
      else
        'jpg'
      end
    when "Audio"
      if style_name.to_s == 'original'
        'mp3'
      end
    else
      File.extname(attachment.original_filename).gsub(/^\.+/, "")
  end
end

# Path to ffmpeg
Paperclip.options[:command_path] = "/usr/local/bin/ffmpeg"
