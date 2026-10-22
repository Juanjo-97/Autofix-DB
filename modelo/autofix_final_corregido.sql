-- AutoFix: script completo de tablas, relaciones y datos de prueba
-- No elimina la base de datos ni las tablas existentes.
-- Ordenado para poder ejecutarse desde una base vacia.

CREATE DATABASE IF NOT EXISTS autofix;
USE autofix;

-- 1. Clientes
CREATE TABLE IF NOT EXISTS cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    correo VARCHAR(100),
    direccion VARCHAR(150)
) ENGINE=InnoDB;

-- 2. Inventario
CREATE TABLE IF NOT EXISTS inventario (
    id_inventario INT AUTO_INCREMENT PRIMARY KEY,
    ubicacion VARCHAR(100) NOT NULL,
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 3. Mecanicos
CREATE TABLE IF NOT EXISTS mecanico (
    id_mecanico INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    especialidad VARCHAR(80) NOT NULL,
    telefono VARCHAR(20),
    estatus VARCHAR(30) NOT NULL
) ENGINE=InnoDB;

-- 4. Vehiculos: cada vehiculo pertenece a un cliente
CREATE TABLE IF NOT EXISTS vehiculo (
    id_vehiculo INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    marca VARCHAR(50) NOT NULL,
    modelo VARCHAR(50) NOT NULL,
    anio YEAR,
    placa VARCHAR(15) NOT NULL UNIQUE,
    color VARCHAR(30),
    CONSTRAINT fk_vehiculo_cliente
        FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
) ENGINE=InnoDB;

-- 5. Ordenes: relacionadas con cliente, vehiculo y mecanico
CREATE TABLE IF NOT EXISTS orden_trabajo (
    id_orden INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_vehiculo INT NOT NULL,
    id_mecanico INT NOT NULL,
    tipo_atencion VARCHAR(50) NOT NULL,
    fecha_creacion DATE NOT NULL,
    estado VARCHAR(30) NOT NULL,
    observaciones VARCHAR(255),
    CONSTRAINT fk_orden_cliente
        FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    CONSTRAINT fk_orden_vehiculo
        FOREIGN KEY (id_vehiculo) REFERENCES vehiculo(id_vehiculo),
    CONSTRAINT fk_orden_mecanico
        FOREIGN KEY (id_mecanico) REFERENCES mecanico(id_mecanico)
) ENGINE=InnoDB;

-- 6. Recepcion de servicios
CREATE TABLE IF NOT EXISTS recepcion_servicio (
    id_recepcion INT AUTO_INCREMENT PRIMARY KEY,
    id_vehiculo INT NOT NULL,
    fecha_recepcion DATETIME NOT NULL,
    tipo_servicio VARCHAR(30) NOT NULL,
    descripcion_falla VARCHAR(255),
    estado VARCHAR(30) NOT NULL,
    CONSTRAINT fk_recepcion_vehiculo
        FOREIGN KEY (id_vehiculo) REFERENCES vehiculo(id_vehiculo)
) ENGINE=InnoDB;

-- 7. Diagnosticos
CREATE TABLE IF NOT EXISTS diagnostico (
    id_diagnostico INT AUTO_INCREMENT PRIMARY KEY,
    id_orden INT NOT NULL UNIQUE,
    fecha_diagnostico DATE NOT NULL,
    descripcion VARCHAR(255) NOT NULL,
    observaciones VARCHAR(255),
    CONSTRAINT fk_diagnostico_orden
        FOREIGN KEY (id_orden) REFERENCES orden_trabajo(id_orden)
) ENGINE=InnoDB;

-- 8. Presupuestos
CREATE TABLE IF NOT EXISTS presupuesto (
    id_presupuesto INT AUTO_INCREMENT PRIMARY KEY,
    id_orden INT NOT NULL UNIQUE,
    fecha_generacion DATE NOT NULL,
    costo_mano_obra DECIMAL(10,2) NOT NULL,
    costo_refacciones DECIMAL(10,2) NOT NULL,
    costo_total DECIMAL(10,2) NOT NULL,
    estatus VARCHAR(30) NOT NULL,
    observaciones VARCHAR(255),
    CONSTRAINT fk_presupuesto_orden
        FOREIGN KEY (id_orden) REFERENCES orden_trabajo(id_orden)
) ENGINE=InnoDB;

-- 9. Refacciones
CREATE TABLE IF NOT EXISTS refaccion (
    id_refaccion INT AUTO_INCREMENT PRIMARY KEY,
    id_inventario INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255),
    existencia INT NOT NULL DEFAULT 0,
    precio_unitario DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_refaccion_inventario
        FOREIGN KEY (id_inventario) REFERENCES inventario(id_inventario)
) ENGINE=InnoDB;

