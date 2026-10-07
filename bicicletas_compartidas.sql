-- phpMyAdmin SQL Dump
-- version 5.2.1deb3
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost:3306
-- Tiempo de generación: 07-10-2026 a las 01:28:36
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
  `id` int(11) NOT NULL,
  `numero_serie` varchar(20) NOT NULL,
  `estado` varchar(20) NOT NULL DEFAULT 'DISPONIBLE',
  `id_estacion` int(11) NOT NULL
) ;

--
-- Volcado de datos para la tabla `bicicleta`
--

INSERT INTO `bicicleta` (`id`, `numero_serie`, `estado`, `id_estacion`) VALUES
(1, 'B001', 'DISPONIBLE', 1),
(2, 'B002', 'DISPONIBLE', 3),
(3, 'B003', 'EN MANTENIMIENTO', 1),
(4, 'B004', 'DISPONIBLE', 2),
(5, 'B005', 'DISPONIBLE', 5),
(6, 'B006', 'DISPONIBLE', 4),
(7, 'B007', 'EN USO', 5),
(8, 'B008', 'DISPONIBLE', 3);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estacion`
--

CREATE TABLE `estacion` (
  `id` int(11) NOT NULL,
  `codigo_estacion` varchar(10) NOT NULL,
  `direccion` varchar(150) NOT NULL,
  `capacidad_max` int(11) NOT NULL
) ;

--
-- Volcado de datos para la tabla `estacion`
--

INSERT INTO `estacion` (`id`, `codigo_estacion`, `direccion`, `capacidad_max`) VALUES
(1, 'E01', 'Av. 9 de Julio 1200', 15),
(2, 'E02', 'Plaza 25 de Mayo s/n', 10),
(3, 'E03', 'Costanera y Av. 3 de Abril', 20),
(4, 'E04', 'Parque Mitre', 8),
(5, 'E05', 'Terminal de Omnibus', 25),
(6, 'B01', 'Guemes 23', 5);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `operario`
--

CREATE TABLE `operario` (
  `id` int(11) NOT NULL,
  `legajo` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `operario`
--

INSERT INTO `operario` (`id`, `legajo`, `nombre`) VALUES
(1, 101, 'Marta Ruiz'),
(2, 102, 'Carlos Benítez'),
(3, 103, 'Lucía Fernández');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tarea_mantenimiento`
--

CREATE TABLE `tarea_mantenimiento` (
  `id` int(11) NOT NULL,
  `id_estacion` int(11) NOT NULL,
  `numero_tarea` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `descripcion` varchar(200) NOT NULL,
  `id_operario` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `tarea_mantenimiento`
--

INSERT INTO `tarea_mantenimiento` (`id`, `id_estacion`, `numero_tarea`, `fecha`, `descripcion`, `id_operario`) VALUES
(1, 1, 1, '2026-09-15', 'Revisión de anclajes', 1),
(2, 1, 2, '2026-10-01', 'Cambio de cubiertas de la B003', 2),
(3, 2, 1, '2026-09-20', 'Limpieza de la estación', 1),
(4, 3, 1, '2026-09-25', 'Calibración de tótem de pago', 2),
(5, 4, 1, '2026-09-28', 'Instalación de anclajes nuevos', 1),
(6, 5, 1, '2026-10-02', 'Pintura de señalización', 3),
(7, 5, 2, '2026-10-04', 'Revisión del tótem de pago', 3),
(8, 6, 1, '2026-09-30', 'Revisión de la estación prestada', 3);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `id` int(11) NOT NULL,
  `dni` varchar(10) NOT NULL,
  `nombre` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`id`, `dni`, `nombre`) VALUES
