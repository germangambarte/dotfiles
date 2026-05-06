## Caso 1. Comercio Minorista

Un comercio dedicado a la venta de productos de almacén necesita gestionar y mantener los datos de los productos que comercializa, así como de las facturas de venta que genera. A continuación, se detallan los datos específicos a considerar:

- Productos: Código (único), nombre, rubro, precio actual y condición de almacenamiento.
- Facturas: Numero de factura (único), fecha, productos incluidos (especificando el precio al que se vendió y la cantidad de unidades vendidas), importe total y CUIL del cliente.

### Restricciones:

- Los clientes son argentinos.
- La condición de almacenamiento refiere a si necesita ser refrigerado, congelado, mantenido en un ambiente seco, etc.
- La condición de almacenamiento es la misma para todos los productos pertenecientes a un mismo rubro.

## Caso 2. Gestión de Viviendas

El gobierno de la provincia de San Juan lo ha contratado para diseñar la base de datos que guarde información relativa a las viviendas y a sus habitantes. A tal fin, es necesario que se mantenga la información detallada a continuación:

- Municipalidades: Nombre, dirección y teléfono de contacto.
- Viviendas: Número de nomenclatura catastral, dirección, teléfono fijo, tipo (casa o departamento),
  propietario/s y quien/es la habitan.
- Propietarios; CUIL, nombre y fecha de nacimiento.
- Habitantes (independientemente sean los dueños o no de la vivienda): CUIL, nombre y fecha de nacimiento.

### Restricciones:

- Los habitantes de una vivienda, pueden o no ser los propietarios de dicha vivienda.
- Cada persona puede habitar solamente una vivienda, pero en la misma pueden habitar varias personas.
- Una persona puede ser propietaria de varias viviendas.
- Una vivienda puede tener varios dueños.
- Las personas son argentinas.
- La municipalidad permite conocer donde se encuentra una vivienda.

### Diseño lógico

#### Entidades

- municipalidad: {**nombreMuni**, dirMuni, telMuni, nomenclaturaViv}
  - cp: {nombreMuni}
- vivienda: {**nomenclaturaViv**, telViv, dirViv,tipoViv, cuilPersona, nombreMuni}
  - cp: {nomenclaturaViv}
  - cf: {nombreMuni}
- persona: {**cuilPersona**, nomPersona, fechaNacPersona, nomenclaturaViv}
  - cp: {cuilPersona}
  - cf: {nomenclaturaViv}

#### Relaciones

- posee: {**cuilPersona**, **nomenclaturaViv**}
  - cp: {cuilPersona, nomenclaturaViv}
  - cf: {nomenclaturaViv}
  - cf: {cuilPersona}

## Caso 3. Freelancers

Un sitio de ofertas de empleos freelance necesita diseñar una base de datos que permita registrar información de las empresas, los freelancers y las propuestas de empleo.
En cuanto a las empresas se registra código identificatorio (único), nombre, país de residencia y moneda oficial de ese país. Respecto a los freelancers, correo electrónico, nombre de usuario, teléfonos, fecha de nacimiento, edad y los rubros en los que está capacitado. Las propuestas de empleo poseen un número (valor creciente dentro de cada empresa), período en el que está activa (fecha de inicio y fecha de finalización), rubro al que pertenece y rango de montos que la empresa está dispuesta a pagar (fijando monto máximo y mínimo). Cada vez que un freelancer se postula a una propuesta lo hace en una fecha concreta (dentro del período en el que la propuesta está activa), indica el monto que desea cobrar (debiera estar dentro del rango estipulado en la propuesta) y la duración que le llevaría la tarea. Un freelancer se postula solo una vez a una propuesta específica.

### Mi solucion

- empresa = {**codEmpresa**, nomEmpresa}
  - cp = {codEmpresa}
- pais = {**nombrePais**, monedaPais}
  - cp = {nombrePais}
- redicada = {**codEmpresa**, **nombrePais**}
  - cp = {codEmpresa, nombrePais}
  - cf = {codEmpresa}
  - cf = {nombrePais}
- propuesta = {**codEmpresa**, **nroProp**, fechaInicioProp, fechaFinProp, sueldoMinProp, sueldoMaxProp,nombreRubro}
  - cp = {codEmpresa, nroProp}
  - cf = {codEmpresa}
  - cf = {nombreRubro}
