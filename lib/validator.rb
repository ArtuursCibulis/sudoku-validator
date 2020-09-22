require "irb"
class Validator
  def initialize(puzzle_string)
    @puzzle_string = puzzle_string
  end

  def self.validate(puzzle_string)
    new(puzzle_string).validate
  end

  def validate
    print @puzzle_string
    array = convert_sudoku_example_to_array
    if unique_row_numbers?(array) && unique_column_numbers?(array) && unique_sub_area_numbers?(array) && is_completed?(array)
      "Sudoku ir derīgs."
    elsif unique_row_numbers?(array) && unique_column_numbers?(array) && unique_sub_area_numbers?(array)
      "Sudoku ir derīgs, bet nepabeigts."
    else
      "Sudoku ir nederīgs."
    end
  end

  def unique_row_numbers?(array)
    array.map { |row| row.reject(&:zero?) }.all? do |row|
      row.uniq.length == row.length
    end
  end

  def unique_column_numbers?(array)
    columns = array.transpose
    columns.map { |column| column.reject(&:zero?) }.all? do |column|
      column.uniq.length == column.length
    end
  end

  def unique_sub_area_numbers?(array)
    array.each_slice(3).map{|stripe| stripe.transpose.each_slice(3).map{|chunk| chunk.transpose}}.flatten(1).map{|a| a.flatten(1).reject(&:zero?)}.all? do |items|
      items.uniq.length == items.length
    end
  end

  def is_completed?(array)
    array.none? { |a| a.include?(0) }
  end

  def convert_sudoku_example_to_array
    array = @puzzle_string.lines
    array.select! { |x| x[0] != '-' }
    array.map { |word| word.gsub( '|', '').strip.split(' ').map(&:to_i) }
  end
end
