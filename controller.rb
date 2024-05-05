#  TODO: Define your Controller Class here, to orchestrate the other classes
require_relative 'view'
require_relative 'recipe'
require 'open-uri'
require 'nokogiri'

class Controller
  def initialize(cookbook)
    @view = View.new
    @cookbook = cookbook
  end

  def list
    @view.display_list(@cookbook.all)
  end

  def add
    recipe = Recipe.new(
      name: @view.ask_user_for("Name"),
      description: @view.ask_user_for("Description"),
      rating: @view.ask_user_for("Rating"),
      prep_time: @view.ask_user_for("Prep time")
    )
    @cookbook.create(recipe)
  end

  def remove
    index = @view.ask_user_for("Index")
    @cookbook.destroy(index.to_i - 1)
  end

  def mark
    index = @view.ask_user_for("Index").to_i - 1
    @cookbook.find(index).markun!
    @cookbook.save
  end

  def scrape
    ingredient = @view.ask_user_for("ingredient")
    @view.loading(ingredient)
    url = "https://www.allrecipes.com/search?q=#{ingredient}"
    array = scrape_names(url)
    @view.list_recipes(array.map { |hash| hash[:name] })
    index = @view.ask_user_for("Index").to_i - 1
    @view.import(array[index][:name])
    url = array[index][:url]
    @cookbook.create(Recipe.new(scrape_rest(url)))
  end

  private

  def scrape_names(url)
    file = URI.open(url).read
    document = Nokogiri::HTML.parse(file)
    array = []
    document.search(".comp.mntl-card-list-items.mntl-document-card.mntl-card.card.card--no-image").first(5).each do |e|
      array << {
        name: e.search(".card__title-text").text.strip,
        url: e.attribute("href").value
      }
    end
    array
  end

  def scrape_rest(url)
    file = URI.open(url).read
    document = Nokogiri::HTML.parse(file)
    {
      name: document.search(".article-heading.type--lion").text.strip,
      rating: document.search("#mntl-recipe-review-bar__rating_1-0").text.strip,
      prep_time: document.search(".mntl-recipe-details__value")[0].text.strip,
      description: document.search(".article-subheading.type--dog").text.strip
    }
  end
end
