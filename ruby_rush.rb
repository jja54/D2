# Jack Anderson
# jja54@pitt.edu
# CS1632 - Software Quality Assurance, Spring 2019
# Professor Bill Laboon

require_relative 'game'
require_relative 'town'
require_relative 'arg_check'

if check_args(ARGV)
  exit(1)
end

game = Game.new
game.run(ARGV[0].to_i, ARGV[1].to_i, ARGV[2].to_i)

exit(0) # Exit cleanly
