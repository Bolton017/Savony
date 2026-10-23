-- auto-generated definition
create table ENTRETIENT
(
    ID             VARCHAR2(50) not null
        primary key,
    IDCANDIDATURE  VARCHAR2(50),
    IDINTERVIEWER  VARCHAR2(50),
    DATEENTRETIENT DATE,
    ETAT           NUMBER,
    SCORE          NUMBER(5, 2),
    REMARQUE       VARCHAR2(500)
);

-- auto-generated definition
create table SECTION
(
    ID    VARCHAR2(50) not null
        primary key,
    VAL   VARCHAR2(100),
    DESCE VARCHAR2(200)
);

drop table LOG_PERSONNEL cascade constraints ;


-- auto-generated definition
create table LOG_PERSONNEL
(
    ID              VARCHAR2(50) not null
        primary key,
    PERMIS_CONDUIRE VARCHAR2(255),
    CHEMIN_PERMIS   VARCHAR2(255),
    REMARQUE        VARCHAR2(255),
    ID_PERS         VARCHAR2(50),
    NOM             VARCHAR2(100),
    PRENOM          VARCHAR2(100),
    DATE_NAISSANCE  DATE,
    SEXE            CHAR,
    NUMERO_CIN      VARCHAR2(100),
    DATE_CIN        DATE,
    DATE_DUPL_CIN   DATE,
    NATIONALITE     VARCHAR2(50),
    ADRESSE         VARCHAR2(200),
    FOKOTANY        VARCHAR2(50),
    ACTE_NAISSANCE  VARCHAR2(100),
    DIRECTION       VARCHAR2(50) not null,
    SERVICE         VARCHAR2(50) not null,
    REFUSER         NUMBER,
    IDSUP           VARCHAR2(100),
    IDHIERARCHIE    VARCHAR2(100),
    CHEMINIMAGE     VARCHAR2(255),
    IDCIVILITE      VARCHAR2(255)
        constraint FK_LOG_PERSONNEL_CIVILITE
            references CIVILITE,
    MERE            VARCHAR2(255),
    PERE            VARCHAR2(255),
    TELEPHONE       NUMBER(10),
    NOMDUSAGE       VARCHAR2(255),
    ADRESSE2        VARCHAR2(255),
    COMMUNE         VARCHAR2(255),
    PAYS            VARCHAR2(255),
    DISTANCE        NUMBER(30, 2),
    ESTHANDICAPE    NUMBER(1) default 0,
    NATUREHANDICAP  VARCHAR2(255),
    IMAGE           VARCHAR2(250)
);



drop table PAIE_INFO_PERSONNEL cascade constraints ;

