# frozen_string_literal: true

# The Mastermind class represents the game of mastermind
# and includes data and methods pertinent to gameplay
class Mastermind
  attr_reader :num_guesses
  attr_writer :code

  def initialize(code)
    @code = code
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
end

# The Computer class represents the opponent of the
# user; the codebreaker of the user's code.
class Computer
  attr_reader :code_set

  def initialize
    @board = Mastermind.new(Array.new(4, 0))
    @code_set = []
    (0...6).each do |i|
      (0...6).each do |j|
        (0...6).each do |k|
          (0...6).each { |l| @code_set.push("#{i}#{j}#{k}#{l}") }
        end
      end
    end
  end

  def guess
    guess = @code_set.length == 1296 ? @code_set.slice!(266) : @code_set.shuffle.shift
    return false if guess.nil?

    @board.code = guess.split('')
    puts "\nComputer Guess: #{guess}"
    keys = award_keys
    return true if keys == true

    update_set(keys[0], keys[1])
  end

  def award_keys
    print 'Enter number of black keys >>> '
    black_keys = gets.chomp.to_i
    return true if black_keys == 4
    print 'Enter number of white keys >>> '
    white_keys = gets.chomp.to_i
    [black_keys, white_keys]
  end

  def update_set(black_keys, white_keys)
    filtered_set = []
    @code_set.each do |code|
      keys = @board.check_code(code.split(''))
      filtered_set.push(code) if keys[0] == black_keys && keys[1] == white_keys
    end
    @code_set = filtered_set
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
  mastermind = Mastermind.new(Array.new(4) { rand(6).to_s })

  difficulty.times do
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
    return 'You changed the code...' if computer.guess == false
  end
  'You win!'
end

def main
  settings = pregame_settings
  difficulty = 6 + (settings[1] * 2)
  settings[0] == 1 ? player_breaker(difficulty) : player_maker(difficulty)
end

puts main
