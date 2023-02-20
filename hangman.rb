class Hangman
  
  attr_accessor :guess

  def initialize
    @guess = 1
  end
  
  def rules
    puts <<-TEXT
    \n
    In this game you have 10 turns to guess a word. A correct guess will give 
    you an extra turn, but if you have ten incorrect guesses, it's Game Over. 
    The word will be chosen randomly and will be between 5 and 12 letters long. 
    Each turn you will choose a letter or guess the word. If the word contains 
    your chosen letter, that letter will replace the blank space where it is 
    located. You will win when you either fill in the blanks or guess the word.
    Good Luck.\n\n
    TEXT
  end

  def choice
    rules
    print "Choose 1 to start the game: "
    input = gets.chomp.to_i
    player
  end

  def player
    chosen_word = random_word
    puts chosen_word
  end

  def random_word
    words = []
    word_list = File.read('google_10000_english_no_swears.txt')

    word_list.each_line do |word|
      word = word.chomp
      if word.length > 4 && word.length < 13
        words.push(word)
      end
    end
    words.sample
  end
  
end

play = Hangman.new
play.choice