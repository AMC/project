-- phpMyAdmin SQL Dump
-- version 3.4.5deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Mar 18, 2012 at 09:04 PM
-- Server version: 5.1.58
-- PHP Version: 5.3.6-13ubuntu3.3

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `mugshotdb`
--

-- --------------------------------------------------------

--
-- Table structure for table `elements`
--

CREATE TABLE IF NOT EXISTS `elements` (
  `page` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `type` varchar(255) NOT NULL,
  `body` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `elements`
--

INSERT INTO `elements` (`page`, `name`, `type`, `body`) VALUES
('index', 'title', 'textbox', 'Welcome to the Mugshot Casino!'),
('index', 'body', 'textarea', '<p>\r\nNow on Facebook, play your favorite casino games while staring at your friend''s ugly mugs! \r\n</p>\r\n<p>\r\nClick <a href=''http://apps.facebook.com/mugshotcasino''>HERE</a> to play now!\r\n</p>\r\n'),
('prizes', 'title', 'textbox', ''),
('prizes', 'body', 'textarea', '');

-- --------------------------------------------------------

--
-- Table structure for table `prizes`
--

CREATE TABLE IF NOT EXISTS `prizes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `category` varchar(255) NOT NULL,
  `price` int(11) NOT NULL,
  `image` varchar(255) NOT NULL,
  `description` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=7 ;

--
-- Dumping data for table `prizes`
--

INSERT INTO `prizes` (`id`, `name`, `category`, `price`, `image`, `description`) VALUES
(5, 'Ducks', 'Novelties', 50, '5.jpg', 'When these guys are ready to get down there''s no way you''ll want to duck out of the party...'),
(6, 'Kazoo', 'Novelties', 75, '6.jpg', 'Don''t you love it when people Kazoo? Now you Kanzoo too!\r\n');

-- --------------------------------------------------------

--
-- Table structure for table `subelements`
--

CREATE TABLE IF NOT EXISTS `subelements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `page` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `body` text NOT NULL,
  `weight` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=11 ;

--
-- Dumping data for table `subelements`
--

INSERT INTO `subelements` (`id`, `page`, `name`, `body`, `weight`) VALUES
(8, 'faq', '1.0 Where can I get the app?', 'At the android app store!', 10),
(9, 'release_notes', 'version 1.0', 'Now available at the android app store!', 0),
(10, 'faq', '1.1 What is a faq?', 'It''s a trap!', 11);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`) VALUES
(1, 'admin', 'a3a3e60a8747db4b5e83258da8ce5e0b5311812c9e0a62b8e3815df1ba7c50585ff0da0cc58cfb9e9711727f7e5af47268185190c03ad8c54f44a1fb94c6b538');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
