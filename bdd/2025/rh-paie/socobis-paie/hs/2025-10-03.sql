create or replace view RESSOURCEPARFABRICATIONCOMPLET as
SELECT
    r.id,
    r.idFabrication,
    r.idPoste AS idPosteDefaut,
    r.idRessource,
    p.matricule,
    f.IDOF,
    r.etat,
    p.TEMPORAIRE,
    p.IDQUALIFICATION AS IdQualification,
    c.IDCATEGORIE,
    c.idPoste,
    po.VAL AS idPostelib,
    p.IDQUALIFICATION AS IdQualificationEffective,
    CAST(c.montant / ((40 * 52) / 12) AS NUMBER(30,2)) AS tauxhoraire,
    h.HS,
    h.MN,
    h.JF,
    h.HD,
    h.IF,
    CASE
        WHEN r.etat = 0  THEN 'ANNULEE'
        WHEN r.etat = 1  THEN 'CREE'
        WHEN r.etat = 11 THEN 'VISEE'
        END AS etatlib,
    p.MATRICULE AS idRessourcelib
FROM ressourceParFabrication r
         LEFT JOIN PAIE_INFO_PERSONNEL p
                   ON p.id = r.idRessource
         LEFT JOIN CATEGORIE_QUALIFICATION c
                   ON c.IDQUALIFICATION = r.IDQUALIFICATION AND c.IDCATEGORIE = p.IDCATEGORIE_PAIE
                       AND (
                          (c.REMARQUE IS NULL)
                              OR (c.REMARQUE = r.IDRESSOURCE)
                          )
         LEFT JOIN FABRICATION f
                   ON f.id = r.idFabrication
         LEFT JOIN heureSupFabrication h
                   ON h.idRessParFab = r.id
         LEFT JOIN POSTE po
                   ON po.id = c.idPoste;



create or replace view HEURESUPFABRICATION_CPL as
SELECT
    h.ID,h.IDRESSPARFAB,h.HEURENORMALE ,h.HS,h.MN,h.JF,h.HD,h.IF,h.ETAT,h.REMARQUE,
    p.id AS  idPersonne,
    h.idFabrication,
    fab.daty as dateFabrication,
    CASE
        WHEN h.etat=0
            THEN 'ANNULEE'
        WHEN h.etat=1
            THEN 'CREE'
        WHEN h.etat=11
            THEN 'VISEE'
        END AS etatlib,
    pm.NOM || ' ' || pm.PRENOM AS idPersonnelib,
    p.MATRICULE,
    r.TAUXHORAIRE,
    CAST(nvl(c.montant,0)/((40*52)/12) AS NUMBER(30,2) ) AS TAUXHORAIREEFFECTIVE,
    p.temporaire,
    h.MONTANT,
    h.MONTANTJFHD
FROM HEURESUPFABRICATION h
         LEFT JOIN RESSOURCEPARFABRICATIONCOMPLET r ON r.id = h.IDRESSPARFAB
         LEFT JOIN PAIE_INFO_PERSONNEL p ON p.id = r.idRessource
         LEFT JOIN CATEGORIE_QUALIFICATION c
                   ON c.IDQUALIFICATION = r.IDQUALIFICATION
                       AND c.IDCATEGORIE = r.IDCATEGORIE
                       AND (
                          (c.REMARQUE IS NULL)
                              OR (c.REMARQUE = r.IDRESSOURCE)
                          )
         LEFT JOIN LOG_PERSONNEL pm ON pm.id = r.IDRESSOURCE
         LEFT JOIN FABRICATION fab ON fab.ID = h.IDFABRICATION;

create or replace view HEURESUPFABRICATION_CUMUL as
SELECT
    p.id AS idPersonne,
    pm.NOM AS idPersonnelib,
    p.MATRICULE,
    TO_CHAR(fab.daty, 'IYYY-IW') AS semaine,
    fab.daty AS jour,
    SUM(h.HS) AS heureJour,
    SUM(SUM(h.HS)) OVER (
        PARTITION BY p.id, TO_CHAR(fab.daty, 'IYYY-IW')
        ORDER BY fab.daty
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) - SUM(h.HS) AS heureDejaCumulees
FROM HEURESUPFABRICATION h
         LEFT JOIN RESSOURCEPARFABRICATIONCOMPLET r ON r.id = h.IDRESSPARFAB
         LEFT JOIN PAIE_INFO_PERSONNEL p ON p.id = r.idRessource
         LEFT JOIN PERSONNEL_MATRICULE pm ON pm.id = r.IDRESSOURCE
         LEFT JOIN FABRICATION fab ON fab.ID = h.IDFABRICATION
GROUP BY p.id, pm.NOM, p.MATRICULE, fab.daty;


create or replace view HEURESUPFABRICATION_CPL as
SELECT
    h.ID,h.IDRESSPARFAB,h.HEURENORMALE ,h.HS,h.MN,h.JF,h.HD,h.IF,h.ETAT,h.REMARQUE,
    p.id AS  idPersonne,
    h.idFabrication,
    fab.daty as dateFabrication,
    CASE
        WHEN h.etat=0
            THEN 'ANNULEE'
        WHEN h.etat=1
            THEN 'CREE'
        WHEN h.etat=11
            THEN 'VISEE'
        END AS etatlib,
    pm.NOM || ' ' || pm.PRENOM AS idPersonnelib,
    p.MATRICULE,
    r.TAUXHORAIRE,
    CAST(nvl(c.montant,0)/((40*52)/12) AS NUMBER(30,2) ) AS TAUXHORAIREEFFECTIVE,
    p.temporaire,
    h.MONTANT,
    h.MONTANTJFHD
FROM HEURESUPFABRICATION h
         LEFT JOIN RESSOURCEPARFABRICATIONCOMPLET r ON r.id = h.IDRESSPARFAB
         LEFT JOIN PAIE_INFO_PERSONNEL p ON p.id = r.idRessource
         LEFT JOIN CATEGORIE_QUALIFICATION c
                   ON c.IDQUALIFICATION = r.IDQUALIFICATION
                       AND c.IDCATEGORIE = r.IDCATEGORIE
                       AND (
                          (c.REMARQUE IS NULL)
                              OR (c.REMARQUE = r.IDRESSOURCE)
                          )
         LEFT JOIN LOG_PERSONNEL pm ON pm.id = r.IDRESSOURCE
         LEFT JOIN FABRICATION fab ON fab.ID = h.IDFABRICATION;