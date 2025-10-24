/*
SQLyog Ultimate v13.1.1 (64 bit)
MySQL - 8.0.43 : Database - final_analisis
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`final_analisis` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `final_analisis`;

/*Table structure for table `accounts_role` */

DROP TABLE IF EXISTS `accounts_role`;

CREATE TABLE `accounts_role` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(32) NOT NULL,
  `name` varchar(64) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_role_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `accounts_role` */

insert  into `accounts_role`(`id`,`code`,`name`) values 
(1,'ADMIN','Administrador'),
(2,'HQ_OPERATOR','Operador Sede'),
(3,'DISTRIBUTOR','Distribuidor'),
(4,'RETAILER','Retailer'),
(5,'WAREHOUSE_OP','Operador Almacén');

/*Table structure for table `accounts_user` */

DROP TABLE IF EXISTS `accounts_user`;

CREATE TABLE `accounts_user` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(150) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(128) NOT NULL,
  `first_name` varchar(150) NOT NULL DEFAULT '',
  `last_name` varchar(150) NOT NULL DEFAULT '',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `is_staff` tinyint(1) NOT NULL DEFAULT '0',
  `is_superuser` tinyint(1) NOT NULL DEFAULT '0',
  `last_login` datetime DEFAULT NULL,
  `date_joined` datetime NOT NULL,
  `distributor_id` bigint unsigned DEFAULT NULL,
  `retailer_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_user_username` (`username`),
  UNIQUE KEY `uq_user_email` (`email`),
  KEY `accounts_user_distributor_id_f3263ce4_fk_partners_distributor_id` (`distributor_id`),
  KEY `accounts_user_retailer_id_939d72ed_fk_partners_retailer_id` (`retailer_id`),
  CONSTRAINT `accounts_user_distributor_id_f3263ce4_fk_partners_distributor_id` FOREIGN KEY (`distributor_id`) REFERENCES `partners_distributor` (`id`),
  CONSTRAINT `accounts_user_retailer_id_939d72ed_fk_partners_retailer_id` FOREIGN KEY (`retailer_id`) REFERENCES `partners_retailer` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `accounts_user` */

insert  into `accounts_user`(`id`,`username`,`email`,`password`,`first_name`,`last_name`,`is_active`,`is_staff`,`is_superuser`,`last_login`,`date_joined`,`distributor_id`,`retailer_id`) values 
(1,'admin','admin@example.com','pbkdf2_sha256$1000000$hIt5PRseEk4czAT1qM20PG$PdRxOk5VDaaWO69U5/tuARz6tpuMjhigw3IZowmX1z4=','System','Admin',1,1,1,'2025-10-24 01:50:59','2025-10-19 09:00:00',NULL,NULL),
(2,'hq.op','hq.op@example.com','test123','HQ','Operator',1,1,0,NULL,'2025-10-19 09:10:00',NULL,NULL),
(3,'dist.li','dist.li@example.com','test123','Li','Wei',1,0,0,NULL,'2025-10-19 09:15:00',NULL,NULL),
(4,'ret.zhang','ret.zhang@example.com','test123','Zhang','Mei',1,0,0,NULL,'2025-10-19 09:20:00',NULL,NULL),
(5,'wh.chen','wh.chen@example.com','test123','Chen','Hao',1,0,0,NULL,'2025-10-19 09:25:00',NULL,NULL),
(6,'cv','cv@local','pbkdf2_sha256$1000000$JVYgzYHEEeRFlNmxAITkFu$Y9bw/6QO7dchwBfjoZF37537nGTK4b/84wVQ2os2bLA=','','',1,1,1,'2025-10-23 01:46:20','2025-10-23 01:12:23',NULL,NULL),
(7,'c','cvelasquezp10@miumg.edu.gt','pbkdf2_sha256$1000000$hIt5PRseEk4czAT1qM20PG$PdRxOk5VDaaWO69U5/tuARz6tpuMjhigw3IZowmX1z4=','','',1,1,1,'2025-10-24 01:48:53','2025-10-23 01:15:40',NULL,NULL),
(8,'root','cvelasquez@miumg.edu.gt','pbkdf2_sha256$1000000$xPZRnt4UNwqBLS5PlQzusm$LeJVBLSHhOHVYGF+2X63/N1jPeYZB0ffvh++TLOwJ4E=','','',1,1,1,'2025-10-24 00:45:21','2025-10-24 00:31:31',NULL,NULL);

/*Table structure for table `accounts_user_roles` */

DROP TABLE IF EXISTS `accounts_user_roles`;

CREATE TABLE `accounts_user_roles` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `role_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_user_role` (`user_id`,`role_id`),
  KEY `fk_userroles_role` (`role_id`),
  CONSTRAINT `fk_userroles_role` FOREIGN KEY (`role_id`) REFERENCES `accounts_role` (`id`),
  CONSTRAINT `fk_userroles_user` FOREIGN KEY (`user_id`) REFERENCES `accounts_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `accounts_user_roles` */

insert  into `accounts_user_roles`(`id`,`user_id`,`role_id`) values 
(1,1,1),
(2,2,2),
(3,3,3),
(4,4,4),
(5,5,5),
(7,6,1),
(8,7,1);

/*Table structure for table `auth_group` */

DROP TABLE IF EXISTS `auth_group`;

CREATE TABLE `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `auth_group` */

/*Table structure for table `auth_group_permissions` */

DROP TABLE IF EXISTS `auth_group_permissions`;

CREATE TABLE `auth_group_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `auth_group_permissions` */

/*Table structure for table `auth_permission` */

DROP TABLE IF EXISTS `auth_permission`;

CREATE TABLE `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=125 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `auth_permission` */

insert  into `auth_permission`(`id`,`name`,`content_type_id`,`codename`) values 
(1,'Can add log entry',1,'add_logentry'),
(2,'Can change log entry',1,'change_logentry'),
(3,'Can delete log entry',1,'delete_logentry'),
(4,'Can view log entry',1,'view_logentry'),
(5,'Can add permission',2,'add_permission'),
(6,'Can change permission',2,'change_permission'),
(7,'Can delete permission',2,'delete_permission'),
(8,'Can view permission',2,'view_permission'),
(9,'Can add group',3,'add_group'),
(10,'Can change group',3,'change_group'),
(11,'Can delete group',3,'delete_group'),
(12,'Can view group',3,'view_group'),
(13,'Can add content type',4,'add_contenttype'),
(14,'Can change content type',4,'change_contenttype'),
(15,'Can delete content type',4,'delete_contenttype'),
(16,'Can view content type',4,'view_contenttype'),
(17,'Can add session',5,'add_session'),
(18,'Can change session',5,'change_session'),
(19,'Can delete session',5,'delete_session'),
(20,'Can view session',5,'view_session'),
(21,'Can add role',6,'add_role'),
(22,'Can change role',6,'change_role'),
(23,'Can delete role',6,'delete_role'),
(24,'Can view role',6,'view_role'),
(25,'Can add user',7,'add_user'),
(26,'Can change user',7,'change_user'),
(27,'Can delete user',7,'delete_user'),
(28,'Can view user',7,'view_user'),
(29,'Can add distributor',8,'add_distributor'),
(30,'Can change distributor',8,'change_distributor'),
(31,'Can delete distributor',8,'delete_distributor'),
(32,'Can view distributor',8,'view_distributor'),
(33,'Can add retailer',9,'add_retailer'),
(34,'Can change retailer',9,'change_retailer'),
(35,'Can delete retailer',9,'delete_retailer'),
(36,'Can view retailer',9,'view_retailer'),
(37,'Can add brand',10,'add_brand'),
(38,'Can change brand',10,'change_brand'),
(39,'Can delete brand',10,'delete_brand'),
(40,'Can view brand',10,'view_brand'),
(41,'Can add category',11,'add_category'),
(42,'Can change category',11,'change_category'),
(43,'Can delete category',11,'delete_category'),
(44,'Can view category',11,'view_category'),
(45,'Can add product',12,'add_product'),
(46,'Can change product',12,'change_product'),
(47,'Can delete product',12,'delete_product'),
(48,'Can view product',12,'view_product'),
(49,'Can add sku',13,'add_sku'),
(50,'Can change sku',13,'change_sku'),
(51,'Can delete sku',13,'delete_sku'),
(52,'Can view sku',13,'view_sku'),
(53,'Can add price list',14,'add_pricelist'),
(54,'Can change price list',14,'change_pricelist'),
(55,'Can delete price list',14,'delete_pricelist'),
(56,'Can view price list',14,'view_pricelist'),
(57,'Can add price item',15,'add_priceitem'),
(58,'Can change price item',15,'change_priceitem'),
(59,'Can delete price item',15,'delete_priceitem'),
(60,'Can view price item',15,'view_priceitem'),
(61,'Can add promotion',16,'add_promotion'),
(62,'Can change promotion',16,'change_promotion'),
(63,'Can delete promotion',16,'delete_promotion'),
(64,'Can view promotion',16,'view_promotion'),
(65,'Can add warehouse',17,'add_warehouse'),
(66,'Can change warehouse',17,'change_warehouse'),
(67,'Can delete warehouse',17,'delete_warehouse'),
(68,'Can view warehouse',17,'view_warehouse'),
(69,'Can add inventory batch',18,'add_inventorybatch'),
(70,'Can change inventory batch',18,'change_inventorybatch'),
(71,'Can delete inventory batch',18,'delete_inventorybatch'),
(72,'Can view inventory batch',18,'view_inventorybatch'),
(73,'Can add replenishment rule',19,'add_replenishmentrule'),
(74,'Can change replenishment rule',19,'change_replenishmentrule'),
(75,'Can delete replenishment rule',19,'delete_replenishmentrule'),
(76,'Can view replenishment rule',19,'view_replenishmentrule'),
(77,'Can add retailer order',20,'add_retailerorder'),
(78,'Can change retailer order',20,'change_retailerorder'),
(79,'Can delete retailer order',20,'delete_retailerorder'),
(80,'Can view retailer order',20,'view_retailerorder'),
(81,'Can add order item',21,'add_orderitem'),
(82,'Can change order item',21,'change_orderitem'),
(83,'Can delete order item',21,'delete_orderitem'),
(84,'Can view order item',21,'view_orderitem'),
(85,'Can add reservation',22,'add_reservation'),
(86,'Can change reservation',22,'change_reservation'),
(87,'Can delete reservation',22,'delete_reservation'),
(88,'Can view reservation',22,'view_reservation'),
(89,'Can add allocation',23,'add_allocation'),
(90,'Can change allocation',23,'change_allocation'),
(91,'Can delete allocation',23,'delete_allocation'),
(92,'Can view allocation',23,'view_allocation'),
(93,'Can add carrier',24,'add_carrier'),
(94,'Can change carrier',24,'change_carrier'),
(95,'Can delete carrier',24,'delete_carrier'),
(96,'Can view carrier',24,'view_carrier'),
(97,'Can add shipment',25,'add_shipment'),
(98,'Can change shipment',25,'change_shipment'),
(99,'Can delete shipment',25,'delete_shipment'),
(100,'Can view shipment',25,'view_shipment'),
(101,'Can add shipment item',26,'add_shipmentitem'),
(102,'Can change shipment item',26,'change_shipmentitem'),
(103,'Can delete shipment item',26,'delete_shipmentitem'),
(104,'Can view shipment item',26,'view_shipmentitem'),
(105,'Can add buyback',27,'add_buyback'),
(106,'Can change buyback',27,'change_buyback'),
(107,'Can delete buyback',27,'delete_buyback'),
(108,'Can view buyback',27,'view_buyback'),
(109,'Can add buyback item',28,'add_buybackitem'),
(110,'Can change buyback item',28,'change_buybackitem'),
(111,'Can delete buyback item',28,'delete_buybackitem'),
(112,'Can view buyback item',28,'view_buybackitem'),
(113,'Can add credit terms',29,'add_creditterms'),
(114,'Can change credit terms',29,'change_creditterms'),
(115,'Can delete credit terms',29,'delete_creditterms'),
(116,'Can view credit terms',29,'view_creditterms'),
(117,'Can add settlement',30,'add_settlement'),
(118,'Can change settlement',30,'change_settlement'),
(119,'Can delete settlement',30,'delete_settlement'),
(120,'Can view settlement',30,'view_settlement'),
(121,'Can add settlement line',31,'add_settlementline'),
(122,'Can change settlement line',31,'change_settlementline'),
(123,'Can delete settlement line',31,'delete_settlementline'),
(124,'Can view settlement line',31,'view_settlementline');

/*Table structure for table `catalog_brand` */

DROP TABLE IF EXISTS `catalog_brand`;

CREATE TABLE `catalog_brand` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(120) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_brand_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `catalog_brand` */

