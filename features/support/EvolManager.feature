# language: es
# encoding: utf-8
# Archivo: VerificarEvolManager.feature
# Autor: GRUPO
# Email:  grupo@gmail.com
# Fecha creación: 2022-08-01
# Fecha última modificación: 2022-08-01
# Versión: 0.2
# Licencia: GPL

Característica: Ejecutar la creación, evaluación, selección y reproducción de los cromosomas.

Antecedentes: controlar la búsqueda de soluciones al problema de las N damas empleando un algoritmo evolutivo basado en los cromosomas.
  Dado que se necesita ubicar 8 reinas en un tablero de ajedrez, se quiere emplear un algoritmo evolutivo con una poblacion de 100 posibles soluciones, una capacidad evolutiva de 100 generaciones con 30 individuos generando una descendencia de 40 hijos en cada generacion.
  #populate
  Escenario: Se crea un arreglo de cromosomas al azar
    Cuando Se desea generar una población de cromosomas aleatorios
    Entonces arroja un arreglo de cromosomas con un array de enteros de tamaño 100

  #makeMatingPool
  Escenario: Se crea un matingPool con los cromosomas teniendo en cuenta su aptitud, no obstante los de menor aptitud también tienen posibilidades de entrar
    Cuando Se desea reproducir cromosomas 
    Entonces Se reemplazan los viejos por los nuevos cromosomas generados dependiendo de la aptitud

  #matingSeason
  Escenario:  Crea la descendencia a partir de los cromosomas presentes en el matingPool. 
  Cuando se han escogido los cromosomas a partir de la aptitud y han sido puestos en el matingPoool 
    Entonces Crea la siguiente generación de cromosomas a partir del matingPool


  #noveltyMakeMatingPool Escenario:  Cuando  Entonces 

  #multiObjectiveMakeMatingPool Escenario:  Cuando Entonces 

#CROMOSOMA

#Característica: Cada cromosoma tiene la función principal de representar una configuración de N damas en un tablero de NxN.

#Antecedentes: crear un cromosoma 
#Dado un arreglo de enteros inicial [0, 1, 2, 3, 4, 5, 6] se genera un cromosoma nuevo a partir de este arreglo inicial