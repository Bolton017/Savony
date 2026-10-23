create or replace view COMPTA_COMPTE_LIB as
(
select ID,
       LIBELLE || ' : ' || COMPTE as compte,
       LIBELLE,
       COMPTE                     as cpt,
       TYPECOMPTE,
       CLASSY,
       ANALYTIQUE_OBLI,
       IDJOURNAL
from COMPTA_COMPTE
    );
