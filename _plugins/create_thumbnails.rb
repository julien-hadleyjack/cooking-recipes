require 'filemagic'
require 'pathname'
require 'mini_magick'
require 'fileutils'
require 'find'


module Jekyll

  class ThumbGenerator < Generator

    def generate(site)
      prefix = 'thumbnail'
      width = 500
      height = 300

      asset_root = File.join site.source, 'images'
      reject = File.join asset_root, prefix


      Find.find(asset_root).each do |file|
        rel_path = Pathname.new(file).relative_path_from(Pathname.new(asset_root))
        thumb_file = File.join site.source, 'images', prefix, rel_path

        if file.start_with?(reject) or !FileMagic.new(FileMagic::MAGIC_MIME_TYPE).file(file).include?('image/') or
            (File.exists?(thumb_file) and File.mtime(thumb_file) > File.mtime(file))
          next
        end

        puts "Thumbnailing #{rel_path} (#{width}x#{height})."

        dir_name = File.dirname thumb_file
        unless File.directory?(dir_name)
          "Creating directory #{dir_name}"
          FileUtils.mkdir_p(dir_name)
        end

        image = MiniMagick::Image.open(file)
        image.resize "#{width}x#{height}^"
        image.gravity 'center'
        image.extent "#{width}x#{height}"
        image.write thumb_file
        image.destroy!
      end

    end

end

end