-- 10. Detalle de refacciones usadas en cada orden
CREATE TABLE IF NOT EXISTS detalle_refaccion (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_orden INT NOT NULL,
    id_refaccion INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_detalle_orden
        FOREIGN KEY (id_orden) REFERENCES orden_trabajo(id_orden),
    CONSTRAINT fk_detalle_refaccion
        FOREIGN KEY (id_refaccion) REFERENCES refaccion(id_refaccion)
) ENGINE=InnoDB;

-- 11. Facturas; fecha_emision es DATE para evitar advertencias al guardar solo la fecha
CREATE TABLE IF NOT EXISTS factura (
    id_factura INT AUTO_INCREMENT PRIMARY KEY,
    id_orden INT NOT NULL UNIQUE,
    fecha_emision DATE NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    impuestos DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    total DECIMAL(10,2) NOT NULL,
    metodo_pago VARCHAR(50) NOT NULL,
    CONSTRAINT fk_factura_orden
        FOREIGN KEY (id_orden) REFERENCES orden_trabajo(id_orden)
) ENGINE=InnoDB;

-- 12. Garantias
CREATE TABLE IF NOT EXISTS garantia (
    id_garantia INT AUTO_INCREMENT PRIMARY KEY,
    id_factura INT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    descripcion VARCHAR(255) NOT NULL,
    estatus VARCHAR(30) NOT NULL DEFAULT 'Vigente',
    CONSTRAINT fk_garantia_factura
        FOREIGN KEY (id_factura) REFERENCES factura(id_factura)
) ENGINE=InnoDB;

-- Datos de prueba. Los IDs fijos permiten que las relaciones sean faciles de revisar.
-- ON DUPLICATE KEY evita duplicar estos ejemplos al volver a ejecutar el script.
INSERT INTO cliente (id_cliente, nombre, telefono, correo, direccion) VALUES
(1, 'Carlos Lopez', '6641234567', 'carlos@email.com', 'Tijuana Baja California'),
(2, 'Maria Garcia', '6656454764', 'maria@email.com', 'Tijuana Baja California')
ON DUPLICATE KEY UPDATE id_cliente = VALUES(id_cliente);

INSERT INTO inventario (id_inventario, ubicacion) VALUES
(1, 'Almacen principal')
ON DUPLICATE KEY UPDATE id_inventario = VALUES(id_inventario);

INSERT INTO mecanico (id_mecanico, nombre, especialidad, telefono, estatus) VALUES
(1, 'Jose Martinez', 'Frenos', '6195550101', 'Activo'),
(2, 'Luis Hernandez', 'Electricidad automotriz', '6195550102', 'Activo')
ON DUPLICATE KEY UPDATE id_mecanico = VALUES(id_mecanico);

INSERT INTO vehiculo (id_vehiculo, id_cliente, marca, modelo, anio, placa, color) VALUES
(1, 1, 'Toyota', 'Corolla', 2020, 'AUTOFIX001', 'Blanco'),
(2, 2, 'Honda', 'Civic', 2021, 'AUTOFIX002', 'Negro')
ON DUPLICATE KEY UPDATE id_vehiculo = VALUES(id_vehiculo);

INSERT INTO orden_trabajo
    (id_orden, id_cliente, id_vehiculo, id_mecanico, tipo_atencion, fecha_creacion, estado, observaciones)
VALUES
(1, 1, 1, 1, 'Taller', CURRENT_DATE, 'En proceso', 'Revision de frenos'),
(2, 2, 2, 2, 'Domicilio', CURRENT_DATE, 'Pendiente', 'Revisar vehiculo que no enciende')
ON DUPLICATE KEY UPDATE id_orden = VALUES(id_orden);

INSERT INTO recepcion_servicio
    (id_recepcion, id_vehiculo, fecha_recepcion, tipo_servicio, descripcion_falla, estado)
VALUES
(1, 1, NOW(), 'Taller', 'Falla en los frenos', 'Recibido'),
(2, 2, NOW(), 'Domicilio', 'El vehiculo no enciende', 'Pendiente')
ON DUPLICATE KEY UPDATE id_recepcion = VALUES(id_recepcion);

