=begin
EvolManager controla la búsqueda de soluciones al problema de las N damas empleando un algoritmo evolutivo basado en los cromosomas. Esto incluye la creación, evaluación, selección y reproducción de los cromosomas.

Se tiene una población fija de cromosomas. Sólo hay más cromosomas de manera momentánea al momento de la reproducción.

El atributo @solutions es un vector que almacena las soluciones válidas.
=end

require './Cromosoma.rb'
require 'matrix'

class EvolManager
  @n
  @population #entero
  @generations #entero
  @currentGeneration = 0
  @cromArray = Array.new()
  @solutions = Array.new()

  #@novelArchive almacena los individuos que en su momento tuvieron un alto novelty.
  @novelArchive
  
  #Arreglo que almacena las generaciones en las que se encuentra una solución nueva
  @solGeneration = Array.new() 
  

  @matingPool = Array.new()
  @sortedCromArr = Array.new()
  #@matingPoolSize = 20

  #@offspring son los nuevos cromosomas que se generan tras la reproducción de los integrantes del @matingPool
  @offspring = Array.new()
  #@offspringSize = 60

  # accessor cumple el rol de los métodos get y set 
  attr_accessor :n, :population, :generations, :currentGeneration, :cromArray

=begin
mode:  Por ahora no se ha implementado este parámetro
0 := Evolución en base al fitness
1 := Evolución en base a novelty
2 := mixto




@noveltyAddRate es un parámetro que define qué porcentaje de 
=end
  def initialize (n, pop, generations, matingPoolSize = 30, offspring = 40, noveltyAddRate = 0.2)
    @n = n
    @population = pop
    @generations = generations

    @currentGeneration = 0
    @cromArray = Array.new()
    @solutions = Array.new()
    @solGeneration = Array.new()
    
  
    @matingPool = Array.new()
    @sortedCromArr = Array.new()
    @matingPoolSize = matingPoolSize
    @offspring = Array.new()
    @offspringSize = offspring
    @bigArr = Array.new()

    @novelArchive = Array.new()
    @noveltyAddRate = noveltyAddRate.to_f
    
    
    self.populate
  end

  def getCromArray
    return @cromArray.dup
  end


  def getSolutions
    return @solutions.dup
  end






    
#Llena @cromArray de cromosomas al azar
  def populate
    @cromArray = Array.new()
    a0 = Array.new(@n){|e| e = e}
    protoCro = Cromosoma.new( a0 )
    protoCro.setN(@n)
    
    for i in 0...@population 
      @cromArray[i] =  Cromosoma.new(protoCro.randomCrom)
    end

    #Se verifica si alguno de los cromosomas es solución
    for i in 0...@cromArray.size
      newSol = true
      if (@cromArray[i].fitness == 1.00)
        for j in 0...@solutions.size
          if (@cromArray[i].getPositions == @solutions[j].getPositions)
            newSol = false
            break
          end
        end 
        if newSol
          @solutions[@solutions.size] = @cromArray[i]
          @solGeneration[@solutions.size - 1] = @currentGeneration
        end
      end  
    end
    
    p "It's populated over here!"
    #self.showChromosomes
  end



  def showChromosomes
    p "cromArray members: "
    for i in 0...@cromArray.size
      p "#{@cromArray[i].getPositions} f: #{@cromArray[i].fitness} "
    end

  end
  