- freelancer = {**usuarioFree**, correoFree, fechaNacFree}
  - cp = {usuarioFree}
- telFree = {**usuarioFree**, **telFree**}
  - cp = {usuarioFree, telFree}
  - cf = {usuarioFree}
- postula = {**nroProp**, **usuarioFree**}
  - cp = {nroProp, usuarioFree}
  - cf = {nroProp}
  - cf = {usuarioFree}
- rubro = {**nombreRubro**}
  - cp = {nombreRubro}
- realiza = {**usuarioFree**, **nombreRubro**}
  - cp = {usuarioFree, nombreRubro}
  - cf = {usuarioFree}
  - cf = {nombreRubro}

### Caso 4. Congreso

Se necesita generar una base de datos que permita administrar la información relativa a un congreso a desarrollarse en la Facultad de Ciencias Exactas, Físicas y Naturales. El congreso abarca varias áreas temáticas, y para cada una de ellas se constituye un comité evaluador, encargado de analizar y calificar los trabajos presentados. Los comités están pueden estar integrados por investigadores/docentes de la facultad o bien externos.
De las salas donde se llevana cabo las exposiciones, se debe mantener su número (valor único), el piso en el que se encuentra y la capacidad máxima de personas.
Los trabajos que se presentan se clasifican en 2 categorías o tipos: Tutoriales y Conferencias. Dichos trabajos (independientemente del tipo) tienen un título y un código que los identifican unívocamente dentro del área a la que pertenecen. También es necesario poder consignar el área temática a la que pertenecen, sus autores, expositores, además de la sala, fecha y horario de exposición. Los inscriptos al congreso pueden asistir a 2 tutoriales y a las conferencias que deseen. El certificado debe indicar solo los tutoriales a los que asistió una persona, por lo que no es necesario registrar las conferencias elegidas para cada asistente.
Nota: No se deben registrar en la base de datos los certificados, pero sí contar con los datos necesarios para generarlos. Los datos personales de las personas involucradas en el evento son: CUIL, nombre, dirección, teléfono particular, teléfono celular, provincia, dirección de correo electrónico (puede tener más de uno) y título de grado o postgrado que posean (se registra el de mayor jerarquía).

## Restricciones:

- Todas las personas son argentinas.
- Una persona puede ser autor, expositor y miembro de un comité simultáneamente.
- Una persona puede ser miembro de sólo un comité evaluador.
- Una persona puede ser autor de muchos trabajos de cualquier área.
- Una persona puede exponer más de un trabajo, por supuesto debe ser autora del mismo.
- Cada trabajo se presenta solo una vez.
- Dentro del comité es necesario poder distinguir a los docentes/investigadores que sean externos.

## Caso 5. Dirección General de Rentas

La Dirección General de Rentas de la provincia de San Juan (DGRSJ) lo ha convocado a realizar el diseño de la base de datos que permita gestionar el cobro de impuestos (del automotor, inmobiliario, etc.) a los contribuyentes, el cual se efectiviza a través de boletas, independientemente del tipo de impuesto del que se trate.
La DGRSJ ha habilitado diferentes lugares/entidades donde se pueden efectuar los pagos. De ellos se conoce: número (los identifican unívocamente dentro de la provincia), domicilio y teléfono/s de contacto. Las boletas poseen un código de barra que las identifica unívocamente, el bien al que corresponde (un automóvil, un inmueble, etc.), y un código de pago electrónico (código link). Además, contienen fecha de emisión, fecha de vencimiento, mes (mes del año que se está pagando), año e importe correspondiente al pago en término (es decir, el día del vencimiento). Sin embargo, el importe pagado por el contribuyente podría variar según la fecha en la que realizó el pago; si lo hizo antes del vencimiento tiene un porcentaje de descuento y si lo hizo posteriormente, un porcentaje de recargo. Cabe mencionar que los porcentajes de descuento y de recargo no son los mismos para todos los tipos de impuestos, concretamente dependen del tipo de impuesto del que se trate. Por ejemplo, el inmobiliario aplica un 5% de descuento por pago anticipado, y un 6% de incremento por pago vencido; el del automotor, aplica otros porcentajes, etc. Obviamente estos datos deben registrarse.
Las boletas pagadas deben mantener el importe pagado además de la fecha y el lugar donde se efectuó el pago. En relación a los bienes para los que se pagan impuestos, se registra número que los identifica, descripción, avalúo (monto en dólares) y el o los propietarios. De los contribuyentes se registran los siguientes datos: CUIL, nombre, apellido, teléfono celular y correo electrónico.
Nota: Las boletas corresponden al pago de algún tipo de impuesto, para un mes/año específico.

