require 'csv'
require 'nokogiri'

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
