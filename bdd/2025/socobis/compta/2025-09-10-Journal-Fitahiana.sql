INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MNDN1009001', 'Journaux', 'fa fa-search', 'module.jsp?but=compta/etat/journal-filtre.jsp', 3, 3, 'MNDN285');



create or replace view COMPTA_SOUSECRITURE_LIB
            (ID, NUMERO, COMPTE, JOURNAL, IDJOURNAL, ECRITURE, DATY, CREDIT, DEBIT, DATECOMPTABLE, EXERCICE, REMARQUE,
             ETAT, IDMERE, HORSEXERCICE, OD, ORIGINE, TIERS, LIBELLEPIECE, COMPTE_AUX,RAISONSOCIAL, FOLIO, LETTRAGE, ANALYTIQUE)
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
    sousecr.ANALYTIQUE
from
    COMPTA_SOUS_ECRITURE sousecr
        join COMPTA_COMPTE cpt on  sousecr.COMPTE = cpt.COMPTE
        join COMPTA_JOURNAL jrn on sousecr.JOURNAL = jrn.ID
        /


create or replace view COMPTA_SOUSECRITURE_LIB_J as
select cse.*,ce.DESIGNATION as designationmere,
       EXTRACT(DAY FROM cse.DATY)   AS jour,
       EXTRACT(MONTH FROM cse.DATY) AS mois,
       EXTRACT(YEAR FROM cse.DATY)  AS annee  from COMPTA_SOUSECRITURE_LIB cse join COMPTA_ECRITURE ce on cse.IDMERE=ce.ID;