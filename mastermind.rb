start_instructions = <<~INSTRUCTIONS
Welcome to Mastermind!
INSTRUCTIONS

colour_hash = {
  "1": "red",
  "2": "blue",
  "3": "green",
  "4": "yellow",
  "5": "orange",
  "6": "purple"
}

code_pegs = [1, 2, 3, 4, 5, 6]
key_pegs = [0, 1]

codebreaker = "player"
codemaster = "PC"
player = codemaster

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

def add_guess(board, row, guess)
  row += 1
  new_row = "| #{guess[0]} #{guess[1]} #{guess[2]} #{guess[3]} | _ _ _ _ |"

  board_rows = board.split("\n")
  board_rows[row] = board_rows[row].replace new_row
  board = board_rows.join("\n")
end

def add_feedback(board, row, feed)
  row += 1
  to_replace = " _ _ _ _ "
  replacement = " #{feed[0]} #{feed[1]} #{feed[2]} #{feed[3]} "

  board_rows = board.split("\n")
  board_rows[row].gsub!(to_replace, replacement)
  board_rows = board_rows.join("\n")
end

# Board str is only a representation of data
# Keep data elsewhere
# Retrieve data elsewhere

game_over = false

# Start game
while !game_over do
  decoding_board = <<~BOARD
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

  puts start_instructions
  # puts decoding_board
  # puts colour_hash

  # puts "Codemaster, please enter your secret code now"
  # puts "valid code: colour, colour, colour, colour"
  # secret_code = gets.chomp

  secret_code = [rand(6), rand(6), rand(6), rand(6)]


  # turn loop
  turn = 1

  while turn < 13 do 
    # codebreaker turn
    puts colour_hash
    puts "valid code: <colour>, <colour>, <colour>, <colour>"
    code_attempt = gets.chomp.gsub(" ", "").split(",")
    code_attempt.map! {|numb| numb.to_i}

    decoding_board = add_guess(decoding_board, turn, code_attempt)

    # codemaster turn
    # feedback = gets.chomp.gsub(" ", "").split(",")
    feedback = process_feedback(secret_code, code_attempt)
    decoding_board = add_feedback(decoding_board, turn, feedback)
    
    puts decoding_board
    break if code_attempt == secret_code;
    turn += 1
    p "turn end"
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
      break
    elsif retry_answer == 'n'
      game_over = true
      break
    else
      puts "Invalid. Please enter either 'y' or 'n'."
    end
  end
end
