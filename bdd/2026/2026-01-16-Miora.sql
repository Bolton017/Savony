
INSERT INTO roles (idrole, descrole, rang) VALUES ('mag_central_bisc', 'Magasin Central Biscuiterie', 2);
INSERT INTO roles (idrole, descrole, rang) VALUES ('mag_transit_mp_bisc', 'Magasin Transit Matières Premières Biscuiterie', 2);
INSERT INTO roles (idrole, descrole, rang) VALUES ('mag_transit_emb_bisc', 'Magasin Transit Emballage + Magasin intermédiaire Biscuiterie', 2);
INSERT INTO roles (idrole, descrole, rang) VALUES ('ctr_fab_ab_bisc', 'Contremaitre fabrication Equipe A-B', 4);
INSERT INTO roles (idrole, descrole, rang) VALUES ('ctr_cond_ab_bisc', 'Contremaitre conditionnement Equipe A-B', 4);
INSERT INTO roles (idrole, descrole, rang) VALUES ('ctr_fab_bc_bisc', 'Contremaitre fabrication Equipe B-C', 4);
INSERT INTO roles (idrole, descrole, rang) VALUES ('ctr_cond_bc_bisc', 'Contremaitre conditionnement Equipe B-C', 4);
INSERT INTO roles (idrole, descrole, rang) VALUES ('mag_gaz', 'Magasin gasoil + Magasin gaz 1 + Magasin gaz 2', 2);
INSERT INTO roles (idrole, descrole, rang) VALUES ('chef_prod_bisc', 'Chef de production Biscuiterie', 5);
INSERT INTO roles (idrole, descrole, rang) VALUES ('sec_prod_bisc', 'Secrétaire Prod', 1);
INSERT INTO roles (idrole, descrole, rang) VALUES ('chef_dep_bisc', 'Chef de departement Atelier Biscuiterie', 5);
INSERT INTO roles (idrole, descrole, rang) VALUES ('assist_ctrm', 'Assistant contre maitre', 1);
INSERT INTO roles (idrole, descrole, rang) VALUES ('mag_central_conf', 'Magasin Central Confiserie', 2);
INSERT INTO roles (idrole, descrole, rang) VALUES ('chef_prod_conf', 'Chef de production Confiserie', 5);
INSERT INTO roles (idrole, descrole, rang) VALUES ('ctr_cond_ab_conf', 'contremaitre conditionnement A-B', 4);
INSERT INTO roles (idrole, descrole, rang) VALUES ('ctr_fab_ab_conf', 'contremaitre fabrication A-B', 4);
INSERT INTO roles (idrole, descrole, rang) VALUES ('ctr_cond_bc_conf', 'Contremaitre conditionnement B-C', 4);
INSERT INTO roles (idrole, descrole, rang) VALUES ('ctr_fab_bc_conf', 'Contremaitre Fabrication B-C', 4);
INSERT INTO roles (idrole, descrole, rang) VALUES ('mag_transit_mp_conf', 'Magasin transit Matières premières confiserie', 2);
INSERT INTO roles (idrole, descrole, rang) VALUES ('mag_transit_emb_conf', 'Magasin transit Emballage', 2);
INSERT INTO roles (idrole, descrole, rang) VALUES ('sec_conf', 'Secretaire Confiserie', 1);
INSERT INTO roles (idrole, descrole, rang) VALUES ('chef_dep_conf', 'Chef de departement Atelier Confiserie', 5);
INSERT INTO roles (idrole, descrole, rang) VALUES ('mag_piece', 'Magasin Pièce de rechange', 2);
INSERT INTO roles (idrole, descrole, rang) VALUES ('dir_usine', 'Directeur d''Usine', 6);
INSERT INTO roles (idrole, descrole, rang) VALUES ('mag_pf', 'Magasin Produits Finis', 2);
INSERT INTO roles (idrole, descrole, rang) VALUES ('assist_mag_pf', 'Assistant Magasinier Produits Finis', 1);
INSERT INTO roles (idrole, descrole, rang) VALUES ('resp_rdq', 'Responsable R&D et Qualité - Essai de fabrication', 5);


