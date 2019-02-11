# Jack Anderson
# jja54@pitt.edu
# CS1632 - Software Quality Assurance, Spring 2019
# Professor Bill Laboon

# Town class (node) containing name, amount of rubies or fake rubies
# possible per iteration, as well as an array of connected towns
class Town
  # getters/setters for name, adjacency list
  attr_accessor :name, :adjacent_towns, :rubies, :fake_rubies

  def initialize(name = 'DEFAULT_NAME', rubies = 0, fake_rubies = 0)
    @name = name
    @adjacent_towns = []
    @rubies = rubies
    @fake_rubies = fake_rubies
  end

  def add_edge(adjacent_town)
    @adjacent_towns << adjacent_town
  end
end
