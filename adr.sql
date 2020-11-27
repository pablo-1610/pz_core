

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";





CREATE TABLE `adr` (
  `id` int(11) NOT NULL,
  `author` text NOT NULL,
  `date` text NOT NULL,
  `firstname` text NOT NULL,
  `lastname` text NOT NULL,
  `reason` text NOT NULL,
  `dangerosity` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



ALTER TABLE `adr`
  ADD PRIMARY KEY (`id`);




ALTER TABLE `adr`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;
COMMIT;

