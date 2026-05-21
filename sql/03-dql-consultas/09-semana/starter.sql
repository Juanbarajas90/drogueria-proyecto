-- ============================================

-- PROYECTO SEMANAL: JOINs aplicados a tu dominio

-- Semana 09 — INNER JOIN y LEFT JOIN

-- ============================================
SELECT
p.nombre_producto AS item,
m.fecha_registro,
m.tipo_movimiento
FROM productos_farmacia p
INNER JOIN movimientos_inventario m ON m.producto_id = p.producto_id;

-- ============================================
-- CONSULTA 2: JOIN con tres tablas
-- TODO: Encadena main_items + child_records + reference_table
-- ============================================

SELECT
p.nombre_producto AS item,
c.nombre_categoria AS category,
m.fecha_registro,
m.tipo_movimiento
FROM productos_farmacia p
INNER JOIN categorias_farmacia c ON p.categoria_id = c.categoria_id
INNER JOIN movimientos_inventario m ON m.producto_id = p.producto_id;

-- ============================================
-- CONSULTA 3: LEFT JOIN — todos los registros
-- TODO: Obtén todos los items aunque no tengan child_records
-- ============================================

SELECT
p.nombre_producto AS item,
m.fecha_registro AS activity,
m.tipo_movimiento
FROM productos_farmacia p
LEFT JOIN movimientos_inventario m ON m.producto_id = p.producto_id;

-- ============================================
-- CONSULTA 4: Detectar huérfanos (registros sin actividad)
-- TODO: Agrega WHERE para mostrar solo ítems sin child_records
-- ============================================

SELECT
p.nombre_producto AS item_sin_actividad
FROM productos_farmacia p
LEFT JOIN movimientos_inventario m ON m.producto_id = p.producto_id
WHERE m.movimiento_id IS NULL;

-- ============================================
-- CONSULTA 5: Reporte agregado con LEFT JOIN + COUNT
-- TODO: Cantidad de child_records por item (incluye 0)
-- ============================================

SELECT
p.nombre_producto AS item,
COUNT(m.movimiento_id) AS total_records
FROM productos_farmacia p
LEFT JOIN movimientos_inventario m ON m.producto_id = p.producto_id
GROUP BY p.nombre_producto
ORDER BY total_records DESC;