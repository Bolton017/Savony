create or replace view LOG_PERSONNEL_FIN_CONGE as
SELECT l.id,
       l.permis_conduire,
       l.chemin_permis,
       l.remarque,
       l.id_pers,
       l.nom,
       l.prenom,
       l.date_naissance,
       sex.desce AS sexe,
       l.numero_cin,
       l.date_cin,
       l.date_dupl_cin,
       l.nationalite,
       l.adresse,
       l.fokotany,
       l.acte_naissance,
       d.val AS direction,
       s.libelle AS service,
       s.code_dr,
       TO_CHAR(paie.matricule) AS matricule,
       paie.idcategorie,
       paie.ctg,
       paie.indicegrade,
       paie.indice_fonctionnel,
       paie.statut,
       c.taux AS categorieval,
       '' AS ctgval,
       paie.numero_cnaps,
       paie.numero_ostie,
       CASE
           WHEN paie.temporaire = -1 THEN 'Temporaire'
           WHEN paie.temporaire = 0 THEN 'Permanent'
           WHEN paie.temporaire = 1 THEN 'Cadre'
           ELSE NULL
           END AS temporaire,
       CAST(NVL(sc.PLUS , 0) AS NUMBER(30, 2)) AS droit ,
       CAST(NVL(sp.CONGEPRIS , 0) AS NUMBER(30, 2)) AS prie,
       CAST(NVL(sc.SOLDE, 0) AS NUMBER(30, 2)) AS resteconge,
       paie.etat,
       l.id AS idpersonnel,
       l.direction AS iddirection,
       paie.DATEEMBAUCHE,
       paie.IDQUALIFICATION,
       paie.IDDEPARTEMENT,
       cq.val as QUALIFICATIONLIB,
       COALESCE(FLOOR(MONTHS_BETWEEN(SYSDATE, l.date_naissance) / 12), 0) AS age,
       CASE
           WHEN paie.etat < 1 THEN 'D&eacute;bauch&eacute;'
           WHEN paie.etat = 1 THEN '&Agrave; Valider'
           WHEN paie.etat = 11 THEN 'Actif'
           END AS etatLib
FROM log_personnel l
         LEFT JOIN log_service s ON l.service = s.id
         LEFT JOIN paie_info_personnel paie ON paie.id = l.id
         LEFT JOIN sexe sex ON l.sexe = sex.id
         LEFT JOIN log_direction d ON d.id = l.direction
         LEFT JOIN paie_categorie c ON c.id = paie.idcategorie
         LEFT JOIN SOLDECONGEPRIS_PERS sp ON l.id = sp.id
         LEFT JOIN SOLDECONGE_PERS sc ON l.id = sc.idPersonnel
         LEFT JOIN QUALIFICATION_PAIE cq ON cq.id = paie.IDQUALIFICATION;



create or replace view LOG_PERSONNEL_AVECCONGE as
SELECT l.id,
       l.permis_conduire,
       l.chemin_permis,
       l.remarque,
       l.id_pers,
       l.nom,
       l.prenom,
       l.date_naissance,
       sex.desce AS sexe,
       l.numero_cin,
       l.date_cin,
       l.date_dupl_cin,
       l.nationalite,
       l.adresse,
       l.fokotany,
       l.acte_naissance,
       d.val AS direction,
       s.libelle AS service,
       s.code_dr,
       TO_CHAR(paie.matricule) AS matricule,
       paie.idcategorie,
       paie.ctg,
       paie.indicegrade,
       paie.indice_fonctionnel,
       paie.statut,
       c.taux AS categorieval,
       '' AS ctgval,
       paie.numero_cnaps,
       paie.numero_ostie,
       CASE
           WHEN paie.temporaire = -1 THEN 'Temporaire'
           WHEN paie.temporaire = 0 THEN 'Permanent'
           WHEN paie.temporaire = 1 THEN 'Cadre'
           ELSE NULL
           END AS temporaire,
       CAST(NVL(sc.PLUS , 0) AS NUMBER(30, 2)) AS droit ,
       CAST(NVL(sp.CONGEPRIS , 0) AS NUMBER(30, 2)) AS prie,
       CAST(NVL(sc.SOLDE, 0) AS NUMBER(30, 2)) AS resteconge,
       paie.etat,
       l.id AS idpersonnel,
       l.direction AS iddirection,
       dp.val AS departementlib,
       paie.DATEEMBAUCHE,
       paie.IDQUALIFICATION,
       paie.IDDEPARTEMENT,
       cq.val as QUALIFICATIONLIB,
       COALESCE(FLOOR(MONTHS_BETWEEN(SYSDATE, l.date_naissance) / 12), 0) AS age,
       CASE
           WHEN paie.etat < 1 THEN 'D&eacute;bauch&eacute;'
           WHEN paie.etat = 1 THEN '&Agrave; Valider'
           WHEN paie.etat = 11 THEN 'Actif'
           END AS etatLib
