class Hangman
  
  attr_accessor :turn
  attr_accessor :hidden_word
  attr_accessor :chosen_word
  attr_accessor :wrong_guesses

  def initialize
    @turn = 0
    @chosen_word = random_word_generator
    @hidden_word = ""
    @chosen_word.length.times { @hidden_word += "_" }
    @wrong_guesses = ""
  end
  
  def rules
    puts <<-TEXT
    \n
    In this game you have 10 turns to guess a word. A correct guess will give 
    you an extra turn, but if you have ten incorrect guesses, it's Game Over. 
    The word will be chosen randomly and will be between 5 and 12 letters long. 
    Each turn you will choose a letter. If the word contains your chosen letter,
    that letter will replace the blank space where it is located. You will win 
    when you either fill in the blanks or guess the word.
    Good Luck.\n\n
    TEXT
  end

  def choice
    rules
    print "Choose 1 to start the game: "
    input = gets.chomp.to_i
    game
  end

  def game
    
    loop do
      if @hidden_word == @chosen_word
        puts "Congratulations, You Won!"
        puts "The hidden word was #{@hidden_word}."
        break
      elsif @turn == 10
        puts "Sorry, that was your final turn. You Lost!"
        puts "The hidden word was #{@chosen_word}."
        break
      end

      puts "Incorrect Guesses: " + @wrong_guesses + "\n\n"
      puts @hidden_word
      print "Choose a letter: "
      input = gets.chomp.downcase
      
      if @hidden_word != @chosen_word && @chosen_word.include?(input)
        @chosen_word.split('').each_with_index do |char, idx|
          @hidden_word[idx] = input if char == input
        end
        puts "\nCorrect, that letter is in the word.\n\n"
      else
        puts "\nThat letter is not in the word.\n\n"
        @wrong_guesses += input
        @turn += 1
      end
    end
  end
 
  def random_word_generator
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