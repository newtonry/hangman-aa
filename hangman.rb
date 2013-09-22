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
      puts @chooser.guessed_word
      
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
  attr_reader :guessed_word, :selected_word

  def initialize
    @dictionary = load_dictionary
    @selected_word = nil
    @guessed_word = nil
  end


  def guess
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

game = Hangman.new(hum, hum)

game.play

