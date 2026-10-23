----- 2025-04-09
---------Tiavina

--script menu
---libelle  
--	historique
--		liste: href: historique/historique-liste.jsp

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM000904001', 'Historique', 'fa fa-history', NULL, 14, 1, NULL);

INSERT INTO USERMENU
(ID, REFUSER, IDMENU, IDROLE, CODESERVICE, CODEDIR, INTERDIT)
VALUES('USRMEN0904001', '*', 'ELM000904001', NULL, NULL, NULL, NULL);

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM000904002', 'Liste', 'fa fa-list', 'module.jsp?but=historique/historique-liste.jsp', 1, 2, 'ELM000904001');

--changement icone
UPDATE MENUDYNAMIQUE
SET ICONE='fas fa-boxes'
WHERE ID='MENUDYN00304003';