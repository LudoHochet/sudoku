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
    # regions = []
    # regions << grid.first(3).map { |rows| rows.first(3) }.flatten
    # regions << grid.first(3).map { |rows| rows[3..5] }.flatten
    # regions << grid.first(3).map { |rows| rows.last(3) }.flatten
    # regions << grid[3..5].map { |rows| rows.first(3) }.flatten
    # regions << grid[3..5].map { |rows| rows[3..5] }.flatten
    # regions << grid[3..5].map { |rows| rows.last(3) }.flatten
    # regions << grid.last(3).map { |rows| rows.first(3) }.flatten
    # regions << grid.last(3).map { |rows| rows[3..5] }.flatten
    # regions << grid.last(3).map { |rows| rows.last(3) }.flatten

  def regions
    regions = []
    [0, 3, 6].map do |j|
      [0, 3, 6].map { |i| regions << grid[j..j + 2].map {|row| row[i..i + 2]}}
    end
    regions
  end

  def valid?
    # item.count == item.uniq.count
    (self & ((1..9).to_a)).size == 9
  end
end
