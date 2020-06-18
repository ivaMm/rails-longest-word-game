require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = ("A".."Z").to_a.sample(10)
  end

  def score
  	# raise
  	@word = params[:attempt].upcase
  	@grid = params[:grid]

    if attempt_in_grid?(@word, @grid)
      if attempt_in_dictionary?(@word)
        @msg = "Congratulation! #{@word} is a valid English word."
      else
        @msg = "Sorry but #{@word} is not an English word." 
      end
    else
      @msg = "Sorry, but #{@word} can’t be built out of #{@grid}."
    end
  end

  private

  def attempt_in_grid?(word, grid)
  	word.chars.sort.all? { |letter| word.count(letter) <= grid.count(letter) }
  end

  def attempt_in_dictionary?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    dictionary = open(url).read
    word = JSON.parse(dictionary)
    word["found"]
  end
end
