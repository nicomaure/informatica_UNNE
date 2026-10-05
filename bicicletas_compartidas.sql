-- phpMyAdmin SQL Dump
-- version 5.2.1deb3
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost:3306
-- Tiempo de generación: 05-10-2026 a las 22:23:14
-- Versión del servidor: 10.11.14-MariaDB-0ubuntu0.24.04.1
-- Versión de PHP: 8.3.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `bicicletas_compartidas`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `bicicleta`
--

CREATE TABLE `bicicleta` (
  `numero_serie` varchar(20) NOT NULL,
  `estado` varchar(20) NOT NULL DEFAULT 'DISPONIBLE',
  `codigo_estacion` varchar(10) NOT NULL
) ;

--
-- Volcado de datos para la tabla `bicicleta`
--

INSERT INTO `bicicleta` (`numero_serie`, `estado`, `codigo_estacion`) VALUES
('B001', 'DISPONIBLE', 'E01'),
('B002', 'DISPONIBLE', 'E03'),
('B003', 'EN MANTENIMIENTO', 'E01'),
('B004', 'DISPONIBLE', 'E02');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estacion`
--

CREATE TABLE `estacion` (
  `codigo_estacion` varchar(10) NOT NULL,
  `direccion` varchar(150) NOT NULL,
  `capacidad_max` int(11) NOT NULL CHECK (`capacidad_max` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `estacion`
--

INSERT INTO `estacion` (`codigo_estacion`, `direccion`, `capacidad_max`) VALUES
('E01', 'Av. 9 de Julio 1200', 15),
('E02', 'Plaza 25 de Mayo s/n', 10),
('E03', 'Costanera y Av. 3 de Abril', 20),
('E04', 'Parque Mitre', 8);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `operario`
--

CREATE TABLE `operario` (
  `legajo` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `operario`
--

INSERT INTO `operario` (`legajo`, `nombre`) VALUES
(101, 'Marta Ruiz'),
(102, 'Carlos Benítez');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tarea_mantenimiento`
--

CREATE TABLE `tarea_mantenimiento` (
  `codigo_estacion` varchar(10) NOT NULL,
  `numero_tarea` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `descripcion` varchar(200) NOT NULL,
  `legajo_operario` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `tarea_mantenimiento`
--

INSERT INTO `tarea_mantenimiento` (`codigo_estacion`, `numero_tarea`, `fecha`, `descripcion`, `legajo_operario`) VALUES
('E01', 1, '2026-09-15', 'Revisión de anclajes', 101),
('E01', 2, '2026-10-01', 'Cambio de cubiertas de la B003', 102),
('E02', 1, '2026-09-20', 'Limpieza de la estación', 101),
('E03', 1, '2026-09-25', 'Calibración de tótem de pago', 102),
('E04', 1, '2026-09-28', 'Instalación de anclajes nuevos', 101);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `dni` varchar(10) NOT NULL,
  `nombre` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`dni`, `nombre`) VALUES
