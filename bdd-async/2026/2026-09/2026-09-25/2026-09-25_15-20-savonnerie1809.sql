-- Stef

CREATE OR REPLACE VIEW MVTSTOCKFILLETRANSFERT AS
SELECT
    m.idtransfertdetail,
    CAST(sum(nvl(m.entree ,0)) AS NUMBER(30,5))  as entree,
    CAST(sum(nvl(m.sortie ,0)) AS NUMBER(30,5)) as sortie
FROM mvtstockfillelib m
         left JOIN mvtstock mv ON mv.id = m.idmvtstock
WHERE mv.etat >=11
GROUP BY m.idtransfertdetail;

CREATE OR REPLACE VIEW ANOMALIETRANSFERT AS
SELECT
    t.id as idTransfert,
    t.IDMAGASINDEPART AS magasinDepart,
    t.IDMAGASINDEPARTLIB AS  magasinDepartLib,
    t.IDMAGASINARRIVE AS magasinArrive,
    t.IDMAGASINARRIVELIB AS magasinArriveLib,
    t.IDDEPARTEMENTDEPART,
    t.idDepartementLibDepart,
    t.IDDEPARTEMENTARRIVE,
    t.idDepartementLibArrive,
    t.daty,
    t.designation,
    td.idproduit,
    td.idproduitlib,
    CAST(nvl(td.quantite,0) AS NUMBER(30,5))  AS quantite ,
    CAST(td.pu AS NUMBER(30, 5)) AS pu,
    CAST(nvl(td.pu,0)*nvl(td.quantite,0) AS NUMBER(30,5))  as montant ,
    CAST(nvl(m.sortie,0) AS NUMBER(30,5))  as envoye,
    CAST(nvl(td.pu,0)*nvl(m.sortie,0) AS NUMBER(30,5))  as montantEnvoye,
    CAST(nvl(m.entree,0) AS NUMBER(30,5))  as recu ,
    CAST(nvl(td.pu,0)*nvl(m.entree,0) AS NUMBER(30,5))  as montantRecu,
    CAST(nvl(m.sortie,0) - nvl(m.entree,0) AS NUMBER(30,5))  as ecart,
    CAST(nvl(td.pu,0)*CAST(nvl(m.sortie,0) - nvl(m.entree,0) AS NUMBER(30,5)) AS NUMBER(30,5))  as montantEcart ,
    CAST(nvl(td.quantite,0) - nvl(m.sortie,0) AS NUMBER(30,5))  as reste
FROM transfertstockdetailscpl td
         LEFT JOIN transfertstockcpl t ON t.id = td.idtransfertstock
         LEFT JOIN mvtstockfilletransfert m ON m.idtransfertdetail = td.id;


UPDATE MENUDYNAMIQUE
SET HREF='module.jsp?but=stock/transfertstock/anomalie-liste.jsp'
WHERE ID='MENDYN1773382834579104';
