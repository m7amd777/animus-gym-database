-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 18, 2025 at 12:16 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `animus`
--

-- --------------------------------------------------------

--
-- Table structure for table `client`
--

CREATE TABLE `client` (
  `Client ID` int(11) NOT NULL,
  `Coach ID` int(11) NOT NULL,
  `Package ID` int(11) NOT NULL,
  `First Name` text NOT NULL,
  `Last Name` text NOT NULL,
  `Gender` varchar(1) NOT NULL,
  `Phone Number` int(11) NOT NULL,
  `Start Date` date NOT NULL,
  `End Date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `client`
--

INSERT INTO `client` (`Client ID`, `Coach ID`, `Package ID`, `First Name`, `Last Name`, `Gender`, `Phone Number`, `Start Date`, `End Date`) VALUES
(1, 1, 1, 'Yousif', 'Abuzuhaira', 'M', 39983391, '2025-04-01', '2025-07-01'),
(2, 1, 2, 'Ahmed', 'Adel', 'M', 32211749, '2025-05-09', '2025-08-09'),
(3, 2, 3, 'Farah', 'Majdi', 'F', 32288582, '2025-05-03', '2025-08-03'),
(4, 2, 3, 'Walaa', 'Majdi', 'F', 35152040, '2025-05-03', '2025-08-03'),
(5, 3, 2, 'Ali', 'Mohamed', 'M', 39978178, '2025-04-15', '2025-08-15');

-- --------------------------------------------------------

--
-- Table structure for table `coach`
--

CREATE TABLE `coach` (
  `CoachID` int(11) NOT NULL,
  `ManagerID` int(11) DEFAULT NULL,
  `First Name` text NOT NULL,
  `Last Name` text NOT NULL,
  `Gender` varchar(1) NOT NULL,
  `Phone Number` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `coach`
--

INSERT INTO `coach` (`CoachID`, `ManagerID`, `First Name`, `Last Name`, `Gender`, `Phone Number`) VALUES
(1, NULL, 'Murtadha', 'Shakhbozi', 'M', 33956622),
(2, 1, 'Ghaida', 'Majdi', 'F', 39167867),
(3, 1, 'Husain', 'AlEkri', 'M', 36212183);

-- --------------------------------------------------------

--
-- Table structure for table `coach specialization`
--

CREATE TABLE `coach specialization` (
  `Coach ID` int(11) NOT NULL,
  `Specialization` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `coach specialization`
--

INSERT INTO `coach specialization` (`Coach ID`, `Specialization`) VALUES
(1, 'Dynamics'),
(1, 'Phsyiotherapy'),
(1, 'Statics'),
(2, 'Dynamics'),
(2, 'Mobility'),
(2, 'Strength & Conditioning'),
(3, 'Dynamics'),
(3, 'Power Dynamics'),
(3, 'Statics');

-- --------------------------------------------------------

--
-- Table structure for table `package`
--

CREATE TABLE `package` (
  `Package ID` int(11) NOT NULL,
  `Package Name` text NOT NULL,
  `Price` int(11) NOT NULL,
  `No. Weeks` int(11) NOT NULL,
  `Times Per Week` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `package`
--

INSERT INTO `package` (`Package ID`, `Package Name`, `Price`, `No. Weeks`, `Times Per Week`) VALUES
(1, 'Students Offer', 50, 4, 3),
(2, '3 Months Offer', 195, 12, 4),
(3, 'Ladies offer', 45, 4, 3);

-- --------------------------------------------------------

--
-- Table structure for table `room`
--

CREATE TABLE `room` (
  `Room ID` int(11) NOT NULL,
  `Location` text NOT NULL,
  `Price Per Hour` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `room`
--

INSERT INTO `room` (`Room ID`, `Location`, `Price Per Hour`) VALUES
(1, 'Main', 30),
(2, 'Upstairs', 15);

-- --------------------------------------------------------

--
-- Table structure for table `room_booking`
--

CREATE TABLE `room_booking` (
  `Room ID` int(11) NOT NULL,
  `Client ID` int(11) NOT NULL,
  `Booking Date` int(11) NOT NULL,
  `Start Time` timestamp NOT NULL DEFAULT current_timestamp(),
  `End Time` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `room_booking`
--

INSERT INTO `room_booking` (`Room ID`, `Client ID`, `Booking Date`, `Start Time`, `End Time`) VALUES
(1, 2, 21052025, '2025-05-05 13:47:16', '2025-05-05 14:47:16'),
(2, 4, 1112025, '2025-04-01 13:46:34', '2025-04-01 20:46:34');

--
-- Triggers `room_booking`
--
DELIMITER $$
CREATE TRIGGER `trg_prevent_double_booking` BEFORE INSERT ON `room_booking` FOR EACH ROW BEGIN
  DECLARE conflict_count INT;

  SELECT COUNT(*) INTO conflict_count
  FROM room_booking
  WHERE `Room ID` = NEW.`Room ID`
    AND `Booking Date` = NEW.`Booking Date`
    AND (
         (NEW.`Start Time` BETWEEN `Start Time` AND `End Time`) OR
         (NEW.`End Time` BETWEEN `Start Time` AND `End Time`) OR
         (`Start Time` BETWEEN NEW.`Start Time` AND NEW.`End Time`) OR
         (`End Time` BETWEEN NEW.`Start Time` AND NEW.`End Time`)
    );

  IF conflict_count > 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Room already booked for the selected time slot.';
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `session`
--

CREATE TABLE `session` (
  `Session ID` int(11) NOT NULL,
  `Room ID` int(11) NOT NULL,
  `Start Time` timestamp NOT NULL DEFAULT current_timestamp(),
  `End Time` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `session`
--

INSERT INTO `session` (`Session ID`, `Room ID`, `Start Time`, `End Time`) VALUES
(1, 1, '2025-04-29 07:40:22', '2025-04-29 10:40:22'),
(2, 1, '2025-04-28 12:34:22', '2025-04-28 13:54:22'),
(3, 2, '2025-04-19 07:42:37', '2025-04-19 09:42:37'),
(4, 2, '2025-04-20 08:42:37', '2025-04-27 09:42:37');

-- --------------------------------------------------------

--
-- Table structure for table `training session`
--

CREATE TABLE `training session` (
  `Session ID` int(11) NOT NULL,
  `Coach ID` int(11) NOT NULL,
  `Client ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `training session`
--

INSERT INTO `training session` (`Session ID`, `Coach ID`, `Client ID`) VALUES
(1, 3, 2),
(1, 3, 5),
(2, 1, 1),
(2, 1, 3),
(3, 2, 3),
(3, 2, 4),
(4, 1, 1),
(4, 3, 5);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_coach_clients`
-- (See below for the actual view)
--
CREATE TABLE `v_coach_clients` (
`CoachID` int(11)
,`Coach_First_Name` text
,`Coach_Last_Name` text
,`Client ID` int(11)
,`Client_First_Name` text
,`Client_Last_Name` text
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_room_utilization`
-- (See below for the actual view)
--
CREATE TABLE `v_room_utilization` (
`Room ID` int(11)
,`Location` text
,`Total_Bookings` bigint(21)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_sessions_per_client`
-- (See below for the actual view)
--
CREATE TABLE `v_sessions_per_client` (
`Client ID` int(11)
,`First Name` text
,`Last Name` text
,`Total_Sessions` bigint(21)
);

-- --------------------------------------------------------

--
-- Structure for view `v_coach_clients`
--
DROP TABLE IF EXISTS `v_coach_clients`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_coach_clients`  AS SELECT `co`.`CoachID` AS `CoachID`, `co`.`First Name` AS `Coach_First_Name`, `co`.`Last Name` AS `Coach_Last_Name`, `cl`.`Client ID` AS `Client ID`, `cl`.`First Name` AS `Client_First_Name`, `cl`.`Last Name` AS `Client_Last_Name` FROM (`coach` `co` join `client` `cl` on(`co`.`CoachID` = `cl`.`Coach ID`)) ;

-- --------------------------------------------------------

--
-- Structure for view `v_room_utilization`
--
DROP TABLE IF EXISTS `v_room_utilization`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_room_utilization`  AS SELECT `r`.`Room ID` AS `Room ID`, `r`.`Location` AS `Location`, count(`rb`.`Client ID`) AS `Total_Bookings` FROM (`room` `r` left join `room_booking` `rb` on(`r`.`Room ID` = `rb`.`Room ID`)) GROUP BY `r`.`Room ID`, `r`.`Location` ;

-- --------------------------------------------------------

--
-- Structure for view `v_sessions_per_client`
--
DROP TABLE IF EXISTS `v_sessions_per_client`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_sessions_per_client`  AS SELECT `c`.`Client ID` AS `Client ID`, `c`.`First Name` AS `First Name`, `c`.`Last Name` AS `Last Name`, count(`ts`.`Session ID`) AS `Total_Sessions` FROM (`client` `c` left join `training session` `ts` on(`c`.`Client ID` = `ts`.`Client ID`)) GROUP BY `c`.`Client ID`, `c`.`First Name`, `c`.`Last Name` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `client`
--
ALTER TABLE `client`
  ADD PRIMARY KEY (`Client ID`),
  ADD KEY `FKCoachID` (`Coach ID`),
  ADD KEY `FKPackageID` (`Package ID`);

--
-- Indexes for table `coach`
--
ALTER TABLE `coach`
  ADD PRIMARY KEY (`CoachID`),
  ADD KEY `FKManagerID` (`ManagerID`);

--
-- Indexes for table `coach specialization`
--
ALTER TABLE `coach specialization`
  ADD PRIMARY KEY (`Coach ID`,`Specialization`(15));

--
-- Indexes for table `package`
--
ALTER TABLE `package`
  ADD PRIMARY KEY (`Package ID`);

--
-- Indexes for table `room`
--
ALTER TABLE `room`
  ADD PRIMARY KEY (`Room ID`);

--
-- Indexes for table `room_booking`
--
ALTER TABLE `room_booking`
  ADD PRIMARY KEY (`Room ID`,`Client ID`,`Booking Date`),
  ADD KEY `FKClientID` (`Client ID`);

--
-- Indexes for table `session`
--
ALTER TABLE `session`
  ADD PRIMARY KEY (`Session ID`),
  ADD KEY `FKRoomSession` (`Room ID`);

--
-- Indexes for table `training session`
--
ALTER TABLE `training session`
  ADD PRIMARY KEY (`Session ID`,`Coach ID`,`Client ID`),
  ADD KEY `FKCoachTrainingID` (`Coach ID`),
  ADD KEY `FKClientTraining` (`Client ID`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `client`
--
ALTER TABLE `client`
  ADD CONSTRAINT `FKCoachID` FOREIGN KEY (`Coach ID`) REFERENCES `coach` (`CoachID`),
  ADD CONSTRAINT `FKPackageID` FOREIGN KEY (`Package ID`) REFERENCES `package` (`Package ID`);

--
-- Constraints for table `coach`
--
ALTER TABLE `coach`
  ADD CONSTRAINT `FKManagerID` FOREIGN KEY (`ManagerID`) REFERENCES `coach` (`CoachID`);

--
-- Constraints for table `room_booking`
--
ALTER TABLE `room_booking`
  ADD CONSTRAINT `FKClientID` FOREIGN KEY (`Client ID`) REFERENCES `client` (`Client ID`),
  ADD CONSTRAINT `FKRoomID` FOREIGN KEY (`Room ID`) REFERENCES `room` (`Room ID`);

--
-- Constraints for table `session`
--
ALTER TABLE `session`
  ADD CONSTRAINT `FKRoomSession` FOREIGN KEY (`Room ID`) REFERENCES `room` (`Room ID`);

--
-- Constraints for table `training session`
--
ALTER TABLE `training session`
  ADD CONSTRAINT `FKClientTraining` FOREIGN KEY (`Client ID`) REFERENCES `client` (`Client ID`),
  ADD CONSTRAINT `FKCoachTrainingID` FOREIGN KEY (`Coach ID`) REFERENCES `coach` (`CoachID`),
  ADD CONSTRAINT `FKSessionID` FOREIGN KEY (`Session ID`) REFERENCES `session` (`Session ID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