('30111222', 'Ana Pérez'),
('35222333', 'Luis Gómez');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario_medio_pago`
--

CREATE TABLE `usuario_medio_pago` (
  `dni` varchar(10) NOT NULL,
  `numero_tarjeta` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `usuario_medio_pago`
--

INSERT INTO `usuario_medio_pago` (`dni`, `numero_tarjeta`) VALUES
('30111222', '4509-XXXX-XXXX-1234'),
('30111222', '5413-XXXX-XXXX-5678'),
('35222333', '4509-XXXX-XXXX-9012');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `viaje`
--

CREATE TABLE `viaje` (
  `id_viaje` int(11) NOT NULL,
  `fecha_inicio` datetime NOT NULL,
  `fecha_fin` datetime NOT NULL,
  `dni_usuario` varchar(10) NOT NULL,
  `numero_serie_bici` varchar(20) NOT NULL,
  `codigo_est_origen` varchar(10) NOT NULL,
  `codigo_est_destino` varchar(10) NOT NULL
) ;

--
-- Volcado de datos para la tabla `viaje`
--

INSERT INTO `viaje` (`id_viaje`, `fecha_inicio`, `fecha_fin`, `dni_usuario`, `numero_serie_bici`, `codigo_est_origen`, `codigo_est_destino`) VALUES
(1, '2026-10-01 08:00:00', '2026-10-01 08:25:00', '30111222', 'B001', 'E01', 'E02'),
(2, '2026-10-02 18:10:00', '2026-10-02 18:40:00', '35222333', 'B001', 'E02', 'E01'),
(3, '2026-10-01 19:00:00', '2026-10-01 19:35:00', '30111222', 'B002', 'E01', 'E03');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `bicicleta`
--
ALTER TABLE `bicicleta`
  ADD PRIMARY KEY (`numero_serie`),
  ADD KEY `fk_bici_estacion` (`codigo_estacion`);

--
-- Indices de la tabla `estacion`
--
ALTER TABLE `estacion`
  ADD PRIMARY KEY (`codigo_estacion`);

--
-- Indices de la tabla `operario`
--
ALTER TABLE `operario`
  ADD PRIMARY KEY (`legajo`);

--
-- Indices de la tabla `tarea_mantenimiento`
--
ALTER TABLE `tarea_mantenimiento`
  ADD PRIMARY KEY (`codigo_estacion`,`numero_tarea`),
  ADD KEY `fk_tarea_operario` (`legajo_operario`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`dni`);

--
-- Indices de la tabla `usuario_medio_pago`
--
ALTER TABLE `usuario_medio_pago`
  ADD PRIMARY KEY (`dni`,`numero_tarjeta`);

--
-- Indices de la tabla `viaje`
--
ALTER TABLE `viaje`
  ADD PRIMARY KEY (`id_viaje`),
  ADD KEY `fk_viaje_usuario` (`dni_usuario`),
  ADD KEY `fk_viaje_bici` (`numero_serie_bici`),
  ADD KEY `fk_viaje_origen` (`codigo_est_origen`),
  ADD KEY `fk_viaje_destino` (`codigo_est_destino`);

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `bicicleta`
--
ALTER TABLE `bicicleta`
  ADD CONSTRAINT `fk_bici_estacion` FOREIGN KEY (`codigo_estacion`) REFERENCES `estacion` (`codigo_estacion`);

--
-- Filtros para la tabla `tarea_mantenimiento`
--
ALTER TABLE `tarea_mantenimiento`
  ADD CONSTRAINT `fk_tarea_estacion` FOREIGN KEY (`codigo_estacion`) REFERENCES `estacion` (`codigo_estacion`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_tarea_operario` FOREIGN KEY (`legajo_operario`) REFERENCES `operario` (`legajo`);

--
-- Filtros para la tabla `usuario_medio_pago`
--
ALTER TABLE `usuario_medio_pago`
  ADD CONSTRAINT `fk_medio_usuario` FOREIGN KEY (`dni`) REFERENCES `usuario` (`dni`) ON DELETE CASCADE;

--
-- Filtros para la tabla `viaje`
--
ALTER TABLE `viaje`
  ADD CONSTRAINT `fk_viaje_bici` FOREIGN KEY (`numero_serie_bici`) REFERENCES `bicicleta` (`numero_serie`),
  ADD CONSTRAINT `fk_viaje_destino` FOREIGN KEY (`codigo_est_destino`) REFERENCES `estacion` (`codigo_estacion`),
  ADD CONSTRAINT `fk_viaje_origen` FOREIGN KEY (`codigo_est_origen`) REFERENCES `estacion` (`codigo_estacion`),
  ADD CONSTRAINT `fk_viaje_usuario` FOREIGN KEY (`dni_usuario`) REFERENCES `usuario` (`dni`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
