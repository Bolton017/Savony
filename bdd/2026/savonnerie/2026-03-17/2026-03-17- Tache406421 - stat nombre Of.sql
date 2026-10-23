create or replace view OFABLIBCOUNT as
select o."ID",
       o."LANCEPAR",
       o."CIBLE",
       o."REMARQUE",
       o."LIBELLE",
       o."BESOIN",
       o."DATY",
       o."ETAT",
       CASE
           WHEN o.ETAT=1
               THEN 'Créé'
           WHEN o.ETAT=11
               THEN 'Validé'
           WHEN o.ETAT=0
               THEN 'Annulée'
           WHEN o.ETAT=21
               THEN 'Entamé'
           WHEN o.ETAT=31
               THEN 'Bloqué'
           WHEN o.ETAT=41
               THEN 'Terminée'
           END AS ETATLIB,
       1 as nb
from OFABLIB o;