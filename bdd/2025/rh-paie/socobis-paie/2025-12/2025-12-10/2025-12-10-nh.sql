CREATE OR REPLACE VIEW HSMOIS_CPL AS
SELECT
    hs.*,
    c.val AS idCategorieLib,
    d.val AS idDepartementLib,
    CASE
        WHEN hs.etat = 1 THEN 'CREE'
        WHEN hs.etat = 11 THEN 'VISEE'
        ELSE 'INCONNU'
        END AS etatLib
FROM
    HSMOIS hs
        LEFT JOIN categorie c ON hs.idCategorie = c.id
        LEFT JOIN departement d ON hs.idDepartement = d.id;

-- ASYNCRH.PAIE_AVANCEMENT_LIBELLE4 source

CREATE OR REPLACE VIEW PAIE_AVANCEMENT_LIBELLE4 AS
SELECT pav.id,
       dt.val AS motif,
       dt.id AS idmotif,
       (lp.nom || ' ') || lp.prenom AS id_logpers,
       lpad(pip.matricule, 5, '0') AS matricule,
       pip.id AS idpers,
       pav.datedecision,
       pav.refdecision,
       pav.date_application,
       ld.val AS direction,
       ls.libelle AS service,
       pf.val AS idfonction,
       pav.ctg,
       pg.val AS idcategorie,
       pav.echelon,
       pav.classee,
       pav.indicegrade,
       pav.indice_fonctionnel,
       pav.statut,
       pav.vehiculee,
       pav.remarque,
       lp.sexe,
       pav.etat,
       pav.matricule_patron,
       pav.droit_hs,
       pav.indice_ct,
       pav.region,
       rg.val AS regionlib,
       CASE pav.vehiculee
           WHEN 0 THEN 'non'
           WHEN 1 THEN 'oui'
           ELSE NULL
           END AS vehiculee_str,
       pav.code_banque,
       pf.desce AS fonctionLib
FROM paie_avancement pav
         LEFT JOIN dec_decision_type dt ON dt.id = pav.motif
         LEFT JOIN log_personnel lp ON lp.id = pav.id_logpers
         LEFT JOIN paie_info_personnel pip ON pip.id = pav.id_logpers
         LEFT JOIN log_direction ld ON ld.id = pav.direction
         LEFT JOIN log_service ls ON ls.id = pav.service
         LEFT JOIN paie_fonction pf ON pf.id = pav.idfonction
         LEFT JOIN region rg ON rg.id = pav.region
         LEFT JOIN paie_categorie pg ON pg.id = pav.idcategorie;


---

-- ASYNCRH.PAIE_AVANCEMENT_LIBELLE3 source

CREATE OR REPLACE VIEW PAIE_AVANCEMENT_LIBELLE3 AS
SELECT pav.id,
       dt.val AS motif,
       dt.id AS idmotif,
       (lp.nom || ' ') || lp.prenom AS id_logpers,
       lpad(pip.matricule, 5, '0') AS matricule,
       pip.id AS idpers,
       pav.datedecision,
       pav.refdecision,
       pav.date_application,
       ld.val AS direction,
       ls.libelle AS service,
       pf.val AS idfonction,
       pav.ctg,
       pg.val AS idcategorie,
       pav.echelon,
       pav.classee,
       pav.indicegrade,
       pav.indice_fonctionnel,
       pav.statut,
       pav.vehiculee,
       pav.remarque,
       lp.sexe,
       pav.etat,
       pav.matricule_patron,
       pav.droit_hs,
       pav.indice_ct,
       CASE pav.vehiculee
           WHEN 0 THEN 'non'
           WHEN 1 THEN 'oui'
           ELSE NULL
           END AS vehiculee_str,
       pav.code_banque
FROM paie_avancement pav
         LEFT JOIN dec_decision_type dt ON dt.id = pav.motif
         LEFT JOIN log_personnel lp ON lp.id = pav.id_logpers
         LEFT JOIN paie_info_personnel pip ON pip.id = pav.id_logpers
         LEFT JOIN log_direction ld ON ld.id = pav.direction
         LEFT JOIN log_service ls ON ls.id = pav.service
         LEFT JOIN paie_fonction pf ON pf.id = pav.idfonction
         LEFT JOIN paie_categorie pg ON pg.id = pav.idcategorie;


---


-- ASYNCRH.PAIE_AVANCEMENT_LIBELLE5 source

