class Cell
  @row
  @column
  @value =[]

  def initialize(value)
    @value = value  
  end

  def validate_box
  end

  def validate_row
  end

  def validate_column
  end

  def validated?
  end
end

class Box
  @cells = []
end

class Sudoko
  @boxes = []

  def initialize(game_string)
    #rows = Array.new(9){game_string.split('').shift(9)}
    #cells = []
    #rows.each do |row|
    #  cell = row.map{ |cell| Cell.}
    binding.pry
  end

  def is_solved?
  end
end

require 'pry'
game = Sudoko.new('003020600900305001001806400008102900700000008006708200002609500800203009005010300')
