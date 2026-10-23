UPDATE menudynamique SET libelle = 'État global' WHERE id = 'MENUDYN02108001';
UPDATE menudynamique SET libelle = 'Éditer ristourne' WHERE id = 'MNDN00050500002';
UPDATE menudynamique SET libelle = 'En attente d''avis de crédit' WHERE id = 'MENTRA002';
UPDATE menudynamique SET libelle = 'Bon de réception' WHERE id = 'MNDN001804004';
UPDATE menudynamique SET libelle = 'État de stock', href = '' WHERE id = 'MNDN000000017';
UPDATE menudynamique SET libelle = 'Détails' WHERE id = 'MNDN0000000171';
UPDATE menudynamique SET libelle = 'Détails par pu' WHERE id = 'MNDN0002706171';
UPDATE menudynamique SET libelle = 'Nouvelle inventaire par catégorie' WHERE id = 'MNDN000000028';
UPDATE menudynamique SET libelle = 'État de caisse' WHERE id = 'MENUDYN0011';
UPDATE menudynamique SET libelle = 'Mouvement de caisse', href = '' WHERE id = 'MENUDYN0017';
UPDATE menudynamique SET libelle = 'Nouvelle Entrée' WHERE id = 'MENUDYN00171';
UPDATE menudynamique SET libelle = 'Paiement multiple de facture de vente' WHERE id = 'MENUDYN0077';
UPDATE menudynamique SET libelle = 'Paiement multiple de facture de vente F2s' WHERE id = 'MENUDYN7778';
UPDATE menudynamique SET libelle = 'Prévision', href = '' WHERE id = 'MENUDYN002';
UPDATE menudynamique SET libelle = 'Prévision', href = '', rang = 10 WHERE id = 'MENUDYN002';
UPDATE menudynamique SET rang = 11 WHERE id = 'ELM000010';
UPDATE menudynamique SET libelle = 'Nouvelle prévision' WHERE id = 'MENUDYN0020001';
UPDATE menudynamique SET libelle = 'Liste des prévisions' WHERE id = 'MENUDYN0020002';
UPDATE menudynamique SET libelle = 'Prévision de dépense' WHERE id = 'MENUDYN0020004';
UPDATE menudynamique SET libelle = 'Prévision de recette' WHERE id = 'MENUDYN0020005';
UPDATE menudynamique SET libelle = 'Unité' WHERE id = 'MNDN00000002111114';
UPDATE menudynamique SET icone = 'money', href = '' WHERE id = 'MENDYN1765468296624239';

-- script pour l'usermenu

INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM27BE0046', 'MNDN00605163001', NULL, 'cheffab', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMA9CE9BEB', 'MNDN00605163001', NULL, 'magcentral', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM2E486261', 'MNDN00605163001', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM759F0FA8', 'MNDN00605163001', NULL, 'chefachat', 1);
