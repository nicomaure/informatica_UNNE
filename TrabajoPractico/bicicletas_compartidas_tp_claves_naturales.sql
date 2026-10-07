-- Informatica II (UNNE) - TP Alquiler de Bicicletas
-- Nicolas Maure

-- dropeo la base para poder correr el script de nuevo sin que tire error
DROP DATABASE IF EXISTS bicicletas_compartidas;
CREATE DATABASE bicicletas_compartidas
    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE bicicletas_compartidas;

-- primero las tablas que no dependen de ninguna otra
CREATE TABLE estacion (
    codigo_estacion VARCHAR(10)  PRIMARY KEY,
    direccion       VARCHAR(150) NOT NULL,
    capacidad_max   INT          NOT NULL CHECK (capacidad_max > 0)
);

CREATE TABLE operario (
    legajo INT          PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE usuario (
    dni    VARCHAR(10)  PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- ahora las que tienen FK

-- relacion 1:N "ubica", la FK va del lado N (bicicleta)
-- NOT NULL porque toda bici tiene que estar en alguna estacion si o si
CREATE TABLE bicicleta (
    numero_serie    VARCHAR(20) PRIMARY KEY,
    estado          VARCHAR(20) NOT NULL DEFAULT 'DISPONIBLE',
    codigo_estacion VARCHAR(10) NOT NULL,
    CONSTRAINT chk_bici_estado
        CHECK (estado IN ('DISPONIBLE', 'EN USO', 'EN MANTENIMIENTO')),
    CONSTRAINT fk_bici_estacion FOREIGN KEY (codigo_estacion)
        REFERENCES estacion (codigo_estacion) ON DELETE RESTRICT
);

-- medio_pago es multivaluado asi que lo saco a una tabla aparte
-- PK compuesta (dni, numero_tarjeta). Puse CASCADE porque si se borra
-- el usuario no tiene sentido dejar la tarjeta huerfana
CREATE TABLE usuario_medio_pago (
    dni            VARCHAR(10),
    numero_tarjeta VARCHAR(20),
    PRIMARY KEY (dni, numero_tarjeta),
    CONSTRAINT fk_medio_usuario FOREIGN KEY (dni)
        REFERENCES usuario (dni) ON DELETE CASCADE
);

-- viaje tiene su propio id. Tiene dos FK a estacion (origen y destino),
-- por eso hay que ponerles nombres distintos al constraint
-- use RESTRICT en todas para no perder el historial de viajes
-- fecha_fin y destino NOT NULL porque el enunciado pide el viaje completo
CREATE TABLE viaje (
    id_viaje           INT PRIMARY KEY,
    fecha_inicio       DATETIME    NOT NULL,
    fecha_fin          DATETIME    NOT NULL,
    dni_usuario        VARCHAR(10) NOT NULL,
    numero_serie_bici  VARCHAR(20) NOT NULL,
    codigo_est_origen  VARCHAR(10) NOT NULL,
    codigo_est_destino VARCHAR(10) NOT NULL,
    CONSTRAINT chk_viaje_fechas
        CHECK (fecha_fin >= fecha_inicio),
    CONSTRAINT fk_viaje_usuario FOREIGN KEY (dni_usuario)
        REFERENCES usuario (dni) ON DELETE RESTRICT,
    CONSTRAINT fk_viaje_bici FOREIGN KEY (numero_serie_bici)
        REFERENCES bicicleta (numero_serie) ON DELETE RESTRICT,
    CONSTRAINT fk_viaje_origen FOREIGN KEY (codigo_est_origen)
        REFERENCES estacion (codigo_estacion) ON DELETE RESTRICT,
    CONSTRAINT fk_viaje_destino FOREIGN KEY (codigo_est_destino)
        REFERENCES estacion (codigo_estacion) ON DELETE RESTRICT
);

-- tarea_mantenimiento es entidad debil de estacion
-- la PK es la clave de estacion + numero_tarea (clave parcial)
-- CASCADE hacia estacion porque es debil, RESTRICT hacia operario
CREATE TABLE tarea_mantenimiento (
    codigo_estacion VARCHAR(10),
    numero_tarea    INT,
    fecha           DATE NOT NULL,
    descripcion     VARCHAR(200) NOT NULL,
    legajo_operario INT  NOT NULL,
    PRIMARY KEY (codigo_estacion, numero_tarea),
    CONSTRAINT fk_tarea_estacion FOREIGN KEY (codigo_estacion)
        REFERENCES estacion (codigo_estacion) ON DELETE CASCADE,
    CONSTRAINT fk_tarea_operario FOREIGN KEY (legajo_operario)
        REFERENCES operario (legajo) ON DELETE RESTRICT
);

-- datos de prueba
INSERT INTO estacion (codigo_estacion, direccion, capacidad_max) VALUES
    ('E01', 'Av. 9 de Julio 1200', 15),
    ('E02', 'Plaza 25 de Mayo s/n', 10),
    ('E03', 'Costanera y Av. 3 de Abril', 20),
    ('E04', 'Parque Mitre', 8);

INSERT INTO operario (legajo, nombre) VALUES
    (101, 'Marta Ruiz'),
    (102, 'Carlos Benítez');

INSERT INTO usuario (dni, nombre) VALUES
    ('30111222', 'Ana Pérez'),
    ('35222333', 'Luis Gómez');

INSERT INTO usuario_medio_pago (dni, numero_tarjeta) VALUES
    ('30111222', '4509-XXXX-XXXX-1234'),
    ('30111222', '5413-XXXX-XXXX-5678'),
    ('35222333', '4509-XXXX-XXXX-9012');

INSERT INTO bicicleta (numero_serie, estado, codigo_estacion) VALUES
    ('B001', 'DISPONIBLE',       'E01'),
    ('B002', 'DISPONIBLE',       'E03'),
    ('B003', 'EN MANTENIMIENTO', 'E01'),
    ('B004', 'DISPONIBLE',       'E02');

INSERT INTO viaje (id_viaje, fecha_inicio, fecha_fin, dni_usuario,
                   numero_serie_bici, codigo_est_origen, codigo_est_destino) VALUES
    (1, '2026-10-01 08:00:00', '2026-10-01 08:25:00', '30111222', 'B001', 'E01', 'E02'),
    (2, '2026-10-02 18:10:00', '2026-10-02 18:40:00', '35222333', 'B001', 'E02', 'E01'),
    (3, '2026-10-01 19:00:00', '2026-10-01 19:35:00', '30111222', 'B002', 'E01', 'E03');

-- el numero_tarea arranca de nuevo en cada estacion (es clave parcial)
INSERT INTO tarea_mantenimiento (codigo_estacion, numero_tarea, fecha,
                                 descripcion, legajo_operario) VALUES
    ('E01', 1, '2026-09-15', 'Revisión de anclajes',          101),
    ('E01', 2, '2026-10-01', 'Cambio de cubiertas de la B003', 102),
    ('E02', 1, '2026-09-20', 'Limpieza de la estación',        101),
    ('E03', 1, '2026-09-25', 'Calibración de tótem de pago',   102),
    ('E04', 1, '2026-09-28', 'Instalación de anclajes nuevos', 101);

-- consultas para verificar que esta todo bien cargado

-- viajes con usuario, bici y las dos estaciones (origen y destino)
SELECT v.id_viaje, u.nombre AS usuario, v.numero_serie_bici AS bici,
       eo.direccion AS origen, ed.direccion AS destino,
       v.fecha_inicio, v.fecha_fin
FROM viaje v
JOIN usuario  u  ON u.dni = v.dni_usuario
JOIN estacion eo ON eo.codigo_estacion = v.codigo_est_origen
JOIN estacion ed ON ed.codigo_estacion = v.codigo_est_destino
ORDER BY v.id_viaje;

-- tareas de mantenimiento agrupadas por estacion y con el nombre del operario
SELECT t.codigo_estacion, t.numero_tarea, t.fecha, t.descripcion,
       o.nombre AS operario
FROM tarea_mantenimiento t
JOIN operario o ON o.legajo = t.legajo_operario
ORDER BY t.codigo_estacion, t.numero_tarea;

-- pruebas de integridad, las dejo comentadas y las voy probando de a una
-- (los CHECK andan desde MariaDB 10.2.1, fijate con SELECT VERSION() si da error raro)

-- a) esto deberia fallar (1451) porque Ana tiene viajes
-- DELETE FROM usuario WHERE dni = '30111222';

-- b) esto tiene que fallar por el CHECK, "ROTA" no es un estado valido
-- INSERT INTO bicicleta VALUES ('B999', 'ROTA', 'E01');

-- c) esto falla porque E99 no existe (FK)
-- INSERT INTO bicicleta VALUES ('B998', 'DISPONIBLE', 'E99');

-- d) no deja borrar E01 porque tiene bicis y viajes asociados
-- DELETE FROM estacion WHERE codigo_estacion = 'E01';

-- e) el CHECK de fechas tiene que frenar esto (fin antes que inicio)
-- INSERT INTO viaje VALUES (9, '2026-10-01 10:00:00', '2026-10-01 09:00:00',
--                           '35222333', 'B001', 'E01', 'E02');

-- f) esta la dejo para el final porque borra E04 de verdad (CASCADE)
--    E04 no tiene bicis ni viajes, solo una tarea, asi que al borrarla
--    la tarea se va sola. si quiero repetir la prueba hay que correr
--    todo el script de nuevo
-- DELETE FROM estacion WHERE codigo_estacion = 'E04';
-- SELECT * FROM tarea_mantenimiento WHERE codigo_estacion = 'E04';  -- 0 filas
