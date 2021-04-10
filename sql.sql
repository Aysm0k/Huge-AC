CREATE TABLE IF NOT EXISTS `ACbans` (
  `identifier` varchar(50) COLLATE utf8mb4_bin NOT NULL,
  `license` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `ip` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `discord` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `nazwa` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `powod` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `typkary` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `datanadania` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `liveid` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `xbl` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;