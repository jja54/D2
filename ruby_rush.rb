# Jack Anderson
# jja54@pitt.edu
# CS1632 - Software Quality Assurance, Spring 2019
# Professor Bill Laboon

# Town class (node) containing name, amount of rubies or fake rubies
# possible per iteration, as well as an array of connected towns
class Town
  # getters/setters for name, adjacency list
  attr_accessor :name, :adjacent_towns, :rubies, :fake_rubies

  def initialize(name, rubies, fake_rubies)
    @name = name
    @adjacent_towns = []
    @rubies = rubies
    @fake_rubies = fake_rubies
  end

  def add_edge(adjacent_town)
    @adjacent_towns << adjacent_town
  end
end

# Creates the undirected graph map of the game world
def populate_world
  # Create the towns
  enum_c = Town.new('Enumerable Canyon', 1, 1)
  duck_typ = Town.new('Duck Type Beach', 2, 2)
  monk_patch = Town.new('Monkey Patch City', 1, 1)
  nil_town = Town.new('Nil Town', 0, 3)
  matz = Town.new('Matzburg', 3, 0)
  hash_cross = Town.new('Hash Crossing', 2, 2)
  dyn_pal = Town.new('Dynamic Palisades', 2, 2)
  # Now add correct paths
  # Enumerable Canyon
  enum_c.add_edge(monk_patch)
  enum_c.add_edge(duck_typ)
  # Duck Type Beach
  duck_typ.add_edge(enum_c)
  duck_typ.add_edge(matz)
  # Monkey Patch City
  monk_patch.add_edge(nil_town)
  monk_patch.add_edge(matz)
  # Nil Town
  nil_town.add_edge(monk_patch)
  nil_town.add_edge(hash_cross)
  # Matzburg
  matz.add_edge(monk_patch)
  matz.add_edge(hash_cross)
  matz.add_edge(dyn_pal)
  matz.add_edge(duck_typ)
  # Hash Crossing
  hash_cross.add_edge(dyn_pal)
  hash_cross.add_edge(matz)
  hash_cross.add_edge(duck_typ)
  # Dynamic Palisades
  dyn_pal.add_edge(hash_cross)
  dyn_pal.add_edge(matz)
  dyn_pal.add_edge(duck_typ)

  enum_c # Return "Enumerable Canyon" as start node
end

# Search for Rubies for 1 turn
def prospect(town, prng)
  # Existence of at least 1 of either type is implicit
  rubies_possible = town.rubies
  fake_rubies_possible = town.fake_rubies

  # Mine for rubies
  rubies_found = prng.rand(rubies_possible + 1)
  fake_rubies_found = prng.rand(fake_rubies_possible + 1)

  # Return found rubies in an array
  rubies = Array[rubies_found, fake_rubies_found]
  print_rubies_found(rubies_found, fake_rubies_found, town)
  rubies
end

# Print daily rubies found
def print_rubies_found(rubies_found, fake_rubies_found, town)
  if rubies_found.zero? && fake_rubies_found.zero?
    puts "\tFound no rubies or fake rubies in #{town.name}."
  elsif rubies_found == 1 && fake_rubies_found.zero?
    puts "\tFound 1 ruby in #{town.name}."
  elsif rubies_found.zero? && fake_rubies_found == 1
    puts "\tFound 1 fake ruby in #{town.name}."
  elsif rubies_found == 1 && fake_rubies_found == 1
    puts "\tFound 1 ruby and 1 fake ruby in #{town.name}."
  elsif rubies_found > 1 && fake_rubies_found.zero?
    puts "\tFound #{rubies_found} rubies in #{town.name}."
  elsif rubies_found.zero? && fake_rubies_found > 1
    puts "\tFound #{fake_rubies_found} fake rubies in #{town.name}."
  else
    puts "\tFound #{rubies_found} rubies and
	  #{fake_rubies_found} fake rubies in #{town.name}."
  end
end

# Move to the next town
def move_town(town, prng)
  # Pick the next town pseudo-randomly
  towns_possible = town.adjacent_towns.size
  next_town_num = prng.rand(towns_possible)

  # Return the next town
  next_town = town.adjacent_towns[next_town_num]
  next_town
end

# Print end-journey results
def print_rubies_end(days_taken, prospect_num, rubies_found, fake_rubies_found)
  if days_taken == 1
    puts "After 1 day, Rubyist #{prospect_num} found:"
  else
    puts "After #{days_taken} days, Rubyist #{prospect_num} found:"
  end

  if rubies_found == 1
    puts "\t1 ruby."
  else
    puts "\t#{rubies_found} rubies."
  end

  if fake_rubies_found == 1
    puts "\t1 fake ruby."
  else
    puts "\t#{fake_rubies_found} fake rubies."
  end

  case rubies_found
  when 0
    puts 'Going home empty-handed.'
  when 1...9
    puts 'Going home sad.'
  else
    puts 'Going home victorious!'
  end
end

# EXECUTION STARTS HERE
error = "Usage:\nruby gold_rush.rb *seed* *num_prospectors*
 *num_turns*\n*seed* should be an integer\n*num_prospectors*
	should be a non-negative integer\n*num_turns* should be a non-negative integer"
unless ARGV.count == 3
  puts error
  exit(1)
end
seed = ARGV[0].to_i
prospects = ARGV[1].to_i
turns = ARGV[2].to_i
# CHECK IF ALL CAN BE INTERPRETED AS INTS?

# If num of prospectors !>0=, inform the user and exit
unless prospects >= 0
  puts error
  exit(1)
end

# If number of iterations is not an integer that is 0 or greater,
# inform the user and exit
unless turns >= 0
  puts error
  exit(1)
end

puts "seed = #{seed}"
puts "prospects = #{prospects}"
puts "turns = #{turns}"

prospect_num = 1

# Start game loop
(0...prospects).each do
  prng = Random.new(seed * prospect_num) # Create pseudo random num generator
  turns_taken = 0
  days_taken = 0
  rubies_found = 0
  fake_rubies_found = 0
  # Get start town (Enumerable Canyon)
  cur_town = populate_world

  puts "Rubyist ##{prospect_num} starting in #{cur_town.name}."

  while turns_taken < turns
    # Mine for rubies
    rubies = prospect(cur_town, prng)
    # Add found rubies to total
    rubies_found += rubies[0]
    fake_rubies_found += rubies[1]

    # Check if found any rubies or if last turn
    unless rubies[0] > 0 || rubies[1] > 0
      # Move to next town
      next_town = move_town(cur_town, prng)
      turns_taken += 1
      unless turns_taken == turns
        puts "Heading from #{cur_town.name} to #{next_town.name}."
      end
      cur_town = next_town
    end
    days_taken += 1
  end
  # Print out prospecting totals
  print_rubies_end(days_taken, prospect_num, rubies_found, fake_rubies_found)
  # Move on to next prospector (resets game world)
  prospect_num += 1
end

exit(0) # Exit cleanly
