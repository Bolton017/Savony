--Menu manana id MNDN000000014 ovaina ny libelle atao hoe “Saisie” de ny id_pere atao MNDN000000013

UPDATE MENUDYNAMIQUE
SET LIBELLE='Saisie', ICONE='fa fa-plus', HREF='module.jsp?but=facturefournisseur/facturefournisseur-saisie.jsp', RANG=1, NIVEAU=3, ID_PERE='MNDN000000013'
WHERE ID='MNDN000000014';

--Mamorona menu ao am Achat (id = MNDN000000002)
--
--Mere: Bon de commande 

--Saisie 
--
--lien:  module.jsp?but=bondecommande/bondecommande-saisie.jsp
--
--Liste
--
--lien:  module.jsp?but=bondecommande/bondecommande-liste.jsp

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MNDN001804001', 'Bon de commande', 'fa fa-book', NULL, 7, 2, 'MNDN000000002');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MNDN001804002', 'Saisie', 'fa fa-plus', 'module.jsp?but=bondecommande/bondecommande-saisie.jsp', 1, 3, 'MNDN001804001');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MNDN001804003', 'Liste', 'fa fa-list', 'module.jsp?but=bondecommande/bondecommande-liste.jsp', 2, 3, 'MNDN001804001');



--Mere: Bon de livraison
--
--Saisie
--
--lien:  module.jsp?but=bondelivraison/bondelivraison-saisie.jsp
--
--Liste
--
--lien:  module.jsp?but=bondelivraison/bondelivraison-saisie.jsp

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MNDN001804004', 'Bon de livraison', 'fa fa-truck', NULL, 8, 2, 'MNDN000000002');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MNDN001804005', 'Saisie', 'fa fa-plus', 'module.jsp?but=bondelivraison/bondelivraison-saisie.jsp', 1, 3, 'MNDN001804004');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MNDN001804006', 'Liste', 'fa fa-list', 'module.jsp?but=bondelivraison/bondelivraison-saisie.jsp', 2, 3, 'MNDN001804004');

--
--Facturer livraison
--
--lien:  module.jsp?but=bondelivraison/facturer-livraison.jsp


INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MNDN001804007', 'Facturer livraison', 'fa fa-list', 'module.jsp?but=bondelivraison/facturer-livraison.jsp', 9, 2, 'MNDN000000002');