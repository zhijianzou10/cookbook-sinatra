require 'sinatra'
require 'sinatra/reloader' if development?
require 'pry-byebug'
require 'better_errors'
require 'nokogiri'
require 'csv'

set :bind, '0.0.0.0'
configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path(__dir__)
end

# Class recipe
class Recipe
  attr_reader :name, :description, :preptime, :difficulty, :done

  def initialize(name, description, preptime = nil, difficulty = nil, done = false)
    @name = name
    @description = description
    @preptime = preptime
    @difficulty = difficulty
    @done = done
  end

  def done?
    @done
  end

  def mark_as_done!
    @done = true
  end
end

# Class cookbook
class Cookbook
  attr_reader :name_array, :desc_array, :prep_array

  def initialize(csv_file_path)
    @recipes = []
    @csv_file_path = csv_file_path
    csv_options = { col_sep: ',', headers: nil }
    CSV.foreach(@csv_file_path, csv_options) do |row|
      @recipes << Recipe.new(row[0], row[1], row[2], row[3], row[4])
    end
  end

  def all
    @recipes
  end

  def add_recipe(recipe)
    @recipes << recipe
    CSV.open(@csv_file_path, 'w') do |csv|
      @recipes.each do |r|
        csv << [r.name, r.description, r.preptime, r.difficulty, r.done]
      end
    end
  end

  def remove_recipe(recipe_index)
    @recipes.delete_at(recipe_index - 1)
    CSV.open(@csv_file_path, 'w') do |csv|
      @recipes.each do |r|
        csv << [r.name, r.description, r.preptime, r.difficulty, r.done]
      end
    end
  end

  def mark_as_done(recipe_index)
    @recipes[recipe_index - 1].mark_as_done!
    CSV.open(@csv_file_path, 'w') do |csv|
      @recipes.each do |r|
        csv << [r.name, r.description, r.preptime, r.difficulty, r.done]
      end
    end
  end
end

get '/' do
  erb :layout

end
