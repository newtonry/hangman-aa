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
      puts @chooser.selected_word
      puts @chooser.guessed_word
      
      @chooser.respond( @guesser.guess )
      
      break if @chooser.guessed_word == @chooser.selected_word
    end
    
    puts "Congrats! It took #{num_guesses} guesses!"
    
  end
end


class HumanPlayer
  def initialize
    @selected_word = nil
    @guessed_word = nil    
    @used_letters = []
  end

  # def guess
  #   letter = prompt_guess
  # end
  
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
  
  def respond
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

game = Hangman.new(comp, hum)

game.play

