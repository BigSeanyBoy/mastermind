# frozen_string_literal: true

# The Mastermind class represents the game of mastermind
# and includes data and methods pertinent to gameplay
class Mastermind
  attr_reader :num_guesses

  def initialize(code = Array.new(4) { rand(6).to_s }, num_guesses = 12)
    @code = code
    @num_guesses = num_guesses
  end

  def check_code(guess)
    matched = black_key_check(guess)
    if matched
      remaining_code = @code.select.with_index { |_, i| !matched.include?(i) }
      remaining_guess = guess.select.with_index { |_, i| !matched.include?(i) }
    else
      remaining_code = @code.map(&:clone)
      remaining_guess = guess
    end
    [matched.length, white_key_check(remaining_code, remaining_guess)]
  end

  def black_key_check(guess)
    black_keys = []
    @code.each_index do |i|
      black_keys.push(i) if @code[i] == guess[i]
    end
    black_keys
  end

  def white_key_check(code, guess)
    code_tally = code.tally
    guess_tally = guess.tally
    white_keys = 0

    code_tally.each_key do |key|
      guess_tally[key] = 0 unless guess_tally[key]
      white_keys += [code_tally[key], guess_tally[key]].min
    end
    white_keys
  end

  def assign_code(code)
    @code = code
  end
end

def main
  mastermind = Mastermind.new(Array.new(4) { rand(6).to_s }, 6)

  mastermind.num_guesses.times do
    print "\nEnter your guess >> "
    breaker_guess = gets.chomp.split('')
    keys = mastermind.check_code(breaker_guess)
    return 'You win!' if keys[0] == 4

    puts "Black Keys: #{keys[0]}\nWhite Keys: #{keys[1]}\n\n"
  end

  'You lose...'
end

puts main
