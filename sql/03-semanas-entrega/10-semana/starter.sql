USE drogueria_db;

-- ============================================================================
-- PROYECTO SEMANAL: SELF JOIN en el dominio drogueria_db
-- Semana 10 — CROSS JOIN y SELF JOIN 
-- ============================================================================

-- ============================================================================
-- CONSULTA 1: SELF JOIN básico (INNER JOIN)
-- Mostrar la subcategoría y su categoría padre.
-- ============================================================================
SELECT 
    hijo.nombre AS subcategoria,
    padre.nombre AS categoria_principal
FROM categorias_medicamentos hijo
INNER JOIN categorias_medicamentos padre ON hijo.parent_id = padre.categoria_id;

-- ============================================================================
-- CONSULTA 2: Incluir la raíz con LEFT JOIN
-- Mostrar todas las categorías. Si es una categoría principal, indicar 'Raíz'.
-- ============================================================================
SELECT 
    hijo.nombre AS categoria,
    COALESCE(padre.nombre, '--- Nivel Raíz ---') AS depende_de
FROM categorias_medicamentos hijo
LEFT JOIN categorias_medicamentos padre ON hijo.parent_id = padre.categoria_id
ORDER BY depende_de, categoria;

-- ============================================================================
-- CONSULTA 3: Contar hijos por padre
-- Cuántas subcategorías directas tiene cada categoría principal.
-- ============================================================================
SELECT 
    padre.nombre AS categoria_principal,
    COUNT(hijo.categoria_id) AS total_subcategorias
FROM categorias_medicamentos padre
LEFT JOIN categorias_medicamentos hijo ON hijo.parent_id = padre.categoria_id
GROUP BY padre.categoria_id, padre.nombre
HAVING COUNT(hijo.categoria_id) > 0
ORDER BY total_subcategorias DESC;

-- ============================================================================
-- CONSULTA BONUS: CROSS JOIN (Producto Cartesiano)
-- Matriz de combinaciones entre categorías y métodos de pago posibles.
-- ============================================================================
SELECT 
    c.nombre AS categoria,
    m.metodo_pago
FROM categorias_medicamentos c
CROSS JOIN (
    SELECT DISTINCT metodo_pago FROM ventas
) m
WHERE c.parent_id IS NOT NULL 
ORDER BY c.nombre, m.metodo_pago;