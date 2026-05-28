-- ============================================
-- PROYECTO SEMANAL: Funciones de Agregación
-- Semana 06 — COUNT, SUM, AVG, GROUP BY, HAVING
-- ============================================

-- NOTA: Usa el esquema de tu Semana 03. Adapta nombres al dominio.
USE drogueria_db;

-- ============================================
-- REPORTE 1: Totales globales
-- ============================================
-- TODO: Cuenta todos los registros y calcula suma/promedio
--       de la columna numérica más relevante de tu dominio

SELECT 
    COUNT(*) AS total_transacciones_ventas,
    SUM(total_venta) AS ingresos_totales,
    AVG(total_venta) AS ticket_promedio
FROM ventas;

-- ============================================
-- REPORTE 2: Extremos
-- ============================================
-- TODO: Obtén el valor mínimo y máximo de la columna numérica

SELECT 
    MIN(precio_venta) AS precio_producto_mas_barato,
    MAX(precio_venta) AS precio_producto_mas_caro
FROM productos;

-- ============================================
-- REPORTE 3: Subtotales por categoría (GROUP BY)
-- ============================================
-- TODO: Agrupa por la columna de categoría/tipo principal de tu dominio
--       y calcula COUNT + AVG o SUM para cada grupo

SELECT 
    metodo_pago,
    COUNT(*) AS cantidad_ventas,
    SUM(total_venta) AS ingresos_por_metodo,
    AVG(total_venta) AS promedio_por_metodo
FROM ventas
GROUP BY metodo_pago
ORDER BY cantidad_ventas DESC;

-- ============================================
-- REPORTE 4: Filtro de grupos (HAVING)
-- ============================================
-- TODO: Muestra solo los grupos que superen un umbral de negocio

-- Muestra los proveedores que nos suministran más de 2 productos diferentes
SELECT 
    proveedor_id,
    COUNT(*) AS cantidad_productos_suministrados
FROM productos
GROUP BY proveedor_id
HAVING COUNT(*) > 2
ORDER BY cantidad_productos_suministrados DESC;