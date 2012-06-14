-- MySQL dump 10.13  Distrib 5.1.61, for debian-linux-gnu (i686)
--
-- Host: localhost    Database: dms.ext_dev
-- ------------------------------------------------------
-- Server version	5.1.61-0ubuntu0.10.10.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `1_clients`
--

DROP TABLE IF EXISTS `1_clients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `1_clients` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fio` varchar(100) NOT NULL DEFAULT '',
  `comment` text NOT NULL,
  `phone1` varchar(50) NOT NULL DEFAULT '',
  `phone2` varchar(50) NOT NULL DEFAULT '',
  `phone3` varchar(50) NOT NULL DEFAULT '',
  `phone4` varchar(50) NOT NULL DEFAULT '',
  `date` date NOT NULL DEFAULT '0000-00-00',
  `adress` varchar(200) NOT NULL DEFAULT '',
  `birthday` date NOT NULL DEFAULT '0000-00-00',
  `brand` varchar(50) NOT NULL DEFAULT '',
  `manager` varchar(100) NOT NULL DEFAULT '',
  `model` varchar(160) NOT NULL DEFAULT '0',
  `icon` int(11) NOT NULL,
  `creditmanager` varchar(100) NOT NULL,
  `zv` datetime NOT NULL,
  `vz` datetime NOT NULL,
  `tst` datetime NOT NULL,
  `dg` datetime NOT NULL,
  `vd` datetime NOT NULL,
  `out` datetime NOT NULL,
  `icon2` int(11) NOT NULL DEFAULT '0',
  `vin` varchar(50) NOT NULL,
  `cost` int(11) NOT NULL,
  `status` varchar(50) NOT NULL,
  `commercial` varchar(50) NOT NULL,
  `tmp` varchar(50) NOT NULL,
  `order` int(11) DEFAULT NULL,
  `contract_date` date DEFAULT NULL,
  `id_series` int(11) DEFAULT NULL,
  `id_number` int(11) DEFAULT NULL,
  `id_dep` varchar(255) DEFAULT NULL,
  `id_issued` date DEFAULT NULL,
  `gifts` varchar(255) DEFAULT NULL,
  `prepay` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fio` (`fio`,`phone1`,`phone2`,`phone3`,`phone4`,`birthday`),
  KEY `manager` (`manager`),
  KEY `model` (`model`),
  KEY `zv` (`zv`),
  KEY `vz` (`vz`),
  KEY `tst` (`tst`),
  KEY `dg` (`dg`),
  KEY `vd` (`vd`),
  KEY `out` (`out`),
  KEY `vin` (`vin`,`cost`,`status`,`commercial`),
  KEY `tmp` (`tmp`),
  KEY `fio_2` (`fio`),
  KEY `phone1` (`phone1`),
  KEY `phone2` (`phone2`),
  KEY `phone3` (`phone3`),
  KEY `phone4` (`phone4`),
  KEY `brand` (`brand`),
  KEY `icon` (`icon`),
  KEY `creditmanager` (`creditmanager`),
  KEY `vin_2` (`vin`),
  KEY `icon2` (`icon2`),
  KEY `zv_index` (`id`,`zv`,`brand`),
  KEY `vz_index` (`id`,`vz`,`brand`),
  KEY `tst_index` (`id`,`tst`,`brand`),
  KEY `dg_index` (`id`,`dg`,`brand`),
  KEY `vd_index` (`id`,`vd`,`brand`),
  KEY `out_index` (`id`,`out`,`brand`)
) ENGINE=MyISAM AUTO_INCREMENT=29335 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
