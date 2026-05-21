-- ============================================
-- PROYECTO SEMANAL: NULL y Constraints
-- Semana 07 — NOT NULL, UNIQUE, CHECK, FK
-- ============================================

-- Activar claves foráneas (obligatorio si usas SQLite, en MySQL/MariaDB se omitiría esta línea)
-- PRAGMA foreign_keys = ON; 

-- Si lo ejecutas en tu base de datos MySQL, asegúrate de usarla:
USE drogueria_db;

-- ============================================
-- PARTE 1: ESQUEMA CON CONSTRAINTS
-- ============================================

-- TODO: Crear la tabla de categorías/grupos de tu dominio
--       Incluir: PK, NOT NULL, UNIQUE donde aplique
CREATE TABLE categorias_medicamentos (
    categoria_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE
);

-- TODO: Crear la tabla principal con todos los constraints
--       Incluir: PK, FK, NOT NULL, UNIQUE, CHECK, DEFAULT
CREATE TABLE inventario_items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre_producto VARCHAR(100) NOT NULL,
    -- Columna con UNIQUE (Código de barras o SKU del medicamento)
    codigo_barras VARCHAR(50) UNIQUE NOT NULL,
    -- Columna numérica con CHECK (El precio no puede ser negativo ni cero)
    precio_venta DECIMAL(12, 2) NOT NULL CHECK (precio_venta > 0),
    -- Columna con DEFAULT (Indica si el producto está activo para la venta)
    estado_activo BOOLEAN DEFAULT TRUE,
    -- COLUMNA OPCIONAL (Permite NULL para probar COALESCE - Ej: Registro sanitario)
    registro_invima VARCHAR(50), 
    categoria_id INT NOT NULL,
    CONSTRAINT fk_item_categoria FOREIGN KEY (categoria_id) 
        REFERENCES categorias_medicamentos(categoria_id) ON DELETE RESTRICT
);

-- ============================================
-- PARTE 2: DATOS DE PRUEBA
-- ============================================

-- TODO: Insertar 3 categorías
INSERT INTO categorias_medicamentos (nombre) VALUES
    ('Analgésicos y Antipiréticos'),
    ('Antibióticos'),
    ('Suplementos y Vitaminas');

-- TODO: Insertar 6 items, al menos 2 con columna_opcional = NULL
INSERT INTO inventario_items (nombre_producto, codigo_barras, precio_venta, estado_activo, registro_invima, categoria_id) VALUES
    -- Registros completos
    ('Acetaminofén 500mg', '7701234567890', 1500.00, TRUE, 'INVIMA-2020M-001', 1),
    ('Amoxicilina 500mg', '7709876543210', 8500.00, TRUE, 'INVIMA-2018M-002', 2),
    ('Vitamina C 1g', '7701122334455', 12000.00, TRUE, 'INVIMA-2021M-003', 3),
    ('Ibuprofeno 400mg', '7705544332211', 2500.00, TRUE, 'INVIMA-2019M-004', 1),
    
    -- Registros con columna_opcional (registro_invima) en NULL (Pendientes de registro)
    ('Azitromicina Genérica', '7709988776655', 15000.00, FALSE, NULL, 2),
    ('Colágeno Importado', '7703344556677', 45000.00, TRUE, NULL, 3);

-- ============================================
-- PARTE 3: CONSULTAS CON NULL
-- ============================================

-- TODO: Mostrar items donde columna_opcional IS NULL
SELECT 
    item_id, 
    nombre_producto, 
    precio_venta
FROM inventario_items
WHERE registro_invima IS NULL;

-- TODO: Mostrar todos los items usando COALESCE para reemplazar NULL
SELECT
    nombre_producto,
    precio_venta,
    COALESCE(registro_invima, 'Trámite Pendiente') AS estado_registro
FROM inventario_items;