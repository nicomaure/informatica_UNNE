-- MariaDB dump 10.19  Distrib 10.11.14-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: bicicletas_compartidas
-- ------------------------------------------------------
-- Server version	10.11.14-MariaDB-0ubuntu0.24.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `bicicleta`
--

DROP TABLE IF EXISTS `bicicleta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `bicicleta` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `numero_serie` varchar(20) NOT NULL,
  `estado` varchar(20) NOT NULL DEFAULT 'DISPONIBLE',
  `id_estacion` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `numero_serie` (`numero_serie`),
  KEY `fk_bici_estacion` (`id_estacion`),
  CONSTRAINT `fk_bici_estacion` FOREIGN KEY (`id_estacion`) REFERENCES `estacion` (`id`),
  CONSTRAINT `chk_bici_estado` CHECK (`estado` in ('DISPONIBLE','EN USO','EN MANTENIMIENTO'))
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bicicleta`
--

LOCK TABLES `bicicleta` WRITE;
/*!40000 ALTER TABLE `bicicleta` DISABLE KEYS */;
INSERT INTO `bicicleta` VALUES
(1,'B001','DISPONIBLE',3),
(2,'B002','DISPONIBLE',1),
(3,'B003','EN MANTENIMIENTO',1),
(4,'B004','DISPONIBLE',5),
(5,'B005','DISPONIBLE',5),
(6,'B006','DISPONIBLE',4),
(7,'B007','EN USO',5),
(8,'B008','DISPONIBLE',2);
/*!40000 ALTER TABLE `bicicleta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estacion`
--

DROP TABLE IF EXISTS `estacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `estacion` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `codigo_estacion` varchar(10) NOT NULL,
  `direccion` varchar(150) NOT NULL,
  `capacidad_max` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `codigo_estacion` (`codigo_estacion`),
  CONSTRAINT `chk_estacion_capacidad` CHECK (`capacidad_max` > 0)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estacion`
--

LOCK TABLES `estacion` WRITE;
/*!40000 ALTER TABLE `estacion` DISABLE KEYS */;
INSERT INTO `estacion` VALUES
(1,'E01','Av. 9 de Julio 1200',15),
(2,'E02','Plaza 25 de Mayo s/n',10),
(3,'E03','Costanera y Av. 3 de Abril',20),
(4,'E04','Parque Mitre',8),
(5,'E05','Terminal de Omnibus',25),
(6,'B01','Guemes 23',5);
/*!40000 ALTER TABLE `estacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `operario`
--

DROP TABLE IF EXISTS `operario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `operario` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `legajo` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `legajo` (`legajo`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `operario`
--

LOCK TABLES `operario` WRITE;
/*!40000 ALTER TABLE `operario` DISABLE KEYS */;
INSERT INTO `operario` VALUES
(1,101,'Marta Ruiz'),
(2,102,'Carlos Benítez'),
(3,103,'Lucía Fernández');
/*!40000 ALTER TABLE `operario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tarea_mantenimiento`
--

DROP TABLE IF EXISTS `tarea_mantenimiento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tarea_mantenimiento` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_estacion` int(11) NOT NULL,
  `numero_tarea` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `descripcion` varchar(200) NOT NULL,
  `id_operario` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_tarea_estacion_numero` (`id_estacion`,`numero_tarea`),
  KEY `fk_tarea_operario` (`id_operario`),
  CONSTRAINT `fk_tarea_estacion` FOREIGN KEY (`id_estacion`) REFERENCES `estacion` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_tarea_operario` FOREIGN KEY (`id_operario`) REFERENCES `operario` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tarea_mantenimiento`
--

LOCK TABLES `tarea_mantenimiento` WRITE;
/*!40000 ALTER TABLE `tarea_mantenimiento` DISABLE KEYS */;
INSERT INTO `tarea_mantenimiento` VALUES
(1,1,1,'2026-09-15','Revisión de anclajes',1),
(2,1,2,'2026-10-01','Cambio de cubiertas de la B003',2),
(3,2,1,'2026-09-20','Limpieza de la estación',1),
(4,3,1,'2026-09-25','Calibración de tótem de pago',2),
(5,4,1,'2026-09-28','Instalación de anclajes nuevos',1),
(6,5,1,'2026-10-02','Pintura de señalización',3),
(7,5,2,'2026-10-04','Revisión del tótem de pago',3),
(8,6,1,'2026-09-30','Revisión de la estación prestada',3);
/*!40000 ALTER TABLE `tarea_mantenimiento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuario`
--

DROP TABLE IF EXISTS `usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuario` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dni` varchar(10) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dni` (`dni`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario`
--

LOCK TABLES `usuario` WRITE;
/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
INSERT INTO `usuario` VALUES
(1,'30111222','Ana Pérez'),
(2,'35222333','Luis Gómez'),
(3,'28444555','Juan Pérez'),
(4,'40555666','María López'),
(5,'33666777','Sofía Ramírez'),
(6,'37777888','Diego Torres');
/*!40000 ALTER TABLE `usuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuario_medio_pago`
--

DROP TABLE IF EXISTS `usuario_medio_pago`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuario_medio_pago` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_usuario` int(11) NOT NULL,
  `numero_tarjeta` varchar(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_medio_usuario_tarjeta` (`id_usuario`,`numero_tarjeta`),
  CONSTRAINT `fk_medio_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario_medio_pago`
--

LOCK TABLES `usuario_medio_pago` WRITE;
/*!40000 ALTER TABLE `usuario_medio_pago` DISABLE KEYS */;
INSERT INTO `usuario_medio_pago` VALUES
(1,1,'4509-XXXX-XXXX-1234'),
(2,1,'5413-XXXX-XXXX-5678'),
(3,2,'4509-XXXX-XXXX-9012'),
(4,3,'5031-XXXX-XXXX-3456'),
(5,4,'4509-XXXX-XXXX-7788'),
(6,5,'5413-XXXX-XXXX-2211'),
(7,6,'4509-XXXX-XXXX-4455');
/*!40000 ALTER TABLE `usuario_medio_pago` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `viaje`
--

DROP TABLE IF EXISTS `viaje`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `viaje` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fecha_inicio` datetime NOT NULL,
  `fecha_fin` datetime DEFAULT NULL,
  `id_usuario` int(11) NOT NULL,
  `id_bicicleta` int(11) NOT NULL,
  `id_estacion_origen` int(11) NOT NULL,
  `id_estacion_destino` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_viaje_usuario` (`id_usuario`),
  KEY `fk_viaje_bici` (`id_bicicleta`),
  KEY `fk_viaje_origen` (`id_estacion_origen`),
  KEY `fk_viaje_destino` (`id_estacion_destino`),
  CONSTRAINT `fk_viaje_bici` FOREIGN KEY (`id_bicicleta`) REFERENCES `bicicleta` (`id`),
  CONSTRAINT `fk_viaje_destino` FOREIGN KEY (`id_estacion_destino`) REFERENCES `estacion` (`id`),
  CONSTRAINT `fk_viaje_origen` FOREIGN KEY (`id_estacion_origen`) REFERENCES `estacion` (`id`),
  CONSTRAINT `fk_viaje_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id`),
  CONSTRAINT `chk_viaje_fechas` CHECK (`fecha_fin` is null or `fecha_fin` >= `fecha_inicio`),
  CONSTRAINT `chk_viaje_en_curso` CHECK (`fecha_fin` is null = (`id_estacion_destino` is null))
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `viaje`
--

LOCK TABLES `viaje` WRITE;
/*!40000 ALTER TABLE `viaje` DISABLE KEYS */;
INSERT INTO `viaje` VALUES
(1,'2026-10-01 08:00:00','2026-10-01 08:25:00',1,1,1,2),
(2,'2026-10-02 18:10:00','2026-10-02 18:40:00',2,1,2,1),
(3,'2026-10-01 19:00:00','2026-10-01 19:35:00',1,2,1,3),
(4,'2026-10-03 09:00:00','2026-10-03 09:20:00',3,4,5,2),
(5,'2026-10-03 12:00:00','2026-10-03 12:30:00',4,5,3,5),
(6,'2026-10-04 08:15:00','2026-10-04 08:50:00',5,8,4,3),
(7,'2026-10-04 17:30:00','2026-10-04 18:05:00',6,6,1,4),
(8,'2026-10-05 07:45:00','2026-10-05 08:10:00',2,1,1,3),
(9,'2026-10-06 13:00:00','2026-10-06 13:45:00',3,2,3,1),
(10,'2026-10-07 09:30:00','2026-10-07 09:50:00',1,4,2,5),
(11,'2026-10-08 18:00:00','2026-10-08 18:40:00',4,8,3,2),
(12,'2026-10-10 10:00:00',NULL,5,7,5,NULL);
/*!40000 ALTER TABLE `viaje` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-16 20:16:13
