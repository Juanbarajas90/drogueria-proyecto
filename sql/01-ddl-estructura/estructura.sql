CREATE DATABASE IF NOT EXISTS drogueria_db;
USE drogueria_db;

-- 1. Tabla de Proveedores
-- Se crea primero porque los productos dependen de ellos.
CREATE TABLE proveedores (
    proveedor_id INT AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    nit VARCHAR(20) UNIQUE NOT NULL,
    telefono VARCHAR(15),
    direccion VARCHAR(255),
    email VARCHAR(100),
    CONSTRAINT pk_proveedores PRIMARY KEY (proveedor_id)
) ENGINE=InnoDB;

-- 2. Tabla de Productos
-- Incluye restricciones de integridad y tipos de datos precisos.
CREATE TABLE productos (
    producto_id INT AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio_venta DECIMAL(12, 2) NOT NULL CHECK (precio_venta > 0),
    stock_minimo INT DEFAULT 5,
    proveedor_id INT,
    CONSTRAINT pk_productos PRIMARY KEY (producto_id),
    CONSTRAINT fk_producto_proveedor FOREIGN KEY (proveedor_id) 
        REFERENCES proveedores(proveedor_id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- 3. Tabla de Inventario (Movimientos)
-- Para trackear entradas y salidas de stock de forma auditable.
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

-- 4. Tabla de Ventas (Cabecera)
CREATE TABLE ventas (
    venta_id INT AUTO_INCREMENT,
    fecha_venta DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_venta DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    metodo_pago ENUM('efectivo', 'tarjeta', 'transferencia') NOT NULL,
    CONSTRAINT pk_ventas PRIMARY KEY (venta_id)
) ENGINE=InnoDB;

-- 5. Tabla Detalle de Ventas (Intermedia)
-- Crucial para saber qué productos se vendieron en cada factura.
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