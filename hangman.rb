class Hangman
  def initialize(chooser, guesser)
    @chooser = chooser
    @guesser = guesser
  end
  
  def play
    num_guesses = 0
    @chooser.get_word
    
    while true
      num_guesses += 1
      @chooser.guessed_word
      @guesser.update_known(@chooser.guessed_word)
      p @chooser.guessed_word
      
      
      @chooser.respond( @guesser.guess )
      
      break unless @chooser.guessed_word.include?('_')
    end
    puts @guesser.guessed_word.upcase
    puts "Congrats! It took #{num_guesses} guesses!"    
  end
end


class HumanPlayer
  attr_reader :guessed_word
  
  def initialize
    @selected_word = nil
    @guessed_word = nil    
    @used_letters = []
  end
  

  def guess
    puts "You've used #{@used_letters}:"
    puts "Please enter a new guess:"
    letter = gets.chomp
    
    until is_valid_letter?(letter)
      puts "Please input a valid letter"
      letter = gets.chomp
    end
    
    @used_letters << letter
    letter
  end
  
  def respond letter
    puts "Was the letter #{letter} in the word? If so, put what places (e.g. '2 4'), if not just hit enter:"
    places = gets.chomp()
    fill_in_guessed(places, letter) 
  end
  
  def fill_in_guessed guessed_places, letter
    guessed_places.split(" ").map(&:to_i).each do |place|
      @guessed_word[place - 1] = letter
    end
  end

  def update_known known_so_far
    @guessed_word = known_so_far
  end


  def get_word
    puts "How many letters are in your word"
    num_let = gets.chomp.to_i
    @guessed_word = "_" * num_let
  end

  def is_valid_letter? letter
    return false if !('a'..'z').include?(letter) or @used_letters.include?(letter)
    true
  end
end


class ComputerPlayer
  attr_accessor :guessed_word, :selected_word

  def initialize
    @dictionary = load_dictionary
    @selected_word = nil
    @guessed_word = nil
    @possible_words = nil
    @used_letters = []
  end

  def guess
    get_possible_words if @possible_words.nil?

    update_possibilities
    
    letter = get_most_freq_letter
    @used_letters << letter
    
    letter
  end

  def update_possibilities
    unless @used_letters.empty?
      last_was_in = @guessed_word.include?(@used_letters[-1])
      @possible_words = @possible_words.select do |word|
        word.include?(@used_letters[-1]) == last_was_in and possible_match?(word)
      end
    end  
  end

  def get_most_freq_letter
    frequencies = Hash.new(0)

    (@possible_words.join('').split('') - @used_letters).each do |char|
      frequencies[char] += 1
    end
    
    frequencies.sort_by { |letter, frequency| -frequency }.first.first
  end


  def get_possible_words
    @possible_words = @dictionary.select do |word|
      word.length == @guessed_word.length
    end
  end

  def possible_match? word
    (@guessed_word.length - 1).times do |ind|
      if @guessed_word[ind] != "_" and @guessed_word[ind] != word[ind]
        return false
      end      
      true
    end
  end


  def update_known known_so_far
    @guessed_word = known_so_far
  end


  def respond letter
    if @selected_word.include?(letter)
#      puts "#{letter} is in the word"
      fill_in_guessed letter
    else
      "Sorry, #{letter} was not in the word"
    end
  end

  def fill_in_guessed letter
    @selected_word.each_char.with_index do |let_in_word, ind|
      @guessed_word[ind] = letter if letter == let_in_word
    end
  end

  def get_word
    @selected_word = load_dictionary.sample
    @guessed_word = '_' * @selected_word.length
  end

  def load_dictionary
    File.readlines('dictionary.txt').map(&:chomp)
  end
end


comp = ComputerPlayer.new
hum = HumanPlayer.new

# comp.guessed_word = "_" * 22
# 
# puts comp.select_letter
# puts comp.get_most_freq_letter

game = Hangman.new(comp, comp)

game.play

