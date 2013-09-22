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
    puts "Was the letter in the word? If so, put what places (e.g. '2 4'), if not just hit enter:"
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
    letter = select_letter
    puts "I'm guess #{letter}"
    @used_letters << letter
    
    
    puts @possible_words
    
    letter
  end
  
  def select_letter
    init_possible_words if @possible_words.nil?
    get_most_freq_letter
  end

  def init_possible_words
    @possible_words = @dictionary.select do |word|
      @guessed_word.length == word.length
    end    
  end

  def get_most_freq_letter
    reduce_possible_words
    
    highest_letter_count = [0, nil]
    letters_left = @possible_words.join('').each_char.select { |letter| !@used_letters.include?(letter) }
    letters_left.each do |letter|
      if letters_left.count(letter) > highest_letter_count[0]
        highest_letter_count = [letters_left.count(letter), letter]
      end
    end
    p highest_letter_count[1], ":     ", highest_letter_count[0]
    highest_letter_count[1]
  end

  def reduce_possible_words
    @possible_words = @possible_words.select do |word|
      possible_match?(word)
    end
  end

  def possible_match? possible_word
    @guessed_word.each_char.with_index do |char, ind|
      return false if (char != '_' and char != possible_word[ind])
      if @used_letters.include?(possible_word[ind]) and char != possible_word[ind]
        return false
      end
    end
    
    true
  end


  def update_known known_so_far
    @guessed_word = known_so_far
  end


  def respond letter
    if @selected_word.include?(letter)
      puts "#{letter} is was in the word"
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

game = Hangman.new(hum, comp)

game.play

