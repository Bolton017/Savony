INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) 
VALUES('MNDNC0000221', 'Produits', 'package_2', '', 2, 1, NULL);

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) 
VALUES('MNDNC0000222', 'Produits semi-fini', 'box', 'module.jsp?but=produits/as-produitsemiFini-liste.jsp', 2, 2, 'MNDNC0000221');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) 
VALUES('MNDNC0000223', 'Produits fini', 'box', 'module.jsp?but=produits/produitFini.jsp', 3, 2, 'MNDNC0000221');

UPDATE  menudynamique SET rang=1 WHERE id='MNDN00001' ;
UPDATE  menudynamique SET niveau=2 WHERE id='MNDN00001' ;
UPDATE  menudynamique SET id_pere='MNDNC0000221' WHERE id='MNDN00001' ;

INSERT INTO USERMENU(id,idmenu,idrole) VALUES ('USERMN00022','MNDNC0000222','dg');
INSERT INTO USERMENU(id,idmenu,idrole) VALUES ('USERMN00021','MNDNC0000223','dg');
