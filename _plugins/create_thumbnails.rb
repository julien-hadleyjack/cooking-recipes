require 'filemagic'
require 'pathname'
require 'mini_magick'
require 'fileutils'


module Jekyll

  class ThumbGenerator < Generator

    def generate(site)

      suffix = '-thumb'
      width = 500
      height = 300

      site.static_files.each do |file|
        directory = File.dirname file.path
        file_name = File.basename file.path, '.*'
        extension = File.extname file.path

        #root_path = Pathname.new(__FILE__ + '/../..').realpath
        #rel_path = Pathname.new(file.path).relative_path_from(root_path)
        thumb_file = File.join directory, file_name + suffix + extension

        allowed_images = %w(image/jpeg image/png)
        if !allowed_images.include?(FileMagic.new(FileMagic::MAGIC_MIME_TYPE).file(file.path)) or
            file_name.end_with?(suffix) or
            (File.exists?(thumb_file) and File.mtime(thumb_file) > File.mtime(file.path))
          next
        end

        #dirname = File.join site.dest, File.dirname(rel_path)
        #unless File.directory?(dirname)
        #  FileUtils.mkdir_p(dirname)
        #end

        puts "Thumbnailing #{thumb_file} (#{width}x#{height})"
        image = MiniMagick::Image.open(file.path)
        image.resize "#{width}x#{height}^"
        image.gravity 'center'
        image.extent "#{width}x#{height}"
        image.write thumb_file

        # site.static_files << StaticFile.new site, file.path, File.basename(thumb_file),File.basename(thumb_file, '.*')
        #site.static_files << StaticFile.new site, site.dest, @config['dir'], name
        #site.static_files << Jekyll::StaticFile.new(site, file.path, site.dest, File.dirname(rel_path), File.basename(thumb_file))
        #site.static_files << Jekyll::StaticFile.new(site, site.dest, '/', File.basename(thumb_file))
        #puts "Path: " + File.join(site.dest, File.dirname(rel_path), File.basename(thumb_file))
        #site.static_files << Jekyll::StaticFile.new(site, site.dest, File.dirname(rel_path), File.basename(thumb_file))
      end

    end

  end

end
