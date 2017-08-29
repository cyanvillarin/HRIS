# nokogiri (ruby gem) is an XML parser
require 'nokogiri' 

# rexml is a ruby library for processing XML. Used for escaping special characters such as &, <, >
require 'rexml/document' 

# sms.rb contains the SMS class
require_relative 'sms.rb'

# <element> This is an element </element>
# <element attr=value> WUW </element>
# Problem with source.xml = there's no body, everything is written as attribute and value

class XMLConverter
	def initialize(filename)
		@fname = filename
		@version = 0
		@encoding = 0
		@msg_array = Array.new
	end

	def structure
		# This method gets the structure of the XML. 
		# Reference for Extracting every element in the XML: https://readysteadycode.com/howto-extract-data-from-html-with-ruby
		# @tags is a dictionary which contains the number of all the elements in the XML and we can determine the structure of the XML
		
		@tags = Hash.new(0)

		@doc = Nokogiri::XML(File.open(@fname)) 
		@doc.traverse do |node|
			next unless node.is_a?(Nokogiri::XML::Element)
			@tags[node.name] += 1
		end

		# puts @tags
		# Example output: {"sms"=>622, "smses"=>1, "hi"=>1}
		# Means that sms elements are contained in smses element, which is contained in hi. hi < smses < sms
	end

	def read
		@version = @doc.version
		@encoding = @doc.encoding

		keys = Array.new
		values = Array.new

		# the first key (@tags.keys[0])in the tags dictionary is the innermost element of the XML
		# the last key is the outermost element

		@doc.css(@tags.keys[0]).each do |sms|
			keys.clear
			values.clear

			sms.attributes.each do |name,attr|
				keys.push(name)
				values.push(attr.value)
			end

			newSMS = SMS.new(keys, values)
			@msg_array.push(newSMS.getDictionary)
		end
	end

	def convert
		inputfile = @fname.split(".").first
		typefile = @fname.split(".").last

		#format of output filename: <original_file_name>-formatted.xml 
		outputfile = inputfile + "-formatted." + typefile  
		output = File.open(outputfile, "w")

		# prints the xml tag
		# puts "<?xml version=\"#{@version}\" encoding=\"#{@encoding}\"?>"
		output << "<?xml version=\"#{@version}\" encoding=\"#{@encoding}\"?>"

		# prints the beginning tags of the outer elements
		for i in (@tags.length-1).downto(1)
			# puts "<#{@tags.keys[i]}>"
			output << "<#{@tags.keys[i]}>"
		end

		# prints all the innermost elements
		@msg_array.each do |sms|
			# puts "\n"
			output << "\n"

			# prints the beginning tag for the innermost element
			# puts "<#{@tags.keys[0]}>"
			output << "<#{@tags.keys[0]}>"

			# prints the element and its body (from the previous attributes' <element name=value /> to <tags>body</tags>)
			for x in 0..sms.length-1
		 		# puts "<#{sms.keys[x]}>#{sms.values[x]}</#{sms.keys[x]}>"	

		 		# 1st argument: string
		 		# 2nd argument: boolean for retaining white space
		 		# 3rd argument: ?? keep it nil or pass the parent object ??
		 		# 4th argument: true = will not change the text ? 
		 		# 				false = will escape characters such as <&

		 		new_string = REXML::Text.new(sms.values[x], false, nil, false)
		 		output << "<#{sms.keys[x]}>#{new_string}</#{sms.keys[x]}>"
			end

			# prints the end tag for the innermost element
			# puts "</#{@tags.keys[0]}>"
			output << "</#{@tags.keys[0]}>"
		end

		# prints the ending tags of the outer elements
		for i in 1..@tags.length-1
		 	# puts "</#{@tags.keys[i]}>"
		 	output << "</#{@tags.keys[i]}>"
		end

		output.close
		puts "Successfully reformatted XML file."
	end
end 








