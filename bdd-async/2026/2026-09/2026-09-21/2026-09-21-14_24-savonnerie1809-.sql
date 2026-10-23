-- Mitia
INSERT INTO PARAMCONSTANTESOCOBIS (ID, VAL, DESCE)
VALUES ('PRMS563', 'CTGST000001', 'ID CATEGORIESOCK NORMAL');
create or replace view AS_INGREDIENTS_LIB as
SELECT ing.id,
       ing.LIBELLE,
       ing.PARFUMS,
       ing.SEUIL,
       au.VAL AS unite,
       ing.QUANTITEPARPACK,
       ing.pu,
       ing.ACTIF,
       ing.PHOTO,
       ing.CALORIE,
       ing.DURRE,
       ing.COMPOSE,
       CAST(
               CASE
                   WHEN ing.COMPOSE = 1 THEN 'OUI'
                   WHEN ing.COMPOSE = 0 THEN 'NON'
                   END AS VARCHAR2(100)
       ) AS COMPOSELIB,
       cating.id AS IDCATEGORIEINGREDIENT ,
       catIng.VAL AS CATEGORIEINGREDIENT,
       ing.CATEGORIEINGREDIENT AS idcategorie,
       ing.idfournisseur,
       ing.daty,
       catIng.desce as bienOuServ,
       CASE WHEN ing.id IN (SELECT idproduit FROM INDISPONIBILITE i )
                THEN 'INDISPONIBLE'
            WHEN ing.id NOT IN (SELECT idproduit FROM INDISPONIBILITE i )
                THEN 'DISPONIBLE'
           END AS etatlib,
       ing.COMPTE_VENTE,
       ing.COMPTE_ACHAT,
       ing.pv,
       ing.tva,
       ing.TYPESTOCK,
       ing.UNITE as idunite,
       ing.REFPOST,
       ing.REFQUALIFICATION ,
       p.VAL AS REFPOSTLIB,
       qp.VAL AS REFQUALIFICATIONLIB,
       fp.val AS idfamilleLib,
       CASE
           WHEN ing.actif = 1 THEN 'OUI'
           WHEN ing.actif = 0 THEN 'NON'
           END AS  actiflib,
        ing.COMPTE_SORTIE_STOCK,
        ing.COMPTE_STOCK

FROM as_ingredients ing
         LEFT JOIN AS_UNITE AU ON ing.UNITE = AU.ID
         LEFT JOIN CATEGORIEINGREDIENTLIB catIng
                   ON catIng.id = ing.CATEGORIEINGREDIENT
         LEFT JOIN POSTE p ON p.id = ing.REFPOST
         LEFT JOIN FAMILLEPRODUIT fp ON fp.id=ing.idfamille
         LEFT JOIN QUALIFICATION_PAIE qp ON qp.id = ing.REFQUALIFICATION;

create or replace view MVTSTOCKLIB as
SELECT
    m.ID ,
    m.DESIGNATION ,
    m.IDMAGASIN ,
    m.IDOBJET ,
    m2.VAL  AS idMagasinlib,
    m.IDVENTE ,
    v.DESIGNATION  AS idVentelib,
    m.IDTRANSFERT ,
    CAST('' AS VARCHAR2(255)) AS idTransfertlib,
    m.IDTYPEMVSTOCK ,
    t.VAL AS idTypeMvStocklib ,
    m.DATY ,
    m.ETAT ,
    CASE
        WHEN m.ETAT = 0
            THEN 'ANNUL&Eacute;E'
        WHEN m.ETAT = 1
            THEN 'CR&Eacute;&Eacute;E'
        WHEN m.ETAT = 11
            THEN 'VALID&Eacute;E'
        END AS etatlib,
    v.IDRESERVATION,
    gm.montantEntree,
    gm.montantSortie,
    (
        m.DESIGNATION || ' ' ||
        NVL(m2.VAL, '') || ' ' ||
        NVL(v.DESIGNATION, '') || ' ' ||
        TO_CHAR(m.DATY, 'YYYY-MM-DD')
        ) AS motsClesss,
    m.remarque,
    m.HEURE
FROM MVTSTOCK m
         LEFT JOIN TYPEMVTSTOCK t ON t.ID = m.IDTYPEMVSTOCK
         LEFT JOIN VENTE v ON v.ID = m.IDVENTE
         LEFT JOIN MAGASIN2 m2 ON m2.ID = m.IDMAGASIN
         left join mvtStockFilleGroupeMere gm on gm.IDMVTSTOCK=m.ID;


create or replace view COMPTA_SOUSECRITURE_LIB
            (ID, NUMERO, COMPTE, JOURNAL, IDJOURNAL, ECRITURE, DATY, CREDIT, DEBIT, DATECOMPTABLE, EXERCICE, REMARQUE,
             ETAT, IDMERE, HORSEXERCICE, OD, ORIGINE, TIERS, LIBELLEPIECE, COMPTE_AUX, RAISONSOCIAL, FOLIO, LETTRAGE,
             ANALYTIQUE,idobjet)
as
select
    sousecr.id,
    cpt.LIBELLE,
    cpt.COMPTE,
    jrn.val||'| '|| jrn.DESCE ,
    jrn.id,
    sousecr.REMARQUE as DESIGNATION,
    sousecr.DATY,
    sousecr.CREDIT,
    sousecr.DEBIT,
    sousecr.DATY AS DATECOMPTABLE,
    sousecr.EXERCICE,
    sousecr.REMARQUE,
    sousecr.ETAT,
    sousecr.idmere,
    cast(0 as number) AS HORSEXERCICE,
    cast('-' as varchar(50)) AS OD,
    cast('' as varchar(50)) AS ORIGINE,
    cast('' as varchar2(50)) as tiers,
    sousecr.LIBELLEPIECE,
    sousecr.COMPTE_AUX,
    cast('' as varchar(100)) as RAISONSOCIAL ,
    sousecr.folio ,
    sousecr.LETTRAGE ,
    sousecr.ANALYTIQUE,
    ce.IDOBJET as idobjet -- nanampy colonne id objet ftsn
from
    COMPTA_SOUS_ECRITURE sousecr
        join COMPTA_COMPTE cpt on  sousecr.COMPTE = cpt.COMPTE
        join COMPTA_JOURNAL jrn on sousecr.JOURNAL = jrn.ID
        LEFT JOIN COMPTA_ECRITURE CE ON CE.ID = sousecr.idMERE;



create or replace view INVENTAIRELIB as
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
    i.HEURE
FROM INVENTAIRE i
         LEFT JOIN MAGASINPOINT m ON m.ID = i.IDMAGASIN
         LEFT JOIN CATEGORIEINGREDIENT c ON c.id = i.idcategorie;