-- auto-generated definition
create table PAIE_INFO_PERSONNEL
(
    ID                      VARCHAR2(50) not null
        constraint PAIE_INFO_PERSONNEL_PK
            primary key,
    DATESAISIE              DATE,
    MATRICULE               VARCHAR2(50),
    LIEU_NAISSANCE_COMMUNE  VARCHAR2(50),
    LIEU_DELIVRANCE_CIN     VARCHAR2(50),
    SITUATION_MATRIMONIAL   VARCHAR2(50),
    INITIALE                VARCHAR2(50),
    CTURGENCE_NOM_PRENOM    VARCHAR2(255),
    CTURGENCE_TELEPHONE1    VARCHAR2(50),
    CTURGENCE_TELEPHONE2    VARCHAR2(50),
    CTURGENCE_TELEPHONE3    VARCHAR2(50),
    IDCONJOINT              VARCHAR2(50),
    CODE_AGENCE_BANQUE      VARCHAR2(50),
    BANQUE_NUMERO_COMPTE    VARCHAR2(50),
    BANQUE_COMPTE_CLE       VARCHAR2(50),
    DATEEMBAUCHE            DATE,
    IDFONCTION              VARCHAR2(50),
    IDCATEGORIE             VARCHAR2(50),
    MODE_PAIEMENT           VARCHAR2(50),
    CLASSEE                 VARCHAR2(50),
    INDICEGRADE             NUMBER,
    INDICE_FONCTIONNEL      NUMBER,
    MATRICULE_PATRON        VARCHAR2(50),
    STATUT                  VARCHAR2(50),
    DROIT_HS                VARCHAR2(1),
    VEHICULEE               NUMBER default 0,
    ECHELON                 NUMBER,
    ETAT                    NUMBER,
    CTG                     VARCHAR2(50),
    IDUSER                  VARCHAR2(50),
    INDICE_CT               NUMBER,
    DATEPROMOTION           DATE,
    NUMERO_CNAPS            VARCHAR2(50),
    NUMERO_OSTIE            VARCHAR2(50),
    TEMPORAIRE              NUMBER,
    N_EMBAUCHE              VARCHAR2(50),
    DATE_DEPART             DATE,
    N_DEPART                VARCHAR2(50),
    NBENFANT                NUMBER,
    HEUREJOURNALIER         NUMBER(30, 2),
    HEUREHEBDOMADAIRE       NUMBER(30, 2),
    HEUREMENSUEL            NUMBER(30, 2),
    INDESIRABLE             NUMBER,
    DUREE                   NUMBER(30, 2),
    TELEPHONE               VARCHAR2(100),
    MAIL                    VARCHAR2(500),
    ADRESSE_LIGNE1          VARCHAR2(100),
    ADRESSE_LIGNE2          VARCHAR2(100),
    CODE_POSTAL             VARCHAR2(100),
    REGION                  VARCHAR2(100),
    IDCATEGORIE_PAIE        VARCHAR2(500)
        constraint CATEGORIE_PAIE_FK
            references CATEGORIE_PAIE,
    IDQUALIFICATION         VARCHAR2(500)
        constraint QUALIFICATION_PAIE_FK
            references QUALIFICATION_PAIE,
    FORMATION               VARCHAR2(1000),
    DISCIPLINE              VARCHAR2(1000),
    ANNEEEXPERIENCE         VARCHAR2(1000),
    PERSONNEL_ETAT          NUMBER,
    PERIODE_ESSAI           NUMBER,
    DEBUTCONTRAT            DATE,
    FINCONTRAT              DATE,
    REFUSER                 NUMBER,
    TYPECONTRAT             VARCHAR2(100),
    IDDEPARTEMENT           VARCHAR2(255),
    IDBANQUE                VARCHAR2(255)
        constraint FK_PAIEINFO_BANQUE
            references BANQUE,
    IDAGENCE                VARCHAR2(255)
        constraint FK_PAIEINFO_AGENCE
            references BANQUE_AGENCE,
    NUMEROSECURITESOCIALE   VARCHAR2(255),
    NUMEROCARTESEJOUR       VARCHAR2(255),
    DATEEXPIRATION          DATE,
    PAYS                    VARCHAR2(255),
    REFERENCECONTRAT        VARCHAR2(255),
    DATEDEBUTPERIODEESSAI   DATE,
    DATEFINPERIODEESSAI     DATE,
    TYPEENTREE              VARCHAR2(255),
    DATEENTREEPROFESSION    DATE,
    DATEENTREEETABLISSEMENT DATE,
    DUREEPERIODEDESSAI      NUMBER(38),
    UNITE                   VARCHAR2(255),
    IDHIERARCHIE            VARCHAR2(255),
    INDICE                  NUMBER(38),
    NIVEAU                  VARCHAR2(255),
    COEFFICIENT             NUMBER(38),
    DATEDEBUTPOSTE          DATE,
    DATEFINPOSTE            DATE,
    TYPECALCUL              VARCHAR2(255),
    SALAIREBASE             NUMBER(38),
    TYPEHORAIRE             VARCHAR2(255),
    MODALITETRAVAIL         VARCHAR2(255),
    IDSOCIETE               VARCHAR2(255),
    ESTRATTACHECNAPS        NUMBER,
    ESTRATTACHEOSTIE        NUMBER,
    TRANSPORT               NUMBER,
    IDSECTION               VARCHAR2(50)
        constraint FK_PERS_SECTION
            references SECTION,
    TYPEPAIE                VARCHAR2(255),
    IDSOUSCATEGORIE         VARCHAR2(255),
    IDBU                    VARCHAR2(255),
    CANTINE                 VARCHAR2(100),
    IDSTATUT                VARCHAR2(100),
    CODE_BANQUE             VARCHAR2(255)
);

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
       paie.idStatut
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

