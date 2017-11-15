require 'bigdecimal'

############################################################
# ISIN 
############################################################
class ISIN
    def initialize(code)
        @code = code
    end
end


############################################################
# Currency 
############################################################
class Currency
    def initialize(currency)
        @currency = currency.upcase
    end
end


############################################################
# Amount 
############################################################
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


############################################################
# Mutation 
############################################################
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


############################################################
# Description 
############################################################
class Description
    def initialize(description)
        @description = description
    end
end


############################################################
# Transaction 
############################################################
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


############################################################
# Account 
############################################################
class Account
    def initialize(transactions)
        @transactions = transactions
    end

    def balance
        @transactions.map { |transaction| transaction.mutation.amount }
                     .sum Amount.ZERO
    end
end
