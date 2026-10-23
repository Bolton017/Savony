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