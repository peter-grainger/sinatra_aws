# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/reloader'

require_relative 'upload_file'

class AWSApp < Sinatra::Application
  set :sessions, true
  set :bind, '0.0.0.0'
  set :port, 8080

  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    erb :index
  end

  post '/file-upload' do
    file = params['file']
    UploadFile.new.call(file)
  end

  get '/list-images' do
    GetImageList.new.call
  end
end
