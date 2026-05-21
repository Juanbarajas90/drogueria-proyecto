# Sistema de Gestión para Droguería - Base de Datos

En este repositorio comparto la estructura y lógica de una base de datos relacional que diseñé con base al dominio entregado por el profesor: **Drogueria**. 

## Estructura de este Repositorio

Para llevar un orden lógico, dividí el proyecto en estos archivos:

*   `/sql/ddl_structure.sql`: Aquí está la creación de las tablas, los tipos de datos exactos y todas las reglas de restricción (`UNIQUE`, `CHECK`, Llaves Foráneas).
*   `/sql/dml_seed.sql`: Mi script con más de 40 registros de prueba por cada tabla. Lo hice así para tener un volumen de datos real con el cual probar consultas pesadas y reportes.
*   `/docs/diagrama_er.png`: El mapa visual que muestra cómo se conecta todo.

## ¿Cómo pensé las tablas?

No quise hacer tablas por hacerlas; cada decisión tiene un porqué técnico para evitar que el sistema falle a futuro:

### 1. Categorías y Proveedores (Los catálogos base)
Separé las categorías (ej. Analgésicos, Antibióticos) y los proveedores en sus propias tablas. 
*   **¿Por qué?** Para no repetir texto. Además, si luego necesito sacar un reporte de "qué categoría vende más", usar un `GROUP BY` sobre un ID numérico es mucho más rápido y exacto.
*   **El control:** A los proveedores les puse la regla `UNIQUE` en el campo del NIT. Así la base de datos bloquea cualquier intento de registrar una misma empresa dos veces.

### 2. Productos (El inventario teórico)
Esta tabla es solo mi catálogo. Define qué vendemos, pero no cuánto hay físicamente.
*   **Reglas estrictas:** El precio tiene un candado (`CHECK (precio_venta > 0)`); es imposible registrar algo gratis o con precio negativo. Además, usé el tipo de dato `DECIMAL(12,2)` para manejar el dinero de forma exacta, ya que los tipos `FLOAT` suelen dar errores de redondeo.
*   **Datos opcionales:** Dejé la columna del Registro INVIMA permitiendo valores vacíos (`NULL`). Lo hice a propósito para poder practicar funciones de SQL que manejan datos faltantes, como `COALESCE`.

### 3. Inventario (La trazabilidad real)
En vez de poner una columna de "stock_actual" que simplemente suma y resta, creé una tabla para registrar **movimientos**.
*   **¿Por qué?** Aquí anoto cada `entrada`, `salida` o `ajuste`. Esto me deja un historial completo. Sé exactamente cuándo y por qué se movió la mercancía. 

### 4. Ventas y Detalle de Ventas (La facturación)
Dividí las ventas en dos partes. La tabla `ventas` (la cabecera) guarda el cuándo y el método de pago. La tabla `detalle_ventas` guarda exactamente qué medicamentos se llevaron en esa factura.
*   **Cálculo Automático:** En el detalle, le dije a la base de datos que el `subtotal` se calcule y se guarde solo (`AS (cantidad * precio_unitario) STORED`). De esta forma, la matemática se hace a nivel de la base de datos y me aseguro de que jamás exista un error de cálculo en las facturas.

---

## Así se relacionan las tablas

Esta es la forma en la que conecté todo mediante Llaves Foráneas (Foreign Keys):

| Origen | Destino | Relación | Columna de conexión |
| :--- | :--- | :--- | :--- |
| `categorias_medicamentos` | `productos` | 1 a Muchos | `categoria_id` |
| `proveedores` | `productos` | 1 a Muchos | `proveedor_id` |
| `productos` | `inventario` | 1 a Muchos | `producto_id` |
| `productos` | `detalle_ventas` | 1 a Muchos | `producto_id` |
| `ventas` | `detalle_ventas` | 1 a Muchos | `venta_id` |

## Reglas de Negocio (Protegiendo los datos)

Para asegurar que los datos no se dañen si alguien borra o inserta algo mal, configuré estas restricciones:

1.  **Cuidado al borrar (Cascade & Restrict):** Si intento borrar una categoría que ya tiene productos asignados, el sistema me detiene (`ON DELETE RESTRICT`). Pero, si cancelo y borro una venta completa, sus detalles se borran automáticamente (`ON DELETE CASCADE`) para no dejar datos basura huérfanos.
2.  **Fechas automáticas:** No tengo que estar enviando la fecha y hora desde el código cada vez que hago una venta o muevo el inventario. La base de datos pone la hora del sistema por defecto (`DEFAULT CURRENT_TIMESTAMP`).