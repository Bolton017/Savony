CREATE OR REPLACE VIEW MAGASINLIB AS 
  SELECT
    m.ID ,
    m.VAL ,
    m.DESCE ,
    m.IDPOINT ,
    p.VAL AS IDPOINTLIB,
    m.IDTYPEMAGASIN ,
    t.VAL AS IDTYPEMAGASINLIB,
    m2.val AS idmagasinmerelib,
    m.IDDEPARTEMENT AS idDepartement,
    s.libelle AS idDepartementLib
FROM MAGASIN2 m
         LEFT JOIN POINT p ON p.ID = m.IDPOINT
         LEFT JOIN TYPEMAGASIN t ON t.ID = m.IDTYPEMAGASIN
         LEFT JOIN MAGASIN2 m2 ON m2.id=m.idmagasinmere
		LEFT JOIN SERVICE s ON m.IDDEPARTEMENT = s.ID;