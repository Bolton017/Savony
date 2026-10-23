create or replace view MVTCAISSEGROUPEFACTURE_PDF as
select id2 AS idorigine, sum(l.MONTANT ) as debit, sum(m.credit) as credit, sum(m.montantretourner) as montantretourner, c.IDDEVISE
from LIAISONPAIEMENT l
         left join MOUVEMENTCAISSE m on m.id = l.id1
         left join caisse c on c.ID = m.idcaisse
where l.etat >= 11
  and id1 is not NULL
group BY id2, c.IDDEVISE, m.montantretourner;

ALTER  TABLE VENTE ADD (MONTANTDONNE NUMBER(30, 2) );

create or replace view VENTE_DIRECTE_CPL_PDF as
SELECT "ID","DESIGNATION","IDMAGASIN","IDMAGASINLIB","DATY","DATYPREVU","REMARQUE","ETAT","ADECLARER","ETATLIB","MONTANTTOTAL","IDDEVISE","IDCLIENT","IDCLIENTLIB","MONTANTTVA","MONTANTTTC","MONTANTTTCAR","MONTANTPAYE","MONTANTRESTE","AVOIR","TAUXDECHANGE","MONTANTREVIENT","MARGEBRUTE","IDRESERVATION","IDMODEPAIEMENT","REFERENCEFACTURE","IDMODEPAIEMENTLIB","MONTANTDONNE","MONTANTRETOURNER","HEURESAISIE","IDECHEANCEPAIEMENT","IDORIGINE","DATYHEURE","NOMCLIENTDIVERS","IDRESPONSABLELIB"
FROM (
         SELECT v.ID,
                v.DESIGNATION,
                v.IDMAGASIN,
                m.VAL AS IDMAGASINLIB,
                v.DATY,
                v.DATYPREVU,
                v.REMARQUE,
                v.ETAT,
                ADECLARER,
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
                V.IDECHEANCEPAIEMENT,
                v.IDORIGINE,
                TO_DATE(v.daty || ' ' || v.heureSaisie, 'DD/MM/YYYY HH24:MI:SS') AS DATYHEURE,
                v.NOMCLIENTDIVERS,
                u.NOMUSER as IDRESPONSABLELIB
         FROM VENTE v
                  LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT
                  LEFT JOIN MAGASIN m ON m.ID = v.IDMAGASIN
                  JOIN VENTEMONTANT v2 ON v2.ID = v.ID
                  LEFT JOIN MVTCAISSEGROUPEFACTURE_PDF mv ON v.id in mv.IDORIGINE
                  LEFT JOIN AVOIRFCLIB_CPL_GRP ACG on ACG.IDVENTE = v.ID
                  LEFT JOIN MODEPAIEMENT mp ON mp.id = v.idmodepaiement
                  LEFT JOIN REFERENCEFACTURE rf ON rf.idfacture=v.Id
                  LEFT JOIN UTILISATEUR u
                            ON u.REFUSER = TO_NUMBER(v.IDRESPONSABLE)
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
       v.idclientlib,
       vd.designation,
       vd.PUREVIENT,
       cast(vd.QTE*vd.PUREVIENT as NUMBER(20,2)) as montantRevient,
       p.UNITE,
       unit.val as idUniteLib,
       CAST(vd.pu * (1 + vd.TVA / 100) AS NUMBER(30,2)) AS PVTVA
FROM VENTE_DETAILS vd
         LEFT JOIN VENTE_LIB v ON v.ID = vd.IDVENTE
         LEFT JOIN AS_INGREDIENTS p ON p.ID = vd.IDPRODUIT
         LEFT JOIN UNITE unit ON unit.id = p.UNITE;
