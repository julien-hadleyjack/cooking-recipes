module Jekyll

  class YamlModifierGenerator < Generator

    def generate(site)

      prefix = 'thumbnail'

      pages = site.pages + site.posts.docs + site.documents
      # site.pages.each do |p|
      #   if p.respond_to?(:posts)
      #     pages.concat p.posts
      #   end
      # end

      (pages).each.each do |page|
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

# def modify_yaml site, page
#   return unless page.data.include?('gallery')
#   page.data['gallery'] = [page.data['gallery']] if page.data['gallery'].is_a?(String)
#
#   page.data['gallery'].map! do |picture|
#
#     result = picture.is_a?(String) ? {'url' => picture} : picture
#
#     thumb_file = File.join prefix, result['url']
#
#     if !result.include? 'image_path' and File.exists? File.join site.source, 'images', thumb_file
#       result['image_path'] = thumb_file
#     elsif !result.include? 'image_path'
#       puts "Couldn't find thumbnail for #{result['url']}."
#     end
#
#     result
#   end
#
#   teaser = page.data['gallery'].first
#   unless teaser.nil?
#     #page.data['epub-picture'] = teaser['url']
#     teaser = teaser.include?('image_path') ? teaser['image_path'] : teaser['url']
#     page.data['header'] = {'teaser' => teaser}
#   end
#
# end


# Jekyll::Hooks.register [:documents, :pages, :posts], :post_init do |post|
#    # code to call after Jekyll renders a post
#    post.data['gallery'] = 'curry-nudeln-mit-blumenkohl.jpg'
#    modify_yaml post.site, post
# end

# Jekyll::Hooks.register :pages, :post_init do |pages|
#   # code to call after Jekyll renders a post
#   #puts site.source
#   #post.data['gallery'] = 'curry-nudeln-mit-blumenkohl.jpg'
#   puts 'Running post_init hook'
#    if pages.respond_to?(:posts)
#      modify_yaml p.site, p
#    end
# end