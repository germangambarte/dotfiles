## 1. Definiciones y Conceptos Fundamentales

### a. Definiciones de Claves
* **Clave Candidata:** Es un conjunto de atributos que identifica de manera unívoca a cada tupla de una relación.
* **Clave Primaria (CP):** Es la clave candidata elegida por el diseñador para identificar de forma principal las tuplas en la relación. No puede contener valores nulos.
* **Clave Alternativa:** Son aquellas claves candidatas que no fueron seleccionadas como clave primaria.
* **Clave Foránea (CF):** Es un conjunto de atributos en una relación ($R_1$) cuyos valores deben coincidir con los valores de la clave primaria de otra relación ($R_2$) o ser totalmente nulos.

### b. ¿Qué es una tupla?
Una **tupla** es un elemento de una relación que se considera como un conjunto finito de pares **(atributo, valor)**. En términos prácticos, representa una fila o registro en una tabla.

### c. Orden y Clave Primaria
* **Orden:** Las tuplas de una relación **no tienen un orden específico**. Esto es una consecuencia directa de que una relación se define matemáticamente como un conjunto, y en los conjuntos el orden de los elementos no es relevante.
* **Existencia de CP:** Una relación **no puede carecer de clave primaria**. La definición de relación exige que sea un conjunto de tuplas, y para que sea un conjunto, cada elemento debe ser único; la clave primaria es la herramienta que garantiza esa unicidad e integridad.

### d. ¿Puede una relación carecer de clave foránea?
**Sí.** Las claves foráneas se utilizan para establecer vínculos o referencias entre relaciones (integridad referencial). Si una relación no necesita referenciar a otra para mantener la consistencia de los datos, no tiene la obligación de poseer una clave foránea.

### e. ¿Una clave foránea puede contener valores nulos?
**Sí.** Según la regla de integridad referencial, un valor de clave foránea puede ocurrir como valor de una clave primaria en la relación referenciada **o bien ser totalmente nulo**. Esto permite representar casos donde la asociación entre las entidades es opcional.

## 2. Propiedad de Clausura en el Álgebra Relacional

### Definición
La **Propiedad de Clausura** establece que todos los operadores del álgebra relacional actúan sobre relaciones y producen como resultado una **nueva relación**.

### Consecuencias
* **Anidamiento:** Al ser el resultado de una operación una relación, esta puede ser utilizada inmediatamente como argumento de otra operación.
* **Expresiones Complejas:** Permite la creación de expresiones del álgebra relacional muy complejas mediante la combinación de operadores simples.
* **Manipulación:** Facilita la consulta y transformación de datos manteniendo siempre la estructura del modelo relacional (nombre, atributos y dominios).
