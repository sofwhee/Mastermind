decoding_board = "string"

colour_list = "1 = blue, 2 = red..."
code_pegs = [1, 2, 3, 4, 5, 6]
key_pegs = [0, 1]

codebreaker = "player"
codemaster = "PC"
player = codemaster

# Start game
puts (start_instructions)

# First turn codemaster
puts (colour_list)
secret_code = gets.chomp
# valid code: [colour, colour, colour, colour]

# Loop turns
12.times do 
  # codebreaker turn
  puts (decoding_board)
  code_attempt = gets.chomp
  decoding_board = "add code attempt to board"

  # codemaster turn
  puts (decoding_board)
  feedback = gets.chomp
  decoding_board = "add feedback to board"
end
