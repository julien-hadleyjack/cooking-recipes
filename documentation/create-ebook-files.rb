require 'yaml'
require 'erb'

files = Dir["../_posts/**/*.adoc"].sort_by { |x| x.match(/\/\d+-\d+-\d+-(.+).adoc/)[1] }
config = YAML.load_file('../_config.yml')

template = ERB.new <<-EOF
= <%= config["title"] %>
<%= config["author"] %>
:doctype: book
:epub3-stylesdir:ebook-css
:ebook: true

ifndef::ebook-format[:leveloffset: 1]

<% files.each do |file| %>
include::<%= file %>[]
<% end %>

EOF
puts template.result(binding)