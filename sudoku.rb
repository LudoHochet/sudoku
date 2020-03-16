require 'set'

module ArrayExtensions
  refine Array do
    def valid?
      Set[*self].size == 9
    end

    def fill
      new_digit = (1..9).each do |digit|
        break digit unless Set[*self].include? digit
      end
      self << new_digit
    end
  end
end

class Sudoku
  using ArrayExtensions

  def self.done_or_not(grid)
    grid = Sudoku.new(grid)
    if grid.rows.all?(&:valid?) && grid.columns.all?(&:valid?) &&
        grid.regions.all?(&:valid?)
      'Finished!'
    else
      'Try again!'
    end
  end

  def initialize(input)
    @grid = input
  end

  def rows
    @grid
  end

  def columns
    @grid.transpose
  end

  def regions
    flat_triplet_list = @grid.flatten.each_slice(3).to_a
    (0..20).step(9).each_with_object([]) do |i, result|
      (0..2).each do |k|
        region = []
        [0, 3, 6].each do |j|
          region << flat_triplet_list[i + j + k]
        end
        result << region.flatten
      end
    end
  end

  def grid_valid?
    rows.all?(&:valid?) && columns.all?(&:valid?) &&
        regions.all?(&:valid?)
  end

  def find_empty_positions
    @grid.each_with_index.with_object([]) do |(row, row_index), empty_positions|
      row.each_with_index do |digit, digit_index|
        empty_positions << [digit_index, row_index] if digit.zero?
      end
    end
  end

  def check_row(row, digit)
    !rows[row].include? digit
  end

  def check_column(col, digit)
    !columns[col].include? digit
  end

  def check_region(row, col, digit)
    region_index = region_index(row, col)
    !regions[region_index].include? digit
  end

  def check_value(row, col, digit)
    check_row(row, digit) && check_column(col, digit) && check_region(row, col, digit)
  end

  def region_index(row, col)
    (row / 3) + (col / 3) * 9
  end

  def fill_all
    empty_positions = find_empty_positions
    until empty_positions.empty?
      row, col = empty_positions.pop
      (1..9).each do |digit|
        @grid[row][col] = digit if check_value(row, col, digit)
      end
    end
    @grid
  end

end

