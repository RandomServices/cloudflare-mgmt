require 'rubygems'
require 'dotenv'
Dotenv.load
require 'bundler'
Bundler.require(:default)
require_relative 'lib/replace_old_server'

ReplaceOldServer.new('wu.rndsvc.net', 'podkayne.rndsvc.net').perform!
