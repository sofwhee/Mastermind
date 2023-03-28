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

fake_code = [1, 2, 3, 4]
fake_guess = [1, 2, 3, 4]

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

feedback = process_feedback(fake_code, fake_guess)

p feedback

