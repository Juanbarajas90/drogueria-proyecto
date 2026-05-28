USE drogueria_db;

-- ============================================================================
-- PROYECTO SEMANAL: Subqueries en el dominio drogueria_db
-- Semana 11 — Subqueries (escalar, IN, EXISTS, FROM)
-- ============================================================================


-- ============================================================================
-- CONSULTA 1: Subquery escalar correlacionada en WHERE
-- OBJETIVO: Mostrar los productos cuyo precio de venta supera el promedio 
-- exacto de los productos de su misma categoría.
-- ============================================================================

SELECT
    p.nombre,
    p.precio_venta,
    c.nombre AS categoria
FROM productos p
INNER JOIN categorias_medicamentos c ON p.categoria_id = c.categoria_id
WHERE p.precio_venta > (
    -- Esta subconsulta calcula el promedio de precio SOLO para la categoría 
    -- del producto que se está evaluando en la fila actual de la consulta externa.
    SELECT AVG(p2.precio_venta)
    FROM productos p2
    WHERE p2.categoria_id = p.categoria_id
)
ORDER BY categoria, p.precio_venta DESC;


-- ============================================================================
-- CONSULTA 2: Subquery escalar en SELECT
-- OBJETIVO: Mostrar el precio del producto y compararlo visualmente con el 
-- promedio global de todos los productos de la droguería.
-- ============================================================================

SELECT
    nombre,
    precio_venta,
    -- Esta subconsulta devuelve un único número estático (el promedio global) 
    -- y se repite en cada fila del resultado.
    ROUND((SELECT AVG(precio_venta) FROM productos), 2) AS promedio_global_precio
FROM productos
ORDER BY precio_venta DESC;


-- ============================================================================
-- CONSULTA 3: NOT EXISTS — items sin actividad
-- OBJETIVO: Detectar productos huérfanos de ventas, es decir, productos 
-- que existen en el inventario pero que NUNCA han sido registrados en una venta.
-- ============================================================================

SELECT
    p.nombre AS producto_sin_ventas
FROM productos p
WHERE NOT EXISTS (
    -- EXISTS devuelve TRUE o FALSE. Busca si hay al menos una coincidencia 
    -- en el detalle de ventas para el producto actual.
    SELECT 1
    FROM detalle_ventas dv
    WHERE dv.producto_id = p.producto_id
);


-- ============================================================================
-- CONSULTA 4: Tabla derivada en FROM (Subquery en FROM)
-- OBJETIVO: Generar un reporte de categorías que agrupan a más de 3 productos, 
-- calculando esto desde una tabla temporal en memoria.
-- ============================================================================

SELECT
    stats_categorias.nombre_categoria,
    stats_categorias.total_productos
FROM (
    -- Tabla Derivada: Agrupa las categorías y cuenta cuántos productos tiene cada una.
    -- OBLIGATORIO: Debe tener un alias (stats_categorias).
    SELECT
        c.nombre AS nombre_categoria,
        COUNT(p.producto_id) AS total_productos
    FROM categorias_medicamentos c
    LEFT JOIN productos p ON c.categoria_id = p.categoria_id
    GROUP BY c.categoria_id, c.nombre
) AS stats_categorias
WHERE stats_categorias.total_productos > 3
ORDER BY stats_categorias.total_productos DESC;