CREATE OR REPLACE VIEW PAIE_AVANCEMENT_LIBELLE5 AS
SELECT pav.id,
       dt.val AS motif,
       dt.id AS idmotif,
       (lp.nom || ' ') || lp.prenom AS id_logpers,
       lpad(pip.matricule, 5, '0') AS matricule,
       pip.id AS idpers,
       pav.datedecision,
       pav.refdecision,
       pav.date_application,
       ld.val AS direction,
       ls.code_service AS service,
       pf.desce AS idfonction,
       pav.ctg,
       pg.val AS idcategorie,
       pav.echelon,
       pav.classee,
       pav.indicegrade,
       pav.indice_fonctionnel,
       CASE
           WHEN pip.temporaire = -1 THEN 'Temporaire'
           WHEN pip.temporaire = 0 THEN 'Permanent'
           WHEN pip.temporaire = 1 THEN 'Cadre'
           ELSE NULL
           END AS statut,
       pav.vehiculee,
       pav.remarque,
       lp.sexe,
       pav.etat,
       pav.matricule_patron,
       pav.droit_hs,
       pav.indice_ct,
       pav.code_banque
FROM paie_avancement pav
         LEFT JOIN dec_decision_type dt ON dt.id = pav.motif
         JOIN log_personnel lp ON lp.id = pav.id_logpers
         LEFT JOIN paie_info_personnel pip ON pip.id = pav.id_logpers
         LEFT JOIN log_direction ld ON ld.id = pav.direction
         LEFT JOIN log_service ls ON ls.id = pav.service
         LEFT JOIN paie_fonction pf ON pf.id = pav.idfonction
         LEFT JOIN paie_categorie pg ON pg.id = pav.idcategorie;


---

-- ASYNCRH.MS_MISSION_ATTACHEMENT definition

CREATE TABLE MS_MISSION_ATTACHEMENT
(	ID VARCHAR2(100) NOT NULL ENABLE,
     IDMISSION VARCHAR2(100),
     IDOBJET VARCHAR2(100),
     LIEN VARCHAR2(150),
     DESCRIPTION VARCHAR2(50),
     CONSTRAINT "MS_MISSION_ATTACHEMENT_PKEY" PRIMARY KEY ("ID")
) ;

---

INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1765387193828636', 'Avancement de fonction', 'add', 'module.jsp?but=paie/avancement/avancement-fonction.jsp', 3, 4, 'ELM0006534');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN176538722666076', 'Avancement de contrat', 'add', 'module.jsp?but=paie/avancement/avancement-contrat.jsp', 4, 4, 'ELM0006534');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1765387283877183', 'Avancement de catégorie qualification', 'add', 'module.jsp?but=paie/avancement/avancement-categorie.jsp', 5, 4, 'ELM0006534');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1765387318000411', 'Avancement de direction', 'add', 'module.jsp?but=paie/avancement/avancement-direction.jsp', 6, 4, 'ELM0006534');

-- script pour l'usermenu

DELETE FROM usermenu WHERE id = 'UM227595AA'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM5198661A'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM8311BDA4'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMCBBEAB39'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM0BAABB4F'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMBADB0E7F'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM022B168E'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM7F62812B'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM5258C62B'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMF317EDD3'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM7FF7BC22'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMB9419443'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM91E44807'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMAE60F8F6'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM9B4759F2'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMFAD30844'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM32E6D03D'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM9ECB2A57'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM478F9F12'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM1EF421D0'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM3044F77A'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM1A5C7E86'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM7A9F16D9'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM0A2A1C01'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM0D1B5C23'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMD2E04994'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMF6375A94'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM74C657AF'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM5F9BB908'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM2EAF091A'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMEDC5B631'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMB895BBC7'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMBB75F927'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM92969161'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMB53508C1'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM2FD72192'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM71BB0977'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM78AAAEED'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM0C452A38'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMFE091FFA'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM57B7817B'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMDC7AB72D'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM395DA785'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM8CF388AD'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM0651E165'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMDED9D998'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM06F0CC28'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMB7129A8F'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMEE648896'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM4D42D420'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM826226DF'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM3E5FF5CC'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM9BB79420'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMB0524704'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM54F152E6'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM71658349'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMAF3598E3'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM8C2E2084'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMFDD6427B'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM8AB72BEE'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM4A7E95A6'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM409146C9'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM23D7A91F'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMD053904C'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM1257EA64'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM5B0A30C1'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM630A833E'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMA51A499D'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM1BA8B2A4'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMC7338A0E'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM6184BCAA'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM0A28E466'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMC0827AC1'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM1D3729FE'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UME057A726'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM116FD49D'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM18C5A2D3'; -- 1 rows
