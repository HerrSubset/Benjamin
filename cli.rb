require 'bigdecimal'

require './domain.rb'


############################################################
# DateEntry 
############################################################
class DateEntry
    def initialize(date, time)
        @date = date
        @time = time
    end

    def to_date
        DateTime::parse("#{@date} #{@time}")
    end
end


############################################################
# AmountEntry 
############################################################
class AmountEntry
    def initialize(amount_string)
        @value = BigDecimal.new(amount_string.delete('.').sub(',', '.'))
    end
    
    def to_amount
        Amount.new(@value)
    end
end


############################################################
# ReportLine 
############################################################
class ReportLine
    def initialize(line_array)
        @date_entry = DateEntry.new(line_array[0], line_array[1])
        @isin = ISIN.new(line_array[3])
        @description = Description.new(line_array[4])
        @amount = AmountEntry.new(line_array[7]).to_amount
        @asset = Currency.new(line_array[6])
    end

    def to_mutation
        Mutation.new(@date_entry.to_date, @description, @asset, @amount)       
    end
end