-- auto-generated definition
create table VILLE
(
    ID         VARCHAR2(50) not null
        primary key,
    NOM        VARCHAR2(100),
    CODEPOSTAL VARCHAR2(20),
    IDPAYS     VARCHAR2(50)
        constraint FK_VILLE_PAYS
            references PAYS
);

create view VILLELIB as
select ville."ID",ville."NOM",ville."CODEPOSTAL",ville."IDPAYS", PAYS.VAL as idPaysLib
from ville
         left join PAYS on PAYS.id = ville.idPays;

-- auto-generated definition
create table SOCIETE
(
    ID    VARCHAR2(255) not null
        primary key,
    VAL   VARCHAR2(255),
    DESCE VARCHAR2(255)
);
-- auto-generated definition
create table BUSINESS_UNITE
(
    ID        VARCHAR2(255) not null
        primary key,
    VAL       VARCHAR2(255),
    DESCE     VARCHAR2(255),
    IDSOCIETE VARCHAR2(50)
        constraint FK_BU_SOCIETE
            references SOCIETE
);

-- auto-generated definition
create table IMPORTDONNEESPOINTEUSE
(
    MATRIC    VARCHAR2(20),
    PERIOD    VARCHAR2(7),
    TOTAL1    NUMBER(10, 3),
    TOTAL2    NUMBER(10, 3),
    TOTAL3    NUMBER(10, 3),
    TOTAL4    NUMBER(10, 3),
    TOTAL5    NUMBER(10, 3),
    TOTAL6    NUMBER(10, 3),
    ABSPAID1  NUMBER(10, 3),
    ABSPAID2  NUMBER(10, 3),
    ABSPAID3  NUMBER(10, 3),
    ABSPAID4  NUMBER(10, 3),
    ABSPAID5  NUMBER(10, 3),
    ABSPAID6  NUMBER(10, 3),
    NUIT1     NUMBER(10, 3),
    NUIT2     NUMBER(10, 3),
    NUIT3     NUMBER(10, 3),
    NUIT4     NUMBER(10, 3),
    NUIT5     NUMBER(10, 3),
    NUIT6     NUMBER(10, 3),
    HM40      NUMBER(10, 3),
    HM50      NUMBER(10, 3),
    HM100     NUMBER(10, 3),
    HABSP     NUMBER(10, 3),
    HABS      NUMBER(10, 3),
    HNUIT     NUMBER(10, 3),
    HN        NUMBER(10, 3),
    HS30      NUMBER(10, 3),
    HS50      NUMBER(10, 3),
    POSTED    NUMBER(10, 3),
    BATCH_ID  VARCHAR2(50),
    LASTUPDBY VARCHAR2(50),
    LASTUPD   DATE,
    WDAY      NUMBER(10, 3),
    NOTLATE   NUMBER(10, 3),
    BASKET1   NUMBER(10, 3),
    BASKET2   NUMBER(10, 3),
    PERSTD    NUMBER(10, 3),
    CONGE0    NUMBER(10, 3),
    CONGE1    NUMBER(10, 3),
    CONGE2    NUMBER(10, 3),
    CONGE3    NUMBER(10, 3),
    CONGE4    NUMBER(10, 3),
    CONGE5    NUMBER(10, 3),
    CONGE6    NUMBER(10, 3),
    JCONGE    NUMBER(10, 3),
    CREATEDON DATE,
    WNIT      NUMBER(10, 3),
    WSUN      NUMBER(10, 3),
    WSAT      NUMBER(10, 3),
    LATE      NUMBER(10, 3),
    STD1      NUMBER(10, 3),
    STD2      NUMBER(10, 3),
    STD3      NUMBER(10, 3),
    STD4      NUMBER(10, 3),
    STD5      NUMBER(10, 3),
    STD6      NUMBER(10, 3),
    HN1       NUMBER(10, 3),
    HN2       NUMBER(10, 3),
    HN3       NUMBER(10, 3),
    HN4       NUMBER(10, 3),
    HN5       NUMBER(10, 3),
    HN6       NUMBER(10, 3),
    HS30_1    NUMBER(10, 3),
    HS30_2    NUMBER(10, 3),
    HS30_3    NUMBER(10, 3),
    HS30_4    NUMBER(10, 3),
    HS30_5    NUMBER(10, 3),
    HS30_6    NUMBER(10, 3),
    HS50_1    NUMBER(10, 3),
    HS50_2    NUMBER(10, 3),
    HS50_3    NUMBER(10, 3),
    HS50_4    NUMBER(10, 3),
    HS50_5    NUMBER(10, 3),
    HS50_6    NUMBER(10, 3),
    NWDAY     NUMBER(10, 3),
    ID        VARCHAR2(50),
    DATY      DATE,
    ETAT      NUMBER
);

