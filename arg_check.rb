# Jack Anderson
# jja54@pitt.edu
# CS1632 - Software Quality Assurance, Spring 2019
# Professor Bill Laboon

# Method that checks that the arguements of Ruby Rush

def check_args(args)
  error = "Usage:\nruby gold_rush.rb *seed* *num_prospectors* *num_turns*\n*seed* should be an integer\n*num_prospectors* should be a non-negative integer\n*num_turns* should be a non-negative integer"
  unless args.count == 3
    puts error
    exit(1)
  end

  prospects = args[1].to_i
  turns = args[2].to_i

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
end
