#Usage: bandwithChanger.rb newBandwithLimit(should be an int) settingsLoction
#!/usr/bin/env ruby
require 'nokogiri'
Document=ARGV[1]
NewBandwidth="#{ARGV[0]}.0"
doc=Nokogiri::XML(File.open(Document))
doc.xpath("//highBandwidthRate")[0].inner_html=NewBandwidth
doc.xpath("//lowBandwidthRate")[0].inner_html=NewBandwidth
doc.xpath("//lanHighBandwidthRate")[0].inner_html=NewBandwidth
doc.xpath("//lanLowBandwidthRate")[0].inner_html=NewBandwidth
File.open(Document, "w"){|file| file.puts doc.to_xml}
system("service crashplan restart")