-- auto-generated definition
create table LOG_UNITE
(
    ID    VARCHAR2(50) not null
        constraint PK_LOG_UNITE
            primary key,
    VAL   VARCHAR2(250),
    DESCE VARCHAR2(250)
);

create view VUE_TOTAUX_HEURES as
SELECT

    imp.id,

    pip.id AS idPaiePersonnel,

    imp.MATRIC,

    imp.Period,

    SUBSTR(imp.Period,1,4) AS annee,

    TO_NUMBER(SUBSTR(imp.Period,6,2)) AS mois,

    CAST(SUM(total1 + total2 + total3 + total4 + total5 + total6) AS NUMBER(30,3)) AS total_heures_travaillees,

    CAST(SUM(HS30_1 + HS30_2 + HS30_3 + HS30_4 + HS30_5 + HS30_6) AS NUMBER(30,3)) AS total_hs_30,

    CAST(SUM(HS50_1 + HS50_2 + HS50_3 + HS50_4 + HS50_5 + HS50_6) AS NUMBER(30,3)) AS total_hs_50,

    CAST(SUM(Hm40 + Hm50 + Hm100) AS NUMBER(30,3)) AS total_hs_taux,

    CAST(SUM(Nuit1 + Nuit2 + Nuit3 + Nuit4 + Nuit5 + Nuit6) AS NUMBER(30,3)) AS total_heures_nuit,

    CAST(SUM(Abspaid1 + Abspaid2 + Abspaid3 + Abspaid4 + Abspaid5 + Abspaid6) AS NUMBER(30,3)) AS total_absence_paye,

    CAST(SUM(HN1 + HN2 + HN3 + HN4 + HN5 + HN6) AS NUMBER(30,3)) AS total_heure_normale,

    CAST(SUM(Late) AS NUMBER(30,3)) AS total_retards,

    CAST(SUM(NotLate) AS NUMBER(30,3)) AS total_jours_sans_retard,

    CAST(SUM(Hm40) AS NUMBER(30,3)) AS total_hm40,

    CAST(SUM(Hm50) AS NUMBER(30,3)) AS total_hm50,

    CAST(SUM(Hm100) AS NUMBER(30,3)) AS total_hm100,

    log.nom || ' ' || log.prenom AS nomPersonnel,

    pip.idBu AS bu,

    bu.val AS buLib,

    lu.val AS uniteLib,

    ls.libelle AS idSectionLib,

    ld.val AS directionLib,

    TO_CHAR(

            TO_DATE(TO_CHAR(TO_NUMBER(SUBSTR(imp.Period,6,2)), 'FM00'), 'MM'),

            'FMMonth',

            'NLS_DATE_LANGUAGE=FRENCH'

    ) AS moisLib,

    TO_CHAR(

            TO_DATE(TO_CHAR(TO_NUMBER(SUBSTR(imp.Period,6,2)), 'FM00'), 'MM'),

            'FMMonth',

            'NLS_DATE_LANGUAGE=FRENCH'

    ) || ' ' || SUBSTR(imp.Period,1,4) AS moisanneelib,

    imp.WDAY AS workDay,

    CAST(SUM(CONGE0 + CONGE1 + CONGE2 + CONGE3 + CONGE4 + CONGE5 + CONGE6) AS NUMBER(30,3)) AS totalConge,

    imp.HABS AS heureAbsence,

    CAST(SUM(

                 GREATEST(0, total1 - 60)

                     + GREATEST(0, total2 - 60)

                     + GREATEST(0, total3 - 60)

                     + GREATEST(0, total4 - 60)

                     + GREATEST(0, total5 - 60)

                     + GREATEST(0, total6 - 60)

         ) AS NUMBER(30,3)) AS over60,

    imp.hm40,

    imp.hm50,

    imp.etat ,

    CASE

        WHEN imp.etat = 1

            THEN 'CRÉE'

        WHEN imp.etat = 11

            THEN 'VALIDÉE'

        WHEN imp.etat = 0

            THEN 'ANNULÉE'

        END AS ETATLIB

