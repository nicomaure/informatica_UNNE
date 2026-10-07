-- =============================================================================
-- Informatica II (UNNE) - Sistema de Alquiler de Bicicletas
-- Alumno: Nicolas Maure
-- Version con id autoincremental (esquema de clase) + reglas del TP
-- =============================================================================

DROP DATABASE IF EXISTS bicicletas_compartidas;
CREATE DATABASE bicicletas_compartidas
CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE bicicletas_compartidas;

-- =============================================================================
-- 1. TABLAS INDEPENDIENTES (sin claves foraneas)
-- =============================================================================

CREATE TABLE estacion (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    codigo_estacion VARCHAR(10)  NOT NULL UNIQUE,
    direccion       VARCHAR(150) NOT NULL,
    capacidad_max   INT          NOT NULL,
    CONSTRAINT chk_estacion_capacidad CHECK (capacidad_max > 0)
);

CREATE TABLE operario (
    id     INT AUTO_INCREMENT PRIMARY KEY,
    legajo INT          NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE usuario (
    id     INT AUTO_INCREMENT PRIMARY KEY,
    dni    VARCHAR(10)  NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL
);

-- =============================================================================
-- 2. TABLAS DEPENDIENTES (con claves foraneas por id)
-- =============================================================================

-- Relacion 1:N "ubica": la FK va del lado N (bicicleta).
-- RESTRICT: toda bicicleta debe estar en una estacion; primero hay que reubicarla.
CREATE TABLE bicicleta (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    numero_serie VARCHAR(20) NOT NULL UNIQUE,
    estado       VARCHAR(20) NOT NULL DEFAULT 'DISPONIBLE',
    id_estacion  INT         NOT NULL,
    CONSTRAINT chk_bici_estado
        CHECK (estado IN ('DISPONIBLE', 'EN USO', 'EN MANTENIMIENTO')),
    CONSTRAINT fk_bici_estacion FOREIGN KEY (id_estacion)
        REFERENCES estacion (id) ON DELETE RESTRICT
);

-- Atributo multivaluado "medio de pago": tabla propia.
-- CASCADE: las tarjetas pertenecen al usuario y se eliminan con el.
-- UNIQUE (id_usuario, numero_tarjeta): un usuario no repite la misma tarjeta.
CREATE TABLE usuario_medio_pago (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario     INT         NOT NULL,
    numero_tarjeta VARCHAR(20) NOT NULL,
    CONSTRAINT uq_medio_usuario_tarjeta UNIQUE (id_usuario, numero_tarjeta),
    CONSTRAINT fk_medio_usuario FOREIGN KEY (id_usuario)
        REFERENCES usuario (id) ON DELETE CASCADE
);

-- VIAJE: entidad central del negocio.
-- Dos FK a estacion con roles distintos (origen y destino).
-- RESTRICT en todas: no se pierde el historial de viajes.
-- fecha_fin y destino NOT NULL: el viaje se registra completo al devolver la bici.
CREATE TABLE viaje (
    id                  INT AUTO_INCREMENT PRIMARY KEY,
    fecha_inicio        DATETIME NOT NULL,
    fecha_fin           DATETIME NOT NULL,
    id_usuario          INT      NOT NULL,
    id_bicicleta        INT      NOT NULL,
    id_estacion_origen  INT      NOT NULL,
    id_estacion_destino INT      NOT NULL,
    CONSTRAINT chk_viaje_fechas CHECK (fecha_fin >= fecha_inicio),
    CONSTRAINT fk_viaje_usuario FOREIGN KEY (id_usuario)
        REFERENCES usuario (id) ON DELETE RESTRICT,
    CONSTRAINT fk_viaje_bici FOREIGN KEY (id_bicicleta)
        REFERENCES bicicleta (id) ON DELETE RESTRICT,
    CONSTRAINT fk_viaje_origen FOREIGN KEY (id_estacion_origen)
        REFERENCES estacion (id) ON DELETE RESTRICT,
    CONSTRAINT fk_viaje_destino FOREIGN KEY (id_estacion_destino)
        REFERENCES estacion (id) ON DELETE RESTRICT
);

-- TAREA_MANTENIMIENTO: entidad debil de estacion.
-- Tiene id propio, pero numero_tarea se numera por estacion:
-- UNIQUE (id_estacion, numero_tarea) conserva esa regla.
-- CASCADE hacia estacion (debil), RESTRICT hacia operario.
CREATE TABLE tarea_mantenimiento (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    id_estacion  INT          NOT NULL,
    numero_tarea INT          NOT NULL,
    fecha        DATE         NOT NULL,
    descripcion  VARCHAR(200) NOT NULL,
    id_operario  INT          NOT NULL,
    CONSTRAINT uq_tarea_estacion_numero UNIQUE (id_estacion, numero_tarea),
    CONSTRAINT fk_tarea_estacion FOREIGN KEY (id_estacion)
        REFERENCES estacion (id) ON DELETE CASCADE,
    CONSTRAINT fk_tarea_operario FOREIGN KEY (id_operario)
        REFERENCES operario (id) ON DELETE RESTRICT
);

-- =============================================================================
-- 3. DATOS DE PRUEBA (primero las independientes, luego las que tienen FK)
-- Los id se asignan solos desde 1 en el orden de insercion.
-- =============================================================================

-- Estaciones: id 1=E01, 2=E02, 3=E03, 4=E04, 5=E05, 6=B01 (prestada)
INSERT INTO estacion (codigo_estacion, direccion, capacidad_max) VALUES
    ('E01', 'Av. 9 de Julio 1200',        15),
    ('E02', 'Plaza 25 de Mayo s/n',       10),
    ('E03', 'Costanera y Av. 3 de Abril', 20),
    ('E04', 'Parque Mitre',                8),
    ('E05', 'Terminal de Omnibus',        25),
    ('B01', 'Guemes 23',                   5);

-- Operarios: id 1=101, 2=102, 3=103
INSERT INTO operario (legajo, nombre) VALUES
    (101, 'Marta Ruiz'),
    (102, 'Carlos Benítez'),
    (103, 'Lucía Fernández');

-- Usuarios: id 1=Ana, 2=Luis, 3=Juan, 4=Maria, 5=Sofia, 6=Diego
INSERT INTO usuario (dni, nombre) VALUES
    ('30111222', 'Ana Pérez'),
    ('35222333', 'Luis Gómez'),
    ('28444555', 'Juan Pérez'),
    ('40555666', 'María López'),
    ('33666777', 'Sofía Ramírez'),
    ('37777888', 'Diego Torres');

-- Tarjetas (numeros enmascarados)
INSERT INTO usuario_medio_pago (id_usuario, numero_tarjeta) VALUES
    (1, '4509-XXXX-XXXX-1234'),
    (1, '5413-XXXX-XXXX-5678'),
    (2, '4509-XXXX-XXXX-9012'),
    (3, '5031-XXXX-XXXX-3456'),
    (4, '4509-XXXX-XXXX-7788'),
    (5, '5413-XXXX-XXXX-2211'),
    (6, '4509-XXXX-XXXX-4455');

-- Bicicletas: id 1=B001 ... 8=B008
-- Cada bici queda en la estacion destino de su ultimo viaje
-- (B007 esta en uso y conserva la estacion de la que fue retirada)
INSERT INTO bicicleta (numero_serie, estado, id_estacion) VALUES
    ('B001', 'DISPONIBLE',       1),
    ('B002', 'DISPONIBLE',       3),
    ('B003', 'EN MANTENIMIENTO', 1),
    ('B004', 'DISPONIBLE',       2),
    ('B005', 'DISPONIBLE',       5),
    ('B006', 'DISPONIBLE',       4),
    ('B007', 'EN USO',           5),
    ('B008', 'DISPONIBLE',       3);

-- Viajes: (inicio, fin, id_usuario, id_bicicleta, id_origen, id_destino)
INSERT INTO viaje (fecha_inicio, fecha_fin, id_usuario, id_bicicleta,
                   id_estacion_origen, id_estacion_destino) VALUES
    ('2026-10-01 08:00:00', '2026-10-01 08:25:00', 1, 1, 1, 2),
    ('2026-10-02 18:10:00', '2026-10-02 18:40:00', 2, 1, 2, 1),
    ('2026-10-01 19:00:00', '2026-10-01 19:35:00', 1, 2, 1, 3),
    ('2026-10-03 09:00:00', '2026-10-03 09:20:00', 3, 4, 5, 2),
    ('2026-10-03 12:00:00', '2026-10-03 12:30:00', 4, 5, 3, 5),
    ('2026-10-04 08:15:00', '2026-10-04 08:50:00', 5, 8, 4, 3),
    ('2026-10-04 17:30:00', '2026-10-04 18:05:00', 6, 6, 1, 4);

-- Tareas: el numero_tarea arranca de nuevo en cada estacion
INSERT INTO tarea_mantenimiento (id_estacion, numero_tarea, fecha, descripcion, id_operario) VALUES
    (1, 1, '2026-09-15', 'Revisión de anclajes',             1),
    (1, 2, '2026-10-01', 'Cambio de cubiertas de la B003',   2),
    (2, 1, '2026-09-20', 'Limpieza de la estación',          1),
    (3, 1, '2026-09-25', 'Calibración de tótem de pago',     2),
    (4, 1, '2026-09-28', 'Instalación de anclajes nuevos',   1),
    (5, 1, '2026-10-02', 'Pintura de señalización',          3),
    (5, 2, '2026-10-04', 'Revisión del tótem de pago',       3),
    (6, 1, '2026-09-30', 'Revisión de la estación prestada', 3);

-- =============================================================================
-- 4. CONSULTAS DE VERIFICACION
-- =============================================================================

SELECT v.id AS id_viaje, u.nombre AS usuario, b.numero_serie AS bici,
       eo.direccion AS origen, ed.direccion AS destino,
       v.fecha_inicio, v.fecha_fin
FROM viaje v
JOIN usuario   u  ON u.id  = v.id_usuario
JOIN bicicleta b  ON b.id  = v.id_bicicleta
JOIN estacion  eo ON eo.id = v.id_estacion_origen
JOIN estacion  ed ON ed.id = v.id_estacion_destino
ORDER BY v.id;

SELECT e.codigo_estacion, t.numero_tarea, t.fecha, t.descripcion,
       o.nombre AS operario
FROM tarea_mantenimiento t
JOIN estacion e ON e.id = t.id_estacion
JOIN operario o ON o.id = t.id_operario
ORDER BY e.codigo_estacion, t.numero_tarea;

-- =============================================================================
-- 5. PRACTICA DE CLASE 8 (correr de a una)
-- =============================================================================

-- SELECT * FROM usuario WHERE id = 1;
-- SELECT * FROM usuario WHERE nombre LIKE '%Pérez%';
-- SELECT * FROM estacion WHERE codigo_estacion LIKE 'E%';
-- SELECT * FROM estacion WHERE codigo_estacion IN ('E01', 'E02');
-- SELECT * FROM estacion WHERE capacidad_max >= 20;
-- SELECT * FROM estacion WHERE capacidad_max BETWEEN 9 AND 16;
-- SELECT * FROM estacion ORDER BY capacidad_max DESC;
-- UPDATE estacion SET direccion = 'Av. 9 de Julio 1300' WHERE id = 1;

-- =============================================================================
-- 6. PRUEBAS DE INTEGRIDAD (comentadas; probar de a una)
-- Despues de probar una que borre datos, correr el script entero otra vez.
-- =============================================================================

-- a) falla (1451): Ana tiene viajes y la FK es RESTRICT
-- DELETE FROM usuario WHERE id = 1;