FROM log_personnel l
         LEFT JOIN log_service s ON l.service = s.id
         LEFT JOIN paie_info_personnel paie ON paie.id = l.id
         LEFT JOIN sexe sex ON l.sexe = sex.id
         LEFT JOIN log_direction d ON d.id = l.direction
         LEFT JOIN paie_categorie c ON c.id = paie.idcategorie
         LEFT JOIN SOLDECONGEPRIS_PERS sp ON l.id = sp.id
         LEFT JOIN SOLDECONGE_PERS sc ON l.id = sc.idPersonnel
         LEFT JOIN departement dp ON paie.idDepartement = dp.id
         LEFT JOIN QUALIFICATION_PAIE cq ON cq.id = paie.IDQUALIFICATION;

create or replace view LOG_PERSONNEL_FIN_VALIDE as
SELECT lpf.id,
       lpf.permis_conduire,
       lpf.chemin_permis,
       lpf.remarque,
       lpf.id_pers,
       lpf.nom,
       lpf.prenom,
       lpf.date_naissance,
       lpf.sexe,
       lpf.numero_cin,
       lpf.date_cin,
       lpf.date_dupl_cin,
       lpf.nationalite,
       lpf.adresse,
       lpf.fokotany,
       lpf.acte_naissance,
       lpf.direction,
       lpf.service,
       lpf.code_dr,
       lpf.matricule,
       lpf.idcategorie,
       lpf.ctg,
       lpf.indicegrade,
       lpf.indice_fonctionnel,
       lpf.statut,
       lpf.categorieval,
       lpf.ctgval,
       lpf.numero_cnaps,
       lpf.numero_ostie,
       lpf.temporaire,
       lpf.droit,
       lpf.prie,
       lpf.resteconge,
       lpf.etat,
       lpf.DATEEMBAUCHE,
       lpf.age,
       lpf.IDQUALIFICATION,
       lpf.QUALIFICATIONLIB,
       IDDEPARTEMENT,
       etatLib
FROM LOG_PERSONNEL_FIN_CONGE lpf
WHERE lpf.etat >= 11;


create or replace view LOG_PERSONNEL_FIN_A_VALIDER as
SELECT lpf.id,
       lpf.permis_conduire,
       lpf.chemin_permis,
       lpf.remarque,
       lpf.id_pers,
       lpf.nom,
       lpf.prenom,
       lpf.date_naissance,
       lpf.sexe,
       lpf.numero_cin,
       lpf.date_cin,
       lpf.date_dupl_cin,
       lpf.nationalite,
       lpf.adresse,
       lpf.fokotany,
       lpf.acte_naissance,
       lpf.direction,
       lpf.service,
       lpf.code_dr,
       lpf.matricule,
       lpf.idcategorie,
       lpf.ctg,
       lpf.indicegrade,
       lpf.indice_fonctionnel,
       lpf.statut,
       lpf.categorieval,
       lpf.ctgval,
       lpf.numero_cnaps,
       lpf.numero_ostie,
       lpf.temporaire,
       lpf.droit,
       lpf.prie,
       lpf.resteconge,
       lpf.etat,
       lpf.DATEEMBAUCHE,
       lpf.IDDEPARTEMENT,
       lpf.etatLib,
       lpf.age,
       lpf.IDQUALIFICATION,
       lpf.QUALIFICATIONLIB
FROM LOG_PERSONNEL_FIN_CONGE lpf
WHERE lpf.etat = 1;



create or replace view LOG_PERSONNE_NON_VALIDE_VUE as
SELECT lpf.id,
       lpf.permis_conduire,
       lpf.chemin_permis,
       lpf.remarque,
       lpf.id_pers,
       lpf.nom,
       lpf.prenom,
       lpf.date_naissance,
       lpf.sexe,
       lpf.numero_cin,
       lpf.date_cin,
       lpf.date_dupl_cin,
       lpf.nationalite,
       lpf.adresse,
       lpf.fokotany,
       lpf.acte_naissance,
       lpf.direction,
       lpf.service,
       lpf.code_dr,
       lpf.matricule,
       lpf.idcategorie,
       lpf.ctg,
       lpf.indicegrade,
       lpf.indice_fonctionnel,
       lpf.statut,
       lpf.ctgval,
       lpf.numero_cnaps,
       lpf.numero_ostie,
       lpf.temporaire,
       lpf.droit,
       lpf.prie,
       lpf.resteconge,
       lpf.etat,
       lpf.DATEEMBAUCHE,
       lpf.etatLib,
       lpf.QUALIFICATIONLIB,
       lpf.IDQUALIFICATION,
       lpf.IDDEPARTEMENT
FROM LOG_PERSONNEL_FIN_CONGE lpf
WHERE lpf.etat < 1;






