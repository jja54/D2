# Jack Anderson
# jja54@pitt.edu
# CS1632 - Software Quality Assurance, Spring 2019
# Professor Bill Laboon

require 'minitest/autorun'
require_relative 'game'
require_relative 'town'

# This is a MiniTest test file. It will test the Game class in ruby_rush.rb
class GameTest < MiniTest::Test
  # UNIT TEST FOR METHOD populate_world
  # populate_world should return the same
  # start town with the same start data every time.
  # As such, it does not lend itself to equivalence
  # class partioning
  def test_populate_world
    game = Game.new
    start_town = game.populate_world

    assert start_town.is_a?(Town)
    assert_equal 'Enumerable Canyon', start_town.name
    assert_equal 1, start_town.rubies
    assert_equal 1, start_town.fake_rubies
    assert_equal 2, start_town.adjacent_towns.count
  end
  # ------------------------------------------

  # UNIT TESTS FOR METHOD prospect(town, prng)
  # Equivalence classes:
  # x= -INFINITY..-1 -> returns -x
  # x= 0..INFINITY -> returns x
  # x= (not a number) -> returns nil

  # The rubies array returned should not be nil
  def test_prspct_rubies_not_nil
    game = Game.new
    town = game.populate_world
    prng = Random.new
    rubies = game.prospect(town, prng)
	refute_nil rubies
  end

  # The rubies[0] variable returned should be >= 0 and
  # not exceed the amount of rubies specified for the town
  def test_prspct_rubies_count
    game = Game.new
    town = game.populate_world
    prng = Random.new
    rubies = game.prospect(town, prng)
	assert(rubies[0] > -1 && rubies[0] <= town.rubies) 
  end

  # The rubies[1] variable returned should be >= 0 and
  # not exceed the amount of fake rubies specified for the town
  def test_prspct_fake_rubies_count
    game = Game.new
    town = game.populate_world
    prng = Random.new
    rubies = game.prospect(town, prng)
	assert(rubies[1] > -1 && rubies[1] <= town.fake_rubies) 
  end
  # ------------------------------------------

  # UNIT TESTS FOR METHOD move_town(town, prng)
  # Equivalence classes:
  # town= (valid town) -> returns (any in town.adjacent_towns)

  # The next town chosen should be one of the towns
  # in the current town's adjacent_towns list
  def test_move_is_valid_town
    game = Game.new
    town = game.populate_world
    prng = Random.new
    next_town = game.move_town(town, prng)
    assert(town.adjacent_towns.any? { |adj_town| adj_town == next_town })
  end
  # The next town chosen should allow for travel back
  # to the town from which it came (undirected graph)
  def test_move_back_possible
    game = Game.new
    town = game.populate_world
    prng = Random.new
    next_town = game.move_town(town, prng)
    assert(next_town.adjacent_towns.any? { |adj_town| adj_town == town })
  end
  # ------------------------------------------

end
