#Usage: ./crashplanConnect.rb some.host username remoteKey
require 'net/ssh/gateway'
IFILE="/Library/Application Support/CrashPlan/.ui_info"#Where the .ui_info is stored on the system
UFILE="/Library/Application Support/CrashPlan/ui_#{ENV['USER']}.properties"
CRASHPLAN="/Applications/CrashPlan.app/Contents/MacOS/CrashPlan"#Where the Crashplan Desktop App is located
gateway=Net::SSH::Gateway.new(ARGV[0], ARGV[1])#Where we are going to connect, and what user we are going to use to authenticate
#Note! We are assuming we are only going to have one argument, so we are going to just return after that.

#Setting up the files so we can get this party started
text=File.read(IFILE)
iText=text
text.gsub!(/(?:,)(([\s\S]*))(?:,)/,",#{ARGV[2]},")
text.gsub!(/^\d\d\d\d/,"4200")
File.open(IFILE, "w") {|file| file.puts text}
text=File.read(UFILE)
File.open(UFILE, "w"){|file| file.puts "#{text}port=4200\n"}
#File Edited, let's conenct to our server!
gateway.open("127.0.0.1",4243,4200)
system("#{CRASHPLAN} > /dev/null")#We honestly don't care too much about the loging info
gateway.close(4200)
#Mischef managed, let's put things back in order
File.open(IFILE,"w"){|file| file.puts iText}
File.open(UFILE,"w"){|file| file.puts text}