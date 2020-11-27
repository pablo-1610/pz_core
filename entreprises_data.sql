

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";







CREATE TABLE `entreprises_data` (
  `label` varchar(80) NOT NULL,
  `items` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- Les sql se font automatiquement pour les entreprises



ALTER TABLE `entreprises_data`
  ADD PRIMARY KEY (`label`);
COMMIT;

