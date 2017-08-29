class SMS
	def initialize(keys, values)
		@keys = keys
		@values = values

		i = 0
		@sms = Hash.new
		@keys.each do |element|
			@sms[element] = @values.at(i)
			i = i + 1
		end
	end

	def getDictionary
		@sms
	end
end