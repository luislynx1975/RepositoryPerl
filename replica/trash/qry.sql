CREATE TABLE `ADM_STATUS_TABLA` (
    `FECHA` DATE NOT NULL,
    `ID_TERMINAL` VARCHAR(10) NULL DEFAULT NULL,
    `TABLA` VARCHAR(50) NOT NULL,
    `ESTATUS` INT(11) NULL DEFAULT NULL,
    PRIMARY KEY (`FECHA`, `TABLA`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
; 