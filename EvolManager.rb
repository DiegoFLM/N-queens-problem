# language: es
# encoding: utf-8
# Archivo: VerificarCromosoma.feature
# Autores: Diego Ledesma, José David Barona, José A Hurtado
# Fecha creación: 2022-07-10
# Fecha última modificación: 2022-08-17
# Versión: 0.2
# Licencia: GPL


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
  def initialize (n, pop, generations, matingPoolSize = 80, offspring = 80, noveltyAddRate = 0.2)
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
    @solutionTimes = Array.new()
    
    self.populate
  end

  def getCromArray
    return @cromArray.dup
  end


  def getSolutions
    return @solutions.dup
  end

  def getSolutionTimes
    return @solutionTimes
  end

  
  def getBestCromFitness
    orderedPopul = @cromArray.sort_by { |crom| -crom.fitness() }.dup
    return orderedPopul[0].fitness
  end

  
  def getBestCromMutualThreats
    orderedPopul = @cromArray.sort_by { |crom| -crom.fitness() }.dup
    return orderedPopul[0].mutualThreats
  end

    
#Llena @cromArray de cromosomas al azar
  def populate
    @cromArray = Array.new()
    a0 = Array.new(@n){|e| e = e}
    protoCro = Cromosoma.new( a0 )
    
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

      if (@cromArray[i].fitness == 1.00)
        newSol = true
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

  end
  

