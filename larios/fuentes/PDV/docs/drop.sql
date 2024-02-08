# ---------------------------------------------------------------------- #
# Script generated with: DeZign for Databases v6.2.1                     #
# Target DBMS:           MySQL 5                                         #
# Project file:          NuevoPuntoDeVenta 6.2.1.dez                     #
# Project name:                                                          #
# Author:                                                                #
# Script type:           Database drop script                            #
# Created on:            2011-05-18 09:19                                #
# ---------------------------------------------------------------------- #


# ---------------------------------------------------------------------- #
# Drop foreign key constraints                                           #
# ---------------------------------------------------------------------- #

ALTER TABLE `PDV_C_AGENCIA_TERMINAL` DROP FOREIGN KEY `PDV_C_AGENCIA_PDV_C_AGENCIA_TERMINAL`;

ALTER TABLE `PDV_C_AGENCIA_TERMINAL` DROP FOREIGN KEY `PDV_C_TERMINAL_PDV_C_AGENCIA_TERMINAL`;

ALTER TABLE `PDV_C_AGENCIA_CORRIDA` DROP FOREIGN KEY `PDV_C_AGENCIA_PDV_C_AGENCIA_CORRIDA`;

ALTER TABLE `PDV_C_AGENCIA_CORRIDA` DROP FOREIGN KEY `PDV_C_ITINERARIO_PDV_C_AGENCIA_CORRIDA`;

# ---------------------------------------------------------------------- #
# Drop table "PDV_C_AGENCIA_CORRIDA"                                     #
# ---------------------------------------------------------------------- #

# Drop constraints #

ALTER TABLE `PDV_C_AGENCIA_CORRIDA` DROP PRIMARY KEY;

# Drop table #

DROP TABLE `PDV_C_AGENCIA_CORRIDA`;

# ---------------------------------------------------------------------- #
# Drop table "PDV_C_AGENCIA_TERMINAL"                                    #
# ---------------------------------------------------------------------- #

# Drop constraints #

ALTER TABLE `PDV_C_AGENCIA_TERMINAL` DROP PRIMARY KEY;

# Drop table #

DROP TABLE `PDV_C_AGENCIA_TERMINAL`;

# ---------------------------------------------------------------------- #
# Drop table "PDV_C_AGENCIA"                                             #
# ---------------------------------------------------------------------- #

# Drop constraints #

ALTER TABLE `PDV_C_AGENCIA` DROP PRIMARY KEY;

# Drop table #

DROP TABLE `PDV_C_AGENCIA`;
