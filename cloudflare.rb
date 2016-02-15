require 'rubygems'
require 'dotenv'
Dotenv.load
require 'bundler'
Bundler.require(:default)
require_relative 'lib/replace_old_server'
require_relative 'lib/all_dns_records'

# ReplaceOldServer.new('wu.rndsvc.net', 'podkayne.rndsvc.net').perform!

# AllDnsRecords.new.matching_dns_records.each do |dns_record|
#   puts "#{dns_record.name}  #{dns_record.type}  #{dns_record.content}"
# end

# AllDnsRecords.new(type: 'A').matching_dns_records.each do |dns_record|
#   puts "#{dns_record.name}  #{dns_record.type}  #{dns_record.content}"
# end
