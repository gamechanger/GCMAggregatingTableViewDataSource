require 'erubis'

template = File.read(File.dirname(__FILE__) + "/template.podspec.erb")
template = Erubis::Eruby.new(template)
puts template.result(:version => ARGV[0])

