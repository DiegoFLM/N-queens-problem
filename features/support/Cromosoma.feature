# language: es
# encoding: utf-8
# Archivo: VerificarCromosoma.feature
# Autores: Diego Ledesma, José David Barona, José A Hurtado
# Fecha creación: 2022-07-10
# Fecha última modificación: 2022-08-17
# Versión: 0.2
# Licencia: GPL


Característica: Creación de cromosoma y evaluación de sus métodos.

Antecedentes: Crear un cromosoma
  Dado un arreglo de enteros 3,5,2,4,1,7,0,6 se genera un cromosoma nuevo como candidata a solución a partir de este arreglo inicial

  Escenario: Creación de cromosoma
    Cuando el cromosoma es 1,6,4,7,0,3,5,2
    Entonces debe indicar que el cromosoma creado contiene las posiciones que se le indicaron en el mismo orden.

  Escenario: Cromosoma aleatorio
    Cuando el cromosoma es 5,4,0,1,6,2,7,3
    Y se pide que genere un cromosoma aleatorio
    Entonces debe cumplirse que para el cromosoma aleatorio generado, en su arreglo de enteros no tiene números repetidos. Además, si el cromosoma es de tamaño 8, su primer gen debe ser menor o igual a: 3

  Escenario: aptitud
    Cuando el cromosoma es 3,5,2,4,1,7,0,6
    Y se mide su aptitud
    Entonces debe indicar que fitness es igual a 0.964285


  Escenario: aptitud
    Cuando el cromosoma es 3,5,2,4,1,7,0,6
    Y se mide su aptitud
    Entonces debe indicar que fitness es igual a 0.964285


  Escenario: aptitud
    Cuando el cromosoma es 5,4,0,1,6,2,7,3
    Y se mide su aptitud
    Entonces debe indicar que fitness es igual a 0.892857


  Escenario: aptitud
    Cuando el cromosoma es 1,3,5,7,6,4,0,2 
    Y se mide su aptitud
    Entonces debe indicar que fitness es igual a 0.892857


  Escenario: aptitud
    Cuando el cromosoma es 2,0,7,5,6,3,4,1 
    Y se mide su aptitud
    Entonces debe indicar que fitness es igual a 0.714285


  Escenario: aptitud
    Cuando el cromosoma es 0,2,1,3,5,6,4,7
    Y se mide su aptitud
    Entonces debe indicar que fitness es igual a 0.75

##Un ataque mutuo es una pareja de damas en la misma diagonal.
##Los ataques mutuos tienen en cuenta que un ataque entre dos damas 
##puede ocurrir a pesar de que haya otra dama atravesada en medio.
##Si en una posición hay únicamente dos damas atacándose mutuamente,
##la cantidad de ataques mutuos es 1.
##La máxima cantidad de ataques mutuos es 28, y ocurre cuando todas las 
##damas están en la misma diagonal.

  Escenario: ataques mutuos
    Cuando el cromosoma es 1,5,4,7,2,6,0,3 
    Y se cuentan los ataques mutuos
    Entonces debe indicar que la cantidad de ataques mutuos es 9


  Escenario: ataques mutuos
    Cuando el cromosoma es 1,6,4,7,0,3,5,2
    Y se cuentan los ataques mutuos
    Entonces debe indicar que la cantidad de ataques mutuos es 0


  Escenario: ataques mutuos
    Cuando el cromosoma es  3,6,2,7,1,4,0,5
    Y se cuentan los ataques mutuos
    Entonces debe indicar que la cantidad de ataques mutuos es 0


  Escenario: ataques mutuos
    Cuando el cromosoma es  2,4,0,7,1,6,3,5
    Y se cuentan los ataques mutuos
    Entonces debe indicar que la cantidad de ataques mutuos es 4


#Mutación: cromosomaPadre.makeChild -> Da lugar a un cromosoma donde dos valores del cromosomaPadre se han intercambiado.

  Escenario: mutación
   Cuando el cromosoma es 3,4,0,6,5,2,7,1
    Y el cromosoma muta
    Entonces debe indicar que hay 2 genes diferentes Además, todos los números son todos diferentes y el primer número debe ser menor o igual a 3


  Escenario: mutación
    Cuando el cromosoma es 3,1,6,4,0,7,5,2
    Y el cromosoma muta
    Entonces debe indicar que hay 2 genes diferentes Además, todos los números son todos diferentes y el primer número debe ser menor o igual a 3


  Escenario: mutación
    Cuando el cromosoma es 0,1,5,6,7,4,2,3
    Y el cromosoma muta
    Entonces debe indicar que hay 2 genes diferentes Además, todos los números son todos diferentes y el primer número debe ser menor o igual a 3



  Escenario: Distancia vertical media entre damas consecutivas
    Cuando el cromosoma es 0,1,5,6,7,4,2,3
    Y se le pide la distancia vertical media entre damas consecutivas
    Entonces la distancia vertical debe decir que es: 1.857142



  Escenario: Distancia vertical media entre damas consecutivas
    Cuando el cromosoma es 2,6,5,7,1,3,4,0 
    Y se le pide la distancia vertical media entre damas consecutivas
    Entonces la distancia vertical debe decir que es: 2.857142



  Escenario: Distancia horizontal entre las dos damas especificadas por fila
    Cuando el cromosoma es 2,1,4,0,6,5,7,3
    Y se le pide la distancia horizontal entre las damas de la fila 2 y de la fila 6
    Entonces la distancia horizontal debe decir que es: 4 



  Escenario: Distancia horizontal entre las dos damas especificadas por fila
    Cuando el cromosoma es 0,7,4,5,2,6,3,1
    Y se le pide la distancia horizontal entre las damas de la fila 4 y de la fila 1
    Entonces la distancia horizontal debe decir que es: 5