insert  into `catalog_brand`(`id`,`name`,`created_at`,`updated_at`,`created_by_id`,`updated_by_id`) values 
(1,'CHANDO','2025-10-23 01:21:45','2025-10-23 01:21:45',NULL,NULL),
(2,'Maysu','2025-10-23 01:21:45','2025-10-23 01:21:45',NULL,NULL),
(3,'Genérica','2025-10-23 01:22:25','2025-10-23 01:22:25',NULL,NULL);

/*Table structure for table `catalog_category` */

DROP TABLE IF EXISTS `catalog_category`;

CREATE TABLE `catalog_category` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(120) NOT NULL,
  `parent_id` bigint unsigned DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_category_name` (`name`),
  KEY `ix_category_parent` (`parent_id`),
  CONSTRAINT `fk_category_parent` FOREIGN KEY (`parent_id`) REFERENCES `catalog_category` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `catalog_category` */

insert  into `catalog_category`(`id`,`name`,`parent_id`,`created_at`,`updated_at`,`created_by_id`,`updated_by_id`) values 
(1,'Skincare',NULL,'2025-10-23 01:21:45','2025-10-23 01:21:45',NULL,NULL),
(2,'Cleansers',1,'2025-10-23 01:21:45','2025-10-23 01:21:45',NULL,NULL),
(3,'Toners',1,'2025-10-23 01:21:45','2025-10-23 01:21:45',NULL,NULL),
(4,'Moisturizers',1,'2025-10-23 01:21:45','2025-10-23 01:21:45',NULL,NULL),
(5,'Masks',1,'2025-10-23 01:21:45','2025-10-23 01:21:45',NULL,NULL),
(6,'Default',NULL,'2025-10-23 01:22:25','2025-10-23 01:22:25',NULL,NULL);

/*Table structure for table `catalog_product` */

DROP TABLE IF EXISTS `catalog_product`;

CREATE TABLE `catalog_product` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL,
  `brand_id` bigint unsigned DEFAULT NULL,
  `category_id` bigint unsigned DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_product_brand` (`brand_id`),
  KEY `ix_product_category` (`category_id`),
  CONSTRAINT `fk_product_brand` FOREIGN KEY (`brand_id`) REFERENCES `catalog_brand` (`id`),
  CONSTRAINT `fk_product_category` FOREIGN KEY (`category_id`) REFERENCES `catalog_category` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `catalog_product` */

