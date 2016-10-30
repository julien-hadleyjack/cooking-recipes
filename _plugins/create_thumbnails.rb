require 'filemagic'
require 'pathname'
require 'mini_magick'
require 'fileutils'
require 'find'


module Jekyll

  class ThumbGenerator < Generator

    def generate(site)
      thumb_dir = 'thumbnail'
      ignored_dirs = %w(thumbnail favicon)
      width = 500
      height = 300

      asset_root = File.join site.source, 'images'


      Find.find(asset_root).each do |file|
        rel_path = Pathname.new(file).relative_path_from(Pathname.new(asset_root))
        thumb_file = File.join site.source, 'images', thumb_dir, rel_path

        if check_dir(asset_root, ignored_dirs, file) or !FileMagic.new(FileMagic::MAGIC_MIME_TYPE).file(file).include?('image/') or
            (File.exists?(thumb_file) and File.mtime(thumb_file) > File.mtime(file))
          next
        end

        dir_name = File.dirname thumb_file
        unless File.exists? dir_name
          puts "Creating directory #{dir_name}"
          FileUtils.mkdir_p dir_name
        end

        puts "Thumbnailing #{rel_path} (#{width}x#{height})."
        image = MiniMagick::Image.open(file)
        image.resize "#{width}x#{height}^"
        image.gravity 'center'
        image.extent "#{width}x#{height}"
        image.write thumb_file
        image.destroy!

        site.static_files << Jekyll::StaticFile.new(site, site.source,
                                                    File.dirname(File.join('images', thumb_dir, rel_path)),
                                                    File.basename(thumb_file))
      end

    end

    def check_dir(asset_root, ignored_dirs, path)
      if ignored_dirs.is_a?(Array)
        ignored_dirs.any? { |dir| path.start_with?(File.join(asset_root, dir)) }
      else
        path.start_with?(File.join(asset_root, ignored_dirs))
      end
    end

  end

end