FROM IMPORTDONNEESPOINTEUSE imp

         LEFT JOIN PAIE_INFO_PERSONNEL pip ON pip.MATRICULE = imp.MATRIC

         LEFT JOIN LOG_PERSONNEL log ON log.id = pip.ID

         LEFT JOIN BUSINESS_UNITE bu ON bu.id = pip.idBu

         LEFT JOIN LOG_UNITE lu ON lu.id = pip.unite

         LEFT JOIN log_direction ld ON ld.id = log.direction

         LEFT JOIN log_service ls ON ls.id = pip.idSection

GROUP BY

    imp.id,

    pip.id,

    imp.MATRIC,

    imp.Period,

    SUBSTR(imp.Period,1,4),

    TO_NUMBER(SUBSTR(imp.Period,6,2)),

    log.nom,

    log.prenom,

    pip.idBu,

    bu.val,

    lu.val,

    ls.libelle,

    ld.val,

    imp.WDAY,

    imp.HABS,

    imp.hm40,

    imp.hm50,

    imp.etat ,

    TO_CHAR(

            TO_DATE(TO_CHAR(TO_NUMBER(SUBSTR(imp.Period,6,2)), 'FM00'), 'MM'),

            'FMMonth',

            'NLS_DATE_LANGUAGE=FRENCH'

    ),

    TO_CHAR(

            TO_DATE(TO_CHAR(TO_NUMBER(SUBSTR(imp.Period,6,2)), 'FM00'), 'MM'),

            'FMMonth',

            'NLS_DATE_LANGUAGE=FRENCH'

    ) || ' ' || SUBSTR(imp.Period,1,4);

-- auto-generated definition
create table CODEBARRE
(
    ID       VARCHAR2(50) not null
        primary key,
    IDING    VARCHAR2(100),
    FILEPATH VARCHAR2(255)
);

drop table PAIE_FONCTION cascade constraints ;

-- auto-generated definition
create table METIER
(
    ID         VARCHAR2(250) not null
        primary key,
    VAL        VARCHAR2(255),
    DESCE      VARCHAR2(500),
    IDCODEROME VARCHAR2(255),
    IDFONCTION VARCHAR2(255)
);

-- auto-generated definition
create table EMPLOI
(
    ID       VARCHAR2(50) not null
        primary key,
    VAL      VARCHAR2(255),
    DESCE    VARCHAR2(255),
    IDMETIER VARCHAR2(50)
        references METIER
);

-- auto-generated definition
create table PAIE_FONCTION
(
    ID               VARCHAR2(50) not null
        constraint PAIE_FONCTION_PKEY
            primary key,
    VAL              VARCHAR2(50),
    DESCE            VARCHAR2(255),
    IDGROUPEFONCTION VARCHAR2(50),
    GRATIFICATION    VARCHAR2(5),
    IDEMPLOIE        VARCHAR2(50)
        constraint FK_PAIE_FONCTION_EMPLOI
            references EMPLOI,
    IDCONFIG         VARCHAR2(100)
);

drop table PAIE_PERSONNEL_ELEMENTPAIE cascade constraints ;

