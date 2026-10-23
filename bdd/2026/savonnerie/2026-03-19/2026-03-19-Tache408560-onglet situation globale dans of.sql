create view SITUATIONOFAB as
SELECT
    offle.IDMERE,
    offle.IDMERE as id,
    st.IDINGREDIENTS,
    st.LIBINGREDIENTS,
    SUM(st.QTEOF) as QTEOF,
    SUM(st.QTEFABRIQUE) as QTEFABRIQUE,
    SUM(st.RAF) as RAF,
    st.atelier,
    st.atelierlib
FROM SITUATIONOFFILLEWATELIER st
         LEFT JOIN OFFILLE offle on offle.ID = st.IDPRODUITS
GROUP BY offle.IDMERE, st.IDINGREDIENTS,st.LIBINGREDIENTS,st.atelierlib,st.atelier