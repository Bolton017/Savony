CREATE OR REPLACE VIEW STOCKETDEPOFFILLETHECATGROUPE AS
select
    st.IDOBJET AS idmere,
    st.CATEGORIEINGREDIENT,
    st.idcategorieingredient,
    cast(sum(montantsortie) as number(30,2)) as montantSortie,
    cast(sum(montth) as number(30,2)) as montth,
    cast(sum(montth)-sum(montantsortie) as number(30,2)) as ecart
from STOCKETDEPENSEOFFILLETHECAT st
group by st.IDOBJET ,st.CATEGORIEINGREDIENT, st.idcategorieingredient;
