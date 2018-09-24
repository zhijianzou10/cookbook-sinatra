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
