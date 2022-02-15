# frozen_string_literal: true

# The Mastermind class represents the game of mastermind
# and includes data and methods pertinent to gameplay
class Mastermind
  attr_reader :num_guesses

  def initialize(code, num_guesses)
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

# The Computer class represents the opponent of the
# user; the codebreaker of the user's code.
class Computer
  def initialize
    @code = []
    @keys = 0
    @next_number = 0
    @permutations = []
  end

  def guess
    puts "\nComputer Guess: #{make_guess.join}"
    print 'Enter number of black keys >>> '
    black_keys = gets.chomp.to_i
    return true if black_keys == 4

    print 'Enter number of white keys >>> '
    white_keys = gets.chomp.to_i
    new_keys = black_keys + white_keys - @keys
    @keys += new_keys
    @code += Array.new(new_keys, @next_number)
    @next_number += 1
  end

  def make_guess
    if @keys == 4
      if @permutations.empty?
        @code.permutation.each do |permutation|
          @permutations.push(permutation)
        end
      end
      return @permutations.shift
    end
    next_number_array = Array.new(4 - @keys, @next_number.to_s)
    @code + next_number_array
  end
end

def pregame_settings
  puts "\nHello! Welcome to Mastermind!"
  print "\nWould you like to be the codemaker [0] or the codebreaker [1]? >>> "
  player_role = gets.chomp.to_i
  print 'Select the difficulty: expert [0], hard [1], medium [2], easy [3] >>> '
  difficulty = gets.chomp.to_i
  [player_role, difficulty]
end

def player_breaker(difficulty)
  mastermind = Mastermind.new(Array.new(4) { rand(6).to_s }, difficulty)

  mastermind.num_guesses.times do
    print "\nEnter your guess >> "
    breaker_guess = gets.chomp.split('')
    keys = mastermind.check_code(breaker_guess)
    return 'You win!' if keys[0] == 4

    puts "Black Keys: #{keys[0]}\nWhite Keys: #{keys[1]}\n\n"
  end

  'You lose...'
end

def player_maker(difficulty)
  computer = Computer.new

  difficulty.times do
    return 'Computer Wins...' if computer.guess == true
  end
  'You win!'
end

def main
  settings = pregame_settings
  difficulty = 6 + (settings[1] * 2)
  settings[0] == 1 ? player_breaker(difficulty) : player_maker(difficulty)
end

puts main
