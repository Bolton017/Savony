-- SOCOBISPROD2411.EMPLOYE_COMPLET_PDF source

CREATE OR REPLACE VIEW EMPLOYE_COMPLET_PDF AS
SELECT logp.id,
       logp.nom,
       logp.prenom,
       logp.id_pers,
       paie.initiale,
       paie.matricule,
       logp.date_naissance,
       paie.lieu_naissance_commune,
       logp.sexe,
       logp.numero_cin,
       logp.date_cin,
       logp.date_dupl_cin,
       paie.lieu_delivrance_cin,
       paie.adresse_ligne1 AS adresse,
       logp.fokotany,
       logp.nationalite,
       logp.acte_naissance,
       paie.situation_matrimonial,
       paie.idconjoint,
       logp.direction,
       logp.service,
       fonct.desce AS idfonction,
       paie.ctg,
       paie.idcategorie,
       paie.classee,
       paie.indicegrade,
       paie.indice_fonctionnel,
       paie.matricule_patron,
       paie.statut,
       paie.mode_paiement,
       paie.code_agence_banque,
       paie.banque_numero_compte,
       paie.banque_compte_cle,
       logp.permis_conduire,
       logp.remarque,
       logp.chemin_permis,
       paie.cturgence_nom_prenom,
       paie.cturgence_telephone1,
       paie.cturgence_telephone2,
       paie.cturgence_telephone3,
       paie.dateembauche,
       paie.datesaisie,
       ld.val AS code_dr,
       trs.val AS banque_code,
       paie.echelon,
       paie.etat,
       paie.vehiculee,
       tab.date_dernierpromo,
       paie.droit_hs,
       paie.heurejournalier,
       paie.heurehebdomadaire,
       paie.heuremensuel,
       paie.numero_cnaps,
       paie.numero_ostie,
       paie.temporaire,
       paie.nbenfant,
       paie.indesirable,
       cp.essaie AS duree,
       paie.telephone,
       paie.mail,
       cp.val AS idcategorie_paie,
       qp.val AS idqualification,
       paie.discipline,
       paie.formation,
       paie.anneeexperience,
       cq.montant,
       cd.resteconge AS conger,
        /* ======================= */
        /* ======================= */
        /* ======================= */
       paie.indicegrade as indice,
       mp.val as modePaiementLib,
       dp.val as departementLib,
       CASE
           WHEN paie.temporaire = 0 THEN 'TITULAIRE'
           WHEN paie.temporaire = -1 THEN 'TEMPORAIRE'
           ELSE NULL
           END AS categoriePersonel,
       smt.val as situationMLib
FROM log_personnel logp
         LEFT JOIN ( SELECT paie_avancement.id_logpers,
                            max(paie_avancement.datedecision) AS date_dernierpromo
                     FROM paie_avancement
                     GROUP BY paie_avancement.id_logpers) tab ON logp.id = tab.id_logpers
         LEFT JOIN paie_info_personnel paie ON logp.id = paie.id
         LEFT JOIN log_service serv ON serv.id = logp.service
         LEFT JOIN trs_banques_agences trs ON paie.code_agence_banque = trs.id
         LEFT JOIN paie_fonction fonct ON fonct.id = paie.idfonction
         LEFT JOIN categorie_paie cp ON cp.id = paie.idcategorie_paie
         LEFT JOIN qualification_paie qp ON qp.id = paie.idqualification
         LEFT JOIN categorie_qualification cq ON cq.idcategorie = paie.idcategorie_paie AND cq.idqualification = paie.idqualification AND cq.remarque = logp.id AND cq.etat = 1
         LEFT JOIN log_direction ld ON ld.id = logp.direction
         LEFT JOIN log_personnel_fin cd ON cd.id = logp.id
         LEFT JOIN modepaiement mp ON paie.mode_paiement = mp.id
         LEFT JOIN departement dp ON paie.iddepartement = dp.id
         LEFT JOIN SITUATION_MATRIMONIALE smt ON paie.SITUATION_MATRIMONIAL = smt.id;


/* ======================================================= */

CREATE OR REPLACE VIEW DETAILS_PAIE_EDITION_PDF AS
SELECT paie_edition.idpersonnel,
       paie_edition.idelementpaie,
       paie_edition.gain,
       paie_edition.retenue,
       CASE
           WHEN paie_edition.idelementpaie = 'PR000041' AND cq2.montant IS NOT NULL THEN cq2.montant
           WHEN paie_edition.idelementpaie = 'PR000041' AND cq2.montant IS NULL THEN cq.montant
           ELSE 0
           END AS salaire_de_base,
       CASE
           WHEN paie_edition.idelementpaie = 'PR000041' AND cq2.montant IS NOT NULL THEN cq2.montant
           WHEN paie_edition.idelementpaie = 'PR000041' AND cq2.montant IS NULL THEN cq.montant
           ELSE 0
           END / 30 AS taux,
       CASE
           WHEN paie_edition.idelementpaie = 'PR000041' THEN paie_edition.gain
           ELSE 0
           END AS juillet,
       CASE
           WHEN paie_edition.idelementpaie = 'PR000001' THEN paie_edition.gain
           ELSE 0
           END AS indemnite_de_transport,
       CASE
           WHEN paie_edition.idelementpaie = 'PR000021' THEN paie_edition.gain
           ELSE 0
           END AS indemnitedepresentationbrut,
       CASE
           WHEN paie_edition.idelementpaie = 'PR000201' THEN paie_edition.gain
           ELSE 0
           END AS avantages_en_nature,
       0 AS montant_brut,
       CASE
           WHEN paie_edition.idelementpaie = 'PR000101' THEN paie_edition.retenue
           ELSE 0
           END AS cnaps_travailleur,
       0 AS brutcnaps,
       CASE
           WHEN paie_edition.idelementpaie = 'PR000181' THEN paie_edition.gain
           ELSE 0
           END AS reductionpourpersonnesacharge,
       CASE
           WHEN paie_edition.idelementpaie = 'PR000141' THEN GREATEST(paie_edition.retenue, 3000)
           ELSE 0
           END AS irsa,
       0 AS netaprescalcul,
       CASE
           WHEN paie_edition.idelementpaie = 'PR000141NET' THEN paie_edition.retenue
           ELSE 0
           END AS irsanet,
       CASE
           WHEN paie_edition.idelementpaie = 'PR000210A' THEN paie_edition.gain
           ELSE 0
           END AS net_a_payer,
       paie_edition.mois,
       paie_edition.annee,
       paie_edition.idedition
