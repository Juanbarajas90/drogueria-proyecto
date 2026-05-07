# 💊 Sistema de Gestión - Droguería & Minimercado (DB Model)

Este repositorio contiene la definición estructural y lógica de una base de datos diseñada para la gestión integral de una droguería. El objetivo principal es proporcionar un entorno robusto para la práctica avanzada del sublenguaje **DQL (Data Query Language)** en MySQL.

## 🏗️ Estructura del Proyecto
- `/sql/ddl_structure.sql`: Definición de tablas, tipos de datos y restricciones.
- `/sql/dml_seed.sql`: Inserción de registros masivos para pruebas (Próximamente).
- `/docs/diagrama_er.png`: Representación visual de las relaciones.

## 🧠 Diccionario de Entidades y Lógica

### 1. Categorias & Marcas (Maestras)
Para evitar la redundancia y permitir consultas de agrupación (GROUP BY), se separan las propiedades del producto.
- **Relación:** `1:N` con Productos.
- **DQL Útil:** "Total de ventas por categoría de medicamento".

### 2. Productos
Define el "qué" es el objeto, pero no el "cuánto" hay (eso lo hace el inventario).
- **Restricción:** `precio_venta` siempre > 0.
- **Tipos de datos:** `DECIMAL(12,2)` para precisión financiera, evitando errores de redondeo de `FLOAT`.

### 3. Inventario (Lotes y Stock)
Esta es la entidad crítica. Una droguería maneja **Lotes**.
- **Campos clave:** `fecha_vencimiento`, `numero_lote`, `stock_actual`.
- **Relación:** `N:1` con Productos (Un producto puede tener varios lotes activos).
- **DQL Útil:** "Listar productos que vencen en los próximos 3 meses y cuyo stock sea menor a 10 unidades".

### 4. Proveedores
Almacena la información de contacto y fiscal (NIT).
- **Restricción:** `UNIQUE` en el NIT para evitar duplicidad de registros legales.

### 5. Empleados (Cajeros/Regentes)
Permite la trazabilidad de la operación.
- **DQL Útil:** "Ranking de empleados con mayor ticket promedio de venta".

### 6. Ventas (Cabecera y Detalle)
Se aplica **Normalización**. La cabecera guarda el *cuándo* y el *quién*; el detalle guarda el *qué* y a *cuánto*.
- **Relación:** `1:N` entre Ventas y Detalle_Ventas.
- **Cálculo:** El `subtotal` es una columna generada (STORED) para asegurar integridad matemática.

---

## 🔗 Matriz de Relaciones y Cardinalidad

| Entidad Origen | Entidad Destino | Cardinalidad | FK (Clave Foránea) |
| :--- | :--- | :--- | :--- |
| `categorias` | `productos` | 1 : N | `id_categoria` |
| `marcas` | `productos` | 1 : N | `id_marca` |
| `productos` | `inventario_lotes`| 1 : N | `id_producto` |
| `empleados` | `ventas` | 1 : N | `id_empleado` |
| `ventas` | `detalle_ventas` | 1 : N | `id_venta` |
| `inventario_lotes`| `detalle_ventas` | 1 : N | `id_lote` |

## 🛠️ Restricciones de Integridad (Business Rules)
1. **No Acción en Borrado:** No se pueden eliminar productos que tengan historial en `detalle_ventas` (Integridad referencial).
2. **Check Constraints:** Se validan que las cantidades en inventario no sean negativas.
3. **Timestamping:** Todas las ventas e ingresos de inventario registran automáticamente la hora del servidor.