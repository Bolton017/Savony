create or replace view VENTE_DIRECTE_CPL_PDF as
SELECT "ID","DESIGNATION","IDMAGASIN","IDMAGASINLIB","DATY","DATYPREVU","REMARQUE","ETAT","ETATLIB","MONTANTTOTAL","IDDEVISE","IDCLIENT","IDCLIENTLIB","MONTANTTVA","MONTANTTTC","MONTANTTTCAR","MONTANTPAYE","MONTANTRESTE","AVOIR","TAUXDECHANGE","MONTANTREVIENT","MARGEBRUTE","IDRESERVATION","IDMODEPAIEMENT","REFERENCEFACTURE","IDMODEPAIEMENTLIB","MONTANTDONNE","MONTANTRETOURNER","HEURESAISIE","IDORIGINE","DATYHEURE","NOMCLIENTDIVERS","IDRESPONSABLELIB"
FROM (
         SELECT v.ID,
                v.DESIGNATION,
                v.IDMAGASIN,
                m.VAL AS IDMAGASINLIB,
                v.DATY,
                v.DATYPREVU,
                v.REMARQUE,
                v.ETAT,
                CASE
                    WHEN v.ETAT = 1  THEN 'CR&Eacute;&Eacute;E'
                    WHEN v.ETAT = 11 THEN 'VIS&Eacute;E'
                    WHEN v.ETAT = 0  THEN 'ANNUL&Eacute;E'
                    END AS ETATLIB,
                v2.MONTANTTOTAL,
                v2.IDDEVISE,
                v.IDCLIENT,
                c.NOM AS IDCLIENTLIB,
                cast(V2.MONTANTTVA as number(30,2)) as MONTANTTVA,
                cast(V2.MONTANTTTC as number(30,2)) as montantttc,
                cast(V2.MONTANTTTCAR as number(30,2)) as MONTANTTTCAR,
                cast(nvl(mv.credit,0)-nvl(ACG.MONTANTPAYE, 0) AS NUMBER(30,2)) AS montantpaye,
                cast(V2.MONTANTTTC-nvl(mv.credit,0)-nvl(ACG.resteapayer_avr, 0) AS NUMBER(30,2)) AS montantreste,
                nvl(ACG.MONTANTTTC_avr, 0) as avoir,
                v2.tauxDeChange AS tauxDeChange,
                v2.MONTANTREVIENT,
                cast((V2.MONTANTTTCAR-v2.MONTANTREVIENT) as number(20,2)) as margeBrute,
                v.IDRESERVATION,
                v.idmodepaiement,
                rf.REFERENCE as referencefacture,
                mp.val AS idmodepaiementlib,
                CASE
                    WHEN v.MONTANTDONNE IS NULL OR v.MONTANTDONNE = 0
                        THEN cast(nvl(mv.credit,0)-nvl(ACG.MONTANTPAYE, 0) AS NUMBER(30,2))
                    ELSE cast(v.MONTANTDONNE AS NUMBER(30,2))
                    END AS MONTANTDONNE,
                nvl(mv.MONTANTRETOURNER, 0) as montantretourner,
                v.heureSaisie,
                v.IDORIGINE,
                TO_DATE(v.daty || ' ' || v.heureSaisie, 'DD/MM/YYYY HH24:MI:SS') AS DATYHEURE,
                v.NOMCLIENTDIVERS,
                pers.nom || ' ' || pers.prenom as IDRESPONSABLELIB
         FROM VENTE v
                  LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT
                  LEFT JOIN MAGASIN m ON m.ID = v.IDMAGASIN
                  JOIN VENTEMONTANT v2 ON v2.ID = v.ID
                  LEFT JOIN MVTCAISSEGROUPEFACTURE_PDF mv ON v.id in mv.IDORIGINE
                  LEFT JOIN AVOIRFCLIB_CPL_GRP ACG on ACG.IDVENTE = v.ID
             LEFT JOIN MODEPAIEMENT mp ON mp.id = v.idmodepaiement
             LEFT JOIN REFERENCEFACTURE rf ON rf.idfacture=v.Id
             LEFT JOIN LOG_PERSONNEL pers ON pers.id = v.IDRESPONSABLE
--                   LEFT JOIN UTILISATEUR u
--                             ON u.REFUSER = v.IDRESPONSABLE
     )
ORDER BY DATYHEURE DESC NULLS LAST;


create or replace view VENTE_DETAILS_TICKET as
SELECT vd.ID,
       vd.IDVENTE,
       v.DESIGNATION AS IDVENTELIB,
       vd.IDPRODUIT,
       p.LIBELLE AS IDPRODUITLIB,
       v.IDORIGINE,
       vd.QTE,
       VD.pu
                     AS PU,
       CAST((nvl(vd.remise/100,0))*(vd.QTE * vd.PU) AS NUMBER(30,2)) AS montantRemise,
       CAST((1-nvl(vd.remise/100,0))*(vd.QTE * vd.PU) AS NUMBER(30,2)) AS montant,
       vd.iddevise AS iddevise,
       vd.tauxDeChange AS tauxDeChange,
       vd.tva AS tva,
       v.idclient,
       c.nom as idclientlib,
       vd.designation,
       vd.PUREVIENT,
       cast(vd.QTE*vd.PUREVIENT as NUMBER(20,2)) as montantRevient,
       p.UNITE,
       unit.val as idUniteLib,
       CAST(vd.pu * (1 + vd.TVA / 100) AS NUMBER(30,2)) AS PVTVA
FROM VENTE_DETAILS vd
         LEFT JOIN VENTE v ON v.ID = vd.IDVENTE
         LEFT JOIN AS_INGREDIENTS p ON p.ID = vd.IDPRODUIT
         LEFT JOIN UNITE unit ON unit.id = p.UNITE
         LEFT JOIN CLIENT c ON c.id = v.IDCLIENT;

SELECT uc.table_name, uc.constraint_type, ucc.column_name, ucc.position
FROM   user_constraints uc
           JOIN   user_cons_columns ucc ON ucc.constraint_name = uc.constraint_name
WHERE  uc.constraint_name = 'SYS_C00420117'
ORDER  BY ucc.position;

create sequence seq_billetage
    minvalue 1
    maxvalue 999999999999
    start with 1
    increment by 1
    cache 20;

-- fonction maka ilay sequence OFFILLE
CREATE OR REPLACE FUNCTION getseqbilletage
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
SELECT seq_billetage.NEXTVAL INTO retour FROM DUAL;

RETURN retour;
END;