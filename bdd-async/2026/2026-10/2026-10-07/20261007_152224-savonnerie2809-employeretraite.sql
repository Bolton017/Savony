create or replace view EMPLOYE_COMPLET as
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
       logp.adresse,
       logp.fokotany,
       logp.nationalite,
       logp.acte_naissance,
       paie.situation_matrimonial,
       paie.idconjoint,
       logp.direction,
       logp.service,
       paie.idfonction,
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
       serv.code_dr,
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
       paie.duree,
       paie.telephone,
       paie.mail,
       paie.idcategorie_paie,
       paie.idqualification,
       paie.discipline,
       paie.formation,
       paie.anneeexperience,
       paie.personnel_etat,
       paie.debutcontrat,
       paie.fincontrat,
       logp.refuser,
       logp.idhierarchie AS idetathierarchie,
       et.etatvisa,
       et.etatannule,
       paie.typecontrat,
       logp.cheminImage,
       paie.code_postal,
       paie.IDDEPARTEMENT,
       logp.mere,
       logp.pere,
       civ.val as idcivilitelib,
       logp.IDCIVILITE,
       paie.idbanque,
       bnq.val as idbanquelib,
       paie.idagence,
       bnqa.codeagence,
       bnqa.nom as idagencelib,
       logp.nomdusage,
       paie.numeroSecuriteSociale,
       paie.numeroCarteSejour,
       paie.dateExpiration,
       logp.adresse2,
       logp.commune,
       paie.region,
       logp.pays,
       paie.referenceContrat,
       paie.datedebutPeriodeEssai,
       paie.dateFinPeriodeEssai,
       paie.typeEntree,
       paie.dateEntreeProfession,
       paie.dateEntreeEtablissement,
       paie.dureePeriodeDessai,
       paie.unite,
       paie.idHierarchie,
       paie.indice,
       paie.niveau,
       paie.coefficient,
       paie.dateDebutPoste,
       paie.dateFinPoste,
       paie.typeCalcul,
       paie.salaireBase,
       paie.typeHoraire,
       paie.modaliteTravail,
       logp.distance,
       paie.idSociete,
       paie.estRattacheCnaps,
       paie.estRattacheOstie,
       paie.cantine,
       paie.transport,
       paie.idSection,
       paie.idBu,
       logp.estHandicape,
       logp.natureHandicap,
       paie.IDSOUSCATEGORIE,
       CASE
           WHEN logp.estHandicape = 1 THEN 'OUI'
           ELSE 'NON'
           END AS estHandicapeLib,
       paie.idStatut,
       paie.DATE_DEPART,
       CASE
           WHEN paie.dateembauche IS NOT NULL THEN
               TRUNC(FLOOR(MONTHS_BETWEEN(CURRENT_DATE, paie.dateembauche)) / 12) || ' an(s) ' ||
               TRUNC(MOD(FLOOR(MONTHS_BETWEEN(CURRENT_DATE, paie.dateembauche)), 12)) || ' mois et ' ||
               TRUNC(CURRENT_DATE - ADD_MONTHS(paie.dateembauche, FLOOR(MONTHS_BETWEEN(CURRENT_DATE, paie.dateembauche)))) || ' jour(s)'
           ELSE NULL
           END AS anciennete
FROM log_personnel logp
         LEFT JOIN ( SELECT paie_avancement.id_logpers,
                            max(paie_avancement.datedecision) AS date_dernierpromo
                     FROM paie_avancement
                     GROUP BY paie_avancement.id_logpers) tab ON logp.id = tab.id_logpers
         LEFT JOIN paie_info_personnel paie ON logp.id = paie.id
         LEFT JOIN log_service serv ON serv.id = logp.service
         LEFT JOIN trs_banques_agences trs ON paie.code_agence_banque = trs.id
         LEFT JOIN categorie_paie cp ON cp.id = paie.idcategorie_paie
         LEFT JOIN qualification_paie qp ON qp.id = paie.idqualification
         LEFT JOIN categorie_qualification cq ON cq.idcategorie = paie.idcategorie_paie AND cq.idqualification = paie.idqualification AND cq.REMARQUE = logp.id
         LEFT JOIN etathierarchie et ON et.id = logp.idhierarchie
         LEFT JOIN civilite civ ON logp.idcivilite = civ.id
         LEFT JOIN banque bnq ON bnq.id = paie.idbanque
         LEFT JOIN BANQUE_AGENCE bnqa ON bnqa.id = paie.idagence;




create or replace view EMPLOYE_RETRAITE as
SELECT
    e."ID",e."NOM",e."PRENOM",e."ID_PERS",e."INITIALE",e."MATRICULE",e."DATE_NAISSANCE",e."LIEU_NAISSANCE_COMMUNE",e."SEXE",e."NUMERO_CIN",e."DATE_CIN",e."DATE_DUPL_CIN",e."LIEU_DELIVRANCE_CIN",e."ADRESSE",e."DIRECTION",e."FOKOTANY",e."NATIONALITE",e."ACTE_NAISSANCE",e."SITUATION_MATRIMONIAL",e."IDCONJOINT",e."SERVICE",e."IDFONCTION",e."CTG",e."IDCATEGORIE",e."CLASSEE",e."INDICEGRADE",e."INDICE_FONCTIONNEL",e."MATRICULE_PATRON",e."STATUT",e."MODE_PAIEMENT",e."CODE_AGENCE_BANQUE",e."BANQUE_NUMERO_COMPTE",e."BANQUE_COMPTE_CLE",e."PERMIS_CONDUIRE",e."REMARQUE",e."CHEMIN_PERMIS",e."CTURGENCE_NOM_PRENOM",e."CTURGENCE_TELEPHONE1",e."CTURGENCE_TELEPHONE2",e."CTURGENCE_TELEPHONE3",e."DATEEMBAUCHE",e."DATESAISIE",e."CODE_DR",e."BANQUE_CODE",e."ECHELON",e."ETAT",e."VEHICULEE",e."DATE_DERNIERPROMO",e."DROIT_HS",e."HEUREJOURNALIER",e."HEUREHEBDOMADAIRE",e."HEUREMENSUEL",e."NUMERO_CNAPS",e."NUMERO_OSTIE",e."TEMPORAIRE",e."NBENFANT",e."INDESIRABLE",e."DUREE",e."TELEPHONE",e."MAIL",e."IDCATEGORIE_PAIE",e."IDQUALIFICATION",e."DISCIPLINE",e."FORMATION",e."ANNEEEXPERIENCE",e."PERSONNEL_ETAT",e."DEBUTCONTRAT",e."FINCONTRAT",e."REFUSER",e."IDETATHIERARCHIE",e."ETATVISA",e."ETATANNULE",e."TYPECONTRAT",e."CHEMINIMAGE",e."CODE_POSTAL",e."IDDEPARTEMENT",e."MERE",e."PERE",e."IDCIVILITELIB",e."IDCIVILITE",e."IDBANQUE",e."IDBANQUELIB",e."IDAGENCE",e."CODEAGENCE",e."IDAGENCELIB",e."UNITE",e."SALAIREBASE",
    TRUNC(MONTHS_BETWEEN(SYSDATE, e.date_naissance) / 12) AS age,
    d.VAL AS DEPARTEMENTLIB,
    e.DATE_DEPART,
    e.anciennete
FROM EMPLOYE_COMPLET e
         LEFT JOIN DEPARTEMENT d ON e.IDDEPARTEMENT=d.ID
WHERE TRUNC(MONTHS_BETWEEN(SYSDATE, e.date_naissance) / 12) >= 60;