(1, '30111222', 'Ana Pérez'),
(2, '35222333', 'Luis Gómez'),
(3, '28444555', 'Juan Pérez'),
(4, '40555666', 'María López'),
(5, '33666777', 'Sofía Ramírez'),
(6, '37777888', 'Diego Torres');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario_medio_pago`
--

CREATE TABLE `usuario_medio_pago` (
  `id` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `numero_tarjeta` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `usuario_medio_pago`
--

INSERT INTO `usuario_medio_pago` (`id`, `id_usuario`, `numero_tarjeta`) VALUES
(1, 1, '4509-XXXX-XXXX-1234'),
(2, 1, '5413-XXXX-XXXX-5678'),
(3, 2, '4509-XXXX-XXXX-9012'),
(4, 3, '5031-XXXX-XXXX-3456'),
(5, 4, '4509-XXXX-XXXX-7788'),
(6, 5, '5413-XXXX-XXXX-2211'),
(7, 6, '4509-XXXX-XXXX-4455');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `viaje`
--

CREATE TABLE `viaje` (
  `id` int(11) NOT NULL,
  `fecha_inicio` datetime NOT NULL,
  `fecha_fin` datetime NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `id_bicicleta` int(11) NOT NULL,
  `id_estacion_origen` int(11) NOT NULL,
  `id_estacion_destino` int(11) NOT NULL
) ;

--
-- Volcado de datos para la tabla `viaje`
--

INSERT INTO `viaje` (`id`, `fecha_inicio`, `fecha_fin`, `id_usuario`, `id_bicicleta`, `id_estacion_origen`, `id_estacion_destino`) VALUES
(1, '2026-10-01 08:00:00', '2026-10-01 08:25:00', 1, 1, 1, 2),
(2, '2026-10-02 18:10:00', '2026-10-02 18:40:00', 2, 1, 2, 1),
(3, '2026-10-01 19:00:00', '2026-10-01 19:35:00', 1, 2, 1, 3),
(4, '2026-10-03 09:00:00', '2026-10-03 09:20:00', 3, 4, 5, 2),
(5, '2026-10-03 12:00:00', '2026-10-03 12:30:00', 4, 5, 3, 5),
(6, '2026-10-04 08:15:00', '2026-10-04 08:50:00', 5, 8, 4, 3),
(7, '2026-10-04 17:30:00', '2026-10-04 18:05:00', 6, 6, 1, 4);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `bicicleta`
--
ALTER TABLE `bicicleta`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `numero_serie` (`numero_serie`),
  ADD KEY `fk_bici_estacion` (`id_estacion`);

--
-- Indices de la tabla `estacion`
--
ALTER TABLE `estacion`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `codigo_estacion` (`codigo_estacion`);

--
-- Indices de la tabla `operario`
--
ALTER TABLE `operario`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `legajo` (`legajo`);

--
-- Indices de la tabla `tarea_mantenimiento`
--
ALTER TABLE `tarea_mantenimiento`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_tarea_estacion_numero` (`id_estacion`,`numero_tarea`),
  ADD KEY `fk_tarea_operario` (`id_operario`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `dni` (`dni`);

--
-- Indices de la tabla `usuario_medio_pago`
--
ALTER TABLE `usuario_medio_pago`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_medio_usuario_tarjeta` (`id_usuario`,`numero_tarjeta`);

--
-- Indices de la tabla `viaje`
--
ALTER TABLE `viaje`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_viaje_usuario` (`id_usuario`),
  ADD KEY `fk_viaje_bici` (`id_bicicleta`),
  ADD KEY `fk_viaje_origen` (`id_estacion_origen`),
  ADD KEY `fk_viaje_destino` (`id_estacion_destino`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `bicicleta`
--
ALTER TABLE `bicicleta`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `estacion`
--
ALTER TABLE `estacion`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `operario`
--
ALTER TABLE `operario`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `tarea_mantenimiento`
--
ALTER TABLE `tarea_mantenimiento`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `usuario`
--
ALTER TABLE `usuario`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `usuario_medio_pago`
--
ALTER TABLE `usuario_medio_pago`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `viaje`
--
ALTER TABLE `viaje`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `bicicleta`
--
ALTER TABLE `bicicleta`
  ADD CONSTRAINT `fk_bici_estacion` FOREIGN KEY (`id_estacion`) REFERENCES `estacion` (`id`);

--
-- Filtros para la tabla `tarea_mantenimiento`
--
ALTER TABLE `tarea_mantenimiento`
  ADD CONSTRAINT `fk_tarea_estacion` FOREIGN KEY (`id_estacion`) REFERENCES `estacion` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_tarea_operario` FOREIGN KEY (`id_operario`) REFERENCES `operario` (`id`);

--
-- Filtros para la tabla `usuario_medio_pago`
--
ALTER TABLE `usuario_medio_pago`
  ADD CONSTRAINT `fk_medio_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `viaje`
--
ALTER TABLE `viaje`
  ADD CONSTRAINT `fk_viaje_bici` FOREIGN KEY (`id_bicicleta`) REFERENCES `bicicleta` (`id`),
  ADD CONSTRAINT `fk_viaje_destino` FOREIGN KEY (`id_estacion_destino`) REFERENCES `estacion` (`id`),
  ADD CONSTRAINT `fk_viaje_origen` FOREIGN KEY (`id_estacion_origen`) REFERENCES `estacion` (`id`),
  ADD CONSTRAINT `fk_viaje_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
