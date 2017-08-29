require_relative 'xmlconverter.rb'

xml = XMLConverter.new(ARGV[0])

# determines the structure of the XML and its elements
xml.structure 

# saves the elements and its attributes in the SMS class
xml.read

# write a new XML with the desired format and contains the data from source.xml
xml.convert