INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1781249861330490', 'Besoin fabrication', 'grid_view', '', 9, 2, 'MENUDYN00304001');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1781249906138951', 'Planning des besoins', 'access_time', 'module.jsp?but=besoin/besoinFabrication-matierepremiere.jsp', 1, 3, 'MENDYN1781249861330490');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1781249940487583', 'Planning des matières premières', 'access_time', 'module.jsp?but=besoin/besoinFabrication-analyse.jsp', 2, 3, 'MENDYN1781249861330490');

-- script pour l'usermenu
DELETE FROM usermenu WHERE id = 'UMA28BE93C'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UME8E58382'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMEC66E706'; -- 1 rows