insert  into `catalog_product`(`id`,`name`,`brand_id`,`category_id`,`created_at`,`updated_at`,`created_by_id`,`updated_by_id`) values 
(1,'CHANDO Himalayan Hydrating Cleanser',1,1,'2025-10-23 01:21:45','2025-10-24 00:05:09',NULL,NULL),
(2,'CHANDO Hyaluronic Acid Toner 200ml',1,3,'2025-10-23 01:21:45','2025-10-23 01:21:45',NULL,NULL),
(3,'CHANDO Arctic Moss Moisturizer 50ml',1,4,'2025-10-23 01:21:45','2025-10-23 01:21:45',NULL,NULL),
(4,'CHANDO Glacier Water Sleeping Mask',1,5,'2025-10-23 01:21:45','2025-10-23 01:21:45',NULL,NULL),
(5,'Maysu Rose Toner 200ml',2,3,'2025-10-23 01:21:45','2025-10-23 01:21:45',NULL,NULL),
(6,'Maysu Collagen Cream 50ml',2,4,'2025-10-23 01:21:45','2025-10-23 01:21:45',NULL,NULL),
(7,'Producto 1',3,6,'2025-10-23 01:22:25','2025-10-23 01:22:25',NULL,NULL),
(8,'Producto 2',3,6,'2025-10-23 01:22:25','2025-10-23 01:22:25',NULL,NULL),
(9,'Producto 3',3,6,'2025-10-23 01:22:25','2025-10-23 01:22:25',NULL,NULL),
(10,'Producto 4',3,6,'2025-10-23 01:22:25','2025-10-23 01:22:25',NULL,NULL),
(11,'Producto 5',3,6,'2025-10-23 01:22:25','2025-10-23 01:22:25',NULL,NULL),
(12,'Producto 6',3,6,'2025-10-23 01:22:25','2025-10-23 01:22:25',NULL,NULL),
(13,'Producto 7',3,6,'2025-10-23 01:22:25','2025-10-23 01:22:25',NULL,NULL),
(14,'Producto 8',3,6,'2025-10-23 01:22:25','2025-10-23 01:22:25',NULL,NULL),
(15,'Producto 9',3,6,'2025-10-23 01:22:25','2025-10-23 01:22:25',NULL,NULL),
(16,'Producto 10',3,6,'2025-10-23 01:22:25','2025-10-23 01:22:25',NULL,NULL),
(17,'Producto 11',3,6,'2025-10-23 01:22:25','2025-10-23 01:22:25',NULL,NULL),
(18,'Producto 12',3,6,'2025-10-23 01:22:25','2025-10-23 01:22:25',NULL,NULL),
(19,'Producto 13',3,6,'2025-10-23 01:22:25','2025-10-23 01:22:25',NULL,NULL),
(20,'Producto 14',3,6,'2025-10-23 01:22:25','2025-10-23 01:22:25',NULL,NULL),
(21,'Producto 15',3,6,'2025-10-23 01:22:25','2025-10-23 01:22:25',NULL,NULL),
(22,'Producto 16',3,6,'2025-10-23 01:22:25','2025-10-23 01:22:25',NULL,NULL),
(23,'Producto 17',3,6,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(24,'Producto 18',3,6,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(25,'Producto 19',3,6,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(26,'Producto 20',3,6,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL);

/*Table structure for table `catalog_sku` */

DROP TABLE IF EXISTS `catalog_sku`;

CREATE TABLE `catalog_sku` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `product_id` bigint unsigned NOT NULL,
  `code` varchar(64) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_sku_code` (`code`),
  KEY `ix_sku_product` (`product_id`),
  CONSTRAINT `fk_sku_product` FOREIGN KEY (`product_id`) REFERENCES `catalog_product` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `catalog_sku` */

insert  into `catalog_sku`(`id`,`product_id`,`code`,`is_active`,`created_at`,`updated_at`,`created_by_id`,`updated_by_id`) values 
(1,1,'CH-CLE-100',1,'2025-10-23 01:21:46','2025-10-23 01:21:46',NULL,NULL),
(2,2,'CH-TON-200',1,'2025-10-23 01:21:46','2025-10-23 01:21:46',NULL,NULL),
(3,3,'CH-MOI-050',1,'2025-10-23 01:21:46','2025-10-23 01:21:46',NULL,NULL),
(4,4,'CH-MASK-080',1,'2025-10-23 01:21:46','2025-10-23 01:21:46',NULL,NULL),
(5,5,'MY-TON-200',1,'2025-10-23 01:21:46','2025-10-23 01:21:46',NULL,NULL),
(6,6,'MY-CRM-050',1,'2025-10-23 01:21:46','2025-10-23 01:21:46',NULL,NULL),
(7,7,'SKU0001',1,'2025-10-23 01:22:25','2025-10-23 01:22:25',NULL,NULL),
(8,8,'SKU0002',1,'2025-10-23 01:22:25','2025-10-23 01:22:25',NULL,NULL),
(9,9,'SKU0003',1,'2025-10-23 01:22:25','2025-10-23 01:22:25',NULL,NULL),
(10,10,'SKU0004',1,'2025-10-23 01:22:25','2025-10-23 01:22:25',NULL,NULL),
(11,11,'SKU0005',1,'2025-10-23 01:22:25','2025-10-23 01:22:25',NULL,NULL),
(12,12,'SKU0006',1,'2025-10-23 01:22:25','2025-10-23 01:22:25',NULL,NULL),
(13,13,'SKU0007',1,'2025-10-23 01:22:25','2025-10-23 01:22:25',NULL,NULL),
(14,14,'SKU0008',1,'2025-10-23 01:22:25','2025-10-23 01:22:25',NULL,NULL),
(15,15,'SKU0009',1,'2025-10-23 01:22:25','2025-10-23 01:22:25',NULL,NULL),
(16,16,'SKU0010',1,'2025-10-23 01:22:25','2025-10-23 01:22:25',NULL,NULL),
(17,17,'SKU0011',1,'2025-10-23 01:22:25','2025-10-23 01:22:25',NULL,NULL),
(18,18,'SKU0012',1,'2025-10-23 01:22:25','2025-10-23 01:22:25',NULL,NULL),
(19,19,'SKU0013',1,'2025-10-23 01:22:25','2025-10-23 01:22:25',NULL,NULL),
(20,20,'SKU0014',1,'2025-10-23 01:22:25','2025-10-23 01:22:25',NULL,NULL),
(21,21,'SKU0015',1,'2025-10-23 01:22:25','2025-10-23 01:22:25',NULL,NULL),
(22,22,'SKU0016',1,'2025-10-23 01:22:25','2025-10-23 01:22:25',NULL,NULL),
(23,23,'SKU0017',1,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(24,24,'SKU0018',1,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(25,25,'SKU0019',1,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(26,26,'SKU0020',1,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL);

/*Table structure for table `django_admin_log` */

DROP TABLE IF EXISTS `django_admin_log`;

CREATE TABLE `django_admin_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext COLLATE utf8mb4_unicode_ci,
  `object_repr` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `action_flag` smallint unsigned NOT NULL,
  `change_message` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_chk_1` CHECK ((`action_flag` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `django_admin_log` */

/*Table structure for table `django_content_type` */

DROP TABLE IF EXISTS `django_content_type`;

CREATE TABLE `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `model` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `django_content_type` */

insert  into `django_content_type`(`id`,`app_label`,`model`) values 
(6,'accounts','role'),
(7,'accounts','user'),
(1,'admin','logentry'),
(3,'auth','group'),
(2,'auth','permission'),
(10,'catalog','brand'),
(11,'catalog','category'),
(12,'catalog','product'),
(13,'catalog','sku'),
(4,'contenttypes','contenttype'),
(29,'finance','creditterms'),
(30,'finance','settlement'),
(31,'finance','settlementline'),
(24,'fulfillment','carrier'),
(25,'fulfillment','shipment'),
(26,'fulfillment','shipmentitem'),
(23,'orders','allocation'),
(21,'orders','orderitem'),
(22,'orders','reservation'),
(20,'orders','retailerorder'),
(8,'partners','distributor'),
(9,'partners','retailer'),
(15,'pricing','priceitem'),
(14,'pricing','pricelist'),
(16,'promo','promotion'),
(27,'returns','buyback'),
(28,'returns','buybackitem'),
(5,'sessions','session'),
(18,'warehouses','inventorybatch'),
(19,'warehouses','replenishmentrule'),
(17,'warehouses','warehouse');

/*Table structure for table `django_migrations` */

DROP TABLE IF EXISTS `django_migrations`;

CREATE TABLE `django_migrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `django_migrations` */

insert  into `django_migrations`(`id`,`app`,`name`,`applied`) values 
(1,'contenttypes','0001_initial','2025-10-23 00:32:06.699648'),
(2,'admin','0001_initial','2025-10-23 00:54:16.895731'),
(3,'admin','0002_logentry_remove_auto_add','2025-10-23 00:54:16.908594'),
(4,'admin','0003_logentry_add_action_flag_choices','2025-10-23 00:54:16.922168'),
(5,'contenttypes','0002_remove_content_type_name','2025-10-23 00:54:17.384593'),
(6,'auth','0001_initial','2025-10-23 00:54:18.448990'),
(7,'auth','0002_alter_permission_name_max_length','2025-10-23 00:54:18.628453'),
(8,'auth','0003_alter_user_email_max_length','2025-10-23 00:54:18.641438'),
(9,'auth','0004_alter_user_username_opts','2025-10-23 00:54:18.653906'),
(10,'auth','0005_alter_user_last_login_null','2025-10-23 00:54:18.668749'),
(11,'auth','0006_require_contenttypes_0002','2025-10-23 00:54:18.677512'),
(12,'auth','0007_alter_validators_add_error_messages','2025-10-23 00:54:18.691227'),
(13,'auth','0008_alter_user_username_max_length','2025-10-23 00:54:18.708309'),
(14,'auth','0009_alter_user_last_name_max_length','2025-10-23 00:54:18.721761'),
(15,'auth','0010_alter_group_name_max_length','2025-10-23 00:54:18.779025'),
(16,'auth','0011_update_proxy_permissions','2025-10-23 00:54:18.819458'),
(17,'auth','0012_alter_user_first_name_max_length','2025-10-23 00:54:18.835371'),
(18,'sessions','0001_initial','2025-10-23 00:54:18.957659'),
(19,'accounts','0001_initial','2025-10-23 01:01:12.000000'),
(20,'partners','0001_initial','2025-10-23 01:01:30.660460'),
(21,'accounts','0002_user_partner_links','2025-10-23 01:03:44.550532'),
(22,'common','0001_add_audit_columns','2025-10-23 01:21:50.490774'),
(23,'accounts','0003_alter_user_options_alter_user_date_joined_and_more','2025-10-23 02:23:08.657557'),
(24,'catalog','0001_initial','2025-10-23 02:23:08.728709'),
(25,'catalog','0002_alter_brand_created_by_alter_brand_updated_by_and_more','2025-10-23 02:23:08.876574'),
(26,'warehouses','0001_initial','2025-10-23 02:23:08.975906'),
(27,'orders','0001_initial','2025-10-23 02:23:09.094260'),
(28,'finance','0001_initial','2025-10-23 02:23:09.197816'),
(29,'finance','0002_alter_creditterms_created_by_and_more','2025-10-23 02:23:09.422163'),
(30,'fulfillment','0001_initial','2025-10-23 02:23:09.571344'),
(31,'fulfillment','0002_alter_carrier_created_by_alter_carrier_updated_by_and_more','2025-10-23 02:23:09.809002'),
(32,'orders','0002_rename_orders_reta_status__e19a1e_idx_orders_reta_status_8db34d_idx_and_more','2025-10-23 02:49:49.231966'),
(33,'orders','0003_rename_orders_reta_status__e19a1e_idx_orders_reta_status_8db34d_idx','2025-10-23 02:53:56.055408'),
(34,'partners','0002_alter_distributor_created_by_and_more','2025-10-23 02:53:56.332922'),
(35,'pricing','0001_initial','2025-10-23 02:53:56.485491'),
(36,'warehouses','0002_rename_warehouses__warehouse_6a59b1_idx_warehouses__warehou_d82d4c_idx_and_more','2025-10-23 03:01:32.367644'),
(52,'orders','0004_rename_orders_reta_status__e19a1e_idx_orders_reta_status_8db34d_idx','2025-10-23 03:29:46.660341'),
(53,'pricing','0002_alter_priceitem_unique_together_and_more','2025-10-24 00:38:30.339139'),
(54,'promo','0001_initial','2025-10-24 00:53:01.517549'),
(55,'promo','0002_alter_promotion_created_by_and_more','2025-10-24 00:53:01.628622'),
(56,'returns','0001_initial','2025-10-24 00:53:01.725381'),
(57,'returns','0002_alter_buyback_created_by_alter_buyback_updated_by_and_more','2025-10-24 00:53:01.886470'),
(58,'warehouses','0003_rename_warehouses__warehouse_6a59b1_idx_warehouses__warehou_d82d4c_idx','2025-10-24 00:57:18.483346');

/*Table structure for table `django_session` */

DROP TABLE IF EXISTS `django_session`;

CREATE TABLE `django_session` (
  `session_key` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `session_data` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `django_session` */

insert  into `django_session`(`session_key`,`session_data`,`expire_date`) values 
('0w8d7djccjc0pqqzps6hc534vsl51jna','.eJxVjMsOwiAQRf-FtSEYHgMu3fsNZAYYqRqalHZl_Hdp0oVu7znnvkXEba1x62WJUxYXcRan340wPUvbQX5gu88yzW1dJpK7Ig_a5W3O5XU93L-Dir2OOjnIhaxPQSeCwoEDjDpQInLWGMUeGTQoVERWEw-PcwA03mhnWXy-HV85Dg:1vC6xH:4KwY77XprdqcxTTbO5iprea824Q4XNlCI_b41Pirewk','2025-11-07 01:50:59.238558'),
('a4nmwcyn1hvwcxlqv4i7ssko4yekwqgy','.eJxVjDEOwjAMRe-SGUVx2qSYkZ0zRI5tSAGlUtNOiLtDpQ6w_vfef5lE61LS2nROo5iTAXP43TLxQ-sG5E71Nlme6jKP2W6K3Wmzl0n0ed7dv4NCrXxrjsKdAoIABxeU6dhH8eqoi44Y8uAxQGBUlECgzHgll5HcIL5HMe8P9zs4gA:1vC6Ca:fkjj-8WRcvu8wr6x4F7oEvEajnGcM3EH5pJskyBbsK0','2025-11-07 01:02:44.463937');

/*Table structure for table `finance_creditterms` */

DROP TABLE IF EXISTS `finance_creditterms`;

CREATE TABLE `finance_creditterms` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `partner_type` enum('DISTRIBUTOR','RETAILER') NOT NULL,
  `partner_id` bigint unsigned NOT NULL,
  `credit_limit` decimal(12,2) NOT NULL DEFAULT '0.00',
  `payment_terms_days` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `ix_credit_partner` (`partner_type`,`partner_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `finance_creditterms` */

insert  into `finance_creditterms`(`id`,`partner_type`,`partner_id`,`credit_limit`,`payment_terms_days`) values 
(1,'DISTRIBUTOR',1,100000.00,30),
(2,'DISTRIBUTOR',2,100000.00,30),
(3,'DISTRIBUTOR',3,100000.00,30),
(4,'RETAILER',1,10000.00,15),
(5,'RETAILER',2,10000.00,15),
(6,'RETAILER',3,8000.00,15),
(7,'RETAILER',4,8000.00,15),
(8,'RETAILER',5,12000.00,21);

/*Table structure for table `finance_settlement` */

DROP TABLE IF EXISTS `finance_settlement`;

CREATE TABLE `finance_settlement` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `period` varchar(16) NOT NULL,
  `partner_type` enum('DISTRIBUTOR','RETAILER') NOT NULL,
  `partner_id` bigint unsigned NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_settle_partner` (`partner_type`,`partner_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `finance_settlement` */

insert  into `finance_settlement`(`id`,`period`,`partner_type`,`partner_id`,`created_at`) values 
(1,'2025-10','RETAILER',5,'2025-10-15 12:00:00'),
(2,'2025-10','RETAILER',1,'2025-10-08 12:00:00');

/*Table structure for table `finance_settlementline` */

DROP TABLE IF EXISTS `finance_settlementline`;

CREATE TABLE `finance_settlementline` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `settlement_id` bigint unsigned NOT NULL,
  `order_id` bigint unsigned NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_settleline_settle` (`settlement_id`),
  KEY `ix_settleline_order` (`order_id`),
  CONSTRAINT `fk_settleline_order` FOREIGN KEY (`order_id`) REFERENCES `orders_retailerorder` (`id`),
  CONSTRAINT `fk_settleline_settle` FOREIGN KEY (`settlement_id`) REFERENCES `finance_settlement` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `finance_settlementline` */

insert  into `finance_settlementline`(`id`,`settlement_id`,`order_id`,`amount`) values 
(1,1,4,645.00),
(2,2,1,547.50);

/*Table structure for table `fulfillment_carrier` */

DROP TABLE IF EXISTS `fulfillment_carrier`;

CREATE TABLE `fulfillment_carrier` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(32) NOT NULL,
  `name` varchar(120) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_carrier_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `fulfillment_carrier` */

insert  into `fulfillment_carrier`(`id`,`code`,`name`,`created_at`,`updated_at`,`created_by_id`,`updated_by_id`) values 
(1,'SFEXP','SF Express','2025-10-23 01:21:48','2025-10-23 01:21:48',NULL,NULL),
(2,'DHL','DHL Express','2025-10-23 01:21:48','2025-10-23 01:21:48',NULL,NULL),
(3,'YTO','YTO Express','2025-10-23 01:21:48','2025-10-23 01:21:48',NULL,NULL),
(4,'CARR1','Carrier X','2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL);

/*Table structure for table `fulfillment_shipment` */

DROP TABLE IF EXISTS `fulfillment_shipment`;

CREATE TABLE `fulfillment_shipment` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(32) NOT NULL,
  `order_id` bigint unsigned NOT NULL,
  `carrier_id` bigint unsigned DEFAULT NULL,
  `tracking` varchar(64) NOT NULL,
  `status` varchar(16) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_shipment_code` (`code`),
  UNIQUE KEY `uq_shipment_tracking` (`tracking`),
  KEY `ix_ship_order` (`order_id`),
  KEY `fk_ship_carrier` (`carrier_id`),
  CONSTRAINT `fk_ship_carrier` FOREIGN KEY (`carrier_id`) REFERENCES `fulfillment_carrier` (`id`),
  CONSTRAINT `fk_ship_order` FOREIGN KEY (`order_id`) REFERENCES `orders_retailerorder` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `fulfillment_shipment` */

insert  into `fulfillment_shipment`(`id`,`code`,`order_id`,`carrier_id`,`tracking`,`status`,`created_at`,`updated_at`,`created_by_id`,`updated_by_id`) values 
(1,'SHP-20251003-001',3,1,'SF123456789CN','DISPATCHED','2025-10-03 15:00:00','2025-10-03 15:30:00',NULL,NULL),
(2,'SHP-20251005-001',4,1,'SF987654321CN','DELIVERED','2025-10-04 15:00:00','2025-10-05 10:00:00',NULL,NULL),
(3,'SH-004',4,4,'TRK04-004','DISPATCHED','2025-10-23 01:22:28','2025-10-23 01:22:28',NULL,NULL),
(4,'SH0006',10,4,'TRKD00006','DISPATCHED','2025-10-23 01:22:28','2025-10-23 01:22:28',NULL,NULL),
(5,'SH0013',17,4,'TRKD00013','DISPATCHED','2025-10-23 01:22:28','2025-10-23 01:22:28',NULL,NULL),
(6,'SH-003',3,4,'TRK03-003','DISPATCHED','2025-10-23 01:22:28','2025-10-23 01:22:28',NULL,NULL),
(7,'SH0003',7,4,'TRKD00003','DISPATCHED','2025-10-23 01:22:28','2025-10-23 01:22:28',NULL,NULL);

/*Table structure for table `fulfillment_shipmentitem` */

DROP TABLE IF EXISTS `fulfillment_shipmentitem`;

CREATE TABLE `fulfillment_shipmentitem` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `shipment_id` bigint unsigned NOT NULL,
  `order_item_id` bigint unsigned NOT NULL,
  `qty` int NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_shipitem_ship` (`shipment_id`),
  KEY `ix_shipitem_item` (`order_item_id`),
  CONSTRAINT `fk_shipitem_item` FOREIGN KEY (`order_item_id`) REFERENCES `orders_orderitem` (`id`),
  CONSTRAINT `fk_shipitem_ship` FOREIGN KEY (`shipment_id`) REFERENCES `fulfillment_shipment` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `fulfillment_shipmentitem` */

insert  into `fulfillment_shipmentitem`(`id`,`shipment_id`,`order_item_id`,`qty`,`created_at`,`updated_at`,`created_by_id`,`updated_by_id`) values 
(1,1,5,30,'2025-10-23 01:21:48','2025-10-23 01:21:48',NULL,NULL),
(2,1,6,20,'2025-10-23 01:21:48','2025-10-23 01:21:48',NULL,NULL),
(3,2,7,12,'2025-10-23 01:21:48','2025-10-23 01:21:48',NULL,NULL),
(4,2,8,15,'2025-10-23 01:21:48','2025-10-23 01:21:48',NULL,NULL),
(5,3,7,12,'2025-10-23 01:22:28','2025-10-23 01:22:28',NULL,NULL),
(6,3,8,15,'2025-10-23 01:22:28','2025-10-23 01:22:28',NULL,NULL),
(7,4,19,3,'2025-10-23 01:22:28','2025-10-23 01:22:28',NULL,NULL),
(8,4,20,1,'2025-10-23 01:22:28','2025-10-23 01:22:28',NULL,NULL),
(9,5,33,1,'2025-10-23 01:22:28','2025-10-23 01:22:28',NULL,NULL),
(10,5,34,3,'2025-10-23 01:22:28','2025-10-23 01:22:28',NULL,NULL),
(11,6,5,30,'2025-10-23 01:22:28','2025-10-23 01:22:28',NULL,NULL),
(12,6,6,20,'2025-10-23 01:22:28','2025-10-23 01:22:28',NULL,NULL),
(13,7,13,2,'2025-10-23 01:22:28','2025-10-23 01:22:28',NULL,NULL),
(14,7,14,1,'2025-10-23 01:22:28','2025-10-23 01:22:28',NULL,NULL);

/*Table structure for table `orders_allocation` */

DROP TABLE IF EXISTS `orders_allocation`;

CREATE TABLE `orders_allocation` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `order_item_id` bigint unsigned NOT NULL,
  `batch_id` bigint unsigned NOT NULL,
  `qty` int NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_alloc_item` (`order_item_id`),
  KEY `ix_alloc_batch` (`batch_id`),
  CONSTRAINT `fk_alloc_batch` FOREIGN KEY (`batch_id`) REFERENCES `warehouses_inventorybatch` (`id`),
  CONSTRAINT `fk_alloc_item` FOREIGN KEY (`order_item_id`) REFERENCES `orders_orderitem` (`id`),
  CONSTRAINT `chk_alloc_qty` CHECK ((`qty` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `orders_allocation` */

insert  into `orders_allocation`(`id`,`order_item_id`,`batch_id`,`qty`,`created_at`,`updated_at`,`created_by_id`,`updated_by_id`) values 
(1,3,8,10,'2025-10-02 11:20:00','2025-10-23 01:21:48',NULL,NULL),
(2,4,4,8,'2025-10-02 11:22:00','2025-10-23 01:21:48',NULL,NULL),
(3,5,7,30,'2025-10-03 12:30:00','2025-10-23 01:21:48',NULL,NULL),
(4,6,8,20,'2025-10-03 12:32:00','2025-10-23 01:21:48',NULL,NULL),
(5,7,5,12,'2025-10-04 13:10:00','2025-10-23 01:21:48',NULL,NULL),
(6,8,6,15,'2025-10-04 13:12:00','2025-10-23 01:21:48',NULL,NULL);

/*Table structure for table `orders_orderitem` */

DROP TABLE IF EXISTS `orders_orderitem`;

CREATE TABLE `orders_orderitem` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `order_id` bigint unsigned NOT NULL,
  `sku_id` bigint unsigned NOT NULL,
  `qty` int NOT NULL,
  `unit_price` decimal(12,2) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_item_order` (`order_id`),
  KEY `ix_item_sku` (`sku_id`),
  CONSTRAINT `fk_item_order` FOREIGN KEY (`order_id`) REFERENCES `orders_retailerorder` (`id`),
  CONSTRAINT `fk_item_sku` FOREIGN KEY (`sku_id`) REFERENCES `catalog_sku` (`id`),
  CONSTRAINT `chk_item_qty` CHECK ((`qty` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `orders_orderitem` */

insert  into `orders_orderitem`(`id`,`order_id`,`sku_id`,`qty`,`unit_price`,`created_at`,`updated_at`,`created_by_id`,`updated_by_id`) values 
(1,1,2,20,18.00,'2025-10-23 01:21:48','2025-10-23 01:21:48',NULL,NULL),
(2,1,1,15,12.50,'2025-10-23 01:21:48','2025-10-23 01:21:48',NULL,NULL),
(3,2,3,10,24.00,'2025-10-23 01:21:48','2025-10-23 01:21:48',NULL,NULL),
(4,2,4,8,22.00,'2025-10-23 01:21:48','2025-10-23 01:21:48',NULL,NULL),
(5,3,2,30,18.00,'2025-10-23 01:21:48','2025-10-23 01:21:48',NULL,NULL),
(6,3,3,20,24.00,'2025-10-23 01:21:48','2025-10-23 01:21:48',NULL,NULL),
(7,4,6,12,30.00,'2025-10-23 01:21:48','2025-10-23 01:21:48',NULL,NULL),
(8,4,5,15,19.00,'2025-10-23 01:21:48','2025-10-23 01:21:48',NULL,NULL),
(9,5,21,2,10.00,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL),
(10,5,13,1,10.00,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL),
(11,6,17,3,10.00,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL),
(12,6,18,3,10.00,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL),
(13,7,11,2,10.00,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL),
(14,7,16,1,10.00,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL),
(15,8,26,1,10.00,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL),
(16,8,12,1,10.00,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL),
(17,9,16,2,10.00,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL),
(18,9,11,3,10.00,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL),
(19,10,8,3,10.00,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL),
(20,10,9,1,10.00,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL),
(21,11,20,1,10.00,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL),
(22,11,23,1,10.00,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL),
(23,12,20,2,10.00,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL),
(24,12,25,1,10.00,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL),
(25,13,23,1,10.00,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL),
(26,13,24,2,10.00,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL),
(27,14,18,1,10.00,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL),
(28,14,26,3,10.00,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL),
(29,15,20,3,10.00,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL),
(30,15,8,2,10.00,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL),
(31,16,7,3,10.00,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL),
(32,16,17,1,10.00,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL),
(33,17,24,1,10.00,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL),
(34,17,7,3,10.00,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL),
(35,18,16,1,10.00,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL),
(36,18,22,3,10.00,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL),
(37,19,17,1,10.00,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL),
(38,19,8,2,10.00,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL),
(39,20,11,2,10.00,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL),
(40,20,8,2,10.00,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL),
(41,21,17,1,10.00,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL),
(42,21,22,3,10.00,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL),
(43,22,15,1,10.00,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL),
(44,22,13,1,10.00,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL),
(45,23,14,1,10.00,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL),
(46,23,11,2,10.00,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL),
(47,24,20,3,10.00,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL),
(48,24,21,2,10.00,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL),
(49,30,1,4,12.50,'2025-10-23 04:39:17','2025-10-23 04:39:17',NULL,NULL),
(50,32,19,3,10.00,'2025-10-24 00:17:33','2025-10-24 00:17:33',NULL,NULL),
(51,32,16,6,10.00,'2025-10-24 00:17:33','2025-10-24 00:17:33',NULL,NULL),
(52,5,26,3,10.00,'2025-10-24 00:29:51','2025-10-24 00:29:51',NULL,NULL),
(53,5,17,3,10.00,'2025-10-24 00:29:51','2025-10-24 00:29:51',NULL,NULL);

/*Table structure for table `orders_reservation` */

DROP TABLE IF EXISTS `orders_reservation`;

CREATE TABLE `orders_reservation` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `order_item_id` bigint unsigned NOT NULL,
  `batch_id` bigint unsigned NOT NULL,
  `qty` int NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_res_item` (`order_item_id`),
  KEY `ix_res_batch` (`batch_id`),
  CONSTRAINT `fk_res_batch` FOREIGN KEY (`batch_id`) REFERENCES `warehouses_inventorybatch` (`id`),
  CONSTRAINT `fk_res_item` FOREIGN KEY (`order_item_id`) REFERENCES `orders_orderitem` (`id`),
  CONSTRAINT `chk_res_qty` CHECK ((`qty` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `orders_reservation` */

insert  into `orders_reservation`(`id`,`order_item_id`,`batch_id`,`qty`,`created_at`,`updated_at`,`created_by_id`,`updated_by_id`) values 
(1,3,8,10,'2025-10-02 11:10:00','2025-10-23 01:21:48',NULL,NULL),
(2,4,4,8,'2025-10-02 11:15:00','2025-10-23 01:21:48',NULL,NULL),
(3,5,7,30,'2025-10-03 12:10:00','2025-10-23 01:21:48',NULL,NULL),
(4,6,8,20,'2025-10-03 12:12:00','2025-10-23 01:21:48',NULL,NULL),
(5,7,5,12,'2025-10-04 13:05:00','2025-10-23 01:21:48',NULL,NULL),
(6,8,6,15,'2025-10-04 13:06:00','2025-10-23 01:21:48',NULL,NULL);

/*Table structure for table `orders_retailerorder` */

DROP TABLE IF EXISTS `orders_retailerorder`;

CREATE TABLE `orders_retailerorder` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(32) NOT NULL,
  `retailer_id` bigint unsigned NOT NULL,
  `status` varchar(16) NOT NULL,
  `warehouse_id` bigint unsigned DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_order_code` (`code`),
  KEY `ix_order_retailer` (`retailer_id`),
  KEY `orders_reta_status_8db34d_idx` (`status`,`created_at`),
  KEY `fk_order_wh` (`warehouse_id`),
  KEY `ix_order_created` (`created_at`),
  CONSTRAINT `fk_order_retailer` FOREIGN KEY (`retailer_id`) REFERENCES `partners_retailer` (`id`),
  CONSTRAINT `fk_order_wh` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouses_warehouse` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `orders_retailerorder` */

insert  into `orders_retailerorder`(`id`,`code`,`retailer_id`,`status`,`warehouse_id`,`created_at`,`updated_at`,`created_by_id`,`updated_by_id`) values 
(1,'SO-20251001-001',1,'ALLOCATED',1,'2025-10-01 10:15:00','2025-10-23 04:38:53',NULL,NULL),
(2,'SO-20251002-002',2,'ALLOCATED',1,'2025-10-02 11:00:00','2025-10-02 11:30:00',NULL,NULL),
(3,'SO-20251003-003',4,'SHIPPED',3,'2025-10-03 12:00:00','2025-10-03 15:00:00',NULL,NULL),
(4,'SO-20251004-004',5,'DELIVERED',3,'2025-10-04 13:00:00','2025-10-05 10:00:00',NULL,NULL),
(5,'ORD00001',15,'ALLOCATED',6,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL),
(6,'ORD00002',6,'PLACED',5,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL),
(7,'ORD00003',14,'SHIPPED',6,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL),
(8,'ORD00004',13,'DRAFT',5,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL),
(9,'ORD00005',11,'DRAFT',5,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL),
(10,'ORD00006',10,'DELIVERED',6,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL),
(11,'ORD00007',10,'ALLOCATED',5,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL),
(12,'ORD00008',8,'ALLOCATED',5,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL),
(13,'ORD00009',15,'DRAFT',5,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL),
(14,'ORD00010',8,'ALLOCATED',5,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL),
(15,'ORD00011',8,'SHIPPED',6,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL),
(16,'ORD00012',9,'ALLOCATED',6,'2025-10-23 01:22:27','2025-10-23 04:38:48',NULL,NULL),
(17,'ORD00013',6,'DELIVERED',5,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL),
(18,'ORD00014',7,'DRAFT',6,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL),
(19,'ORD00015',9,'SHIPPED',5,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL),
(20,'ORD00016',6,'SHIPPED',6,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL),
(21,'ORD00017',7,'ALLOCATED',5,'2025-10-23 01:22:27','2025-10-23 04:38:42',NULL,NULL),
(22,'ORD00018',12,'DRAFT',5,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL),
(23,'ORD00019',8,'SHIPPED',6,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL),
(24,'ORD00020',12,'DRAFT',6,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL),
(30,'ped1',1,'ALLOCATED',NULL,'2025-10-23 04:39:17','2025-10-23 04:39:21',NULL,NULL),
(32,'CUST-IJ7G',1,'ALLOCATED',NULL,'2025-10-24 00:17:33','2025-10-24 00:17:38',NULL,NULL);

/*Table structure for table `partners_distributor` */

DROP TABLE IF EXISTS `partners_distributor`;

CREATE TABLE `partners_distributor` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(32) NOT NULL,
  `name` varchar(120) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_distributor_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `partners_distributor` */

insert  into `partners_distributor`(`id`,`code`,`name`,`created_at`,`updated_at`,`created_by_id`,`updated_by_id`) values 
(1,'D-001','Shanghai East Distributor','2025-10-23 01:21:44','2025-10-23 01:21:44',NULL,NULL),
(2,'D-002','Beijing North Distributor','2025-10-23 01:21:44','2025-10-23 01:21:44',NULL,NULL),
(3,'D-003','Guangzhou South Distributor','2025-10-23 01:21:44','2025-10-23 01:21:44',NULL,NULL),
(4,'DIST1','Distribuidor Uno','2025-10-23 01:22:25','2025-10-23 01:22:25',NULL,NULL);

/*Table structure for table `partners_retailer` */

DROP TABLE IF EXISTS `partners_retailer`;

CREATE TABLE `partners_retailer` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(32) NOT NULL,
  `name` varchar(120) NOT NULL,
  `distributor_id` bigint unsigned NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_retailer_code` (`code`),
  KEY `ix_retailer_distributor` (`distributor_id`),
  CONSTRAINT `fk_retailer_distributor` FOREIGN KEY (`distributor_id`) REFERENCES `partners_distributor` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `partners_retailer` */

insert  into `partners_retailer`(`id`,`code`,`name`,`distributor_id`,`created_at`,`updated_at`,`created_by_id`,`updated_by_id`) values 
(1,'R-001','Beauty House Nanjing Rd',1,'2025-10-23 01:21:44','2025-10-23 01:21:45',NULL,NULL),
(2,'R-002','Lotus Mall Pudong',1,'2025-10-23 01:21:44','2025-10-23 01:21:45',NULL,NULL),
(3,'R-003','Xidan Beauty Shop',2,'2025-10-23 01:21:44','2025-10-23 01:21:45',NULL,NULL),
(4,'R-004','Tianhe Skin Care Center',3,'2025-10-23 01:21:44','2025-10-23 01:21:45',NULL,NULL),
(5,'R-005','Shenzhen Bay Beauty',3,'2025-10-23 01:21:44','2025-10-23 01:21:45',NULL,NULL),
(6,'RET01','Retailer 1',4,'2025-10-23 01:22:25','2025-10-23 01:22:25',NULL,NULL),
(7,'RET02','Retailer 2',4,'2025-10-23 01:22:25','2025-10-23 01:22:25',NULL,NULL),
(8,'RET03','Retailer 3',4,'2025-10-23 01:22:25','2025-10-23 01:22:25',NULL,NULL),
(9,'RET04','Retailer 4',4,'2025-10-23 01:22:25','2025-10-23 01:22:25',NULL,NULL),
(10,'RET05','Retailer 5',4,'2025-10-23 01:22:25','2025-10-23 01:22:25',NULL,NULL),
(11,'RET06','Retailer 6',4,'2025-10-23 01:22:25','2025-10-23 01:22:25',NULL,NULL),
(12,'RET07','Retailer 7',4,'2025-10-23 01:22:25','2025-10-23 01:22:25',NULL,NULL),
(13,'RET08','Retailer 8',4,'2025-10-23 01:22:25','2025-10-23 01:22:25',NULL,NULL),
(14,'RET09','Retailer 9',4,'2025-10-23 01:22:25','2025-10-23 01:22:25',NULL,NULL),
(15,'RET10','Retailer 10',4,'2025-10-23 01:22:25','2025-10-23 01:22:25',NULL,NULL);

/*Table structure for table `pricing_priceitem` */

DROP TABLE IF EXISTS `pricing_priceitem`;

CREATE TABLE `pricing_priceitem` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `pricelist_id` bigint unsigned NOT NULL,
  `sku_id` bigint unsigned NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `valid_from` datetime NOT NULL,
  `valid_to` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_priceitem` (`pricelist_id`,`sku_id`,`valid_from`),
  KEY `ix_priceitem_sku` (`sku_id`),
  CONSTRAINT `fk_priceitem_pricelist` FOREIGN KEY (`pricelist_id`) REFERENCES `pricing_pricelist` (`id`),
  CONSTRAINT `fk_priceitem_sku` FOREIGN KEY (`sku_id`) REFERENCES `catalog_sku` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=227 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `pricing_priceitem` */

insert  into `pricing_priceitem`(`id`,`pricelist_id`,`sku_id`,`amount`,`valid_from`,`valid_to`,`created_at`,`updated_at`,`created_by_id`,`updated_by_id`) values 
(1,1,1,12.50,'2025-09-01 00:00:00',NULL,'2025-10-23 01:21:46','2025-10-23 01:21:46',NULL,NULL),
(2,1,2,18.00,'2025-09-01 00:00:00',NULL,'2025-10-23 01:21:46','2025-10-23 01:21:46',NULL,NULL),
(3,1,3,24.00,'2025-09-01 00:00:00',NULL,'2025-10-23 01:21:46','2025-10-23 01:21:46',NULL,NULL),
(4,1,4,22.00,'2025-09-01 00:00:00',NULL,'2025-10-23 01:21:46','2025-10-23 01:21:46',NULL,NULL),
(5,1,5,19.00,'2025-09-01 00:00:00',NULL,'2025-10-23 01:21:46','2025-10-23 01:21:46',NULL,NULL),
(6,1,6,30.00,'2025-09-01 00:00:00',NULL,'2025-10-23 01:21:46','2025-10-23 01:21:46',NULL,NULL),
(7,2,7,15.00,'2025-10-23 01:22:26',NULL,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(8,2,8,19.00,'2025-10-23 01:22:26',NULL,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(9,2,9,20.00,'2025-10-23 01:22:26',NULL,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(10,2,10,19.00,'2025-10-23 01:22:26',NULL,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(11,2,11,19.00,'2025-10-23 01:22:26',NULL,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(12,2,12,7.00,'2025-10-23 01:22:26',NULL,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(13,2,13,19.00,'2025-10-23 01:22:26',NULL,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(14,2,14,7.00,'2025-10-23 01:22:26',NULL,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(15,2,15,8.00,'2025-10-23 01:22:26',NULL,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(16,2,16,8.00,'2025-10-23 01:22:26',NULL,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(17,2,17,15.00,'2025-10-23 01:22:26',NULL,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(18,2,18,16.00,'2025-10-23 01:22:26',NULL,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(19,2,19,18.00,'2025-10-23 01:22:26',NULL,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(20,2,20,14.00,'2025-10-23 01:22:26',NULL,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(21,2,21,17.00,'2025-10-23 01:22:26',NULL,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(22,2,22,10.00,'2025-10-23 01:22:26',NULL,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(23,2,23,6.00,'2025-10-23 01:22:26',NULL,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(24,2,24,11.00,'2025-10-23 01:22:26',NULL,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(25,2,25,10.00,'2025-10-23 01:22:26',NULL,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(26,2,26,17.00,'2025-10-23 01:22:26',NULL,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(27,2,7,20.00,'2025-10-23 01:35:53',NULL,'2025-10-23 01:35:53','2025-10-23 01:35:53',NULL,NULL),
(28,2,8,17.00,'2025-10-23 01:35:53',NULL,'2025-10-23 01:35:53','2025-10-23 01:35:53',NULL,NULL),
(29,2,9,8.00,'2025-10-23 01:35:53',NULL,'2025-10-23 01:35:53','2025-10-23 01:35:53',NULL,NULL),
(30,2,10,8.00,'2025-10-23 01:35:53',NULL,'2025-10-23 01:35:53','2025-10-23 01:35:53',NULL,NULL),
(31,2,11,16.00,'2025-10-23 01:35:53',NULL,'2025-10-23 01:35:53','2025-10-23 01:35:53',NULL,NULL),
(32,2,12,11.00,'2025-10-23 01:35:53',NULL,'2025-10-23 01:35:53','2025-10-23 01:35:53',NULL,NULL),
(33,2,13,12.00,'2025-10-23 01:35:53',NULL,'2025-10-23 01:35:53','2025-10-23 01:35:53',NULL,NULL),
(34,2,14,10.00,'2025-10-23 01:35:53',NULL,'2025-10-23 01:35:53','2025-10-23 01:35:53',NULL,NULL),
(35,2,15,13.00,'2025-10-23 01:35:53',NULL,'2025-10-23 01:35:53','2025-10-23 01:35:53',NULL,NULL),
(36,2,16,7.00,'2025-10-23 01:35:53',NULL,'2025-10-23 01:35:53','2025-10-23 01:35:53',NULL,NULL),
(37,2,17,18.00,'2025-10-23 01:35:53',NULL,'2025-10-23 01:35:53','2025-10-23 01:35:53',NULL,NULL),
(38,2,18,5.00,'2025-10-23 01:35:53',NULL,'2025-10-23 01:35:53','2025-10-23 01:35:53',NULL,NULL),
(39,2,19,13.00,'2025-10-23 01:35:53',NULL,'2025-10-23 01:35:53','2025-10-23 01:35:53',NULL,NULL),
(40,2,20,9.00,'2025-10-23 01:35:53',NULL,'2025-10-23 01:35:53','2025-10-23 01:35:53',NULL,NULL),
(41,2,21,14.00,'2025-10-23 01:35:53',NULL,'2025-10-23 01:35:53','2025-10-23 01:35:53',NULL,NULL),
(42,2,22,20.00,'2025-10-23 01:35:53',NULL,'2025-10-23 01:35:53','2025-10-23 01:35:53',NULL,NULL),
(43,2,23,5.00,'2025-10-23 01:35:53',NULL,'2025-10-23 01:35:53','2025-10-23 01:35:53',NULL,NULL),
(44,2,24,9.00,'2025-10-23 01:35:53',NULL,'2025-10-23 01:35:53','2025-10-23 01:35:53',NULL,NULL),
(45,2,25,9.00,'2025-10-23 01:35:53',NULL,'2025-10-23 01:35:53','2025-10-23 01:35:53',NULL,NULL),
(46,2,26,20.00,'2025-10-23 01:35:53',NULL,'2025-10-23 01:35:53','2025-10-23 01:35:53',NULL,NULL),
(47,2,7,19.00,'2025-10-23 01:40:09',NULL,'2025-10-23 01:40:09','2025-10-23 01:40:09',NULL,NULL),
(48,2,8,5.00,'2025-10-23 01:40:09',NULL,'2025-10-23 01:40:09','2025-10-23 01:40:09',NULL,NULL),
(49,2,9,14.00,'2025-10-23 01:40:09',NULL,'2025-10-23 01:40:09','2025-10-23 01:40:09',NULL,NULL),
(50,2,10,16.00,'2025-10-23 01:40:09',NULL,'2025-10-23 01:40:09','2025-10-23 01:40:09',NULL,NULL),
(51,2,11,20.00,'2025-10-23 01:40:09',NULL,'2025-10-23 01:40:09','2025-10-23 01:40:09',NULL,NULL),
(52,2,12,14.00,'2025-10-23 01:40:09',NULL,'2025-10-23 01:40:09','2025-10-23 01:40:09',NULL,NULL),
(53,2,13,20.00,'2025-10-23 01:40:09',NULL,'2025-10-23 01:40:09','2025-10-23 01:40:09',NULL,NULL),
(54,2,14,18.00,'2025-10-23 01:40:09',NULL,'2025-10-23 01:40:09','2025-10-23 01:40:09',NULL,NULL),
(55,2,15,6.00,'2025-10-23 01:40:09',NULL,'2025-10-23 01:40:09','2025-10-23 01:40:09',NULL,NULL),
(56,2,16,7.00,'2025-10-23 01:40:09',NULL,'2025-10-23 01:40:09','2025-10-23 01:40:09',NULL,NULL),
(57,2,17,12.00,'2025-10-23 01:40:09',NULL,'2025-10-23 01:40:09','2025-10-23 01:40:09',NULL,NULL),
(58,2,18,17.00,'2025-10-23 01:40:09',NULL,'2025-10-23 01:40:09','2025-10-23 01:40:09',NULL,NULL),
(59,2,19,16.00,'2025-10-23 01:40:09',NULL,'2025-10-23 01:40:09','2025-10-23 01:40:09',NULL,NULL),
(60,2,20,11.00,'2025-10-23 01:40:09',NULL,'2025-10-23 01:40:09','2025-10-23 01:40:09',NULL,NULL),
(61,2,21,20.00,'2025-10-23 01:40:09',NULL,'2025-10-23 01:40:09','2025-10-23 01:40:09',NULL,NULL),
(62,2,22,18.00,'2025-10-23 01:40:09',NULL,'2025-10-23 01:40:09','2025-10-23 01:40:09',NULL,NULL),
(63,2,23,7.00,'2025-10-23 01:40:09',NULL,'2025-10-23 01:40:09','2025-10-23 01:40:09',NULL,NULL),
(64,2,24,6.00,'2025-10-23 01:40:09',NULL,'2025-10-23 01:40:09','2025-10-23 01:40:09',NULL,NULL),
(65,2,25,8.00,'2025-10-23 01:40:09',NULL,'2025-10-23 01:40:09','2025-10-23 01:40:09',NULL,NULL),
(66,2,26,17.00,'2025-10-23 01:40:09',NULL,'2025-10-23 01:40:09','2025-10-23 01:40:09',NULL,NULL),
(67,2,7,7.00,'2025-10-23 03:29:03',NULL,'2025-10-23 03:29:03','2025-10-23 03:29:03',NULL,NULL),
(68,2,8,6.00,'2025-10-23 03:29:03',NULL,'2025-10-23 03:29:03','2025-10-23 03:29:03',NULL,NULL),
(69,2,9,13.00,'2025-10-23 03:29:03',NULL,'2025-10-23 03:29:03','2025-10-23 03:29:03',NULL,NULL),
(70,2,10,20.00,'2025-10-23 03:29:03',NULL,'2025-10-23 03:29:03','2025-10-23 03:29:03',NULL,NULL),
(71,2,11,18.00,'2025-10-23 03:29:03',NULL,'2025-10-23 03:29:03','2025-10-23 03:29:03',NULL,NULL),
(72,2,12,9.00,'2025-10-23 03:29:03',NULL,'2025-10-23 03:29:03','2025-10-23 03:29:03',NULL,NULL),
(73,2,13,6.00,'2025-10-23 03:29:03',NULL,'2025-10-23 03:29:03','2025-10-23 03:29:03',NULL,NULL),
(74,2,14,18.00,'2025-10-23 03:29:03',NULL,'2025-10-23 03:29:03','2025-10-23 03:29:03',NULL,NULL),
(75,2,15,11.00,'2025-10-23 03:29:03',NULL,'2025-10-23 03:29:03','2025-10-23 03:29:03',NULL,NULL),
(76,2,16,16.00,'2025-10-23 03:29:03',NULL,'2025-10-23 03:29:03','2025-10-23 03:29:03',NULL,NULL),
(77,2,17,9.00,'2025-10-23 03:29:03',NULL,'2025-10-23 03:29:03','2025-10-23 03:29:03',NULL,NULL),
(78,2,18,12.00,'2025-10-23 03:29:03',NULL,'2025-10-23 03:29:03','2025-10-23 03:29:03',NULL,NULL),
(79,2,19,17.00,'2025-10-23 03:29:03',NULL,'2025-10-23 03:29:03','2025-10-23 03:29:03',NULL,NULL),
(80,2,20,17.00,'2025-10-23 03:29:03',NULL,'2025-10-23 03:29:03','2025-10-23 03:29:03',NULL,NULL),
(81,2,21,6.00,'2025-10-23 03:29:03',NULL,'2025-10-23 03:29:03','2025-10-23 03:29:03',NULL,NULL),
(82,2,22,11.00,'2025-10-23 03:29:03',NULL,'2025-10-23 03:29:03','2025-10-23 03:29:03',NULL,NULL),
(83,2,23,18.00,'2025-10-23 03:29:03',NULL,'2025-10-23 03:29:03','2025-10-23 03:29:03',NULL,NULL),
(84,2,24,19.00,'2025-10-23 03:29:03',NULL,'2025-10-23 03:29:03','2025-10-23 03:29:03',NULL,NULL),
(85,2,25,6.00,'2025-10-23 03:29:03',NULL,'2025-10-23 03:29:03','2025-10-23 03:29:03',NULL,NULL),
(86,2,26,11.00,'2025-10-23 03:29:03',NULL,'2025-10-23 03:29:03','2025-10-23 03:29:03',NULL,NULL),
(87,2,7,13.00,'2025-10-23 03:30:04',NULL,'2025-10-23 03:30:04','2025-10-23 03:30:04',NULL,NULL),
(88,2,8,14.00,'2025-10-23 03:30:04',NULL,'2025-10-23 03:30:04','2025-10-23 03:30:04',NULL,NULL),
(89,2,9,19.00,'2025-10-23 03:30:04',NULL,'2025-10-23 03:30:04','2025-10-23 03:30:04',NULL,NULL),
(90,2,10,9.00,'2025-10-23 03:30:04',NULL,'2025-10-23 03:30:04','2025-10-23 03:30:04',NULL,NULL),
(91,2,11,10.00,'2025-10-23 03:30:04',NULL,'2025-10-23 03:30:04','2025-10-23 03:30:04',NULL,NULL),
(92,2,12,20.00,'2025-10-23 03:30:04',NULL,'2025-10-23 03:30:04','2025-10-23 03:30:04',NULL,NULL),
(93,2,13,8.00,'2025-10-23 03:30:04',NULL,'2025-10-23 03:30:04','2025-10-23 03:30:04',NULL,NULL),
(94,2,14,15.00,'2025-10-23 03:30:04',NULL,'2025-10-23 03:30:04','2025-10-23 03:30:04',NULL,NULL),
(95,2,15,11.00,'2025-10-23 03:30:04',NULL,'2025-10-23 03:30:04','2025-10-23 03:30:04',NULL,NULL),
(96,2,16,14.00,'2025-10-23 03:30:04',NULL,'2025-10-23 03:30:04','2025-10-23 03:30:04',NULL,NULL),
(97,2,17,20.00,'2025-10-23 03:30:04',NULL,'2025-10-23 03:30:04','2025-10-23 03:30:04',NULL,NULL),
(98,2,18,17.00,'2025-10-23 03:30:04',NULL,'2025-10-23 03:30:04','2025-10-23 03:30:04',NULL,NULL),
(99,2,19,10.00,'2025-10-23 03:30:04',NULL,'2025-10-23 03:30:04','2025-10-23 03:30:04',NULL,NULL),
(100,2,20,6.00,'2025-10-23 03:30:04',NULL,'2025-10-23 03:30:04','2025-10-23 03:30:04',NULL,NULL),
(101,2,21,10.00,'2025-10-23 03:30:04',NULL,'2025-10-23 03:30:04','2025-10-23 03:30:04',NULL,NULL),
(102,2,22,16.00,'2025-10-23 03:30:04',NULL,'2025-10-23 03:30:04','2025-10-23 03:30:04',NULL,NULL),
(103,2,23,13.00,'2025-10-23 03:30:04',NULL,'2025-10-23 03:30:04','2025-10-23 03:30:04',NULL,NULL),
(104,2,24,7.00,'2025-10-23 03:30:04',NULL,'2025-10-23 03:30:04','2025-10-23 03:30:04',NULL,NULL),
(105,2,25,17.00,'2025-10-23 03:30:04',NULL,'2025-10-23 03:30:04','2025-10-23 03:30:04',NULL,NULL),
(106,2,26,9.00,'2025-10-23 03:30:04',NULL,'2025-10-23 03:30:04','2025-10-23 03:30:04',NULL,NULL),
(107,2,7,20.00,'2025-10-23 04:37:47',NULL,'2025-10-23 04:37:47','2025-10-23 04:37:47',NULL,NULL),
(108,2,8,7.00,'2025-10-23 04:37:47',NULL,'2025-10-23 04:37:47','2025-10-23 04:37:47',NULL,NULL),
(109,2,9,7.00,'2025-10-23 04:37:47',NULL,'2025-10-23 04:37:47','2025-10-23 04:37:47',NULL,NULL),
(110,2,10,6.00,'2025-10-23 04:37:47',NULL,'2025-10-23 04:37:47','2025-10-23 04:37:47',NULL,NULL),
(111,2,11,9.00,'2025-10-23 04:37:47',NULL,'2025-10-23 04:37:47','2025-10-23 04:37:47',NULL,NULL),
(112,2,12,20.00,'2025-10-23 04:37:47',NULL,'2025-10-23 04:37:47','2025-10-23 04:37:47',NULL,NULL),
(113,2,13,14.00,'2025-10-23 04:37:47',NULL,'2025-10-23 04:37:47','2025-10-23 04:37:47',NULL,NULL),
(114,2,14,10.00,'2025-10-23 04:37:47',NULL,'2025-10-23 04:37:47','2025-10-23 04:37:47',NULL,NULL),
(115,2,15,6.00,'2025-10-23 04:37:47',NULL,'2025-10-23 04:37:47','2025-10-23 04:37:47',NULL,NULL),
(116,2,16,5.00,'2025-10-23 04:37:47',NULL,'2025-10-23 04:37:47','2025-10-23 04:37:47',NULL,NULL),
(117,2,17,14.00,'2025-10-23 04:37:47',NULL,'2025-10-23 04:37:47','2025-10-23 04:37:47',NULL,NULL),
(118,2,18,7.00,'2025-10-23 04:37:47',NULL,'2025-10-23 04:37:47','2025-10-23 04:37:47',NULL,NULL),
(119,2,19,20.00,'2025-10-23 04:37:47',NULL,'2025-10-23 04:37:47','2025-10-23 04:37:47',NULL,NULL),
(120,2,20,6.00,'2025-10-23 04:37:47',NULL,'2025-10-23 04:37:47','2025-10-23 04:37:47',NULL,NULL),
(121,2,21,9.00,'2025-10-23 04:37:47',NULL,'2025-10-23 04:37:47','2025-10-23 04:37:47',NULL,NULL),
(122,2,22,17.00,'2025-10-23 04:37:47',NULL,'2025-10-23 04:37:47','2025-10-23 04:37:47',NULL,NULL),
(123,2,23,18.00,'2025-10-23 04:37:47',NULL,'2025-10-23 04:37:47','2025-10-23 04:37:47',NULL,NULL),
(124,2,24,19.00,'2025-10-23 04:37:47',NULL,'2025-10-23 04:37:47','2025-10-23 04:37:47',NULL,NULL),
(125,2,25,14.00,'2025-10-23 04:37:47',NULL,'2025-10-23 04:37:47','2025-10-23 04:37:47',NULL,NULL),
(126,2,26,11.00,'2025-10-23 04:37:47',NULL,'2025-10-23 04:37:47','2025-10-23 04:37:47',NULL,NULL),
(127,2,7,19.00,'2025-10-24 00:03:57',NULL,'2025-10-24 00:03:57','2025-10-24 00:03:57',NULL,NULL),
(128,2,8,7.00,'2025-10-24 00:03:57',NULL,'2025-10-24 00:03:57','2025-10-24 00:03:57',NULL,NULL),
(129,2,9,13.00,'2025-10-24 00:03:57',NULL,'2025-10-24 00:03:57','2025-10-24 00:03:57',NULL,NULL),
(130,2,10,16.00,'2025-10-24 00:03:57',NULL,'2025-10-24 00:03:57','2025-10-24 00:03:57',NULL,NULL),
(131,2,11,20.00,'2025-10-24 00:03:57',NULL,'2025-10-24 00:03:57','2025-10-24 00:03:57',NULL,NULL),
(132,2,12,6.00,'2025-10-24 00:03:57',NULL,'2025-10-24 00:03:57','2025-10-24 00:03:57',NULL,NULL),
(133,2,13,19.00,'2025-10-24 00:03:57',NULL,'2025-10-24 00:03:57','2025-10-24 00:03:57',NULL,NULL),
(134,2,14,13.00,'2025-10-24 00:03:57',NULL,'2025-10-24 00:03:57','2025-10-24 00:03:57',NULL,NULL),
(135,2,15,11.00,'2025-10-24 00:03:57',NULL,'2025-10-24 00:03:57','2025-10-24 00:03:57',NULL,NULL),
(136,2,16,12.00,'2025-10-24 00:03:57',NULL,'2025-10-24 00:03:57','2025-10-24 00:03:57',NULL,NULL),
(137,2,17,18.00,'2025-10-24 00:03:57',NULL,'2025-10-24 00:03:57','2025-10-24 00:03:57',NULL,NULL),
(138,2,18,12.00,'2025-10-24 00:03:57',NULL,'2025-10-24 00:03:57','2025-10-24 00:03:57',NULL,NULL),
(139,2,19,11.00,'2025-10-24 00:03:57',NULL,'2025-10-24 00:03:57','2025-10-24 00:03:57',NULL,NULL),
(140,2,20,15.00,'2025-10-24 00:03:57',NULL,'2025-10-24 00:03:57','2025-10-24 00:03:57',NULL,NULL),
(141,2,21,7.00,'2025-10-24 00:03:57',NULL,'2025-10-24 00:03:57','2025-10-24 00:03:57',NULL,NULL),
(142,2,22,17.00,'2025-10-24 00:03:57',NULL,'2025-10-24 00:03:57','2025-10-24 00:03:57',NULL,NULL),
(143,2,23,7.00,'2025-10-24 00:03:57',NULL,'2025-10-24 00:03:57','2025-10-24 00:03:57',NULL,NULL),
(144,2,24,15.00,'2025-10-24 00:03:57',NULL,'2025-10-24 00:03:57','2025-10-24 00:03:57',NULL,NULL),
(145,2,25,7.00,'2025-10-24 00:03:57',NULL,'2025-10-24 00:03:57','2025-10-24 00:03:57',NULL,NULL),
(146,2,26,11.00,'2025-10-24 00:03:57',NULL,'2025-10-24 00:03:57','2025-10-24 00:03:57',NULL,NULL),
(147,2,7,7.00,'2025-10-24 00:29:51',NULL,'2025-10-24 00:29:51','2025-10-24 00:29:51',NULL,NULL),
(148,2,8,19.00,'2025-10-24 00:29:51',NULL,'2025-10-24 00:29:51','2025-10-24 00:29:51',NULL,NULL),
(149,2,9,20.00,'2025-10-24 00:29:51',NULL,'2025-10-24 00:29:51','2025-10-24 00:29:51',NULL,NULL),
(150,2,10,15.00,'2025-10-24 00:29:51',NULL,'2025-10-24 00:29:51','2025-10-24 00:29:51',NULL,NULL),
(151,2,11,5.00,'2025-10-24 00:29:51',NULL,'2025-10-24 00:29:51','2025-10-24 00:29:51',NULL,NULL),
(152,2,12,9.00,'2025-10-24 00:29:51',NULL,'2025-10-24 00:29:51','2025-10-24 00:29:51',NULL,NULL),
(153,2,13,20.00,'2025-10-24 00:29:51',NULL,'2025-10-24 00:29:51','2025-10-24 00:29:51',NULL,NULL),
(154,2,14,6.00,'2025-10-24 00:29:51',NULL,'2025-10-24 00:29:51','2025-10-24 00:29:51',NULL,NULL),
(155,2,15,14.00,'2025-10-24 00:29:51',NULL,'2025-10-24 00:29:51','2025-10-24 00:29:51',NULL,NULL),
(156,2,16,19.00,'2025-10-24 00:29:51',NULL,'2025-10-24 00:29:51','2025-10-24 00:29:51',NULL,NULL),
(157,2,17,20.00,'2025-10-24 00:29:51',NULL,'2025-10-24 00:29:51','2025-10-24 00:29:51',NULL,NULL),
(158,2,18,10.00,'2025-10-24 00:29:51',NULL,'2025-10-24 00:29:51','2025-10-24 00:29:51',NULL,NULL),
(159,2,19,16.00,'2025-10-24 00:29:51',NULL,'2025-10-24 00:29:51','2025-10-24 00:29:51',NULL,NULL),
(160,2,20,8.00,'2025-10-24 00:29:51',NULL,'2025-10-24 00:29:51','2025-10-24 00:29:51',NULL,NULL),
(161,2,21,13.00,'2025-10-24 00:29:51',NULL,'2025-10-24 00:29:51','2025-10-24 00:29:51',NULL,NULL),
(162,2,22,17.00,'2025-10-24 00:29:51',NULL,'2025-10-24 00:29:51','2025-10-24 00:29:51',NULL,NULL),
(163,2,23,10.00,'2025-10-24 00:29:51',NULL,'2025-10-24 00:29:51','2025-10-24 00:29:51',NULL,NULL),
(164,2,24,9.00,'2025-10-24 00:29:51',NULL,'2025-10-24 00:29:51','2025-10-24 00:29:51',NULL,NULL),
(165,2,25,9.00,'2025-10-24 00:29:51',NULL,'2025-10-24 00:29:51','2025-10-24 00:29:51',NULL,NULL),
(166,2,26,11.00,'2025-10-24 00:29:51',NULL,'2025-10-24 00:29:51','2025-10-24 00:29:51',NULL,NULL),
(167,2,7,13.00,'2025-10-24 00:38:29',NULL,'2025-10-24 00:38:29','2025-10-24 00:38:29',NULL,NULL),
(168,2,8,9.00,'2025-10-24 00:38:29',NULL,'2025-10-24 00:38:29','2025-10-24 00:38:29',NULL,NULL),
(169,2,9,18.00,'2025-10-24 00:38:29',NULL,'2025-10-24 00:38:29','2025-10-24 00:38:29',NULL,NULL),
(170,2,10,14.00,'2025-10-24 00:38:29',NULL,'2025-10-24 00:38:29','2025-10-24 00:38:29',NULL,NULL),
(171,2,11,18.00,'2025-10-24 00:38:29',NULL,'2025-10-24 00:38:29','2025-10-24 00:38:29',NULL,NULL),
(172,2,12,8.00,'2025-10-24 00:38:29',NULL,'2025-10-24 00:38:29','2025-10-24 00:38:29',NULL,NULL),
(173,2,13,16.00,'2025-10-24 00:38:29',NULL,'2025-10-24 00:38:29','2025-10-24 00:38:29',NULL,NULL),
(174,2,14,10.00,'2025-10-24 00:38:29',NULL,'2025-10-24 00:38:29','2025-10-24 00:38:29',NULL,NULL),
(175,2,15,11.00,'2025-10-24 00:38:29',NULL,'2025-10-24 00:38:29','2025-10-24 00:38:29',NULL,NULL),
(176,2,16,14.00,'2025-10-24 00:38:29',NULL,'2025-10-24 00:38:29','2025-10-24 00:38:29',NULL,NULL),
(177,2,17,7.00,'2025-10-24 00:38:29',NULL,'2025-10-24 00:38:29','2025-10-24 00:38:29',NULL,NULL),
(178,2,18,16.00,'2025-10-24 00:38:29',NULL,'2025-10-24 00:38:29','2025-10-24 00:38:29',NULL,NULL),
(179,2,19,7.00,'2025-10-24 00:38:29',NULL,'2025-10-24 00:38:29','2025-10-24 00:38:29',NULL,NULL),
(180,2,20,15.00,'2025-10-24 00:38:29',NULL,'2025-10-24 00:38:29','2025-10-24 00:38:29',NULL,NULL),
(181,2,21,19.00,'2025-10-24 00:38:29',NULL,'2025-10-24 00:38:29','2025-10-24 00:38:29',NULL,NULL),
(182,2,22,9.00,'2025-10-24 00:38:29',NULL,'2025-10-24 00:38:29','2025-10-24 00:38:29',NULL,NULL),
(183,2,23,8.00,'2025-10-24 00:38:29',NULL,'2025-10-24 00:38:29','2025-10-24 00:38:29',NULL,NULL),
(184,2,24,13.00,'2025-10-24 00:38:29',NULL,'2025-10-24 00:38:29','2025-10-24 00:38:29',NULL,NULL),
(185,2,25,12.00,'2025-10-24 00:38:29',NULL,'2025-10-24 00:38:29','2025-10-24 00:38:29',NULL,NULL),
(186,2,26,15.00,'2025-10-24 00:38:29',NULL,'2025-10-24 00:38:29','2025-10-24 00:38:29',NULL,NULL),
(187,2,7,9.00,'2025-10-24 00:48:40',NULL,'2025-10-24 00:48:40','2025-10-24 00:48:40',NULL,NULL),
(188,2,8,20.00,'2025-10-24 00:48:40',NULL,'2025-10-24 00:48:40','2025-10-24 00:48:40',NULL,NULL),
(189,2,9,11.00,'2025-10-24 00:48:40',NULL,'2025-10-24 00:48:40','2025-10-24 00:48:40',NULL,NULL),
(190,2,10,20.00,'2025-10-24 00:48:40',NULL,'2025-10-24 00:48:40','2025-10-24 00:48:40',NULL,NULL),
(191,2,11,6.00,'2025-10-24 00:48:40',NULL,'2025-10-24 00:48:40','2025-10-24 00:48:40',NULL,NULL),
(192,2,12,14.00,'2025-10-24 00:48:40',NULL,'2025-10-24 00:48:40','2025-10-24 00:48:40',NULL,NULL),
(193,2,13,7.00,'2025-10-24 00:48:40',NULL,'2025-10-24 00:48:40','2025-10-24 00:48:40',NULL,NULL),
(194,2,14,13.00,'2025-10-24 00:48:40',NULL,'2025-10-24 00:48:40','2025-10-24 00:48:40',NULL,NULL),
(195,2,15,10.00,'2025-10-24 00:48:40',NULL,'2025-10-24 00:48:40','2025-10-24 00:48:40',NULL,NULL),
(196,2,16,9.00,'2025-10-24 00:48:40',NULL,'2025-10-24 00:48:40','2025-10-24 00:48:40',NULL,NULL),
(197,2,17,8.00,'2025-10-24 00:48:40',NULL,'2025-10-24 00:48:40','2025-10-24 00:48:40',NULL,NULL),
(198,2,18,18.00,'2025-10-24 00:48:40',NULL,'2025-10-24 00:48:40','2025-10-24 00:48:40',NULL,NULL),
(199,2,19,12.00,'2025-10-24 00:48:40',NULL,'2025-10-24 00:48:40','2025-10-24 00:48:40',NULL,NULL),
(200,2,20,19.00,'2025-10-24 00:48:40',NULL,'2025-10-24 00:48:40','2025-10-24 00:48:40',NULL,NULL),
(201,2,21,20.00,'2025-10-24 00:48:40',NULL,'2025-10-24 00:48:40','2025-10-24 00:48:40',NULL,NULL),
(202,2,22,13.00,'2025-10-24 00:48:40',NULL,'2025-10-24 00:48:40','2025-10-24 00:48:40',NULL,NULL),
(203,2,23,8.00,'2025-10-24 00:48:40',NULL,'2025-10-24 00:48:40','2025-10-24 00:48:40',NULL,NULL),
(204,2,24,11.00,'2025-10-24 00:48:40',NULL,'2025-10-24 00:48:40','2025-10-24 00:48:40',NULL,NULL),
(205,2,25,6.00,'2025-10-24 00:48:40',NULL,'2025-10-24 00:48:40','2025-10-24 00:48:40',NULL,NULL),
(206,2,26,7.00,'2025-10-24 00:48:40',NULL,'2025-10-24 00:48:40','2025-10-24 00:48:40',NULL,NULL),
(207,2,7,15.00,'2025-10-24 01:33:46',NULL,'2025-10-24 01:33:46','2025-10-24 01:33:46',NULL,NULL),
(208,2,8,5.00,'2025-10-24 01:33:46',NULL,'2025-10-24 01:33:46','2025-10-24 01:33:46',NULL,NULL),
(209,2,9,11.00,'2025-10-24 01:33:46',NULL,'2025-10-24 01:33:46','2025-10-24 01:33:46',NULL,NULL),
(210,2,10,19.00,'2025-10-24 01:33:46',NULL,'2025-10-24 01:33:46','2025-10-24 01:33:46',NULL,NULL),
(211,2,11,9.00,'2025-10-24 01:33:46',NULL,'2025-10-24 01:33:46','2025-10-24 01:33:46',NULL,NULL),
(212,2,12,8.00,'2025-10-24 01:33:46',NULL,'2025-10-24 01:33:46','2025-10-24 01:33:46',NULL,NULL),
(213,2,13,11.00,'2025-10-24 01:33:46',NULL,'2025-10-24 01:33:46','2025-10-24 01:33:46',NULL,NULL),
(214,2,14,14.00,'2025-10-24 01:33:46',NULL,'2025-10-24 01:33:46','2025-10-24 01:33:46',NULL,NULL),
(215,2,15,20.00,'2025-10-24 01:33:46',NULL,'2025-10-24 01:33:46','2025-10-24 01:33:46',NULL,NULL),
(216,2,16,6.00,'2025-10-24 01:33:46',NULL,'2025-10-24 01:33:46','2025-10-24 01:33:46',NULL,NULL),
(217,2,17,6.00,'2025-10-24 01:33:46',NULL,'2025-10-24 01:33:46','2025-10-24 01:33:46',NULL,NULL),
(218,2,18,19.00,'2025-10-24 01:33:46',NULL,'2025-10-24 01:33:46','2025-10-24 01:33:46',NULL,NULL),
(219,2,19,18.00,'2025-10-24 01:33:46',NULL,'2025-10-24 01:33:46','2025-10-24 01:33:46',NULL,NULL),
(220,2,20,16.00,'2025-10-24 01:33:46',NULL,'2025-10-24 01:33:46','2025-10-24 01:33:46',NULL,NULL),
(221,2,21,16.00,'2025-10-24 01:33:46',NULL,'2025-10-24 01:33:46','2025-10-24 01:33:46',NULL,NULL),
(222,2,22,16.00,'2025-10-24 01:33:46',NULL,'2025-10-24 01:33:46','2025-10-24 01:33:46',NULL,NULL),
(223,2,23,20.00,'2025-10-24 01:33:46',NULL,'2025-10-24 01:33:46','2025-10-24 01:33:46',NULL,NULL),
(224,2,24,12.00,'2025-10-24 01:33:46',NULL,'2025-10-24 01:33:46','2025-10-24 01:33:46',NULL,NULL),
(225,2,25,16.00,'2025-10-24 01:33:46',NULL,'2025-10-24 01:33:46','2025-10-24 01:33:46',NULL,NULL),
(226,2,26,7.00,'2025-10-24 01:33:46',NULL,'2025-10-24 01:33:46','2025-10-24 01:33:46',NULL,NULL);

/*Table structure for table `pricing_pricelist` */

DROP TABLE IF EXISTS `pricing_pricelist`;

CREATE TABLE `pricing_pricelist` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(120) NOT NULL,
  `currency` char(3) NOT NULL DEFAULT 'USD',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_pricelist_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `pricing_pricelist` */

insert  into `pricing_pricelist`(`id`,`name`,`currency`,`is_active`,`created_at`,`updated_at`,`created_by_id`,`updated_by_id`) values 
(1,'Retail USD 2025','USD',1,'2025-10-23 01:21:46','2025-10-23 01:21:46',NULL,NULL),
(2,'General','USD',1,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL);

/*Table structure for table `promo_promotion` */

DROP TABLE IF EXISTS `promo_promotion`;

CREATE TABLE `promo_promotion` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(120) NOT NULL,
  `percent_off` decimal(5,2) NOT NULL DEFAULT '0.00',
  `starts_at` datetime NOT NULL,
  `ends_at` datetime NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `promo_promotion` */

insert  into `promo_promotion`(`id`,`name`,`percent_off`,`starts_at`,`ends_at`,`is_active`,`created_at`,`updated_at`,`created_by_id`,`updated_by_id`) values 
(1,'Autumn Hydration',10.00,'2025-10-01 00:00:00','2025-10-31 23:59:59',1,'2025-10-23 01:21:46','2025-10-23 01:21:46',NULL,NULL),
(2,'Singles Day 2025',15.00,'2025-11-01 00:00:00','2025-11-12 23:59:59',1,'2025-10-23 01:21:46','2025-10-23 01:21:46',NULL,NULL);

/*Table structure for table `promo_promotion_skus` */

DROP TABLE IF EXISTS `promo_promotion_skus`;

CREATE TABLE `promo_promotion_skus` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `promotion_id` bigint unsigned NOT NULL,
  `sku_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_promo_sku` (`promotion_id`,`sku_id`),
  KEY `fk_promo_sku_sku` (`sku_id`),
  CONSTRAINT `fk_promo_sku_promo` FOREIGN KEY (`promotion_id`) REFERENCES `promo_promotion` (`id`),
  CONSTRAINT `fk_promo_sku_sku` FOREIGN KEY (`sku_id`) REFERENCES `catalog_sku` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `promo_promotion_skus` */

insert  into `promo_promotion_skus`(`id`,`promotion_id`,`sku_id`) values 
(1,1,2),
(2,1,3),
(3,1,4),
(4,2,1),
(5,2,2),
(6,2,3),
(7,2,4),
(8,2,5),
(9,2,6);

/*Table structure for table `returns_buyback` */

DROP TABLE IF EXISTS `returns_buyback`;

CREATE TABLE `returns_buyback` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `retailer_id` bigint unsigned NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_buyback_retailer` (`retailer_id`),
  CONSTRAINT `fk_buyback_retailer` FOREIGN KEY (`retailer_id`) REFERENCES `partners_retailer` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `returns_buyback` */

insert  into `returns_buyback`(`id`,`retailer_id`,`created_at`,`updated_at`,`created_by_id`,`updated_by_id`) values 
(1,3,'2025-10-10 09:00:00','2025-10-23 01:21:50',NULL,NULL),
(2,14,'2025-10-23 01:22:28','2025-10-23 01:22:28',NULL,NULL);

/*Table structure for table `returns_buybackitem` */

DROP TABLE IF EXISTS `returns_buybackitem`;

CREATE TABLE `returns_buybackitem` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `buyback_id` bigint unsigned NOT NULL,
  `batch_id` bigint unsigned NOT NULL,
  `qty` int NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_bb_item_bb` (`buyback_id`),
  KEY `ix_bb_item_batch` (`batch_id`),
  CONSTRAINT `fk_bb_item_batch` FOREIGN KEY (`batch_id`) REFERENCES `warehouses_inventorybatch` (`id`),
  CONSTRAINT `fk_bb_item_bb` FOREIGN KEY (`buyback_id`) REFERENCES `returns_buyback` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `returns_buybackitem` */

insert  into `returns_buybackitem`(`id`,`buyback_id`,`batch_id`,`qty`,`created_at`,`updated_at`,`created_by_id`,`updated_by_id`) values 
(1,1,3,5,'2025-10-23 01:21:49','2025-10-23 01:21:49',NULL,NULL),
(2,2,1,1,'2025-10-23 01:22:28','2025-10-23 01:22:28',NULL,NULL),
(3,2,2,1,'2025-10-23 01:22:28','2025-10-23 01:22:28',NULL,NULL),
(4,2,3,1,'2025-10-23 01:22:28','2025-10-23 01:22:28',NULL,NULL);

/*Table structure for table `warehouses_inventorybatch` */

DROP TABLE IF EXISTS `warehouses_inventorybatch`;

CREATE TABLE `warehouses_inventorybatch` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `warehouse_id` bigint unsigned NOT NULL,
  `sku_id` bigint unsigned NOT NULL,
  `lot` varchar(64) NOT NULL,
  `expires_at` date DEFAULT NULL,
  `qty_on_hand` int NOT NULL,
  `qty_reserved` int NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_batch` (`warehouse_id`,`sku_id`,`lot`),
  KEY `warehouses__warehou_d82d4c_idx` (`warehouse_id`,`sku_id`,`expires_at`),
  KEY `fk_batch_sku` (`sku_id`),
  KEY `ix_batch_wh_sku_qty` (`warehouse_id`,`sku_id`,`qty_on_hand`),
  CONSTRAINT `fk_batch_sku` FOREIGN KEY (`sku_id`) REFERENCES `catalog_sku` (`id`),
  CONSTRAINT `fk_batch_wh` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouses_warehouse` (`id`),
  CONSTRAINT `chk_qty_on_hand` CHECK ((`qty_on_hand` >= 0)),
  CONSTRAINT `chk_qty_reserved` CHECK ((`qty_reserved` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `warehouses_inventorybatch` */

insert  into `warehouses_inventorybatch`(`id`,`warehouse_id`,`sku_id`,`lot`,`expires_at`,`qty_on_hand`,`qty_reserved`,`created_at`,`updated_at`,`created_by_id`,`updated_by_id`) values 
(1,1,2,'L20250102','2027-01-31',500,0,'2025-10-23 01:21:47','2025-10-23 01:21:47',NULL,NULL),
(2,1,3,'L20250103','2027-01-31',400,0,'2025-10-23 01:21:47','2025-10-23 01:21:47',NULL,NULL),
(3,1,1,'L20250101','2026-12-31',600,0,'2025-10-23 01:21:47','2025-10-23 01:21:47',NULL,NULL),
(4,1,4,'L20250104','2026-06-30',300,8,'2025-10-23 01:21:47','2025-10-23 01:21:47',NULL,NULL),
(5,3,6,'L20250106','2027-03-31',250,12,'2025-10-23 01:21:47','2025-10-23 01:21:47',NULL,NULL),
(6,3,5,'L20250105','2027-02-28',300,15,'2025-10-23 01:21:47','2025-10-23 01:21:47',NULL,NULL),
(7,1,2,'L20240302','2026-03-31',100,30,'2025-10-23 01:21:47','2025-10-23 01:21:47',NULL,NULL),
(8,1,3,'L20240303','2026-03-31',80,30,'2025-10-23 01:21:47','2025-10-23 01:21:47',NULL,NULL),
(9,5,7,'L001WH1','2025-12-18',100,0,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(10,6,7,'L001WH2','2025-12-06',100,0,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(11,5,8,'L002WH1','2026-06-27',100,0,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(12,6,8,'L002WH2','2026-06-03',100,0,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(13,5,9,'L003WH1','2026-02-07',100,0,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(14,6,9,'L003WH2','2026-08-16',100,0,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(15,5,10,'L004WH1','2026-08-11',100,0,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(16,6,10,'L004WH2','2026-03-05',100,0,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(17,5,11,'L005WH1','2026-01-02',100,0,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(18,6,11,'L005WH2','2026-02-19',100,0,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(19,5,12,'L006WH1','2026-04-26',100,0,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(20,6,12,'L006WH2','2026-02-21',100,0,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(21,5,13,'L007WH1','2026-03-25',100,0,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(22,6,13,'L007WH2','2025-11-28',100,0,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(23,5,14,'L008WH1','2026-03-31',100,0,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(24,6,14,'L008WH2','2026-05-12',100,0,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(25,5,15,'L009WH1','2026-08-11',100,0,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(26,6,15,'L009WH2','2026-06-10',100,0,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(27,5,16,'L010WH1','2026-01-23',100,0,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(28,6,16,'L010WH2','2026-05-02',100,0,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(29,5,17,'L011WH1','2026-01-16',100,0,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(30,6,17,'L011WH2','2026-06-06',100,0,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(31,5,18,'L012WH1','2025-12-08',100,0,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(32,6,18,'L012WH2','2026-07-09',100,0,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(33,5,19,'L013WH1','2026-03-11',100,0,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(34,6,19,'L013WH2','2025-11-21',100,0,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(35,5,20,'L014WH1','2026-06-16',100,0,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(36,6,20,'L014WH2','2026-05-06',100,0,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(37,5,21,'L015WH1','2025-12-20',100,0,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(38,6,21,'L015WH2','2026-07-24',100,0,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(39,5,22,'L016WH1','2025-11-22',100,0,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(40,6,22,'L016WH2','2026-01-20',100,0,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(41,5,23,'L017WH1','2025-11-23',100,0,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(42,6,23,'L017WH2','2026-05-03',100,0,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(43,5,24,'L018WH1','2026-02-27',100,0,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(44,6,24,'L018WH2','2026-01-16',100,0,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(45,5,25,'L019WH1','2026-03-13',100,0,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(46,6,25,'L019WH2','2026-06-26',100,0,'2025-10-23 01:22:26','2025-10-23 01:22:26',NULL,NULL),
(47,5,26,'L020WH1','2025-12-21',100,0,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL),
(48,6,26,'L020WH2','2026-06-18',100,0,'2025-10-23 01:22:27','2025-10-23 01:22:27',NULL,NULL);

/*Table structure for table `warehouses_replenishmentrule` */

DROP TABLE IF EXISTS `warehouses_replenishmentrule`;

CREATE TABLE `warehouses_replenishmentrule` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `sku_id` bigint unsigned NOT NULL,
  `warehouse_id` bigint unsigned NOT NULL,
  `min_qty` int NOT NULL DEFAULT '0',
  `target_qty` int NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_replenish` (`sku_id`,`warehouse_id`),
  KEY `fk_replenish_wh` (`warehouse_id`),
  CONSTRAINT `fk_replenish_sku` FOREIGN KEY (`sku_id`) REFERENCES `catalog_sku` (`id`),
  CONSTRAINT `fk_replenish_wh` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouses_warehouse` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `warehouses_replenishmentrule` */

insert  into `warehouses_replenishmentrule`(`id`,`sku_id`,`warehouse_id`,`min_qty`,`target_qty`,`created_at`,`updated_at`,`created_by_id`,`updated_by_id`) values 
(1,1,1,50,200,'2025-10-23 01:21:47','2025-10-23 01:21:47',NULL,NULL),
(2,2,1,50,200,'2025-10-23 01:21:47','2025-10-23 01:21:47',NULL,NULL),
(3,3,1,40,160,'2025-10-23 01:21:47','2025-10-23 01:21:47',NULL,NULL),
(4,4,1,30,120,'2025-10-23 01:21:47','2025-10-23 01:21:47',NULL,NULL),
(5,5,1,40,160,'2025-10-23 01:21:47','2025-10-23 01:21:47',NULL,NULL),
(6,6,1,30,120,'2025-10-23 01:21:47','2025-10-23 01:21:47',NULL,NULL),
(7,1,2,50,200,'2025-10-23 01:21:47','2025-10-23 01:21:47',NULL,NULL),
(8,2,2,50,200,'2025-10-23 01:21:47','2025-10-23 01:21:47',NULL,NULL),
(9,3,2,40,160,'2025-10-23 01:21:47','2025-10-23 01:21:47',NULL,NULL),
(10,4,2,30,120,'2025-10-23 01:21:47','2025-10-23 01:21:47',NULL,NULL),
(11,5,2,40,160,'2025-10-23 01:21:47','2025-10-23 01:21:47',NULL,NULL),
(12,6,2,30,120,'2025-10-23 01:21:47','2025-10-23 01:21:47',NULL,NULL),
(13,1,3,50,200,'2025-10-23 01:21:47','2025-10-23 01:21:47',NULL,NULL),
(14,2,3,50,200,'2025-10-23 01:21:47','2025-10-23 01:21:47',NULL,NULL),
(15,3,3,40,160,'2025-10-23 01:21:47','2025-10-23 01:21:47',NULL,NULL),
(16,4,3,30,120,'2025-10-23 01:21:47','2025-10-23 01:21:47',NULL,NULL),
(17,5,3,40,160,'2025-10-23 01:21:47','2025-10-23 01:21:47',NULL,NULL),
(18,6,3,30,120,'2025-10-23 01:21:47','2025-10-23 01:21:47',NULL,NULL),
(19,1,4,50,200,'2025-10-23 01:21:47','2025-10-23 01:21:47',NULL,NULL),
(20,2,4,50,200,'2025-10-23 01:21:47','2025-10-23 01:21:47',NULL,NULL),
(21,3,4,40,160,'2025-10-23 01:21:47','2025-10-23 01:21:47',NULL,NULL),
(22,4,4,30,120,'2025-10-23 01:21:47','2025-10-23 01:21:47',NULL,NULL),
(23,5,4,40,160,'2025-10-23 01:21:47','2025-10-23 01:21:47',NULL,NULL),
(24,6,4,30,120,'2025-10-23 01:21:47','2025-10-23 01:21:47',NULL,NULL);

/*Table structure for table `warehouses_warehouse` */

DROP TABLE IF EXISTS `warehouses_warehouse`;

CREATE TABLE `warehouses_warehouse` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(32) NOT NULL,
  `name` varchar(120) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `updated_by_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_warehouse_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `warehouses_warehouse` */

insert  into `warehouses_warehouse`(`id`,`code`,`name`,`created_at`,`updated_at`,`created_by_id`,`updated_by_id`) values 
(1,'WH-SH-01','Shanghai Central 01','2025-10-23 01:21:47','2025-10-23 01:21:47',NULL,NULL),
(2,'WH-BJ-01','Beijing Central 01','2025-10-23 01:21:47','2025-10-23 01:21:47',NULL,NULL),
(3,'WH-GZ-01','Guangzhou Central 01','2025-10-23 01:21:47','2025-10-23 01:21:47',NULL,NULL),
(4,'WH-CD-01','Chengdu Central 01','2025-10-23 01:21:47','2025-10-23 01:21:47',NULL,NULL),
(5,'WH1','Central','2025-10-23 01:22:25','2025-10-23 01:22:25',NULL,NULL),
(6,'WH2','Backup','2025-10-23 01:22:25','2025-10-23 01:22:25',NULL,NULL);

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
