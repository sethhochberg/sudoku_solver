class Sudoko
  require 'pp'
  #@rows_array
  #@boxed_rows
  #@game_string

  def initialize(game_string)
    sudoku_array = game_string.split('')
    @rows_array = Array.new(9){ sudoku_array.shift(9) }
  end

  def generate_boxes
    @boxed_rows = []
    rows_string = @rows_array.flatten.join
    sudoku_array = rows_string.split('')
    temp_rows_array = Array.new(9){ sudoku_array.shift(9) }

    temp_rows_array.each do |row|
      @boxed_rows += Array.new(3){row.shift(3)}
    end 
  end

  def get_box(box_number)
    generate_boxes
    case 
    when box_number <= 2
      index_shifter = 0 + box_number
    when box_number <= 5
      index_shifter = 6 + box_number 
    when box_number <= 8
      index_shifter= 12 + box_number 
    end
    box_array = [@boxed_rows[index_shifter], @boxed_rows[index_shifter + 3], @boxed_rows[index_shifter + 6]]
  end

  def get_row(row_number)
    return @rows_array[row_number]
  end

  def get_column(column_number)
    column = []
    @rows_array.each do |row|
      column << row[column_number]
    end
    return column  
  end  
   
  def print_box (box_number)
    p get_box(box_number).each {|row| p row }
  end

  def is_solved?
    @rows_array.each do |row|
      return false if row.include?('0')
    end
    return true
  end

  def build_possible_values(row_number, column_number, box_number)
    if @rows_array[row_number][column_number] == '0'
      possible_values = ('1'..'9').to_a 

      row_array = get_row(row_number)
      column_array = get_column(column_number)
      box_array = get_box(box_number)

      #remove number present in other data arrays - eliminate possible values
      possible_values -= row_array
      possible_values -= column_array
      possible_values -= box_array.flatten  

      return possible_values
    else
      return @rows_array[row_number][column_number]
    end    
  end

  def update_element(possible_values, row, column)
    if possible_values.length == 1
      @rows_array[row][column] = possible_values[0] 
    end
  end
    
  def solve
    start_time = Time.now
    until is_solved? do
      @rows_array.each_with_index do |row, row_number|
        column = 0 
        while column < 9
          case
          when column < 3 #we are in box 0, 3, or 6
            if row_number < 3
              update_element(build_possible_values(row_number, column, 0), row_number, column)
            elsif row_number < 6
              update_element(build_possible_values(row_number, column, 3), row_number, column)
            else
              update_element(build_possible_values(row_number, column, 6), row_number, column)
            end
          when column < 6
            if row_number < 3
              update_element(build_possible_values(row_number, column, 1), row_number, column)
            elsif row_number < 6
              update_element(build_possible_values(row_number, column, 4), row_number, column)
            else
              update_element(build_possible_values(row_number, column, 7), row_number, column)
            end
          when column < 9
            if row_number < 3
              update_element(build_possible_values(row_number, column, 2), row_number, column)
            elsif row_number < 6
              update_element(build_possible_values(row_number, column, 5), row_number, column)
            else
              update_element(build_possible_values(row_number, column, 8), row_number, column)
            end
          end
        column += 1 
        print_board
        sleep(0.04)            
        end
      end    
    end
    puts "The game is finished! It took this poor computer #{(Time.now - start_time).round(2)} to solve the puzzle. It slowed down for you to watch the magic..."  
    if validate_solution
      puts "All rows, columns, and boxes sum to 45 - all numbers between 1 and 9 are present in each!"
    else
      puts "Its just wrong. Validations failed. At least one row, column, or box did not add up to 45. All 9 numbers were not present."  
    end 
  end

  def print_board
    print "\e[2J" #clear screen
    print "\e[H" #move to home
    counter = 0
    print "-------------------------\n"

    @rows_array.each do |row_array|
      print '| '
      row_array.each_slice(3) do |subrow|
        print subrow.join(' ')
        print ' | '
      end
      print "\n"
      if counter == 2 || counter == 5 || counter == 8
        print "-------------------------\n"
      end
      counter += 1      
    end
  end

  def validate_solution
    @rows_array.each do |row|
      return false if row.inject(0){|result, number| number.to_i + result } != 45
    end

    count = 0
    while count < 9 
      return false if get_column(count).inject(0){|result, number| number.to_i + result } != 45
      return false if get_box(count).flatten.inject(0){|result, number| number.to_i + result } != 45
      count += 1
    end

    return true  
  end
end

game = Sudoko.new('003020600900305001001806400008102900700000008006708200002609500800203009005010300')
game.solve
sleep(3)
#game2 = Sudoko.new('619030040270061008000047621486302079000014580031009060005720806320106057160400030')
#game2.solve
#game3 = Sudoko.new('105802000090076405200400819019007306762083090000061050007600030430020501600308900')
#game3.solve
