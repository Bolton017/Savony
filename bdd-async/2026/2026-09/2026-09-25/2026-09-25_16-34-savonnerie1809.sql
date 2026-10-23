-- Stef

CREATE OR REPLACE VIEW INVENTAIREFILLEGROUPEMERE AS
select f.IDINVENTAIRE,cast(sum(nvl(f.pu*f.QUANTITE,0)) as number(30,2)) as montantQuantite
from INVENTAIREFILLE f group by f.IDINVENTAIRE;

CREATE OR REPLACE VIEW INVENTAIRELIB AS
SELECT
    i.ID ,
    i.DATY ,
    i.DESIGNATION ,
    i.IDMAGASIN ,
    m.VAL AS IDMAGASINLIB,
    i.ETAT ,
    CASE
        WHEN i.ETAT = 0
            THEN 'ANNUL&Eacute;E'
        WHEN i.ETAT = 1
            THEN 'CR&Eacute;&Eacute;E'
        WHEN i.ETAT = 11
            THEN 'VALID&Eacute;E'
        END AS ETATLIB,
    i.idcategorie,
    c.VAL AS idcategorieLib,
    UPPER(
            NVL(i.DESIGNATION, '') || ' ' ||
            NVL(m.VAL, '') || ' ' ||
            NVL(c.VAL, '') || ' ' ||
            NVL(i.ID, '') || ' ' ||
            TO_CHAR(i.DATY, 'DD/MM/YYYY') || ' ' ||
            NVL(
                    CASE
                        WHEN i.ETAT = 0 THEN 'ANNUL&Eacute;E'
                        WHEN i.ETAT = 1 THEN 'CR&Eacute;&Eacute;E'
                        WHEN i.ETAT = 11 THEN 'VALID&Eacute;E'
                        END
                , '')
    ) AS MOTSCLESSS,
    i.HEURE,
    m.IDDEPARTEMENT,
    m.IDDEPARTEMENTLIB,
    CAST(ifgm.montantQuantite AS NUMBER(30,2) ) AS montantQuantite,
    i.REMARQUE
FROM INVENTAIRE i
         LEFT JOIN MAGASINPOINT m ON m.ID = i.IDMAGASIN
         LEFT JOIN CATEGORIEINGREDIENT c ON c.id = i.idcategorie
         LEFT JOIN INVENTAIREFILLEGROUPEMERE ifgm ON ifgm.IDINVENTAIRE = i.id;


CREATE OR REPLACE VIEW INVENTAIRELIB_ANNULEE AS
SELECT
    i.ID,i.DATY,i.DESIGNATION,i.IDMAGASIN,i.IDMAGASINLIB,i.ETAT,i.ETATLIB,i.MOTSCLESSS,i.HEURE, i.IDDEPARTEMENT, i.IDDEPARTEMENTLIB, i.REMARQUE, CAST(i.montantQuantite AS NUMBER(30,2)) AS montantQuantite
FROM INVENTAIRELIB i
WHERE i.ETAT = 0;

CREATE OR REPLACE VIEW INVENTAIRELIB_CREE AS
SELECT
    i.ID,i.DATY,i.DESIGNATION,i.IDMAGASIN,i.IDMAGASINLIB,i.ETAT,i.ETATLIB,i.MOTSCLESSS,i.HEURE, i.IDDEPARTEMENT, i.IDDEPARTEMENTLIB, i.REMARQUE, CAST(i.montantQuantite AS NUMBER(30,2)) AS montantQuantite
FROM INVENTAIRELIB i
WHERE i.ETAT = 1;

CREATE OR REPLACE VIEW INVENTAIRELIB_VALIDEE AS
SELECT
    i.ID,i.DATY,i.DESIGNATION,i.IDMAGASIN,i.IDMAGASINLIB,i.ETAT,i.ETATLIB,i.MOTSCLESSS,i.HEURE, i.IDDEPARTEMENT, i.IDDEPARTEMENTLIB, i.REMARQUE, CAST(i.montantQuantite AS NUMBER(30,2)) AS montantQuantite
FROM INVENTAIRELIB i
WHERE i.ETAT = 11;
 
