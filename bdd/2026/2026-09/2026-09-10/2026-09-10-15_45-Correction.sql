create or replace view ST_INGREDIENTSAUTOACHAT_CPL as (
SELECT st."ID",
       st."LIBELLE",
       st."SEUIL",
       st."UNITE",
       st."QUANTITEPARPACK",
       st."PU",
       st."ACTIF",
       st."PHOTO",
       st."CALORIE",
       st."DURRE",
       st."COMPOSE",
       st."CATEGORIEINGREDIENT",
       st."IDFOURNISSEUR",
       st."DATY",
       st."QTELIMITE",
       st."PV",
       st."LIBELLEVENTE",
       st."SEUILMIN",
       st."SEUILMAX",
       st."PUACHATUSD",
       st."PUACHATEURO",
       st."PUACHATAUTREDEVISE",
       st."PUVENTEUSD",
       st."PUVENTEEURO",
       st."PUVENTEAUTREDEVISE",
       st."ISVENTE",
       st."ISACHAT",
       st."COMPTE_VENTE",
       st."COMPTE_ACHAT",
       st."COMPTE",
       1 AS taux
FROM ST_INGREDIENTSAUTO st);

create or replace view  PROFORMAFOURNISSEUR_MERECPL as
SELECT
    ab.ID,
    ab.DATY,
    ab.ETAT,
    ab.REMARQUE,
    ab.DESIGNATION,
    ab.MODEPAIEMENT,
    ab.FOURNISSEUR,
    ab.REFERENCE,
    mp.VAL AS MODEPAIEMENTLIB,
    F.NOM AS FOURNISSEURLIB,
    abf.montantTVA,
    abf.montantHT,
    CAST(nvl(abf.MONTANTTTC,0) AS NUMBER(30,2)) AS montantTTC ,
    CAST(nvl(abf.MONTANTTTCAR,0) AS NUMBER(30,2)) AS montantTTCAriary,
    d.val AS idDeviselib,
    d.id AS IDDEVISE,
    CASE
        WHEN ab.ETAT = 0
            THEN 'ANNUL&Eacute;E'
        WHEN ab.ETAT = 1
            THEN 'CR&Eacute;&Eacute;E'
        WHEN ab.ETAT = 11
            THEN 'VIS&Eacute;(E) par PDG'
        WHEN ab.ETAT = 3
            THEN 'VIS&Eacute;(E) par Responsable achat'
        WHEN ab.ETAT = 4
            THEN 'VIS&Eacute;(E) par Chef hierarchique'
        END AS etatlib,
    ab.IDORIGINE
from  proformafournisseur AB
          left join MODEPAIEMENT mp on AB.MODEPAIEMENT = mp.id
          left join FOURNISSEUR F on AB.FOURNISSEUR = F.id
          LEFT JOIN proformafournisseurdetailsgrp abf ON abf.IDMERE = ab.ID
          LEFT JOIN DEVISE d ON d.id = ab.IDDEVISE;
