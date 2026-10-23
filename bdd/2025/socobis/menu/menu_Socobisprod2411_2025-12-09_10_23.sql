UPDATE menudynamique SET libelle = 'Gestion d''immobilisation', href = '' WHERE id = 'ELM001026';
UPDATE menudynamique SET libelle = 'Gestion d''immobilisation', href = '', rang = 13, id_pere = 'MNDN00000002111' WHERE id = 'ELM001026';
UPDATE menudynamique SET rang = 8 WHERE id = 'INVET0001425';
UPDATE menudynamique SET libelle = 'Catégorie d''immobilisation', href = '' WHERE id = 'ELM000411';
UPDATE menudynamique SET libelle = 'Catégorie d''immobilisation', href = '/fer/pages/module.jsp?but=immo/configuration/categorie-liste.jsp' WHERE id = 'ELM000411';
UPDATE menudynamique SET href = '/fer/pages/module.jsp?but=immo/inventaire/inventaire-liste.jsp', rang = 8 WHERE id = 'INVET0001425';

-- script pour l'usermenu

INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMFD04E474', 'ELM001026', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM5304D210', 'ELM001026', NULL, 'dg', 1);
