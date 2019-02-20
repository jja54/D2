# Jack Anderson
# jja54@pitt.edu
# CS1632 - Software Quality Assurance, Spring 2019
# Professor Bill Laboon

require 'minitest/autorun'
require_relative 'arg_check'

# This is a MiniTest test file. It will test the Game class in ruby_rush.rb
class ArgCheckTest < MiniTest::Test
  # UNIT TESTS FOR METHOD check_args(args)
  def setup
    error_msg = "Usage:\nruby gold_rush.rb *seed* *num_prospectors* *num_turns*\n*seed* should be an integer\n*num_prospectors* should be a non-negative integer\n*num_turns* should be a non-negative integer\n"
    error_msg
  end

  # If no arguments are passed, the error message is displayed
  def test_no_args
    args = []
	error_msg = setup
	assert_output(error_msg) { check_args(args) }
  end

  # If negative prospectors are passed, the error message is displayed
  def test_neg_prospectors
    args = [0, -1, 2]
    error_msg = setup
	assert_output(error_msg) { check_args(args) }
  end

  # If negative turns are passed, the error message is displayed
  def test_neg_turns
    args = [0, 1, -20]
    error_msg = setup
	assert_output(error_msg) { check_args(args) }
  end

  # If all arguements are valid, check_args returns false (no error)
  def test_args_valid
    args = [0, 1, 1]
    refute check_args(args)
  end
end