
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

red = Colour.new("red", 1)
blue = Colour.new("blue", 2)
green = Colour.new("green", 3)
yellow = Colour.new("yellow", 4)
orange = Colour.new("orange", 5)
purple = Colour.new("purple", 6)
code_colours = [red, blue, green, yellow, orange, purple]

red.attempted << 0
red.attempted << 1

blue.attempted << 0

purple.attempted << 2
purple.attempted << 1
purple.attempted << 3


best_number = code_colours.reduce do |acc, colour|
  acc.attempted.count > colour.attempted.count ? acc : colour
end

best_number = best_number.name
puts best_number

feedback = [0, 1, 2, 2]

for i in 0..3
  if feedback[i] != 1
    best_number = code_colours.reduce do |acc, colour|
      acc.attempted.count > colour.attempted.count ? acc : colour
    end
    best_number = best_number.name
  end
end