-- auto-generated definition
create table PAIE_PERSONNEL_ELEMENTPAIE
(
    ID                        VARCHAR2(100)    not null
        constraint PAIE_PERS_ELPAIE_PKEY
            primary key,
    CODE_RUBRIQUE             VARCHAR2(100)    not null,
    DATE_DEBUT                DATE,
    DATE_FIN                  DATE,
    GAIN                      NUMBER(30, 2),
    RETENUE                   NUMBER(30, 2),
    REMARQUE                  VARCHAR2(255),
    IDPERSONNEL               VARCHAR2(100),
    ETAT                      NUMBER default 1 not null,
    ID_OBJET                  VARCHAR2(100),
    IDUSER                    VARCHAR2(100),
    MOISREGULARISATION        VARCHAR2(10),
    ANNEEREGULARISATION       VARCHAR2(10),
    IDCATEGORIE_QUALIFICATION VARCHAR2(100)
        constraint PAIE_CATEGORIE_FK
            references CATEGORIE_QUALIFICATION,
    IDFONCTION                VARCHAR2(100)
        constraint PAIE_PERSONNEL_FONCTION_FK
            references PAIE_FONCTION,
    POURCENTAGE               NUMBER(30, 2),
    QUANTITE                  NUMBER(30, 2),
    UNITE                     VARCHAR2(200),
    MODECALCUL                NUMBER,
    BASE                      NUMBER(30, 2),
    TAUX                      NUMBER(30, 2)
);

create or replace view PAIE_INFO_PERSONNELDIRECT as
SELECT p.id,
       l.nationalite,
       p.datesaisie,
       p.matricule,
       p.lieu_naissance_commune,
       p.lieu_delivrance_cin,
       p.situation_matrimonial,
       p.initiale,
       p.cturgence_nom_prenom,
       p.cturgence_telephone1,
       p.cturgence_telephone2,
       p.cturgence_telephone3,
       p.idconjoint,
       p.code_agence_banque,
       p.banque_numero_compte,
       p.banque_compte_cle,
       p.dateembauche,
       p.idfonction,
       p.idcategorie,
       p.mode_paiement,
       p.classee,
       p.indicegrade,
       p.indice_fonctionnel,
       p.matricule_patron,
       p.statut,
       p.droit_hs,
       p.vehiculee,
       p.echelon,
       p.etat,
       p.ctg,
       p.iduser,
       p.indice_ct,
       p.datepromotion,
       p.numero_cnaps,
       p.numero_ostie,
       p.temporaire,
       p.n_embauche,
       p.date_depart,
       p.n_depart,
       p.nbenfant,
       p.heurejournalier,
       p.heurehebdomadaire,
       p.heuremensuel,
       l.direction,
       l.service,
       p.periode_essai,
       l.sexe,
       l.date_naissance,
       p.idcategorie_paie,
       p.idqualification,
       p.unite,
       p.typeCalcul,
       CAST(COALESCE(pips.montant, 0) AS NUMBER(30,2)) AS salaire_base,
       p.idBu,
       p.IDSOCIETE,
       TRUNC(MONTHS_BETWEEN(SYSDATE, p.DATEEMBAUCHE) / 12) AS anciennete,
       p.CANTINE,
       p.IDSOUSCATEGORIE as sous_categorie_paie
FROM paie_info_personnel p,
     log_personnel l,
     paie_info_personnel_sb pips
WHERE l.id = p.id AND p.id = pips.id;

