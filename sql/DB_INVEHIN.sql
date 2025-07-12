-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Versión del servidor:         8.0.41 - MySQL Community Server - GPL
-- SO del servidor:              Win64
-- HeidiSQL Versión:             12.8.0.6908
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Volcando estructura de base de datos para db_invehin
CREATE DATABASE IF NOT EXISTS `db_invehin` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `db_invehin`;

-- Volcando estructura para tabla db_invehin.auditoria
CREATE TABLE IF NOT EXISTS `auditoria` (
  `id_auditoria` int NOT NULL AUTO_INCREMENT,
  `tabla_auditoria` varchar(100) NOT NULL,
  `operacion_auditoria` enum('INSERT','UPDATE','DELETE') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `idregistro_auditoria` varchar(50) NOT NULL DEFAULT '0',
  `fecha_auditoria` timestamp NOT NULL DEFAULT (now()),
  `detalleanterior_auditoria` text,
  `detallenuevo_auditoria` text,
  `usuario_auditoria` int DEFAULT NULL,
  PRIMARY KEY (`id_auditoria`),
  KEY `usuario_auditoria` (`usuario_auditoria`),
  CONSTRAINT `fk_auditoria_usuario` FOREIGN KEY (`usuario_auditoria`) REFERENCES `usuario` (`id_usuario`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Volcando datos para la tabla db_invehin.auditoria: ~0 rows (aproximadamente)

-- Volcando estructura para función db_invehin.calcular_total_pedido
DELIMITER //
CREATE FUNCTION `calcular_total_pedido`(
	`pedidoId` INT
) RETURNS int
    DETERMINISTIC
BEGIN

	DECLARE total INT;
	
	SELECT
		IFNULL(SUM(dp.cantidad_detallepedido * dp.costounitario_detallepedido), 0) INTO total
	FROM
		detallepedido dp
	WHERE
		dp.fk_id_pedido = pedidoId;
	
	RETURN total;

END//
DELIMITER ;

-- Volcando estructura para función db_invehin.calcular_total_venta
DELIMITER //
CREATE FUNCTION `calcular_total_venta`(
	`id` INT
) RETURNS int
    DETERMINISTIC
BEGIN

	DECLARE total INT;
	
	SELECT
		IFNULL(SUM(dv.cantidad_detalleventa * s.precio_subcategoria), 0) INTO total
	FROM
		detalleventa dv
	INNER JOIN prenda p ON dv.fk_codigo_prenda = p.codigo_prenda
	INNER JOIN subcategoria s ON p.fk_id_subcategoria = s.id_subcategoria
	WHERE
		dv.fk_id_venta = id;
	
	RETURN total;

END//
DELIMITER ;

-- Volcando estructura para función db_invehin.calcular_total_ventas_por_rango
DELIMITER //
CREATE FUNCTION `calcular_total_ventas_por_rango`(
	`fecha_inicio` DATETIME,
	`fecha_fin` DATETIME
) RETURNS int
    DETERMINISTIC
BEGIN

	DECLARE total INT;
	
	SELECT
		IFNULL(SUM(dv.cantidad_detalleventa * s.precio_subcategoria), 0) INTO total
	FROM
		detalleventa dv
	INNER JOIN prenda p ON dv.fk_codigo_prenda = p.codigo_prenda
	INNER JOIN subcategoria s ON p.fk_id_subcategoria = s.id_subcategoria
	INNER JOIN venta v ON dv.fk_id_venta = v.id_venta
	WHERE
		v.fecha_venta BETWEEN fecha_inicio AND fecha_fin;
	
	RETURN total;

END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.cambiar_contrasenia
DELIMITER //
CREATE PROCEDURE `cambiar_contrasenia`(
	IN `id` INT,
	IN `contrasenia_actual` VARCHAR(255),
	IN `contrasenia_nueva` VARCHAR(255)
)
BEGIN
	
	START TRANSACTION;
	
	UPDATE
		usuario u
	SET
		u.contrasenia_usuario = SHA2(contrasenia_nueva, 256)
	WHERE
		u.id_usuario = id
		AND u.contrasenia_usuario = SHA2(contrasenia_actual, 256);
	
	COMMIT;
	
END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.cambiar_estado_categoria
DELIMITER //
CREATE PROCEDURE `cambiar_estado_categoria`(
	IN `id` INT,
	IN `estado` TINYINT
)
BEGIN

	START TRANSACTION;
	
	UPDATE
		categoria c
	SET
		c.estado_categoria = estado
	WHERE
		c.id_categoria = id;
	
	COMMIT;

END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.cambiar_estado_subcategoria
DELIMITER //
CREATE PROCEDURE `cambiar_estado_subcategoria`(
	IN `id` INT,
	IN `estado` TINYINT
)
BEGIN

	START TRANSACTION;
	
	UPDATE
		subcategoria s
	SET
		s.estado_subcategoria = estado
	WHERE
		s.id_subcategoria = id;
	
	COMMIT;

END//
DELIMITER ;

-- Volcando estructura para función db_invehin.cantidad_clientes_por_rango
DELIMITER //
CREATE FUNCTION `cantidad_clientes_por_rango`(
	`fecha_inicio` DATE,
	`fecha_fin` DATE
) RETURNS int
    DETERMINISTIC
BEGIN
	
	DECLARE total INT;

	SELECT
		COUNT(c.id_cliente) INTO total
	FROM
		cliente c
	WHERE
		c.fecharegistro_cliente BETWEEN fecha_inicio AND fecha_fin;
	
	RETURN total;

END//
DELIMITER ;

-- Volcando estructura para función db_invehin.cantidad_prendas_bajo_stock
DELIMITER //
CREATE FUNCTION `cantidad_prendas_bajo_stock`() RETURNS int
    DETERMINISTIC
BEGIN

	DECLARE total INT;
	
	SELECT
		COUNT(p.codigo_prenda) INTO total
	FROM
		prenda p
	WHERE
		p.stock_prenda < p.stockminimo_prenda;
	
	RETURN total;

END//
DELIMITER ;

-- Volcando estructura para función db_invehin.cantidad_prendas_vendidas_por_rango
DELIMITER //
CREATE FUNCTION `cantidad_prendas_vendidas_por_rango`(
	`fecha_inicio` DATETIME,
	`fecha_fin` DATETIME
) RETURNS int
    DETERMINISTIC
BEGIN

	DECLARE total INT;
	
	SELECT
		IFNULL(SUM(dv.cantidad_detalleventa), 0) INTO total
	FROM
		detalleventa dv
	INNER JOIN venta v ON dv.fk_id_venta = v.id_venta
	WHERE
		v.fecha_venta BETWEEN fecha_inicio AND fecha_fin;
	
	RETURN total;

END//
DELIMITER ;

-- Volcando estructura para tabla db_invehin.categoria
CREATE TABLE IF NOT EXISTS `categoria` (
  `id_categoria` int NOT NULL AUTO_INCREMENT,
  `nombre_categoria` varchar(50) NOT NULL,
  `estado_categoria` tinyint NOT NULL DEFAULT '1',
  PRIMARY KEY (`id_categoria`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Volcando datos para la tabla db_invehin.categoria: ~9 rows (aproximadamente)
INSERT INTO `categoria` (`id_categoria`, `nombre_categoria`, `estado_categoria`) VALUES
	(1, 'Blusa', 1),
	(2, 'Pantalon', 1),
	(3, 'Falda', 1),
	(4, 'Vestido', 1),
	(5, 'Camisa', 1),
	(6, 'Short', 1),
	(7, 'Abrigo', 0),
	(8, 'Suéter', 1),
	(9, 'Chaqueta', 1);

-- Volcando estructura para tabla db_invehin.cliente
CREATE TABLE IF NOT EXISTS `cliente` (
  `id_cliente` int NOT NULL AUTO_INCREMENT,
  `direccion_cliente` varchar(150) NOT NULL,
  `fecharegistro_cliente` timestamp NOT NULL DEFAULT (now()),
  `estado_cliente` tinyint(1) NOT NULL DEFAULT '1',
  `fk_id_persona` int NOT NULL,
  PRIMARY KEY (`id_cliente`),
  KEY `fk_cliente_persona_idx` (`fk_id_persona`),
  CONSTRAINT `fk_cliente_persona` FOREIGN KEY (`fk_id_persona`) REFERENCES `persona` (`id_persona`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Volcando datos para la tabla db_invehin.cliente: ~10 rows (aproximadamente)
INSERT INTO `cliente` (`id_cliente`, `direccion_cliente`, `fecharegistro_cliente`, `estado_cliente`, `fk_id_persona`) VALUES
	(1, 'Cra 1 #10-10', '2025-05-10 14:15:30', 1, 9),
	(2, 'Cra 2 #20-20', '2025-06-10 10:32:00', 1, 10),
	(3, 'Cra 3 #30-30', '2025-05-30 20:06:30', 1, 11),
	(4, 'Cra 4 #40-40', '2025-06-05 17:56:02', 1, 12),
	(5, 'Cra 5 #50-50', '2025-05-23 18:25:00', 1, 13),
	(6, 'Cra 6 #60-60', '2025-05-03 13:30:15', 1, 14),
	(7, 'Cra 7 #70-70', '2025-05-02 21:44:54', 1, 15),
	(8, 'las avenidas', '2025-06-15 21:49:44', 0, 18),
	(9, 'Los angeles', '2025-06-20 22:16:38', 1, 21),
	(10, 'California', '2025-06-20 22:22:10', 1, 22),
	(11, 'Florencia', '2025-07-05 14:13:09', 1, 23),
	(12, 'Florencia', '2025-07-11 22:37:51', 1, 24);

-- Volcando estructura para tabla db_invehin.color
CREATE TABLE IF NOT EXISTS `color` (
  `id_color` int NOT NULL AUTO_INCREMENT,
  `nombre_color` varchar(50) NOT NULL,
  PRIMARY KEY (`id_color`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Volcando datos para la tabla db_invehin.color: ~15 rows (aproximadamente)
INSERT INTO `color` (`id_color`, `nombre_color`) VALUES
	(1, 'Rojo'),
	(2, 'Azul'),
	(3, 'Azul claro'),
	(4, 'Negro'),
	(5, 'Blanco'),
	(6, 'Gris'),
	(7, 'Rosa'),
	(8, 'Beige'),
	(9, 'Verde'),
	(10, 'Verde menta'),
	(11, 'Mostaza'),
	(12, 'Lila'),
	(13, 'Coral'),
	(14, 'Naranja'),
	(15, 'Amarillo');

-- Volcando estructura para procedimiento db_invehin.delete_color
DELIMITER //
CREATE PROCEDURE `delete_color`(
	IN `id` INT
)
BEGIN
	
	START TRANSACTION;
	
	DELETE
	FROM
		color c
	WHERE
		c.id_color = id;
	
	COMMIT;
	
END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.delete_estadoprenda
DELIMITER //
CREATE PROCEDURE `delete_estadoprenda`(
	IN `id` INT
)
BEGIN
	
	START TRANSACTION;
	
	DELETE
	FROM
		estadoprenda e
	WHERE
		e.id_estadoprenda = id;
	
	COMMIT;
	
END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.delete_inventario
DELIMITER //
CREATE PROCEDURE `delete_inventario`(
	IN `id` INT
)
BEGIN

	START TRANSACTION;
	
	DELETE
	FROM
		inventario i
	WHERE
		i.id_inventario = id;
	
	COMMIT;

END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.delete_motodopago
DELIMITER //
CREATE PROCEDURE `delete_motodopago`(
	IN `id` INT
)
BEGIN

	START TRANSACTION;
	
	DELETE
	FROM
		metodopago mp
	WHERE
		mp.id_metodopago = id;
	
	COMMIT;

END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.delete_pedido
DELIMITER //
CREATE PROCEDURE `delete_pedido`(
	IN `id` INT
)
BEGIN

	START TRANSACTION;
	
	DELETE
	FROM
		pedido p
	WHERE
		p.id_pedido = id;
	
	COMMIT;

END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.delete_permiso
DELIMITER //
CREATE PROCEDURE `delete_permiso`(
	IN `id` INT
)
BEGIN

	START TRANSACTION;
		
	DELETE
	FROM
		permiso p
	WHERE
		p.id_permiso = id;
	
	COMMIT;

END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.delete_persona
DELIMITER //
CREATE PROCEDURE `delete_persona`(
	IN `id` INT
)
BEGIN

	START TRANSACTION;
	
	DELETE
	FROM
		persona p
	WHERE
		p.id_persona = id;

	COMMIT;
	
END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.delete_promocion
DELIMITER //
CREATE PROCEDURE `delete_promocion`(
	IN `id` INT
)
BEGIN

	START TRANSACTION;
	
	DELETE
	FROM
		promocion p
	WHERE
		p.id_promocion = id;
	
	COMMIT;

END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.delete_rol
DELIMITER //
CREATE PROCEDURE `delete_rol`(
	IN `id` INT
)
BEGIN

	START TRANSACTION;
	
	UPDATE
		usuario u
		SET u.fk_id_rol = 2
	WHERE
		u.fk_id_rol = id;

	DELETE
	FROM
		rol r
	WHERE
		r.id_rol = id;
	
	COMMIT;

END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.delete_talla
DELIMITER //
CREATE PROCEDURE `delete_talla`(
	IN `id` INT
)
BEGIN
	
	START TRANSACTION;
	
	DELETE
	FROM
		talla t
	WHERE
		t.id_talla = id;
	
	COMMIT;
	
END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.delete_usuario
DELIMITER //
CREATE PROCEDURE `delete_usuario`(
	IN `id` INT
)
BEGIN

	START TRANSACTION;
	
	DELETE
	FROM
		usuario u
	WHERE
		u.id_usuario = id;
	
	COMMIT;

END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.delete_venta
DELIMITER //
CREATE PROCEDURE `delete_venta`(
	IN `id` INT
)
BEGIN
	
	START TRANSACTION;
	
	DELETE
	FROM
		venta v
	WHERE
		v.id_venta = id;
	
	COMMIT;
	
END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.desactivar_cliente
DELIMITER //
CREATE PROCEDURE `desactivar_cliente`(
	IN `id` INT
)
BEGIN
	
	START TRANSACTION;
	
	UPDATE
		cliente c
	SET
		c.estado_cliente = 0
	WHERE
		c.id_cliente = id;
	
	COMMIT;
	
END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.desactivar_prenda
DELIMITER //
CREATE PROCEDURE `desactivar_prenda`(
	IN `codigo` VARCHAR(50)
)
BEGIN

	START TRANSACTION;
	
	UPDATE
		prenda p
	SET
		p.fk_id_estadoprenda = 3
	WHERE
		p.codigo_prenda = codigo;
	
	COMMIT;

END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.desactivar_proveedor
DELIMITER //
CREATE PROCEDURE `desactivar_proveedor`(
	IN `id` INT
)
BEGIN

	START TRANSACTION;
	
	UPDATE
		proveedor p
	SET
		p.estado_proveedor = 0
	WHERE
		p.id_proveedor = id;
	
	COMMIT;

END//
DELIMITER ;

-- Volcando estructura para tabla db_invehin.detalleinventario
CREATE TABLE IF NOT EXISTS `detalleinventario` (
  `id_detalleinventario` int NOT NULL AUTO_INCREMENT,
  `observacion_detalleinventario` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `cantidadregistrada_detalleinventario` int NOT NULL,
  `cantidadsistema_detalleinventario` int NOT NULL,
  `fk_id_inventario` int NOT NULL,
  `fk_codigo_prenda` varchar(50) NOT NULL,
  PRIMARY KEY (`id_detalleinventario`),
  KEY `fk_inventariounidadprenda_inventario_idx` (`fk_id_inventario`),
  KEY `fk_inventarioprenda_prenda_idx` (`fk_codigo_prenda`),
  CONSTRAINT `fk_inventarioprenda_inventario` FOREIGN KEY (`fk_id_inventario`) REFERENCES `inventario` (`id_inventario`) ON UPDATE CASCADE,
  CONSTRAINT `fk_inventarioprenda_prenda` FOREIGN KEY (`fk_codigo_prenda`) REFERENCES `prenda` (`codigo_prenda`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Volcando datos para la tabla db_invehin.detalleinventario: ~25 rows (aproximadamente)
INSERT INTO `detalleinventario` (`id_detalleinventario`, `observacion_detalleinventario`, `cantidadregistrada_detalleinventario`, `cantidadsistema_detalleinventario`, `fk_id_inventario`, `fk_codigo_prenda`) VALUES
	(1, 'Stock agotado', 0, 0, 1, 'PR001'),
	(2, 'Faltan 1', 28, 29, 2, 'PR002'),
	(3, 'Correcto', 23, 23, 2, 'PR003'),
	(4, 'Excedente', 13, 12, 3, 'PR004'),
	(5, 'Coincide', 54, 54, 3, 'PR005'),
	(6, 'Falta 1', 3, 4, 3, 'PR006'),
	(7, 'Sin novedad', 21, 21, 4, 'PR007'),
	(8, 'Revisar estado', 27, 27, 4, 'PR008'),
	(9, 'Correcto', 41, 41, 4, 'PR009'),
	(10, 'Normal', 49, 49, 4, 'PR010'),
	(11, 'Coincide', 23, 23, 5, 'PR003'),
	(12, 'OK', 4, 4, 6, 'PR006'),
	(13, 'Agotado', 0, 0, 6, 'PR001'),
	(14, 'Sin cambios', 41, 41, 6, 'PR009'),
	(15, 'Menor conteo', 27, 29, 6, 'PR002'),
	(16, 'Coincide', 49, 49, 6, 'PR010'),
	(17, 'Excedente mínimo', 13, 12, 7, 'PR004'),
	(18, 'Sin diferencia', 54, 54, 8, 'PR005'),
	(19, 'Revisado', 23, 23, 8, 'PR003'),
	(20, 'Stock real menor', 20, 21, 9, 'PR007'),
	(21, 'Estado inactivo', 27, 27, 9, 'PR008'),
	(22, 'Faltan 2', 2, 4, 9, 'PR006'),
	(23, 'Sin inventario', 0, 0, 10, 'PR001'),
	(24, 'Revisión de stock', 11, 12, 10, 'PR004'),
	(46, 'Pero que ha pasao?', 120, 127, 23, 'PR005');

-- Volcando estructura para tabla db_invehin.detallepedido
CREATE TABLE IF NOT EXISTS `detallepedido` (
  `id_detallepedido` int NOT NULL AUTO_INCREMENT,
  `cantidad_detallepedido` int NOT NULL,
  `costounitario_detallepedido` double NOT NULL DEFAULT (0),
  `fk_id_pedido` int NOT NULL,
  `fk_codigo_prenda` varchar(50) NOT NULL,
  PRIMARY KEY (`id_detallepedido`),
  KEY `fk_pedidoprenda_pedido_idx` (`fk_id_pedido`),
  KEY `fk_pedidoprenda_prenda_idx` (`fk_codigo_prenda`),
  CONSTRAINT `fk_pedidoprenda_pedido` FOREIGN KEY (`fk_id_pedido`) REFERENCES `pedido` (`id_pedido`) ON UPDATE CASCADE,
  CONSTRAINT `fk_pedidoprenda_prenda` FOREIGN KEY (`fk_codigo_prenda`) REFERENCES `prenda` (`codigo_prenda`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Volcando datos para la tabla db_invehin.detallepedido: ~22 rows (aproximadamente)
INSERT INTO `detallepedido` (`id_detallepedido`, `cantidad_detallepedido`, `costounitario_detallepedido`, `fk_id_pedido`, `fk_codigo_prenda`) VALUES
	(23, 10, 35000, 1, 'PR001'),
	(24, 6, 42000.5, 1, 'PR004'),
	(25, 20, 57000, 2, 'PR005'),
	(26, 15, 30000, 3, 'PR002'),
	(27, 8, 28000.75, 3, 'PR006'),
	(28, 10, 49000, 3, 'PR009'),
	(29, 12, 31000, 4, 'PR007'),
	(30, 14, 39000, 4, 'PR003'),
	(31, 9, 52000.5, 4, 'PR010'),
	(32, 7, 45500, 5, 'PR008'),
	(33, 4, 39000, 6, 'PR004'),
	(34, 6, 31000, 6, 'PR006'),
	(35, 11, 29500, 7, 'PR002'),
	(36, 13, 47000, 7, 'PR009'),
	(37, 10, 51500, 7, 'PR010'),
	(38, 9, 36000, 8, 'PR001'),
	(39, 6, 45000, 8, 'PR008'),
	(40, 7, 32500, 8, 'PR007'),
	(41, 18, 59000, 8, 'PR005'),
	(42, 10, 41000, 9, 'PR003'),
	(54, 1, 30000, 10, 'FM001'),
	(55, 14, 30000, 10, 'PR002'),
	(56, 2, 23100, 11, 'SC001'),
	(57, 6, 21300, 11, 'CM001');

-- Volcando estructura para tabla db_invehin.detalleventa
CREATE TABLE IF NOT EXISTS `detalleventa` (
  `id_detalleventa` int NOT NULL AUTO_INCREMENT,
  `cantidad_detalleventa` int NOT NULL,
  `fk_codigo_prenda` varchar(50) NOT NULL,
  `fk_id_venta` int NOT NULL,
  PRIMARY KEY (`id_detalleventa`),
  KEY `fk_prendaventa_prenda_idx` (`fk_codigo_prenda`),
  KEY `fk_prendaventa_venta_idx` (`fk_id_venta`),
  CONSTRAINT `fk_prendaventa_prenda` FOREIGN KEY (`fk_codigo_prenda`) REFERENCES `prenda` (`codigo_prenda`) ON UPDATE CASCADE,
  CONSTRAINT `fk_prendaventa_venta` FOREIGN KEY (`fk_id_venta`) REFERENCES `venta` (`id_venta`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Volcando datos para la tabla db_invehin.detalleventa: ~32 rows (aproximadamente)
INSERT INTO `detalleventa` (`id_detalleventa`, `cantidad_detalleventa`, `fk_codigo_prenda`, `fk_id_venta`) VALUES
	(1, 2, 'PR001', 1),
	(2, 1, 'PR002', 2),
	(3, 3, 'PR003', 2),
	(4, 4, 'PR004', 3),
	(5, 1, 'PR005', 3),
	(6, 2, 'PR006', 3),
	(7, 1, 'PR007', 4),
	(8, 5, 'PR008', 5),
	(9, 2, 'PR009', 6),
	(10, 2, 'PR010', 6),
	(11, 1, 'PR001', 7),
	(12, 3, 'PR002', 7),
	(13, 2, 'PR003', 8),
	(14, 3, 'PR004', 9),
	(15, 4, 'PR005', 9),
	(16, 1, 'PR006', 10),
	(17, 1, 'PR007', 11),
	(18, 2, 'PR008', 11),
	(19, 1, 'PR009', 12),
	(20, 3, 'PR010', 12),
	(21, 1, 'PR001', 13),
	(22, 2, 'PR002', 14),
	(23, 2, 'PR003', 14),
	(24, 1, 'PR004', 14),
	(25, 1, 'PR005', 15),
	(26, 3, 'PR006', 16),
	(27, 2, 'PR007', 16),
	(28, 1, 'PR008', 17),
	(29, 1, 'PR009', 18),
	(30, 1, 'PR010', 18),
	(31, 1, 'PR001', 19),
	(32, 5, 'PR002', 20),
	(33, 5, 'PR006', 21),
	(34, 2, 'PR005', 23),
	(35, 1, 'PR002', 23),
	(36, 1, 'PR005', 25),
	(37, 2, 'PR007', 26),
	(38, 1, 'PR002', 27),
	(39, 2, 'CM001', 28),
	(40, 2, 'PR005', 29),
	(41, 1, 'FM001', 29);

-- Volcando estructura para tabla db_invehin.estadoprenda
CREATE TABLE IF NOT EXISTS `estadoprenda` (
  `id_estadoprenda` int NOT NULL AUTO_INCREMENT,
  `nombre_estadoprenda` varchar(50) NOT NULL,
  PRIMARY KEY (`id_estadoprenda`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Volcando datos para la tabla db_invehin.estadoprenda: ~2 rows (aproximadamente)
INSERT INTO `estadoprenda` (`id_estadoprenda`, `nombre_estadoprenda`) VALUES
	(1, 'Existente'),
	(2, 'Descontinuado'),
	(3, 'Inactiva');

-- Volcando estructura para procedimiento db_invehin.get_prendas_mas_vendidas_por_rango
DELIMITER //
CREATE PROCEDURE `get_prendas_mas_vendidas_por_rango`(
	IN `cantidad` INT,
	IN `fecha_inicio` DATE,
	IN `fecha_fin` DATE
)
BEGIN

	SELECT
		p.codigo_prenda AS codigo,
		c.nombre_categoria AS categoria_nombre,
		s.nombre_subcategoria AS subcategoria_nombre,
		t.nombre_talla AS talla_nombre,
		co.nombre_color AS color_nombre,
		SUM(dv.cantidad_detalleventa) AS cantidad_total
	FROM
		venta v
	INNER JOIN detalleventa dv ON v.id_venta = dv.fk_id_venta
	INNER JOIN prenda p ON dv.fk_codigo_prenda = p.codigo_prenda
	INNER JOIN subcategoria s ON p.fk_id_subcategoria = s.id_subcategoria
	INNER JOIN categoria c ON s.fk_id_categoria = c.id_categoria
	INNER JOIN color co ON p.fk_id_color = co.id_color
	INNER JOIN talla t ON p.fk_id_talla = t.id_talla
   WHERE
   	v.fecha_venta BETWEEN fecha_inicio AND fecha_fin
   GROUP BY
   	p.codigo_prenda
	ORDER BY
		cantidad_total DESC,
		c.nombre_categoria ASC,
		s.nombre_subcategoria ASC,
		t.nombre_talla ASC,
		co.nombre_color ASC
	LIMIT cantidad;

END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.get_valor_prendas_por_categoria
DELIMITER //
CREATE PROCEDURE `get_valor_prendas_por_categoria`()
BEGIN

	SELECT
		c.nombre_categoria AS nombre,
		SUM(p.stock_prenda * s.precio_subcategoria) AS total
	FROM
		prenda p
	INNER JOIN subcategoria s ON p.fk_id_subcategoria = s.id_subcategoria
	INNER JOIN categoria c ON s.fk_id_categoria = c.id_categoria
	GROUP BY
		c.nombre_categoria
	ORDER BY
		c.nombre_categoria ASC;

END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.get_ventas_por_dia_por_rango
DELIMITER //
CREATE PROCEDURE `get_ventas_por_dia_por_rango`(
	IN `fecha_inicio` DATE,
	IN `fecha_fin` DATE
)
BEGIN

	SELECT
		DATE(v.fecha_venta) AS fecha,
		SUM(dv.cantidad_detalleventa * s.precio_subcategoria) AS total
	FROM
		venta v
	INNER JOIN detalleventa dv ON v.id_venta = dv.fk_id_venta
	INNER JOIN prenda p ON dv.fk_codigo_prenda = p.codigo_prenda
	INNER JOIN subcategoria s ON p.fk_id_subcategoria = s.id_subcategoria
	WHERE
      v.fecha_venta BETWEEN fecha_inicio AND fecha_fin
	GROUP BY
		DATE(v.fecha_venta)
	ORDER BY
		DATE(v.fecha_venta) ASC;

END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.insert_categoria
DELIMITER //
CREATE PROCEDURE `insert_categoria`(
	IN `nombre` VARCHAR(50)
)
BEGIN

	START TRANSACTION;
		
	INSERT INTO categoria (
		categoria.nombre_categoria
	) VALUES (
		nombre
	);
		
	COMMIT;

END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.insert_cliente
DELIMITER //
CREATE PROCEDURE `insert_cliente`(
	IN `nombres` VARCHAR(100),
	IN `apellidos` VARCHAR(100),
	IN `numero_identificacion` VARCHAR(15),
	IN `telefono` VARCHAR(20),
	IN `genero` TINYINT,
	IN `direccion` VARCHAR(150)
)
BEGIN

	DECLARE persona_id INT DEFAULT NULL;
	
	START TRANSACTION;
	
	CALL insert_persona(nombres, apellidos, numero_identificacion, telefono, genero, persona_id);
	
	INSERT INTO cliente (
		cliente.direccion_cliente,
		cliente.fk_id_persona
	) VALUES (
		direccion,
		persona_id
	);
	
	COMMIT;
	
END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.insert_color
DELIMITER //
CREATE PROCEDURE `insert_color`(
	IN `nombre` VARCHAR(50)
)
BEGIN
	
	START TRANSACTION;
		
	INSERT INTO color (
		color.nombre_color
	) VALUES (
		nombre
	);
		
	COMMIT;
	
END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.insert_estadoprenda
DELIMITER //
CREATE PROCEDURE `insert_estadoprenda`(
	IN `nombre` VARCHAR(50)
)
BEGIN

	START TRANSACTION;
	
	INSERT INTO estadoprenda (
		estadoprenda.nombre_estadoprenda
	) VALUES (
		nombre
	);
	
	COMMIT;

END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.insert_inventario
DELIMITER //
CREATE PROCEDURE `insert_inventario`(
	IN `observacion` VARCHAR(500),
	IN `usuario_id` INT,
	IN `detalles_inventario` JSON
)
BEGIN

	DECLARE inventario_id INT DEFAULT NULL;
	DECLARE prenda_codigo VARCHAR(50);
	DECLARE detalle_observacion VARCHAR(100);
	DECLARE cantidad_registrada INT;
	DECLARE cantidad_sistema INT;
	DECLARE detalles_inventario_count INT DEFAULT JSON_LENGTH(detalles_inventario);
	DECLARE i INT DEFAULT 0;
	
	START TRANSACTION;
		
	INSERT INTO inventario (
		inventario.observacion_inventario,
		inventario.fk_id_usuario
	) VALUES (
		observacion,
		usuario_id
	);
	
	SET inventario_id = LAST_INSERT_ID();

	WHILE i < detalles_inventario_count DO
		SET prenda_codigo = JSON_UNQUOTE(JSON_EXTRACT(detalles_inventario, CONCAT('$[', i, '].codigo_prenda')));
		SET detalle_observacion = JSON_UNQUOTE(JSON_EXTRACT(detalles_inventario, CONCAT('$[', i, '].observacion')));
		SET cantidad_registrada = CAST(JSON_EXTRACT(detalles_inventario, CONCAT('$[', i, '].cantidad_registrada')) AS UNSIGNED);
		SET cantidad_sistema = CAST(JSON_EXTRACT(detalles_inventario, CONCAT('$[', i, '].cantidad_sistema')) AS UNSIGNED);
		
		INSERT INTO detalleinventario (
			detalleinventario.observacion_detalleinventario,
			detalleinventario.cantidadregistrada_detalleinventario,
			detalleinventario.cantidadsistema_detalleinventario,
			detalleinventario.fk_id_inventario,
			detalleinventario.fk_codigo_prenda
		) VALUES (
			detalle_observacion,
			cantidad_registrada,
			cantidad_sistema,
			inventario_id,
			prenda_codigo
		);
		
		SET i = i + 1;
	END WHILE;
	
	COMMIT;
	
END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.insert_metodopago
DELIMITER //
CREATE PROCEDURE `insert_metodopago`(
	IN `nombre` VARCHAR(50)
)
BEGIN

	START TRANSACTION;
	
	INSERT INTO metodopago (
		metodopago.nombre_metodopago
	) VALUES (
		nombre
	);
	
	COMMIT;

END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.insert_pedido
DELIMITER //
CREATE PROCEDURE `insert_pedido`(
	IN `fecha` DATE,
	IN `proveedor_id` INT,
	IN `estado` TINYINT,
	IN `detalles_pedido` JSON
)
BEGIN

	DECLARE pedido_id INT DEFAULT NULL;
	DECLARE prenda_codigo VARCHAR(50);
	DECLARE cantidad_prenda INT;
	DECLARE costo_unitario_prenda DOUBLE;
	DECLARE detalles_pedido_count INT DEFAULT JSON_LENGTH(detalles_pedido);
	DECLARE i INT DEFAULT 0;
	
	START TRANSACTION;
		
	INSERT INTO pedido (
		pedido.fecha_pedido,
		pedido.estado_pedido,
		pedido.fk_id_proveedor
	) VALUES (
		fecha,
		estado,
		proveedor_id
	);
	
	SET pedido_id = LAST_INSERT_ID();

	WHILE i < detalles_pedido_count DO
		SET prenda_codigo = JSON_UNQUOTE(JSON_EXTRACT(detalles_pedido, CONCAT('$[', i, '].codigo_prenda')));
		SET cantidad_prenda = CAST(JSON_EXTRACT(detalles_pedido, CONCAT('$[', i, '].cantidad')) AS UNSIGNED);
		SET costo_unitario_prenda = CAST(JSON_EXTRACT(detalles_pedido, CONCAT('$[', i, '].costo_unitario')) AS DECIMAL(10,2));
		
		INSERT INTO detallepedido (
			detallepedido.cantidad_detallepedido,
			detallepedido.costounitario_detallepedido,
			detallepedido.fk_id_pedido,
			detallepedido.fk_codigo_prenda
		) VALUES (
			cantidad_prenda,
			costo_unitario_prenda,
			pedido_id,
			prenda_codigo
		);
		
		SET i = i + 1;
	END WHILE;
	
	COMMIT;
	
END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.insert_permiso
DELIMITER //
CREATE PROCEDURE `insert_permiso`(
	IN `nombre` VARCHAR(50)
)
BEGIN

	START TRANSACTION;
	
	INSERT INTO permiso (
		permiso.nombre_permiso
	) VALUES (
		nombre
	);
	
	COMMIT;

END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.insert_persona
DELIMITER //
CREATE PROCEDURE `insert_persona`(
	IN `nombres` VARCHAR(100),
	IN `apellidos` VARCHAR(100),
	IN `numero_identificacion` VARCHAR(15),
	IN `telefono` VARCHAR(20),
	IN `genero` TINYINT,
	OUT `persona_id` INT
)
BEGIN
	
	START TRANSACTION;
	
	INSERT INTO persona (
		persona.nombres_persona,
		persona.apellidos_persona,
		persona.numeroidentificacion_persona,
		persona.telefono_persona,
		persona.genero_persona
	) VALUES (
		nombres,
		apellidos,
		numero_identificacion,
		telefono,
		genero
	);
	
	SET persona_id = LAST_INSERT_ID();
	
	COMMIT;
	
END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.insert_prenda
DELIMITER //
CREATE PROCEDURE `insert_prenda`(
	IN `codigo` VARCHAR(50),
	IN `stock` INT,
	IN `stock_minimo` INT,
	IN `color_id` INT,
	IN `subcategoria_id` INT,
	IN `talla_id` INT
)
BEGIN

	START TRANSACTION;
	
	INSERT INTO prenda (
		prenda.codigo_prenda,
		prenda.stock_prenda,
		prenda.stockminimo_prenda,
		prenda.fk_id_color,
		prenda.fk_id_subcategoria,
		prenda.fk_id_talla
	) VALUES (
		codigo,
		stock,
		stock_minimo,
		color_id,
		subcategoria_id,
		talla_id
	);
	
	COMMIT;

END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.insert_promocion
DELIMITER //
CREATE PROCEDURE `insert_promocion`(
	IN `porcentaje` INT,
	IN `fecha_inicio` DATE,
	IN `fecha_fin` DATE
)
BEGIN

	START TRANSACTION;
	
	INSERT INTO promocion (
		promocion.porcentaje_promocion,
		promocion.fechainicio_promocion,
		promocion.fechafin_promocion
	) VALUES (
		porcentaje,
		fecha_inicio,
		fecha_fin
	);
	
	COMMIT;

END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.insert_proveedor
DELIMITER //
CREATE PROCEDURE `insert_proveedor`(
	IN `nombre` VARCHAR(100),
	IN `correo` VARCHAR(150),
	IN `direccion` VARCHAR(150),
	IN `nombres` VARCHAR(100),
	IN `apellidos` VARCHAR(100),
	IN `telefono` VARCHAR(20)
)
BEGIN

	DECLARE persona_id INT DEFAULT NULL;
	
	START TRANSACTION;
	
	CALL insert_persona(nombres, apellidos, NULL, telefono, NULL, persona_id);
	
	INSERT INTO proveedor (
		proveedor.nombre_proveedor,
		proveedor.direccion_proveedor,
		proveedor.correo_proveedor,
		proveedor.fk_id_persona
	) VALUES (
		nombre,
		direccion,
		correo,
		persona_id
	);
	
	COMMIT;

END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.insert_rol
DELIMITER //
CREATE PROCEDURE `insert_rol`(
	IN `nombre` VARCHAR(50),
	IN `permisos` JSON
)
BEGIN

	DECLARE rol_id INT DEFAULT NULL;
	DECLARE permiso_id INT;
	DECLARE permisos_count INT DEFAULT JSON_LENGTH(permisos);
	DECLARE i INT DEFAULT 0;
	
	START TRANSACTION;
	
	INSERT INTO rol (
		rol.nombre_rol
	) VALUES (
		nombre
	);
	
	SET rol_id = LAST_INSERT_ID();
	
	WHILE i < permisos_count DO
		SET permiso_id = JSON_EXTRACT(permisos, CONCAT('$[', i, '].id'));
		
		INSERT INTO permisorol (
			permisorol.fk_id_rol,
			permisorol.fk_id_permiso
		) VALUES (
			rol_id,
			permiso_id
		);
		
		SET i = i + 1;
	END WHILE;
	
	COMMIT;
	
END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.insert_subcategoria
DELIMITER //
CREATE PROCEDURE `insert_subcategoria`(
	IN `nombre` VARCHAR(50),
	IN `precio` INT,
	IN `categoria_id` INT
)
BEGIN

	START TRANSACTION;
	
	INSERT INTO subcategoria (
		subcategoria.nombre_subcategoria,
		subcategoria.precio_subcategoria,
		subcategoria.fk_id_categoria
	) VALUES (
		nombre,
		precio,
		categoria_id
	);
	
	COMMIT;

END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.insert_talla
DELIMITER //
CREATE PROCEDURE `insert_talla`(
	IN `nombre` VARCHAR(50)
)
BEGIN
	
	START TRANSACTION;
	
	INSERT INTO talla (
		talla.nombre_talla
	) VALUES (
		nombre
	);
	
	COMMIT;
	
END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.insert_usuario
DELIMITER //
CREATE PROCEDURE `insert_usuario`(
	IN `correo` VARCHAR(150),
	IN `rol_id` INT,
	IN `nombres` VARCHAR(100),
	IN `apellidos` VARCHAR(100),
	IN `numero_identificacion` VARCHAR(15),
	IN `telefono` VARCHAR(20),
	IN `genero` TINYINT
)
BEGIN
	
	DECLARE persona_id INT DEFAULT NULL;
	
	START TRANSACTION;
	
	CALL insert_persona(nombres, apellidos, numero_identificacion, telefono, genero, persona_id);

	INSERT INTO usuario (
		usuario.correo_usuario,
		usuario.contrasenia_usuario,
		usuario.fk_id_persona,
		usuario.fk_id_rol
	) VALUES (
		correo,
		SHA2(numero_identificacion, 256),
		persona_id,
		rol_id
	);
	
	COMMIT;

END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.insert_venta
DELIMITER //
CREATE PROCEDURE `insert_venta`(
	IN `monto_recibido` INT,
	IN `cliente_id` INT,
	IN `metodopago_id` INT,
	IN `usuario_id` INT,
	IN `detalles_venta` JSON
)
BEGIN

	DECLARE venta_id INT DEFAULT NULL;
	DECLARE prenda_codigo VARCHAR(50);
	DECLARE cantidad INT;
	DECLARE detalles_venta_count INT DEFAULT JSON_LENGTH(detalles_venta);
	DECLARE i INT DEFAULT 0;
	
	START TRANSACTION;
		
	INSERT INTO venta (
		venta.montorecibido_venta,
		venta.fk_id_cliente,
		venta.fk_id_metodopago,
		venta.fk_id_usuario
	) VALUES (
		monto_recibido,
		cliente_id,
		metodopago_id,
		usuario_id
	);
	
	SET venta_id = LAST_INSERT_ID();

	WHILE i < detalles_venta_count DO
		SET prenda_codigo = JSON_UNQUOTE(JSON_EXTRACT(detalles_venta, CONCAT('$[', i, '].codigo_prenda')));
		SET cantidad = CAST(JSON_EXTRACT(detalles_venta, CONCAT('$[', i, '].cantidad')) AS UNSIGNED);
		
		INSERT INTO detalleventa (
			detalleventa.cantidad_detalleventa,
			detalleventa.fk_codigo_prenda,
			detalleventa.fk_id_venta
		) VALUES (
			cantidad,
			prenda_codigo,
			venta_id
		);
		
		SET i = i + 1;
	END WHILE;
	
	COMMIT;
	
END//
DELIMITER ;

-- Volcando estructura para tabla db_invehin.inventario
CREATE TABLE IF NOT EXISTS `inventario` (
  `id_inventario` int NOT NULL AUTO_INCREMENT,
  `fecha_inventario` datetime NOT NULL DEFAULT (now()),
  `observacion_inventario` varchar(500) DEFAULT NULL,
  `estado_inventario` tinyint(1) NOT NULL DEFAULT '1',
  `fk_id_usuario` int DEFAULT NULL,
  PRIMARY KEY (`id_inventario`),
  KEY `fk_inventario_usuario_idx` (`fk_id_usuario`),
  CONSTRAINT `fk_inventario_usuario` FOREIGN KEY (`fk_id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Volcando datos para la tabla db_invehin.inventario: ~10 rows (aproximadamente)
INSERT INTO `inventario` (`id_inventario`, `fecha_inventario`, `observacion_inventario`, `estado_inventario`, `fk_id_usuario`) VALUES
	(1, '2025-05-21 23:38:23', 'Inventario automático 1', 1, 4),
	(2, '2025-05-22 23:38:23', 'Inventario automático 2', 1, 4),
	(3, '2025-05-23 23:38:23', 'Inventario automático 3', 1, 4),
	(4, '2025-05-22 23:38:23', 'Inventario automático 4', 1, 4),
	(5, '2025-05-21 23:38:23', 'Inventario automático 5', 1, 4),
	(6, '2025-05-22 23:38:23', 'Inventario automático 6', 1, 4),
	(7, '2025-05-23 23:38:23', 'Inventario automático 7', 1, 4),
	(8, '2025-05-22 23:38:23', 'Inventario automático 8', 1, 4),
	(9, '2025-05-21 23:38:23', 'Inventario automático 9', 1, 4),
	(10, '2025-05-23 23:38:23', 'Inventario automático 10', 1, 4),
	(23, '2025-07-04 18:49:10', 'Todo good', 0, 1);

-- Volcando estructura para procedimiento db_invehin.login
DELIMITER //
CREATE PROCEDURE `login`(
	IN `correo` VARCHAR(150),
	IN `contrasenia` VARCHAR(255)
)
BEGIN

	DECLARE rol_id INT DEFAULT NULL;
	
	START TRANSACTION;
	
	SELECT
		vu.id,
		vu.correo,
		vu.contrasenia,
		vu.estado,
		vu.rol_id,
		vu.rol_nombre,
		vu.rol_estado,
		vu.persona_id,
		vu.nombres,
		vu.apellidos,
		vu.numero_identificacion,
		vu.telefono,
		vu.genero
	FROM
		view_usuario vu
	WHERE
		vu.correo = correo
		AND vu.contrasenia = SHA2(contrasenia, 256)
		AND vu.estado = 1
	LIMIT 1;
	
	SELECT
		vu.rol_id INTO rol_id
	FROM
		view_usuario vu
	WHERE
		vu.correo = correo
		AND vu.contrasenia = SHA2(contrasenia, 256)
	LIMIT 1;
	
	IF rol_id IS NOT NULL THEN
		CALL select_permisos_by_rol(rol_id);
	END IF;
	
	COMMIT;
	
END//
DELIMITER ;

-- Volcando estructura para tabla db_invehin.metodopago
CREATE TABLE IF NOT EXISTS `metodopago` (
  `id_metodopago` int NOT NULL AUTO_INCREMENT,
  `nombre_metodopago` varchar(50) NOT NULL,
  `estado_metodopago` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id_metodopago`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Volcando datos para la tabla db_invehin.metodopago: ~2 rows (aproximadamente)
INSERT INTO `metodopago` (`id_metodopago`, `nombre_metodopago`, `estado_metodopago`) VALUES
	(1, 'Efectivo', 1),
	(2, 'Sistecredito', 1);

-- Volcando estructura para tabla db_invehin.pedido
CREATE TABLE IF NOT EXISTS `pedido` (
  `id_pedido` int NOT NULL AUTO_INCREMENT,
  `fecha_pedido` date NOT NULL,
  `estado_pedido` tinyint(1) NOT NULL DEFAULT '1',
  `fk_id_proveedor` int NOT NULL,
  PRIMARY KEY (`id_pedido`),
  KEY `fk_pedido_proveedor_idx` (`fk_id_proveedor`),
  CONSTRAINT `fk_pedido_proveedor` FOREIGN KEY (`fk_id_proveedor`) REFERENCES `proveedor` (`id_proveedor`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Volcando datos para la tabla db_invehin.pedido: ~11 rows (aproximadamente)
INSERT INTO `pedido` (`id_pedido`, `fecha_pedido`, `estado_pedido`, `fk_id_proveedor`) VALUES
	(1, '2025-05-01', 1, 1),
	(2, '2025-05-02', 1, 7),
	(3, '2025-05-03', 1, 4),
	(4, '2025-05-04', 1, 1),
	(5, '2025-05-05', 1, 11),
	(6, '2025-05-06', 1, 1),
	(7, '2025-05-07', 1, 1),
	(8, '2025-05-08', 1, 7),
	(9, '2025-05-09', 1, 1),
	(10, '2025-05-10', 0, 2),
	(11, '2025-07-04', 0, 11);

-- Volcando estructura para tabla db_invehin.permiso
CREATE TABLE IF NOT EXISTS `permiso` (
  `id_permiso` int NOT NULL AUTO_INCREMENT,
  `nombre_permiso` varchar(50) NOT NULL,
  PRIMARY KEY (`id_permiso`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Volcando datos para la tabla db_invehin.permiso: ~11 rows (aproximadamente)
INSERT INTO `permiso` (`id_permiso`, `nombre_permiso`) VALUES
	(1, 'Consultar categorias'),
	(2, 'Registrar categorias'),
	(3, 'Consultar usuarios'),
	(4, 'Consultar clientes'),
	(5, 'Consultar roles'),
	(6, 'Registrar venta'),
	(7, 'Consultar ventas'),
	(8, 'Consultar prendas'),
	(9, 'Consultar pedidos'),
	(10, 'Consultar proveedores'),
	(11, 'Consultar inventario'),
	(12, 'Registrar usuarios'),
	(13, 'Registrar clientes'),
	(14, 'Registrar roles'),
	(15, 'Registrar prendas'),
	(16, 'Registrar pedidos'),
	(17, 'Registrar proveedores'),
	(18, 'Registrar inventario'),
	(19, 'Editar categorias'),
	(20, 'Editar usuarios'),
	(21, 'Editar clientes'),
	(22, 'Editar roles'),
	(23, 'Editar ventas'),
	(24, 'Editar prendas'),
	(25, 'Editar pedidos'),
	(26, 'Editar proveedores'),
	(27, 'Editar inventario'),
	(28, 'Desactivar categorias'),
	(29, 'Eliminar clientes'),
	(30, 'Eliminar roles'),
	(31, 'Eliminar prendas'),
	(32, 'Eliminar proveedores'),
	(33, 'Reporte ventas'),
	(34, 'Reporte pedidos'),
	(35, 'Reporte prendas'),
	(36, 'Reporte inventario'),
	(37, 'Gestionar perfil');

-- Volcando estructura para tabla db_invehin.permisorol
CREATE TABLE IF NOT EXISTS `permisorol` (
  `id_permisorol` int NOT NULL AUTO_INCREMENT,
  `estado_permisorol` tinyint(1) NOT NULL DEFAULT '1',
  `fk_id_permiso` int NOT NULL,
  `fk_id_rol` int NOT NULL,
  PRIMARY KEY (`id_permisorol`),
  KEY `fk_permisorol_permiso_idx` (`fk_id_permiso`),
  KEY `fk_permisorol_rol_idx` (`fk_id_rol`),
  CONSTRAINT `fk_permisorol_permiso` FOREIGN KEY (`fk_id_permiso`) REFERENCES `permiso` (`id_permiso`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_permisorol_rol` FOREIGN KEY (`fk_id_rol`) REFERENCES `rol` (`id_rol`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=252 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Volcando datos para la tabla db_invehin.permisorol: ~24 rows (aproximadamente)
INSERT INTO `permisorol` (`id_permisorol`, `estado_permisorol`, `fk_id_permiso`, `fk_id_rol`) VALUES
	(150, 1, 1, 1),
	(151, 1, 4, 1),
	(152, 1, 11, 1),
	(153, 1, 9, 1),
	(154, 1, 8, 1),
	(155, 1, 10, 1),
	(156, 1, 5, 1),
	(157, 1, 3, 1),
	(158, 1, 7, 1),
	(159, 1, 28, 1),
	(160, 1, 19, 1),
	(161, 1, 21, 1),
	(162, 1, 27, 1),
	(163, 1, 25, 1),
	(164, 1, 24, 1),
	(165, 1, 26, 1),
	(166, 1, 22, 1),
	(167, 1, 20, 1),
	(168, 1, 23, 1),
	(169, 1, 29, 1),
	(170, 1, 31, 1),
	(171, 1, 32, 1),
	(172, 1, 30, 1),
	(173, 1, 37, 1),
	(174, 1, 2, 1),
	(175, 1, 13, 1),
	(176, 1, 18, 1),
	(177, 1, 16, 1),
	(178, 1, 15, 1),
	(179, 1, 17, 1),
	(180, 1, 14, 1),
	(181, 1, 12, 1),
	(182, 1, 6, 1),
	(183, 1, 36, 1),
	(184, 1, 34, 1),
	(185, 1, 35, 1),
	(186, 1, 33, 1),
	(187, 1, 1, 3),
	(188, 1, 4, 3),
	(189, 1, 11, 3),
	(190, 1, 9, 3),
	(191, 1, 8, 3),
	(192, 1, 10, 3),
	(193, 1, 3, 3),
	(194, 1, 7, 3),
	(195, 1, 28, 3),
	(196, 1, 19, 3),
	(197, 1, 21, 3),
	(198, 1, 27, 3),
	(199, 1, 25, 3),
	(200, 1, 24, 3),
	(201, 1, 26, 3),
	(202, 1, 23, 3),
	(203, 1, 29, 3),
	(204, 1, 31, 3),
	(205, 1, 32, 3),
	(206, 1, 37, 3),
	(207, 1, 2, 3),
	(208, 1, 13, 3),
	(209, 1, 18, 3),
	(210, 1, 16, 3),
	(211, 1, 15, 3),
	(212, 1, 17, 3),
	(213, 1, 6, 3),
	(214, 1, 36, 3),
	(215, 1, 34, 3),
	(216, 1, 35, 3),
	(217, 1, 33, 3),
	(218, 1, 4, 4),
	(219, 1, 7, 4),
	(220, 1, 21, 4),
	(221, 1, 23, 4),
	(222, 1, 29, 4),
	(223, 1, 37, 4),
	(224, 1, 6, 4),
	(225, 1, 1, 5),
	(226, 1, 11, 5),
	(227, 1, 9, 5),
	(228, 1, 8, 5),
	(229, 1, 10, 5),
	(230, 1, 7, 5),
	(231, 1, 37, 5),
	(232, 1, 36, 5),
	(233, 1, 34, 5),
	(234, 1, 35, 5),
	(235, 1, 33, 5),
	(236, 1, 1, 7),
	(237, 1, 4, 7),
	(238, 1, 11, 7),
	(239, 1, 9, 7),
	(240, 1, 8, 7),
	(241, 1, 10, 7),
	(242, 1, 3, 7),
	(243, 1, 7, 7),
	(244, 1, 6, 7),
	(245, 1, 36, 7),
	(246, 1, 34, 7),
	(247, 1, 35, 7),
	(248, 1, 33, 7);

-- Volcando estructura para tabla db_invehin.persona
CREATE TABLE IF NOT EXISTS `persona` (
  `id_persona` int NOT NULL AUTO_INCREMENT,
  `nombres_persona` varchar(100) NOT NULL,
  `apellidos_persona` varchar(100) NOT NULL,
  `numeroidentificacion_persona` varchar(15) DEFAULT NULL,
  `telefono_persona` varchar(15) NOT NULL,
  `genero_persona` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id_persona`),
  UNIQUE KEY `id_persona_UNIQUE` (`id_persona`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Volcando datos para la tabla db_invehin.persona: ~19 rows (aproximadamente)
INSERT INTO `persona` (`id_persona`, `nombres_persona`, `apellidos_persona`, `numeroidentificacion_persona`, `telefono_persona`, `genero_persona`) VALUES
	(1, 'Laura', 'Gómez', NULL, '3111111111', NULL),
	(2, 'Diego', 'Ramírez', '1010101011', '3112222222', 1),
	(3, 'Camila', 'Sánchez', '1010101012', '3113333333', 0),
	(4, 'Andrés', 'Torres', '1010101013', '3114444444', 1),
	(5, 'Natalia', 'Fernández', '1010101014', '3115555555', 0),
	(6, 'Juan', 'Pérez', '1010101015', '3116666666', 1),
	(7, 'Valentina', 'Rojas', '1010101016', '3117777777', 0),
	(8, 'Carlos', 'Morales', '1010101017', '3118888888', 1),
	(9, 'Sofía', 'Castillo', '1010101018', '3119999999', 0),
	(10, 'Miguel', 'Herrera', '1010101019', '3120000000', 1),
	(11, 'Isabela', 'Mendoza', '1010101020', '3121111111', 2),
	(12, 'Sebastián', 'Vargas', '1010101021', '3122222222', 1),
	(13, 'Alejandra', 'Moreno', '1010101022', '3123333334', 0),
	(14, 'Jorge', 'Soto', '1010101023', '3124444444', 1),
	(15, 'María', 'Castro', '1010101024', '3125555555', 2),
	(17, 'Sebastian', 'Sierra', '1234567890', '+57 3112929178', 1),
	(18, 'Elias', 'Sierra', '1006506524', '3152919218', 1),
	(19, 'Fernanda', 'Vargas', '1002603659', '3152926356', 0),
	(20, 'Sebastian', 'Sierra', NULL, '3112929178', 1),
	(21, 'Fabian', 'Garcia', '12131515', '312569486', 1),
	(22, 'Fabian', 'Castro', '15555255', '3254805555', 1),
	(23, 'Juanito', 'Perez', '1500003', '3112659584', 1),
	(24, 'Johana', 'Sanchez', '1231350', '3154654556', 0),
	(28, 'a', 'a', NULL, 'bb', NULL),
	(32, 'Sebastián', 'Sierra', '123456789', '+57 3112929178', 1);

-- Volcando estructura para tabla db_invehin.prenda
CREATE TABLE IF NOT EXISTS `prenda` (
  `codigo_prenda` varchar(50) NOT NULL,
  `stock_prenda` int NOT NULL,
  `stockminimo_prenda` int NOT NULL,
  `fk_id_color` int DEFAULT NULL,
  `fk_id_estadoprenda` int DEFAULT '1',
  `fk_id_subcategoria` int DEFAULT NULL,
  `fk_id_talla` int DEFAULT NULL,
  PRIMARY KEY (`codigo_prenda`),
  UNIQUE KEY `codigo_prenda` (`codigo_prenda`),
  KEY `fk_prenda_color_idx` (`fk_id_color`),
  KEY `fk_prenda_subcategoria_idx` (`fk_id_subcategoria`),
  KEY `fk_prenda_talla_idx` (`fk_id_talla`),
  KEY `fk_prenda_estadoprenda_idx` (`fk_id_estadoprenda`),
  CONSTRAINT `fk_prenda_color` FOREIGN KEY (`fk_id_color`) REFERENCES `color` (`id_color`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_prenda_estadoprenda` FOREIGN KEY (`fk_id_estadoprenda`) REFERENCES `estadoprenda` (`id_estadoprenda`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_prenda_subcategoria` FOREIGN KEY (`fk_id_subcategoria`) REFERENCES `subcategoria` (`id_subcategoria`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_prenda_talla` FOREIGN KEY (`fk_id_talla`) REFERENCES `talla` (`id_talla`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Volcando datos para la tabla db_invehin.prenda: ~55 rows (aproximadamente)
INSERT INTO `prenda` (`codigo_prenda`, `stock_prenda`, `stockminimo_prenda`, `fk_id_color`, `fk_id_estadoprenda`, `fk_id_subcategoria`, `fk_id_talla`) VALUES
	('CM001', 36, 7, 8, 1, 21, 5),
	('FM001', 48, 10, 7, 1, 13, 1),
	('PR001', 5, 10, 1, 1, 1, 1),
	('PR002', 229, 10, 2, 1, 2, 2),
	('PR003', 71, 5, 3, 2, 3, 3),
	('PR004', 32, 5, 4, 1, 4, 4),
	('PR005', 125, 15, 5, 1, 5, 5),
	('PR006', 47, 5, 1, 1, 1, 1),
	('PR007', 57, 5, 2, 1, 2, 2),
	('PR008', 53, 5, 3, 2, 3, 3),
	('PR009', 88, 5, 4, 1, 4, 4),
	('PR010', 16, 15, 5, 3, 5, 5),
	('PR011', 35, 10, 1, 1, 1, 1),
	('PR012', 65, 15, 2, 1, 2, 2),
	('PR013', 45, 12, 3, 1, 3, 3),
	('PR014', 28, 10, 4, 1, 4, 4),
	('PR015', 150, 20, 5, 1, 5, 5),
	('PR016', 90, 25, 1, 1, 6, 1),
	('PR017', 120, 30, 2, 2, 7, 2),
	('PR018', 110, 25, 3, 2, 8, 3),
	('PR019', 80, 20, 4, 1, 9, 4),
	('PR020', 95, 18, 5, 1, 10, 5),
	('PR021', 65, 12, 1, 1, 11, 1),
	('PR022', 75, 15, 2, 1, 12, 2),
	('PR023', 105, 20, 3, 2, 13, 3),
	('PR024', 55, 10, 4, 1, 14, 4),
	('PR025', 95, 25, 5, 1, 15, 5),
	('PR026', 50, 15, 1, 2, 16, 1),
	('PR027', 60, 18, 2, 2, 17, 2),
	('PR028', 70, 20, 3, 2, 18, 3),
	('PR029', 50, 12, 4, 2, 19, 4),
	('PR030', 120, 28, 5, 1, 20, 5),
	('PR031', 55, 10, 1, 2, 21, 1),
	('PR032', 65, 15, 2, 1, 22, 2),
	('PR033', 75, 20, 3, 2, 23, 3),
	('PR034', 100, 25, 4, 1, 24, 4),
	('PR035', 90, 22, 5, 1, 25, 5),
	('PR036', 110, 30, 1, 1, 26, 1),
	('PR037', 120, 25, 2, 1, 27, 2),
	('PR038', 80, 18, 3, 2, 28, 3),
	('PR039', 55, 12, 4, 1, 29, 4),
	('PR040', 70, 15, 5, 2, 30, 5),
	('PR041', 50, 10, 1, 1, 31, 1),
	('PR042', 60, 18, 2, 2, 32, 2),
	('PR043', 40, 12, 3, 1, 33, 3),
	('PR044', 100, 25, 4, 1, 34, 4),
	('PR045', 55, 12, 5, 2, 35, 5),
	('PR046', 75, 20, 1, 1, 36, 1),
	('PR047', 90, 22, 2, 2, 37, 2),
	('PR048', 80, 18, 3, 1, 38, 3),
	('PR049', 110, 30, 4, 2, 39, 4),
	('PR050', 95, 25, 5, 1, 40, 5),
	('SC001', 12, 5, 4, 1, 36, 3),
	('SH001', 5, 5, 1, 1, 27, 2);

-- Volcando estructura para función db_invehin.promedio_venta_por_rango
DELIMITER //
CREATE FUNCTION `promedio_venta_por_rango`(
	`fecha_inicio` DATE,
	`fecha_fin` DATE
) RETURNS double
    DETERMINISTIC
BEGIN

	DECLARE promedio DOUBLE;
	
	SELECT 
        ROUND(AVG(total_dia), 0) INTO promedio
    FROM (
		SELECT 
		   DATE(v.fecha_venta) AS fecha,
		   SUM(dv.cantidad_detalleventa * s.precio_subcategoria) AS total_dia
		FROM
			venta v
		JOIN detalleventa dv ON v.id_venta = dv.fk_id_venta
		JOIN prenda p ON dv.fk_codigo_prenda = p.codigo_prenda
		JOIN subcategoria s ON p.fk_id_subcategoria = s.id_subcategoria
		WHERE
			v.fecha_venta BETWEEN fecha_inicio AND fecha_fin
		GROUP BY
			DATE(v.fecha_venta)
    ) AS subconsulta;

	
	RETURN promedio;

END//
DELIMITER ;

-- Volcando estructura para tabla db_invehin.promocion
CREATE TABLE IF NOT EXISTS `promocion` (
  `id_promocion` int NOT NULL AUTO_INCREMENT,
  `porcentaje_promocion` int NOT NULL,
  `fechainicio_promocion` datetime NOT NULL,
  `fechafin_promocion` datetime NOT NULL,
  `estado_promocion` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id_promocion`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Volcando datos para la tabla db_invehin.promocion: ~5 rows (aproximadamente)
INSERT INTO `promocion` (`id_promocion`, `porcentaje_promocion`, `fechainicio_promocion`, `fechafin_promocion`, `estado_promocion`) VALUES
	(1, 10, '2025-05-01 00:00:00', '2025-05-15 23:59:59', 1),
	(2, 15, '2025-06-01 00:00:00', '2025-06-10 23:59:59', 1),
	(3, 20, '2025-07-01 00:00:00', '2025-07-31 23:59:59', 1),
	(4, 25, '2025-08-01 00:00:00', '2025-08-15 23:59:59', 0),
	(5, 30, '2025-09-01 00:00:00', '2025-09-30 23:59:59', 1);

-- Volcando estructura para tabla db_invehin.proveedor
CREATE TABLE IF NOT EXISTS `proveedor` (
  `id_proveedor` int NOT NULL AUTO_INCREMENT,
  `nombre_proveedor` varchar(100) NOT NULL,
  `direccion_proveedor` varchar(150) NOT NULL,
  `correo_proveedor` varchar(150) NOT NULL,
  `estado_proveedor` tinyint NOT NULL DEFAULT '1',
  `fk_id_persona` int NOT NULL,
  PRIMARY KEY (`id_proveedor`),
  KEY `fk_proveedor_persona_idx` (`fk_id_persona`),
  CONSTRAINT `fk_proveedor_persona` FOREIGN KEY (`fk_id_persona`) REFERENCES `persona` (`id_persona`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Volcando datos para la tabla db_invehin.proveedor: ~10 rows (aproximadamente)
INSERT INTO `proveedor` (`id_proveedor`, `nombre_proveedor`, `direccion_proveedor`, `correo_proveedor`, `estado_proveedor`, `fk_id_persona`) VALUES
	(1, 'Koaj', 'Calle 1 #100', 'proveedorA@example.com', 1, 1),
	(2, 'Proveedor B', 'Calle 2 #200', 'proveedorB@example.com', 1, 2),
	(3, 'Proveedor C', 'Calle 3 #300', 'proveedorC@example.com', 1, 3),
	(4, 'Proveedor D', 'Calle 4 #400', 'proveedorD@example.com', 1, 4),
	(5, 'Proveedor E', 'Calle 5 #500', 'proveedorE@example.com', 1, 5),
	(6, 'Proveedor A', 'Calle 1 #100', 'proveedorA@example.com', 1, 1),
	(7, 'Proveedor B', 'Calle 2 #200', 'proveedorB@example.com', 0, 2),
	(8, 'Proveedor C', 'Calle 3 #300', 'proveedorC@example.com', 1, 3),
	(9, 'Proveedor D', 'Calle 4 #400', 'proveedorD@example.com', 1, 4),
	(10, 'Proveedor E', 'Calle 5 #500', 'proveedorE@example.com', 1, 5),
	(11, 'Todo Prendas', 'Las avenidas', 'todoprendas@gmail.com', 1, 20);

-- Volcando estructura para procedimiento db_invehin.reporte_inventarios
DELIMITER //
CREATE PROCEDURE `reporte_inventarios`(
	IN `fecha_inicio` DATE,
	IN `fecha_fin` DATE,
	IN `estado` TINYINT
)
BEGIN
	
	START TRANSACTION;
	
	-- inventarios
	SELECT
		i.id_inventario AS id,
		i.fecha_inventario AS fecha,
		i.observacion_inventario AS observacion,
		i.estado_inventario AS estado,
		i.fk_id_usuario AS usuario_id,
		CONCAT(p.nombres_persona, ' ', p.apellidos_persona) AS usuario_nombre
	FROM
		inventario i
	INNER JOIN usuario u ON i.fk_id_usuario = u.id_usuario
	INNER JOIN persona p ON u.fk_id_persona = p.id_persona
	WHERE
		i.fecha_inventario BETWEEN fecha_inicio AND fecha_fin
		AND (estado IS NULL OR i.estado_inventario = estado)
	ORDER BY
		i.fecha_inventario DESC,
		p.nombres_persona ASC,
		p.apellidos_persona ASC;
	
   COMMIT;
    
END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.reporte_pedidos
DELIMITER //
CREATE PROCEDURE `reporte_pedidos`(
	IN `fecha_inicio` DATE,
	IN `fecha_fin` DATE,
	IN `proveedor_id` INT,
	IN `estado` TINYINT
)
BEGIN
	
	START TRANSACTION;
	
	-- pedidos
	SELECT
		vp.id,
		vp.fecha,
		vp.proveedor_id,
		vp.proveedor_nombre,
		calcular_total_pedido(vp.id) AS precio_total,
		(
	  		SELECT 
				SUM(dp.cantidad_detallepedido)
			FROM 
				detallepedido dp
			WHERE 
				dp.fk_id_pedido = vp.id
		) AS cantidad,
		vp.estado
	FROM
		view_pedido vp
	WHERE
		vp.fecha BETWEEN fecha_inicio AND fecha_fin
		AND (proveedor_id IS NULL OR vp.proveedor_id = proveedor_id)
		AND (estado IS NULL OR vp.estado = estado)
	ORDER BY
		vp.fecha DESC;
	
   COMMIT;
    
END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.reporte_prendas
DELIMITER //
CREATE PROCEDURE `reporte_prendas`(
	IN `categoria_id` INT,
	IN `talla_id` INT,
	IN `stock_bajo` TINYINT
)
BEGIN

	SELECT
		vp.codigo,
		vp.stock,
		vp.stock_minimo,
		vp.color_id,
		vp.color_nombre,
		vp.talla_id,
		vp.talla_nombre,
		vp.estadoprenda_id,
		vp.estadoprenda_nombre,
		vp.subcategoria_id,
		vp.subcategoria_nombre,
		vp.subcategoria_precio,
		vp.subcategoria_imagen,
		vp.subcategoria_estado,
		vp.categoria_id,
		vp.categoria_nombre,
		vp.promocion_id,
		vp.promocion_porcentaje,
		vp.promocion_fechainicio,
		vp.promocion_fechafin
	FROM
		view_prenda vp
	WHERE
		vp.categoria_estado = 1
		AND vp.subcategoria_estado = 1
		AND vp.estadoprenda_id != 3
		AND (categoria_id IS NULL OR vp.categoria_id = categoria_id)
		AND (talla_id IS NULL OR vp.talla_id = talla_id)
		AND (stock_bajo IS NULL OR stock_bajo = 0 OR vp.stock < vp.stock_minimo)
	ORDER BY
		vp.categoria_nombre ASC,
		vp.subcategoria_nombre ASC,
		vp.talla_nombre ASC,
		vp.color_nombre ASC,
		vp.codigo ASC;
		
END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.reporte_ventas
DELIMITER //
CREATE PROCEDURE `reporte_ventas`(
	IN `fecha_inicio` DATE,
	IN `fecha_fin` DATE
)
BEGIN
	
	START TRANSACTION;
	
	-- ventas
	SELECT
		vv.id,
		vv.fecha,
		vv.monto_recibido,
		vv.estado,
		vv.metodopago_id,
		vv.metodopago_nombre,
		vv.metodopago_estado,
		vv.cliente_id,
		vv.persona_id,
		vv.persona_nombres,
		vv.persona_apellidos,
		vv.persona_numero_identificacion,
		vv.persona_telefono,
		vv.persona_genero,
		vv.cliente_direccion,
		vv.cliente_estado,
		vv.usuario_id,
		(
	  		SELECT 
				SUM(dv.cantidad_detalleventa * sc.precio_subcategoria)
			FROM 
				detalleventa dv
			JOIN prenda p ON dv.fk_codigo_prenda = p.codigo_prenda
			JOIN subcategoria sc ON p.fk_id_subcategoria = sc.id_subcategoria
			WHERE 
				dv.fk_id_venta = vv.id
		) AS precio_total,
		(
	  		SELECT 
				COUNT(dv.id_detalleventa)
			FROM 
				detalleventa dv
			WHERE 
				dv.fk_id_venta = vv.id
		) AS cantidad
	FROM
		view_venta vv
	WHERE
		vv.fecha BETWEEN fecha_inicio AND fecha_fin
	ORDER BY
		vv.fecha DESC;
	
   COMMIT;
    
END//
DELIMITER ;

-- Volcando estructura para tabla db_invehin.rol
CREATE TABLE IF NOT EXISTS `rol` (
  `id_rol` int NOT NULL AUTO_INCREMENT,
  `nombre_rol` varchar(50) NOT NULL,
  `estado_rol` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id_rol`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Volcando datos para la tabla db_invehin.rol: ~6 rows (aproximadamente)
INSERT INTO `rol` (`id_rol`, `nombre_rol`, `estado_rol`) VALUES
	(1, 'SuperAdmin', 1),
	(2, 'Invitado', 1),
	(3, 'Administrador', 1),
	(4, 'Empleado', 1),
	(5, 'Contador', 1),
	(7, 'Invitado', 1);

-- Volcando estructura para procedimiento db_invehin.select_categorias
DELIMITER //
CREATE PROCEDURE `select_categorias`(
	IN `search_term` VARCHAR(50),
	IN `num_page` INT,
	IN `page_size` INT
)
BEGIN

	DECLARE offset_value INT;
	SET offset_value = (num_page - 1) * page_size;
	
	START TRANSACTION;
	
	-- tabla temporal de categorias
	CREATE TEMPORARY TABLE temp_categorias (id INT PRIMARY KEY);
	INSERT INTO temp_categorias (id)
	SELECT
		c.id_categoria AS id
	FROM
		categoria c
	WHERE
		search_term IS NULL OR search_term = ''
		OR c.nombre_categoria LIKE CONCAT('%', search_term, '%')
	ORDER BY
		c.nombre_categoria ASC
	LIMIT page_size OFFSET offset_value;
	
	-- categorias
	SELECT
		c.id_categoria AS id,
		c.nombre_categoria AS nombre,
		c.estado_categoria AS estado
	FROM
		categoria c
	WHERE
		c.id_categoria IN (SELECT tc.id FROM temp_categorias tc)
	ORDER BY
		c.nombre_categoria ASC;
	
	-- total categorias
	SELECT
		COUNT(c.id_categoria) AS total_entries
	FROM
		categoria c
	WHERE
		search_term IS NULL OR search_term = ''
		OR c.nombre_categoria LIKE CONCAT('%', search_term, '%');
	
	-- subcategorias
	SELECT
		s.id_subcategoria AS id,
		s.nombre_subcategoria AS nombre,
		s.precio_subcategoria AS precio,
		s.imagen_subcategoria AS imagen,
		s.estado_subcategoria AS estado,
		s.fk_id_categoria AS categoria_id
	FROM
		subcategoria s
	WHERE
		s.fk_id_categoria IN (SELECT tc.id FROM temp_categorias tc)
	ORDER BY
		s.fk_id_categoria ASC,
		s.nombre_subcategoria ASC;
	
   DROP TEMPORARY TABLE IF EXISTS temp_categorias;
    
   COMMIT;
	
END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.select_categorias_estaticas
DELIMITER //
CREATE PROCEDURE `select_categorias_estaticas`()
BEGIN

	SELECT
		c.id_categoria AS id,
		c.nombre_categoria AS nombre,
		c.estado_categoria AS estado
	FROM
		categoria c
	ORDER BY
		c.nombre_categoria ASC;
	
	-- subcategorias
	SELECT
		s.id_subcategoria AS subcategoria_id,
		s.nombre_subcategoria AS subcategoria_nombre,
		s.precio_subcategoria AS subcategoria_precio,
		s.imagen_subcategoria AS subcategoria_imagen,
		s.estado_subcategoria AS subcategoria_estado,
		s.fk_id_categoria AS categoria_id
	FROM
		subcategoria s
	INNER JOIN categoria c ON s.fk_id_categoria = c.id_categoria
	WHERE
		c.estado_categoria = 1
	ORDER BY
		c.nombre_categoria ASC;

END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.select_categoria_by_id
DELIMITER //
CREATE PROCEDURE `select_categoria_by_id`(
	IN `id` INT
)
BEGIN
	
	SELECT
		c.id_categoria AS id,
		c.nombre_categoria AS nombre
	FROM
		categoria c
	WHERE
		c.estado_categoria = 1
		AND c.id_categoria = id
	LIMIT 1;
	
END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.select_clientes
DELIMITER //
CREATE PROCEDURE `select_clientes`(
	IN `search_term` VARCHAR(50),
	IN `num_page` INT,
	IN `page_size` INT
)
BEGIN
	
	DECLARE offset_value INT;
	SET offset_value = (num_page - 1) * page_size;
	
	-- clientes
	SELECT
		vc.id,
		vc.fecha_registro,
		vc.direccion,
		vc.estado,
		vc.persona_id,
		vc.nombres,
		vc.apellidos,
		vc.numero_identificacion,
		vc.telefono,
		vc.genero
	FROM
		view_cliente vc
	WHERE
		vc.estado = 1
		AND (search_term IS NULL OR search_term = ''
		OR vc.nombres LIKE CONCAT('%', search_term, '%')
		OR vc.apellidos LIKE CONCAT('%', search_term, '%')
		OR vc.numero_identificacion LIKE CONCAT('%', search_term, '%')
		OR vc.telefono LIKE CONCAT('%', search_term, '%')
		OR vc.direccion LIKE CONCAT('%', search_term, '%')
		OR vc.fecha_registro LIKE CONCAT('%', search_term, '%'))
	ORDER BY
		vc.nombres ASC,
		vc.apellidos ASC,
		vc.numero_identificacion ASC,
		vc.estado DESC
	LIMIT page_size OFFSET offset_value;
	
	-- totalclientes
	SELECT
		COUNT(vc.id) AS total_entries
	FROM
		view_cliente vc
	WHERE
		vc.estado = 1
		AND (search_term IS NULL OR search_term = ''
		OR vc.nombres LIKE CONCAT('%', search_term, '%')
		OR vc.apellidos LIKE CONCAT('%', search_term, '%')
		OR vc.numero_identificacion LIKE CONCAT('%', search_term, '%')
		OR vc.telefono LIKE CONCAT('%', search_term, '%')
		OR vc.direccion LIKE CONCAT('%', search_term, '%'));
	
END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.select_clientes_by_search_term
DELIMITER //
CREATE PROCEDURE `select_clientes_by_search_term`(
	IN `search_term` VARCHAR(50)
)
BEGIN
	
	SELECT
		vc.id,
		vc.fecha_registro,
		vc.direccion,
		vc.estado,
		vc.persona_id,
		vc.nombres,
		vc.apellidos,
		vc.numero_identificacion,
		vc.telefono,
		vc.genero
	FROM
		view_cliente vc
	WHERE
		vc.estado = 1
		AND (search_term IS NULL OR search_term = ''
		OR vc.numero_identificacion LIKE CONCAT('%', search_term, '%')
		OR vc.nombres LIKE CONCAT('%', search_term, '%')
		OR vc.apellidos LIKE CONCAT('%', search_term, '%'));
	
END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.select_cliente_by_id
DELIMITER //
CREATE PROCEDURE `select_cliente_by_id`(
	IN `id` INT
)
BEGIN

	SELECT
		vc.id,
		vc.fecha_registro,
		vc.direccion,
		vc.estado,
		vc.persona_id,
		vc.nombres,
		vc.apellidos,
		vc.numero_identificacion,
		vc.telefono,
		vc.genero
	FROM
		view_cliente vc
	WHERE
		vc.id = id
	LIMIT 1;

END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.select_colores
DELIMITER //
CREATE PROCEDURE `select_colores`()
BEGIN

	SELECT
		c.id_color AS id,
		c.nombre_color AS nombre
	FROM
		color c
	ORDER BY
		c.nombre_color ASC;
	
END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.select_color_by_id
DELIMITER //
CREATE PROCEDURE `select_color_by_id`(
	IN `id` INT
)
BEGIN

	SELECT
		c.id_color AS id,
		c.nombre_color AS nombre
	FROM
		color c
	WHERE
		c.id_color = id
	LIMIT 1;

END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.select_detalleinventario_by_inventario
DELIMITER //
CREATE PROCEDURE `select_detalleinventario_by_inventario`(
	IN `inventario_id` INT
)
BEGIN

	SELECT
		di.id_detalleinventario AS id,
		di.observacion_detalleinventario AS observacion,
		di.cantidadregistrada_detalleinventario AS cantidad_registrada,
		di.cantidadsistema_detalleinventario AS cantidad_sistema,
		di.fk_id_inventario AS inventario_id,
		vp.codigo,
		vp.stock,
		vp.stock_minimo,
		vp.color_id,
		vp.color_nombre,
		vp.talla_id,
		vp.talla_nombre,
		vp.estadoprenda_id,
		vp.estadoprenda_nombre,
		vp.subcategoria_id,
		vp.subcategoria_nombre,
		vp.subcategoria_precio,
		vp.subcategoria_imagen,
		vp.categoria_id,
		vp.categoria_nombre,
		vp.promocion_id,
		vp.promocion_porcentaje,
		vp.promocion_fechainicio,
		vp.promocion_fechafin
	FROM
		detalleinventario di
	INNER JOIN view_prenda vp ON di.fk_codigo_prenda = vp.codigo
	WHERE
		di.fk_id_inventario = inventario_id
	ORDER BY
		vp.categoria_nombre ASC,
		vp.subcategoria_nombre ASC,
		vp.talla_nombre ASC,
		vp.color_nombre ASC;

END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.select_detallepedido_by_pedido
DELIMITER //
CREATE PROCEDURE `select_detallepedido_by_pedido`(
	IN `pedido_id` INT
)
BEGIN

	SELECT
		dp.id_detallepedido AS id,
		dp.cantidad_detallepedido AS cantidad,
		dp.costounitario_detallepedido AS consto_unitario,
		dp.fk_id_pedido AS pedido_id,
		vp.codigo,
		vp.stock,
		vp.stock_minimo,
		vp.color_id,
		vp.color_nombre,
		vp.talla_id,
		vp.talla_nombre,
		vp.estadoprenda_id,
		vp.estadoprenda_nombre,
		vp.subcategoria_id,
		vp.subcategoria_nombre,
		vp.subcategoria_precio,
		vp.subcategoria_imagen,
		vp.categoria_id,
		vp.categoria_nombre,
		vp.promocion_id,
		vp.promocion_porcentaje,
		vp.promocion_fechainicio,
		vp.promocion_fechafin
	FROM
		detallepedido dp
	INNER JOIN view_prenda vp ON dp.fk_codigo_prenda = vp.codigo
	WHERE
		dp.fk_id_pedido = pedido_id
	ORDER BY
		vp.categoria_nombre ASC,
		vp.subcategoria_nombre ASC,
		vp.talla_nombre ASC,
		vp.color_nombre ASC;

END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.select_detalleventa_by_venta
DELIMITER //
CREATE PROCEDURE `select_detalleventa_by_venta`(
	IN `venta_id` INT
)
BEGIN

	SELECT
		dv.id_detalleventa AS id,
		dv.cantidad_detalleventa AS cantidad,
		dv.cantidad_detalleventa * vp.subcategoria_precio AS subtotal,
		dv.fk_id_venta AS venta_id,
		vp.codigo AS prenda_codigo,
		concat(vp.subcategoria_nombre, ' - ', vp.categoria_nombre) AS prenda_nombre,
		vp.color_nombre AS prenda_color,
		vp.talla_nombre AS prenda_talla,
		vp.subcategoria_precio AS prenda_precio,
		vp.promocion_porcentaje AS prenda_promocion_porcentaje
	FROM
		detalleventa dv
	INNER JOIN view_prenda vp ON dv.fk_codigo_prenda = vp.codigo
	WHERE
		dv.fk_id_venta = venta_id;

END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.select_estadoprenda_by_id
DELIMITER //
CREATE PROCEDURE `select_estadoprenda_by_id`(
	IN `id` INT
)
BEGIN

	SELECT
		e.id_estadoprenda AS id,
		e.nombre_estadoprenda AS nombre
	FROM
		estadoprenda e
	WHERE
		e.id_estadoprenda = id
	LIMIT 1;
		
END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.select_estadosprenda
DELIMITER //
CREATE PROCEDURE `select_estadosprenda`()
BEGIN

	SELECT
		e.id_estadoprenda AS id,
		e.nombre_estadoprenda AS nombre
	FROM
		estadoprenda e
	WHERE
		e.id_estadoprenda!= 3
	ORDER BY
		e.id_estadoprenda ASC;

END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.select_inventarios
DELIMITER //
CREATE PROCEDURE `select_inventarios`(
	IN `search_term` VARCHAR(50),
	IN `num_page` INT,
	IN `page_size` INT
)
BEGIN

	DECLARE offset_value INT;
	SET offset_value = (num_page - 1) * page_size;
	
	START TRANSACTION;
	
	-- tabla temporal de inventarios
	CREATE TEMPORARY TABLE temp_inventarios (id INT PRIMARY KEY);
	INSERT INTO temp_inventarios (id)
	SELECT
		i.id_inventario AS id
	FROM
		inventario i
	INNER JOIN usuario u ON i.fk_id_usuario = u.id_usuario
	INNER JOIN persona p ON u.fk_id_persona = p.id_persona
	WHERE
		search_term IS NULL OR search_term = ''
		OR i.fecha_inventario LIKE CONCAT('%', search_term, '%')
		OR i.observacion_inventario LIKE CONCAT('%', search_term, '%')
		OR p.nombres_persona LIKE CONCAT('%', search_term, '%')
		OR p.apellidos_persona LIKE CONCAT('%', search_term, '%')
	ORDER BY
		i.fecha_inventario DESC
	LIMIT page_size OFFSET offset_value;
	
	-- inventarios
	SELECT
		i.id_inventario AS id,
		i.fecha_inventario AS fecha,
		i.observacion_inventario AS observacion,
		i.estado_inventario AS estado,
		i.fk_id_usuario AS usuario_id,
		CONCAT(p.nombres_persona, ' ', p.apellidos_persona) AS usuario_nombre
	FROM
		inventario i
	INNER JOIN usuario u ON i.fk_id_usuario = u.id_usuario
	INNER JOIN persona p ON u.fk_id_persona = p.id_persona
	WHERE
		i.id_inventario IN (SELECT ti.id FROM temp_inventarios ti)
	ORDER BY
		i.fecha_inventario DESC,
		p.nombres_persona ASC,
		p.apellidos_persona ASC,
		i.observacion_inventario ASC;

	-- total inventarios
	SELECT
		COUNT(i.id_inventario) AS total_entries
	FROM
		inventario i
	INNER JOIN usuario u ON i.fk_id_usuario = u.id_usuario
	INNER JOIN persona p ON u.fk_id_persona = p.id_persona
	WHERE
		search_term IS NULL OR search_term = ''
		OR i.fecha_inventario LIKE CONCAT('%', search_term, '%')
		OR i.observacion_inventario LIKE CONCAT('%', search_term, '%')
		OR p.nombres_persona LIKE CONCAT('%', search_term, '%')
		OR p.apellidos_persona LIKE CONCAT('%', search_term, '%');
	
	-- detallesinventario
	SELECT
		di.id_detalleinventario AS id,
		di.observacion_detalleinventario AS observacion,
		di.cantidadregistrada_detalleinventario AS cantidad_registrada,
		di.cantidadsistema_detalleinventario AS cantidad_sistema,
		di.fk_id_inventario AS inventario_id,
		di.fk_codigo_prenda AS prenda_codigo,
		CONCAT(c.nombre_categoria, ' - ', s.nombre_subcategoria, ' - Talla ', t.nombre_talla, ' · ', co.nombre_color) AS prenda_nombre
	FROM
		detalleinventario di
	INNER JOIN inventario i ON di.fk_id_inventario = i.id_inventario
	INNER JOIN prenda p ON di.fk_codigo_prenda = p.codigo_prenda
	INNER JOIN subcategoria s ON p.fk_id_subcategoria = s.id_subcategoria
	INNER JOIN categoria c ON s.fk_id_categoria = c.id_categoria
	INNER JOIN color co ON p.fk_id_color = co.id_color
	INNER JOIN talla t ON p.fk_id_talla = t.id_talla
	WHERE
		di.fk_id_inventario IN (SELECT ti.id FROM temp_inventarios ti)
	ORDER BY
		i.fecha_inventario DESC;
	
	-- Eliminar la tabla temporal
    DROP TEMPORARY TABLE IF EXISTS temp_inventarios;
    
    COMMIT;
    
END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.select_inventario_by_id
DELIMITER //
CREATE PROCEDURE `select_inventario_by_id`(
	IN `id` INT
)
BEGIN
	
	SELECT
		i.id_inventario AS id,
		i.fecha_inventario AS fecha,
		i.observacion_inventario AS observacion,
		i.fk_id_usuario AS usuario_id
	FROM
		inventario i
	WHERE
		i.id_inventario = id
	LIMIT 1;
	
END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.select_metodopago_by_id
DELIMITER //
CREATE PROCEDURE `select_metodopago_by_id`(
	IN `id` INT
)
BEGIN

	SELECT
		mp.id_metodopago AS id,
		mp.nombre_metodopago AS nombre,
		mp.estado_metodopago AS estado
	FROM
		metodopago mp
	WHERE
		mp.id_metodopago = id
	LIMIT 1;

END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.select_metodospago
DELIMITER //
CREATE PROCEDURE `select_metodospago`()
BEGIN

	SELECT
		mp.id_metodopago AS id,
		mp.nombre_metodopago AS nombre,
		mp.estado_metodopago AS estado
	FROM
		metodopago mp
	ORDER BY
		mp.nombre_metodopago ASC;

END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.select_pedidos
DELIMITER //
CREATE PROCEDURE `select_pedidos`(
	IN `search_term` VARCHAR(50),
	IN `num_page` INT,
	IN `page_size` INT
)
BEGIN

	DECLARE offset_value INT;
	SET offset_value = (num_page - 1) * page_size;
	
	START TRANSACTION;
	
	-- tabla temporal de pedidos
	CREATE TEMPORARY TABLE temp_pedidos (id INT PRIMARY KEY);
	INSERT INTO temp_pedidos (id)
	SELECT
		vp.id
	FROM
		view_pedido vp
	WHERE
		search_term IS NULL OR search_term = ''
		OR vp.fecha LIKE CONCAT('%', search_term, '%')
		OR vp.proveedor_nombre LIKE CONCAT('%', search_term, '%')
	ORDER BY
		vp.fecha DESC
	LIMIT page_size OFFSET offset_value;
	
	-- pedidos
	SELECT
		vp.id,
		vp.fecha,
		vp.estado,
		vp.proveedor_id,
		vp.proveedor_nombre,
		calcular_total_pedido(vp.id) AS precio_total,
		(
	  		SELECT 
				SUM(dp.cantidad_detallepedido)
			FROM 
				detallepedido dp
			WHERE 
				dp.fk_id_pedido = vp.id
		) AS cantidad
	FROM
		view_pedido vp
	WHERE
		vp.id IN (SELECT tp.id FROM temp_pedidos tp)
	ORDER BY
		vp.fecha DESC,
		vp.proveedor_nombre ASC;

	-- total pedidos
	SELECT
		COUNT(vp.id) AS total_entries
	FROM
		view_pedido vp
	WHERE
		search_term IS NULL OR search_term = ''
		OR vp.fecha LIKE CONCAT('%', search_term, '%')
		OR vp.proveedor_nombre LIKE CONCAT('%', search_term, '%');
	
	-- detallespedido
	SELECT
		dp.id_detallepedido AS id,
		dp.cantidad_detallepedido AS cantidad,
		dp.costounitario_detallepedido AS costo_unitario,
		dp.cantidad_detallepedido * dp.costounitario_detallepedido AS subtotal,
		dp.fk_codigo_prenda AS prenda_codigo,
		CONCAT(c.nombre_categoria, ' - ', s.nombre_subcategoria) AS prenda_nombre,
		co.nombre_color AS prenda_color,
		t.nombre_talla AS prenda_talla,
		s.precio_subcategoria AS prenda_precio,
		dp.fk_id_pedido AS pedido_id
	FROM
		detallepedido dp
	INNER JOIN prenda p ON dp.fk_codigo_prenda = p.codigo_prenda
	INNER JOIN subcategoria s ON p.fk_id_subcategoria = s.id_subcategoria
	INNER JOIN categoria c ON s.fk_id_categoria = c.id_categoria
	INNER JOIN color co ON p.fk_id_color = co.id_color
	INNER JOIN talla t ON p.fk_id_talla = t.id_talla
	INNER JOIN pedido pe ON dp.fk_id_pedido = pe.id_pedido
	WHERE
		dp.fk_id_pedido IN (SELECT tp.id FROM temp_pedidos tp)
	ORDER BY
		pe.fecha_pedido DESC,
		pe.id_pedido ASC;
	
	-- Eliminar la tabla temporal
    DROP TEMPORARY TABLE IF EXISTS temp_pedidos;
    
    COMMIT;
    
END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.select_pedido_by_id
DELIMITER //
CREATE PROCEDURE `select_pedido_by_id`(
	IN `id` INT
)
BEGIN

	SELECT
		p.id_pedido AS id,
		p.fecha_pedido AS fecha,
		p.estado_pedido AS estado,
		p.fk_id_proveedor AS proveedor_id,
		calcular_total_pedido(id) AS precio_total
	FROM
		pedido p
	WHERE
		p.id_pedido = id
	LIMIT 1;

END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.select_permisos
DELIMITER //
CREATE PROCEDURE `select_permisos`()
BEGIN

	SELECT
		p.id_permiso AS id,
		p.nombre_permiso AS nombre
	FROM
		permiso p
	ORDER BY
		p.nombre_permiso ASC;

END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.select_permisos_by_rol
DELIMITER //
CREATE PROCEDURE `select_permisos_by_rol`(
	IN `rol_id` INT
)
BEGIN

	SELECT
		p.id_permiso AS id,
		p.nombre_permiso AS nombre
	FROM
		permiso p
	INNER JOIN permisorol pr ON p.id_permiso = pr.fk_id_permiso
	WHERE
		pr.fk_id_rol = rol_id
	ORDER BY
		p.nombre_permiso ASC;
	
END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.select_permiso_by_id
DELIMITER //
CREATE PROCEDURE `select_permiso_by_id`(
	IN `id` INT
)
BEGIN
	
	SELECT
		p.id_permiso AS id,
		p.nombre_permiso AS nombre
	FROM
		permiso p
	WHERE
		p.id_permiso = id
	LIMIT 1;
	
END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.select_persona_by_id
DELIMITER //
CREATE PROCEDURE `select_persona_by_id`(
	IN `id` INT
)
BEGIN
	
	SELECT
		p.id_persona AS id,
		p.nombres_persona AS nombres,
		p.apellidos_persona AS apellidos,
		p.numeroidentificacion_persona AS numero_identificacion,
		p.telefono_persona AS telefono,
		p.genero_persona AS genero
	FROM
		persona p
	WHERE
		p.id_persona = id
	LIMIT 1;
	
END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.select_prendas
DELIMITER //
CREATE PROCEDURE `select_prendas`(
	IN `search_term` VARCHAR(50),
	IN `num_page` INT,
	IN `page_size` INT
)
BEGIN
	
	DECLARE offset_value INT;
	SET offset_value = (num_page - 1) * page_size;
	
	-- prendas
	SELECT
		vp.codigo,
		vp.stock,
		vp.stock_minimo,
		vp.color_id,
		vp.color_nombre,
		vp.talla_id,
		vp.talla_nombre,
		vp.estadoprenda_id,
		vp.estadoprenda_nombre,
		vp.subcategoria_id,
		vp.subcategoria_nombre,
		vp.subcategoria_precio,
		vp.subcategoria_imagen,
		vp.subcategoria_estado,
		vp.categoria_id,
		vp.categoria_nombre,
		vp.promocion_id,
		vp.promocion_porcentaje,
		vp.promocion_fechainicio,
		vp.promocion_fechafin
	FROM
		view_prenda vp
	WHERE
		vp.estadoprenda_id != 3
		AND (search_term IS NULL OR search_term = ''
		OR vp.codigo LIKE CONCAT('%', search_term, '%')
		OR vp.color_nombre LIKE CONCAT('%', search_term, '%')
		OR vp.talla_nombre LIKE CONCAT('%', search_term, '%')
		OR vp.estadoprenda_nombre LIKE CONCAT('%', search_term, '%')
		OR vp.subcategoria_nombre LIKE CONCAT('%', search_term, '%')
		OR vp.subcategoria_precio LIKE CONCAT('%', search_term, '%')
		OR vp.categoria_nombre LIKE CONCAT('%', search_term, '%'))
	ORDER BY
		(vp.stock - vp.stock_minimo) ASC,
		vp.categoria_nombre ASC,
		vp.subcategoria_nombre ASC,
		vp.talla_nombre ASC,
		vp.color_nombre ASC,
		vp.codigo ASC
	LIMIT page_size OFFSET offset_value;
	
	-- totalprendas
	SELECT
		COUNT(vp.codigo) AS total_entries
	FROM
		view_prenda vp
	WHERE
		search_term IS NULL OR search_term = ''
		OR vp.codigo LIKE CONCAT('%', search_term, '%')
		OR vp.color_nombre LIKE CONCAT('%', search_term, '%')
		OR vp.talla_nombre LIKE CONCAT('%', search_term, '%')
		OR vp.estadoprenda_nombre LIKE CONCAT('%', search_term, '%')
		OR vp.subcategoria_nombre LIKE CONCAT('%', search_term, '%')
		OR vp.subcategoria_precio LIKE CONCAT('%', search_term, '%')
		OR vp.categoria_nombre LIKE CONCAT('%', search_term, '%');
	
END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.select_prendas_for_venta
DELIMITER //
CREATE PROCEDURE `select_prendas_for_venta`(
	IN `search_term` VARCHAR(50)
)
BEGIN
	
	SELECT
		vp.codigo,
		vp.stock,
		vp.stock_minimo,
		vp.color_id,
		vp.color_nombre,
		vp.talla_id,
		vp.talla_nombre,
		vp.estadoprenda_id,
		vp.estadoprenda_nombre,
		vp.subcategoria_id,
		vp.subcategoria_nombre,
		vp.subcategoria_precio,
		vp.subcategoria_imagen,
		vp.categoria_id,
		vp.categoria_nombre,
		vp.categoria_estado,
		vp.promocion_id,
		vp.promocion_porcentaje,
		vp.promocion_fechainicio,
		vp.promocion_fechafin
	FROM
		view_prenda vp
	WHERE
		vp.categoria_estado = 1
		AND vp.subcategoria_estado = 1
		AND vp.estadoprenda_id = 1
		AND (search_term IS NULL OR search_term = ''
		OR vp.codigo LIKE CONCAT('%', search_term, '%')
		OR vp.color_nombre LIKE CONCAT('%', search_term, '%')
		OR vp.talla_nombre LIKE CONCAT('%', search_term, '%')
		OR vp.estadoprenda_nombre LIKE CONCAT('%', search_term, '%')
		OR vp.subcategoria_nombre LIKE CONCAT('%', search_term, '%')
		OR vp.categoria_nombre LIKE CONCAT('%', search_term, '%'))
	ORDER BY
		(vp.stock - vp.stock_minimo) DESC,
		vp.categoria_nombre ASC,
		vp.subcategoria_nombre ASC,
		vp.talla_nombre ASC,
		vp.color_nombre ASC,
		vp.codigo ASC;
	
END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.select_prenda_by_id
DELIMITER //
CREATE PROCEDURE `select_prenda_by_id`(
	IN `codigo` VARCHAR(50)
)
BEGIN

	SELECT
		vp.codigo,
		vp.stock,
		vp.stock_minimo,
		vp.color_id,
		vp.color_nombre,
		vp.talla_id,
		vp.talla_nombre,
		vp.estadoprenda_id,
		vp.estadoprenda_nombre,
		vp.subcategoria_id,
		vp.subcategoria_nombre,
		vp.subcategoria_precio,
		vp.subcategoria_imagen,
		vp.categoria_id,
		vp.categoria_nombre,
		vp.promocion_id,
		vp.promocion_porcentaje,
		vp.promocion_fechainicio,
		vp.promocion_fechafin
	FROM
		view_prenda vp
	WHERE
		vp.codigo = codigo
	LIMIT 1;

END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.select_promociones
DELIMITER //
CREATE PROCEDURE `select_promociones`()
BEGIN
	
	SELECT
		p.id_promocion AS id,
		p.porcentaje_promocion AS porcentaje,
		p.fechainicio_promocion AS feha_inicio,
		p.fechafin_promocion AS fecha_fin,
		p.estado_promocion AS estado
	FROM
		promocion p
	ORDER BY
		p.fechainicio_promocion DESC,
		p.fechafin_promocion DESC;
	
END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.select_promocion_by_id
DELIMITER //
CREATE PROCEDURE `select_promocion_by_id`(
	IN `id` INT
)
BEGIN
	
	SELECT
		p.id_promocion AS id,
		p.porcentaje_promocion AS porcentaje,
		p.fechainicio_promocion AS feha_inicio,
		p.fechafin_promocion AS fecha_fin,
		p.estado_promocion AS estado
	FROM
		promocion p
	WHERE
		p.id_promocion = id
	LIMIT 1;
		
END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.select_proveedores
DELIMITER //
CREATE PROCEDURE `select_proveedores`(
	IN `search_term` VARCHAR(50),
	IN `num_page` INT,
	IN `page_size` INT
)
BEGIN

	DECLARE offset_value INT;
	SET offset_value = (num_page - 1) * page_size;
	
	-- proveedores
	SELECT
		vp.id,
		vp.nombre,
		vp.correo,
		vp.direccion,
		vp.estado,
		vp.persona_id,
		vp.persona_nombres,
		vp.persona_apellidos,
		vp.persona_telefono
	FROM
		view_proveedor vp
	WHERE
		vp.estado = 1
		AND (search_term IS NULL OR search_term = ''
		OR vp.nombre LIKE CONCAT('%', search_term, '%')
		OR vp.correo LIKE CONCAT('%', search_term, '%')
		OR vp.persona_nombres LIKE CONCAT('%', search_term, '%')
		OR vp.persona_apellidos LIKE CONCAT('%', search_term, '%')
		OR vp.direccion LIKE CONCAT('%', search_term, '%')
		OR vp.persona_telefono LIKE CONCAT('%', search_term, '%'))
	ORDER BY
		vp.nombre ASC,
		vp.correo ASC,
		vp.direccion ASC,
		vp.persona_nombres ASC,
		vp.persona_apellidos ASC
	LIMIT page_size OFFSET offset_value;

	-- totalproveedores
	SELECT
		COUNT(vp.id) AS total_entries
	FROM
		view_proveedor vp
	WHERE
		vp.estado = 1
		AND (search_term IS NULL OR search_term = ''
		OR vp.nombre LIKE CONCAT('%', search_term, '%')
		OR vp.correo LIKE CONCAT('%', search_term, '%')
		OR vp.persona_nombres LIKE CONCAT('%', search_term, '%')
		OR vp.persona_apellidos LIKE CONCAT('%', search_term, '%')
		OR vp.direccion LIKE CONCAT('%', search_term, '%')
		OR vp.persona_telefono LIKE CONCAT('%', search_term, '%'));

END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.select_proveedores_estaticos
DELIMITER //
CREATE PROCEDURE `select_proveedores_estaticos`()
BEGIN

	SELECT
		vp.id,
		vp.nombre
	FROM
		view_proveedor vp
	WHERE
		vp.estado = 1
	ORDER BY
		vp.nombre ASC;

END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.select_proveedor_by_id
DELIMITER //
CREATE PROCEDURE `select_proveedor_by_id`(
	IN `id` INT
)
BEGIN

	SELECT
		vp.id,
		vp.nombre,
		vp.direccion,
		vp.correo,
		vp.estado,
		vp.persona_id,
		vp.persona_nombres,
		vp.persona_apellidos,
		vp.persona_numero_identificacion,
		vp.persona_telefono,
		vp.persona_genero
	FROM
		view_proveedor vp
	WHERE
		vp.id = id
		AND vp.estado = 1
	LIMIT 1;
	
END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.select_roles
DELIMITER //
CREATE PROCEDURE `select_roles`(
	IN `search_term` VARCHAR(50),
	IN `num_page` INT,
	IN `page_size` INT
)
BEGIN
	
	DECLARE offset_value INT;
	SET offset_value = (num_page - 1) * page_size;
	
	START TRANSACTION;
	
	-- tabla temporal de roles
	CREATE TEMPORARY TABLE temp_roles (id INT PRIMARY KEY);
	INSERT INTO temp_roles (id)
	SELECT
		r.id_rol AS id
	FROM
		rol r
	WHERE
		r.estado_rol = 1
		AND r.id_rol != 1
		AND r.id_rol != 2
		AND (search_term IS NULL OR search_term = ''
		OR r.nombre_rol LIKE CONCAT('%', search_term, '%')
		OR r.id_rol LIKE CONCAT('%', search_term, '%'))
	ORDER BY
		r.nombre_rol ASC,
		r.id_rol ASC
	LIMIT page_size OFFSET offset_value;
	
	-- roles
	SELECT
		r.id_rol AS id,
		r.nombre_rol AS nombre,
		r.estado_rol AS estado
	FROM
		rol r
	WHERE
		r.id_rol IN (SELECT tr.id FROM temp_roles tr);
	
	-- totalroles
	SELECT
		COUNT(r.id_rol) AS total_entries
	FROM
		rol r
	WHERE
		r.estado_rol = 1
		AND r.id_rol != 1
		AND r.id_rol != 2
		AND (search_term IS NULL OR search_term = ''
		OR r.nombre_rol LIKE CONCAT('%', search_term, '%')
		OR r.id_rol LIKE CONCAT('%', search_term, '%'));
	
	-- Resultado: permisos por cada rol
    SELECT
        pr.fk_id_rol AS rol_id,
        p.id_permiso AS permiso_id,
        p.nombre_permiso AS permiso_nombre
    FROM
	 	permisorol pr
    INNER JOIN permiso p ON pr.fk_id_permiso = p.id_permiso
    WHERE
	 	pr.estado_permisorol = 1
      AND pr.fk_id_rol IN (SELECT tr.id FROM temp_roles tr)
	ORDER BY
		pr.fk_id_rol ASC,
		p.nombre_permiso ASC;
        
	-- Eliminar la tabla temporal
    DROP TEMPORARY TABLE IF EXISTS temp_roles;
    
    COMMIT;
    
END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.select_roles_estaticos
DELIMITER //
CREATE PROCEDURE `select_roles_estaticos`()
BEGIN

	SELECT
		r.id_rol AS id,
		r.nombre_rol AS nombre,
		r.estado_rol AS estado
	FROM
		rol r
	WHERE
		r.id_rol != 1
		AND r.id_rol != 2
	ORDER BY
		r.nombre_rol ASC;

END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.select_rol_by_id
DELIMITER //
CREATE PROCEDURE `select_rol_by_id`(
	IN `id` INT
)
BEGIN

	SELECT
		r.id_rol AS id,
		r.nombre_rol AS nombre,
		r.estado_rol AS estado
	FROM
		rol r
	WHERE
		r.id_rol = id;

	CALL select_permisos_by_rol(id);

END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.select_subcategorias
DELIMITER //
CREATE PROCEDURE `select_subcategorias`()
BEGIN

	SELECT
		s.id_subcategoria AS id,
		s.nombre_subcategoria AS nombre,
		s.precio_subcategoria AS precio,
		s.imagen_subcategoria AS imagen,
		s.estado_subcategoria AS estado,
		c.id_categoria AS categoria_id,
		c.nombre_categoria AS categoria_nombre,
		s.fk_id_promocion AS promocion_id,
		p.porcentaje_promocion AS promocion_porcentaje,
		p.fechainicio_promocion AS promocion_fecha_inicio,
		p.fechafin_promocion AS promocion_fecha_fin,
		p.estado_promocion AS promocion_estado
	FROM
		subcategoria s
	INNER JOIN categoria c ON s.fk_id_categoria = c.id_categoria
	LEFT JOIN promocion p ON s.fk_id_promocion = p.id_promocion
	ORDER BY
		s.nombre_subcategoria ASC;

END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.select_subcategoria_by_id
DELIMITER //
CREATE PROCEDURE `select_subcategoria_by_id`(
	IN `id` INT
)
BEGIN

	SELECT
		s.id_subcategoria AS id,
		s.nombre_subcategoria AS nombre,
		s.precio_subcategoria AS precio,
		s.imagen_subcategoria AS imagen,
		s.estado_subcategoria AS estado,
		c.id_categoria AS categoria_id,
		c.nombre_categoria AS categoria_nombre,
		s.fk_id_promocion AS promocion_id,
		p.porcentaje_promocion AS promocion_porcentaje,
		p.fechainicio_promocion AS promocion_fecha_inicio,
		p.fechafin_promocion AS promocion_fecha_fin,
		p.estado_promocion AS promocion_estado
	FROM
		subcategoria s
	INNER JOIN categoria c ON s.fk_id_categoria = c.id_categoria
	LEFT JOIN promocion p ON s.fk_id_promocion = p.id_promocion
	WHERE
		s.id_subcategoria = id
	LIMIT 1;
		
END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.select_tallas
DELIMITER //
CREATE PROCEDURE `select_tallas`()
BEGIN

	SELECT
		t.id_talla AS id,
		t.nombre_talla AS nombre
	FROM
		talla t
	ORDER BY
		t.id_talla ASC;

END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.select_talla_by_id
DELIMITER //
CREATE PROCEDURE `select_talla_by_id`(
	IN `id` INT
)
BEGIN

	SELECT
		t.id_talla AS id,
		t.nombre_talla AS nombre
	FROM
		talla t
	WHERE
		t.id_talla = id
	LIMIT 1;
	
END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.select_usuarios
DELIMITER //
CREATE PROCEDURE `select_usuarios`(
	IN `search_term` VARCHAR(50),
	IN `num_page` INT,
	IN `page_size` INT
)
BEGIN
	
	DECLARE offset_value INT;
	SET offset_value = (num_page - 1) * page_size;
	
	-- usuarios
	SELECT
		vu.id,
		vu.correo,
		vu.estado,
		vu.rol_id,
		vu.rol_nombre,
		vu.rol_estado,
		vu.persona_id,
		vu.nombres,
		vu.apellidos,
		vu.numero_identificacion,
		vu.telefono,
		vu.genero
	FROM
		view_usuario vu
	WHERE
		vu.rol_id != 1
		AND (search_term IS NULL OR search_term = ''
		OR vu.correo LIKE CONCAT('%', search_term, '%')
		OR vu.nombres LIKE CONCAT('%', search_term, '%')
		OR vu.apellidos LIKE CONCAT('%', search_term, '%')
		OR vu.numero_identificacion LIKE CONCAT('%', search_term, '%')
		OR vu.telefono LIKE CONCAT('%', search_term, '%')
		OR vu.rol_nombre LIKE CONCAT('%', search_term, '%'))
	ORDER BY
		vu.correo ASC,
		vu.nombres ASC,
		vu.apellidos ASC,
		vu.numero_identificacion ASC,
		vu.rol_nombre ASC
	LIMIT page_size OFFSET offset_value;
	
	-- totalclientes
	SELECT
		COUNT(vu.id) AS total_entries
	FROM
		view_usuario vu
	WHERE
		search_term IS NULL OR search_term = ''
		OR vu.correo LIKE CONCAT('%', search_term, '%')
		OR vu.nombres LIKE CONCAT('%', search_term, '%')
		OR vu.apellidos LIKE CONCAT('%', search_term, '%')
		OR vu.numero_identificacion LIKE CONCAT('%', search_term, '%')
		OR vu.telefono LIKE CONCAT('%', search_term, '%')
		OR vu.rol_nombre LIKE CONCAT('%', search_term, '%');
	
END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.select_usuario_by_id
DELIMITER //
CREATE PROCEDURE `select_usuario_by_id`(
	IN `id` INT
)
BEGIN

	SELECT
		vu.id,
		vu.correo,
		vu.contrasenia,
		vu.estado,
		vu.rol_id,
		vu.rol_nombre,
		vu.rol_estado,
		vu.persona_id,
		vu.nombres,
		vu.apellidos,
		vu.numero_identificacion,
		vu.telefono,
		vu.genero
	FROM
		view_usuario vu
	WHERE
		vu.id = id
	LIMIT 1;

END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.select_ventas
DELIMITER //
CREATE PROCEDURE `select_ventas`(
	IN `search_term` VARCHAR(50),
	IN `num_page` INT,
	IN `page_size` INT
)
BEGIN
	
	DECLARE offset_value INT;
	SET offset_value = (num_page - 1) * page_size;
	
	START TRANSACTION;
	
	-- tabla temporal de ventas
	CREATE TEMPORARY TABLE temp_ventas (id INT PRIMARY KEY);
	INSERT INTO temp_ventas (id)
	SELECT
		vv.id
	FROM
		view_venta vv
	WHERE
		search_term IS NULL OR search_term = ''
		OR vv.fecha LIKE CONCAT('%', search_term, '%')
		OR vv.metodopago_nombre LIKE CONCAT('%', search_term, '%')
		OR vv.persona_nombres LIKE CONCAT('%', search_term, '%')
		OR vv.persona_apellidos LIKE CONCAT('%', search_term, '%')
		OR vv.persona_numero_identificacion LIKE CONCAT('%', search_term, '%')
		OR vv.usuario_id LIKE CONCAT('%', search_term, '%')
	ORDER BY
		vv.fecha DESC
	LIMIT page_size OFFSET offset_value;
	
	-- ventas
	SELECT
		vv.id,
		vv.fecha,
		vv.monto_recibido,
		vv.estado,
		vv.metodopago_id,
		vv.metodopago_nombre,
		vv.metodopago_estado,
		vv.cliente_id,
		vv.persona_id,
		vv.persona_nombres,
		vv.persona_apellidos,
		vv.persona_numero_identificacion,
		vv.persona_telefono,
		vv.persona_genero,
		vv.cliente_fecha_registro,
		vv.cliente_direccion,
		vv.cliente_estado,
		vv.usuario_id,
		(
	  		SELECT 
				SUM(dv.cantidad_detalleventa * sc.precio_subcategoria)
			FROM 
				detalleventa dv
			JOIN prenda p ON dv.fk_codigo_prenda = p.codigo_prenda
			JOIN subcategoria sc ON p.fk_id_subcategoria = sc.id_subcategoria
			WHERE 
				dv.fk_id_venta = vv.id
		) AS precio_total,
		(
	  		SELECT 
				COUNT(dv.id_detalleventa)
			FROM 
				detalleventa dv
			WHERE 
				dv.fk_id_venta = vv.id
		) AS cantidad
	FROM
		view_venta vv
	WHERE
		vv.id IN (SELECT tv.id FROM temp_ventas tv);
	
	-- totalventas
	SELECT
		COUNT(vv.id) AS total_entries
	FROM
		view_venta vv
	WHERE
		search_term IS NULL OR search_term = ''
		OR vv.fecha LIKE CONCAT('%', search_term, '%')
		OR vv.metodopago_nombre LIKE CONCAT('%', search_term, '%')
		OR vv.persona_nombres LIKE CONCAT('%', search_term, '%')
		OR vv.persona_apellidos LIKE CONCAT('%', search_term, '%')
		OR vv.persona_numero_identificacion LIKE CONCAT('%', search_term, '%')
		OR vv.usuario_id LIKE CONCAT('%', search_term, '%');
	
	-- detallesventa
	SELECT
		dv.id_detalleventa AS id,
		dv.cantidad_detalleventa AS cantidad,
		dv.cantidad_detalleventa * s.precio_subcategoria AS subtotal,
		dv.fk_codigo_prenda AS prenda_codigo,
		CONCAT(c.nombre_categoria, ' - ', s.nombre_subcategoria) AS prenda_nombre,
		co.nombre_color AS prenda_color,
		t.nombre_talla AS prenda_talla,
		s.precio_subcategoria AS prenda_precio,
		pr.porcentaje_promocion AS prenda_promocion,
		dv.fk_id_venta AS venta_id
	FROM
		detalleventa dv
	INNER JOIN prenda p ON dv.fk_codigo_prenda = p.codigo_prenda
	INNER JOIN subcategoria s ON p.fk_id_subcategoria = s.id_subcategoria
	INNER JOIN categoria c ON s.fk_id_categoria = c.id_categoria
	INNER JOIN color co ON p.fk_id_color = co.id_color
	INNER JOIN talla t ON p.fk_id_talla = t.id_talla
	INNER JOIN venta v ON dv.fk_id_venta = v.id_venta
	LEFT JOIN promocion pr ON s.fk_id_promocion = pr.id_promocion
	WHERE
		dv.fk_id_venta IN (SELECT tv.id FROM temp_ventas tv)
	ORDER BY
		v.fecha_venta DESC;
	
	-- Eliminar la tabla temporal
    DROP TEMPORARY TABLE IF EXISTS temp_ventas;
    
    COMMIT;
    
END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.select_venta_by_id
DELIMITER //
CREATE PROCEDURE `select_venta_by_id`(
	IN `id` INT
)
BEGIN

	SELECT
		vv.id,
		vv.fecha,
		vv.monto_recibido,
		vv.estado,
		vv.metodopago_id,
		vv.metodopago_nombre,
		vv.metodopago_estado,
		vv.cliente_id,
		vv.persona_id,
		vv.persona_nombres,
		vv.persona_apellidos,
		vv.persona_numero_identificacion,
		vv.persona_telefono,
		vv.persona_genero,
		vv.cliente_fecha_registro,
		vv.cliente_direccion,
		vv.cliente_estado,
		vv.usuario_id,
		(
	  	SELECT 
			SUM(dv.cantidad_detalleventa * sc.precio_subcategoria)
			FROM 
			detalleventa dv
			JOIN prenda p ON dv.fk_codigo_prenda = p.codigo_prenda
			JOIN subcategoria sc ON p.fk_id_subcategoria = sc.id_subcategoria
			WHERE 
			dv.fk_id_venta = vv.id
		) AS precio_total
	FROM
		view_venta vv
	WHERE
		vv.id = id
	LIMIT 1;

END//
DELIMITER ;

-- Volcando estructura para tabla db_invehin.subcategoria
CREATE TABLE IF NOT EXISTS `subcategoria` (
  `id_subcategoria` int NOT NULL AUTO_INCREMENT,
  `nombre_subcategoria` varchar(50) NOT NULL,
  `precio_subcategoria` int NOT NULL,
  `imagen_subcategoria` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `estado_subcategoria` tinyint(1) NOT NULL DEFAULT '1',
  `fk_id_categoria` int NOT NULL,
  `fk_id_promocion` int DEFAULT NULL,
  PRIMARY KEY (`id_subcategoria`),
  KEY `fk_subcategoria_categoria_idx` (`fk_id_categoria`),
  KEY `fk_subcategoria_promocion_idx` (`fk_id_promocion`) USING BTREE,
  CONSTRAINT `fk_subcategoria_categoria` FOREIGN KEY (`fk_id_categoria`) REFERENCES `categoria` (`id_categoria`) ON UPDATE CASCADE,
  CONSTRAINT `fk_subcategoria_promocion` FOREIGN KEY (`fk_id_promocion`) REFERENCES `promocion` (`id_promocion`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Volcando datos para la tabla db_invehin.subcategoria: ~45 rows (aproximadamente)
INSERT INTO `subcategoria` (`id_subcategoria`, `nombre_subcategoria`, `precio_subcategoria`, `imagen_subcategoria`, `estado_subcategoria`, `fk_id_categoria`, `fk_id_promocion`) VALUES
	(1, 'Manga larga', 25000, 'manga_larga.jpg', 1, 1, 1),
	(2, 'Manga corta', 20000, 'manga_corta.jpg', 1, 1, 2),
	(3, 'Sin mangas', 22000, 'sin_mangas.jpg', 1, 1, 1),
	(4, 'Oversize', 30000, 'oversize.jpg', 1, 1, NULL),
	(5, 'Crop top', 28000, 'crop_top.jpg', 1, 1, NULL),
	(6, 'Skinny', 40000, 'skinny.jpg', 1, 2, NULL),
	(7, 'Palazzo', 45000, 'palazzo.jpg', 1, 2, NULL),
	(8, 'Recto', 42000, 'recto.jpg', 1, 2, NULL),
	(9, 'Jogger', 39000, 'jogger.jpg', 1, 2, NULL),
	(10, 'Culotte', 43000, 'culotte.jpg', 1, 2, NULL),
	(11, 'Plisada', 30000, 'plisada.jpg', 1, 3, NULL),
	(12, 'Lápiz', 35000, 'lapiz.jpg', 1, 3, NULL),
	(13, 'Midi', 32000, 'midi.jpg', 1, 3, NULL),
	(14, 'Mini', 28000, 'mini.jpg', 1, 3, 1),
	(15, 'Maxi', 40000, 'maxi.jpg', 1, 3, NULL),
	(16, 'Casual', 45000, 'casual.jpg', 1, 4, NULL),
	(17, 'Formal', 70000, 'formal.jpg', 1, 4, NULL),
	(18, 'De fiesta', 80000, 'fiesta.jpg', 1, 4, NULL),
	(19, 'Veraniego', 42000, 'veraniego.jpg', 1, 4, NULL),
	(20, 'Largo', 60000, 'largo.jpg', 1, 4, NULL),
	(21, 'Formal', 35000, 'formal_camisa.jpg', 1, 5, NULL),
	(22, 'Casual', 30000, 'casual_camisa.jpg', 1, 5, 3),
	(23, 'Estampada', 32000, 'estampada.jpg', 1, 5, NULL),
	(24, 'Blanca', 28000, 'blanca.jpg', 1, 5, NULL),
	(25, 'Lino', 40000, 'lino.jpg', 1, 5, NULL),
	(26, 'Denim', 30000, 'denim_short.jpg', 1, 6, NULL),
	(27, 'Casual', 28000, 'casual_short.jpg', 1, 6, 4),
	(28, 'Deporte', 35000, 'deporte.jpg', 1, 6, NULL),
	(29, 'Formal', 40000, 'formal_short.jpg', 1, 6, NULL),
	(30, 'Talle alto', 32000, 'talle_alto.jpg', 1, 6, 4),
	(31, 'Trench', 70000, 'trench.jpg', 1, 7, NULL),
	(32, 'Lana', 80000, 'lana.jpg', 1, 7, NULL),
	(33, 'Acolchado', 85000, 'acolchado.jpg', 1, 7, NULL),
	(34, 'Parka', 75000, 'parka.jpg', 1, 7, NULL),
	(35, 'Gabardina', 90000, 'gabardina.jpg', 1, 7, NULL),
	(36, 'Cuello redondo', 30000, 'cuello_redondo.jpg', 1, 8, NULL),
	(37, 'Cuello en V', 32000, 'cuello_v.jpg', 1, 8, NULL),
	(38, 'Oversize', 35000, 'oversize_sueter.jpg', 1, 8, NULL),
	(39, 'Cardigan', 40000, 'cardigan.jpg', 1, 8, NULL),
	(40, 'Crop', 28000, 'crop_sueter.jpg', 1, 8, NULL),
	(41, 'Denim', 60000, 'denim_chaqueta.jpg', 1, 9, 3),
	(42, 'Cuero', 85000, 'cuero.jpg', 1, 9, NULL),
	(43, 'Bomber', 70000, 'bomber.jpg', 1, 9, 5),
	(44, 'Blazer', 75000, 'blazer.jpg', 1, 9, NULL),
	(45, 'Parka', 80000, 'parka_chaqueta.jpg', 1, 9, NULL),
	(46, 'Seda', 85000, NULL, 0, 7, NULL);

-- Volcando estructura para tabla db_invehin.talla
CREATE TABLE IF NOT EXISTS `talla` (
  `id_talla` int NOT NULL AUTO_INCREMENT,
  `nombre_talla` varchar(50) NOT NULL,
  PRIMARY KEY (`id_talla`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Volcando datos para la tabla db_invehin.talla: ~5 rows (aproximadamente)
INSERT INTO `talla` (`id_talla`, `nombre_talla`) VALUES
	(1, 'S'),
	(2, 'M'),
	(3, 'L'),
	(4, 'XL'),
	(5, 'XXL');

-- Volcando estructura para procedimiento db_invehin.update_categoria
DELIMITER //
CREATE PROCEDURE `update_categoria`(
	IN `id` INT,
	IN `nombre` VARCHAR(50)
)
BEGIN

	START TRANSACTION;
	
	UPDATE
		categoria c
	SET
		c.nombre_categoria = nombre
	WHERE
		c.id_categoria = id;
	
	COMMIT;

END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.update_cliente
DELIMITER //
CREATE PROCEDURE `update_cliente`(
	IN `id` INT,
	IN `direccion` VARCHAR(150),
	IN `persona_id` INT,
	IN `nombres` VARCHAR(100),
	IN `apellidos` VARCHAR(100),
	IN `numero_identificacion` VARCHAR(15),
	IN `telefono` VARCHAR(20),
	IN `genero` TINYINT
)
BEGIN

	START TRANSACTION;
	
	CALL update_persona(persona_id, nombres, apellidos, numero_identificacion, telefono, genero);
	
	UPDATE
		cliente c
	SET
		c.direccion_cliente = direccion
	WHERE
		c.id_cliente = id;
	
	COMMIT;

END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.update_color
DELIMITER //
CREATE PROCEDURE `update_color`(
	IN `id` INT,
	IN `nombre` VARCHAR(50)
)
BEGIN
	
	START TRANSACTION;
		
	UPDATE
		color c
	SET
		c.nombre_color = nombre
	WHERE
		c.id_color = id;
		
	COMMIT;
	
END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.update_estadoprenda
DELIMITER //
CREATE PROCEDURE `update_estadoprenda`(
	IN `id` INT,
	IN `nombre` VARCHAR(50)
)
BEGIN
	
	START TRANSACTION;
	
	UPDATE
		estadoprenda e
	SET
		e.nombre_estadoprenda = nombre
	WHERE
		e.id_estadoprenda = id;
	
	COMMIT;
	
END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.update_inventario
DELIMITER //
CREATE PROCEDURE `update_inventario`(
	IN `id` INT,
	IN `observacion` VARCHAR(500),
	IN `estado` TINYINT,
	IN `detalles_inventario` JSON
)
BEGIN

	DECLARE prenda_codigo VARCHAR(50);
	DECLARE detalle_observacion VARCHAR(100);
	DECLARE cantidad_registrada INT;
	DECLARE cantidad_sistema INT;
	DECLARE detalles_inventario_count INT DEFAULT JSON_LENGTH(detalles_inventario);
	DECLARE i INT DEFAULT 0;
	
	START TRANSACTION;
		
	UPDATE
		inventario i
	SET
		i.observacion_inventario = observacion,
		i.estado_inventario = estado
	WHERE
		i.id_inventario = id;
		
	DELETE
	FROM
		detalleinventario di
	WHERE
		di.fk_id_inventario = id;

	WHILE i < detalles_inventario_count DO
		SET prenda_codigo = JSON_UNQUOTE(JSON_EXTRACT(detalles_inventario, CONCAT('$[', i, '].codigo_prenda')));
		SET detalle_observacion = JSON_UNQUOTE(JSON_EXTRACT(detalles_inventario, CONCAT('$[', i, '].observacion')));
		SET cantidad_registrada = CAST(JSON_EXTRACT(detalles_inventario, CONCAT('$[', i, '].cantidad_registrada')) AS UNSIGNED);
		SET cantidad_sistema = CAST(JSON_EXTRACT(detalles_inventario, CONCAT('$[', i, '].cantidad_sistema')) AS UNSIGNED);
		
		INSERT INTO detalleinventario (
			detalleinventario.observacion_detalleinventario,
			detalleinventario.cantidadregistrada_detalleinventario,
			detalleinventario.cantidadsistema_detalleinventario,
			detalleinventario.fk_id_inventario,
			detalleinventario.fk_codigo_prenda
		) VALUES (
			detalle_observacion,
			cantidad_registrada,
			cantidad_sistema,
			id,
			prenda_codigo
		);
		
		SET i = i + 1;
	END WHILE;
	
	COMMIT;
	
END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.update_metodopago
DELIMITER //
CREATE PROCEDURE `update_metodopago`(
	IN `id` INT,
	IN `nombre` VARCHAR(50),
	IN `estado` TINYINT
)
BEGIN

	START TRANSACTION;
	
	UPDATE
		metodopago mp
	SET
		mp.nombre_metodopago = nombre,
		mp.estado_metodopago = estado
	WHERE
		mp.id_metodopago = id;
	
	COMMIT;

END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.update_pedido
DELIMITER //
CREATE PROCEDURE `update_pedido`(
	IN `id` INT,
	IN `fecha` DATE,
	IN `estado` TINYINT,
	IN `proveedor_id` INT,
	IN `detalles_pedido` JSON
)
BEGIN
	
	DECLARE prenda_codigo VARCHAR(50) DEFAULT NULL;
	DECLARE cantidad_prenda INT;
	DECLARE costo_unitario_prenda INT;
	DECLARE detalles_pedido_count INT DEFAULT JSON_LENGTH(detalles_pedido);
	DECLARE i INT DEFAULT 0;
	
	START TRANSACTION;
	
	UPDATE
		pedido p
	SET
		p.fecha_pedido = fecha,
		p.estado_pedido = estado,
		p.fk_id_proveedor = proveedor_id
	WHERE
		p.id_pedido = id;
		
	DELETE
	FROM
		detallepedido dp
	WHERE
		dp.fk_id_pedido = id;
	
	WHILE i < detalles_pedido_count DO
		SET prenda_codigo = JSON_UNQUOTE(JSON_EXTRACT(detalles_pedido, CONCAT('$[', i, '].codigo_prenda')));
		SET cantidad_prenda = CAST(JSON_EXTRACT(detalles_pedido, CONCAT('$[', i, '].cantidad')) AS UNSIGNED);
		SET costo_unitario_prenda = CAST(JSON_EXTRACT(detalles_pedido, CONCAT('$[', i, '].costo_unitario')) AS DECIMAL(10,2));
		
		INSERT INTO detallepedido (
			detallepedido.cantidad_detallepedido,
			detallepedido.costounitario_detallepedido,
			detallepedido.fk_id_pedido,
			detallepedido.fk_codigo_prenda
		) VALUES (
			cantidad_prenda,
			costo_unitario_prenda,
			id,
			prenda_codigo
		);
		
		SET i = i + 1;
	END WHILE;
	
	COMMIT;
	
END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.update_permiso
DELIMITER //
CREATE PROCEDURE `update_permiso`(
	IN `id` INT,
	IN `nombre` VARCHAR(50)
)
BEGIN

	START TRANSACTION;
	
	UPDATE
		permiso p
	SET
		p.nombre_permiso = nombre
	WHERE
		p.id_permiso = id;
	
	COMMIT;

END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.update_persona
DELIMITER //
CREATE PROCEDURE `update_persona`(
	IN `id` INT,
	IN `nombres` VARCHAR(100),
	IN `apellidos` VARCHAR(100),
	IN `numero_identificacion` VARCHAR(15),
	IN `telefono` VARCHAR(20),
	IN `genero` TINYINT
)
BEGIN
	
	START TRANSACTION;
	
	UPDATE
		persona p
	SET
		p.nombres_persona = nombres,
		p.apellidos_persona = apellidos,
		p.numeroidentificacion_persona = numero_identificacion,
		p.telefono_persona = telefono,
		p.genero_persona = genero
	WHERE
		p.id_persona = id;
	
	COMMIT;
	
END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.update_prenda
DELIMITER //
CREATE PROCEDURE `update_prenda`(
	IN `codigo` VARCHAR(50),
	IN `stock` INT,
	IN `stock_minimo` INT,
	IN `color_id` INT,
	IN `estadoprenda_id` INT,
	IN `subcategoria_id` INT,
	IN `talla_id` INT
)
BEGIN

	START TRANSACTION;
	
	UPDATE
		prenda p
	SET
		p.codigo_prenda = codigo,
		p.stock_prenda = stock,
		p.stockminimo_prenda = stock_minimo,
		p.fk_id_color = color_id,
		p.fk_id_estadoprenda = estadoprenda_id,
		p.fk_id_subcategoria = subcategoria_id,
		p.fk_id_talla = talla_id
	WHERE
		p.codigo_prenda = codigo;
	
	COMMIT;

END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.update_promocion
DELIMITER //
CREATE PROCEDURE `update_promocion`(
	IN `id` INT,
	IN `porcentaje` INT,
	IN `fecha_inicio` DATE,
	IN `fecha_fin` DATE,
	IN `estado` TINYINT
)
BEGIN

	START TRANSACTION;
	
	UPDATE
		promocion p
	SET
		p.porcentaje_promocion = porcentaje,
		p.fechainicio_promocion = fecha_incio,
		p.fechafin_promocion = fecha_fin,
		p.estado_promocion = estado
	WHERE
		p.id_promocion = id;
	
	COMMIT;

END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.update_proveedor
DELIMITER //
CREATE PROCEDURE `update_proveedor`(
	IN `id` INT,
	IN `nombre` VARCHAR(100),
	IN `correo` VARCHAR(150),
	IN `direccion` VARCHAR(150),
	IN `persona_id` INT,
	IN `nombres` VARCHAR(100),
	IN `apellidos` VARCHAR(100),
	IN `telefono` VARCHAR(20)
)
BEGIN
	
	START TRANSACTION;
		
	CALL update_persona(persona_id, nombres, apellidos, NULL, telefono, NULL);
	
	UPDATE
		proveedor p
	SET
		p.nombre_proveedor = nombre,
		p.correo_proveedor = correo,
		p.direccion_proveedor = direccion
	WHERE
		p.id_proveedor = id;
		
	COMMIT;
	
END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.update_rol
DELIMITER //
CREATE PROCEDURE `update_rol`(
	IN `id` INT,
	IN `nombre` VARCHAR(50),
	IN `permisos` JSON
)
BEGIN

	DECLARE permiso_id INT;
	DECLARE permisos_count INT DEFAULT JSON_LENGTH(permisos);
	DECLARE i INT DEFAULT 0;
	
	START TRANSACTION;
		
	UPDATE
		rol r
	SET
		r.nombre_rol = nombre
	WHERE
		r.id_rol = id;
		
	DELETE
	FROM
		permisorol pr
	WHERE
		pr.fk_id_rol = id;
		
	WHILE i < permisos_count DO
		SET permiso_id = JSON_EXTRACT(permisos, CONCAT('$[', i, '].id'));
		
		INSERT INTO permisorol (
			permisorol.fk_id_rol,
			permisorol.fk_id_permiso
		) VALUES (
			id,
			permiso_id
		);
		
		SET i = i + 1;
   END WHILE;
	
	COMMIT;

END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.update_subcategoria
DELIMITER //
CREATE PROCEDURE `update_subcategoria`(
	IN `id` INT,
	IN `nombre` VARCHAR(50),
	IN `precio` INT,
	IN `categoria_id` INT
)
BEGIN
	
	START TRANSACTION;
	
	UPDATE
		subcategoria s
	SET
		s.nombre_subcategoria = nombre,
		s.precio_subcategoria = precio,
		s.fk_id_categoria = categoria_id
	WHERE
		s.id_subcategoria = id;
	
	COMMIT;
	
END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.update_talla
DELIMITER //
CREATE PROCEDURE `update_talla`(
	IN `id` INT,
	IN `nombre` VARCHAR(50)
)
BEGIN

	START TRANSACTION;
	
	UPDATE
		talla t
	SET
		t.nombre_talla = nombre
	WHERE
		t.id_talla = id;
	
	COMMIT;

END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.update_usuario
DELIMITER //
CREATE PROCEDURE `update_usuario`(
	IN `id` INT,
	IN `rol_id` INT,
	IN `estado` TINYINT,
	IN `persona_id` INT,
	IN `nombres` VARCHAR(100),
	IN `apellidos` VARCHAR(100),
	IN `numero_identificacion` VARCHAR(15),
	IN `telefono` VARCHAR(20),
	IN `genero` TINYINT
)
BEGIN

	START TRANSACTION;
	
	CALL update_persona(persona_id, nombres, apellidos, numero_identificacion, telefono, genero);
	
	UPDATE
		usuario u
	SET
		u.estado_usuario = estado,
		u.fk_id_rol = rol_id
	WHERE
		u.id_usuario = id;

	COMMIT;

END//
DELIMITER ;

-- Volcando estructura para procedimiento db_invehin.update_venta
DELIMITER //
CREATE PROCEDURE `update_venta`(
	IN `id` INT,
	IN `cliente_id` INT,
	IN `metodopago_id` INT,
	IN `estado` TINYINT
)
BEGIN

	START TRANSACTION;
	
	UPDATE
		venta v
	SET
		v.fk_id_cliente = cliente_id,
		v.fk_id_metodopago = metodopago_id,
		v.estado_venta = estado
	WHERE
		v.id_venta = id;
	
	COMMIT;
	
END//
DELIMITER ;

-- Volcando estructura para tabla db_invehin.usuario
CREATE TABLE IF NOT EXISTS `usuario` (
  `id_usuario` int NOT NULL AUTO_INCREMENT,
  `correo_usuario` varchar(150) NOT NULL,
  `contrasenia_usuario` varchar(255) NOT NULL,
  `estado_usuario` tinyint(1) NOT NULL DEFAULT '1',
  `fk_id_persona` int NOT NULL,
  `fk_id_rol` int NOT NULL DEFAULT '2',
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `correo_usuario` (`correo_usuario`),
  KEY `fk_usuario_persona_idx` (`fk_id_persona`),
  KEY `fk_usuario_rol_idx` (`fk_id_rol`),
  CONSTRAINT `fk_usuario_persona` FOREIGN KEY (`fk_id_persona`) REFERENCES `persona` (`id_persona`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_usuario_rol` FOREIGN KEY (`fk_id_rol`) REFERENCES `rol` (`id_rol`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Volcando datos para la tabla db_invehin.usuario: ~5 rows (aproximadamente)
INSERT INTO `usuario` (`id_usuario`, `correo_usuario`, `contrasenia_usuario`, `estado_usuario`, `fk_id_persona`, `fk_id_rol`) VALUES
	(1, 'superadmin@invehin.com', '5994471abb01112afcc18159f6cc74b4f511b99806da59b3caf5a9c173cacfc5', 1, 17, 1),
	(2, 'empleado@invehin.com', '5994471abb01112afcc18159f6cc74b4f511b99806da59b3caf5a9c173cacfc5', 1, 7, 4),
	(3, 'contador@invehin.com', '5994471abb01112afcc18159f6cc74b4f511b99806da59b3caf5a9c173cacfc5', 1, 8, 5),
	(4, 'admin@invehin.com', '5994471abb01112afcc18159f6cc74b4f511b99806da59b3caf5a9c173cacfc5', 1, 20, 3),
	(5, 'recepcionista@invehin.com', '5994471abb01112afcc18159f6cc74b4f511b99806da59b3caf5a9c173cacfc5', 0, 19, 4),
	(9, 'invitado@invehin.com', '5994471abb01112afcc18159f6cc74b4f511b99806da59b3caf5a9c173cacfc5', 1, 32, 7);

-- Volcando estructura para tabla db_invehin.venta
CREATE TABLE IF NOT EXISTS `venta` (
  `id_venta` int NOT NULL AUTO_INCREMENT,
  `fecha_venta` datetime NOT NULL DEFAULT (now()),
  `montorecibido_venta` int NOT NULL,
  `estado_venta` tinyint(1) NOT NULL DEFAULT '1',
  `fk_id_cliente` int DEFAULT NULL,
  `fk_id_metodopago` int DEFAULT NULL,
  `fk_id_usuario` int DEFAULT NULL,
  PRIMARY KEY (`id_venta`),
  KEY `fk_venta_cliente_idx` (`fk_id_cliente`),
  KEY `fk_venta_metodopago_idx` (`fk_id_metodopago`),
  KEY `fk_venta_usuario_idx` (`fk_id_usuario`),
  CONSTRAINT `fk_venta_cliente` FOREIGN KEY (`fk_id_cliente`) REFERENCES `cliente` (`id_cliente`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_venta_metodopago` FOREIGN KEY (`fk_id_metodopago`) REFERENCES `metodopago` (`id_metodopago`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_venta_usuario` FOREIGN KEY (`fk_id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Volcando datos para la tabla db_invehin.venta: ~25 rows (aproximadamente)
INSERT INTO `venta` (`id_venta`, `fecha_venta`, `montorecibido_venta`, `estado_venta`, `fk_id_cliente`, `fk_id_metodopago`, `fk_id_usuario`) VALUES
	(1, '2025-06-22 19:28:30', 100000, 0, 2, 1, 4),
	(2, '2025-05-21 19:28:30', 250000, 1, 2, 1, 2),
	(3, '2025-05-22 19:28:30', 180000, 1, 3, 1, 3),
	(4, '2025-06-23 19:28:30', 90000, 1, 4, 1, 1),
	(5, '2025-05-22 19:28:30', 300000, 1, 5, 1, 4),
	(6, '2025-05-21 19:28:30', 150000, 1, 1, 1, 2),
	(7, '2025-05-22 19:28:30', 220000, 1, 2, 1, 3),
	(8, '2025-05-21 19:28:30', 120000, 1, 3, 1, 1),
	(9, '2025-05-22 19:28:30', 400000, 1, 4, 1, 4),
	(10, '2025-05-23 19:28:30', 95000, 1, 5, 1, 2),
	(11, '2025-06-21 19:28:30', 170000, 1, 1, 1, 3),
	(12, '2025-05-21 19:28:30', 210000, 1, 2, 1, 1),
	(13, '2025-05-21 19:28:30', 80000, 1, 3, 1, 4),
	(14, '2025-05-22 19:28:30', 260000, 1, 4, 1, 2),
	(15, '2025-05-23 19:28:30', 110000, 1, 5, 1, 3),
	(16, '2025-07-11 19:28:30', 300000, 1, 1, 1, 1),
	(17, '2025-05-22 19:28:30', 90000, 1, 2, 1, 4),
	(18, '2025-05-23 19:28:30', 140000, 1, 3, 1, 2),
	(19, '2025-05-23 19:28:30', 50000, 1, 4, 1, 3),
	(20, '2025-05-23 19:28:30', 350000, 1, 5, 1, 1),
	(21, '2025-05-21 19:29:46', 350000, 1, 5, 1, 1),
	(23, '2025-06-05 18:28:21', 150000, 1, 1, 1, 1),
	(25, '2025-06-05 22:28:52', 30000, 1, 4, 1, 1),
	(26, '2025-06-05 22:32:36', 50000, 1, 3, 2, 1),
	(27, '2025-06-14 18:37:44', 30000, 1, 2, 1, 1),
	(28, '2025-06-20 17:28:01', 80000, 1, 10, 1, 1),
	(29, '2025-07-05 09:13:22', 100000, 1, 11, 1, 1);

-- Volcando estructura para vista db_invehin.view_cliente
-- Creando tabla temporal para superar errores de dependencia de VIEW
CREATE TABLE `view_cliente` (
	`id` INT NOT NULL,
	`fecha_registro` TIMESTAMP NOT NULL,
	`direccion` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`estado` TINYINT(1) NOT NULL,
	`persona_id` INT NOT NULL,
	`nombres` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`apellidos` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`numero_identificacion` VARCHAR(1) NULL COLLATE 'utf8mb4_0900_ai_ci',
	`telefono` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`genero` TINYINT(1) NULL
) ENGINE=MyISAM;

-- Volcando estructura para vista db_invehin.view_pedido
-- Creando tabla temporal para superar errores de dependencia de VIEW
CREATE TABLE `view_pedido` (
	`id` INT NOT NULL,
	`fecha` DATE NOT NULL,
	`estado` TINYINT(1) NOT NULL,
	`proveedor_id` INT NOT NULL,
	`proveedor_nombre` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_0900_ai_ci'
) ENGINE=MyISAM;

-- Volcando estructura para vista db_invehin.view_prenda
-- Creando tabla temporal para superar errores de dependencia de VIEW
CREATE TABLE `view_prenda` (
	`codigo` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`stock` INT NOT NULL,
	`stock_minimo` INT NOT NULL,
	`color_id` INT NULL,
	`color_nombre` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`talla_id` INT NULL,
	`talla_nombre` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`estadoprenda_id` INT NULL,
	`estadoprenda_nombre` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`subcategoria_id` INT NULL,
	`subcategoria_nombre` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`subcategoria_precio` INT NOT NULL,
	`subcategoria_imagen` VARCHAR(1) NULL COLLATE 'utf8mb4_0900_ai_ci',
	`subcategoria_estado` TINYINT(1) NOT NULL,
	`categoria_id` INT NOT NULL,
	`categoria_nombre` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`categoria_estado` TINYINT NOT NULL,
	`promocion_id` INT NULL,
	`promocion_porcentaje` INT NULL,
	`promocion_fechainicio` DATETIME NULL,
	`promocion_fechafin` DATETIME NULL
) ENGINE=MyISAM;

-- Volcando estructura para vista db_invehin.view_proveedor
-- Creando tabla temporal para superar errores de dependencia de VIEW
CREATE TABLE `view_proveedor` (
	`id` INT NOT NULL,
	`nombre` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`direccion` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`correo` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`estado` TINYINT NOT NULL,
	`persona_id` INT NOT NULL,
	`persona_nombres` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`persona_apellidos` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`persona_numero_identificacion` VARCHAR(1) NULL COLLATE 'utf8mb4_0900_ai_ci',
	`persona_telefono` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`persona_genero` TINYINT(1) NULL
) ENGINE=MyISAM;

-- Volcando estructura para vista db_invehin.view_usuario
-- Creando tabla temporal para superar errores de dependencia de VIEW
CREATE TABLE `view_usuario` (
	`id` INT NOT NULL,
	`correo` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`contrasenia` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`estado` TINYINT(1) NOT NULL,
	`rol_id` INT NOT NULL,
	`rol_nombre` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`rol_estado` TINYINT(1) NOT NULL,
	`persona_id` INT NOT NULL,
	`nombres` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`apellidos` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`numero_identificacion` VARCHAR(1) NULL COLLATE 'utf8mb4_0900_ai_ci',
	`telefono` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`genero` TINYINT(1) NULL
) ENGINE=MyISAM;

-- Volcando estructura para vista db_invehin.view_venta
-- Creando tabla temporal para superar errores de dependencia de VIEW
CREATE TABLE `view_venta` (
	`id` INT NOT NULL,
	`fecha` DATETIME NOT NULL,
	`monto_recibido` INT NOT NULL,
	`estado` TINYINT(1) NOT NULL,
	`metodopago_id` INT NULL,
	`metodopago_nombre` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`metodopago_estado` TINYINT(1) NOT NULL,
	`cliente_id` INT NULL,
	`persona_id` INT NOT NULL,
	`persona_nombres` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`persona_apellidos` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`persona_numero_identificacion` VARCHAR(1) NULL COLLATE 'utf8mb4_0900_ai_ci',
	`persona_telefono` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`persona_genero` TINYINT(1) NULL,
	`cliente_fecha_registro` TIMESTAMP NOT NULL,
	`cliente_direccion` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`cliente_estado` TINYINT(1) NOT NULL,
	`usuario_id` INT NULL
) ENGINE=MyISAM;

-- Volcando estructura para disparador db_invehin.tr_auditorias_after_update_proveedor
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `tr_auditorias_after_update_proveedor` AFTER UPDATE ON `proveedor` FOR EACH ROW BEGIN

	INSERT INTO auditoria (
		auditoria.tabla_auditoria,
		auditoria.operacion_auditoria,
		auditoria.idregistro_auditoria,
		auditoria.usuario_auditoria,
		auditoria.fecha_auditoria,
		auditoria.detalleanterior_auditoria,
		auditoria.detallenuevo_auditoria
	)
	VALUES (
		'proveedor',
		'UPDATE',
		NEW.id_proveedor,
		@id_usuario_auditoria, -- recibido desde el backend
		NOW(),
		CONCAT(
			'{',
				'"id_proveedor":"', OLD.id_proveedor, '",',
				'"nombre_proveedor":"', OLD.nombre_proveedor, '",',
				'"direccion_proveedor":"', OLD.direccion_proveedor, '",',
				'"correo_proveedor":"', OLD.correo_proveedor, '",',
				'"estado_proveedor":"', OLD.estado_proveedor, '",',
				'"fk_id_persona":"', OLD.fk_id_persona, '"',
			'}'
		),
		CONCAT(
			'{',
				'"id_proveedor":"', NEW.id_proveedor, '",',
				'"nombre_proveedor":"', NEW.nombre_proveedor, '",',
				'"direccion_proveedor":"', NEW.direccion_proveedor, '",',
				'"correo_proveedor":"', NEW.correo_proveedor, '",',
				'"estado_proveedor":"', NEW.estado_proveedor, '",',
				'"fk_id_persona":"', NEW.fk_id_persona, '"',
			'}'
		)
	);

END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador db_invehin.tr_auditoria_after_ delete_rol
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `tr_auditoria_after_ delete_rol` AFTER DELETE ON `rol` FOR EACH ROW BEGIN

	INSERT INTO auditoria (
		auditoria.tabla_auditoria,
		auditoria.operacion_auditoria,
		auditoria.idregistro_auditoria,
		auditoria.usuario_auditoria,
		auditoria.fecha_auditoria,
		auditoria.detalleanterior_auditoria,
		auditoria.detallenuevo_auditoria
	)
	VALUES (
		'rol',
		'DELETE',
		OLD.id_rol,
		@id_usuario_auditoria, -- recibido desde el backend
		NOW(),
		CONCAT(
			'{',
				'"id_rol":"', OLD.id_rol, '",',
				'"nombre_rol":"', OLD.nombre_rol, '",',
				'"estado_rol":"', OLD.estado_rol, '"',
			'}'
		),
		NULL
	);

END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador db_invehin.tr_auditoria_after_delete_categoria
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `tr_auditoria_after_delete_categoria` AFTER DELETE ON `categoria` FOR EACH ROW BEGIN

	INSERT INTO auditoria (
		auditoria.tabla_auditoria,
		auditoria.operacion_auditoria,
		auditoria.idregistro_auditoria,
		auditoria.usuario_auditoria,
		auditoria.fecha_auditoria,
		auditoria.detalleanterior_auditoria,
		auditoria.detallenuevo_auditoria
	)
	VALUES (
		'categoria',
		'DELETE',
		OLD.id_categoria,
		@id_usuario_auditoria, -- recibido desde el backend
		NOW(),
		CONCAT(
			'{',
				'"id_categoria":"', OLD.id_categoria, '",',
				'"nombre_categoria":"', OLD.nombre_categoria, '",',
				'"estado_categoria":"', OLD.estado_categoria, '"',
			'}'
		),
		NULL
	);

END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador db_invehin.tr_auditoria_after_delete_cliente
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `tr_auditoria_after_delete_cliente` AFTER DELETE ON `cliente` FOR EACH ROW BEGIN

	INSERT INTO auditoria (
		auditoria.tabla_auditoria,
		auditoria.operacion_auditoria,
		auditoria.idregistro_auditoria,
		auditoria.usuario_auditoria,
		auditoria.fecha_auditoria,
		auditoria.detalleanterior_auditoria,
		auditoria.detallenuevo_auditoria
	) 
	VALUES (
		'cliente',
		'DELETE',
		OLD.id_cliente,
		@id_usuario_auditoria, -- recibido desde el backend
		NOW(),
		CONCAT(
			'{',
				'"id_cliente":"', OLD.id_cliente, '",',
				'"direccion_cliente":"', OLD.direccion_cliente, '",',
				'"fecharegistro_cliente":"', OLD.fecharegistro_cliente, '",',
				'"estado_cliente":"', OLD.estado_cliente, '",',
				'"fk_id_persona":"', OLD.fk_id_persona, '"',
			'}'
		),
		NULL
	);
	
	-- Eliminar datos persona
	DELETE
	FROM
		persona p
	WHERE
		p.id_persona = OLD.fk_id_persona;

END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador db_invehin.tr_auditoria_after_delete_inventario
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `tr_auditoria_after_delete_inventario` AFTER DELETE ON `inventario` FOR EACH ROW BEGIN

	INSERT INTO auditoria (
		auditoria.tabla_auditoria,
		auditoria.operacion_auditoria,
		auditoria.idregistro_auditoria,
		auditoria.usuario_auditoria,
		auditoria.fecha_auditoria,
		auditoria.detalleanterior_auditoria,
		auditoria.detallenuevo_auditoria
	)
	VALUES (
		'inventario',
		'DELETE',
		OLD.id_inventario,
		@id_usuario_auditoria, -- recibido desde el backend
		NOW(),
		CONCAT(
			'{',
				'"id_inventario":"', OLD.id_inventario, '",',
				'"fecha_inventario":"', OLD.fecha_inventario, '",',
				'"observacion_inventario":"', IFNULL(OLD.observacion_inventario, ''), '",',
				'"estado_inventario":"', OLD.estado_inventario, '",',
				'"fk_id_usuario":"', IFNULL(OLD.fk_id_usuario, ''), '"',
			'}'
		),
		NULL
	);
	
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador db_invehin.tr_auditoria_after_delete_pedido
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `tr_auditoria_after_delete_pedido` AFTER DELETE ON `pedido` FOR EACH ROW BEGIN

	INSERT INTO auditoria (
		auditoria.tabla_auditoria,
		auditoria.operacion_auditoria,
		auditoria.idregistro_auditoria,
		auditoria.usuario_auditoria,
		auditoria.fecha_auditoria,
		auditoria.detalleanterior_auditoria,
		auditoria.detallenuevo_auditoria
	)
	VALUES (
		'pedido',
		'DELETE',
		OLD.id_pedido,
		@id_usuario_auditoria, -- recibido desde el backend
		NOW(),
		CONCAT(
			'{',
				'"id_pedido":"', OLD.id_pedido, '",',
				'"fecha_pedido":"', OLD.fecha_pedido, '",',
				'"estado_pedido":"', OLD.estado_pedido, '",',
				'"fk_id_proveedor":"', OLD.fk_id_proveedor, '"',
			'}'
		),
		NULL
	);

END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador db_invehin.tr_auditoria_after_delete_persona
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `tr_auditoria_after_delete_persona` AFTER DELETE ON `persona` FOR EACH ROW BEGIN

	INSERT INTO auditoria (
		auditoria.tabla_auditoria,
		auditoria.operacion_auditoria,
		auditoria.idregistro_auditoria,
		auditoria.usuario_auditoria,
		auditoria.fecha_auditoria,
		auditoria.detalleanterior_auditoria,
		auditoria.detallenuevo_auditoria
	)
	VALUES (
		'persona',
		'DELETE',
		OLD.id_persona,
		@id_usuario_auditoria, -- recibido desde el backend
		NOW(),
		CONCAT(
			'{',
				'"id_persona":"', OLD.id_persona, '",',
				'"nombres_persona":"', OLD.nombres_persona, '",',
				'"apellidos_persona":"', OLD.apellidos_persona, '",',
				'"numeroidentificacion_persona":"', IFNULL(OLD.numeroidentificacion_persona, ''), '",',
				'"telefono_persona":"', OLD.telefono_persona, '",',
				'"genero_persona":"', IFNULL(OLD.genero_persona, ''), '"',
			'}'
		),
		NULL
	);

END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador db_invehin.tr_auditoria_after_delete_proveedor
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `tr_auditoria_after_delete_proveedor` AFTER DELETE ON `proveedor` FOR EACH ROW BEGIN

	INSERT INTO auditoria (
		auditoria.tabla_auditoria,
		auditoria.operacion_auditoria,
		auditoria.idregistro_auditoria,
		auditoria.usuario_auditoria,
		auditoria.fecha_auditoria,
		auditoria.detalleanterior_auditoria,
		auditoria.detallenuevo_auditoria
	)
	VALUES (
		'proveedor',
		'DELETE',
		OLD.id_proveedor,
		@id_usuario_auditoria, -- recibido desde el backend
		NOW(),
		CONCAT(
			'{',
				'"id_proveedor":"', OLD.id_proveedor, '",',
				'"nombre_proveedor":"', OLD.nombre_proveedor, '",',
				'"direccion_proveedor":"', OLD.direccion_proveedor, '",',
				'"correo_proveedor":"', OLD.correo_proveedor, '",',
				'"estado_proveedor":"', OLD.estado_proveedor, '",',
				'"fk_id_persona":"', OLD.fk_id_persona, '"',
			'}'
		),
		NULL
	);

	-- Eliminar datos persona
	DELETE
	FROM
		persona p
	WHERE
		p.id_persona = OLD.fk_id_persona;
		
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador db_invehin.tr_auditoria_after_delete_subcategoria
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `tr_auditoria_after_delete_subcategoria` AFTER DELETE ON `subcategoria` FOR EACH ROW BEGIN

	INSERT INTO auditoria (
		auditoria.tabla_auditoria,
		auditoria.operacion_auditoria,
		auditoria.idregistro_auditoria,
		auditoria.usuario_auditoria,
		auditoria.fecha_auditoria,
		auditoria.detalleanterior_auditoria,
		auditoria.detallenuevo_auditoria
	)
	VALUES (
		'subcategoria',
		'DELETE',
		OLD.id_subcategoria,
		@id_usuario_auditoria, -- recibido desde el backend
		NOW(),
		CONCAT(
			'{',
				'"id_subcategoria":"', OLD.id_subcategoria, '",',
				'"nombre_subcategoria":"', OLD.nombre_subcategoria, '",',
				'"precio_subcategoria":"', OLD.precio_subcategoria, '",',
				'"imagen_subcategoria":"', IFNULL(OLD.imagen_subcategoria, ''), '",',
				'"estado_subcategoria":"', OLD.estado_subcategoria, '",',
				'"fk_id_categoria":"', OLD.fk_id_categoria, '",',
				'"fk_id_promocion":"', IFNULL(OLD.fk_id_promocion, ''), '"',
			'}'
		),
		NULL
	);

END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador db_invehin.tr_auditoria_after_delete_usuario
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `tr_auditoria_after_delete_usuario` AFTER DELETE ON `usuario` FOR EACH ROW BEGIN

	INSERT INTO auditoria (
		auditoria.tabla_auditoria,
		auditoria.operacion_auditoria,
		auditoria.idregistro_auditoria,
		auditoria.usuario_auditoria,
		auditoria.fecha_auditoria,
		auditoria.detalleanterior_auditoria,
		auditoria.detallenuevo_auditoria
	)
	VALUES (
		'usuario',
		'DELETE',
		OLD.id_usuario,
		@id_usuario_auditoria, -- recibido desde el backend
		NOW(),
		CONCAT(
			'{',
				'"id_usuario":"', OLD.id_usuario, '",',
				'"correo_usuario":"', OLD.correo_usuario, '",',
				'"estado_usuario":"', OLD.estado_usuario, '",',
				'"fk_id_persona":"', OLD.fk_id_persona, '",',
				'"fk_id_rol":"', OLD.fk_id_rol, '"',
			'}'
		),
		NULL
	);

	-- Eliminar datos persona
	DELETE
	FROM
		persona p
	WHERE
		p.id_persona = OLD.fk_id_persona;
		
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador db_invehin.tr_auditoria_after_delete_venta
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `tr_auditoria_after_delete_venta` AFTER DELETE ON `venta` FOR EACH ROW BEGIN

	INSERT INTO auditoria (
		auditoria.tabla_auditoria,
		auditoria.operacion_auditoria,
		auditoria.idregistro_auditoria,
		auditoria.usuario_auditoria,
		auditoria.fecha_auditoria,
		auditoria.detalleanterior_auditoria,
		auditoria.detallenuevo_auditoria
	)
	VALUES (
		'venta',
		'DELETE',
		OLD.id_venta,
		@id_usuario_auditoria, -- recibido desde el backend
		NOW(),
		CONCAT(
			'{',
				'"id_venta":"', OLD.id_venta, '",',
				'"fecha_venta":"', DATE_FORMAT(OLD.fecha_venta, '%Y-%m-%d %H:%i:%s'), '",',
				'"montorecibido_venta":"', OLD.montorecibido_venta, '",',
				'"estado_venta":"', OLD.estado_venta, '",',
				'"fk_id_cliente":"', IFNULL(OLD.fk_id_cliente, ''), '",',
				'"fk_id_metodopago":"', IFNULL(OLD.fk_id_metodopago, ''), '",',
				'"fk_id_usuario":"', IFNULL(OLD.fk_id_usuario, ''), '"',
			'}'
		),
		NULL
	);

END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador db_invehin.tr_auditoria_after_insert_categoria
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `tr_auditoria_after_insert_categoria` AFTER INSERT ON `categoria` FOR EACH ROW BEGIN

	INSERT INTO auditoria (
		auditoria.tabla_auditoria,
		auditoria.operacion_auditoria,
		auditoria.idregistro_auditoria,
		auditoria.usuario_auditoria,
		auditoria.fecha_auditoria,
		auditoria.detalleanterior_auditoria,
		auditoria.detallenuevo_auditoria
	)
	VALUES (
		'categoria',
		'INSERT',
		NEW.id_categoria,
		@id_usuario_auditoria, -- recibido desde el backend
		NOW(),
		NULL,
		CONCAT(
			'{',
				'"nombre_categoria":"', NEW.nombre_categoria, '",',
				'"estado_categoria":"', NEW.estado_categoria, '"',
			'}'
		)
	);

END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador db_invehin.tr_auditoria_after_insert_cliente
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `tr_auditoria_after_insert_cliente` AFTER INSERT ON `cliente` FOR EACH ROW BEGIN

	INSERT INTO auditoria (
		auditoria.tabla_auditoria,
		auditoria.operacion_auditoria,
		auditoria.idregistro_auditoria,
		auditoria.usuario_auditoria,
		auditoria.fecha_auditoria,
		auditoria.detalleanterior_auditoria,
		auditoria.detallenuevo_auditoria
	) 
	VALUES (
		'cliente',
		'INSERT',
		NEW.id_cliente,
		@id_usuario_auditoria, -- recibido desde el backend
		NOW(),
		NULL,
		CONCAT(
			'{',
				'"direccion_cliente":"', NEW.direccion_cliente, '",',
				'"fecharegistro_cliente":"', NEW.fecharegistro_cliente, '",',
				'"estado_cliente":"', NEW.estado_cliente, '",',
				'"fk_id_persona":"', NEW.fk_id_persona, '"',
			'}'
		)
	);

END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador db_invehin.tr_auditoria_after_insert_inventario
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `tr_auditoria_after_insert_inventario` AFTER INSERT ON `inventario` FOR EACH ROW BEGIN

	INSERT INTO auditoria (
		auditoria.tabla_auditoria,
		auditoria.operacion_auditoria,
		auditoria.idregistro_auditoria,
		auditoria.usuario_auditoria,
		auditoria.fecha_auditoria,
		auditoria.detalleanterior_auditoria,
		auditoria.detallenuevo_auditoria
	)
	VALUES (
		'inventario',
		'INSERT',
		NEW.id_inventario,
		@id_usuario_auditoria, -- recibido desde el backend
		NOW(),
		NULL,
		CONCAT(
			'{',
				'"fecha_inventario":"', NEW.fecha_inventario, '",',
				'"observacion_inventario":"', IFNULL(NEW.observacion_inventario, ''), '",',
				'"estado_inventario":"', NEW.estado_inventario, '",',
				'"fk_id_usuario":"', IFNULL(NEW.fk_id_usuario, ''), '"',
			'}'
		)
	);
	
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador db_invehin.tr_auditoria_after_insert_pedido
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `tr_auditoria_after_insert_pedido` AFTER INSERT ON `pedido` FOR EACH ROW BEGIN

	INSERT INTO auditoria (
		auditoria.tabla_auditoria,
		auditoria.operacion_auditoria,
		auditoria.idregistro_auditoria,
		auditoria.usuario_auditoria,
		auditoria.fecha_auditoria,
		auditoria.detalleanterior_auditoria,
		auditoria.detallenuevo_auditoria
	)
	VALUES (
		'pedido',
		'INSERT',
		NEW.id_pedido,
		@id_usuario_auditoria, -- recibido desde el backend
		NOW(),
		NULL,
		CONCAT(
			'{',
				'"fecha_pedido":"', NEW.fecha_pedido, '",',
				'"estado_pedido":"', NEW.estado_pedido, '",',
				'"fk_id_proveedor":"', NEW.fk_id_proveedor, '"',
			'}'
		)
	);

END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador db_invehin.tr_auditoria_after_insert_persona
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `tr_auditoria_after_insert_persona` AFTER INSERT ON `persona` FOR EACH ROW BEGIN

	INSERT INTO auditoria (
		auditoria.tabla_auditoria,
		auditoria.operacion_auditoria,
		auditoria.idregistro_auditoria,
		auditoria.usuario_auditoria,
		auditoria.fecha_auditoria,
		auditoria.detalleanterior_auditoria,
		auditoria.detallenuevo_auditoria
	)
	VALUES (
		'persona',
		'INSERT',
		NEW.id_persona,
		@id_usuario_auditoria, -- recibido desde el backend
		NOW(),
		NULL,
		CONCAT(
			'{',
				'"nombres_persona":"', NEW.nombres_persona, '",',
				'"apellidos_persona":"', NEW.apellidos_persona, '",',
				'"numeroidentificacion_persona":"', IFNULL(NEW.numeroidentificacion_persona, ''), '",',
				'"telefono_persona":"', NEW.telefono_persona, '",',
				'"genero_persona":"', IFNULL(NEW.genero_persona, ''), '"',
			'}'
		)
	);

END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador db_invehin.tr_auditoria_after_insert_prenda
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `tr_auditoria_after_insert_prenda` AFTER INSERT ON `prenda` FOR EACH ROW BEGIN

	INSERT INTO auditoria (
		auditoria.tabla_auditoria,
		auditoria.operacion_auditoria,
		auditoria.idregistro_auditoria,
		auditoria.usuario_auditoria,
		auditoria.fecha_auditoria,
		auditoria.detalleanterior_auditoria,
		auditoria.detallenuevo_auditoria
	)
	VALUES (
		'prenda',
		'INSERT',
		NEW.codigo_prenda,
		@id_usuario_auditoria, -- recibido desde el backend
		NOW(),
		NULL,
		CONCAT(
			'{',
				'"codigo_prenda":"', NEW.codigo_prenda, '",',
				'"stock_prenda":"', NEW.stock_prenda, '",',
				'"stockminimo_prenda":"', NEW.stockminimo_prenda, '",',
				'"fk_id_color":"', IFNULL(NEW.fk_id_color, ''), '",',
				'"fk_id_estadoprenda":"', IFNULL(NEW.fk_id_estadoprenda, ''), '",',
				'"fk_id_subcategoria":"', IFNULL(NEW.fk_id_subcategoria, ''), '",',
				'"fk_id_talla":"', IFNULL(NEW.fk_id_talla, ''), '"',
			'}'
		)
	);

END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador db_invehin.tr_auditoria_after_insert_proveedor
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `tr_auditoria_after_insert_proveedor` AFTER INSERT ON `proveedor` FOR EACH ROW BEGIN

	INSERT INTO auditoria (
		auditoria.tabla_auditoria,
		auditoria.operacion_auditoria,
		auditoria.idregistro_auditoria,
		auditoria.usuario_auditoria,
		auditoria.fecha_auditoria,
		auditoria.detalleanterior_auditoria,
		auditoria.detallenuevo_auditoria
	)
	VALUES (
		'proveedor',
		'INSERT',
		NEW.id_proveedor,
		@id_usuario_auditoria, -- recibido desde el backend
		NOW(),
		NULL,
		CONCAT(
			'{',
				'"nombre_proveedor":"', NEW.nombre_proveedor, '",',
				'"direccion_proveedor":"', NEW.direccion_proveedor, '",',
				'"correo_proveedor":"', NEW.correo_proveedor, '",',
				'"estado_proveedor":"', NEW.estado_proveedor, '",',
				'"fk_id_persona":"', NEW.fk_id_persona, '"',
			'}'
		)
	);

END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador db_invehin.tr_auditoria_after_insert_rol
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `tr_auditoria_after_insert_rol` AFTER INSERT ON `rol` FOR EACH ROW BEGIN

	INSERT INTO auditoria (
		auditoria.tabla_auditoria,
		auditoria.operacion_auditoria,
		auditoria.idregistro_auditoria,
		auditoria.usuario_auditoria,
		auditoria.fecha_auditoria,
		auditoria.detalleanterior_auditoria,
		auditoria.detallenuevo_auditoria
	)
	VALUES (
		'rol',
		'INSERT',
		NEW.id_rol,
		@id_usuario_auditoria, -- recibido desde el backend
		NOW(),
		NULL,
		CONCAT(
			'{',
				'"nombre_rol":"', NEW.nombre_rol, '",',
				'"estado_rol":"', NEW.estado_rol, '"',
			'}'
		)
	);

END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador db_invehin.tr_auditoria_after_insert_subcategoria
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `tr_auditoria_after_insert_subcategoria` AFTER INSERT ON `subcategoria` FOR EACH ROW BEGIN

	INSERT INTO auditoria (
		auditoria.tabla_auditoria,
		auditoria.operacion_auditoria,
		auditoria.idregistro_auditoria,
		auditoria.usuario_auditoria,
		auditoria.fecha_auditoria,
		auditoria.detalleanterior_auditoria,
		auditoria.detallenuevo_auditoria
	)
	VALUES (
		'subcategoria',
		'INSERT',
		NEW.id_subcategoria,
		@id_usuario_auditoria, -- recibido desde el backend
		NOW(),
		NULL,
		CONCAT(
			'{',
				'"nombre_subcategoria":"', NEW.nombre_subcategoria, '",',
				'"precio_subcategoria":"', NEW.precio_subcategoria, '",',
				'"imagen_subcategoria":"', IFNULL(NEW.imagen_subcategoria, ''), '",',
				'"estado_subcategoria":"', NEW.estado_subcategoria, '",',
				'"fk_id_categoria":"', NEW.fk_id_categoria, '",',
				'"fk_id_promocion":"', IFNULL(NEW.fk_id_promocion, ''), '"',
			'}'
		)
	);

END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador db_invehin.tr_auditoria_after_insert_usuario
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `tr_auditoria_after_insert_usuario` AFTER INSERT ON `usuario` FOR EACH ROW BEGIN

	INSERT INTO auditoria (
		auditoria.tabla_auditoria,
		auditoria.operacion_auditoria,
		auditoria.idregistro_auditoria,
		auditoria.usuario_auditoria,
		auditoria.fecha_auditoria,
		auditoria.detalleanterior_auditoria,
		auditoria.detallenuevo_auditoria
	)
	VALUES (
		'usuario',
		'INSERT',
		NEW.id_usuario,
		@id_usuario_auditoria, -- recibido desde el backend
		NOW(),
		NULL,
		CONCAT(
			'{',
				'"correo_usuario":"', NEW.correo_usuario, '",',
				'"estado_usuario":"', NEW.estado_usuario, '",',
				'"fk_id_persona":"', NEW.fk_id_persona, '",',
				'"fk_id_rol":"', NEW.fk_id_rol, '"',
			'}'
		)
	);

END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador db_invehin.tr_auditoria_after_insert_venta
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `tr_auditoria_after_insert_venta` AFTER INSERT ON `venta` FOR EACH ROW BEGIN

	INSERT INTO auditoria (
		auditoria.tabla_auditoria,
		auditoria.operacion_auditoria,
		auditoria.idregistro_auditoria,
		auditoria.usuario_auditoria,
		auditoria.fecha_auditoria,
		auditoria.detalleanterior_auditoria,
		auditoria.detallenuevo_auditoria
	)
	VALUES (
		'venta',
		'INSERT',
		NEW.id_venta,
		@id_usuario_auditoria, -- recibido desde el backend
		NOW(),
		NULL,
		CONCAT(
			'{',
				'"fecha_venta":"', DATE_FORMAT(NEW.fecha_venta, '%Y-%m-%d %H:%i:%s'), '",',
				'"montorecibido_venta":"', NEW.montorecibido_venta, '",',
				'"estado_venta":"', NEW.estado_venta, '",',
				'"fk_id_cliente":"', IFNULL(NEW.fk_id_cliente, ''), '",',
				'"fk_id_metodopago":"', IFNULL(NEW.fk_id_metodopago, ''), '",',
				'"fk_id_usuario":"', IFNULL(NEW.fk_id_usuario, ''), '"',
			'}'
		)
	);

END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador db_invehin.tr_auditoria_after_update_categoria
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `tr_auditoria_after_update_categoria` AFTER UPDATE ON `categoria` FOR EACH ROW BEGIN

	INSERT INTO auditoria (
		auditoria.tabla_auditoria,
		auditoria.operacion_auditoria,
		auditoria.idregistro_auditoria,
		auditoria.usuario_auditoria,
		auditoria.fecha_auditoria,
		auditoria.detalleanterior_auditoria,
		auditoria.detallenuevo_auditoria
	)
	VALUES (
		'categoria',
		'UPDATE',
		NEW.id_categoria,
		@id_usuario_auditoria, -- recibido desde el backend
		NOW(),
		CONCAT(
			'{',
				'"id_categoria":"', OLD.id_categoria, '",',
				'"nombre_categoria":"', OLD.nombre_categoria, '",',
				'"estado_categoria":"', OLD.estado_categoria, '"',
			'}'
		),
		CONCAT(
			'{',
				'"id_categoria":"', NEW.id_categoria, '",',
				'"nombre_categoria":"', NEW.nombre_categoria, '",',
				'"estado_categoria":"', NEW.estado_categoria, '"',
			'}'
		)
	);

END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador db_invehin.tr_auditoria_after_update_cliente
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `tr_auditoria_after_update_cliente` AFTER UPDATE ON `cliente` FOR EACH ROW BEGIN

	INSERT INTO auditoria (
		auditoria.tabla_auditoria,
		auditoria.operacion_auditoria,
		auditoria.idregistro_auditoria,
		auditoria.usuario_auditoria,
		auditoria.fecha_auditoria,
		auditoria.detalleanterior_auditoria,
		auditoria.detallenuevo_auditoria
	) 
	VALUES (
		'cliente',
		'UPDATE',
		NEW.id_cliente,
		@id_usuario_auditoria, -- recibido desde el backend
		NOW(),
		CONCAT(
			'{',
				'"id_cliente":"', OLD.id_cliente, '",',
				'"direccion_cliente":"', OLD.direccion_cliente, '",',
				'"fecharegistro_cliente":"', OLD.fecharegistro_cliente, '",',
				'"estado_cliente":"', OLD.estado_cliente, '",',
				'"fk_id_persona":"', OLD.fk_id_persona, '"',
			'}'
		),
		CONCAT(
			'{',
				'"id_cliente":"', NEW.id_cliente, '",',
				'"direccion_cliente":"', NEW.direccion_cliente, '",',
				'"fecharegistro_cliente":"', NEW.fecharegistro_cliente, '",',
				'"estado_cliente":"', NEW.estado_cliente, '",',
				'"fk_id_persona":"', NEW.fk_id_persona, '"',
			'}'
		)
	);

END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador db_invehin.tr_auditoria_after_update_inventario
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `tr_auditoria_after_update_inventario` AFTER UPDATE ON `inventario` FOR EACH ROW BEGIN

	INSERT INTO auditoria (
		auditoria.tabla_auditoria,
		auditoria.operacion_auditoria,
		auditoria.idregistro_auditoria,
		auditoria.usuario_auditoria,
		auditoria.fecha_auditoria,
		auditoria.detalleanterior_auditoria,
		auditoria.detallenuevo_auditoria
	)
	VALUES (
		'inventario',
		'UPDATE',
		NEW.id_inventario,
		@id_usuario_auditoria, -- recibido desde el backend
		NOW(),
		CONCAT(
			'{',
				'"id_inventario":"', OLD.id_inventario, '",',
				'"fecha_inventario":"', OLD.fecha_inventario, '",',
				'"observacion_inventario":"', IFNULL(OLD.observacion_inventario, ''), '",',
				'"estado_inventario":"', OLD.estado_inventario, '",',
				'"fk_id_usuario":"', IFNULL(OLD.fk_id_usuario, ''), '"',
			'}'
		),
		CONCAT(
			'{',
				'"id_inventario":"', NEW.id_inventario, '",',
				'"fecha_inventario":"', NEW.fecha_inventario, '",',
				'"observacion_inventario":"', IFNULL(NEW.observacion_inventario, ''), '",',
				'"estado_inventario":"', NEW.estado_inventario, '",',
				'"fk_id_usuario":"', IFNULL(NEW.fk_id_usuario, ''), '"',
			'}'
		)
	);
	
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador db_invehin.tr_auditoria_after_update_pedido
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `tr_auditoria_after_update_pedido` AFTER UPDATE ON `pedido` FOR EACH ROW BEGIN

	INSERT INTO auditoria (
		auditoria.tabla_auditoria,
		auditoria.operacion_auditoria,
		auditoria.idregistro_auditoria,
		auditoria.usuario_auditoria,
		auditoria.fecha_auditoria,
		auditoria.detalleanterior_auditoria,
		auditoria.detallenuevo_auditoria
	)
	VALUES (
		'pedido',
		'UPDATE',
		NEW.id_pedido,
		@id_usuario_auditoria, -- recibido desde el backend
		NOW(),
		CONCAT(
			'{',
				'"id_pedido":"', OLD.id_pedido, '",',
				'"fecha_pedido":"', OLD.fecha_pedido, '",',
				'"estado_pedido":"', OLD.estado_pedido, '",',
				'"fk_id_proveedor":"', OLD.fk_id_proveedor, '"',
			'}'
		),
		CONCAT(
			'{',
				'"id_pedido":"', NEW.id_pedido, '",',
				'"fecha_pedido":"', NEW.fecha_pedido, '",',
				'"estado_pedido":"', NEW.estado_pedido, '",',
				'"fk_id_proveedor":"', NEW.fk_id_proveedor, '"',
			'}'
		)
	);

END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador db_invehin.tr_auditoria_after_update_persona
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `tr_auditoria_after_update_persona` AFTER UPDATE ON `persona` FOR EACH ROW BEGIN

	INSERT INTO auditoria (
		auditoria.tabla_auditoria,
		auditoria.operacion_auditoria,
		auditoria.idregistro_auditoria,
		auditoria.usuario_auditoria,
		auditoria.fecha_auditoria,
		auditoria.detalleanterior_auditoria,
		auditoria.detallenuevo_auditoria
	)
	VALUES (
		'persona',
		'UPDATE',
		NEW.id_persona,
		@id_usuario_auditoria, -- recibido desde el backend
		NOW(),
		CONCAT(
			'{',
				'"id_persona":"', OLD.id_persona, '",',
				'"nombres_persona":"', OLD.nombres_persona, '",',
				'"apellidos_persona":"', OLD.apellidos_persona, '",',
				'"numeroidentificacion_persona":"', IFNULL(OLD.numeroidentificacion_persona, ''), '",',
				'"telefono_persona":"', OLD.telefono_persona, '",',
				'"genero_persona":"', IFNULL(OLD.genero_persona, ''), '"',
			'}'
		),
		CONCAT(
			'{',
				'"id_persona":"', NEW.id_persona, '",',
				'"nombres_persona":"', NEW.nombres_persona, '",',
				'"apellidos_persona":"', NEW.apellidos_persona, '",',
				'"numeroidentificacion_persona":"', IFNULL(NEW.numeroidentificacion_persona, ''), '",',
				'"telefono_persona":"', NEW.telefono_persona, '",',
				'"genero_persona":"', IFNULL(NEW.genero_persona, ''), '"',
			'}'
		)
	);

END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador db_invehin.tr_auditoria_after_update_prenda
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `tr_auditoria_after_update_prenda` AFTER UPDATE ON `prenda` FOR EACH ROW BEGIN

	INSERT INTO auditoria (
		auditoria.tabla_auditoria,
		auditoria.operacion_auditoria,
		auditoria.idregistro_auditoria,
		auditoria.usuario_auditoria,
		auditoria.fecha_auditoria,
		auditoria.detalleanterior_auditoria,
		auditoria.detallenuevo_auditoria
	)
	VALUES (
		'prenda',
		'UPDATE',
		NEW.codigo_prenda,
		@id_usuario_auditoria, -- recibido desde el backend
		NOW(),
		CONCAT(
			'{',
				'"codigo_prenda":"', OLD.codigo_prenda, '",',
				'"stock_prenda":"', OLD.stock_prenda, '",',
				'"stockminimo_prenda":"', OLD.stockminimo_prenda, '",',
				'"fk_id_color":"', IFNULL(OLD.fk_id_color, ''), '",',
				'"fk_id_estadoprenda":"', IFNULL(OLD.fk_id_estadoprenda, ''), '",',
				'"fk_id_subcategoria":"', IFNULL(OLD.fk_id_subcategoria, ''), '",',
				'"fk_id_talla":"', IFNULL(OLD.fk_id_talla, ''), '"',
			'}'
		),
		CONCAT(
			'{',
				'"codigo_prenda":"', NEW.codigo_prenda, '",',
				'"stock_prenda":"', NEW.stock_prenda, '",',
				'"stockminimo_prenda":"', NEW.stockminimo_prenda, '",',
				'"fk_id_color":"', IFNULL(NEW.fk_id_color, ''), '",',
				'"fk_id_estadoprenda":"', IFNULL(NEW.fk_id_estadoprenda, ''), '",',
				'"fk_id_subcategoria":"', IFNULL(NEW.fk_id_subcategoria, ''), '",',
				'"fk_id_talla":"', IFNULL(NEW.fk_id_talla, ''), '"',
			'}'
		)
	);

END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador db_invehin.tr_auditoria_after_update_rol
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `tr_auditoria_after_update_rol` AFTER UPDATE ON `rol` FOR EACH ROW BEGIN

	INSERT INTO auditoria (
		auditoria.tabla_auditoria,
		auditoria.operacion_auditoria,
		auditoria.idregistro_auditoria,
		auditoria.usuario_auditoria,
		auditoria.fecha_auditoria,
		auditoria.detalleanterior_auditoria,
		auditoria.detallenuevo_auditoria
	)
	VALUES (
		'rol',
		'UPDATE',
		NEW.id_rol,
		@id_usuario_auditoria, -- recibido desde el backend
		NOW(),
		CONCAT(
			'{',
				'"id_rol":"', OLD.id_rol, '",',
				'"nombre_rol":"', OLD.nombre_rol, '",',
				'"estado_rol":"', OLD.estado_rol, '"',
			'}'
		),
		CONCAT(
			'{',
				'"id_rol":"', NEW.id_rol, '",',
				'"nombre_rol":"', NEW.nombre_rol, '",',
				'"estado_rol":"', NEW.estado_rol, '"',
			'}'
		)
	);

END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador db_invehin.tr_auditoria_after_update_subcategoria
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `tr_auditoria_after_update_subcategoria` AFTER UPDATE ON `subcategoria` FOR EACH ROW BEGIN

	INSERT INTO auditoria (
		auditoria.tabla_auditoria,
		auditoria.operacion_auditoria,
		auditoria.idregistro_auditoria,
		auditoria.usuario_auditoria,
		auditoria.fecha_auditoria,
		auditoria.detalleanterior_auditoria,
		auditoria.detallenuevo_auditoria
	)
	VALUES (
		'subcategoria',
		'UPDATE',
		NEW.id_subcategoria,
		@id_usuario_auditoria, -- recibido desde el backend
		NOW(),
		CONCAT(
			'{',
				'"id_subcategoria":"', OLD.id_subcategoria, '",',
				'"nombre_subcategoria":"', OLD.nombre_subcategoria, '",',
				'"precio_subcategoria":"', OLD.precio_subcategoria, '",',
				'"imagen_subcategoria":"', IFNULL(OLD.imagen_subcategoria, ''), '",',
				'"estado_subcategoria":"', OLD.estado_subcategoria, '",',
				'"fk_id_categoria":"', OLD.fk_id_categoria, '",',
				'"fk_id_promocion":"', IFNULL(OLD.fk_id_promocion, ''), '"',
			'}'
		),
		CONCAT(
			'{',
				'"id_subcategoria":"', NEW.id_subcategoria, '",',
				'"nombre_subcategoria":"', NEW.nombre_subcategoria, '",',
				'"precio_subcategoria":"', NEW.precio_subcategoria, '",',
				'"imagen_subcategoria":"', IFNULL(NEW.imagen_subcategoria, ''), '",',
				'"estado_subcategoria":"', NEW.estado_subcategoria, '",',
				'"fk_id_categoria":"', NEW.fk_id_categoria, '",',
				'"fk_id_promocion":"', IFNULL(NEW.fk_id_promocion, ''), '"',
			'}'
		)
	);

END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador db_invehin.tr_auditoria_after_update_usuario
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `tr_auditoria_after_update_usuario` AFTER UPDATE ON `usuario` FOR EACH ROW BEGIN

	INSERT INTO auditoria (
		auditoria.tabla_auditoria,
		auditoria.operacion_auditoria,
		auditoria.idregistro_auditoria,
		auditoria.usuario_auditoria,
		auditoria.fecha_auditoria,
		auditoria.detalleanterior_auditoria,
		auditoria.detallenuevo_auditoria
	)
	VALUES (
		'usuario',
		'UPDATE',
		NEW.id_usuario,
		@id_usuario_auditoria, -- recibido desde el backend
		NOW(),
		CONCAT(
			'{',
				'"id_usuario":"', OLD.id_usuario, '",',
				'"correo_usuario":"', OLD.correo_usuario, '",',
				'"estado_usuario":"', OLD.estado_usuario, '",',
				'"fk_id_persona":"', OLD.fk_id_persona, '",',
				'"fk_id_rol":"', OLD.fk_id_rol, '"',
			'}'
		),
		CONCAT(
			'{',
				'"id_usuario":"', NEW.id_usuario, '",',
				'"correo_usuario":"', NEW.correo_usuario, '",',
				'"estado_usuario":"', NEW.estado_usuario, '",',
				'"fk_id_persona":"', NEW.fk_id_persona, '",',
				'"fk_id_rol":"', NEW.fk_id_rol, '"',
			'}'
		)
	);

END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador db_invehin.tr_auditoria_after_update_venta
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `tr_auditoria_after_update_venta` AFTER UPDATE ON `venta` FOR EACH ROW BEGIN

	INSERT INTO auditoria (
		auditoria.tabla_auditoria,
		auditoria.operacion_auditoria,
		auditoria.idregistro_auditoria,
		auditoria.usuario_auditoria,
		auditoria.fecha_auditoria,
		auditoria.detalleanterior_auditoria,
		auditoria.detallenuevo_auditoria
	)
	VALUES (
		'venta',
		'UPDATE',
		NEW.id_venta,
		@id_usuario_auditoria, -- recibido desde el backend
		NOW(),
		CONCAT(
			'{',
				'"id_venta":"', OLD.id_venta, '",',
				'"fecha_venta":"', DATE_FORMAT(OLD.fecha_venta, '%Y-%m-%d %H:%i:%s'), '",',
				'"montorecibido_venta":"', OLD.montorecibido_venta, '",',
				'"estado_venta":"', OLD.estado_venta, '",',
				'"fk_id_cliente":"', IFNULL(OLD.fk_id_cliente, ''), '",',
				'"fk_id_metodopago":"', IFNULL(OLD.fk_id_metodopago, ''), '",',
				'"fk_id_usuario":"', IFNULL(OLD.fk_id_usuario, ''), '"',
			'}'
		),
		CONCAT(
			'{',
				'"id_venta":"', NEW.id_venta, '",',
				'"fecha_venta":"', DATE_FORMAT(NEW.fecha_venta, '%Y-%m-%d %H:%i:%s'), '",',
				'"montorecibido_venta":"', NEW.montorecibido_venta, '",',
				'"estado_venta":"', NEW.estado_venta, '",',
				'"fk_id_cliente":"', IFNULL(NEW.fk_id_cliente, ''), '",',
				'"fk_id_metodopago":"', IFNULL(NEW.fk_id_metodopago, ''), '",',
				'"fk_id_usuario":"', IFNULL(NEW.fk_id_usuario, ''), '"',
			'}'
		)
	);

END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador db_invehin.tr_detallepedido_after_insert
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `tr_detallepedido_after_insert` AFTER INSERT ON `detallepedido` FOR EACH ROW BEGIN

	UPDATE
		prenda p
	SET
		p.stock_prenda = p.stock_prenda + NEW.cantidad_detallepedido
	WHERE
		p.codigo_prenda = NEW.fk_codigo_prenda;

END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador db_invehin.tr_detalleventa_after_insert
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `tr_detalleventa_after_insert` AFTER INSERT ON `detalleventa` FOR EACH ROW BEGIN

	UPDATE
		prenda p
	SET
		p.stock_prenda = p.stock_prenda - NEW.cantidad_detalleventa
	WHERE
		p.codigo_prenda = NEW.fk_codigo_prenda;

END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador db_invehin.tr_update_after_delete_prenda
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `tr_update_after_delete_prenda` AFTER DELETE ON `prenda` FOR EACH ROW BEGIN

	INSERT INTO auditoria (
		auditoria.tabla_auditoria,
		auditoria.operacion_auditoria,
		auditoria.idregistro_auditoria,
		auditoria.usuario_auditoria,
		auditoria.fecha_auditoria,
		auditoria.detalleanterior_auditoria,
		auditoria.detallenuevo_auditoria
	)
	VALUES (
		'prenda',
		'DELETE',
		OLD.codigo_prenda,
		@id_usuario_auditoria, -- recibido desde el backend
		NOW(),
		CONCAT(
			'{',
				'"codigo_prenda":"', OLD.codigo_prenda, '",',
				'"stock_prenda":"', OLD.stock_prenda, '",',
				'"stockminimo_prenda":"', OLD.stockminimo_prenda, '",',
				'"fk_id_color":"', IFNULL(OLD.fk_id_color, ''), '",',
				'"fk_id_estadoprenda":"', IFNULL(OLD.fk_id_estadoprenda, ''), '",',
				'"fk_id_subcategoria":"', IFNULL(OLD.fk_id_subcategoria, ''), '",',
				'"fk_id_talla":"', IFNULL(OLD.fk_id_talla, ''), '"',
			'}'
		),
		NULL
	);

END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Eliminando tabla temporal y crear estructura final de VIEW
DROP TABLE IF EXISTS `view_cliente`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_cliente` AS select `c`.`id_cliente` AS `id`,`c`.`fecharegistro_cliente` AS `fecha_registro`,`c`.`direccion_cliente` AS `direccion`,`c`.`estado_cliente` AS `estado`,`p`.`id_persona` AS `persona_id`,`p`.`nombres_persona` AS `nombres`,`p`.`apellidos_persona` AS `apellidos`,`p`.`numeroidentificacion_persona` AS `numero_identificacion`,`p`.`telefono_persona` AS `telefono`,`p`.`genero_persona` AS `genero` from (`cliente` `c` join `persona` `p` on((`c`.`fk_id_persona` = `p`.`id_persona`))) order by `p`.`nombres_persona`,`p`.`apellidos_persona`;

-- Eliminando tabla temporal y crear estructura final de VIEW
DROP TABLE IF EXISTS `view_pedido`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_pedido` AS select `p`.`id_pedido` AS `id`,`p`.`fecha_pedido` AS `fecha`,`p`.`estado_pedido` AS `estado`,`pr`.`id_proveedor` AS `proveedor_id`,`pr`.`nombre_proveedor` AS `proveedor_nombre` from (`pedido` `p` join `proveedor` `pr` on((`p`.`fk_id_proveedor` = `pr`.`id_proveedor`)));

-- Eliminando tabla temporal y crear estructura final de VIEW
DROP TABLE IF EXISTS `view_prenda`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_prenda` AS select `p`.`codigo_prenda` AS `codigo`,`p`.`stock_prenda` AS `stock`,`p`.`stockminimo_prenda` AS `stock_minimo`,`p`.`fk_id_color` AS `color_id`,`c`.`nombre_color` AS `color_nombre`,`p`.`fk_id_talla` AS `talla_id`,`t`.`nombre_talla` AS `talla_nombre`,`p`.`fk_id_estadoprenda` AS `estadoprenda_id`,`ep`.`nombre_estadoprenda` AS `estadoprenda_nombre`,`p`.`fk_id_subcategoria` AS `subcategoria_id`,`s`.`nombre_subcategoria` AS `subcategoria_nombre`,`s`.`precio_subcategoria` AS `subcategoria_precio`,`s`.`imagen_subcategoria` AS `subcategoria_imagen`,`s`.`estado_subcategoria` AS `subcategoria_estado`,`s`.`fk_id_categoria` AS `categoria_id`,`ca`.`nombre_categoria` AS `categoria_nombre`,`ca`.`estado_categoria` AS `categoria_estado`,`s`.`fk_id_promocion` AS `promocion_id`,`pr`.`porcentaje_promocion` AS `promocion_porcentaje`,`pr`.`fechainicio_promocion` AS `promocion_fechainicio`,`pr`.`fechafin_promocion` AS `promocion_fechafin` from ((((((`prenda` `p` join `color` `c` on((`p`.`fk_id_color` = `c`.`id_color`))) join `estadoprenda` `ep` on((`p`.`fk_id_estadoprenda` = `ep`.`id_estadoprenda`))) join `talla` `t` on((`p`.`fk_id_talla` = `t`.`id_talla`))) join `subcategoria` `s` on((`p`.`fk_id_subcategoria` = `s`.`id_subcategoria`))) join `categoria` `ca` on((`s`.`fk_id_categoria` = `ca`.`id_categoria`))) left join `promocion` `pr` on((`s`.`fk_id_promocion` = `pr`.`id_promocion`)));

-- Eliminando tabla temporal y crear estructura final de VIEW
DROP TABLE IF EXISTS `view_proveedor`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_proveedor` AS select `pr`.`id_proveedor` AS `id`,`pr`.`nombre_proveedor` AS `nombre`,`pr`.`direccion_proveedor` AS `direccion`,`pr`.`correo_proveedor` AS `correo`,`pr`.`estado_proveedor` AS `estado`,`p`.`id_persona` AS `persona_id`,`p`.`nombres_persona` AS `persona_nombres`,`p`.`apellidos_persona` AS `persona_apellidos`,`p`.`numeroidentificacion_persona` AS `persona_numero_identificacion`,`p`.`telefono_persona` AS `persona_telefono`,`p`.`genero_persona` AS `persona_genero` from (`proveedor` `pr` join `persona` `p` on((`pr`.`fk_id_persona` = `p`.`id_persona`))) order by `pr`.`nombre_proveedor`;

-- Eliminando tabla temporal y crear estructura final de VIEW
DROP TABLE IF EXISTS `view_usuario`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_usuario` AS select `u`.`id_usuario` AS `id`,`u`.`correo_usuario` AS `correo`,`u`.`contrasenia_usuario` AS `contrasenia`,`u`.`estado_usuario` AS `estado`,`u`.`fk_id_rol` AS `rol_id`,`r`.`nombre_rol` AS `rol_nombre`,`r`.`estado_rol` AS `rol_estado`,`p`.`id_persona` AS `persona_id`,`p`.`nombres_persona` AS `nombres`,`p`.`apellidos_persona` AS `apellidos`,`p`.`numeroidentificacion_persona` AS `numero_identificacion`,`p`.`telefono_persona` AS `telefono`,`p`.`genero_persona` AS `genero` from ((`usuario` `u` join `persona` `p` on((`u`.`fk_id_persona` = `p`.`id_persona`))) join `rol` `r` on((`u`.`fk_id_rol` = `r`.`id_rol`))) order by `u`.`correo_usuario`;

-- Eliminando tabla temporal y crear estructura final de VIEW
DROP TABLE IF EXISTS `view_venta`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_venta` AS select `v`.`id_venta` AS `id`,`v`.`fecha_venta` AS `fecha`,`v`.`montorecibido_venta` AS `monto_recibido`,`v`.`estado_venta` AS `estado`,`v`.`fk_id_metodopago` AS `metodopago_id`,`mp`.`nombre_metodopago` AS `metodopago_nombre`,`mp`.`estado_metodopago` AS `metodopago_estado`,`v`.`fk_id_cliente` AS `cliente_id`,`p`.`id_persona` AS `persona_id`,`p`.`nombres_persona` AS `persona_nombres`,`p`.`apellidos_persona` AS `persona_apellidos`,`p`.`numeroidentificacion_persona` AS `persona_numero_identificacion`,`p`.`telefono_persona` AS `persona_telefono`,`p`.`genero_persona` AS `persona_genero`,`c`.`fecharegistro_cliente` AS `cliente_fecha_registro`,`c`.`direccion_cliente` AS `cliente_direccion`,`c`.`estado_cliente` AS `cliente_estado`,`v`.`fk_id_usuario` AS `usuario_id` from (((`venta` `v` join `cliente` `c` on((`v`.`fk_id_cliente` = `c`.`id_cliente`))) join `persona` `p` on((`c`.`fk_id_persona` = `p`.`id_persona`))) join `metodopago` `mp` on((`v`.`fk_id_metodopago` = `mp`.`id_metodopago`))) order by `v`.`fecha_venta` desc,`p`.`nombres_persona`,`p`.`apellidos_persona`;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
