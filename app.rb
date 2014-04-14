require 'sinatra/base'
require 'rdiscount'

class StaticApp < Sinatra::Base

  get '/:file?' do
    cache_control :public, :must_revalidate, :max_age => 60
    begin
      file = params[:file] || 'index'
      markdown file.to_sym, :layout_engine => :erb
    rescue Errno::ENOENT
      not_found
    end
  end

  not_found do
    markdown :not_found, :layout_engine => :erb
  end
end