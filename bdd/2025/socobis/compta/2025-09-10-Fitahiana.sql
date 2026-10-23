ALTER TABLE Client
    ADD compteauxiliaire VARCHAR(20) UNIQUE;

ALTER TABLE Fournisseur
    ADD compteauxiliaire VARCHAR(20) UNIQUE;

create or replace view TIERS as
select ID, NOM, COMPTE, compteauxiliaire from FOURNISSEUR
UNION ALL
select ID, NOM, COMPTE, compteauxiliaire from CLIENT;

create or replace view FACTUREFOURNISSEUR_CPL as
select ff."ID",ff."IDFOURNISSEUR",ff."IDMODEPAIEMENT",ff."DATY",ff."DESIGNATION",ff."DATEECHEANCEPAIEMENT",ff."ETAT",ff."REFERENCE",ff."IDBC",ff."DEVISE",ff."TAUX",ff."IDMAGASIN",
       f.NOM as fournisseurlib,
       mp.VAL as modedepaimentlib,
       f.COMPTE,
       f.compteauxiliaire
from FACTUREFOURNISSEUR ff
         left join FOURNISSEUR f on ff.IDFOURNISSEUR = f.ID
         left join MODEPAIEMENT mp on ff.IDMODEPAIEMENT = mp.ID;

create or replace view FACTUREFOURNISSEUR_MERECMPT as
select ff."ID",
       ff."IDFOURNISSEUR",
       ff."IDMODEPAIEMENT",
       ff."DATY",
       ff."DESIGNATION",
       ff."DATEECHEANCEPAIEMENT",
       ff."ETAT",
       ff."REFERENCE",
       ff."IDBC",
       ff."DEVISE",
       ff."TAUX",
       ff."IDMAGASIN",
       ff."FOURNISSEURLIB",
       ff."MODEDEPAIMENTLIB",
       ff."COMPTE",
       ff.compteauxiliaire,
       fm.MONTANTHT,
       fm.MONTANTTVA,
       fm.MONTANTTTC
from FACTUREFOURNISSEUR_CPL ff
         left join FACTUREFOURNISSEUR_FILLECOMPTE fm on fm.IDFACTUREFOURNISSEUR = ff.id;


create or replace view AVOIRFCLIB as
SELECT a.ID,
       a.DESIGNATION,
       a.IDMAGASIN,
       m.VAL         AS IDMAGASINLIB,
       a.DATY,
       a.REMARQUE,
       a.ETAT,
       a.IDORIGINE,
       a.IDCLIENT,
       t.COMPTE,
       t.compteauxiliaire,
       a.IDVENTE,
       v.DESIGNATION AS IDVENTELIB,
       a.IDMOTIF,
       ma.VAL        AS IDMOTIFLIB,
       a.IDCATEGORIE,
       c.VAL         AS IDCATEGORIELIB,
       ag.IDDEVISE,
       ag.TAUXDECHANGE,
       ag.MONTANTHT,
       ag.MONTANTTVA,
       ag.MONTANTTTC,
       ag.MONTANTHTAR,
       ag.MONTANTTVAAR,
       ag.MONTANTTTCAR,
       v.IDRESERVATION
FROM AVOIRFC a
         LEFT JOIN MAGASIN m ON m.id = a.IDMAGASIN
         LEFT JOIN VENTE v ON v.id = a.IDVENTE
         LEFT JOIN MOTIFAVOIRFC ma ON ma.id = a.IDMOTIF
         LEFT JOIN CATEGORIEAVOIRFC c ON c.id = a.IDCATEGORIE
         JOIN AVOIRFCFILLE_GRP ag ON ag.idavoirfc = a.id
         LEFT JOIN TIERS T ON T.ID = A.IDCLIENT;


create or replace view COMPTA_SOUSECRITURE_SANSPG
            (ID, NUMERO, COMPTE, JOURNAL, IDJOURNAL, ECRITURE, DATY, CREDIT, DEBIT, DATECOMPTABLE, EXERCICE, REMARQUE,
             ETAT, HORSEXERCICE, OD, ORIGINE, TIERS, LIBELLEPIECE, COMPTE_AUX, RAISONSOCIAL,FOLIO, LETTRAGE, ANALYTIQUE, IDOBJET)
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
    cast(0 as number) AS HORSEXERCICE,
    cast('-' as varchar(50)) AS OD,
    cast('' as varchar(50)) AS ORIGINE,
    cast('' as varchar2(50)) as tiers,
    sousecr.LIBELLEPIECE,
    sousecr.COMPTE_AUX,
    cast('' as varchar(100)) as RAISONSOCIAL ,
    sousecr.folio ,
    sousecr.LETTRAGE ,
    ANALYTIQUE,
    CASE
        WHEN ce.IDOBJET= pe.id THEN pe.idorigine
        ELSE ce.idobjet
        END
        AS idobjet
from
    COMPTA_SOUS_ECRITURE sousecr
        join COMPTA_COMPTE cpt on  sousecr.COMPTE = cpt.COMPTE
        join COMPTA_JOURNAL jrn on sousecr.JOURNAL = jrn.ID
        JOIN COMPTA_ECRITURE ce ON ce.id = sousecr.IDMERE
        LEFT JOIN PERTEGAINIMPREVUE pe ON ce.idobjet=pe.id;