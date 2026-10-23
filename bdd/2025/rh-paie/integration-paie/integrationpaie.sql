create or replace view PAIE_AVANCEMENT_LIBELLE4 as
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

CREATE TABLE MS_MISSION_ATTACHEMENT (
    ID            VARCHAR2(50)    PRIMARY KEY,
    IDMISSION     VARCHAR2(50)    NOT NULL,
    IDOBJET       VARCHAR2(50),
    LIEN          VARCHAR2(255),
    DESCRIPTION   VARCHAR2(500)
);
