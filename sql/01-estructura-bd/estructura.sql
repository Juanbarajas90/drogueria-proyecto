CREATE DATABASE IF NOT EXISTS drogueria_db;
USE drogueria_db;

-- ============================================================================
-- PARTE 1: ESTRUCTURA DDL (Con Constraints de la Semana 07)
-- ============================================================================

-- 1. Tabla de Categorías (Nueva - Agrupa los productos)
CREATE TABLE categorias_medicamentos (
    categoria_id INT AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    CONSTRAINT pk_categorias PRIMARY KEY (categoria_id)
) ENGINE=InnoDB;

-- 2. Tabla de Proveedores
CREATE TABLE proveedores (
    proveedor_id INT AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    nit VARCHAR(20) UNIQUE NOT NULL,
    telefono VARCHAR(15),
    direccion VARCHAR(255),
    email VARCHAR(100),
    CONSTRAINT pk_proveedores PRIMARY KEY (proveedor_id)
) ENGINE=InnoDB;

-- 3. Tabla de Productos (Modificada con constraints requeridos)
CREATE TABLE productos (
    producto_id INT AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    codigo_barras VARCHAR(50) UNIQUE NOT NULL, -- CONSTRAINT UNIQUE
    precio_venta DECIMAL(12, 2) NOT NULL CHECK (precio_venta > 0), -- CONSTRAINT CHECK
    stock_minimo INT DEFAULT 5, -- CONSTRAINT DEFAULT
    estado_activo BOOLEAN DEFAULT TRUE, -- CONSTRAINT DEFAULT
    registro_invima VARCHAR(50), -- COLUMNA OPCIONAL (Permite NULL)
    proveedor_id INT,
    categoria_id INT NOT NULL, -- Nueva relación obligatoria
    CONSTRAINT pk_productos PRIMARY KEY (producto_id),
    CONSTRAINT fk_producto_proveedor FOREIGN KEY (proveedor_id) 
        REFERENCES proveedores(proveedor_id) ON DELETE SET NULL,
    CONSTRAINT fk_producto_categoria FOREIGN KEY (categoria_id) 
        REFERENCES categorias_medicamentos(categoria_id) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- 4. Tabla de Inventario (Movimientos)
CREATE TABLE inventario (
    inventario_id INT AUTO_INCREMENT,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL,
    tipo_movimiento ENUM('entrada', 'salida', 'ajuste') NOT NULL,
    fecha_movimiento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    observaciones VARCHAR(255),
    CONSTRAINT pk_inventario PRIMARY KEY (inventario_id),
    CONSTRAINT fk_inventario_producto FOREIGN KEY (producto_id) 
        REFERENCES productos(producto_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 5. Tabla de Ventas (Cabecera)
CREATE TABLE ventas (
    venta_id INT AUTO_INCREMENT,
    fecha_venta DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_venta DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    metodo_pago ENUM('efectivo', 'tarjeta', 'transferencia') NOT NULL,
    CONSTRAINT pk_ventas PRIMARY KEY (venta_id)
) ENGINE=InnoDB;

-- 6. Tabla Detalle de Ventas (Intermedia)
CREATE TABLE detalle_ventas (
    detalle_id INT AUTO_INCREMENT,
    venta_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    precio_unitario DECIMAL(12, 2) NOT NULL,
    subtotal DECIMAL(12, 2) AS (cantidad * precio_unitario) STORED,
    CONSTRAINT pk_detalle PRIMARY KEY (detalle_id),
    CONSTRAINT fk_detalle_venta FOREIGN KEY (venta_id) 
        REFERENCES ventas(venta_id) ON DELETE CASCADE,
    CONSTRAINT fk_detalle_producto FOREIGN KEY (producto_id) 
        REFERENCES productos(producto_id)
) ENGINE=InnoDB;