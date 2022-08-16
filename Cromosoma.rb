=begin
  Cada cromosoma tiene la función principal de representar una configuración de N damas en un tablero de NxN.
Existe la restricción de que en cada columna sólo puede haber una dama. Lo mismo ocurre para cada fila. Con lo cual las damas sólo pueden atacarse en diagonal.
=end

#require 'bigdecimal'

class Cromosoma
  #@@n es un número entero, es la cantidad de damas que hay que ubicar. También es la dimensión del tablero.
  #@@n = 0 

  #@positions: [vector de enteros] la posición i de este vector almacena la fila en la que está ubicada la dama de la columna i.
  @positions = []
  
  
  def initialize(v)
    @@n = v.size
    @positions = Array.new()
    @positions = v
    #a = @positions[0] 
    @behavior = self.calcBehavior
  end 


  def setN( newN )
    @@n = newN
  end

  def getN()
    return @@n
  end


  def getPositions
    @positions
  end

  
  #Genera un cromosoma al azar.
  def randomCrom
    pool = Array.new(@@n){|i| i = i}
    crom = Array.new(@@n)

    #p "@@n = #{@@n}"
    
    r = rand( 1 + ((@@n - 1) / 2).floor() )
    crom[0] = pool[r]   
    pool.delete(pool[r])
    
    for i in 1...@@n
      r = rand(pool.length)
      crom[i] = pool[r]   
      pool.delete(pool[r])
    end
    #p "crom = #{crom}"
    #newCrom = Cromosoma.new(crom)
    return crom
  end


=begin
  Retorna un nuevo cromosoma resultado de intercambiar las posiciones de las damas de dos columnas al azar. El cromosoma que invoca el método no cambia. El cromosoma retornado cumple las restricciones.
=end
  def makeChild
  
    if @@n <= 2
      p "identical son = #{@positions}"
      return @positions.dup
    end 

    mutant = @positions.dup
    colsPool = Array.new(@@n){|i| i = i}
    #p "colsPool   = #{colsPool}"
    
    c1 = rand(colsPool.length)
    #p "      c1 = #{c1}"
    colsPool.delete(c1)
    #p "colsPool   = #{colsPool}"
    
    c2 = colsPool[ rand(colsPool.length) ]
    #p "      c2 = #{c2}"
    
    if c1 == 0 && @positions[c2] > ((@@n - 1) / 2 ).floor()
      while @positions[c2] > ((@@n - 1) / 2 ).floor() do
        colsPool.delete(c2)
        c2 = colsPool[ rand(colsPool.length) ]
        #p "New   c2 = #{c2}"
      end
      #p   "final c2 = #{c2}"
    elsif c2 == 0 && @positions[c1] > ((@@n - 1) / 2 ).floor() 
      colsPool.delete(0)
      c2 = colsPool[ rand(colsPool.length) ]
      #p   "final c2 = #{c2}"
    end
    
    aux = mutant[c1]
    mutant[c1] = mutant[ c2 ]
    mutant[ c2 ] = aux
    #p "final mutant      = #{mutant}"

    child = Cromosoma.new(mutant)
    return child  
  end


=begin
  Este método cuenta la candida de amenazas mutuas entre damas. Si hay sólamente dos damas, en un tablero de 2x2 donde es inevitable que se amenacen, la cantidad de amenazas mutuas es sólamente 1.
=end
  def mutualThreats
    threats = 0
    for i in 0...@@n
      for j in 0...@@n
        if i == j
          next
        end

=begin
  Si la diferencia entre la filas y la diferencia entre las columnas de dos damas son iguales, entonces las damas se están amenazando en diagonal.        
=end
        if (i - j).abs() == (@positions[i] - @positions[j]).abs()
          threats = threats + 1
        end
      end
    end
    mutualT = threats / 2
    return mutualT
  end


=begin
Función de aptitud normalizada.
=end
  def fitness
    maxThreats = (@@n * (@@n - 1) / 2)
    if @@n <= 1
      return 1
    end

    f = (maxThreats.to_f - self.mutualThreats.to_f ) / maxThreats.to_f
    #p "f = (maxThreats - self.mutualThreats) = #{ maxThreats - self.mutualThreats}"
    if f == 1
      p "TENEMOS UNA SOLUCIÓN: #{self.getPositions}"
    end
    return f
  end


  
#NOVELTY
  
  def calcBehavior
    @behavior = Array.new(5)
    
    @behavior[0] = self.meanConsecutive
    @behavior[1] = self.extremsDist
    @behavior[2] = self.centralDist
    @behavior[3] = self.meanRange(0, ((@@n - 1)/2).floor + 1)
    @behavior[4] = @positions[0]
    
    return @behavior
  end


  def getBehavior
    return @behavior  
  end

  

  #Distancia media entre damas
  def meanConsecutive
    consecDist = 0
    for i in 0...(@@n - 1)
      consecDist += (@positions[i] - @positions[i + 1]).abs()
    end
    return meanDist = consecDist.to_f / (@@n - 1)
  end


  #Distancia horizontal entre las damas de las filas f1 y f2. Las distancias siempre son positivas
  def hDist(f1, f2)
    if ((f1 < 0 || f2 < 0) || (f1 > (@@n - 1) || (f2 > (@@n - 1)) ))
      p "ERROR: columna ó @@n inconsistente en: hDist(#{f1}, #{f2})"
      return
    end
    hd = (@positions.find_index(f1) - @positions.find_index(f2)).abs 
  end

  #Distancia horizontal entre las damas de la fila  0   y de la fila  (N-1)
  def extremsDist
    return hDist(0, @@n - 1)
  end

  #Distancia horizontal entre las damas de la fila  ((N - 1) / 2).floor  y de la fila   ((N - 1) / 2).floor + 1
  def centralDist
    return hDist( ((@@n - 1)/2).floor , ((@@n - 1)/2).floor + 1 )
  end

  #Fila promedio de las columnas en el rango  [ 0, limit) 
  def meanRange(from, limit)
    if (from >= limit)
      p "ERROR. Rango inválido en meanRange( #{from}, #{limit})"
      return
    end
    rowSum = 0
    for i in from...limit
      rowSum += @positions[i]
    end
    mean = rowSum.to_f / (limit)
    return mean
  end


  #Behavioral distance: La distancia euclidiana entre dos vectores de caracterización de comportamiento.F
  def behavDist(crom2)
    sum = 0
    for i in 0...@behavior.size
      sum += ( (@behavior[i] - crom2.getBehavior[i])  ** 2)
    end
    bDist = Math.sqrt(sum)
    
    return bDist
  end
  
  
  
end