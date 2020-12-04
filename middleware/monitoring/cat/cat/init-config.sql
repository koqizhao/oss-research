
USE `cat`;

UPDATE `config` SET `content` = 'SERVER_CONFIG' WHERE (`name` = 'server-config');

UPDATE `config` SET `content` = 'ROUTE_CONFIG' WHERE (`name` = 'routerConfig');
