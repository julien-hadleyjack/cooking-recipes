require 'yaml'
require 'erb'

files = Dir["../_posts/**/*.adoc"]
config = YAML.load_file('../_config.yml')

template = ERB.new <<-EOF
= <%= config["title"] %>
<%= config["author"] %>
:doctype: book
:imagesdir: images
ifndef::ebook-format[:leveloffset: 1]

<% files.each do |file| %>
include::<%= file %>[]
<% end %>

EOF
puts template.result(binding)