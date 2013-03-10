#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-
require 'sinatra/base'
require 'redis'
require 'yaml'
require 'haml'

class Okkake < Sinatra::Base
	enable :inline_templates
	enable :logging

  configure do
    require 'sinatra/reloader'
    set :server, "webrick"
    register Sinatra::Reloader
  end

	get '/' do  
	  @config = YAML.load_file(File.expand_path(File.dirname(__FILE__) + '/redis-config.yml'))
    @now_time = Time.now.to_i
    # 表示する値の数
    @show_count = 16
    # 出力する秒数の間隔
    @span = 5
    # 間隔に合うように時間調整
    adjust = @now_time % @span
    @now_time = @now_time - adjust

	  redis = Redis.new(
      :host=>@config['HOST'],
      :port=>@config['PORT'],
      :password=>@config['PASSWORD'])
    @dot = {}
    # 過去データをRedisから読み込み
    ((@now_time - (@span*@show_count))..@now_time).step(@span).each do |t|
      val = redis.get(t)
      val = "0" if val.nil?
      @dot[t] = val.to_f
    end

		haml :top
	end

	get '/:id' do
	  @id = params[:id]
		haml :index
	end
end
