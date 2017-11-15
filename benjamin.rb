#!/usr/bin/env ruby

require 'csv'
require 'bigdecimal'
require 'pp'

require './domain.rb'
require './cli.rb'


############################################################
# Program start
############################################################
transactions = []
CSV.read("input.csv", {headers: true}).each do |row|
    next if row.empty?
    transactions << ReportLine.new(row).to_transaction
end

account = Account.new(transactions)
pp account
puts
pp account.balance
