# Jack Anderson
# jja54@pitt.edu
# CS1632 - Software Quality Assurance, Spring 2019
# Professor Bill Laboon

require 'minitest/autorun'
require_relative 'town'

# This is a MiniTest test file. It will test the Town class in town.rb and game.rb
class TownTest < Minitest::Test
  def test_town_is_town
    town = Town.new
    assert town.is_a?(Town)
  end

  def test_town_new_not_nil
    town = Town.new
    refute_nil town
  end

  def test_town_initialize_variables
    town = Town.new('Town Name', 5, 2)
    assert_equal 'Town Name', town.name
    assert_equal 5, town.rubies
    assert_equal 2, town.fake_rubies
  end

  def test_town_add_edge
    town = Town.new
    town2 = Town.new
    town.add_edge(town2)
    assert_equal town2, town.adjacent_towns[0]
  end
end
