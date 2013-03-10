#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-
require 'sinatra/base'
require 'sinatra/reloader'
require 'redis'
require 'haml'

class Okkake < Sinatra::Base
	enable :inline_templates
	enable :logging

	# Sinatra再起動が不要になる(gem入れたときは別)
	set :server, "webrick"
	register Sinatra::Reloader

	get '/' do
		"Hello world, it's #{Time.now} at the server!"
	end

	get '/:id' do
	    @id = params[:id]
		haml :index
	end
end
