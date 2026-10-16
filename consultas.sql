-- =============================================================================
-- Informatica II (UNNE) - Sistema de Alquiler de Bicicletas
-- Alumno: Nicolas Maure
-- Tarea "MER MR": 5 consultas de busqueda
--   Clase 14: SELECT con WHERE, LIKE, IN, BETWEEN, IS NULL, ORDER BY y JOIN
--   Clase 15: funciones de agregado (COUNT, SUM, AVG, MIN, MAX),
--             GROUP BY, HAVING y TIMESTAMPDIFF
-- Base: bicicletas_compartidas (12 viajes, 1 en curso)
-- =============================================================================

USE bicicletas_compartidas;

-- -----------------------------------------------------------------------------
-- Consulta 1: estaciones oficiales (codigo que empieza con "E") con
-- capacidad entre 10 y 25, de mayor a menor capacidad.
-- Conceptos: WHERE, LIKE, BETWEEN, AND, ORDER BY
-- Resultado esperado: E05 (25), E03 (20), E01 (15), E02 (10)
-- -----------------------------------------------------------------------------
SELECT codigo_estacion, direccion, capacidad_max
FROM estacion
WHERE codigo_estacion LIKE 'E%'
  AND capacidad_max BETWEEN 10 AND 25
ORDER BY capacidad_max DESC;

-- -----------------------------------------------------------------------------
-- Consulta 2: viajes en curso (todavia sin fecha de fin), con quien lleva
-- la bici y desde que estacion salio.
-- Conceptos: IS NULL, JOIN entre 4 tablas, alias
-- Resultado esperado: 1 fila -> Sofia Ramirez, B007, E05
-- -----------------------------------------------------------------------------
SELECT v.id AS id_viaje, u.nombre AS usuario, b.numero_serie AS bici,
       e.codigo_estacion AS origen, v.fecha_inicio
FROM viaje v
JOIN usuario   u ON u.id = v.id_usuario
JOIN bicicleta b ON b.id = v.id_bicicleta
JOIN estacion  e ON e.id = v.id_estacion_origen
WHERE v.fecha_fin IS NULL;

-- -----------------------------------------------------------------------------
-- Consulta 3: recorrido completo de los viajes hechos con B001, B002 o B004,
-- con estacion de origen y de destino (estacion se une dos veces).
-- Conceptos: IN, JOIN de la misma tabla con dos roles, LEFT JOIN, ORDER BY
-- Resultado esperado: 7 filas (viajes 1, 2, 3, 4, 8, 9 y 10)
-- -----------------------------------------------------------------------------
SELECT v.id AS id_viaje, b.numero_serie AS bici, u.nombre AS usuario,
       eo.codigo_estacion AS origen, ed.codigo_estacion AS destino,
       v.fecha_inicio, v.fecha_fin
FROM viaje v
JOIN bicicleta b      ON b.id  = v.id_bicicleta
JOIN usuario   u      ON u.id  = v.id_usuario
JOIN estacion  eo     ON eo.id = v.id_estacion_origen
LEFT JOIN estacion ed ON ed.id = v.id_estacion_destino
WHERE b.numero_serie IN ('B001', 'B002', 'B004')
ORDER BY b.numero_serie, v.fecha_inicio;

-- -----------------------------------------------------------------------------
-- Consulta 4: usuarios frecuentes (2 viajes o mas), con su primer y su
-- ultimo viaje.
-- Conceptos: COUNT, MIN, MAX, GROUP BY, HAVING, JOIN, ORDER BY
-- Resultado esperado: Ana Perez (3), Juan Perez (2), Luis Gomez (2),
--                     Maria Lopez (2), Sofia Ramirez (2)
-- -----------------------------------------------------------------------------
SELECT u.nombre AS usuario,
       COUNT(*)            AS cantidad_viajes,
       MIN(v.fecha_inicio) AS primer_viaje,
       MAX(v.fecha_inicio) AS ultimo_viaje
FROM viaje v
JOIN usuario u ON u.id = v.id_usuario
GROUP BY u.id, u.nombre
HAVING COUNT(*) >= 2
ORDER BY cantidad_viajes DESC, usuario;

-- -----------------------------------------------------------------------------
-- Consulta 5: duracion de los viajes terminados por estacion de origen
-- (cantidad, total y promedio en minutos), solo estaciones con 2 viajes o mas.
-- El viaje en curso queda afuera con IS NOT NULL.
-- Conceptos: TIMESTAMPDIFF, SUM, AVG, ROUND, GROUP BY, HAVING, IS NOT NULL
-- Resultado esperado:
--   E03: 3 viajes, 115 min, promedio 38.3
--   E01: 4 viajes, 120 min, promedio 30.0
--   E02: 2 viajes,  50 min, promedio 25.0
-- -----------------------------------------------------------------------------
SELECT e.codigo_estacion AS origen,
       COUNT(*) AS viajes_terminados,
       SUM(TIMESTAMPDIFF(MINUTE, v.fecha_inicio, v.fecha_fin))           AS minutos_totales,
       ROUND(AVG(TIMESTAMPDIFF(MINUTE, v.fecha_inicio, v.fecha_fin)), 1) AS promedio_min
FROM viaje v
JOIN estacion e ON e.id = v.id_estacion_origen
WHERE v.fecha_fin IS NOT NULL
GROUP BY e.id, e.codigo_estacion
HAVING COUNT(*) >= 2
ORDER BY promedio_min DESC;
