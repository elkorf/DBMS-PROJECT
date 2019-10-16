-- phpMyAdmin SQL Dump
-- version 4.7.4
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Oct 16, 2019 at 06:23 AM
-- Server version: 10.1.28-MariaDB
-- PHP Version: 7.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `sig_management`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `eventcount` ()  BEGIN
    DECLARE finished INTEGER DEFAULT 0;
    DECLARE store varchar(10);
    DECLARE noOfEvents INT;
 
    SET noOfEvents :=0;
    
    BEGIN
     
    DECLARE t_event CURSOR FOR 
    SELECT event_id FROM event;
 
    
    DECLARE CONTINUE HANDLER 
FOR NOT FOUND SET finished = 1;
 
    OPEN t_event;
 
    getUsers: LOOP
FETCH t_event INTO store;

IF finished = 1 THEN 
    LEAVE getUsers;
ELSE
    SET noOfEvents := noOfEvents+1;
END IF;
    END LOOP getUsers;
    CLOSE t_event;
    END;
  SELECT noOfEvents;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getAnswers` (IN `qid` VARCHAR(10))  NO SQL
BEGIN
	select * from answers
	where question_id = qid
   	order by posted_on DESC;
END$$

CREATE DEFINER=``@`localhost` PROCEDURE `getComments` (IN `pid` VARCHAR(10))  begin
select * from comments where post_id=pid order by posted_on desc;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `groupcount` ()  BEGIN
    DECLARE finished INTEGER DEFAULT 0;
    DECLARE store varchar(10);
    DECLARE noOfGroups INT;
 
    SET noOfGroups :=0;
    
    BEGIN
     
    DECLARE t_group CURSOR FOR 
    SELECT group_id FROM group_details;
 
    
    DECLARE CONTINUE HANDLER 
FOR NOT FOUND SET finished = 1;
 
    OPEN t_group;
 
    getUsers: LOOP
FETCH t_group INTO store;

IF finished = 1 THEN 
    LEAVE getUsers;
ELSE
    SET noOfGroups := noOfGroups+1;
END IF;
    END LOOP getUsers;
    CLOSE t_group;
    END;
  SELECT noOfGroups;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `isMember` (IN `uid` VARCHAR(10), IN `gid` VARCHAR(10))  BEGIN
	select * from group_members where group_id = gid and user_id = uid;
END$$

CREATE DEFINER=``@`localhost` PROCEDURE `leave_group` (IN `uid` VARCHAR(11), IN `gid` VARCHAR(11))  begin
    delete from `event` where user_id = uid and group_id = gid;
    delete from `answers` where user_id = uid and question_id in (select question_id from questions where group_id = gid);
    delete from `comments` where user_id = uid and post_id in (select post_id from post where group_id = gid);
    delete from `post` where user_id = uid and group_id = gid;
    delete from `questions` where user_id = uid and group_id = gid;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usercount` ()  BEGIN     DECLARE finished INTEGER DEFAULT 0;     DECLARE store varchar(10);     DECLARE noOfUsers INT;       SET noOfUsers :=0;          BEGIN           DECLARE t_users CURSOR FOR      SELECT user_id FROM users;            DECLARE CONTINUE HANDLER  FOR NOT FOUND SET finished = 1;       OPEN t_users;       getUsers: LOOP FETCH t_users INTO store;  IF finished = 1 THEN      LEAVE getUsers; ELSE     SET noOfUsers := noOfUsers+1; END IF;     END LOOP getUsers;     CLOSE t_users;     END;   SELECT noOfUsers; END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `answers`
--

