create or replace view PERTEGAINIMPREVUELIB as
SELECT pgi.ID,pgi.DESIGNATION,pgi.IDTYPEGAINPERTE,pgi.PERTE,pgi.GAIN,pgi.IDORIGINE,pgi.DATY,pgi.ETAT,pgi.TVA,pgi.TIERS,
       tgp.val                                                                             AS TYPE,
       tgp.desce                                                                           AS compte,
       case when perte > 0 then perte * tva / 100 else gain * tva / 100 end                as montanttva,
       case when perte > 0 then perte else gain end                                        as montantht,
       case when perte > 0 then perte + perte * tva / 100 else gain + gain * tva / 100 end as montantttc,
       t.nom as TIERSLIB,
       t.COMPTE as tierscompte,
       t.COMPTEAUXILIAIRE
FROM pertegainimprevue pgi
         LEFT JOIN typegainperte tgp on pgi.idtypegainperte = tgp.id
         LEFT JOIN tiers t on t.id = pgi.tiers
/
-- auto-generated definition
create or replace view COMPTA_SOUSECRITURE_ECRITURE
            (ID, NUMERO, COMPTE, JOURNAL, IDJOURNAL, ECRITURE, DATY, CREDIT, DEBIT, DATECOMPTABLE, EXERCICE, REMARQUE,
             ETAT, HORSEXERCICE, OD, ORIGINE, TIERS, LIBELLEPIECE, COMPTE_AUX,RAISONSOCIAL, FOLIO, LETTRAGE, ANALYTIQUE, IDOBJET)
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
    ce.IDOBJET
from
    COMPTA_SOUS_ECRITURE sousecr
        join COMPTA_COMPTE cpt on  sousecr.COMPTE = cpt.COMPTE
        join COMPTA_JOURNAL jrn on sousecr.JOURNAL = jrn.ID
        JOIN COMPTA_ECRITURE ce ON ce.id = sousecr.IDMERE
/





