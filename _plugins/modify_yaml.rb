module Jekyll

  class YamlModifierGenerator < Generator

    def generate(site)

      prefix = 'thumbnail'

      (site.pages + site.posts.docs).each.each do |page|
        next unless page.data.include?('gallery')
        page.data['gallery'] = [page.data['gallery']] if page.data['gallery'].is_a?(String)

        page.data['gallery'].map! do |picture|

          result = picture.is_a?(String) ? {'url' => picture} : picture

          thumb_file = File.join prefix, result['url']

          if !result.include? 'image_path' and File.exists? File.join site.source, 'images', thumb_file
            result['image_path'] = thumb_file
          elsif !result.include? 'image_path'
            puts "Couldn't find thumbnail for #{result['url']}."
          end

          result
        end

        teaser = page.data['gallery'].first
        unless teaser.nil?
          #page.data['epub-picture'] = teaser['url']
          teaser = teaser.include?('image_path') ? teaser['image_path'] : teaser['url']
          page.data['header'] = {'teaser' => teaser}
        end

      end

    end

  end

end
