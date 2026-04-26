-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: fakenewsdb
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category` (
  `category_id` int NOT NULL,
  `category_name` varchar(50) NOT NULL,
  PRIMARY KEY (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` VALUES (1,'Politics'),(2,'Health'),(3,'Technology'),(4,'Sports');
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `category_count_view`
--

DROP TABLE IF EXISTS `category_count_view`;
/*!50001 DROP VIEW IF EXISTS `category_count_view`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `category_count_view` AS SELECT 
 1 AS `category_name`,
 1 AS `total_news`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `fake_news_view`
--

DROP TABLE IF EXISTS `fake_news_view`;
/*!50001 DROP VIEW IF EXISTS `fake_news_view`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `fake_news_view` AS SELECT 
 1 AS `title`,
 1 AS `status`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `news`
--

DROP TABLE IF EXISTS `news`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `news` (
  `news_id` int NOT NULL,
  `title` varchar(200) NOT NULL,
  `content` text,
  `language` varchar(50) DEFAULT NULL,
  `publish_date` date DEFAULT NULL,
  `source_id` int DEFAULT NULL,
  `category_id` int DEFAULT NULL,
  PRIMARY KEY (`news_id`),
  KEY `source_id` (`source_id`),
  KEY `category_id` (`category_id`),
  CONSTRAINT `news_ibfk_1` FOREIGN KEY (`source_id`) REFERENCES `source` (`source_id`),
  CONSTRAINT `news_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `category` (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `news`
--

LOCK TABLES `news` WRITE;
/*!40000 ALTER TABLE `news` DISABLE KEYS */;
INSERT INTO `news` VALUES (101,'Election Updates','Election results announced by officials','English','2025-01-10',1,1),(102,'New Government Policies','Government releases new policy framework','English','2025-01-14',2,1),(103,'New Vaccine Developed','Scientists develop a new vaccine','English','2025-01-15',3,2),(104,'AI Technology Breakthrough','Major breakthrough in AI technology','English','2025-01-20',1,3),(105,'Cricket Team Wins Championship','National team wins the final match','English','2025-01-25',4,4),(107,'New Smartphone Launched','Latest smartphone model launched with advanced features','English','2025-01-22',2,3),(110,'Climate Change Awareness Drive','Awareness drive launched to address climate change issues','English','2025-01-30',1,1),(111,'Global Climate Summit','World leaders meet to discuss climate policies.','English','2025-02-01',5,1),(112,'Flood Alert Issued','Authorities issue flood warning in coastal zones.','English','2025-02-05',3,2),(113,'Budget Speech Released','Finance minister presents annual budget.','English','2025-02-07',2,1);
/*!40000 ALTER TABLE `news` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `news_new`
--

DROP TABLE IF EXISTS `news_new`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `news_new` (
  `news_id` int NOT NULL,
  `title` varchar(100) DEFAULT NULL,
  `category_id` int DEFAULT NULL,
  PRIMARY KEY (`news_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `news_new`
--

LOCK TABLES `news_new` WRITE;
/*!40000 ALTER TABLE `news_new` DISABLE KEYS */;
INSERT INTO `news_new` VALUES (101,'Election Updates',1),(102,'New Government Policies',1),(103,'New Vaccine Developed',2),(104,'AI Technology Breakthrough',3),(105,'Cricket Team Wins Championship',4);
/*!40000 ALTER TABLE `news_new` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `news_source_view`
--

DROP TABLE IF EXISTS `news_source_view`;
/*!50001 DROP VIEW IF EXISTS `news_source_view`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `news_source_view` AS SELECT 
 1 AS `title`,
 1 AS `source_name`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `news_unnormalized`
--

DROP TABLE IF EXISTS `news_unnormalized`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `news_unnormalized` (
  `news_id` int DEFAULT NULL,
  `title` varchar(100) DEFAULT NULL,
  `category_name` varchar(50) DEFAULT NULL,
  `verification_id` int DEFAULT NULL,
  `verification_date` date DEFAULT NULL,
  `status` varchar(10) DEFAULT NULL,
  `confidence_level` int DEFAULT NULL,
  `remarks` varchar(100) DEFAULT NULL,
  `verifier_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `news_unnormalized`
--

LOCK TABLES `news_unnormalized` WRITE;
/*!40000 ALTER TABLE `news_unnormalized` DISABLE KEYS */;
INSERT INTO `news_unnormalized` VALUES (101,'Election Updates','Politics',1,'2025-01-12','Real',9,'Verified information',1),(102,'New Government Policies','Politics',2,'2025-01-16','Fake',4,'Misleading content',2),(103,'New Vaccine Developed','Health',3,'2025-01-18','Real',8,'Verified by experts',3),(104,'AI Technology Breakthrough','Technology',4,'2025-01-22','Real',6,'Reliable source',1),(105,'Cricket Team Wins Championship','Sports',5,'2025-01-27','Fake',3,'False claim detected',2),(101,'Election Updates','Politics',20,'2026-03-18','Real',8,NULL,2),(102,'New Government Policies','Politics',21,'2026-03-18','Real',10,NULL,1),(103,'New Vaccine Developed','Health',30,'2026-03-18','Real',7,NULL,2);
/*!40000 ALTER TABLE `news_unnormalized` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `source`
--

DROP TABLE IF EXISTS `source`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `source` (
  `source_id` int NOT NULL,
  `source_name` varchar(100) NOT NULL,
  `country` varchar(50) DEFAULT NULL,
  `website_url` varchar(150) DEFAULT NULL,
  `credibility_score` int DEFAULT NULL,
  PRIMARY KEY (`source_id`),
  CONSTRAINT `check_credibility` CHECK (((`credibility_score` between 1 and 10) and (`credibility_score` is not null))),
  CONSTRAINT `chk_credibility` CHECK ((`credibility_score` between 1 and 10))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `source`
--

LOCK TABLES `source` WRITE;
/*!40000 ALTER TABLE `source` DISABLE KEYS */;
INSERT INTO `source` VALUES (1,'BBC News','UK','bbc.com',8),(2,'CNN','USA','www.cnn.com',9),(3,'The Hindu','India','www.thehindu.com',9),(4,'NDTV','India','www.ndtv.com',7),(5,'Al Jazeera','Qatar','www.aljazeera.com',8);
/*!40000 ALTER TABLE `source` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `verification`
--

DROP TABLE IF EXISTS `verification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `verification` (
  `verification_id` int NOT NULL,
  `verification_date` date DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `confidence_level` int DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  `news_id` int DEFAULT NULL,
  `verifier_id` int DEFAULT NULL,
  PRIMARY KEY (`verification_id`),
  UNIQUE KEY `unique_verification` (`news_id`,`verifier_id`),
  KEY `verifier_id` (`verifier_id`),
  CONSTRAINT `verification_ibfk_1` FOREIGN KEY (`news_id`) REFERENCES `news` (`news_id`),
  CONSTRAINT `verification_ibfk_2` FOREIGN KEY (`verifier_id`) REFERENCES `verifier` (`verifier_id`),
  CONSTRAINT `chk_confidence` CHECK ((`confidence_level` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `verification`
--

LOCK TABLES `verification` WRITE;
/*!40000 ALTER TABLE `verification` DISABLE KEYS */;
INSERT INTO `verification` VALUES (1,'2025-01-12','Real',9,'Confirmed authentic by FactCheck Org',101,1),(2,'2025-01-16','Fake',4,'Misleading content',102,2),(3,'2025-01-18','Real',8,'Verified by experts',103,3),(4,'2025-01-22','Real',6,'Reliable source',104,1),(5,'2025-01-27','Fake',3,'False claim detected',105,2),(20,'2026-03-18','Real',8,'Secondary review complete',101,2),(21,'2026-03-18','Real',10,NULL,102,1),(30,'2026-03-18','Real',7,NULL,103,2),(31,'2026-04-13','Real',8,'Verified by MediaWatch',103,4),(32,'2026-04-13','Real',9,'Confirmed by authorities',112,3),(33,'2026-04-13','Real',7,'Verified source',113,1);
/*!40000 ALTER TABLE `verification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `verifier`
--

DROP TABLE IF EXISTS `verifier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `verifier` (
  `verifier_id` int NOT NULL,
  `verifier_name` varchar(100) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `organization` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`verifier_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `verifier`
--

LOCK TABLES `verifier` WRITE;
/*!40000 ALTER TABLE `verifier` DISABLE KEYS */;
INSERT INTO `verifier` VALUES (1,'FactCheck Org','contact@factcheck.org','Independent'),(2,'NewsVerify','verify@news.com','Media Group'),(3,'TruthCheck India','truth@india.org','NGO'),(4,'MediaWatch','watch@media.org','Press Council');
/*!40000 ALTER TABLE `verifier` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `category_count_view`
--

/*!50001 DROP VIEW IF EXISTS `category_count_view`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `category_count_view` AS select `c`.`category_name` AS `category_name`,count(0) AS `total_news` from (`news` `n` join `category` `c` on((`n`.`category_id` = `c`.`category_id`))) group by `c`.`category_name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `fake_news_view`
--

/*!50001 DROP VIEW IF EXISTS `fake_news_view`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `fake_news_view` AS select `n`.`title` AS `title`,`v`.`status` AS `status` from (`news` `n` join `verification` `v` on((`n`.`news_id` = `v`.`news_id`))) where (`v`.`status` = 'Fake') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `news_source_view`
--

/*!50001 DROP VIEW IF EXISTS `news_source_view`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `news_source_view` AS select `n`.`title` AS `title`,`s`.`source_name` AS `source_name` from (`news` `n` join `source` `s` on((`n`.`source_id` = `s`.`source_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-26 11:49:16