=begin
Se crea un matingPool dando más posibilidades a las aptitudes más altas. Todos los cromosomas tienen oportunidad de entrar al mating pool, pero la probabilidad de que entren los menos aptos es muy baja. En caso de que haya una cantidad de soluciones, las cuales tienen aptitud = 1, mayor o igual a @matingPoolSize, en ese caso definitivamente no tendrán oportunidad de reproducirse los demás cromosomas.
Los cromosomas con aptitud = 0 tampoco tienen oportunidad de entrar al mating pool.
Se asume que el mating pool es de menor tamaño que la población
=end
  def makeMatingPool
    @matingPool.clear()

    #Se ordenan los cromosomas de mayor a menor aptitud 
    @sortedCromArr = @cromArray.sort_by { |crom| -crom.fitness() }.dup

    c = 0
    
    while @matingPool.size < @matingPoolSize
      boolSignal = false
      d = c % @population
      
      if ((@n <= 2) || (c > @population && @matingPool.size == 0) )
        @matingPool = @sortedCromArr.slice(0, @matingPoolSize)

      #Se otorga una probabilidad de entrar al @matingPool proporcional al fitness del cromosoma. Sólamente si un cromosoma tiene fitness = 0 ocurre que no puede entrar, pero eso es extremadamente improbable.  
      elsif ( rand() < (@sortedCromArr[d].fitness / 3) ) 
      #elsif ( rand() < 0.2 ) 
        @matingPool[@matingPool.size] = @sortedCromArr[d]
      end

      #Si hay una solución, se almacena en el arreglo de soluciones y si esa solución se había encontrado previamente, se saca del @matingPool.
      if (@sortedCromArr[d].fitness == 1.000000)
        if @solutions.size == 0
          @solutions[0] = @sortedCromArr[d]
          @solGeneration[@solutions.size - 1] = @currentGeneration
          ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
          lapse = ending - @starting
          @solutionTimes[@solutionTimes.size] = lapse.dup
          p "Time for first solution:"
          p lapse
          #@matingPool.delete(@sortedCromArr[d])
          @sortedCromArr.delete(@sortedCromArr[d])
          @sortedCromArr[@sortedCromArr.size] = Cromosoma.new(@sortedCromArr[d - 1].randomCrom)
          next
        end
        #En caso de que ya haya encontrado la solución antes,
        #elimina el cromosoma.
        for i in 0...@solutions.size
          if (@solutions[i].getPositions == @sortedCromArr[d].getPositions)

            #Se elimina la solución repetida de @matingPool, 
            #pero se le permite entrar al @matingPool a uno
            #de sus hijos. Esto con la intención de permitir
            #que se encuentren soluciones cercanas a una 
            #solución ya encontrada.
            @matingPool[@matingPool.size] = @sortedCromArr[d].makeChild
            @matingPool.delete(@sortedCromArr[d])
            
            @cromArray.delete( @sortedCromArr[d] )
            @cromArray[@population - 1] = Cromosoma.new(@cromArray[0].randomCrom)

            
            
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
          ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
          lapse = ending - @starting
          @solutionTimes[@solutionTimes.size] = lapse.dup
          p "Time for solution:"
          p lapse
        end
      end
      
      c = c + 1
    end
  end


  def getMatingPool
    return @matingPool
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


  def getOffspring
    return @offspring
  end


  def replacement
    @bigArr.clear
    @bigArr = @cromArray.concat(@offspring)
    @bigArr.sort_by! { |crom| -crom.fitness() }
    @cromArray = @bigArr.slice(0, @population)
  end


  def greedyNextGeneration
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
    @solutionTimes.clear
    self.populate
    @starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)

    while @currentGeneration < @generations do
      self.greedyNextGeneration
      @currentGeneration = @currentGeneration + 1
    end
    
    p "@currentGeneration = #{@currentGeneration}"
    p "population.size = #{@population}"
    self.showChromosomes
    self.showSolutions
  end


  def getCurrentGeneration
    return @currentGeneration
  end

  
  #NOVELTY

  #Calcula la distancia comportamental de cromosoma crom0 al cromosoma más cercano en el arreglo de cromosomas arr. Si el cromosoma crom0 pertenece al arreglo, se puede incluír su índice index para que no sea medida la distancia a sí mismo.
  
  def shortestDist(crom0, arr, index = -1)
    minDistance = 100
    for i in 0...(arr.size)
      if i == index
        next
      end
      if ( (crom0.behavDist(arr[i]) < minDistance) ) #&& (crom0.behavDist(arr[i]) > 0 ) )
        minDistance = crom0.behavDist(arr[i])

        if minDistance == 0
          return minDistance
        end
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
    
    c = 0 

    while @matingPool.size < @matingPoolSize
      boolSignal = false
      d = c % @population

      if ((@n <= 2) || (c > @population && @matingPool.size == 0) )
        @matingPool = @sortedCromArr.slice(0, @matingPoolSize)
      
      #elsif ( rand() < (@sortedCromArr[d].fitness / 4) ) 
      elsif ( rand() < 0.9 ) #parámetro
      #else
        @matingPool[@matingPool.size] = @sortedCromArr[d]
        if (not (@novelArchive.any? { |c| c.getPositions == @sortedCromArr[d].getPositions }) )
          @novelArchive[@novelArchive.size] = @sortedCromArr[d]          
        end
      end

      #Store found solutions. This doesn't affect novelty evolution
      #Se guardan las nuevas soluciones. Esto no afecta el algoritmo de 
      #evolución que emplea novelty, simplemente revisa si novelty encuentra una solución
      #Y en caso de ser así la almacena.
      
      if (@sortedCromArr[d].fitness == 1.000000)
        if @solutions.size == 0
          @solutions[0] = @sortedCromArr[d]
          @solGeneration[@solutions.size - 1] = @currentGeneration
          ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
          lapse = ending - @starting
          @solutionTimes[@solutionTimes.size] = lapse.dup
          p "Time for first solution:"
          p lapse
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
            ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
            lapse = ending - @starting
            @solutionTimes[@solutionTimes.size] = lapse.dup
            p "Time for solution:"
            p lapse
          end
        end
      end

      c = c + 1
    end
  end


  #Si la configuración del cromosoma recibido no está en @novelArchive, lo almacena allí.
  def noveltyArchiveAdd(crom)
    for i in 0...@novelArchive.size
      if ( crom.getPositions == @novelArchive[i].getPositions ) 
        return
      end
    end
    @novelArchive[@novelArchive.size] = crom
  end

  
  #Toma los individuos nuevos que se obtuvieron de la reproducción (@offspring) 
  #y los junta con toda la población. 
  #Luego selecciona a los de mayor novelty para permanecer en la 
  #población. El arreglo en donde está la población es @cromArray
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
      #Al hacer esto @cromArray se encuentra ordenado
      #de mayor a menor novelty
      self.noveltyArchiveAdd(@cromArray[i]) 
    end
  end


  def showArrayOfCrom(arr)
    for i in 0...arr.size
      p arr[i].getPositions
    end
  end
  
  #Muestra las posiciones de damas de los cromosomas junto con el vector 
  #que caracteriza su comportamiento.
  def showChromosomesWithB
    p "cromArray members: "
    for i in 0...@cromArray.size
      p "#{@cromArray[i].getPositions} b: #{@cromArray[i].getBehavior} "
    end
  end

  def showChromosomesWithSDist
    p "cromArray members: "
    for i in 0...@novelArchive.size
      p "#{@novelArchive[i].getPositions} sDist: 
          #{self.shortestDist(@novelArchive[i], @novelArchive, i) } "
    end
  p "@novelArchive.size = #{@novelArchive.size}"
  end

  #Algoritmo de evolución que premia la novedad de los cromosomas
  #en vez de lo cerca que están de ser una solución válida.
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
    @solutionTimes.clear
    self.populate
    @starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)

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
  #Objetivos: fitness y novelty.
  #Toma cromosomas de la frontera de pareto para @matingPool, y los retira de 
  #@cromArray. Luego vuelve a calcular la frontera de pareto, los introduce en
  #@matingPool y los vuelve a retirar, hasta que @matingPool.size == @matingPoolSize
  def multiObjectiveParetoMakeMatingPool
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

      #Sólo los cromosomas presentes en la frontera de pareto podrán entrar a @matingPool
      ind0 = 0
      while (ind0 < ordByFitness.size && @matingPool.size < @matingPoolSize)
        
        pareto = true
        newMate = true
        #ind1 se sabe que domina a ind0 en cuanto a fitness
        for ind1 in 0...ind0
          #¿También lo domina en novelty?
          if( ordByNovelty.find_index(ordByFitness[ind1]) <   
                  ordByNovelty.find_index(ordByFitness[ind0]) )
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
            
            ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
            lapse = ending - @starting
            @solutionTimes[@solutionTimes.size] = lapse.dup
            p "Time for solution:"
            p lapse
            #Inicialmente se consideró sacar las soluciones permitiendo
            #que una mutación de la solución entrara al mating pool.
            #Pero dado que novelty valora la novedad de un cromosoma, 
            #esto no es realmente necesario.
            #@matingPool[@matingPool.size] = ordByFitness[ind0].makeChild
            #@matingPool.delete(ordByFitness[ind0])
            
            @cromArray.delete(ordByFitness[ind0])
            @cromArray[@cromArray.size] = Cromosoma.new(@cromArray[0].randomCrom)
            next
          end
          for i in 0...@solutions.size
            if (@solutions[i].getPositions == ordByFitness[ind0].getPositions)
              #@matingPool[@matingPool.size] = ordByFitness[ind0].makeChild
              #@matingPool.delete(ordByFitness[ind0])
              
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
            
            ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
            lapse = ending - @starting
            @solutionTimes[@solutionTimes.size] = lapse.dup
            p "Time for solution:"
            p lapse
          end
          
        end
        
        ind0 += 1
      end  #end del while para escoger a los cromosomas en la frontera de pareto
    end    
  end #end de multiObjectiveParetoMakeMatingPool
  
  
  #Los cromosomas en la frontera de Pareto están en @matingPool. Se ordenan los cromosomas de menor a mayor distancia a un punto en la frontera de Pareto. Eliminar los que se van agregando y volver a calcular la frontera de Pareto se evita para no volver más lento el programa.
  def multiObjectiveReplacement
    @bigArr.clear
    #@bigArr = @cromArray.concat(@offspring)
    @bigArr = @offspring.concat(@cromArray)
    #@bigArr.sort_by! { |crom| -shortestDist(crom, @novelArchive)}
    
    closestToPareto = @bigArr.sort_by { |crom| -shortestDist(crom, @matingPool)}

    @cromArray = closestToPareto.slice(0, @population)
  end


  



  def multiObjectiveNextGeneration
    p "@currentGeneration = #{@currentGeneration}"
    self.multiObjectiveParetoMakeMatingPool
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
    @solutionTimes.clear

    self.populate
    @starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    
   

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