INSERT INTO diagnostico
    (id_diagnostico, id_orden, fecha_diagnostico, descripcion, observaciones)
VALUES
(1, 1, CURRENT_DATE, 'Desgaste en las balatas delanteras', 'Se recomienda revisar los frenos'),
(2, 2, CURRENT_DATE, 'El vehiculo no enciende', 'Revisar bateria y sistema electrico')
ON DUPLICATE KEY UPDATE id_diagnostico = VALUES(id_diagnostico);

INSERT INTO presupuesto
    (id_presupuesto, id_orden, fecha_generacion, costo_mano_obra, costo_refacciones, costo_total, estatus, observaciones)
VALUES
(1, 1, CURRENT_DATE, 1200.00, 2000.00, 3200.00, 'Aprobado', 'Cambio de balatas'),
(2, 2, CURRENT_DATE, 500.00, 1800.00, 2300.00, 'Pendiente', 'Reparacion electrica')
ON DUPLICATE KEY UPDATE id_presupuesto = VALUES(id_presupuesto);

INSERT INTO refaccion
    (id_refaccion, id_inventario, nombre, descripcion, existencia, precio_unitario)
VALUES
(1, 1, 'Balatas delanteras', 'Juego de balatas para automovil', 10, 850.00),
(2, 1, 'Bateria 12V', 'Bateria para automovil', 5, 1500.00)
ON DUPLICATE KEY UPDATE id_refaccion = VALUES(id_refaccion);

INSERT INTO detalle_refaccion
    (id_detalle, id_orden, id_refaccion, cantidad, precio_unitario, subtotal)
VALUES
(1, 1, 1, 2, 850.00, 1700.00),
(2, 2, 2, 1, 1500.00, 1500.00)
ON DUPLICATE KEY UPDATE id_detalle = VALUES(id_detalle);

INSERT INTO factura
    (id_factura, id_orden, fecha_emision, subtotal, impuestos, total, metodo_pago)
VALUES
(1, 1, CURRENT_DATE, 2900.00, 232.00, 3132.00, 'Tarjeta'),
(2, 2, CURRENT_DATE, 2000.00, 160.00, 2160.00, 'Efectivo')
ON DUPLICATE KEY UPDATE id_factura = VALUES(id_factura);

INSERT INTO garantia
    (id_garantia, id_factura, fecha_inicio, fecha_fin, descripcion, estatus)
VALUES
(1, 1, CURRENT_DATE, DATE_ADD(CURRENT_DATE, INTERVAL 90 DAY), 'Garantia de reparacion de frenos', 'Vigente'),
(2, 2, CURRENT_DATE, DATE_ADD(CURRENT_DATE, INTERVAL 90 DAY), 'Garantia de reparacion electrica', 'Vigente')
ON DUPLICATE KEY UPDATE id_garantia = VALUES(id_garantia);

-- Verificacion de tablas
SHOW TABLES;

-- Verificacion de llaves foraneas (debe mostrar 12 relaciones)
SELECT TABLE_NAME, COLUMN_NAME, REFERENCED_TABLE_NAME, REFERENCED_COLUMN_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'autofix'
  AND REFERENCED_TABLE_NAME IS NOT NULL
ORDER BY TABLE_NAME, COLUMN_NAME;

-- Consulta de prueba: debe mostrar 2 ordenes conectadas
SELECT
    ot.id_orden,
    c.nombre AS cliente,
    CONCAT(v.marca, ' ', v.modelo) AS vehiculo,
    m.nombre AS mecanico,
    d.descripcion AS diagnostico,
    p.costo_total AS presupuesto,
    r.nombre AS refaccion,
    dr.cantidad,
    f.total AS factura,
    g.estatus AS garantia
FROM orden_trabajo AS ot
JOIN cliente AS c ON c.id_cliente = ot.id_cliente
JOIN vehiculo AS v ON v.id_vehiculo = ot.id_vehiculo
JOIN mecanico AS m ON m.id_mecanico = ot.id_mecanico
LEFT JOIN diagnostico AS d ON d.id_orden = ot.id_orden
LEFT JOIN presupuesto AS p ON p.id_orden = ot.id_orden
LEFT JOIN detalle_refaccion AS dr ON dr.id_orden = ot.id_orden
LEFT JOIN refaccion AS r ON r.id_refaccion = dr.id_refaccion
LEFT JOIN factura AS f ON f.id_orden = ot.id_orden
LEFT JOIN garantia AS g ON g.id_factura = f.id_factura;
