# language: es
# encoding: utf-8
# Archivo: VerificarCromosoma.feature
# Autores: Diego Ledesma, José David Barona, José A Hurtado
# Fecha creación: 2022-07-10
# Fecha última modificación: 2022-08-17
# Versión: 0.2
# Licencia: GPL


  Dado("un arreglo de enteros {} se genera un cromosoma nuevo como candidata a solución a partir de este arreglo inicial") do |list|
    arr = []
    list.split(',').each{|pos| arr.push(pos.to_i)}
    @protoCro = Cromosoma.new(arr)
    
  end

  Cuando("el cromosoma es {}") do |list|
    arr = []
    list.split(',').each{|pos| arr.push(pos.to_i)}
    @arr2 = arr
    @cromosoma1 = Cromosoma.new(arr)
  end

  Cuando('se mide su aptitud') do
    @fit = @cromosoma1.fitness
  end

  Entonces('debe indicar que fitness es igual a {float}') do |prueba|
    expect(@fit.truncate(6)).to eq prueba
  end

  Entonces('debe indicar que el cromosoma creado contiene las posiciones que se le indicaron en el mismo orden.') do
    expect(@cromosoma1.getPositions).to eq @arr2
  end

  Cuando('se pide que genere un cromosoma aleatorio') do
    @cromosomaAleatorio = @cromosoma1.randomCrom
  end

  Entonces('debe cumplirse que para el cromosoma aleatorio generado, en su arreglo de enteros no tiene números repetidos. Además, si el cromosoma es de tamaño {int}, su primer gen debe ser menor o igual a: {int}') do |n,int|

    firstGen = @cromosomaAleatorio[0]
    approve = false
    if firstGen <= int
      approve = true
    end
    expect(approve).to eq true
  end

 Cuando('se cuentan los ataques mutuos') do
  @threats = @cromosoma1.mutualThreats
 end

  Entonces('debe indicar que la cantidad de ataques mutuos es {int}') do |int|
    expect(@threats).to eq int
  end

  Cuando('el cromosoma muta') do
    @childCrom = @cromosoma1.makeChild
  end

  Entonces('debe indicar que hay {int} genes diferentes Además, todos los números son todos diferentes y el primer número debe ser menor o igual a {int}') do |gens, int|
    
    positions = @childCrom.getPositions
    approve = false
    if positions[0] <= int
      approve = true
    end
    expect(approve).to eq true
    
  end

  Cuando('se le pide la distancia vertical media entre damas consecutivas') do
    @meanConsecutive = @cromosoma1.meanConsecutive
  end

  Entonces('la distancia vertical debe decir que es: {float}') do |float|
    expect(@meanConsecutive.truncate(6)).to eq float
  end

  Cuando('se le pide la distancia horizontal entre las damas de la fila {int} y de la fila {int}') do |row1, row2|
    @dist = @cromosoma1.hDist(row1, row2)
  end

  Entonces('la distancia horizontal debe decir que es: {int}') do |int|

    expect(@dist).to eq int
  end

  Cuando('se le pide la distancia horizontal de los extremos entre las damas de la fila 0 y de la fila 7') do
    @dist = @cromosoma1.extremsDist
  end

  Cuando('se le pide la distancia central horizontal entre las damas de la fila 3 y de la fila 4') do
  
    @dist = @cromosoma1.centralDist
  end

  Cuando('se le pide el promedio de las filas de las damas en las columnas 0 a 3, incluyendo la columna 3.') do
    @avg = @cromosoma1.meanRange(0,4)
  end

  Entonces('debe decir que el promedio es: {float}') do |float|
    expect(@avg.truncate(2)).to eq float
  end

  Cuando('se le pide el vector que caracteriza su comportamiento.') do
  @vec = @cromosoma1.calcBehavior
  end

  Entonces('debe decir que es: {}') do |list|
    arr = []
    list.split(',').each{|pos| arr.push(pos.to_f)}
    expect(@vec).to eq arr
  end

  Cuando('el primer cromosoma es {} y el segundo cromosoma es {}') do |list1, list2|
    arr1 = []
    arr2 = []
    list1.split(',').each{|pos| arr1.push(pos.to_i)}
    list2.split(',').each{|pos| arr2.push(pos.to_i)}
    @cromosoma1 = Cromosoma.new(arr1)
    @cromosoma2 = Cromosoma.new(arr2)
  end

  Cuando('se le pide al primer cromosoma que calcule su distancia al segundo cromosoma') do
  @behDist = @cromosoma1.behavDist(@cromosoma2)
  end

  Entonces('debe decir que la distancia euclidiana entre los cromosomas es: {float}') do |float|
    expect(@behDist).to eq float
  end