
ALTER TABLE PERIODEPAIE ADD ANNEE VARCHAR2(4);
UPDATE PERIODEPAIE SET ANNEE = '2025';

ALTER TABLE PAIE_EDITIONMOISANNEE  ADD idperiodepaie VARCHAR2(255);
ALTER TABLE PAIE_EDITION  ADD idperiodepaie VARCHAR2(255);

CREATE OR REPLACE PROCEDURE DELETEEDITIONWITHPERIODE(periode VARCHAR) AS
BEGIN
    DELETE FROM PAIE_EDITION WHERE idperiodepaie = periode;
    DELETE FROM PAIE_EDITIONMOISANNEE where idperiodepaie = periode;
END;

CREATE OR REPLACE VIEW PAIE_EDITIONMOISANNEE_LIB_3 AS 
SELECT pe.*,p.DATEDEBUT ,p.DATEFIN,cps.val AS categorie FROM PAIE_EDITIONMOISANNEE pe 
LEFT JOIN PERIODEPAIE p ON pe.idperiodepaie = p.id
LEFT JOIN CATEGORIE_PAIE_SALAIRE cps ON p.IDCATEGORIEPAIE  = cps.id


CREATE OR REPLACE VIEW PAIE_EDITIONMOISANNEE_LIB_3 AS  
SELECT pae.id,
       (log.nom || ' ') || log.prenom AS idpersonnel,
       pae.mois,
       pae.annee,
       pae.gain,
       pae.retenue,
       u.nomuser AS iduser,
       dir.val AS iddirection,
       pae.daty,
       CASE
           WHEN pae.mois = 1 THEN 'Janvier'
           WHEN pae.mois = 2 THEN 'Fevrier'
           WHEN pae.mois = 3 THEN 'Mars'
           WHEN pae.mois = 4 THEN 'Avril'
           WHEN pae.mois = 5 THEN 'Mai'
           WHEN pae.mois = 6 THEN 'Juin'
           WHEN pae.mois = 7 THEN 'Juillet'
           WHEN pae.mois = 8 THEN 'Aout'
           WHEN pae.mois = 9 THEN 'Septembre'
           WHEN pae.mois = 10 THEN 'Octobre'
           WHEN pae.mois = 11 THEN 'Novembre'
           WHEN pae.mois = 12 THEN 'Decembre'
           ELSE NULL
           END AS mois_string,
       pae.etat,
       pae.idperiodepaie,
       pp.datedebut,
       pp.datefin,
       cps.val AS categorie,
       CAST(ROUND(net.montant, 0) AS NUMBER(15, 0)) AS montant
FROM paie_editionmoisannee pae
         LEFT JOIN log_personnel log ON log.id_pers = pae.idpersonnel
         LEFT JOIN log_direction dir ON dir.id = pae.iddirection
         LEFT JOIN utilisateur u ON u.refuser = pae.iduser
         LEFT JOIN net_moisannee net ON pae.mois = net.mois AND pae.annee = net.annee
         LEFT JOIN periodepaie pp ON pp.id = pae.id
         LEFT JOIN categorie_paie_salaire cps ON cps.id = pp.idcategoriepaie
ORDER BY pae.annee DESC, pae.mois DESC;