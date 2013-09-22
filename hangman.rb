class Hangman
  def initialize(chooser, guesser)
    @chooser = chooser
    @guesser = guesser
  end
  
  def play
    @chooser.get_word
    
    while true
      puts @chooser.selected_word
      puts @chooser.guessed_word 
      break
    end
    
  end
end


class HumanPlayer
  def initialize
    @selected_word = nil
    @guessed_word = nil    
  end

  def guess
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

