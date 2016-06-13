#!/usr/bin/env ruby
require 'xmlrpc/client'
require 'open-uri'
APIKEY = '' #Insert your API Key here
ZONE=000000 #The zone number of the file that you want to edit
NAMES=[] #The list of Names that you want to keep the IP address on the up and up
class ZlibParserDecorator
  def initialize(parser)
    @parser = parser
  end
  def parseMethodResponse(responseText)
    @parser.parseMethodResponse(Zlib::GzipReader.new(StringIO.new(responseText)).read)
  end
  def parseMethodCall(*args)
    @parser.parseMethodCall(*args)
  end
end
def recordCheckValid?(records,name)# Essentally what we are doing here is checking if we have a valid name ... I only trust myself so far.
	!records.find{|record| record["name"]==name}.nil?
end
def recordCheck(records,name,expectedValue)#Checks the Records for the right name
	if !recordCheckValid?(records,name)
		raise "INVALID NAME" # We can not do anything with an invalid record ... yet ... (Gonna be a bit lazy here, and skip this for right now ...)
	end
	valueset=records.find{|record| record["name"]==name}["value"]
	returner=valueset==expectedValue
	if !returner
		puts "Found issue with record #{name}: Expected \"#{expectedValue}\", was set to \"#{valueset}\""
	end
	return returner
end 
server = XMLRPC::Client.new2('https://rpc.gandi.net/xmlrpc/')
server.http_header_extra = { "Accept-Encoding" => "gzip" }
server.set_parser ZlibParserDecorator.new(server.send(:parser))


# Now you can call API methods.
# You must authenticate yourself by passing the API key
# as the first method's argument
version = server.call("version.info", APIKEY)
if version.nil?
	puts "Hey! We must be missing an API key here! did you forget to fill it in?"
end
records=server.call("domain.zone.record.list",APIKEY,ZONE,0)
domainRight=true
ipAddress=remote_ip = open('http://whatismyip.akamai.com').read
NAMES.each{|name|
	domainRight&&=recordCheck(records,name,ipAddress)
}
if !domainRight
	NAMES.each{|name| records.find{|record| record["name"]==name}["value"]=ipAddress}
	version = server.call("domain.zone.version.new", APIKEY, ZONE)
	server.call("domain.zone.record.set",APIKEY, ZONE,version,records)
	server.call("domain.zone.version.set",APIKEY, ZONE, version)
	
else
	puts "No issues found!"
end