UPDATE utilisateur SET idrole = 'magcentral' WHERE LOGINUSER = 'Lanto';
UPDATE utilisateur SET idrole = 'magcentral' WHERE LOGINUSER = 'Natacha';

UPDATE utilisateur SET idrole = 'magtransitmp' WHERE LOGINUSER = 'Aline';
UPDATE utilisateur SET idrole = 'magtransitmp' WHERE LOGINUSER = 'Miandrisoa';

UPDATE utilisateur SET idrole = 'magtransiteblg' WHERE LOGINUSER = 'Caroline';

UPDATE utilisateur SET idrole = 'ctrmaitre' WHERE LOGINUSER = 'Hery';
UPDATE utilisateur SET idrole = 'ctrmaitre' WHERE LOGINUSER = 'Harilanto';
UPDATE utilisateur SET idrole = 'ctrmaitre' WHERE LOGINUSER = 'Tojonirina';
UPDATE utilisateur SET idrole = 'ctrmaitre' WHERE LOGINUSER = 'Rijason';

UPDATE utilisateur SET idrole = 'mag_gaz' WHERE LOGINUSER = 'Andry';

UPDATE utilisateur SET idrole = 'cheffab' WHERE LOGINUSER = 'Malalatina';

UPDATE utilisateur SET idrole = 'sec_prod_bisc' WHERE LOGINUSER = 'Solomampionona';
UPDATE utilisateur SET idrole = 'sec_prod_bisc' WHERE LOGINUSER = 'Noeline';

UPDATE utilisateur SET idrole = 'cheffab' WHERE LOGINUSER = 'Jean';

UPDATE utilisateur SET idrole = 'assist_ctrm' WHERE LOGINUSER = 'Sambatra';

UPDATE utilisateur SET idrole = 'magcentral' WHERE LOGINUSER = 'Andry';

UPDATE utilisateur SET idrole = 'cheffab' WHERE LOGINUSER = 'Freddie';

UPDATE utilisateur SET idrole = 'ctrmaitre' WHERE LOGINUSER = 'Laurence';
UPDATE utilisateur SET idrole = 'ctrmaitre' WHERE LOGINUSER = 'Jules';
UPDATE utilisateur SET idrole = 'ctrmaitre' WHERE LOGINUSER = 'Mamy';
UPDATE utilisateur SET idrole = 'ctrmaitre' WHERE LOGINUSER = 'RijaToky';

UPDATE utilisateur SET idrole = 'magtransitmp' WHERE LOGINUSER = 'Solofotiana';

UPDATE utilisateur SET idrole = 'magtransiteblg' WHERE LOGINUSER = 'Maminirina';

UPDATE utilisateur SET idrole = 'sec_conf' WHERE LOGINUSER = 'Radonirina';
UPDATE utilisateur SET idrole = 'sec_conf' WHERE LOGINUSER = 'Lova';

UPDATE utilisateur SET idrole = 'cheffab' WHERE LOGINUSER = 'Andriamihaja';

UPDATE utilisateur SET idrole = 'mag_piece' WHERE LOGINUSER = 'Leon';

UPDATE utilisateur SET idrole = 'assist_ctrm' WHERE LOGINUSER = 'Lalaina';
UPDATE utilisateur SET idrole = 'assist_ctrm' WHERE LOGINUSER = 'Sitraka';

UPDATE utilisateur SET idrole = 'dg' WHERE LOGINUSER = 'Andriamampianina';

UPDATE utilisateur SET idrole = 'mag_pf' WHERE LOGINUSER = 'Bernadette';

UPDATE utilisateur SET idrole = 'assist_mag_pf' WHERE LOGINUSER = 'James';

UPDATE utilisateur SET idrole = 'resp_rdq' WHERE LOGINUSER = 'Famenonirina';
