# frozen_string_literal: true

require 'open-uri'
require 'json'

class GamesController < ApplicationController
  VOWELS = %w[A E I O U Y].freeze

  def new
    @letters = VOWELS.sample(5)
    @letters += (('A'..'Z').to_a - VOWELS).sample(5)
    @letters.shuffle!
    @start_time = Time.now
  end

  def score
    start_time = params[:start_time].to_time
    end_time = Time.now
    @elapsed_t = (end_time - start_time).ceil(2)
    @score = 0

    @word = params[:attempt].upcase
    @grid = params[:grid]
    @in_grid = attempt_in_grid?(@word, @grid)
    @in_dictionary = attempt_in_dictionary?(@word)
  end

  private

  def attempt_in_grid?(word, grid)
    word.chars.all? { |letter| word.count(letter) <= grid.count(letter) }
  end

  def attempt_in_dictionary?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    dictionary = open(url).read
    word = JSON.parse(dictionary)
    word['found']
  end
end
