#!/usr/bin/env ruby

require 'csv'
require 'bigdecimal'
require 'pp'

class ISIN
    def initialize(code)
        @code = code
    end
end

class Currency
    def initialize(currency)
        @currency = currency.upcase
    end
end

class Amount
    def initialize(value)
        @value = value
    end

    attr_reader :value

    def self.ZERO
        Amount.new(BigDecimal.new("0.0"))
    end

    def +(amount)
        puts "Adding #{@value} and #{amount.value}"
        Amount.new(@value + amount.value)
    end
end

class Mutation
    def initialize(currency, amount)
        @currency = Currency.new(currency)
        @amount = amount
    end

    attr_reader :amount

    def +(mutation)
        @amount + mutation.amount
    end
end

class Description
    def initialize(description)
        @description = description
    end
end

class Transaction
    def initialize(date, description, mutation)
        @date = date
        @description = description
        @mutation = mutation
    end

    attr_reader :mutation

    def +(transaction)
        @mutation + transaction.mutation
    end
end

class Account
    def initialize(transactions)
        @transactions = transactions
    end

    def balance
        @transactions.map { |transaction| transaction.mutation.amount }
                     .sum Amount.ZERO
    end
end

class DateEntry
    def initialize(date, time)
        @date = date
        @time = time
    end

    def to_date
        DateTime::parse("#{@date} #{@time}")
    end
end

class AmountEntry
    def initialize(amount_string)
        @value = BigDecimal.new(amount_string.delete('.').sub(',', '.'))
    end
    
    def to_amount
        Amount.new(@value)
    end
end

class ReportLine
    def initialize(line_array)
        @date_entry = DateEntry.new(line_array[0], line_array[1])
        @isin = ISIN.new(line_array[3])
        @description = Description.new(line_array[4])
        @amount = AmountEntry.new(line_array[7]).to_amount
        @mutation = Mutation.new(line_array[6], @amount)
    end

    def to_transaction
        Transaction.new(@date_entry.to_date, @description, @mutation)       
    end
end


transactions = []
CSV.read("input.csv", {headers: true}).each do |row|
    next if row.empty?
    transactions << ReportLine.new(row).to_transaction
end

account = Account.new(transactions)
pp account
puts
pp account.balance
