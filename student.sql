-- MySQL dump 10.13  Distrib 8.0.34, for Win64 (x86_64)
--
-- Host: localhost    Database: student
-- ------------------------------------------------------
-- Server version	8.0.34

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `class`
--

DROP TABLE IF EXISTS `class`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `class` (
  `clno` char(8) NOT NULL,
  `clyear` year NOT NULL,
  `clmno` char(8) NOT NULL,
  PRIMARY KEY (`clno`),
  KEY `fk_major` (`clmno`),
  CONSTRAINT `fk_major` FOREIGN KEY (`clmno`) REFERENCES `major` (`mno`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `class`
--

LOCK TABLES `class` WRITE;
/*!40000 ALTER TABLE `class` DISABLE KEYS */;
INSERT INTO `class` VALUES ('30000001',2023,'20000001'),('30000002',2022,'20000002'),('30000003',2021,'20000003'),('30000004',2020,'20000004'),('30000005',2019,'20000005'),('30000006',2018,'20000006'),('30000007',2017,'20000007'),('30000008',2016,'20000008'),('30000009',2015,'20000009'),('30000010',2014,'20000010'),('30000011',2013,'20000011'),('30000012',2012,'20000012'),('30000013',2011,'20000013'),('30000014',2010,'20000014'),('30000015',2009,'20000015'),('30000016',2008,'20000016'),('30000017',2007,'20000017'),('30000018',2006,'20000018'),('30000019',2005,'20000019'),('30000020',2004,'20000020'),('30000021',2003,'20000021'),('30000022',2002,'20000022'),('30000023',2001,'20000023'),('30000024',2000,'20000024'),('30000025',1999,'20000025'),('30000026',1998,'20000026'),('30000027',1997,'20000027'),('30000028',1996,'20000028'),('30000029',1995,'20000029'),('30000030',1994,'20000030');
/*!40000 ALTER TABLE `class` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_insert_class_check` BEFORE INSERT ON `class` FOR EACH ROW BEGIN
    IF NEW.clyear > YEAR(CURDATE()) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = '入学日期不能是未来的日期';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_update_class_check` BEFORE UPDATE ON `class` FOR EACH ROW BEGIN
    IF NEW.clyear > YEAR(CURDATE()) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = '入学日期不能是未来的日期';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `course`
--

DROP TABLE IF EXISTS `course`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `course` (
  `cno` char(8) NOT NULL,
  `cname` char(20) NOT NULL,
  `ccredit` int NOT NULL,
  `ctype` char(10) NOT NULL,
  PRIMARY KEY (`cno`),
  CONSTRAINT `chk_credit` CHECK ((`ccredit` between 0 and 6))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course`
--

LOCK TABLES `course` WRITE;
/*!40000 ALTER TABLE `course` DISABLE KEYS */;
INSERT INTO `course` VALUES ('50000001','高等数学',4,'必修'),('50000002','英语语法与写作',3,'必修'),('50000003','计算机编程基础',3,'必修'),('50000004','线性代数',4,'必修'),('50000005','数据库原理',3,'必修'),('50000006','数据结构与算法',4,'必修'),('50000007','离散数学',3,'必修'),('50000008','大学物理',4,'必修'),('50000009','电子商务导论',3,'选修'),('50000010','计算机网络',4,'必修'),('50000011','软件工程',4,'必修'),('50000012','人工智能基础',3,'选修'),('50000013','操作系统原理',4,'必修'),('50000014','人际沟通与交往',2,'选修'),('50000015','体育健身',1,'选修'),('50000016','微积分',4,'必修'),('50000017','数据库应用开发',3,'选修'),('50000018','人工智能应用',3,'选修'),('50000019','计算机图形学',3,'选修'),('50000020','算法设计与分析',3,'必修'),('50000021','大学英语',3,'必修'),('50000022','嵌入式系统设计',3,'选修'),('50000023','机器学习',3,'选修'),('50000024','网络安全',3,'选修'),('50000025','数字信号处理',3,'选修'),('50000026','社交心理学',2,'选修'),('50000027','音乐鉴赏',2,'选修'),('50000028','国际贸易原理',3,'选修'),('50000029','互联网营销',3,'选修'),('50000030','创业管理',3,'选修');
/*!40000 ALTER TABLE `course` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `faculty`
--

DROP TABLE IF EXISTS `faculty`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `faculty` (
  `fno` char(8) NOT NULL,
  `fname` char(20) NOT NULL,
  PRIMARY KEY (`fno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `faculty`
--

LOCK TABLES `faculty` WRITE;
/*!40000 ALTER TABLE `faculty` DISABLE KEYS */;
INSERT INTO `faculty` VALUES ('10000001','计算机学院'),('10000002','电子工程学院'),('10000003','机械工程学院'),('10000004','化学工程学院'),('10000005','经济管理学院'),('10000006','文学与传媒学院'),('10000007','法学院'),('10000008','医学院'),('10000009','数学与统计学院'),('10000010','物理与天文学院'),('10000011','历史与文化学院'),('10000012','环境与资源学院'),('10000013','外国语学院'),('10000014','音乐与舞蹈学院'),('10000015','社会与政治学院'),('10000016','材料科学与工程学院'),('10000017','农学与生物技术学院'),('10000018','教育学院'),('10000019','地球与空间科学学院'),('10000020','哲学与社会学院'),('10000021','艺术与设计学院'),('10000022','体育科学与体育训练学院'),('10000023','食品与生物工程学院'),('10000024','交通与物流工程学院'),('10000025','化学与材料工程学院'),('10000026','地理与信息工程学院'),('10000027','心理与认知科学学院'),('10000028','人文与社会科学研究院'),('10000029','公共卫生与环境科学学院'),('10000030','马克思主义学院');
/*!40000 ALTER TABLE `faculty` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `grade`
--

DROP TABLE IF EXISTS `grade`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `grade` (
  `sno` char(8) NOT NULL,
  `cno` char(8) NOT NULL,
  `score` int NOT NULL,
  PRIMARY KEY (`sno`,`cno`),
  KEY `fk_cno` (`cno`),
  CONSTRAINT `fk_cno` FOREIGN KEY (`cno`) REFERENCES `course` (`cno`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_sno` FOREIGN KEY (`sno`) REFERENCES `student` (`sno`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `chk_score` CHECK ((`score` between 0 and 100))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `grade`
--

LOCK TABLES `grade` WRITE;
/*!40000 ALTER TABLE `grade` DISABLE KEYS */;
INSERT INTO `grade` VALUES ('40000001','50000001',85),('40000002','50000002',72),('40000003','50000003',94),('40000004','50000004',68),('40000005','50000005',90),('40000006','50000006',78),('40000007','50000007',89),('40000008','50000008',75),('40000009','50000009',92),('40000010','50000010',86),('40000011','50000011',77),('40000012','50000012',95),('40000013','50000013',80),('40000014','50000014',65),('40000015','50000015',88),('40000016','50000016',91),('40000017','50000017',79),('40000018','50000018',93),('40000019','50000019',82),('40000020','50000020',87),('40000021','50000021',74),('40000022','50000022',97),('40000023','50000023',83),('40000024','50000024',76),('40000025','50000025',98),('40000026','50000026',71),('40000027','50000027',99),('40000028','50000028',84),('40000029','50000029',73),('40000030','50000030',96);
/*!40000 ALTER TABLE `grade` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `login`
--

DROP TABLE IF EXISTS `login`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `login` (
  `username` char(20) NOT NULL,
  `password` char(64) NOT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login`
--

LOCK TABLES `login` WRITE;
/*!40000 ALTER TABLE `login` DISABLE KEYS */;
INSERT INTO `login` VALUES ('40000001','8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92'),('admin','8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92');
/*!40000 ALTER TABLE `login` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `major`
--

DROP TABLE IF EXISTS `major`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `major` (
  `mno` char(8) NOT NULL,
  `mname` char(20) NOT NULL,
  `mfno` char(8) NOT NULL,
  PRIMARY KEY (`mno`),
  KEY `fk_faculty` (`mfno`),
  CONSTRAINT `fk_faculty` FOREIGN KEY (`mfno`) REFERENCES `faculty` (`fno`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `major`
--

LOCK TABLES `major` WRITE;
/*!40000 ALTER TABLE `major` DISABLE KEYS */;
INSERT INTO `major` VALUES ('20000001','计算机科学与技术','10000001'),('20000002','电子信息工程','10000002'),('20000003','机械工程','10000003'),('20000004','化学工程与工艺','10000004'),('20000005','工商管理','10000005'),('20000006','新闻传播学','10000006'),('20000007','法学','10000007'),('20000008','临床医学','10000008'),('20000009','数学与应用数学','10000009'),('20000010','物理学','10000010'),('20000011','历史学','10000011'),('20000012','环境工程','10000012'),('20000013','英语','10000013'),('20000014','音乐学','10000014'),('20000015','社会工作','10000015'),('20000016','材料科学与工程','10000016'),('20000017','农业科学','10000017'),('20000018','教育学','10000018'),('20000019','地理信息科学','10000019'),('20000020','哲学','10000020'),('20000021','视觉传达设计','10000021'),('20000022','运动训练','10000022'),('20000023','食品科学与工程','10000023'),('20000024','交通工程','10000024'),('20000025','化学与材料科学','10000025'),('20000026','地理信息工程','10000026'),('20000027','心理学','10000027'),('20000028','社会学','10000028'),('20000029','公共卫生学','10000029'),('20000030','马克思主义理论','10000030');
/*!40000 ALTER TABLE `major` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student`
--

DROP TABLE IF EXISTS `student`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student` (
  `sno` char(8) NOT NULL,
  `sname` char(10) NOT NULL,
  `sgender` char(2) NOT NULL,
  `syear` year NOT NULL,
  `sbirth` date DEFAULT NULL,
  `spolitic` char(10) DEFAULT NULL,
  `sethnic` char(10) DEFAULT NULL,
  `sclno` char(8) DEFAULT NULL,
  PRIMARY KEY (`sno`),
  KEY `fk_class` (`sclno`),
  CONSTRAINT `fk_class` FOREIGN KEY (`sclno`) REFERENCES `class` (`clno`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `chk_ethnic` CHECK ((`sethnic` in (_utf8mb4'汉族',_utf8mb4'满族',_utf8mb4'回族',_utf8mb4'其他'))),
  CONSTRAINT `chk_gender` CHECK ((`sgender` in (_utf8mb4'男',_utf8mb4'女'))),
  CONSTRAINT `chk_politic` CHECK ((`spolitic` in (_utf8mb4'群众',_utf8mb4'党员',_utf8mb4'预备党员',_utf8mb4'团员',_utf8mb4'无党派人士')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student`
--

LOCK TABLES `student` WRITE;
/*!40000 ALTER TABLE `student` DISABLE KEYS */;
INSERT INTO `student` VALUES ('40000001','张三','男',2023,'2006-01-01','党员','汉族','30000001'),('40000002','李四','女',2023,'2004-02-02','团员','满族','30000002'),('40000003','王五','男',2022,'2003-03-03','群众','回族','30000003'),('40000004','赵六','女',2022,'2002-04-04','无党派人士','其他','30000004'),('40000005','小红','男',2021,'2001-05-05','党员','汉族','30000005'),('40000006','小明','女',2021,'2000-06-06','团员','满族','30000006'),('40000007','小李','男',2020,'1999-07-07','群众','回族','30000007'),('40000008','小刘','女',2020,'1998-08-08','无党派人士','其他','30000008'),('40000009','丽丽','男',2019,'1997-09-09','党员','汉族','30000009'),('40000010','小华','女',2019,'1996-10-10','团员','满族','30000010'),('40000011','小强','男',2018,'1995-11-11','群众','回族','30000011'),('40000012','世世','女',2018,'1994-12-12','无党派人士','其他','30000012'),('40000013','大明','男',2017,'1993-01-13','党员','汉族','30000013'),('40000014','大红','女',2017,'1992-02-14','团员','满族','30000014'),('40000015','大李','男',2016,'1991-03-15','群众','回族','30000015'),('40000016','大刘','女',2016,'1990-04-16','无党派人士','其他','30000016'),('40000017','小小','男',2015,'1989-05-17','党员','汉族','30000017'),('40000018','小红','女',2015,'1988-06-18','团员','满族','30000018'),('40000019','小李','男',2014,'1987-07-19','群众','回族','30000019'),('40000020','小刘','女',2014,'1986-08-20','无党派人士','其他','30000020'),('40000021','大大','男',2013,'1985-09-21','党员','汉族','30000021'),('40000022','大红','女',2013,'1984-10-22','团员','满族','30000022'),('40000023','大李','男',2012,'1983-11-23','群众','回族','30000023'),('40000024','大刘','女',2012,'1982-12-24','无党派人士','其他','30000024'),('40000025','小小','男',2011,'1981-01-25','党员','汉族','30000025'),('40000026','小红','女',2011,'1980-02-26','团员','满族','30000026'),('40000027','小李','男',2010,'1979-03-27','群众','回族','30000027'),('40000028','小刘','女',2010,'1978-04-28','无党派人士','其他','30000028'),('40000029','大大','男',2009,'1977-05-29','党员','汉族','30000029'),('40000030','大红','女',2009,'1976-06-30','团员','满族','30000030');
/*!40000 ALTER TABLE `student` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_insert_student_check` BEFORE INSERT ON `student` FOR EACH ROW BEGIN
    IF NEW.syear > YEAR(CURDATE()) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = '年级不能是未来的日期';
    END IF;

    IF NEW.sbirth > CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = '出生日期不能是未来的日期';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_update_student_check` BEFORE UPDATE ON `student` FOR EACH ROW BEGIN
    IF NEW.syear > YEAR(CURDATE()) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = '年级不能是未来的日期';
    END IF;

    IF NEW.sbirth > CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = '出生日期不能是未来的日期';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Temporary view structure for view `student_course_grade`
--

DROP TABLE IF EXISTS `student_course_grade`;
/*!50001 DROP VIEW IF EXISTS `student_course_grade`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `student_course_grade` AS SELECT 
 1 AS `sno`,
 1 AS `sname`,
 1 AS `cno`,
 1 AS `cname`,
 1 AS `clno`,
 1 AS `ccredit`,
 1 AS `score`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `student_course_grade`
--

/*!50001 DROP VIEW IF EXISTS `student_course_grade`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `student_course_grade` AS select `s`.`sno` AS `sno`,`s`.`sname` AS `sname`,`c`.`cno` AS `cno`,`c`.`cname` AS `cname`,`s`.`sclno` AS `clno`,`c`.`ccredit` AS `ccredit`,`g`.`score` AS `score` from ((`grade` `g` join `student` `s` on((`g`.`sno` = `s`.`sno`))) join `course` `c` on((`g`.`cno` = `c`.`cno`))) */;
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

-- Dump completed on 2023-12-19 20:24:13