create or replace view PAIEINFOPERSELTPAIECOMPLET2 as
SELECT elt.id,
       elt.code_rubrique,
       elt.date_debut,
       elt.date_fin,
       elt.moisregularisation,
       elt.anneeregularisation,
       elt.gain,
       elt.retenue,
       elt.quantite,
       elt.unite,
       r.isinfini AS remarque,
       elt.idpersonnel,
       r.val,
       r.desce,
       r.rang,
       r.comptepcg,
       r.code,
       r.typerubrique,
       r.bcs,
       r.bg,
       r.imposable,
       r.nature,
       r.avantage,
       r.cpt_gen_db,
       r.cpt_gen_cr,
       r.cpt_ana_db,
       r.cpt_ana_cr,
       0 AS israppel,
       1 AS isconfeltfixe,
       EXTRACT(MONTH FROM elt.date_debut) AS mois,
       EXTRACT(YEAR FROM elt.date_debut) AS annee,
       info.datesaisie,
       info.matricule,
       info.lieu_naissance_commune,
       info.lieu_delivrance_cin,
       info.situation_matrimonial,
       info.initiale,
       info.cturgence_nom_prenom,
       info.cturgence_telephone1,
       info.cturgence_telephone2,
       info.cturgence_telephone3,
       info.idconjoint,
       info.code_agence_banque,
       info.banque_numero_compte,
       info.banque_compte_cle,
       info.dateembauche,
       info.idfonction,
       fonc.idgroupefonction,
       info.idcategorie,
       info.mode_paiement,
       info.classee,
       info.indicegrade,
       info.indice_fonctionnel,
       info.matricule_patron,
       info.statut,
       info.droit_hs,
       elt.etat AS etat_element,
       info.nationalite,
       info.service,
       info.direction,
       invalid.dateapplication,
       invalid.datefin AS datefininvalid,
       invalid.date_decision,
       invalid.idtypedebauche,
       info.nbenfant,
       elt.id_objet,
       info.etat,
       info.temporaire,
       info.periode_essai,
       c.valmin AS pointindice,
       elt.remarque AS remarque_element,
       formu.id AS formu,
       r.regroupement,
       r.arrondi,
       r.inserted,
       r.sommable,
       r.beneficiaire,
       r.remarque AS remarqueformule,
       r.uniteformule,
       r.qteformule,
       info.idcategorie_paie,
       info.idqualification,
       info.IDSOCIETE,
       info.IDBU,
       elt.BASE,
       elt.TAUX
FROM paie_personnel_elementpaie elt
         JOIN paie_rubrique r ON elt.code_rubrique = r.id
         LEFT JOIN paie_info_personneldirect info ON elt.idpersonnel = info.id
         LEFT JOIN paie_fonction fonc ON info.idfonction = fonc.id AND info.id <> '1002067'
         LEFT JOIN dernier_debauche_by_employe invalid ON invalid.idlogpers = info.id
         LEFT JOIN configuration c ON c.id = 'CONF000250'
         LEFT JOIN detformu formu ON elt.id = formu.mere;

create table TYPECALCUL
(
    ID    VARCHAR2(250) not null
        primary key,
    VAL   VARCHAR2(500),
    DESCE VARCHAR2(2000)
);

create table TYPEHORAIRE
(
    ID    VARCHAR2(255) not null
        primary key,
    VAL   VARCHAR2(255),
    DESCE VARCHAR2(255)
);

create table MODALITETRAVAIL
(
    ID    VARCHAR2(255) not null
        primary key,
    VAL   VARCHAR2(255),
    DESCE VARCHAR2(255)
);

create table STATUTCANTINE
(
    ID    VARCHAR2(100) not null
        constraint STATUTCANTINE_PK
            primary key,
    VAL   VARCHAR2(255),
    DESCE VARCHAR2(255)
);

create view SUM_HS_DAY as
SELECT
    dateFabrication AS jour,
    SUM(HS) AS avg_hs_per_day,
    IDDEPARTEMENT,
    departementLib
FROM HEURESUPFABRICATION_CPL
GROUP BY dateFabrication, IDDEPARTEMENT, departementLib
ORDER BY dateFabrication;

create or replace view VIEW_VIDE_SOMME as
SELECT
    CAST(NULL AS VARCHAR2(50)) AS id,
    CAST(NULL AS VARCHAR2(50)) AS idDepartement,
    CAST(NULL AS VARCHAR2(50)) AS idTypeSomme
FROM dual
WHERE 1 = 0;

create view EFFECTIF_LOG_PERSONNEL as
SELECT
    sexe,
    COUNT(*) AS nombre,
    idCategorie,
    idCategorieLib,
    idDepartement,
    departementLib
FROM (
         SELECT
             CASE
                 WHEN sexe = 'Masculin' THEN 'Masculin'
                 WHEN sexe = 'Feminin' THEN 'Feminin'
                 ELSE 'Non défini'
                 END AS sexe,
             idCategorie,
             idCategorieLib,
             IDDEPARTEMENT AS idDepartement,
             departementLib
         FROM LOG_PERSONNEL_GRAPHE
     )
GROUP BY
    sexe,
    idCategorie,
    idCategorieLib,
    idDepartement,
    departementLib;