FROM paie_edition
         JOIN paie_info_personnel pip ON pip.id = paie_edition.idpersonnel
         LEFT JOIN categorie_qualification cq ON cq.idcategorie = pip.idcategorie_paie AND cq.idqualification = pip.idqualification AND cq.remarque is NULL AND cq.etat = 1
         LEFT JOIN categorie_qualification cq2 ON cq2.idcategorie = pip.idcategorie_paie AND cq2.idqualification = pip.idqualification AND cq2.remarque = paie_edition.idpersonnel AND cq2.remarque = pip.id AND cq2.etat = 1;



CREATE OR REPLACE VIEW DETAILS_PAIE_EDITION_FINALPDF AS
SELECT d.idpersonnel AS id,
       o.cturgence_nom_prenom AS nom,
       pf.desce AS poste,
       sum(d.salaire_de_base) AS salaire_de_base,
       sum(d.taux) AS taux,
       sum(d.juillet) AS juillet,
       sum(d.indemnitedepresentationbrut) AS indemnitedepresentationbrut,
       sum(d.indemnite_de_transport) AS indemnite_de_transport,
       sum(d.avantages_en_nature) AS avantages_en_nature,
       sum(d.juillet) + sum(d.indemnitedepresentationbrut) + sum(d.indemnite_de_transport) + sum(d.avantages_en_nature) AS montant_brut,
       sum(d.cnaps_travailleur) AS cnaps,
       sum(d.juillet) + sum(d.indemnitedepresentationbrut) + sum(d.indemnite_de_transport) + sum(d.avantages_en_nature) - sum(d.cnaps_travailleur) AS brutcnaps,
       100 * trunc((sum(d.juillet) + sum(d.indemnitedepresentationbrut) + sum(d.indemnite_de_transport) + sum(d.avantages_en_nature) - sum(d.cnaps_travailleur)) / 100) AS imposable,
       sum(d.irsa) AS irsa,
       round((sum(d.juillet) + sum(d.indemnitedepresentationbrut) + sum(d.indemnite_de_transport) + sum(d.avantages_en_nature) - sum(d.cnaps_travailleur) - sum(d.irsa)), 1) AS netaprescalcul,
       sum(d.reductionpourpersonnesacharge) AS reductionpourpersonnesacharge,
       sum(d.irsanet) AS irsanet,
       sum(d.net_a_payer) AS net_a_payer,
       d.mois,
       d.annee,
       o.dateembauche,
       o.numero_cnaps,
       o.matricule,
       d.idedition,
       TO_CHAR(
               TO_DATE(TO_CHAR(d.mois, 'FM00'), 'MM'),
               'FMMonth',
               'NLS_DATE_LANGUAGE=FRENCH'
       ) AS moisLib
FROM details_paie_edition_pdf d
         LEFT JOIN paie_info_personnel_libcomplet o ON o.id = d.idpersonnel
         LEFT JOIN paie_info_personnel pip ON pip.id = d.idpersonnel
         LEFT JOIN paie_fonction pf ON pf.id = pip.idfonction
GROUP BY d.idpersonnel, o.cturgence_nom_prenom, pf.desce, d.mois, d.annee, o.dateembauche, o.numero_cnaps, o.matricule, d.idedition;


/* ==================================================== */

-- SOCOBISPROD2411.ETAT_IRSA source

CREATE OR REPLACE VIEW ETAT_IRSA AS
SELECT dp.id,
       dp.mois,
       CASE dp.mois
           WHEN 1  THEN 'Janvier'
           WHEN 2  THEN 'Février'
           WHEN 3  THEN 'Mars'
           WHEN 4  THEN 'Avril'
           WHEN 5  THEN 'Mai'
           WHEN 6  THEN 'Juin'
           WHEN 7  THEN 'Juillet'
           WHEN 8  THEN 'Août'
           WHEN 9  THEN 'Septembre'
           WHEN 10 THEN 'Octobre'
           WHEN 11 THEN 'Novembre'
           WHEN 12 THEN 'Décembre'
           ELSE 'Inconnu'
           END AS mois_lib,
       dp.annee,
       dp.matricule,
       COALESCE(dp.numero_cnaps, '') AS numero_cnaps,
       dp.nom,
       dp.poste,
       dp.salaire_de_base AS salaire_de_base,
       dp.indemnitedepresentationbrut + dp.indemnite_de_transport AS indemnite,
       dp.avantages_en_nature AS avantages_en_nature,
       dp.montant_brut AS montant_brut,
       dp.cnaps,
       dp.net_a_payer,
       dp.imposable,
       dp.irsa,
       dp.reductionpourpersonnesacharge,
       dp.irsanet
FROM details_paie_edition_finalpdf dp;