### Restricciones:

- Los contribuyentes son argentinos.
- Los bienes se identifican por un número único.

## Caso 6. Empresa Minera

Una empresa minera necesita una base de datos que mantenga información inherente a los distintos proyectos que se están ejecutando en diferentes provincias de nuestro país. Cada proyecto es desarrollado en una provincia y tiene un código que lo identifica, como así también una denominación. Es necesario almacenar también fecha de inicio, duración aproximada e inversión estimada.
De los geólogos ha de mantenerse: país de nacimiento, número de documento, CUIL, nombre, apellido, fecha de nacimiento, género, ciudad, provincia y país de residencia, además del teléfono celular. Por cada proyecto se extraen muestras, identificadas unívocamente por un código, también se debe registrar la fecha/hora de extracción y las coordenadas geográficas (latitud y longitud) del lugar específico. Es importante identificar el geólogo que la extrajo, el proyecto al que pertenece y el tipo de muestra correspondiente (por ejemplo, de sedimentos de río, de suelo, etc.). En cada muestra se indican los elementos (o minerales) que se requieren analizar y así encontrar el valor correspondiente. Esa información es necesaria mantenerla, además del valor mínimo de concentración de cada mineral para que sea económicamente viable extraerlo. Esa información permitirá reconocer los minerales relevantes encontrados en las muestras.
Por otra parte, también se debe mantener los tipos de máquinas (perforadoras, topadoras, etc.) que se utilizaron en los proyectos, a qué empresa se las alquiló y cuál fue el importe pagado. Es necesario además tener un registro de las empresas que alquilan estas maquinarias (tipos de máquinas) para tener una referencia a quien alquilar cuando se necesita una en específico (no todos los proveedores tienen todos los tipos de maquinarias). Por ejemplo, la base de datos debería poder informar que la empresa “Igarreta Máquinas S.A.” alquila solamente topadoras y perforadoras; por lo que, si un proyecto necesitara una retroexcavadora, debiera buscar otro proveedor. De los proveedores se debe mantener su CUIT, nombre, teléfono, provincia donde está radicado, y provincias donde puede prestar servicios.

### Restricciones:

- El nombre de las provincias es único dentro de cada país.
- Un geólogo puede extraer muestras en distintos proyectos.
- Un país está dividido geográficamente en provincias.
- Una ciudad tiene un código que la identifica unívocamente y pertenece solamente a una provincia. De las ciudades también se debe mantener su nombre, que podría no ser único.
- En relación a los países y provincias, lo único que se debe mantener es su nombre.
- Cada empresa proveedora posee un CUIT (único).
- Se registra la fecha en la que un proyecto alquila un tipo de maquinaria a su empresa proveedora (la alquila las veces
  que sea necesaria).
- Un proyecto puede utilizar en más de una ocasión un mismo tipo de maquinaria, y alquilarla a la misma empresa.
- Los geólogos pueden o no ser extranjeros.

## Caso 7. Venta por Delivery

