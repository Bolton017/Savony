CREATE OR REPLACE VIEW COMPTA_SOUSECRITURE_LIB ("ID", "NUMERO", "COMPTE", "JOURNAL", "IDJOURNAL", "ECRITURE", "DATY", "CREDIT", "DEBIT", "DATECOMPTABLE", "EXERCICE", "REMARQUE", "ETAT","IDMERE", "HORSEXERCICE", "OD", "ORIGINE", "TIERS", "LIBELLEPIECE", "COMPTE_AUX", "FOLIO", "LETTRAGE", "ANALYTIQUE") AS 
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
    cast('' as varchar(100)) as RAISONSOCIAL ,
    sousecr.folio ,
    sousecr.LETTRAGE ,
    sousecr.ANALYTIQUE
from
    COMPTA_SOUS_ECRITURE sousecr
        join COMPTA_COMPTE cpt on  sousecr.COMPTE = cpt.COMPTE
        join COMPTA_JOURNAL jrn on sousecr.JOURNAL = jrn.ID;