#método: extremsDist
  Escenario: Distancia horizontal entre las damas de las filas extremo (0 y 7)
    Cuando el cromosoma es 3,6,0,5,1,7,2,4
    Y se le pide la distancia horizontal de los extremos entre las damas de la fila 0 y de la fila 7
    Entonces la distancia horizontal debe decir que es: 3


#método: extremsDist
 Escenario: Distancia horizontal entre las damas de las filas extremo (0 y 7)
    Cuando el cromosoma es 0,7,6,2,1,5,4,3
    Y se le pide la distancia horizontal de los extremos entre las damas de la fila 0 y de la fila 7
   Entonces la distancia horizontal debe decir que es: 1


#Método: centralDist
Escenario: Distancia horizontal entre las damas de las filas centrales
    Cuando el cromosoma es 2,1,5,4,0,6,7,3
    Y se le pide la distancia central horizontal entre las damas de la fila 3 y de la fila 4
    Entonces la distancia horizontal debe decir que es: 4


#Método: centralDist
  Escenario: Distancia horizontal entre las damas de las filas centrales
    Cuando el cromosoma es 0,2,7,6,1,5,4,3
    Y se le pide la distancia central horizontal entre las damas de la fila 3 y de la fila 4
    Entonces la distancia horizontal debe decir que es: 1


#Método meanRange(0, ((@@n - 1)/2).floor + 1) [0,4)
 Escenario: Para N = 8, fila promedio de las damas en el rango de las columnas 0 a la 3, incluyendo la columna 3.
   Cuando el cromosoma es 2,7,3,1,6,5,0,4 
    Y se le pide el promedio de las filas de las damas en las columnas 0 a 3, incluyendo la columna 3.
    Entonces debe decir que el promedio es: 3.25


#Método meanRange(0, ((@@n - 1)/2).floor + 1)
  Escenario: Para N = 8, fila promedio de las damas en el rango de las columnas 0 a la 3, incluyendo la columna 3.
    Cuando el cromosoma es 1,2,5,3,7,4,0,6
    Y se le pide el promedio de las filas de las damas en las columnas 0 a 3, incluyendo la columna 3.
    Entonces debe decir que el promedio es: 2.75


#Método calcBehavior
  Escenario: Se desea caracterizar el comportamiento de un cromosoma mediante un vector de números.
    Cuando el cromosoma es 3,1,6,7,0,5,2,4
    Y se le pide el vector que caracteriza su comportamiento.
    Entonces debe decir que es: 3.5714285714285716,1,7,4.25,3


#Método calcBehavior
  Escenario: Se desea caracterizar el comportamiento de un cromosoma mediante un vector de números.
    Cuando el cromosoma es 1,3,4,5,2,0,7,6
    Y se le pide el vector que caracteriza su comportamiento.
    Entonces debe decir que es: 2.4285714285714284,1,1,3.25,1

#Método behavDist(crom2)
  Escenario: Se desea conocer qué tan diferente es el comportamiento de dos cromosomas. 
    Cuando el primer cromosoma es 3,5,4,7,1,2,0,6 y el segundo cromosoma es 2,5,7,6,1,0,4,3
    Y se le pide al primer cromosoma que calcule su distancia al segundo cromosoma
    Entonces debe decir que la distancia euclidiana entre los cromosomas es: 1.5456489291701716


#Método behavDist(crom2)
  Escenario: Se desea conocer qué tan diferente es el comportamiento de dos cromosomas. 
    Cuando el primer cromosoma es 1,5,3,7,6,0,4,2 y el segundo cromosoma es 0,6,3,7,5,2,1,4
    Y se le pide al primer cromosoma que calcule su distancia al segundo cromosoma
    Entonces debe decir que la distancia euclidiana entre los cromosomas es: 1.737932151513777













 