Una compañía de delivery online argentina lo convoca a realizar el diseño de la base de datos necesaria para gestionar sus pedidos. Para ello, el portal administra la siguiente información:
Por un lado, los datos referidos a las empresas proveedoras de los productos ofrecidos en el portal. De ellas se conoce: número de CUIT, nombre, teléfono, rubro y sucursales que posee. De las sucursales se conoce: número de la sucursal (identificado unívocamente aun entre empresas diferentes), dirección, teléfono de contacto, y localidad, ciudad y provincia donde se encuentra, además de la calificación promedio obtenida de las opiniones de sus clientes y la franja horaria establecida para la recepción de pedidos. Por ejemplo Mcdonald’s Patio Alvear - San Juan atiende en horario de 12:00 a 23:00. Cabe aclarar que el horario es el mismo para todos los días de la semana, y es de corrido.
Conjuntamente se mantienen los datos correspondientes a los productos ofrecidos por empresa, a saber: código (único por empresa), nombre, descripción, ingredientes (opcionalmente) y foto. Es importante indicar que cada sucursal posee su propia lista de precios.
De los clientes usuarios del portal, se registra: correo electrónico, nombre de usuario, dirección (calle, número, orientación) y localidad de residencia. El pedido de un cliente queda registrado a través de la factura de la sucursal donde realizó el pedido. De cada factura generada se mantiene su número (único), fecha-hora, detalle de los productos solicitados (indicando precio y cantidad de los mismos) e importe total. También se especifica la dirección (calle, número, orientación), localidad y ciudad correspondiente donde se debe entregar. El cliente tiene la posibilidad de indicar entre qué calles se localiza el destino.
Los clientes pueden calificar y comentar el desempeño de las sucursales. Por ejemplo, Josefina calificó a Mcdonald’s Patio Alvear - San Juan con 4 , el 16 mayo de 2020 a las 23:05 hs. y su comentario fue “El único detalle es que pedí bebida sin hielo y trajeron con hielo, lo demás excelente”.
Debe consignarse la forma de pago correspondiente a cada factura (pedido). Cada empresa tiene habilitados sus propios medios de pago (transferencia, tarjeta de crédito, etc.).

### Restricciones:

● Los clientes y las empresas adheridas son argentinas.
● Las localidades son identificadas unívocamente por su código postal dentro del territorio argentino.
● Los nombres de ciudades y provincias son únicos.
● La calificación de los clientes la realizan cuando lo deseen, como máximo una por día.

## Caso 8. Inmobiliaria

Una inmobiliaria necesita poseer una base de datos que mantenga información de sus clientes, inmuebles, etc. Los clientes de la inmobiliaria ofertan para vender inmuebles a un precio determinado. Los inmuebles pueden ser de distintos tipos, esto es, casas, departamentos, fincas, etc. Es importante registrar el número catastral, superficie total, superficie cubierta, dirección y zona de cada inmueble, como así también los servicios que posee, es decir, agua, energía eléctrica, gas natural, teléfono, etc.
La inmobiliaria además de recibir ofertas de ventas, también recibe pedidos de compra, de manera de poder informar que, por ejemplo se vende una casa determinada en Rivadavia (zona), a una persona que necesita comprar una casa en Rivadavia. Por lo tanto, cuando una persona requiere comprar un inmueble, se deberá registrar el tipo de inmueble y la zona en la que el cliente lo necesita.
Cuando se efectúa una operación de venta , ésta queda asentada en un contrato que es identificado unívocamente por un número. Además se registra fecha de firma, importe de la venta, porcentaje de comisión, comprador, vendedor y por supuesto el inmueble en cuestión. Y operativamente, la oferta de ese inmueble y el pedido correspondiente son eliminados de la base de datos.

### Restricciones:

- De las personas que son propietarias y/o compradores, se mantiene número de CUIL (todos son argentinos), nombre y apellido, teléfono de contacto, email, fecha de nacimiento y lugar de trabajo.

## Caso 9. Empleados del Gobierno Provincial

El gobierno de nuestra provincia desea generar una base de datos que permita gestionar datos referidos a sus empleados, como así también a las inscripciones de los nuevos aspirantes a cargos vacantes.
De sus empleados se debe mantener: Nombre completo, número de CUIL, fecha de nacimiento, género, teléfono celular, teléfono fijo, domicilio (calle, número, orientación) y localidad dónde vive. Es importante conocer la/s oficina/s dónde trabajó/trabaja actualmente, como así mismo el tipo de cargo (fiscal, defensor, etc.) que desempeñó/a indicando el período.
En cuanto a las oficinas, cada una tiene un número que la identifica, nombre, teléfonos de contacto, horarios de atención y el ministerio (Ministerio de Justicia, Ministerio de Hacienda, etc) al que pertenece. De cada ministerio se debe mantener su nombre (único) y su página web (url).
Por otra parte, cuando surge un cargo vacante, queda registrado a través de un expediente, los cuales son identificados por un número (único dentro de cada oficina), y especifican fecha, cargo, oficina y ministerio donde debe desempeñarse. Las personas interesadas en cubrir esos cargos vacantes (representados a través del expediente), deben inscribirse, dejando constancia de su nombre completo, CUIL, género, fecha de nacimiento, teléfono celular, teléfono fijo, domicilio (calle, número, orientación) y localidad dónde vive.