-- b) falla por el CHECK: "ROTA" no es un estado valido
-- INSERT INTO bicicleta (numero_serie, estado, id_estacion) VALUES ('B999', 'ROTA', 1);

-- c) falla (1452): la estacion 99 no existe
-- INSERT INTO bicicleta (numero_serie, estado, id_estacion) VALUES ('B998', 'DISPONIBLE', 99);

-- d) falla (1451): la estacion 1 tiene bicis y viajes
-- DELETE FROM estacion WHERE id = 1;

-- e) falla por el CHECK: fin antes que inicio
-- INSERT INTO viaje (fecha_inicio, fecha_fin, id_usuario, id_bicicleta,
--                    id_estacion_origen, id_estacion_destino)
-- VALUES ('2026-10-01 10:00:00', '2026-10-01 09:00:00', 2, 1, 1, 2);

-- f) falla (1062): la estacion 1 ya tiene la tarea numero 1
-- INSERT INTO tarea_mantenimiento (id_estacion, numero_tarea, fecha, descripcion, id_operario)
-- VALUES (1, 1, '2026-10-05', 'Tarea repetida', 1);

-- g) falla (1062): codigo de estacion repetido
-- INSERT INTO estacion (codigo_estacion, direccion, capacidad_max) VALUES ('E01', 'Otra direccion', 10);

-- h) esta borra de verdad (CASCADE): la estacion 6 no tiene bicis ni viajes
-- DELETE FROM estacion WHERE id = 6;
-- SELECT * FROM tarea_mantenimiento WHERE id_estacion = 6;   -- 0 filas
