# language: es
# encoding: utf-8
# Archivo: VerificarCromosoma.feature
# Autores: Diego Ledesma, José David Barona, José A Hurtado
# Fecha creación: 2022-07-10
# Fecha última modificación: 2022-08-17
# Versión: 0.2
# Licencia: GPL


Característica: Ejecutar la creación, evaluación, selección y reproducción de los cromosomas.

Antecedentes: controlar la búsqueda de soluciones al problema de las N damas empleando un algoritmo evolutivo basado en los cromosomas.
  Dado que se necesita ubicar 8 reinas en un tablero de ajedrez, se quiere emplear un algoritmo evolutivo con una poblacion de 100 posibles soluciones, una capacidad evolutiva de 50 generaciones con 30 individuos generando una descendencia de 40 hijos en cada generacion.

  #populate
  Escenario: Se crea un arreglo de 100 cromosomas al azar
    Cuando Se desea generar una población de cromosomas aleatorios
   Entonces arroja un arreglo de cromosomas de tamaño 100


  Escenario: Se genera un mating pool de 30 individuos en cada generación
    Cuando Se desea seleccionar los individuos que van a reproducirse en base a su aptitud.
    Entonces el mating pool es un arreglo de cromosomas de tamaño 30


  Escenario: Se ha especificado que se desea generar una descendencia de 40 individuos en cada generación
    Cuando se reproducen los individuos del mating pool
   Entonces la descendencia  es un arreglo de cromosomas de tamaño 40


  Escenario: Se pasa de una generación a la siguiente
    Cuando Se pasa de una generación a la siguiente
   Entonces los arreglos de cromosomas del mating pool y de la descendencia deben ser distintos a los de la generación anterior


  Escenario: desea generar un algoritmo evolutivo que premie a los individuos más aptos. Con 100 individuos, 50 generaciones, un mating pool de 30 individuos y una descendencia de 40.
     Entonces se debe estar en la generación 50, el mating pool debe tener 30 individuos y la descendencia debe contener 40 individuos.


########        NOVELTY        #########
  Escenario: Se genera un mating pool de 30 individuos en cada generación
    Cuando Se desea seleccionar los individuos que van a reproducirse con base a la novedad de su comportamiento.
    Entonces el mating pool es un arreglo de cromosomas de tamaño 30


  Escenario: Se pasa de una generación a la siguiente en evolución por novedad
    Cuando Se pasa de una generación a la siguiente -novelty-
   Entonces los arreglos de cromosomas del mating pool y de la descendencia deben ser distintos a los de la generación anterior


  Escenario: desea generar un algoritmo evolutivo que premie a los individuos más novedosos. Con 100 individuos, 50 generaciones, un mating pool de 30 individuos y una descendencia de 40.
    Cuando Se realiza la evolución que premia la aptitud.
   Entonces se debe estar en la generación 50, el mating pool debe tener 30 individuos y la descendencia debe contener 40 individuos.


########        NOVELTY        #########
  Escenario: se genera un mating pool de 30 individuos en cada generación
    Cuando se desea seleccionar los individuos que van a reproducirse tanto en base a la novedad de su comportamiento como en base a su aptitud.
    Entonces el mating pool es un arreglo de cromosomas de tamaño 30


  Escenario: Se pasa de una generación a la siguiente en evolución por objetivos múltiples
    Cuando Se pasa de una generación a la siguiente -multiobjective-
   Entonces los arreglos de cromosomas del mating pool y de la descendencia deben ser distintos a los de la generación anterior


  Escenario: desea generar un algoritmo evolutivo que premie a los individuos tanto por novedad como por aptitud. Con 100 individuos, 50 generaciones, un mating pool de 30 individuos y una descendencia de 40.
  Cuando Se realiza la evolución que premia la aptitud.
   Entonces se debe estar en la generación 50, el mating pool debe tener 30 individuos y la descendencia debe contener 40 individuos.






















