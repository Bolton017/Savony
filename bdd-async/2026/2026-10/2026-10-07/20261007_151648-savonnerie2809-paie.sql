create or replace view PAIE_PERS_ELTPAIE_LIB2 as
SELECT
    ppe.id,
    pip2.matricule,
    pr.id AS id_code_rubrique,
    pr.val AS code_rubrique,
    ppe.date_debut,
    ppe.date_fin,
    ppe.gain,
    ppe.retenue,
    ppe.remarque,
    pip.nom || ' ' || pip.prenom AS idpersonnel,
    ppe.etat,
    ppe.id_objet,
    ppe.iduser,
    ppe.moisregularisation,
    ppe.anneeregularisation,

    TO_CHAR(
            TO_DATE(TO_CHAR(ppe.moisregularisation, 'FM00'), 'MM'),
            'FMMonth',
            'NLS_DATE_LANGUAGE=FRENCH'
    ) AS moisLib,

    cq.idcategorielib || ' ' || cq.categorie_qualificationlib AS idcategorie_qualification,
    pf.desce AS idfonction,
    ppe.pourcentage,

    CASE
        WHEN ppe.etat = 1 THEN 'CRÉÉ'
        WHEN ppe.etat = 11 THEN 'VALIDÉ'
        WHEN ppe.etat = 0 THEN 'ANNULÉ'
        ELSE 'INCONNU'
        END AS etatlib

FROM paie_personnel_elementpaie ppe
         LEFT JOIN log_personnel pip
                   ON TO_CHAR(pip.id) = TO_CHAR(ppe.idpersonnel)
         LEFT JOIN categorie_qualification_libc cq
                   ON TO_CHAR(ppe.idcategorie_qualification) = TO_CHAR(cq.id)
         LEFT JOIN paie_fonction pf
                   ON TO_CHAR(ppe.idfonction) = TO_CHAR(pf.id)
         LEFT JOIN paie_rubrique pr
                   ON TO_CHAR(pr.id) = TO_CHAR(ppe.code_rubrique)
         LEFT JOIN PAIE_INFO_PERSONNEL pip2 ON pip2.id = ppe.IDPERSONNEL;

INSERT INTO TYPEHORAIRE (ID, VAL, DESCE) VALUES ('TYPEHO01', 'Fixe', 'Fixe');
INSERT INTO TYPEHORAIRE (ID, VAL, DESCE) VALUES ('TYPEHO02', 'Flexible', 'Flexible');

create table TYPE_PAIE
(
    ID    VARCHAR2(50) not null
        constraint PK_TYPE_PAIE
            primary key,
    VAL   VARCHAR2(250),
    DESCE VARCHAR2(250)
);



INSERT INTO TYPE_PAIE (ID, VAL, DESCE) VALUES ('TYPEP00004', 'SAL HORAIRE', 'SAL HORAIRE');
INSERT INTO TYPE_PAIE (ID, VAL, DESCE) VALUES ('TYPEP00001', 'ELIGIBLE HS', 'ELIGIBLE HS');
INSERT INTO TYPE_PAIE (ID, VAL, DESCE) VALUES ('TYPEP00002', 'FIXE', 'FIXE');
INSERT INTO TYPE_PAIE (ID, VAL, DESCE) VALUES ('TYPEP00003', 'A LA PIÈCE', 'A LA PIÈCE');
INSERT INTO TYPE_PAIE (ID, VAL, DESCE) VALUES ('TYPEP00005', 'Sbase / Sans Hsup', 'Sbase / Sans Hsup');
INSERT INTO TYPE_PAIE (ID, VAL, DESCE) VALUES ('TYPEP00006', 'Sbase + Hsup', 'Sbase + Hsup');

create table MODALITETRAVAIL
(
    ID    VARCHAR2(255) not null
        primary key,
    VAL   VARCHAR2(255),
    DESCE VARCHAR2(255)
);

INSERT INTO MODALITETRAVAIL (ID, VAL, DESCE) VALUES ('MODTRAO01', 'Temps plein', 'Temps plein');
INSERT INTO MODALITETRAVAIL (ID, VAL, DESCE) VALUES ('MODTRAO02', 'Temps partiel', 'Temps partiel');


INSERT INTO TYPECALCUL (ID, VAL, DESCE) VALUES ('TYPCALC005', 'Par heure', 'Par heure');
INSERT INTO TYPECALCUL (ID, VAL, DESCE) VALUES ('TYPCALC001', 'Par Pièce', 'Par Pièce');
INSERT INTO TYPECALCUL (ID, VAL, DESCE) VALUES ('TYPCALC002', 'Mensuel Fixe', 'Mensuel Fixe');
INSERT INTO TYPECALCUL (ID, VAL, DESCE) VALUES ('TYPCALC003', 'Par Commission', 'Par Commission');
INSERT INTO TYPECALCUL (ID, VAL, DESCE) VALUES ('TYPCALC004', 'Par Tâche', 'Par Tâche');

INSERT INTO STATUTCANTINE (ID, VAL, DESCE) VALUES ('STCTN001', 'I - Cadre', 'I - Cadre');
INSERT INTO STATUTCANTINE (ID, VAL, DESCE) VALUES ('STCTN002', 'I - Ouvrier', 'I - Ouvrier');
INSERT INTO STATUTCANTINE (ID, VAL, DESCE) VALUES ('STCTN003', 'R - Cadre', 'R - Cadre');
INSERT INTO STATUTCANTINE (ID, VAL, DESCE) VALUES ('STCTN004', 'R - Ouvrier', 'R - Ouvrier');
INSERT INTO STATUTCANTINE (ID, VAL, DESCE) VALUES ('STCTN005', 'I/R - Cadre', 'I/R - Cadre');
INSERT INTO STATUTCANTINE (ID, VAL, DESCE) VALUES ('STCTN006', 'I/R - Ouvrier', 'I/R - Ouvrier');
INSERT INTO STATUTCANTINE (ID, VAL, DESCE) VALUES ('STCTN007', 'n/a - Cadre', 'n/a - Cadre');

