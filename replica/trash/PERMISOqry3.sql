USE mysql;
GRANT ALTER ROUTINE, CREATE ROUTINE  ON `CORPORATIVO`.* TO 'venta'@'%';
FLUSH PRIVILEGES;