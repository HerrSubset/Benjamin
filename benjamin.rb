#!/usr/bin/env ruby

require 'csv'
require 'pp'

require './domain.rb'
require './cli.rb'


############################################################
# Program start
############################################################
mutations = []
CSV.read("input.csv", {headers: true}).each do |row|
    next if row.empty?
    mutations << ReportLine.new(row).to_mutation
end

account = Account.new(mutations)
pp account
puts
pp account.balance
