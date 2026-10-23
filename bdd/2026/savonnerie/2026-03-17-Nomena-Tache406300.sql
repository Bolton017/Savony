create or replace view MVTSTOCKFILLEFAB as
select st."ID",st."IDMVTSTOCK",st."IDPRODUIT",st."ENTREE",st."SORTIE",st."IDVENTEDETAIL",st."IDTRANSFERTDETAIL",st."PU",st."MVTSRC",st."RESTE",st."DESIGNATION",m.IDOBJET as idFab ,m.DATY  from MVTSTOCKFILLE st left join MVTSTOCK m on st.IDMVTSTOCK=m.ID;


create or replace view MVTSTOCKFILLESORTIEFAB as
select st.ID,
       st.IDMVTSTOCK,
       st.IDPRODUIT,
       ai.LIBELLE AS IDPRODUITLIB,
       st.ENTREE,
       st.SORTIE,
       st.IDVENTEDETAIL,
       st.IDTRANSFERTDETAIL,
       st.PU,
       st.MVTSRC,
       st.RESTE,
       st.DESIGNATION,
       st.IDFAB,
       st.DATY,
       ai.CATEGORIEINGREDIENT,
       st.SORTIE * st.PU as MONTANT
from MVTSTOCKFILLEFAB st
         LEFT JOIN AS_INGREDIENTS_LIB ai
                   ON st.IDPRODUIT = ai.id
WHERE st.ENTREE <= 0 AND IDFAB like 'FAB%' AND IDFAB is not null;


CREATE OR REPLACE VIEW MVTSTOCKFILLEENTREEFAB AS
select st.ID,st.IDMVTSTOCK,st.IDPRODUIT,ai.LIBELLE AS IDPRODUITLIB,st.ENTREE,st.SORTIE,st.IDVENTEDETAIL,st.IDTRANSFERTDETAIL,st.PU,st.MVTSRC,st.RESTE,st.DESIGNATION,st.IDFAB, st.DATY, ai.CATEGORIEINGREDIENT
from MVTSTOCKFILLEFAB st
         LEFT JOIN AS_INGREDIENTS ai
                   ON st.IDPRODUIT = ai.id
WHERE st.SORTIE <= 0;

CREATE OR REPLACE VIEW OFABLIBCOUNT AS
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
from fabricationcpl o;