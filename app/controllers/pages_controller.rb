class PagesController < ApplicationController
  require 'rest-client'
  def index
    response = RestClient.get "https://google.com"
    ap response
  end
end
