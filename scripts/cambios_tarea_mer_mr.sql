-- =============================================================================
-- Informatica II (UNNE) - Sistema de Alquiler de Bicicletas
-- Alumno: Nicolas Maure
-- Cambios para la tarea "MER MR" (octubre 2026)
--
-- Se ejecuta UNA sola vez sobre la base bicicletas_compartidas ya cargada
-- (la de la exportacion del 06/10). Despues se vuelve a exportar desde
-- phpMyAdmin y se reemplaza bicicletas_compartidas.sql en la raiz del repo.
--
-- Que cambia:
--   1. viaje.fecha_fin y viaje.id_estacion_destino pasan a admitir NULL,
--      para poder registrar un viaje EN CURSO (todavia no se devolvio la bici).
--   2. Se rehace el CHECK de fechas y se agrega un CHECK de coherencia:
--      fin y destino se cargan juntos (los dos NULL o los dos con valor).
--   3. Se agregan 5 viajes (4 terminados y 1 en curso): quedan 12 en total,
--      por encima del minimo de 10 que pide la clase 14.
--   4. UPDATE de la estacion actual de las bicis que hicieron viajes nuevos.
-- =============================================================================

USE bicicletas_compartidas;

-- -----------------------------------------------------------------------------
-- 1. ESTRUCTURA (DDL)
-- -----------------------------------------------------------------------------

-- Primero se borra el CHECK viejo (fecha_fin >= fecha_inicio)
ALTER TABLE viaje DROP CHECK chk_viaje_fechas;

-- Fin y destino opcionales mientras el viaje esta en curso.
-- id_estacion_destino es FK: se desactiva el control de FK solo durante
-- este cambio para que MySQL permita modificar la columna.
SET FOREIGN_KEY_CHECKS = 0;
ALTER TABLE viaje
    MODIFY fecha_fin           DATETIME NULL DEFAULT NULL,
    MODIFY id_estacion_destino INT      NULL DEFAULT NULL;
SET FOREIGN_KEY_CHECKS = 1;

-- CHECK nuevos
ALTER TABLE viaje
    ADD CONSTRAINT chk_viaje_fechas
        CHECK (fecha_fin IS NULL OR fecha_fin >= fecha_inicio),
    ADD CONSTRAINT chk_viaje_en_curso
        CHECK ((fecha_fin IS NULL) = (id_estacion_destino IS NULL));

-- -----------------------------------------------------------------------------
-- 2. DATOS NUEVOS (DML)
-- Ids actuales: usuarios 1..6, bicis 1..8, estaciones 1..6.
-- B003 (id 3) esta EN MANTENIMIENTO: no se usa.
-- B007 (id 7) ya figuraba EN USO en la estacion 5: es el viaje en curso.
-- -----------------------------------------------------------------------------

INSERT INTO viaje (fecha_inicio, fecha_fin, id_usuario, id_bicicleta,
                   id_estacion_origen, id_estacion_destino) VALUES
    ('2026-10-05 07:45:00', '2026-10-05 08:10:00', 2, 1, 1, 3),   -- B001 E01 -> E03
    ('2026-10-06 13:00:00', '2026-10-06 13:45:00', 3, 2, 3, 1),   -- B002 E03 -> E01
    ('2026-10-07 09:30:00', '2026-10-07 09:50:00', 1, 4, 2, 5),   -- B004 E02 -> E05
    ('2026-10-08 18:00:00', '2026-10-08 18:40:00', 4, 8, 3, 2),   -- B008 E03 -> E02
    ('2026-10-10 10:00:00', NULL,                  5, 7, 5, NULL); -- B007 en curso

-- Cada bici queda en la estacion destino de su ultimo viaje
UPDATE bicicleta SET id_estacion = 3 WHERE id = 1;  -- B001 -> E03
UPDATE bicicleta SET id_estacion = 1 WHERE id = 2;  -- B002 -> E01
UPDATE bicicleta SET id_estacion = 5 WHERE id = 4;  -- B004 -> E05
UPDATE bicicleta SET id_estacion = 2 WHERE id = 8;  -- B008 -> E02

-- -----------------------------------------------------------------------------
-- 3. VERIFICACION (correr de a una en phpMyAdmin)
-- -----------------------------------------------------------------------------

-- Debe dar 12
-- SELECT COUNT(*) AS total_viajes FROM viaje;

-- Debe dar 1 fila: el viaje 12, B007, sin fin ni destino
-- SELECT * FROM viaje WHERE fecha_fin IS NULL;

-- Deben aparecer los 4 CHECK: chk_bici_estado, chk_estacion_capacidad,
-- chk_viaje_en_curso y chk_viaje_fechas
-- SELECT CONSTRAINT_NAME, CHECK_CLAUSE
-- FROM information_schema.CHECK_CONSTRAINTS
-- WHERE CONSTRAINT_SCHEMA = 'bicicletas_compartidas';

-- Prueba: debe FALLAR por chk_viaje_en_curso (tiene fin pero no destino)
-- INSERT INTO viaje (fecha_inicio, fecha_fin, id_usuario, id_bicicleta,
--                    id_estacion_origen, id_estacion_destino)
-- VALUES ('2026-10-11 10:00:00', '2026-10-11 10:30:00', 1, 5, 5, NULL);