### Restricciones:

- Cada oficina tiene su propio horario de atención, que puede diferir para cada día de la semana. Por ejemplo la oficina de Titularización del Ministerio de Educación, atiende de lunes a viernes en horario de mañana de 7:30hs-12:30hs y en la tarde 15hs-18hs. Mientras que la oficina de Mesa de Entrada atiende Lunes, Miércoles y Viernes en horario de 8hs a 12hs en la mañana y por la tarde 16hs a 20hs y los días Martes y Jueves de 8hs a 16hs.
- Los cargos tienen un nombre que los identifica unívocamente y les corresponde una cantidad determinada de horas a cumplir y un sueldo a cobrar.
- Respecto a los trabajos de los empleados, debe mantenerse la fecha de alta y la fecha de baja (cuando corresponda).
- Un empleado sólo puede tener un trabajo en el gobierno de la provincia en una fecha determinada. Sólo podrá haber tenido varios en periodos de tiempo diferentes, inclusive con el mismo tipo de cargo, en la misma oficina e inclusive ministerio.
- Una persona puede inscribirse a varios cargos vacantes. Debe registrarse la fecha.
- Un empleado podría aspirar a ocupar otro trabajo, para ello deberá inscribirse al expediente correspondiente. En el caso de obtenerlo, debiera renunciar (darse de baja) al trabajo que tenía anteriormente.
- Es necesario conocer cargo, oficina y ministerio en el que trabaja actualmente cada empleado.
- Se necesita conocer la edad tanto de los empleados como de los aspirantes. Ambos siempre son argentinos.
- Es necesario poder identificar los expedientes cerrados, es decir, ya se cubrió la vacante correspondiente.

## Caso 10. Empresa de Electrodomésticos

La empresa argentina de productos electrodomésticos AS S.R.L (CUIT 30-12345678-9) necesita diseñar una base de datos que le permita gestionar información relativa a las reparaciones cubiertas por los centros autorizados. Cuando una persona compra un producto en AS y tiene algún problema dentro del periodo de garantía, debe dirigirse con la factura de compra, al centro más cercano para su reparación. El importe del arreglo queda a cargo de AS.
Para ello, necesita administrar datos relativos a los productos que comercializa, a saber, código (que permite identificarlo unívocamente), nombre (por ejemplo horno, lavarropas, heladera, etc.), modelo (123AG, XX1, etc.), tipo o rubro al que pertenece (refrigeración, entretenimiento, belleza, etc.) y la marca (Samsung, Whirpool, Gafa,etc). Cabe notar que cada marca brinda una garantía según el modelo del producto específico. La heladera Samsung 123AG tiene garantía por un año, mientras que la heladera Samsung XX1 tiene 6 meses, por ejemplo.
Por otro lado, necesita mantener datos relativos a los centros de reparación. De ellos se debe registrar, número de CUIT, dirección, email, ciudad y provincia donde se encuentran; además, de la/s marca/s y el/los tipo/s de productos que está preparado para reparar. Asimismo, la empresa AS debe mantener los datos de contacto de los centros para poder proporcionarlos a sus clientes en el caso de que lo necesiten, concretamente debe almacenar los teléfonos fijos y el número de whatsapp. También deben mantener los días y horarios de atención de cada centro de reparación.
AS debe registrar los arreglos (pedidos de reparación) informados por los centros de reparación, a saber: número de pedido de reparación generado por el centro correspondiente, fecha del pedido, problemas del producto, piezas (repuestos) utilizadas (cambiadas) para la reparación, fecha en la que se hizo entrega del producto reparado, el importe correspondiente al arreglo y el nro. de la factura correspondiente a la compra.

### Restricciones:

- Cada centro de reparación puede brindar el servicio de reparación para varias marcas y para diferentes tipos de productos (o rubros, por ejemplo: refrigeración, entretenimiento, belleza, etc.). Es decir, un centro X puede reparar artículos de refrigeración de la marca BGH y Samsung, y no para Gafa. Sin embargo, puede arreglar artículos de cocina (cocinas, anafes, etc.) de la marca Gafa.
- Todos los centros de atención atienden en horario corrido, pero no necesariamente mantienen el mismo horario de lunes a sábado.
- Los números de los pedidos de reparación son únicos para cada centro.
- Los pedidos de reparación involucran solo un producto. Si el cliente solicitara el arreglo de más de un producto de la misma o distinta factura, se genera un pedido por cada uno.
- Cada producto reparado puede haber necesitado o no cambio de pieza/s.
- Los códigos de modelos son únicos, es decir, no se repiten para diferentes marcas.
- Los nombres de ciudades no se repiten en todo el país.

## Caso 11. Oficina de Riesgo Agropecuario

La Oficina de Riesgo Agropecuario de nuestro país los ha convocado a realizar el diseño de la base de datos necesaria para implementar un registro de cultivos y fincas en nuestro país. A continuación, se describen los datos que debe mantener:
De cada cultivo (tomate perita, tomate platense, zapallo inglés, etc.) se conoce: nombre científico que lo identifica unívocamente, nombre común y las estaciones del año donde es propicio cultivarlo.
En cuanto a las fincas se detalla: número catastral, superficie total (cantidad de hectáreas), el o los propietarios en caso de existir más de un dueño, la localidad y provincia donde se encuentra la finca y los cultivos que se han sembrado, aclarando la cantidad de hectáreas y la fecha.
Respecto de los propietarios se detalla: nombre y apellido, teléfono celular y número de documento.
Por otra parte, se debe tener un registro de cuál/es cultivos son prioritarios dentro de cada provincia argentina, con la finalidad de poder conocer si se está cultivando lo que se precisa.
Además, es fundamental que para cada siembra se especifique el/los plaguicidas utilizados, en qué cantidad (expresada en kg.) y en qué fecha se aplicó. En cuanto a los plaguicidas se detalla: nombre, código único y fabricante. Como medida de precaución también se indica si está o no prohibido su uso en algún otro país (no se deben registrar los países).
Nota: Es fundamental poder conocer los plaguicidas que se aplicaron en cada siembra.

### Restricciones:

- Las fincas tienen un número catastral que es único dentro de cada localidad.
- Para cada siembra en una finca concreta, se debe conocer la cantidad sembrada (en hectáreas) de los distintos cultivos.
- Los propietarios pueden ser argentinos o extranjeros.
- Los nombres de las localidades pueden repetirse en diferentes provincias .
- Una localidad se ubica en una provincia.
- En una finca se pueden sembrar varios cultivos en una misma fecha o en fechas diferentes.
- En una finca puede sembrarse el mismo cultivo en fechas diferentes.
- Una finca puede sembrar un mismo cultivo en más de una oportunidad.

## Caso 12. Carreras de caballos de nuestra provincia

### Restricciones:

- Las carreras se identifican por un número (único) y se realizan en una fecha/hora determinada.
- Los caballos se identifican por su número de chip.
- Todo caballo tiene un padre y una madre.
- Los caballos pueden ser pura sangre o mestizos.
- Debe conocerse el/los studs por los que un caballo pasó en su vida, sin importar las fechas, ni la secuencia, etc. (Un stud es un establecimiento dedicado a la cría y cuidado de caballos).
- Los nombres de stud no se repiten.
- Los jinetes pueden ser argentinos o extranjeros.
- En cuanto al nombre y apellido de los jinetes, deben poder distinguirse.
- Las carreras son mixtas, es decir, pueden participar caballos de pura sangre junto con mestizos.
- Es importante conocer los participantes de cada carrera, es decir, qué caballos y con qué jinete participan.
- Un caballo puede competir en la misma carrera que sus progenitores, inclusive con caballos con los que tenga cualquier grado de parentesco.
- En una carrera, cada caballo es montado por un jinete (jockey).
- Un jinete puede participar en varias carreras, pero en cada carrera solo puede montar a un caballo.
- Para cada carrera, se registra tiempo y puesto logrado por los participantes.
- Interesa conocer el peso del jockey como del caballo, al momento de cada carrera.
- Para cada carrera, debe conocerse el stud al que pertenece (stud actual) cada caballo participante.
  a) Indique si es correcto o no. Justifique. En el caso que presente errores, genere el modelo correcto.
