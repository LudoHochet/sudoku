class Sudoku
  attr_reader :grid
  def initialize(grid)
    @grid = grid
  end

  def rows
    @grid
  end

  def columns
    @grid.transpose
  end

  def regions

  end
end
