create or replace view DEMANDETRAVAUX_CPL as
SELECT
    dmd."ID",dmd."IDENTITE",dmd."IDSITUATION",dmd."IDMACHINE",dmd."DATY",dmd."DATEBESOIN",dmd."PRIORITE",dmd."ESTEXISTANT",dmd."DESCRIPTION",dmd."ETAT",dmd."IDDEPARTEMENT",
    e.VAL AS idEntiteLib,
    s.VAL AS idSituationLib,
    m.LIBELLE AS idMachineLib,
    CASE dmd.ESTEXISTANT
        WHEN 0 THEN 'NON'
        WHEN 1 THEN 'OUI'
        ELSE 'Non spécifié'
        END AS estExistantLib,
    CASE dmd.ETAT
        WHEN 1 THEN 'CR&Eacute;&Eacute;E(S)'
        WHEN 11 THEN 'VALID&Eacute;E(S)'
        ELSE 'CR&Eacute;&Eacute;E(S)'
        END AS etatLib,
    d.id AS IDDEPARTEMENTMAINTENANCE,
    d.VAL AS IDDEPARTEMENTMAINTENANCELIB,
    pri.val AS prioritelib,
    departement.val AS IDDEPARTEMENTLIB,
    otf.ID AS idOtFille,
    pl.idtypemaintenance AS idtypemaintenance,
    tm.val AS idtypemaintenancelib
FROM DEMANDETRAVAUX dmd
         LEFT JOIN ENTITE e ON e.ID = dmd.IDENTITE
         LEFT JOIN SITUATION s ON s.ID = dmd.IDSITUATION
         LEFT JOIN AS_INGREDIENT_MAINTENANCE m ON m.ID = dmd.IDMACHINE
         LEFT JOIN DEPARTEMENTMAINTENANCE d ON d.ID = dmd.IDDEPARTEMENTMAINTENANCE
         LEFT JOIN PRIORITE pri ON dmd.priorite=pri.ID
         LEFT JOIN DEPARTEMENT departement ON departement.id=dmd.iddepartement
         LEFT JOIN ORDRETRAVAUX o ON o.IDBC = dmd.ID
         LEFT JOIN ORDRETRAVAUXFILLE otf ON otf.IDMERE = o.ID
         LEFT JOIN PLANNING pl ON pl.id=dmd.idplanning
         LEFT JOIN TYPEMAINTENANCE tm ON tm.id=pl.idtypemaintenance

/