=begin
Se crea un matingPool dando más posibilidades a las aptitudes más altas. Todos los cromosomas tienen oportunidad de entrar al mating pool, pero la probabilidad de que entren los menos aptos es muy baja. En caso de que haya una cantidad de soluciones, las cuales tienen aptitud = 1, mayor o igual a @matingPoolSize, en ese caso definitivamente no tendrán oportunidad de reproducirse los demás cromosomas.
Los cromosomas con aptitud = 0 tampoco tienen oportunidad de entrar al mating pool.
Se asume que el mating pool es de menor tamaño que la población
=end
  def makeMatingPool
    @matingPool.clear()

    #Se ordenan los cromosomas de mayor a menor aptitud 
    @sortedCromArr = @cromArray.sort_by { |crom| -crom.fitness() }

    c = 0
    
    while @matingPool.size < @matingPoolSize
      boolSignal = false
      d = c % @population
      #p "c = #{c}"
      #p "d = #{d}"
      if ((@n <= 2) || (c > @population && @matingPool.size == 0) )
        @matingPool = @sortedCromArr.slice(0, @matingPoolSize)
      
      #elsif ( rand() < (@sortedCromArr[d].fitness / 4) ) 
      elsif ( rand() < 0.2 ) 
        @matingPool[@matingPool.size] = @sortedCromArr[d]
      end

      if (@sortedCromArr[d].fitness == 1.000000)
        if @solutions.size == 0
          @solutions[0] = @sortedCromArr[d]
          @solGeneration[@solutions.size - 1] = @currentGeneration
          
          @matingPool.delete(@sortedCromArr[d])
          @sortedCromArr.delete(@sortedCromArr[d])
          @sortedCromArr[@sortedCromArr.size] = Cromosoma.new(@sortedCromArr[d - 1].randomCrom)
          next
        end
        for i in 0...@solutions.size
          if (@solutions[i].getPositions == @sortedCromArr[d].getPositions)
            
            @matingPool.delete(@sortedCromArr[d])
            @sortedCromArr.delete(@sortedCromArr[d])
            @sortedCromArr[@sortedCromArr.size] = Cromosoma.new(@sortedCromArr[d - 1].randomCrom)
            boolSignal = true
            break            
          end
        end

        if boolSignal
          next
        else
          @solutions[@solutions.size] = @sortedCromArr[d]
          @solGeneration[@solutions.size - 1] = @currentGeneration
        end
        
      end
      

      c = c + 1
    end
  end

=begin
Crea la descendencia a partir de los cromosomas presentes en el @matingPool. 
Se considera la posibilidad de que @offspringSize sea mayor a @matingPoolSize, lo cual generaría una mayor recompensa a los cromosomas presentes en @matingPool
=end
  def matingSeason
    for i in 0...@offspringSize
      @offspring[i] = @matingPool[i % @matingPoolSize].makeChild
    end
  end


  def replacement
    @bigArr.clear
    @bigArr = @cromArray.concat(@offspring)
    #p "bigArr[0] #{bigArr[0]}"
    @bigArr.sort_by! { |crom| -crom.fitness() }
    @cromArray = @bigArr.slice(0, @population)
  end


  def nextGeneration
    p "@currentGeneration = #{@currentGeneration}"
    self.makeMatingPool
    self.matingSeason
    self.replacement
  end


  def showSolutions
    p "Solutions: "
    for i in 0...@solutions.size
      p "@solutions[#{i}]: #{@solutions[i].getPositions}. Generation: #{@solGeneration[i]}"
    end

    if (@solutions.size > 2)
      if (@solutions[@solutions.size - 1].getPositions == @solutions[@solutions.size - 2].getPositions)
        p "last solution repeated"
      end
    end
    
    
    
  end

    
  def greedyEvolve

    @currentGeneration = 0
    @cromArray.clear
    @solutions.clear
    @solGeneration.clear
    
    @matingPool.clear
    @sortedCromArr.clear
    @offspring.clear
    @bigArr.clear
    @novelArchive.clear

    self.populate


    
    while @currentGeneration < @generations do
      self.nextGeneration
      @currentGeneration = @currentGeneration + 1
    end
    
    p "@currentGeneration = #{@currentGeneration}"
    p "population.size = #{@population}"
    self.showChromosomes
    self.showSolutions
  end

=begin
  #calcDistances recibe un array de cromosomas
  def calcDistances (array)
    
    for i in 0...array.size
    behavDist(crom2)
    end
  end
=end


  #NOVELTY

  #Calcula la distancia de cromosoma crom0 al cromosoma más cercano en el arreglo de cromosomas arr. Si el cromosoma crom0 pertenece al arreglo, se puede incluír su índice index para que no sea medida la distancia a sí mismo.
  
  def shortestDist(crom0, arr, index = -1)
    minDistance = 100
    for i in 0...(arr.size)
      if i == index
        next
      end
      if ( (crom0.behavDist(arr[i]) < minDistance) && (crom0.behavDist(arr[i]) > 0 ) )
        minDistance = crom0.behavDist(arr[i])
      end
    end
    return minDistance
  end


