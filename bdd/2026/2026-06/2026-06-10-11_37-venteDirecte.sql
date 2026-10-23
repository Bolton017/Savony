ALTER TABLE VENTE ADD (
    IDMODEPAIEMENT VARCHAR2(255),
    IDRESPONSABLE  VARCHAR2(255),
    REMISE         NUMBER(10,2),
    REMISEMONTANT  NUMBER(10,2),
    HEURESAISIE    VARCHAR2(8),
    IDCOMMERCIAL   VARCHAR2(255)
    );

create view INSERTION_VENTE_PERSONNEL as
SELECT v.ID,
       v.DESIGNATION,
       v.IDMAGASIN,
       v.DATY,
       v.REMARQUE,
       v.ETAT,
       v.IDORIGINE,
       v.IDCLIENT,
       CAST(' ' AS varchar(100)) AS iddevise,
       v.ESTPREVU,
       v.DATYPREVU,
       v.IDRESERVATION,
       v.idCommercial,
       v.idmodepaiement,
       v.remise,
       v.remiseMontant,
       v.HEURESAISIE,
       v.IDRESPONSABLE
FROM VENTE v;

create view INSERTION_VENTE_PERSONNEL_VIDE as
SELECT id,daty,designation,idmagasin,remarque,etat,idorigine,idclient,iddevise,estprevu,datyprevu,idreservation,idcommercial,idmodepaiement,remise,remisemontant,HEURESAISIE, IDRESPONSABLE FROM INSERTION_VENTE_PERSONNEL;

alter table VENTE_DETAILS add (
    PHOTO         VARCHAR2(255),
    REFERENCE     VARCHAR2(100),
    MONTANT       NUMBER
    );

create or replace view VENTE_DETAILS_SAISIE as
SELECT
    id,
    IDVENTE ,
    IDPRODUIT ,
    DESIGNATION ,
    IDORIGINE ,
    qte,
    pu,
    REMISE ,
    TVA ,
    PUACHAT ,
    PUVENTE ,
    IDDEVISE ,
    TAUXDECHANGE ,
    compte,
    vd.idbcfille,
    photo,
    reference,
    montant,
    unite,
    ristourne
FROM VENTE_DETAILS vd;

-- auto-generated definition
create table TAILLE
(
    ID                    VARCHAR2(255) not null
        constraint TAILLE_PK
            primary key,
    VAL                   VARCHAR2(200),
    DESCE                 VARCHAR2(200),
    IDCATEGORIEINGREDIENT VARCHAR2(200),
    TAILLENOMBRE          NUMBER(38)
);

create table COULEUR
(
    ID    VARCHAR2(50) not null
        constraint PK_COULEUR
            primary key,
    VAL   VARCHAR2(250),
    DESCE VARCHAR2(250),
    CODE  VARCHAR2(250)
);

alter table SAVONNERIEFINAL0519.AS_INGREDIENTS add(
    PVGROS              NUMBER,
    COULEUR             VARCHAR2(100),
    TAILLE              VARCHAR2(100),
    CODEBARRE           VARCHAR2(100),
    REFERENCE           VARCHAR2(100),
    CODEGROS            NUMBER,
    POINTURE            VARCHAR2(100),
    IDCOULEUR           VARCHAR2(100)
    );

create or replace view ST_INGREDIENTSVENTEPOS as
SELECT
    ai.ID,
    ai.LIBELLE || ' - ' || c.val || ' - ' ||
    CASE
        WHEN ai.POINTURE IS NOT NULL AND ai.POINTURE <> 0
            THEN CAST(ai.POINTURE AS VARCHAR2(255))
        WHEN ai.TAILLE IS NOT NULL
            THEN tl.val
        ELSE ''
        END AS libelle,
    ai.SEUIL,
    ai.UNITE,
    ai.QUANTITEPARPACK,
    ai.PU,
    ai.ACTIF,
    ai.PHOTO,
    ai.CALORIE,
    ai.DURRE,
    ai.COMPOSE,
    ai.CATEGORIEINGREDIENT,
    ai.IDFOURNISSEUR,
    ai.DATY,
    ai.QTELIMITE,
    ai.PV,
    ai.LIBELLEVENTE,
    ai.SEUILMIN,
    ai.SEUILMAX,
    ai.PUACHATUSD,
    ai.PUACHATEURO,
    ai.PUACHATAUTREDEVISE,
    ai.PUVENTEUSD,
    ai.PUVENTEEURO,
    ai.PUVENTEAUTREDEVISE,
    ai.ISVENTE,
    ai.ISACHAT,
    ai.COMPTE_VENTE,
    ai.COMPTE_ACHAT,
    ai.TVA,
    1 AS taux,
    ai.COMPTE_VENTE AS compte,
    ai.LIBELLE|| ' '||ai.COULEUR|| ' '||ai.TAILLE||'  '||
    LISTAGG(
            cps.LIBELLE || ' - ' || c.val ||
            CASE
                WHEN cps.POINTURE IS NOT NULL AND cps.POINTURE <> 0 THEN CAST(cps.POINTURE AS VARCHAR2(255))
                WHEN cps.TAILLE IS NOT NULL THEN tl.val
                ELSE ''
                END
    ) WITHIN GROUP (ORDER BY cps.LIBELLE) AS libellecomposant,
    ai.TAILLE,
    ai.codebarre,
    ai.REFERENCE,
    ai.codegros,
    ai.pvgros,
    u.VAL AS UNITELIB,
    CONCAT(concat(ai.libelle,' - '),u.val) AS designation,
    CASE
        WHEN ai.POINTURE IS NOT NULL AND ai.pointure <> 0 THEN CAST(ai.pointure AS VARCHAR2(255))
        WHEN ai.taille   IS NOT NULL THEN tl.val
        END AS tailleLib,
    c.val as couleur
FROM
    AS_INGREDIENTS ai
        LEFT JOIN AS_RECETTE ar ON ar.IDPRODUITS = ai.ID
        LEFT JOIN AS_INGREDIENTS cps ON cps.ID  = ar.IDINGREDIENTS
        LEFT JOIN AS_UNITE u ON ai.unite=u.id
        LEFT JOIN TAILLE tl ON tl.id = ai.TAILLE
        LEFT JOIN COULEUR c ON c.id = ai.IDCOULEUR
where AI.PV != 0 AND ai.ACTIF = 1
GROUP BY
    ai.ID,
    ai.LIBELLE,
    ai.SEUIL,
    ai.UNITE,
    ai.QUANTITEPARPACK,
    ai.PU,
    ai.ACTIF,
    ai.PHOTO,
    ai.CALORIE,
    ai.DURRE,
    ai.COMPOSE,
    ai.CATEGORIEINGREDIENT,
    ai.IDFOURNISSEUR,
    ai.DATY,
    ai.QTELIMITE,
    ai.PV,
    ai.LIBELLEVENTE,
    ai.SEUILMIN,
    ai.SEUILMAX,
    ai.PUACHATUSD,
    ai.PUACHATEURO,
    ai.PUACHATAUTREDEVISE,
    ai.PUVENTEUSD,
    ai.PUVENTEEURO,
    ai.PUVENTEAUTREDEVISE,
    ai.ISVENTE,
    ai.ISACHAT,
    ai.COMPTE_VENTE,
    ai.COMPTE_ACHAT,
    ai.TVA,
    ai.COULEUR,
    ai.TAILLE,
    ai.REFERENCE,
    ai.codebarre,
    u.val,
    ai.codegros,
    ai.pvgros, ai.POINTURE, tl.val, c.VAL, ai.COULEUR;
