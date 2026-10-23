ALTER TABLE  localisation
ADD (
    departement VARCHAR2(255)
);

-- SAVONNERIE1307.LOCALISATIONLIB source

CREATE OR REPLACE  VIEW "LOCALISATIONLIB" ("ID", "COMPTE", "LIBELLE", "TYPECOMPTE", "CLASSY", "TYPECOMPTELIB","MAGASINLIB","DEPARTEMENT","DEPARTEMENTLIB") AS 
select l."ID",l."COMPTE",l."LIBELLE",l."TYPECOMPTE",l."CLASSY", ctc.val as typecomptelib,m.val AS magasinlib,l.departement,d.val AS departementlib
from localisation l
         left join COMPTA_TYPE_COMPTE ctc on ctc.id = l.TYPECOMPTE
         LEFT JOIN MAGASIN2 m ON m.ID = l.CLASSY 
         LEFT JOIN DEPARTEMENT d ON d.id = l.departement
;

 