CREATE TABLE `answers` (
  `question_id` int(11) NOT NULL,
  `answer_id` int(11) NOT NULL,
  `answer` varchar(500) NOT NULL,
  `user_id` varchar(10) NOT NULL,
  `posted_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `answers`
--

INSERT INTO `answers` (`question_id`, `answer_id`, `answer`, `user_id`, `posted_on`) VALUES
(1, 1, 'answer on java by manas', 'manas', '2019-09-27 12:16:57'),
(1, 2, 'answer on java by jayesh', 'jayesh', '2019-09-27 12:16:57'),
(5, 3, 'answer for another question in php', 'jayesh', '2019-09-27 12:18:12'),
(5, 4, 'answer on another question in php', 'manas', '2019-09-27 12:18:12'),
(7, 7, 'gr8 keep it up', 'manas', '2019-10-09 21:01:09'),
(8, 8, 'wrong group for a cpp question', 'manas', '2019-10-09 21:19:43'),
(9, 9, 'q2 a1', 'manas', '2019-10-09 21:24:02'),
(2, 10, 'ok', 'manas', '2019-10-10 05:59:09'),
(6, 11, 'no', 'manas', '2019-10-10 05:59:19'),
(7, 12, 'this is answer of blockchain question ', 'swapnil', '2019-10-10 07:01:29'),
(10, 13, 'Its a sequre chaining using hashing', 'manas', '2019-10-10 07:31:37'),
(11, 14, 'adgh', 'manas', '2019-10-10 08:40:33'),
(12, 15, 'answer by niranjan', 'niranjan', '2019-10-10 09:02:04'),
(13, 16, 'Ask your questions here', 'sanket', '2019-10-15 02:43:00');

-- --------------------------------------------------------

--
-- Table structure for table `comments`
--

CREATE TABLE `comments` (
  `comment_id` int(11) NOT NULL,
  `comment` varchar(500) NOT NULL,
  `post_id` int(11) NOT NULL,
  `user_id` varchar(10) NOT NULL,
  `posted_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `comments`
--

INSERT INTO `comments` (`comment_id`, `comment`, `post_id`, `user_id`, `posted_on`) VALUES
(1, 'comment on java post of manas', 4, 'manas', '2019-09-18 12:10:04'),
(2, 'comment on php post of jayesh', 1, 'manas', '2019-09-27 12:10:04'),
(3, 'comment on java post of jayesh', 2, 'manas', '2019-09-27 12:10:04'),
(4, 'comment on php post of manas', 3, 'jayesh', '2019-09-27 12:10:04'),
(5, 'comment on java post of manas', 4, 'jayesh', '2019-09-27 12:10:04'),
(6, 'great keep it up', 6, 'manas', '2019-10-09 20:50:07'),
(7, 'ok gr8', 6, 'manas', '2019-10-09 20:57:19'),
(8, 'comment 1', 7, 'manas', '2019-10-09 21:19:04'),
(9, 'comment 2', 7, 'manas', '2019-10-09 21:19:13'),
(10, 'gr8', 5, 'manas', '2019-10-10 05:58:30'),
(11, 'dcghsdhcdsjfh', 8, 'manas', '2019-10-10 06:35:01'),
(12, 'hello guys', 7, 'manas', '2019-10-10 06:56:59'),
(13, 'hello guys', 8, 'swapnil', '2019-10-10 06:58:50'),
(14, 'but i have doubt', 6, 'swapnil', '2019-10-10 06:59:57'),
(15, 'okkk', 10, 'manas', '2019-10-10 07:28:41'),
(16, 'asdfghj', 11, 'manas', '2019-10-10 08:40:11'),
(17, 'sdsdfs\r\n', 10, 'manas', '2019-10-11 06:30:39'),
(18, 'bv\r\n', 12, 'manas', '2019-10-14 18:10:34'),
(19, 'New Events Updated', 14, 'sanket', '2019-10-15 02:42:14'),
(20, 'asdfgh', 15, 'manas', '2019-10-15 05:30:47');

-- --------------------------------------------------------

--
-- Table structure for table `event`
--

CREATE TABLE `event` (
  `event_id` int(11) NOT NULL,
  `details` varchar(500) NOT NULL,
  `group_id` varchar(10) NOT NULL,
  `date` date NOT NULL,
  `user_id` varchar(10) NOT NULL,
  `posted_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `event_name` varchar(50) NOT NULL,
  `venue` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `event`
--

INSERT INTO `event` (`event_id`, `details`, `group_id`, `date`, `user_id`, `posted_on`, `event_name`, `venue`) VALUES
(1, 'blockchain event', 'blockchain', '2019-10-03', 'manas', '2019-10-09 21:17:41', 'blk1', 'pict'),
(2, 'seminar on java', 'java', '2019-10-17', 'jayesh', '2019-09-27 12:12:47', 'java', 'pict'),
(3, 'seminar on php', 'php', '2019-10-09', 'manas', '2019-09-27 12:12:47', 'php', 'gpn'),
(4, 'Meetup for all c coders', 'c', '2019-10-31', 'manas', '2019-10-09 21:21:18', 'C meetup', 'Semina hall IT'),
(5, 'asdhs fhsdgfhaf ', 'c', '2019-10-16', 'manas', '2019-10-09 21:23:44', 'event2 ', 'sq+wert'),
(6, 'mett  ', 'hadoop', '2019-10-23', 'manas', '2019-10-10 08:40:57', 'meetup', 'ASDFG'),
(7, 'workshop on mongo', 'mongo', '2019-10-23', 'niranjan', '2019-10-10 09:02:41', 'workshop', 'pict'),
(8, 'blk 2', 'blockchain', '2019-10-17', 'manas', '2019-10-14 21:01:46', 'blk 2', 'sllab'),
(9, 'blk 3', 'blockchain', '2019-10-26', 'manas', '2019-10-14 21:02:05', 'blk 3', 'pllab'),
(10, 'jaahj', 'mongo', '2019-10-23', 'manas', '2019-10-14 21:03:30', 'ahah', 'ajhahj'),
(11, 'sedrftghj', 'mongo', '2019-10-31', 'manas', '2019-10-14 21:03:42', 'wert', 'sdddddddddd'),
(12, 'Python sig 1', 'python', '2019-10-11', 'sanket', '2019-10-15 02:43:28', 'Python sig 1', 'sllab'),
(13, 'python sig meet 2', 'python', '2019-10-30', 'sanket', '2019-10-15 02:43:51', 'python sig meet 2', 'nl lab');

-- --------------------------------------------------------

--
-- Table structure for table `group_details`
--

CREATE TABLE `group_details` (
  `group_id` varchar(10) NOT NULL,
  `group_name` varchar(50) NOT NULL,
  `description` varchar(100) NOT NULL,
  `created_by` varchar(10) NOT NULL,
  `date_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `group_details`
--

INSERT INTO `group_details` (`group_id`, `group_name`, `description`, `created_by`, `date_created`) VALUES
('blockchain', 'grp for blokckchain', 'Group that will walk through start to end development of a blockchain based site using java', 'manas', '2019-09-18 17:19:46'),
('c', 'grp for c', 'Old Is Gold An SIG to discuss The C language', 'jayesh', '2019-10-03 17:19:46'),
('cloud', 'cloud computing', 'Cloud computing can help us explore many new fields!', 'manas', '2019-10-10 10:25:43'),
('hadoop', 'hadoop', 'Lets Learn HADOOP', 'swapnil', '2019-10-02 17:19:46'),
('java', 'JAVA SIg', 'Java Programming, Core java, Swing, Awt all will be covered here  ', 'jayesh', '2019-10-01 17:19:46'),
('jsp', 'JSP SIG', 'The JSP sig will allow you to solve all your problems related to jsp development and deployment', 'manas', '2019-10-06 17:19:46'),
('mongo', 'grp for mongo', 'NoSQL is the future lets learn and grow together ', 'swapnil', '2019-10-04 17:19:46'),
('mysql', 'MySQL', 'MySQL sig will cover all the important aspects of database and rdbms', 'manas', '2019-10-05 17:19:46'),
('php', 'PHP PUNE', 'PHP PUNE is the official group for all the php developers in pune', 'jayesh', '2019-09-19 17:19:46'),
('python', 'Python SIG', 'Python Sig focuses on covering all the basic aspects and concepts of python.', 'sanket', '2019-10-15 02:41:09');

-- --------------------------------------------------------

--
-- Table structure for table `group_members`
--

CREATE TABLE `group_members` (
  `group_id` varchar(10) NOT NULL,
  `user_id` varchar(10) NOT NULL,
  `designation` varchar(20) NOT NULL DEFAULT 'member'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `group_members`
--

INSERT INTO `group_members` (`group_id`, `user_id`, `designation`) VALUES
('blockchain', 'manas', 'admin'),
('blockchain', 'niranjan', 'member'),
('blockchain', 'swapnil', 'member'),
('c', 'manas', 'member'),
('cloud', 'manas', 'admin'),
('java', 'jayesh', 'admin'),
('jsp', 'manas', 'admin'),
('mongo', 'manas', 'member'),
('mongo', 'niranjan', 'member'),
('mysql', 'manas', 'admin'),
('mysql', 'swapnil', 'member'),
('php', 'jayesh', 'admin'),
('php', 'manas', 'member'),
('php', 'niranjan', 'member'),
('php', 'sanket', 'member'),
('python', 'manas', 'member'),
('python', 'sanket', 'admin'),
('python', 'swapnil', 'member');

-- --------------------------------------------------------

--
-- Table structure for table `post`
--

CREATE TABLE `post` (
  `post_id` int(11) NOT NULL,
  `post` varchar(500) NOT NULL,
  `group_id` varchar(10) NOT NULL,
  `user_id` varchar(10) NOT NULL,
  `posted_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `post`
--

INSERT INTO `post` (`post_id`, `post`, `group_id`, `user_id`, `posted_on`) VALUES
(1, 'post of php group by jayesh', 'php', 'jayesh', '2019-09-18 05:51:50'),
(2, 'post of group java by jayesh', 'java', 'jayesh', '2019-09-11 12:11:42'),
(3, 'post on php by manas', 'php', 'manas', '2019-09-27 12:11:42'),
(4, 'post on java by manas', 'java', 'manas', '2019-09-27 12:11:42'),
(5, 'Php stands for php hypertext pre-processor it is a recursive acronym.', 'php', 'manas', '2019-10-09 20:15:13'),
(6, 'this is first post of blockchain', 'blockchain', 'manas', '2019-10-09 20:23:31'),
(7, 'first post\r\n', 'c', 'manas', '2019-10-09 21:18:55'),
(8, 'post 123', 'blockchain', 'manas', '2019-10-10 06:34:51'),
(9, 'this is new post to see the new features of java in java 11', 'blockchain', 'swapnil', '2019-10-10 07:00:42'),
(10, 'dfsfs', 'blockchain', 'swapnil', '2019-10-10 07:03:33'),
(11, 'post 1', 'hadoop', 'manas', '2019-10-10 08:40:04'),
(12, 'VB', 'c', 'manas', '2019-10-10 08:46:22'),
(13, 'post here', 'mongo', 'niranjan', '2019-10-10 09:01:31'),
(14, 'First post in python sig to inform you all about the workshop. Stay tuned to the event Section', 'python', 'sanket', '2019-10-15 02:41:58'),
(15, 'asdfghj', 'mysql', 'manas', '2019-10-15 05:30:37');

-- --------------------------------------------------------

--
-- Table structure for table `questions`
--

CREATE TABLE `questions` (
  `question_id` int(11) NOT NULL,
  `question` varchar(500) NOT NULL,
  `group_id` varchar(10) NOT NULL,
  `user_id` varchar(10) NOT NULL,
  `resolved_by` varchar(10) DEFAULT NULL,
  `posted_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `questions`
--

INSERT INTO `questions` (`question_id`, `question`, `group_id`, `user_id`, `resolved_by`, `posted_on`) VALUES
(1, 'quesion on java', 'java', 'jayesh', NULL, '2019-09-27 12:14:09'),
(2, 'quesion on php', 'php', 'jayesh', NULL, '2019-09-27 12:15:38'),
(3, 'quesion on java', 'java', 'manas', NULL, '2019-09-27 12:15:38'),
(4, 'another quesion on java', 'java', 'manas', NULL, '2019-09-27 12:15:38'),
(5, 'another quesion on php', 'php', 'manas', NULL, '2019-09-27 12:15:38'),
(6, 'can anyone tell me how to connect to mongodb trough php?', 'php', 'manas', NULL, '2019-10-09 20:22:08'),
(7, 'This is first question of blockchain', 'blockchain', 'manas', NULL, '2019-10-09 20:23:47'),
(8, 'question abt stdcpp', 'c', 'manas', NULL, '2019-10-09 21:19:25'),
(9, 'q2', 'c', 'manas', NULL, '2019-10-09 21:23:51'),
(10, 'what is blockchain actually?', 'blockchain', 'swapnil', NULL, '2019-10-10 07:01:55'),
(11, 'q1', 'hadoop', 'manas', NULL, '2019-10-10 08:40:24'),
(12, 'question by niranjan', 'mongo', 'niranjan', NULL, '2019-10-10 09:01:50'),
(13, 'No Question is a dumb one', 'python', 'sanket', NULL, '2019-10-15 02:42:40');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` varchar(10) NOT NULL,
  `name` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `password` varchar(32) NOT NULL,
  `mobile_number` varchar(10) NOT NULL,
  `acc_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `name`, `email`, `password`, `mobile_number`, `acc_created`) VALUES
('jayesh', 'jayesh', 'prajapatijayesh1999@gmail.omc', '4d069b4e77b1d1804bead1d3bea762b8', '8888888855', '2019-09-25 12:13:30'),
('man', 'manas patil', 'pmanas10001@gmail.com', '4a56408678fdde215d6621287cb65262', '6666666666', '2019-10-15 05:28:09'),
('manas', 'manas', 'mnpatil155137@gmail.com', '5d45c58ea1ef37f17c2f885219215426', '8888888888', '2019-09-24 12:13:30'),
('niranjan', 'Niranjan', 'niranjanpatil391312@gmail.com', '03b562c208fdaefdcc43a09acb7ba087', '8866554411', '2019-10-09 13:16:13'),
('sanket', 'Sanket', 'sanketsahane6@gmail.com', '81c6fa745434534c4a9633ad8c08506a', '6666666666', '2019-10-14 17:54:26'),
('swapnil', 'swapnil', 'patilswapnil2512@gmail.com', 'b39a5005f03f16e882a911cd34f86043', '8855221111', '2019-10-15 17:56:17');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `answers`
--
ALTER TABLE `answers`
  ADD PRIMARY KEY (`answer_id`),
  ADD KEY `fk_question_answer` (`question_id`),
  ADD KEY `fk_user_answer` (`user_id`);

--
-- Indexes for table `comments`
--
ALTER TABLE `comments`
  ADD PRIMARY KEY (`comment_id`),
  ADD KEY `fk_post_comments` (`post_id`),
  ADD KEY `fk_user_comments` (`user_id`);

--
-- Indexes for table `event`
--
ALTER TABLE `event`
  ADD PRIMARY KEY (`event_id`),
  ADD KEY `fk_group_event` (`group_id`),
  ADD KEY `fk_user_event` (`user_id`);

--
-- Indexes for table `group_details`
--
ALTER TABLE `group_details`
  ADD PRIMARY KEY (`group_id`),
  ADD KEY `fk_group_creator` (`created_by`);

--
-- Indexes for table `group_members`
--
ALTER TABLE `group_members`
  ADD PRIMARY KEY (`group_id`,`user_id`),
  ADD KEY `group_id` (`group_id`),
  ADD KEY `fk_user` (`user_id`);

--
-- Indexes for table `post`
--
ALTER TABLE `post`
  ADD PRIMARY KEY (`post_id`),
  ADD KEY `fk_group_post` (`group_id`),
  ADD KEY `fk_user_post` (`user_id`);

--
-- Indexes for table `questions`
--
ALTER TABLE `questions`
  ADD PRIMARY KEY (`question_id`),
  ADD KEY `fk_group_question` (`group_id`),
  ADD KEY `fk_user_question` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `unique_email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `answers`
--
ALTER TABLE `answers`
  MODIFY `answer_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `comments`
--
ALTER TABLE `comments`
  MODIFY `comment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `event`
--
ALTER TABLE `event`
  MODIFY `event_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `post`
--
ALTER TABLE `post`
  MODIFY `post_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `questions`
--
ALTER TABLE `questions`
  MODIFY `question_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `answers`
--
ALTER TABLE `answers`
  ADD CONSTRAINT `fk_question_ans` FOREIGN KEY (`question_id`) REFERENCES `questions` (`question_id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_user_answer` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Constraints for table `comments`
--
ALTER TABLE `comments`
  ADD CONSTRAINT `fk_post_comment` FOREIGN KEY (`post_id`) REFERENCES `post` (`post_id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_user_comments` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE NO ACTION;

--
-- Constraints for table `event`
--
ALTER TABLE `event`
  ADD CONSTRAINT `fk_group_event` FOREIGN KEY (`group_id`) REFERENCES `group_details` (`group_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_user_event` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `group_details`
--
ALTER TABLE `group_details`
  ADD CONSTRAINT `fk_group_creator` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Constraints for table `group_members`
--
ALTER TABLE `group_members`
  ADD CONSTRAINT `fk_group` FOREIGN KEY (`group_id`) REFERENCES `group_details` (`group_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `post`
--
ALTER TABLE `post`
  ADD CONSTRAINT `fk_group_post` FOREIGN KEY (`group_id`) REFERENCES `group_details` (`group_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_user_post` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `questions`
--
ALTER TABLE `questions`
  ADD CONSTRAINT `fk_group_question` FOREIGN KEY (`group_id`) REFERENCES `group_details` (`group_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_user_question` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
