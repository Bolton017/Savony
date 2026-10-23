ALTER TABLE REMBOURSEMENT MODIFY mois INT;
ALTER TABLE REMBOURSEMENT MODIFY annee INT;

ALTER TABLE POINTAGECANTINE ADD NOMBRE NUMBER(30, 2);

INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1765892827090649', 'Pointage cantine', 'add', 'module.jsp?but=cantine/pointage-cantine.jsp', 4, 3, 'MD000020040030');

-- script pour l'usermenu
DELETE FROM usermenu WHERE id = 'UM6F12F04F'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM17089E5B'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM890B937E'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM05C59346'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UME81AAE92'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM79EABE2C'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM7EBA1802'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM99E6A7EF'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM1A27A7C5'; -- 1 rows