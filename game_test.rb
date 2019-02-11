# Jack Anderson
# jja54@pitt.edu
# CS1632 - Software Quality Assurance, Spring 2019
# Professor Bill Laboon

require 'minitest/autorun'
require_relative 'game'
require_relative 'town'

# This is a MiniTest test file. It will test the Game class in ruby_rush.rb
class GameTest < MiniTest::Test
  def test_populate_world
    game = Game.new
    start_town = game.populate_world

    assert start_town.is_a?(Town)
    assert_equal 'Enumerable Canyon', start_town.name
    assert_equal 1, start_town.rubies
    assert_equal 1, start_town.fake_rubies
    assert_equal 2, start_town.adjacent_towns.count
  end

  def test_prospect
    game = Game.new
    rubies_count = 2
    town = Town.new('Dynamic Palisades', rubies_count, rubies_count)
    prng = Random.new(seed * prospect_num)
    rubies = game.prospect(town, prng)

    assert_not_nil rubies
    assert_equal rubies.size, 2
    assert_block do
      rubies.any? { |num| num > -1 && num <= rubies_count }
    end
  end
end
