-- phpMyAdmin SQL Dump
-- version 4.9.1
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost
-- Tiempo de generación: 07-07-2026 a las 14:58:01
-- Versión del servidor: 8.0.17
-- Versión de PHP: 7.3.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `floreria_primavera`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categorias`
--

CREATE TABLE `categorias` (
  `id_categoria` int(11) NOT NULL,
  `nombre` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `estado` tinyint(1) NOT NULL DEFAULT '1',
  `permite_dedicatoria` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 = permite dedicatoria, 0 = no (ej. Peluches, Chocolates, Globos)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `categorias`
--

INSERT INTO `categorias` (`id_categoria`, `nombre`, `descripcion`, `estado`, `permite_dedicatoria`) VALUES
(1, 'Ramos', 'Ramos florales sencillos para toda ocasión', 1, 1),
(2, 'Arreglos', 'Arreglos florales decorativos en base de cartón, cerámica o canasta', 1, 1),
(3, 'Peluches', 'Peluches para acompañar regalos florales', 1, 0),
(4, 'Chocolates', 'Cajas y detalles de chocolate', 1, 0),
(5, 'Globos', 'Globos personalizados para celebraciones', 1, 0),
(6, 'Accesorios Adicionales', 'Accesorios adicionales para agregar a arreglos o ramos', 1, 0),
(7, 'Flores Individuales', 'Flores hechas a mano con cinta satinada', 1, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clientes`
--

