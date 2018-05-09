require 'nokogiri'

doc = Nokogiri::XML(File.open(ARGV[0]))
doc.xpath('fpc4:Root').xpath('fpc4:Arrays').xpath('fpc4:Array').xpath('fpc4:RuleElements').xpath('fpc4:DomainNameSets').xpath('fpc4:DomainNameSet').each do |doo|
		puts doo.xpath('fpc4:Name').text
		my_file = File.open(doo.xpath('fpc4:Name').text+".rsc", 'w')
		doo.xpath('fpc4:DomainNameStrings')[0].xpath('fpc4:Str').each do |dio|
			my_file.puts 'do { /ip firewall address-list add address="'+dio.text.gsub("*.","")+'" list="'+doo.xpath('fpc4:Name').text+'"} on-error={}' rescue puts "Error in: "+dio.text
			my_file.write "\r\n"
		end
		my_file.close
		puts "------"
		#.gsub("http://","").gsub("https://","").gsub("*.","")
end

doc.xpath('fpc4:Root').xpath('fpc4:Arrays').xpath('fpc4:Array').xpath('fpc4:RuleElements').xpath('fpc4:URLSets').xpath('fpc4:URLSet').each do |doo|
		my_file = File.open(doo.xpath('fpc4:Name').text+".rsc", 'w')
		puts doo.xpath('fpc4:Name').text
		doo.xpath('fpc4:URLStrings')[0].xpath('fpc4:Str').each do |dio|
			my_file.puts 'do { /ip firewall address-list add address="'+URI.parse(dio.text.gsub("*.","").gsub("\\","")).host.to_s+'" list="'+doo.xpath('fpc4:Name').text+'"} on-error={}' rescue puts "Error in: "+dio.text
			my_file.write "\r\n"
		end
		my_file.close
		puts "------"
end	
