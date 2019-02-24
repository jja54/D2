# Jack Anderson
# jja54@pitt.edu
# CS1632 - Software Quality Assurance, Spring 2019
# Professor Bill Laboon

require 'minitest/autorun'
require_relative 'town'

# This is a MiniTest test file. It will test the Town class in town.rb and game.rb
class TownTest < Minitest::Test
  # UNIT TESTS FOR METHOD intialize(name, rubies, fake_rubies)

  # A newly created Town object should be a Town object
  def test_town_is_town
    town = Town.new
    assert town.is_a?(Town)
  end

  # A town created with no parameters should hold the correct defaults
  def test_town_defaults
    town = Town.new
    assert_equal 'DEFAULT_NAME', town.name
    assert_equal 0, town.rubies
    assert_equal 0, town.fake_rubies
  end

  # A newly created Town object should not return a nil reference
  def test_town_new_not_nil
    town = Town.new
    refute_nil town
  end

  # When initalizing the Town object, the passed in parameters
  # should be able to be accessed after at any time  
  def test_town_initialize_variables
    town = Town.new('Town Name', 5, 2)
    assert_equal 'Town Name', town.name
    assert_equal 5, town.rubies
    assert_equal 2, town.fake_rubies
  end

  # UNIT TEST FOR METHOD add_edge(town)

  # When adding a new edge to a Town, the new city should
  # appear as the last object in the Town's adjacent_towns array
  def test_town_add_edge
    town = Town.new
    town2 = Town.new
    town.add_edge(town2)
    assert_equal town2, town.adjacent_towns[0]
  end
end
