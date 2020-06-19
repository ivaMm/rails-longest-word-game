require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = ("A".."Z").to_a.sample(10)
    @start_time = Time.now
  end

  def score
  	# raise
    date_arr = params[:start_time].split(/-|\s|:/)
    tz = date_arr[-1].insert(3, ":")
    nums = date_arr[0...-1].map { |n| n.to_i }
    start_time = Time.new(nums[0], nums[1], nums[2], nums[3], nums[4], nums[5], tz)
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
    word["found"]
  end
end
