require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    @started_at = Time.current.to_i
    @letters = Array.new(10) { ("a".."z").to_a.sample }
  end

  def score
    @guess = params[:guess]
    @token = params[:token]
    elapsed_seconds = Time.current.to_i - params[:started_at].to_i

    token_array = @token.split("")


    def run_game(attempt, grid, elapsed_seconds)
      grid.map!(&:downcase)
      attempt.downcase!
      attempt_serialized = URI.parse("https://dictionary.lewagon.com/#{attempt}").read
      parsed_attempt = JSON.parse(attempt_serialized)
      final_score = calcucalate_score(parsed_attempt, elapsed_seconds)
      if parsed_attempt["found"] == false
        return { score: 0, message: "Not an english word", time: elapsed_seconds }
      elsif check_grid(grid, attempt) == false
        return { score: 0, message: "Not in the grid", time: elapsed_seconds }
      else
        return { score: final_score, message: "Well done", time: elapsed_seconds }
      end
    end

    def calcucalate_score(parsed_attempt, elapsed_seconds)
      if parsed_attempt.key?("length")
        time = elapsed_seconds
        lenght = parsed_attempt["length"]
        final_score = (lenght / time.to_f) * Math::PI
        return final_score
      end
    end

    def check_grid(grid, attempt)
      arr_attempt = attempt.chars
      arr_attempt.each do |letter|
        if grid.include?(letter)
          grid.delete_at(grid.index(letter))
        else
          return false
        end
      end
    end

    start_time = 2
    end_time = 10

    @result = run_game(@guess, token_array, elapsed_seconds)

  end
end
