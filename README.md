# 2020-Stack-Overflow-Data
Project for group 19 [Cristóbal Sepúlveda Á, Fabián Jaña, Maximiliano Aguilar S, Vicente Reyes]

## Overview
El objetivo del proyecto consiste en aplicar técnicas de procesamiento masivo de datos para analizar el conjunto de datos seleccionado (Stack Overflow), el cual será descrito
más adelante, este análisis tratará de responder preguntas como:
* ¿Cuántos usuarios activos e inactivos tiene actualmente (año 2020) el sitio Stack Overflow?
* ¿Que países reportan mayo cantidad de usuarios?
* ¿Cuales son los usuarios con mayor reputación definiendo una locación o país?
* ¿Cuáles son los usuarios que han escrito mayor cantidad de comentrios comenzando con "+1"?

## Data
Para el proyecto se utilizaron los datos de  [Stack Overflow](https://stackoverflow.com/), un sitio web de preguntas y respuestas para todo tipo
de programadores.
El conjunto de datos que se quería utilizar en un principio era el siguiente: [Kaggle.com - Stack Overflow Data](https://www.kaggle.com/stackoverflow/stackoverflow)
Sin embargo hubo complicaciones con la obtención de los datos mencionados anteriormente, por lo cual, se terminó por utilizar: [archive.org - Stack Exchange Data Dump](https://archive.org/details/stackexchange), los cuales tenían los mismos atributos que los datos encontrados en Kaggle.com. Por esto el análisis se realizó, en particular y debido al gran espacio en disco que utilizaban los datos de archive.org, solo con las tablas de usuarios (Users) y comentarios (Comments).

Para finalizar esta sección se entrega una breve descripción de cada tabla y sus atributos relevantes para el proyecto:

1. Users: Formato XML, alrededor de 12 millones de tuplas y ~4GB de espacio en disco.
- **Reputation:** número que asigna la reputación del usuario (ej: 59111, 15196, 101)
- **CreationDate:** Fecha en que se creó el usuario (ej: 2008-07-31T14:22:31.287)
- **LastAccessDate:** Fecha en que el usuario ingresó por última vez (ej: 2020-05-02T18:23:48.813)
- **Location:** Descripción del lugar en donde reside el usuario (ej: "Ottawa, Canada" , "Raleigh, NC, United States")
2. Comments: Formato XML, alrededor de 75.4 millones de tuplas y ~22GB de espacio en disco.
- **Text:** El texto que fue escrito por algún usuario (ej: "It will help if you give some details of which database you are using as techniques vary.")
- **UserId:** Identificación del usuario que escribió el comentario (ej: 3, 380)

## Methods
Para realizar el análisis sobre los datos se utilizó Pig: una herramienta de programación para producir jobs MapReduce en Hadoop, además para leer el formato
XML se necesitó utilizar "XPath" una funcionalidad para extraer texto de archivos XML.
La razón de elegir Pig para realizar el análisis se basó en que su sintaxis es más simple, con lo cual, fue posible centrarse más en las relaciones entre los datos.
Sin embargo, una de las consecuencias negativas del uso de Pig es que, se pueden llegar a realizar varios MapReduce sin advertirlo, y así obtener consultas
muy ineficientes lo cual tiene un impacto aún mayor con respecto a la escala de los datos utilzados (12m Tuplas y 79m tuplas). Esto, junto con lo acotado de los tiempos
desencadenó en que los objetivos del proyecto no fueran logrados del todo, tal como se verá en la siguiente sección.

## Results
Se organizarán los resultados obtenidos de acuerdo a las preguntas planteadas al inicio:
*  ¿Cuántos usuarios activos e inactivos tiene actualmente (año 2020) el sitio Stack Overflow?
Se realizó una consulta contenida en el archivo "InactiveUsersByCreationYear.pig" que obtenía los usuarios inactivos (considerados como los que no se logearon a su cuenta en lo que va de 2020)  y , para comparar, la cantidad total de usuarios, ambos resultados anteriores clasificados según el año en que los usuarios fueron creados.
Se presenta a continuación una tabla con los resultados obtenidos:

| Año de creación | Usuarios inactivos | Usuarios Registrados | Porcentaje de usuarios inactivos |
|:---------------:|:------------------:|:--------------------:|:--------------------------------:|
|       2008      |        10562       |         21653        |               48.78              |
|       2009      |        47468       |         78051        |               60.82              |
|       2010      |       149591       |        199327        |               75.05              |
|       2011      |       268884       |        358997        |               74.90              |
|       2012      |       536649       |        679458        |               78.98              |
|       2013      |       934226       |        1123534       |               83.15              |
|       2014      |       989484       |        1176302       |               84.12              |
|       2015      |       1050217      |        1254380       |               83.72              |
|       2016      |       1273565      |        1518292       |               83.88              |
|       2017      |       1446729      |        1730099       |               83.62              |
|       2018      |       1325445      |        1648472       |               80.40              |
|       2019      |       1124220      |        1724592       |               65.19              |
|       2020      |          0         |        971998        |                 0                |
|      Total      |      12485155      |        9157040       |               73.34              |

* ¿Que países reportan mayo cantidad de usuarios?
Para responder a esta pregunta se realizó, nuevamente, una consulta de Pig, la cual está disponible en el archivo "TopStackoverflowLocations.pig".
Se divide en dos partes:
1. Primero se agrupa a los usuarios por su atributo "Location" (descrito en la sección "Data") y se realiza un conteo para entregar usuarios clasificados por "Location"
    
2. Luego de agrupar por "Location", se cuenta el contenido de cada grupo, y se ordena descendientemente


| Cantidad De Usuarios| País           |
|:-----------------: |:-----------------:|
|     73627        |        India      |     
|       41073      |    United States  |        
|       35867      |     Germany       |           
|       27166      |       China       |   
|       21291      |     Francia       |    
|       19504      |  United Kingdom   |      
|       18123      |       Indonesia   |       
|       17786      |       Philippines |        
|       15227      |       Singapore   |       
|       14866      |       Pakistan    |     
|       14538      |       Canada      |     
|       14846      |       Israel      |       
|       13768      |       Egypt       |      
|      13653       |      Netherlands      |  

* ¿Cualés son los usuarios con mayor Reputación dado una Localización Específica?
Para responder a esta pregunta se realizó, nuevamente, una consulta de Pig, la cual está disponible en el archivo "TopUsersPerLocation.pig".
1. Primero se agrupa a los usuarios por su atributo "Location" (descrito en la sección "Data") y se realiza un conteo para entregar usuarios clasificados por "Location"
2. Luego se Toma un "Location" específico ("United States") y se retornan todos los usuarios que pertenezcan a esta "Location" ordenados de acuerdo a su reputación en el sitio.

| Reputación         | Nombre De Usuario | País              |
|:-----------------:|:-----------------:|:-----------------:|
|       98872        | Legend      |   United States   |
|       98815     | Charlie Martin      |   United States   |
|      94423         |   apsillers    |   United States   |
|       93356        |  Carl Meyer      |   United States   |
|          92558     |   Peter Hosey    |   United States   |
|            91170   | AnApprentice      |   United States   |
|         87036      |    Michael Gundlach   |   United States   |
|       85554        | Bob      |   United States   |
|       83688        | Ben Gottlieb      |   United States   |
|           83540    |    Ahmad Mageed   |   United States   |
|           82958    |  NotMe     |   United States   |
|          82597    | mmcdole      |   United States   |
|          79938     |    Derek 朕會功夫   |   United States   |
|          79323     |     Reinstate Monica  |   United States   |



* ¿Cuáles son los usuarios que han escrito mayor cantidad de comentrios comenzando con "+1"?
Esta consulta se implementó en el archivo "Top+1Commenters.pig", la cual filtra todos los comentarios que comienzan con "+1" de la tabla "Comments" y los agrupa según el Id de los usuarios, luego para cada Id se realiza un conteo de la cantidad de comentarios y se asocia al DisplayName de la tabla "Usuarios", con lo que se obtiene una tabla con el nombre de cada usuario y la cantidad de comentarios que han escrito que comienzan con "+1".
Los primeros 10 resultados se muestran en la siguiente tabla:


| UserName                   | Counter |
|:--------------------------:|:-------:|
| Alexei Levenkov            | 1054    |
| trashgod                   | 975     |
| Peter Lawrey               | 829     |
| WhozCraig                  | 689     |
| MarkJ                      | 632     |
| Mawg says reinstate Monica | 614     |
| S.Lott                     | 531     |
| David Heffernan            | 444     |
| camickr                    | 437     |
| David Rodríguez - dribeas  | 411     |

## Conclusion

## Appendix?

