require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require_relative "./cookbook.rb"

filepath = "./recipes.csv"

get "/team/:username" do
  puts params[:username]
  "The username is #{params[:username]}"
end

get "/" do
  @recipes = Cookbook.new(filepath).all
  erb :index
end
