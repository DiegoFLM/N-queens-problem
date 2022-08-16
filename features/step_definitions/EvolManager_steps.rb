# language: es
# encoding: utf-8
# Archivo: VerificarEvolManager.feature
# Autor: GRUPO
# Email:  grupo@gmail.com
# Fecha creación: 2022-08-01
# Fecha última modificación: 2022-08-01
# Versión: 0.2
# Licencia: GPL

Dado(/que se necesita ubicar (.+?) reinas en un tablero de ajedrez, se quiere emplear un algoritmo evolutivo con una poblacion de (.+?) posibles soluciones, una capacidad evolutiva de (.+?) generaciones con (.+?) individuos generando una descendencia de (.+?) hijos en cada generacion./) do |queens, population, generations, currentGeneration, offspring|

  @evolver = EvolManager.new(queens.to_i, population.to_i, generations.to_i, currentGeneration.to_i, offspring.to_i)

end

Cuando('Se desea generar una población de cromosomas aleatorios') do
  @cromosomas = @evolver.getCromArray.size
end

Entonces('arroja un arreglo de cromosomas con un array de enteros de tamaño {int}') do |tamano|
  expect(@cromosomas).to eq tamano
end

Cuando('Se desea reproducir cromosomas ') do
  @evolver.makeMatingPool

end

Entonces('Se reemplazan los viejos por los nuevos cromosomas generados dependiendo de la aptitud') do 
  @evolver.
end

##CROMOSOMA
#Dado(/un arreglo de enteros inicial (.+?) se genera un cromosoma nuevo a partir de este arreglo inicial/) do |arr0|

  #@crom0 = Cromosoma.new(arr0)

#end
