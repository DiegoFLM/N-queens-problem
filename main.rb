require './EvolManager.rb'

#evolver = EvolManager.new(n, pop, generations, matingPoolSize = 30, offspring = 40, noveltyAddRate = 0.2)

#evolver = EvolManager.new(8, 100, 50, 30, 40, 0.1)
evolver = EvolManager.new(8, 100, 100, 30, 40, 0.3)
times = []
numberOfFoundSolutions = []



for i in 0...20
  p "Iteration: #{i}"
  starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  
  evolver.multiObjectiveEvolve
  numberOfFoundSolutions[numberOfFoundSolutions.size] = evolver.getSolutions.size
  ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  elapsed = ending - starting
  p elapsed # => [seconds]
  times[times.size] = elapsed

end
p "numberOfFoundSolutions: "
p numberOfFoundSolutions
p "times: "
p times