#@novelArchive almacena los individuos que en su momento tuvieron un alto novelty.



  def noveltyMakeMatingPool
    @matingPool.clear()

    if @novelArchive.size > 0
      #Se ordenan los cromosomas de mayor a menor novelty 
      @sortedCromArr = @cromArray.sort_by { |crom| -shortestDist(crom, @novelArchive)}
     
    else
      @sortedCromArr = @cromArray
    end
    
    c=0

    while @matingPool.size < @matingPoolSize
      boolSignal = false
      d = c % @population

      if ((@n <= 2) || (c > @population && @matingPool.size == 0) )
        @matingPool = @sortedCromArr.slice(0, @matingPoolSize)
      
      #elsif ( rand() < (@sortedCromArr[d].fitness / 4) ) 
      elsif ( rand() < 0.9 ) #parámetro
      #else
        @matingPool[@matingPool.size] = @sortedCromArr[d]
        #if ((self.shortestDist(@sortedCromArr[d], @novelArchive)) > 0)
        if (not (@novelArchive.any? { |c| c.getPositions == @sortedCromArr[d].getPositions }) )
          #if (rand() < 0.5) #@noveltyAddRate)
            @novelArchive[@novelArchive.size] = @sortedCromArr[d]
          #end
          
        end
      end

      #Store found solutions. This doesn't affect novelty evolution
      if (@sortedCromArr[d].fitness == 1.000000)
        if @solutions.size == 0
          @solutions[0] = @sortedCromArr[d]
          @solGeneration[@solutions.size - 1] = @currentGeneration
        else
          for i in 0...@solutions.size
            if (@solutions[i].getPositions == @sortedCromArr[d].getPositions)
              boolSignal = true
              break            
            end
          end
  
          if boolSignal
            #not storing the solution
          else
            @solutions[@solutions.size] = @sortedCromArr[d]
            @solGeneration[@solutions.size - 1] = @currentGeneration
          end
        end
      end

      c = c + 1
    end
  end


  def noveltyArchiveAdd(crom)
    for i in 0...@novelArchive.size
      if ( crom.getPositions == @novelArchive[i].getPositions ) 
        return
      end
    end

    @novelArchive[@novelArchive.size] = crom
  end

  

  def noveltyReplacement
    @bigArr.clear
    @bigArr = @cromArray.concat(@offspring)
    @bigArr.sort_by! { |crom| -shortestDist(crom, @novelArchive)}
    @cromArray = @bigArr.slice(0, @population)
  end


  def noveltyNextGeneration
    p "@currentGeneration = #{@currentGeneration}"
    self.noveltyMakeMatingPool
    self.matingSeason #El mismo método que para greedyEvolve
    self.noveltyReplacement

    for i in 0...(@population * @noveltyAddRate.to_f) #Parámetro para curiousEvolve noveltyAddRate
      self.noveltyArchiveAdd(@cromArray[i])
    end
  end


  def showArrayOfCrom(arr)
    for i in 0...arr.size
      p arr[i].getPositions
    end
  end
  

  def showChromosomesWithB
    p "cromArray members: "
    for i in 0...@cromArray.size
      p "#{@cromArray[i].getPositions} b: #{@cromArray[i].getBehavior} "
    end
  end

  def showChromosomesWithSDist
    p "cromArray members: "
    #for i in 0...@cromArray.size
    for i in 0...@novelArchive.size
      #p "#{@cromArray[i].getPositions} sDist: #{self.shortestDist(@cromArray[i], @cromArray, i) } "
      p "#{@novelArchive[i].getPositions} sDist: #{self.shortestDist(@novelArchive[i], @novelArchive, i) } "
    end
  p "@novelArchive.size = #{@novelArchive.size}"
  end

  
  def curiousEvolve

    @currentGeneration = 0
    @cromArray.clear
    @solutions.clear
    @solGeneration.clear
    
    @matingPool.clear
    @sortedCromArr.clear
    @offspring.clear
    @bigArr.clear
    @novelArchive.clear

    self.populate

    
    
    while @currentGeneration < @generations do
      self.noveltyNextGeneration
      @currentGeneration += 1
    end
    
    p "@currentGeneration = #{@currentGeneration}"
    p "population.size = #{@population}"
    self.showChromosomes
    self.showSolutions
  end




  #ALGORITMO MULTIOBJETIVO
  #135 fitness
  #256 novelty
  def multiObjectiveParetoMakeMatingPool
    @matingPool.clear()
    ordByFitness = Array.new()
    ordByNovelty = Array.new()

    ordByFitness = @cromArray.sort_by { |crom| -crom.fitness() }

    if @novelArchive.size > 0
      #Se ordenan los cromosomas de mayor a menor novelty 
    ordByNovelty = @cromArray.sort_by { |crom| -shortestDist(crom, @novelArchive)}
     
    else
      ordByNovelty = @cromArray
    end

    ind0 = 0
    #Sólo los cromosomas presentes en la frontera de pareto podrán reproducirse.
    while (ind0 < ordByFitness.size )
      pareto = true
      newMate = true
      #ind1 se sabe que domina a ind0 en cuanto a fitness
      for ind1 in 0...ind0
        #¿También lo domina en novelty?
        if( ordByNovelty.find_index(ordByFitness[ind1]) < ordByNovelty.find_index(ordByFitness[ind0]) )
          #ordByFitness[ind0] No es frontera de pareto
          pareto = false
          break
        end
      end

      if pareto && (@matingPool.size > 0)
        #No se admiten cromosomas repetidos en el @matingPool
        for i in 0...@matingPool.size
          if ( @matingPool[i].getPositions == ordByFitness[ind0].getPositions )
            newMate = false
          end
        end
      end
      
      if ( pareto && newMate )
        @matingPool[@matingPool.size] = ordByFitness[ind0]
      end

                #Se buscan soluciones y se verifica si están repetidas
      boolSignal = false

      if (ordByFitness[ind0].fitness == 1.000000)
        if @solutions.size == 0
          @solutions[0] = ordByFitness[ind0]
          @solGeneration[@solutions.size - 1] = @currentGeneration
          
          @matingPool.delete(ordByFitness[ind0])
          #ordByFitness.delete(ordByFitness[ind0])
          ordByFitness[ordByFitness.size] = Cromosoma.new(@cromArray[0].randomCrom)
          #next
        end
        for i in 0...@solutions.size
          if (@solutions[i].getPositions == ordByFitness[ind0].getPositions)
            
            @matingPool.delete(ordByFitness[ind0])
            #ordByFitness.delete(ordByFitness[ind0])
            ordByFitness[ordByFitness.size] = Cromosoma.new(@cromArray[0].randomCrom)
            boolSignal = true
            break            
          end
        end

        if boolSignal
          #next
        else
          @solutions[@solutions.size] = ordByFitness[ind0]
          @solGeneration[@solutions.size - 1] = @currentGeneration
        end
        
      end
      
      ind0 += 1
    end  #end de while para escoger a los cromosomas en la frontera de pareto
    
    #Los cromosomas de la frontera de Pareto son muy pocos (en promedio 3), se seleccionan los más cercanos a estos:
    closestToPareto = ordByFitness.sort_by { |crom| shortestDist(crom, @matingPool)}
    counter = 0
    indexC = counter % closestToPareto.size
    
    while (@matingPoolSize > @matingPool.size)
    #for k in 0...( @matingPoolSize - @matingPool.size )
      indexC = counter % closestToPareto.size
      #@matingPool[@matingPool.size] = closestToPareto[indexC]
      @matingPool[@matingPool.size] = Cromosoma.new(@cromArray[0].randomCrom)
      counter += 1
    end
    
    
   # p "@matinPool.size = #{@matingPool.size}"
  end #end de multiObjectiveParetoMakeMatingPool


  #ALGORITMO MULTIOBJETIVO
  #135 fitness
  #256 novelty
  #Toma cromosomas de la frontera de pareto para @matingPool, y los retira de 
  #@cromArray. Luego vuelve a calcular la frontera de pareto, los introduce en
  #@matingPool y los vuelve a retirar, hasta que @matingPool.size == @matingPoolSize
  def multiObjectiveParetoMakeMatingPool1
    @matingPool.clear()
    ordByFitness = Array.new()
    ordByNovelty = Array.new()

    ordByFitness = @cromArray.sort_by { |crom| -crom.fitness() }.dup

    if @novelArchive.size > 0
      #Se ordenan los cromosomas de mayor a menor novelty 
      ordByNovelty = @cromArray.sort_by { |crom| -shortestDist(crom, @novelArchive)}.dup
    else
      ordByNovelty = @cromArray
    end

    for c in 0...5
        self.noveltyArchiveAdd(ordByNovelty[c])
    end
    

    
    while ( @matingPool.size < @matingPoolSize )
      ordByFitness = @cromArray.sort_by { |crom| -crom.fitness() }.dup
      ordByNovelty = @cromArray.sort_by { |crom| -shortestDist(crom, @novelArchive)}.dup

      for c in 0...3
        self.noveltyArchiveAdd(ordByNovelty[c])
      end 

      
      #Sólo los cromosomas presentes en la frontera de pareto podrán reproducirse.
      ind0 = 0
      while (ind0 < ordByFitness.size )
        pareto = true
        newMate = true
        #ind1 se sabe que domina a ind0 en cuanto a fitness
        for ind1 in 0...ind0
          #¿También lo domina en novelty?
          if( ordByNovelty.find_index(ordByFitness[ind1]) < ordByNovelty.find_index(ordByFitness[ind0]) )
            #ordByFitness[ind0] No es frontera de pareto
            pareto = false
            break
          end
        end
        
        if ( pareto && newMate )
          @matingPool[@matingPool.size] = ordByFitness[ind0]
          @cromArray.delete(ordByFitness[ind0])
          @cromArray[@cromArray.size] = Cromosoma.new(@cromArray[0].randomCrom)
        end
  
                  #Se buscan soluciones y se verifica si están repetidas
        boolSignal = false
  
        if (ordByFitness[ind0].fitness == 1.000000)
          if @solutions.size == 0
            @solutions[0] = ordByFitness[ind0]
            @solGeneration[@solutions.size - 1] = @currentGeneration
            
            @matingPool.delete(ordByFitness[ind0])
            @cromArray.delete(ordByFitness[ind0])
            @cromArray[@cromArray.size] = Cromosoma.new(@cromArray[0].randomCrom)
            #next
          end
          for i in 0...@solutions.size
            if (@solutions[i].getPositions == ordByFitness[ind0].getPositions)
              
              @matingPool.delete(ordByFitness[ind0])
              @cromArray.delete(ordByFitness[ind0])
              @cromArray[@cromArray.size] = Cromosoma.new(@cromArray[0].randomCrom)
              boolSignal = true
              break            
            end
          end
  
          if boolSignal
            #next
          else
            @solutions[@solutions.size] = ordByFitness[ind0]
            @solGeneration[@solutions.size - 1] = @currentGeneration
          end
          
        end
        
        ind0 += 1
      end  #end de while para escoger a los cromosomas en la frontera de pareto
    end
    
    
   # p "@matinPool.size = #{@matingPool.size}"
  end #end de multiObjectiveParetoMakeMatingPool1

  

  def multiObjectiveDominanceMakeMatingPool
    @matingPool.clear()

    ordByFitness = Array.new()
    ordByNovelty = Array.new()

    ordByFitness = @cromArray.sort_by { |crom| -crom.fitness() }

    if @novelArchive.size > 0
      #Se ordenan los cromosomas de mayor a menor novelty 
    ordByNovelty = @cromArray.sort_by { |crom| -shortestDist(crom, @novelArchive)}
    else
      ordByNovelty = @cromArray
    end

    
  end
  

  

  def multiObjectiveReplacement
    @bigArr.clear
    @bigArr = @cromArray.concat(@offspring)
    #@bigArr.sort_by! { |crom| -shortestDist(crom, @novelArchive)}
    
    #Se usa el nivel de dominancia para decidir a quién sacar.

    ordByFitness = Array.new()
    ordByNovelty = Array.new()

    #Se ordenan los cromosomas de mayor a menor fitness
    #ordByFitness = @bigArr.sort_by { |crom| -crom.fitness() }

    #Se ordenan los cromosomas de mayor a menor novelty 
    #ordByNovelty = @bigArr.sort_by { |crom| -shortestDist(crom, @novelArchive)}
     
    #Los cromosomas en la frontera de Pareto están en @matingPool. Se ordenan los cromosomas de menor a mayor distancia a un punto en la frontera de Pareto. Eliminar los que se van agregando y volver a calcular la frontera de Pareto se evita para no volver más lento el programa.
    closestToPareto = @bigArr.sort_by { |crom| shortestDist(crom, @matingPool)}

    @cromArray = @bigArr.slice(0, @population)
  end


  



  def multiObjectiveNextGeneration
    p "@currentGeneration = #{@currentGeneration}"
    self.multiObjectiveParetoMakeMatingPool1
    self.matingSeason #El mismo método que para greedyEvolve
    self.multiObjectiveReplacement

    for i in 0...(@population * 0.8) #Parámetro para curiousEvolve noveltyAddRate
      self.noveltyArchiveAdd(@cromArray[i])
    end
  end
  



  def multiObjectiveEvolve
    @currentGeneration = 0
    @cromArray.clear
    @solutions.clear
    @solGeneration.clear
    
    @matingPool.clear
    @sortedCromArr.clear
    @offspring.clear
    @bigArr.clear
    @novelArchive.clear

    self.populate
   

    while @currentGeneration < @generations do
      self.multiObjectiveNextGeneration
      @currentGeneration += 1
    end
    
    p "@currentGeneration = #{@currentGeneration}"
    p "population.size = #{@population}"
    self.showChromosomes
    self.showSolutions
  end
  
  
end