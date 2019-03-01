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
  # town.rubies= 0..INFINITY -> returns rubies array where 0 <= rubies[0] <= town.rubies
  # town.fake_rubies= 0..INFINITY -> returns rubies array where 0 <= rubies[1] <= town.fake_rubies
  # town= (not Town object) -> NoMethodError

  # The rubies array returned should not be nil
  def test_prspct_rubies_not_nil
    game = Game.new
    town = Minitest::Mock.new("town") # Mock of the town class that just holds rubies/fakes
    def town.rubies; 2; end
    def town.fake_rubies; 3; end
    prng = Random.new
    rubies = game.prospect(town, prng)
    refute_nil rubies
  end

  # The rubies[0] variable returned should be >= 0 and
  # not exceed the amount of rubies specified for the town
  def test_prspct_rubies_count
    game = Game.new
    town = Minitest::Mock.new("town") # Mock of the town class that just holds rubies/fakes
    def town.rubies; 2; end
    def town.fake_rubies; 3; end
    prng = Random.new
    rubies = game.prospect(town, prng)
    assert(rubies[0] > -1 && rubies[0] <= town.rubies) 
  end

  # The rubies[1] variable returned should be >= 0 and
  # not exceed the amount of fake rubies specified for the town
  def test_prspct_fake_rubies_count
    game = Game.new
    town = Minitest::Mock.new("town") # Mock of the town class that just holds rubies/fakes
    def town.rubies; 2; end
    def town.fake_rubies; 3; end
    prng = Random.new
    rubies = game.prospect(town, prng)
    assert(rubies[1] > -1 && rubies[1] <= town.fake_rubies) 
  end

  # Passing in an invalid town parameter to the prospect method
  # should throw a "NoMethodError" as it will try to access
  # variables and methods that only exist for the Town class
  def test_prspct_invalid_town
    game = Game.new
    town = 'This is not a town'
    prng = Random.new
    assert_raises NoMethodError do
      rubies = game.prospect(town, prng)
    end
  end

  # Passing in an invalid Random Number Generator to the prospect
  # method should raise a "RuntimeError" caught by the first line
  def test_prspct_invalid_prng
    game = Game.new
    town = Minitest::Mock.new("town") # Mock of the town class that just holds rubies/fakes
    def town.rubies; 2; end
    def town.fake_rubies; 3; end
    prng = 0
    assert_raises RuntimeError do
      game.prospect(town, prng)
    end
  end
  # ------------------------------------------

  # UNIT TESTS FOR METHOD move_town(town, prng)
  # Equivalence classes:
  # town= (valid Town) && prng= (valid Random) -> returns (any in town.adjacent_towns)
  # town= (not Town object) -> NoMethodError
  # prng= (not Random object) -> RuntimeError (raised)

  # The next town chosen should be one of the towns
  # in the current town's adjacent_towns list
  def test_move_is_valid_town
    game = Game.new
    # Mocks cannot be used here as creating 2 Mocks to represent towns
    # with an adjacent_towns method that returns an array with the other
    # town in it does not work as "town.adjacent_towns.size" (called in
    # move_town) throws a NoMethodError when running the tests	
    town = Town.new('Test Town', 1, 1)
    town_two = Town.new('Test City', 2, 2)
	town.add_edge(town_two)
	town_two.add_edge(town)
    # Because actual Town objects need to be made and addEdge is used,
    # this test is rather brittle
    prng = Random.new
    next_town = game.move_town(town, prng)
    assert(town.adjacent_towns.any? { |adj_town| adj_town == next_town })
  end

  # The next town chosen should allow for travel back
  # to the town from which it came (undirected graph)
  def test_move_back_possible
    game = Game.new
	# See above for comments on why real town objects are used here 
    town = Town.new('Test Town', 1, 1)
    town_two = Town.new('Test City', 2, 2)
	town.add_edge(town_two)
	town_two.add_edge(town)
    prng = Random.new
    next_town = game.move_town(town, prng)
    assert(next_town.adjacent_towns.any? { |adj_town| adj_town == town })
  end

  # Passing in an invalid town parameter to the move_town method
  # should throw a "NoMethodError" as it will try to access
  # variables and methods that only exist for the Town class
  def test_move_invalid_town
    game = Game.new
    town = 'This is not a town'
    prng = Random.new
    assert_raises NoMethodError do
      next_town = game.move_town(town, prng)
    end
  end

  # Passing in an invalid Random Number Generator to the move_town
  # method should raise a "RuntimeError" caught by the first line
  def test_move_invalid_prng
    game = Game.new
    town = Town.new('Test Town', 1, 1)
    town_two = Town.new('Test City', 2, 2)
	town.add_edge(town_two)
    prng = 0
    assert_raises RuntimeError do
      game.move_town(town, prng)
    end
  end

  # ------------------------------------------

  # UNIT TESTS FOR METHOD print_rubies_found(rubies_found, fake_rubies_found, town)
  # Equivalence classes:
  # rubies=fake_rubies= 0 -> prints none found
  # rubies=fake_rubies= 1 -> prints 1 ruby/1 fake ruby (singular)
  # rubies=fake_rubies= 2..INFINITY -> prints x rubies/fake rubies (plural)
  # rubies=fake_rubies= -INFINITY..-1 -> raises exception

  # If zero rubies and fake rubies are found, the method
  # should print the amount found appropriately
  def test_print_found_zero
    game = Game.new
    town = Minitest::Mock.new("town") # Mock of the town class that just holds a name
    def town.name; 'Test Town'; end
    rubies_found = 0
    fake_rubies_found = 0
	assert_output("\tFound no rubies or fake rubies in #{town.name}.\n") { game.print_rubies_found(rubies_found, fake_rubies_found, town) }
  end

  # If one ruby and zero fake rubies are found, the method
  # should print the amount found appropriately
  def test_print_found_one_ruby
    game = Game.new
    town = Minitest::Mock.new("town") # Mock of the town class that just holds a name
    def town.name; 'Test Town'; end
    rubies_found = 1
    fake_rubies_found = 0
    assert_output("\tFound 1 ruby in #{town.name}.\n") { game.print_rubies_found(rubies_found, fake_rubies_found, town) }
  end

  # If zero rubies and one fake ruby are found, the method
  # should print the amount found appropriately
  def test_print_found_one_fake_ruby
    game = Game.new
    town = Minitest::Mock.new("town") # Mock of the town class that just holds a name
    def town.name; 'Test Town'; end
    rubies_found = 0
    fake_rubies_found = 1
    assert_output ("\tFound 1 fake ruby in #{town.name}.\n") { game.print_rubies_found(rubies_found, fake_rubies_found, town) }
  end

  # If one ruby and one fake ruby are found, the method
  # should print the amount found appropriately
  def test_print_found_one_each
    game = Game.new
    town = Minitest::Mock.new("town") # Mock of the town class that just holds a name
    def town.name; 'Test Town'; end
    rubies_found = 1
    fake_rubies_found = 1
    assert_output ("\tFound 1 ruby and 1 fake ruby in #{town.name}.\n") { game.print_rubies_found(rubies_found, fake_rubies_found, town) }
  end
  
  # If > one rubies and zero fake rubies are found, the method
  # should print the amount found appropriately
  def test_print_found_many_ruby
    game = Game.new
    town = Minitest::Mock.new("town") # Mock of the town class that just holds a name
    def town.name; 'Test Town'; end
    rubies_found = 2
    fake_rubies_found = 0
    assert_output ("\tFound #{rubies_found} rubies in #{town.name}.\n") { game.print_rubies_found(rubies_found, fake_rubies_found, town) }
  end

  # If zero rubies and > one fake rubies are found, the method
  # should print the amount found appropriately
  def test_print_found_many_fake_ruby
    game = Game.new
    town = Minitest::Mock.new("town") # Mock of the town class that just holds a name
    def town.name; 'Test Town'; end
    rubies_found = 0
    fake_rubies_found = 2
    assert_output ("\tFound #{fake_rubies_found} fake rubies in #{town.name}.\n") { game.print_rubies_found(rubies_found, fake_rubies_found, town) }
  end

  # If > one rubies and > one fake rubies are found, the method
  # should print the amount found appropriately
  def test_print_found_many_each
    game = Game.new
    town = Minitest::Mock.new("town") # Mock of the town class that just holds a name
    def town.name; 'Test Town'; end
    rubies_found = 2
    fake_rubies_found = 2
    assert_output ("\tFound #{rubies_found} rubies and
        #{fake_rubies_found} fake rubies in #{town.name}.\n") { game.print_rubies_found(rubies_found, fake_rubies_found, town) }
  end

  # Passing in a negative value for either ruby count to the method
  # should raise a RuntimeError (caught) as ruby counts can not be negative
  # EDGE CASE
  def test_print_negatives_exception
    game = Game.new
    town = Minitest::Mock.new("town") # Mock of the town class that just holds a name
    def town.name; 'Test Town'; end
    rubies_found = -2
    fake_rubies_found = -2
    assert_raises RuntimeError do
      game.print_rubies_found(rubies_found, fake_rubies_found, town)
    end
  end

  # Passing in an invalid town parameter to the method
  # should throw a "NoMethodError" as it will try to access
  # variables and methods that only exist for the Town class
  def test_print_found_invalid_input
    game = Game.new
    town = 'This is not a town'
    rubies_found = 2
    fake_rubies_found = 2
    assert_raises NoMethodError do
      game.print_rubies_found(rubies_found, fake_rubies_found, town)
    end
  end
  # ------------------------------------------

  # UNIT TESTS FOR METHOD print_rubies_end(days_taken, prospect_num, rubies_found, fake_rubies_found)
  # Equivalence classes:
  # rubies_found=fake_rubies_found= 0 -> prints none found, going home empty-handed
  # rubies_found=fake_rubies_found= 1 -> prints 1 ruby/1 fake ruby (singular), going home sad
  # rubies_found=fake_rubies_found= 2..INFINITY -> prints x rubies/fake rubies (plural)
  # rubies_found= 2..9 -> prints x rubies, going home sad
  # rubies_found= 10..INFINITY -> prints x rubies, going home victorious
  # rubies_found=fake_rubies_found= -INFINITY..-1 -> raises exception

  # If the game ends after one day, with one of each found,
  # the method should print the appropriate line
  def test_print_end_oneday_one_each
    game = Game.new
    town = Minitest::Mock.new("town") # Mock of the town class that just holds a name
    def town.name; 'Test Town'; end
    rubies_found = 1
    fake_rubies_found = 1
    prospect_num = 1
    days_taken = 1
    assert_output ("After 1 day, Rubyist #{prospect_num} found:\n\t1 ruby.\n\t1 fake ruby.\nGoing home sad.\n") { game.print_rubies_end(days_taken, prospect_num, rubies_found, fake_rubies_found) }
  end

  # If the game ends after many days, with many of each found,
  # the method should print the appropriate line
  # BOUNDARY CASE
  def test_print_end_manydays_many_each
    game = Game.new
    town = Minitest::Mock.new("town") # Mock of the town class that just holds a name
    def town.name; 'Test Town'; end
    rubies_found = 10
    fake_rubies_found = 999
    prospect_num = 12
    days_taken = 50
    assert_output ("After #{days_taken} days, Rubyist #{prospect_num} found:\n\t#{rubies_found} rubies.\n\t#{fake_rubies_found} fake rubies.\nGoing home victorious!\n") { game.print_rubies_end(days_taken, prospect_num, rubies_found, fake_rubies_found) }
  end

  # If the game ends after many days, with < 10 rubies found,
  # the method should print the appropriate line
  # BOUNDARY CASE
  def test_print_end_going_home_sad
    game = Game.new
    town = Minitest::Mock.new("town") # Mock of the town class that just holds a name
    def town.name; 'Test Town'; end
    rubies_found = 9
    fake_rubies_found = 1
    prospect_num = 2
    days_taken = 13
    assert_output ("After #{days_taken} days, Rubyist #{prospect_num} found:\n\t#{rubies_found} rubies.\n\t1 fake ruby.\nGoing home sad.\n") { game.print_rubies_end(days_taken, prospect_num, rubies_found, fake_rubies_found) }
  end

  # If the game ends after many days, with 0 rubies found,
  # the method should print the appropriate line
  def test_print_end_going_home_empty
    game = Game.new
    town = Minitest::Mock.new("town") # Mock of the town class that just holds a name
    def town.name; 'Test Town'; end
    rubies_found = 0
    fake_rubies_found = 215
    prospect_num = 2
    days_taken = 1
    assert_output ("After 1 day, Rubyist #{prospect_num} found:\n\t#{rubies_found} rubies.\n\t#{fake_rubies_found} fake rubies.\nGoing home empty-handed.\n") { game.print_rubies_end(days_taken, prospect_num, rubies_found, fake_rubies_found) }
  end

  # Passing in a negative value for either ruby count to the method
  # should raise a RuntimeError (caught) as ruby counts can not be negative
  # EDGE CASE
  def test_print_end_negatives_exception
    game = Game.new
    town = Minitest::Mock.new("town") # Mock of the town class that just holds a name
    def town.name; 'Test Town'; end
    rubies_found = -2
    fake_rubies_found = -2
    prospect_num = 2
    days_taken = 1
    assert_raises RuntimeError do
      game.print_rubies_end(days_taken, prospect_num, rubies_found, fake_rubies_found)
    end
  end
  # ------------------------------------------

  # UNIT TESTS FOR METHOD run(seed, prospects, turns)

  # NOTE: To get 100% code coverage of run, only this one test is required.
  # This is due to the fact that all of the methods in the Game class
  # are called by the run(seed, prospects, turns) method, and those
  # methods have been tested extensively already above. Therefore, partioning
  # and extensive testing of the run method is not necessary.
  # The arguements themselves are protected and tested by the arg_check_test file so that
  # in proper program use it is not possible to pass in invalid arguments.

  # Check that calling the run method prints to the console correctly
  # using a predetermined and tested random number generator seed
  def test_run_outputs_same_with_seed
    game = Game.new
    correct = "Rubyist #1 starting in Enumerable Canyon.\n\tFound 1 fake ruby in Enumerable Canyon.\n\tFound 1 ruby in Enumerable Canyon.\n\tFound 1 ruby and 1 fake ruby in Enumerable Canyon.\n\tFound 1 ruby and 1 fake ruby in Enumerable Canyon.\n\tFound 1 ruby and 1 fake ruby in Enumerable Canyon.\n\tFound 1 ruby in Enumerable Canyon.\n\tFound 1 fake ruby in Enumerable Canyon.\n\tFound no rubies or fake rubies in Enumerable Canyon.\nAfter 8 days, Rubyist 1 found:\n\t5 rubies.\n\t5 fake rubies.\nGoing home sad.\n"
    assert_output (correct) { game.run(0, 1, 1) }
  end
end
