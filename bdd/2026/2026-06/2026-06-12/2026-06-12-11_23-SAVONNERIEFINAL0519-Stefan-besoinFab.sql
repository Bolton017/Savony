-- Stefan

CREATE TABLE BESOINFABRICATION (
                                   ID VARCHAR2(255) NOT NULL,
                                   DATY DATE,
                                   MOIS NUMBER(2,0),
                                   ANNEE NUMBER(4,0),
                                   REMARQUE VARCHAR2(4000),

                                   CONSTRAINT PK_BESOINFABRICATION PRIMARY KEY (ID)
);


create sequence seq_BesoinFabrication
    minvalue 1
    maxvalue 999999999999
    start with 1
    increment by 1
    cache 20;

CREATE OR REPLACE FUNCTION get_seq_BesoinFabrication
   RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
SELECT seq_BesoinFabrication.NEXTVAL INTO retour FROM DUAL;

RETURN retour;
END;

CREATE TABLE BESOINFABRICATIONDETAILS (
                                          ID VARCHAR2(255) NOT NULL,
                                          IDBESOINFABRICATION VARCHAR2(255),
                                          IDPRODUIT VARCHAR2(255) NOT NULL,
                                          QTE NUMBER(15,3),
                                          UNITE VARCHAR2(50),
                                          IDMERE VARCHAR2(255),

                                          CONSTRAINT PK_BESOINFABRICATIONDETAILS PRIMARY KEY (ID)
);

create sequence SeqBesoinFabDetails
    minvalue 1
    maxvalue 999999999999
    start with 1
    increment by 1
    cache 20;

CREATE OR REPLACE FUNCTION get_SeqBesoinFabDetails
   RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
SELECT SeqBesoinFabDetails.NEXTVAL INTO retour FROM DUAL;

RETURN retour;
END;

CREATE OR REPLACE VIEW BESOINFABRICATIONCPL AS
SELECT
    BF.ID,
    BF.DATY,
    BF.MOIS,
    CASE BF.MOIS
        WHEN 1 THEN 'Janvier'
        WHEN 2 THEN 'Fevrier'
        WHEN 3 THEN 'Mars'
        WHEN 4 THEN 'Avril'
        WHEN 5 THEN 'Mai'
        WHEN 6 THEN 'Juin'
        WHEN 7 THEN 'Juillet'
        WHEN 8 THEN 'Aout'
        WHEN 9 THEN 'Septembre'
        WHEN 10 THEN 'Octobre'
        WHEN 11 THEN 'Novembre'
        WHEN 12 THEN 'Decembre'
        END AS MOISLIB,
    BF.ANNEE,
    BF.REMARQUE
FROM BESOINFABRICATION BF
;

CREATE OR REPLACE VIEW BESOINFABRICATIONDETAILSCPL AS
SELECT
    bfd.id,
    bfd.idBesoinFabrication,
    bfd.idProduit,
    bfd.qte,
    bfd.unite,
    bfd.IDMERE,
    p.LIBELLE                            AS idproduitLib,
    u.VAL                                AS uniteLib,
    bfdl.mois,
    bfdl.annee,
    bfdl.daty,
    DECODE(bfdl.mois,
           1, 'Janvier', 2, 'Fevrier', 3, 'Mars', 4, 'Avril',
           5, 'Mai', 6, 'Juin', 7, 'Juillet', 8, 'Aout',
           9, 'Septembre', 10, 'Octobre', 11, 'Novembre', 12, 'Decembre'
    ) AS moisLib,
    DECODE(bfdl.mois,
           1, 'Janvier', 2, 'Fevrier', 3, 'Mars', 4, 'Avril',
           5, 'Mai', 6, 'Juin', 7, 'Juillet', 8, 'Aout',
           9, 'Septembre', 10, 'Octobre', 11, 'Novembre', 12, 'Decembre'
    )
        || ' ' || bfdl.annee AS moisAnneeLib,
    (bfdl.annee * 100 + bfdl.mois) AS TRI_CHRONO
FROM BesoinFabricationDetails bfd
         LEFT JOIN AS_INGREDIENTS p ON p.id = bfd.idProduit
         LEFT JOIN AS_UNITE u ON u.id = bfd.unite
         LEFT JOIN BESOINFABRICATION bfdl ON bfdl.id = bfd.IDBESOINFABRICATION
WHERE p.categorieIngredient = 'CAT008'
ORDER BY mois ASC

;

CREATE OR REPLACE VIEW BESOINFABRICATIONDETAILSCPL2 AS
SELECT
    bfd.id,
    bfd.idBesoinFabrication,
    bfd.idProduit,
    bfd.qte,
    bfd.unite,
    bfd.IDMERE,
    p.LIBELLE                            AS idproduitLib,
    u.VAL                                AS uniteLib,
    bfdl.mois,
    bfdl.annee,
    bfdl.daty,
    DECODE(bfdl.mois,
           1, 'Janvier', 2, 'Fevrier', 3, 'Mars', 4, 'Avril',
           5, 'Mai', 6, 'Juin', 7, 'Juillet', 8, 'Aout',
           9, 'Septembre', 10, 'Octobre', 11, 'Novembre', 12, 'Decembre'
    ) AS moisLib,
    DECODE(bfdl.mois, 1, 'Janvier', 2, 'Fevrier', 3, 'Mars', 4, 'Avril', 5, 'Mai', 6, 'Juin', 7, 'Juillet', 8, 'Aout', 9, 'Septembre', 10, 'Octobre', 11, 'Novembre', 12, 'Decembre')
        || ' ' || bfdl.annee AS moisAnneeLib,
    (bfdl.annee * 100 + bfdl.mois) AS TRI_CHRONO
FROM BesoinFabricationDetails bfd
         LEFT JOIN AS_INGREDIENTS p ON p.id = bfd.idProduit
         LEFT JOIN AS_UNITE u ON u.id = bfd.unite
         LEFT JOIN BESOINFABRICATION bfdl ON bfdl.id = bfd.IDBESOINFABRICATION
WHERE p.categorieIngredient <> 'CAT008'
ORDER BY mois ASC



;