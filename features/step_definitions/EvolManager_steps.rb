# language: es
# encoding: utf-8
# Archivo: VerificarCromosoma.feature
# Autores: Diego Ledesma, José David Barona, José A Hurtado
# Fecha creación: 2022-07-10
# Fecha última modificación: 2022-08-17
# Versión: 0.2
# Licencia: GPL


Dado(/que se necesita ubicar (.+?) reinas en un tablero de ajedrez, se quiere emplear un algoritmo evolutivo con una poblacion de (.+?) posibles soluciones, una capacidad evolutiva de (.+?) generaciones con (.+?) individuos generando una descendencia de (.+?) hijos en cada generacion./) do |queens, population, generations, currentGeneration, offspring|

  @evolver = EvolManager.new(queens.to_i, population.to_i, generations.to_i, currentGeneration.to_i, offspring.to_i)

end


Cuando('Se desea generar una población de cromosomas aleatorios') do
  @cromosomas = @evolver.getCromArray.size
end

Entonces('arroja un arreglo de cromosomas de tamaño {int}') do |tamano|
  expect(@cromosomas).to eq tamano
end


Cuando('Se desea seleccionar los individuos que van a reproducirse en base a su aptitud.') do
  @evolver.makeMatingPool
end

Entonces('el mating pool es un arreglo de cromosomas de tamaño {int}') do |tamano|
  expect(@evolver.getMatingPool.size).to eq tamano
end


Cuando('se reproducen los individuos del mating pool') do
  @evolver.makeMatingPool
  @evolver.matingSeason
end


Entonces('la descendencia  es un arreglo de cromosomas de tamaño {int}') do |tamano|

    expect(@evolver.getOffspring.size).to eq tamano
end


Cuando('Se pasa de una generación a la siguiente') do

    @evolver.greedyNextGeneration
end

Entonces('los arreglos de cromosomas del mating pool y de la descendencia deben ser distintos a los de la generación anterior') do

    fatherCrom1 = @evolver.getMatingPool.dup
    sonCrom1 = @evolver.getOffspring.dup
    @evolver.greedyNextGeneration
    fatherCrom2 = @evolver.getMatingPool.dup
    sonCrom2 = @evolver.getOffspring.dup

    diff = false
    if fatherCrom1 != fatherCrom2 and sonCrom1 != sonCrom2
      diff = true
    end

    expect(diff).to eq true
end



  Cuando('Se desea seleccionar los individuos que van a reproducirse con base a la novedad de su comportamiento.') do

      @evolver.noveltyMakeMatingPool
  end


  Entonces('se debe estar en la generación {int}, el mating pool debe tener {int} individuos y la descendencia debe contener {int} individuos.') do |season, mpool, ind|

    @evolver.greedyEvolve
    ok = false
    if @evolver.getCurrentGeneration == season and @evolver.getMatingPool.size == mpool and @evolver.getOffspring.size == ind
        ok = true
    end
    expect(ok).to eq true
  end


  Cuando('Se pasa de una generación a la siguiente -novelty-') do
  
      @evolver.noveltyNextGeneration
  end


Cuando('Se realiza la evolución que premia la aptitud.') do

  @evolver.curiousEvolve
end


  Cuando('se desea seleccionar los individuos que van a reproducirse tanto en base a la novedad de su comportamiento como en base a su aptitud.') do
    @evolver.multiObjectiveParetoMakeMatingPool
  end


Cuando('Se pasa de una generación a la siguiente -multiobjective-') do
  @evolver.multiObjectiveNextGeneration
end


Cuando('Se realiza la evolución que premia la aptitud -multiEvolve-') do
  @evolver.multiObjectiveEvolve
end