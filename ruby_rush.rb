require_relative 'game'
require_relative 'town'
require_relative 'arg_check'
exit(1) if check_args(ARGV)
game = Game.new
game.run(ARGV[0].to_i, ARGV[1].to_i, ARGV[2].to_i)