CREATE TABLE `clientes` (
  `id_cliente` int(11) NOT NULL,
  `nombres` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `apellidos` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `correo` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `contrasena` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `telefono` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `distrito` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rol` enum('usuario','admin') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'usuario',
  `fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `clientes`
--

INSERT INTO `clientes` (`id_cliente`, `nombres`, `apellidos`, `correo`, `contrasena`, `telefono`, `distrito`, `rol`, `fecha_registro`) VALUES
(1, 'Admin', 'Primavera', 'admin@floreriaprimavera.com', 'admin', '999888777', NULL, 'admin', '2026-06-23 00:44:15'),
(2, 'María', 'García López', 'maria@gmail.com', 'maria', '987654321', 'Surco', 'usuario', '2026-06-23 00:44:15'),
(3, 'Karla', 'Santos', 'karla@gmail.com', 'karla', '999999999', 'San Bartolo', 'usuario', '2026-06-28 17:19:33'),
(4, 'Daniel', 'CS', 'daniel@gmail.com', 'daniel', '963215847', 'Santa Maria', 'usuario', '2026-07-02 19:14:45'),
(5, 'Sheril', 'H', 'sheril@gmail.com', 'sheril', '929845630', 'VMT', 'usuario', '2026-07-05 22:38:22'),
(6, 'Jhadira', 'C', 'jhadira@gmail.com', 'jhadira', '987654321', 'VES', 'usuario', '2026-07-05 22:42:10'),
(7, 'Yanet', 'P', 'yanet@gmail.com', 'yanet', '123456789', 'Los Olivos', 'usuario', '2026-07-05 22:43:00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_pedido`
--

CREATE TABLE `detalle_pedido` (
  `id_detalle` int(11) NOT NULL,
  `id_pedido` int(11) NOT NULL,
  `id_producto` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `precio_unitario` decimal(10,2) NOT NULL,
  `subtotal` decimal(10,2) NOT NULL,
  `dedicatoria` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Mensaje de dedicatoria para este producto (solo si la categoría lo permite)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `detalle_pedido`
--

INSERT INTO `detalle_pedido` (`id_detalle`, `id_pedido`, `id_producto`, `cantidad`, `precio_unitario`, `subtotal`, `dedicatoria`) VALUES
(1, 1, 4, 1, '90.00', '90.00', NULL),
(2, 1, 8, 3, '75.00', '225.00', NULL),
(3, 2, 11, 1, '38.00', '38.00', NULL),
(4, 3, 9, 1, '45.00', '45.00', NULL),
(5, 4, 11, 1, '38.00', '38.00', NULL),
(6, 5, 13, 1, '42.00', '42.00', NULL),
(7, 6, 13, 1, '42.00', '42.00', NULL),
(8, 7, 22, 1, '12.00', '12.00', NULL),
(9, 7, 7, 1, '30.00', '30.00', NULL),
(10, 8, 10, 1, '35.00', '35.00', NULL),
(11, 9, 11, 1, '38.00', '38.00', NULL),
(12, 10, 9, 1, '45.00', '45.00', NULL),
(13, 11, 1, 1, '55.00', '55.00', NULL),
(14, 12, 10, 1, '35.00', '35.00', 'Feliz cumple!! Mi hermosa hijita'),
(15, 13, 6, 1, '40.00', '40.00', NULL),
(16, 13, 25, 1, '48.00', '48.00', 'Feliz cumpleaños mi reina'),
(17, 14, 17, 1, '35.00', '35.00', NULL),
(18, 14, 24, 1, '4.50', '4.50', NULL),
(19, 14, 1, 1, '55.00', '55.00', 'Mi hermosa hijita'),
(20, 15, 10, 1, '35.00', '35.00', NULL),
(21, 16, 1, 1, '55.00', '55.00', NULL),
(22, 17, 19, 1, '52.00', '52.00', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pedidos`
--

CREATE TABLE `pedidos` (
  `id_pedido` int(11) NOT NULL,
  `id_cliente` int(11) NOT NULL,
  `fecha_pedido` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `total` decimal(10,2) NOT NULL,
  `estado` enum('Pendiente','Preparando','Enviado','Entregado','Cancelado') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Pendiente',
  `metodo_pago` enum('Yape','Plin','Tarjeta','Efectivo') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Efectivo',
  `comprobante_pago` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Nombre del archivo de imagen del comprobante (Yape/Plin), guardado en assets/img/comprobantes/',
  `direccion_entrega` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `observaciones` text COLLATE utf8mb4_unicode_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `pedidos`
--

INSERT INTO `pedidos` (`id_pedido`, `id_cliente`, `fecha_pedido`, `total`, `estado`, `metodo_pago`, `comprobante_pago`, `direccion_entrega`, `observaciones`) VALUES
(1, 3, '2026-06-28 18:27:22', '315.00', 'Entregado', 'Yape', NULL, 'Av', NULL),
(2, 2, '2026-06-28 18:33:31', '38.00', 'Entregado', 'Tarjeta', NULL, 'Calle surco', NULL),
(3, 3, '2026-06-28 18:40:03', '45.00', 'Cancelado', 'Efectivo', NULL, 'Av.san jose', NULL),
(4, 3, '2026-07-01 21:58:47', '38.00', 'Entregado', 'Efectivo', NULL, 'santa maria', NULL),
(5, 3, '2026-07-01 21:59:45', '42.00', 'Entregado', 'Yape', NULL, 'santa maria', NULL),
(6, 3, '2026-07-02 18:39:22', '42.00', 'Cancelado', 'Yape', NULL, 'Las Orquideas 28', NULL),
(7, 2, '2026-07-02 18:47:19', '42.00', 'Entregado', 'Plin', NULL, 'SJM Mz A lt 2', NULL),
(8, 2, '2026-07-02 18:57:23', '35.00', 'Cancelado', 'Plin', NULL, 'Javier Perez de Cuellar N 2', NULL),
(9, 4, '2026-07-02 19:15:45', '38.00', 'Entregado', 'Yape', '8516be04-f91a-4c43-8f69-ee0d0a49b283.jpeg', 'Av. santa maria', NULL),
(10, 3, '2026-07-02 19:38:06', '45.00', 'Entregado', 'Yape', '61dc1f8d-7688-47e4-93e3-ed7142d88637.jpeg', 'mz ', NULL),
(11, 4, '2026-07-03 11:34:38', '55.00', 'Cancelado', 'Efectivo', NULL, 'VES', NULL),
(12, 2, '2026-07-03 11:54:54', '35.00', 'Entregado', 'Efectivo', NULL, 'Surco #236', NULL),
(13, 4, '2026-07-03 14:27:54', '79.20', 'Entregado', 'Efectivo', NULL, 'Miraflores, DPTO #2', '[Entrega: 2026-07-04T14:27]'),
(14, 3, '2026-07-03 23:53:20', '109.50', 'Entregado', 'Yape', 'e2a1d7f8-a8b6-4b9f-ad7c-19c6e7466bef.jpg', 'Villa El Salvador, Av. central', '[Entrega: 2026-07-06T14:50] [Personalización: rosas rosadas y blancas]'),
(15, 5, '2026-07-07 02:12:14', '50.00', 'Preparando', 'Efectivo', NULL, 'Villa María del Triunfo, 815', ''),
(16, 5, '2026-07-07 02:13:14', '60.00', 'Enviado', 'Yape', '696235ee-8afa-42be-b434-f15ea9e1424d.jpg', 'Magdalena del Mar, 87', ''),
(17, 5, '2026-07-07 09:01:02', '67.00', 'Pendiente', 'Yape', 'd15970fc-3c4b-42f8-8a5a-f351ba3a4b0a.jpg', 'Villa María del Triunfo, 569', '');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE `productos` (
  `id_producto` int(11) NOT NULL,
  `id_categoria` int(11) NOT NULL,
  `nombre` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `precio` decimal(10,2) NOT NULL,
  `stock` int(11) NOT NULL DEFAULT '0',
  `imagen` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT 'sin-imagen.jpg',
  `estado` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`id_producto`, `id_categoria`, `nombre`, `descripcion`, `precio`, `stock`, `imagen`, `estado`, `fecha_registro`) VALUES
(1, 1, 'Ramo de Rosas Rojas x12', 'Doce rosas rojas frescas con follaje y lazo de satén', '55.00', 17, '5137158b-d0ee-4795-83c1-06e71ecad0ca.jpg', 1, '2026-06-23 00:44:15'),
(2, 1, 'Ramo Girasoles Alegría', 'Diez girasoles frescos con papel coreano decorativo', '45.00', 25, '894133d5-3625-4c08-83d7-99bda534e619.jpg', 1, '2026-06-23 00:44:15'),
(3, 2, 'Arreglo Floral', 'Rosas en caja circular temática', '35.00', 5, 'IMG_20250507_124858.jpg', 1, '2026-06-23 00:44:15'),
(4, 2, 'Arreglo Amor Eterno', 'Rosas blancas y rojas en malla decorativa', '90.00', 7, 'IMG_20250304_150901.jpg', 1, '2026-06-23 00:44:15'),
(5, 3, 'Oso de Peluche Mediano', 'Peluche de 30cm, ideal para acompañar un ramo', '35.00', 30, 'oso.jpg', 1, '2026-06-23 00:44:15'),
(6, 4, 'Caja de Ferrero Rocher Premiun', 'Caja surtida de bombones finos, 12 piezas', '40.00', 17, 'ferrero.jpg', 1, '2026-06-23 00:44:15'),
(7, 5, 'Set de Globos Cumpleaños', 'Globos metálicos con helio', '30.00', 21, 'set-globos-feliz-cumpleanos-azul-con-corona.jpg', 1, '2026-06-23 00:44:15'),
(8, 2, 'Arreglo Graduación', 'Arreglo con birrete decorativo, rosas', '75.00', 9, 'IMG_20251219_102610.jpg', 1, '2026-06-23 00:44:15'),
(9, 2, 'Caja Corazón', '6 Rosas y un girasol en caja forma de corazón', '45.00', 18, 'Caja corazon.jpg', 1, '2026-06-23 00:44:15'),
(10, 1, 'Ramo Barbie', '', '35.00', 12, 'Ramo Barbie.jpg', 1, '2026-06-23 00:44:15'),
(11, 1, 'Ramo Dragon Ball', '', '38.00', 7, 'Ramo Dragon Ball.jpg', 1, '2026-06-23 00:44:15'),
(12, 1, 'Ramo Girasol', '3 girasoles con lazo', '52.00', 10, 'IMG_20250328_163027.jpg', 1, '2026-06-23 00:44:15'),
(13, 1, 'Tulipanes', '4 tulipanes con lazo de cinta', '42.00', 8, '7b194c98-b391-4791-9acc-3aa654974fa3.jpg', 1, '2026-06-23 00:44:15'),
(14, 1, 'Messi', 'Rosas celestes', '48.00', 9, 'IMG_20241021_164811-EDIT.jpg', 1, '2026-06-28 18:38:53'),
(15, 3, 'Cerdito de Peluche Mediano', 'Cerdito de 30cm', '35.00', 2, 'cerdita.jpg', 1, '2026-07-01 22:33:58'),
(16, 3, 'Vaquita de Peluche', 'Vaquita de 30cm', '35.00', 20, 'vaquita.jpg', 1, '2026-07-01 22:35:07'),
(17, 3, 'Hello Kitty Peluche Mediano', 'Hello Kitty Peluche 30cm', '35.00', 19, 'peluche-hello-kitty-morango-30cm.jpg', 1, '2026-07-01 22:37:01'),
(18, 3, 'Cinnamonroll Graduado Peluche Mediano', 'cinnamonroll30cm', '38.00', 10, 't-plush-grad-cinnamonroll30cm-1.jpg', 1, '2026-07-01 22:38:45'),
(19, 5, 'Set de Globos Personalizable', 'Globos cumpleañeros de helio', '52.00', 9, 'globo personalizd.jpg', 1, '2026-07-01 22:44:00'),
(20, 6, 'Carritos Hot Wheels', 'Carritos Hot Wheels x1', '35.00', 10, '71V7XF20XZL._AC_SL1500_.jpg', 1, '2026-07-01 22:50:19'),
(21, 7, 'Girasol Mediano', 'Girasol con 16 pétalos', '15.00', 500, 'IMG_20240730_223447.jpg', 1, '2026-07-01 23:12:44'),
(22, 7, 'Rosa Mediana', 'Rosa individual', '12.00', 599, 'IMG_20240808_100938.jpg', 1, '2026-07-01 23:16:11'),
(23, 6, 'Corona de Metal Plateada', 'Corona Plateada', '4.50', 200, 'coronas.jpg', 1, '2026-07-01 23:23:30'),
(24, 6, 'Corona de Metal Dorada', 'Corona Dorada', '4.50', 199, 'coronas.jpg', 1, '2026-07-01 23:26:21'),
(25, 1, 'Ramo Stitch', 'Rosas con imagenes de Stitch', '48.00', 0, 'Ramo Stitch.jpg', 1, '2026-07-03 14:04:00'),
(26, 1, 'Rosas Primavera', '7 Rosas Amarillas + mariposa + lazo', '48.00', 7, 'a8f250ca-cd5a-4b62-882d-346ef7696132.jpg', 1, '2026-07-03 17:27:57'),
(27, 1, 'Ramo Celestial', 'Rosas celestes con azul', '45.00', 20, '650b6351-c130-4dfd-829e-92046e8c8a6b.jpg', 1, '2026-07-04 00:00:09');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `categorias`
--
ALTER TABLE `categorias`
  ADD PRIMARY KEY (`id_categoria`);

--
-- Indices de la tabla `clientes`
--
ALTER TABLE `clientes`
  ADD PRIMARY KEY (`id_cliente`),
  ADD UNIQUE KEY `correo` (`correo`);

--
-- Indices de la tabla `detalle_pedido`
--
ALTER TABLE `detalle_pedido`
  ADD PRIMARY KEY (`id_detalle`),
  ADD KEY `fk_detalle_pedido` (`id_pedido`),
  ADD KEY `fk_detalle_producto` (`id_producto`);

--
-- Indices de la tabla `pedidos`
--
ALTER TABLE `pedidos`
  ADD PRIMARY KEY (`id_pedido`),
  ADD KEY `fk_pedido_cliente` (`id_cliente`);

--
-- Indices de la tabla `productos`
--
ALTER TABLE `productos`
  ADD PRIMARY KEY (`id_producto`),
  ADD KEY `fk_prod_categoria` (`id_categoria`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `categorias`
--
ALTER TABLE `categorias`
  MODIFY `id_categoria` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `clientes`
--
ALTER TABLE `clientes`
  MODIFY `id_cliente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `detalle_pedido`
--
ALTER TABLE `detalle_pedido`
  MODIFY `id_detalle` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT de la tabla `pedidos`
--
ALTER TABLE `pedidos`
  MODIFY `id_pedido` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `id_producto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `detalle_pedido`
--
ALTER TABLE `detalle_pedido`
  ADD CONSTRAINT `fk_detalle_pedido` FOREIGN KEY (`id_pedido`) REFERENCES `pedidos` (`id_pedido`),
  ADD CONSTRAINT `fk_detalle_producto` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`);

--
-- Filtros para la tabla `pedidos`
--
ALTER TABLE `pedidos`
  ADD CONSTRAINT `fk_pedido_cliente` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id_cliente`);

--
-- Filtros para la tabla `productos`
--
ALTER TABLE `productos`
  ADD CONSTRAINT `fk_prod_categoria` FOREIGN KEY (`id_categoria`) REFERENCES `categorias` (`id_categoria`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
