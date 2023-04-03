start_instructions = <<~INSTRUCTIONS
Welcome to Mastermind!
INSTRUCTIONS

key_pegs = [0, 1, 2]

class Colour

  attr_accessor :name
  attr_accessor :code_number
  attr_accessor :ruled_out
  attr_accessor :attempted
  attr_accessor :confirmed

  def initialize(name, code_number)
    @name = name
    @code_number = code_number
    @ruled_out = false
    @attempted = []
    @confirmed = []
  end
end

code_colours = [
red = Colour.new("red", 1), 
blue = Colour.new("blue", 2), 
green = Colour.new("green", 3), 
yellow = Colour.new("yellow", 4), 
orange = Colour.new("orange", 5), 
purple = Colour.new("purple", 6)
]

col_hash = code_colours.map { |colour| [colour.code_number, colour.name] }.to_h

class Board

  attr_accessor :decoding_board

  def initialize
    @decoding_board = <<~BOARD
    Attempts   Feedback
    ___________________
   | _ _ _ _ | _ _ _ _ |
   | _ _ _ _ | _ _ _ _ |
   | _ _ _ _ | _ _ _ _ |
   | _ _ _ _ | _ _ _ _ |
   | _ _ _ _ | _ _ _ _ |
   | _ _ _ _ | _ _ _ _ |
   | _ _ _ _ | _ _ _ _ |
   | _ _ _ _ | _ _ _ _ |
   | _ _ _ _ | _ _ _ _ |
   | _ _ _ _ | _ _ _ _ |
   | _ _ _ _ | _ _ _ _ |
   | _ _ _ _ | _ _ _ _ |
   |___________________|
   BOARD
  end

  def add_guess(row, guess)
    row += 1
    new_row = "| #{guess[0]} #{guess[1]} #{guess[2]} #{guess[3]} | _ _ _ _ |"
  
    board_rows = @decoding_board.split("\n")
    board_rows[row] = board_rows[row].replace new_row
    board_rows = board_rows.join("\n")
  end

  def add_feedback(row, feed)
    row += 1
    to_replace = " _ _ _ _ "
    replacement = " #{feed[0]} #{feed[1]} #{feed[2]} #{feed[3]} "
  
    board_rows = @decoding_board.split("\n")
    board_rows[row].gsub!(to_replace, replacement)
    board_rows = board_rows.join("\n")
  end

end

board = Board.new()

def process_feedback(code, guess)
  feedback = guess.map.with_index do |numb, i|
    if numb == code[i]
      1
    elsif code.include?(numb)
      2
    else
      0
    end
  end
  feedback
end

def choose_role()
  role = 1

  loop do
    puts "Would you like to be the codebreaker or codemaster? (enter 1 or 2)"
    role = gets.chomp

    if role == "1"
      role = "codebreaker"
      break
    elsif role == "2"
      role = "codemaster"
      break
    else
      puts "Invalid input. Try again."
    end
  end

  puts "You chose #{role}!"
  role
end

game_over = false

# Start game
while !game_over do
  puts start_instructions
  
  # Choose role
  player = choose_role()

  # Set up secret code
  secret_code = []

  if player == "codebreaker"
    secret_code = [rand(6), rand(6), rand(6), rand(6)]
  elsif player == "codemaster"
    puts "Codemaster, please enter your secret code now"
    puts col_hash
    puts "valid code: <colour>, <colour>, <colour>, <colour>"
    secret_code = gets.chomp.gsub(" ", "").split(",")
    secret_code.map! {|numb| numb.to_i}
  end

  # Computer memory
  code_attempts = []
  feedbacks = []
  feedback = []

  # turn loop
  turn = 1

  while turn < 13 do
    # codebreaker
    if player == "codebreaker"
      puts col_hash
      puts "valid code: <colour>, <colour>, <colour>, <colour>"
      code_attempt = gets.chomp.gsub(" ", "").split(",")
      code_attempt.map! {|numb| numb.to_i}
    
    elsif player == "codemaster" && code_attempts.empty?
      code_attempt = [rand(6), rand(6), rand(6), rand(6)]

    elsif player == "codemaster"
      # read
      for i in 0..3
        code_colour = code_colours[code_attempt[i] - 1]

        case feedback[i]
        when 0
          code_colour.ruled_out = true
        when 1
          next if code_colour.confirmed.include?(i)
          code_colour.confirmed << i
        when 2
          code_colour.attempted << i
        end

      end

      # write

      for i in 0..3
        if feedback[i] == 1
          next
        else
          attemptable = code_colours.select {|colour| !colour.ruled_out}
          attemptable = attemptable.select {|colour| !colour.attempted.include?(i)}

          best_number = attemptable.reduce do |acc, colour|
            acc.attempted.count > colour.attempted.count ? acc : colour
          end

          code_attempt[i] = best_number.code_number  
        end
      end
    end

    # Update board
    board.decoding_board = board.add_guess(turn, code_attempt)
    feedback = process_feedback(secret_code, code_attempt)
    board.decoding_board = board.add_feedback(turn, feedback)
    puts board.decoding_board

    # win?
    break if code_attempt == secret_code;
    
    # turn end
    turn += 1
    p "turn end"
    p feedback
  end

  # Round end

  # determine win or loss
  end_message = "none"

  if turn < 12
    end_message = <<~WIN
    You win!
    The code was #{secret_code}.
    You cracked it in #{turn} turns.
    WIN
  elsif turn == 12
    end_message = <<~LOSE
    You lose!
    Better luck next time!
    The code was #{secret_code}
    LOSE
  end

  puts end_message

  # Try again
  loop do
    puts <<~RETRY
    Would you like to play again?
    'y' or 'n'?
    RETRY

    retry_answer = gets.chomp.downcase

    if retry_answer == 'y'
      code_colours = [
        red = Colour.new("red", 1), 
        blue = Colour.new("blue", 2), 
        green = Colour.new("green", 3), 
        yellow = Colour.new("yellow", 4), 
        orange = Colour.new("orange", 5), 
        purple = Colour.new("purple", 6)
        ]
      break
    elsif retry_answer == 'n'
      game_over = true
      break
    else
      puts "Invalid. Please enter either 'y' or 'n'."
    end
  end
end
