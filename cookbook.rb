# TODO: Implement the Cookbook class that will be our repository
require 'csv'
require_relative 'recipe'

class Cookbook
  def initialize(csv_file_path)
    @recipes = []
    @filepath = csv_file_path
    load_csv
  end

  def all
    @recipes
  end

  def create(recipe)
    @recipes << recipe
    save_csv
  end

  def destroy(index)
    @recipes.delete_at(index)
    save_csv
  end

  def find(index)
    @recipes[index]
  end

  def save
    save_csv
  end

  private

  def load_csv
    CSV.foreach(@filepath, headers: :first_row, header_converters: :symbol) do |row|
      @recipes << Recipe.new(row)
    end
  end

  def save_csv
    CSV.open(@filepath, "wb") do |csv|
      csv << ["name", "rating", "prep_time", "description", "done"]
      @recipes.each do |recipe|
        csv << [recipe.name, recipe.rating, recipe.prep_time, recipe.description, recipe.done]
      end
    end
  end
end
