class Recipe
  attr_reader :name, :description, :rating, :prep_time, :done

  def initialize(attributes = {})
    @name = attributes[:name]
    @description = attributes[:description]
    @rating = attributes[:rating]
    @prep_time = attributes[:prep_time]
    @done = attributes[:done] == "true"
  end

  def done?
    return @done == true ? "[X]" : "[ ]"
  end

  def markun!
    @done = !@done
  end
end
