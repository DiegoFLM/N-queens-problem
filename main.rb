# language: es
# encoding: utf-8
# Archivo: VerificarCromosoma.feature
# Autores: Diego Ledesma, José David Barona, Jose A Hurtado
# Fecha creación: 2022-07-10
# Fecha última modificación: 2022-08-17
# Versión: 0.2
# Licencia: GPL

require './EvolManager.rb'
require './Cromosoma.rb'

puts "Cuantas Reinas?"
n = gets.chomp.to_i
puts "Cual estrategia a usar 1=ATAQUES 2=DIVERSIDAD 3=MULTIOBJETIVO?"
m = gets.chomp.to_i



#defaultEvolver = EvolManager.new(15, 100, 100, 30, 40)



def iteratedEvo(n, m)
  times = []
  foundSolutions = []
  fitnessAvgs = []
  evolver = EvolManager.new(n, 100, 100, 30, 40) 
  for i in 0...10
    p "Iteration: #{i}"
    starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)  
    if m == 1
      evolver.greedyEvolve
    elsif m == 2
      evolver.curiousEvolve
    elsif m == 3
      evolver.multiObjectiveEvolve  
    end  
    acc = 0  
    for j in 0...evolver.getCromArray.size
      acc += (evolver.getCromArray)[j].fitness
    end
  
    
  
    fitnessAvgs[fitnessAvgs.size] = 
        acc.to_f / evolver.getCromArray.size
  
    
    foundSolutions[foundSolutions.size] = evolver.getSolutions.size
    ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    elapsed = ending - starting
    p elapsed # => [seconds]
    times[times.size] = elapsed
    p fitnessAvgs[fitnessAvgs.size - 1]
  end
  p "foundSolutions: "
  p foundSolutions
  p "times: "
  p times
  p "AVERAGES"
  acc = 0  
  for j in 0...foundSolutions.size
    acc += foundSolutions[j]
  end
  avgFoundSolutions = 
      acc.to_f / foundSolutions.size
  p "Average Found Solutions:"
  p avgFoundSolutions

  acc = 0  
  for j in 0...times.size
    acc += times[j]
  end
  avgTimes = 
      acc.to_f / times.size
  p "Average time:"
  p avgTimes


  acc = 0  
  for j in 0...fitnessAvgs.size
    acc += fitnessAvgs[j]
  end
  p "Average of chromosomes fitness:"
  #p fitnessAvgs
  avgFitness = acc.to_f / fitnessAvgs.size
  p avgFitness  
end    


iteratedEvo(n, m)
