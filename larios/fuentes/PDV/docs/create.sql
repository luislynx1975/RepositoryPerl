# ---------------------------------------------------------------------- #
# Script generated with: DeZign for Databases v6.2.1                     #
# Target DBMS:           MySQL 5                                         #
# Project file:          NuevoPuntoDeVenta 6.2.1.dez                     #
# Project name:                                                          #
# Author:                                                                #
# Script type:           Database creation script                        #
# Created on:            2011-05-18 09:19                                #
# ---------------------------------------------------------------------- #


# ---------------------------------------------------------------------- #
# Tables                                                                 #
# ---------------------------------------------------------------------- #

# ---------------------------------------------------------------------- #
# Add table "PDV_C_AGENCIA"                                              #
# ---------------------------------------------------------------------- #

CREATE TABLE `PDV_C_AGENCIA` (
    `ID_AGENCIA` VARCHAR(10) NOT NULL,
    `NOMBRE` VARCHAR(100) NOT NULL,
    `ASIENTO_INICIAL` INTEGER NOT NULL,
    `ASIENTO_FINAL` INTEGER NOT NULL,
    `FECHA_BAJA` DATETIME,
    CONSTRAINT `PK_PDV_C_AGENCIA` PRIMARY KEY (`ID_AGENCIA`)
);

# ---------------------------------------------------------------------- #
# Add table "PDV_C_AGENCIA_TERMINAL"                                     #
# ---------------------------------------------------------------------- #

CREATE TABLE `PDV_C_AGENCIA_TERMINAL` (
    `ID_AGENCIA` VARBINARY(10) NOT NULL,
    `ID_TERMINAL` VARCHAR(5) NOT NULL,
    CONSTRAINT `PK_PDV_C_AGENCIA_TERMINAL` PRIMARY KEY (`ID_AGENCIA`, `ID_TERMINAL`)
);

# ---------------------------------------------------------------------- #
# Add table "PDV_C_AGENCIA_CORRIDA"                                      #
# ---------------------------------------------------------------------- #

CREATE TABLE `PDV_C_AGENCIA_CORRIDA` (
    `ID_AGENCIA` VARCHAR(10) NOT NULL,
    `ID_CORRIDA` VARCHAR(10) NOT NULL,
    CONSTRAINT `PK_PDV_C_AGENCIA_CORRIDA` PRIMARY KEY (`ID_AGENCIA`, `ID_CORRIDA`)
);

# ---------------------------------------------------------------------- #
# Foreign key constraints                                                #
# ---------------------------------------------------------------------- #

ALTER TABLE `PDV_C_AGENCIA_TERMINAL` ADD CONSTRAINT `PDV_C_AGENCIA_PDV_C_AGENCIA_TERMINAL` 
    FOREIGN KEY (`ID_AGENCIA`) REFERENCES `PDV_C_AGENCIA` (`ID_AGENCIA`);

ALTER TABLE `PDV_C_AGENCIA_TERMINAL` ADD CONSTRAINT `PDV_C_TERMINAL_PDV_C_AGENCIA_TERMINAL` 
    FOREIGN KEY (`ID_TERMINAL`) REFERENCES `PDV_C_TERMINAL` (`ID_TERMINAL`);

ALTER TABLE `PDV_C_AGENCIA_CORRIDA` ADD CONSTRAINT `PDV_C_AGENCIA_PDV_C_AGENCIA_CORRIDA` 
    FOREIGN KEY (`ID_AGENCIA`) REFERENCES `PDV_C_AGENCIA` (`ID_AGENCIA`);

ALTER TABLE `PDV_C_AGENCIA_CORRIDA` ADD CONSTRAINT `PDV_C_ITINERARIO_PDV_C_AGENCIA_CORRIDA` 
    FOREIGN KEY (`ID_CORRIDA`) REFERENCES `PDV_C_ITINERARIO` (`ID_CORRIDA`);
