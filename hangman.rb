require 'yaml'

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
    print "Choose 1 to start the game or 2 to load a saved game: "
    input = gets.chomp.to_i
    until (input == 1) || (input == 2) do
      print "Choose 1 to start the game or 2 to load a saved game: "
      input = gets.chomp.to_i
    end

    if input == 1
      game
    elsif input == 2
      # load the saved file and start the game.
      load_game
      game
      # delete the saved file after it has been loaded into the game.
      File.delete("saves/save.yaml") if File.exist?("saves/save.yaml")
    end
  end

  def game
    loop do
      # check if you have won or lost.
      if @hidden_word == @chosen_word
        puts "Congratulations, You Win!"
        puts "The hidden word was #{@hidden_word}."
        break
      elsif @turn == 10
        puts "Sorry, that was your final turn. You Lose!"
        puts "The hidden word was #{@chosen_word}."
        break
      end

      # display your incorrect guesses.
      puts "Incorrect Guesses: " + @wrong_guesses + "\n\n"
      puts @hidden_word
      print "Choose a letter: "
      input = gets.chomp.downcase

      # save the game and then exit the code.
      if input == "save"
        puts "\nYour game has been saved, Goodbye."
        save_game
        exit!
      end

      # check for only 1 letter in the input.
      if input.length != 1
        puts "\nPlease choose a letter.\n\n"
        puts "Incorrect Guesses: " + @wrong_guesses + "\n\n"
        puts @hidden_word
        print "Choose a letter: "
        input = gets.chomp.downcase
      end

      # correct letters will replace a blank space in the hidden word at the correct position.
      # incorrect letters will be added to wrong guesses.
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

  # open a text file and randomly select a word.
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
  
  # create a directory, open a file and write the chosen strings to the file.
  def save_game
    Dir.mkdir 'saves' unless Dir.exist? 'saves'
    yaml = YAML::dump(
      'turn' => @turn,
      'chosen_word' => @chosen_word,
      'hidden_word' => @hidden_word,
      'wrong_guesses' => @wrong_guesses
    )
    File.open("saves/save.yaml", 'w') { |file| file.write yaml }
  end

  # open the saved file and replace the game strings with the saved strings.
  def load_game
    file = YAML.safe_load(File.read("saves/save.yaml"))
    @turn = file['turn']
    @chosen_word = file['chosen_word']
    @hidden_word = file['hidden_word']
    @wrong_guesses = file['wrong_guesses']
  end

end

play = Hangman.new
play.choice