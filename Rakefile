require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('iap_verify', '0.1.0') do |p|
  p.description    = "Verify in app purchase"
  p.url            = "https://github.com/WebFactoryMk/iap_verify"
  p.author         = "WF|Todor Panev"
  p.email          = "toshe@webfactory.mk"
  p.ignore_pattern = ["tmp/*", "script/*"]
  p.development_dependencies = []
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }