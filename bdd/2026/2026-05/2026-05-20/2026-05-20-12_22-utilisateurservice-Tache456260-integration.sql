UPDATE PREVISION SET
    annee = NULL,
    mois  = NULL;

ALTER TABLE UTILISATEUR ADD
idService varchar(255);

UPDATE UTILISATEUR SET idService = '62';


create or replace view PREVISION_CPL as
select
    p.id,
    p.designation,
    p.idcaisse,
    c.val as idcaisselib,
    p.idventedetail,
    v.IDVENTE,
    v2.designation as idventelib,
    p.idvirement,
    p.debit,
    p.credit,
    p.daty,
    p.etat,
    p.idop,
    o.DESIGNATION as idoplib ,
    p.idorigine,
    p.iddevise,
    p.designation as iddeviselib,
    p.taux,
    p.idtiers,
    p.compte,
    p.idfacture,
    v2.IDRESERVATION,
    CASE WHEN p.mois BETWEEN 1 AND 12 THEN p.mois  END AS mois,
    CASE WHEN p.annee > 0 THEN p.annee END AS annee,
    CASE
        WHEN p.mois BETWEEN 1 AND 12
        THEN TO_CHAR(
                 TO_DATE(TO_CHAR(p.mois, 'FM00'), 'MM'),
                 'FMMonth',
                 'NLS_DATE_LANGUAGE=FRENCH'
             )
    END AS moisLib,
    s.id as idservice,
    p.SERVICE,
    s.libelle AS idServiceLib
from PREVISION p
         left join caisse c on p.idcaisse = c.id
         left join VENTE_DETAILS v on p.IDVENTEDETAIL=v.ID
         left join vente v2 on v2.id=v.IDVENTE
         left join ORDONNERPAIEMENT o on o.id=p.IDOP
         left join devise d on d.id=p.IDDEVISE
         LEFT JOIN SERVICE s ON p.SERVICE = s.COMPTE;