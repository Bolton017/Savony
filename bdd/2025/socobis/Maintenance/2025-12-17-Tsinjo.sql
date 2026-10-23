ALTER TABLE FACTUREFOURNISSEUR ADD idDmdAchat varchar(255);
ALTER TABLE FACTUREFOURNISSEUR ADD CONSTRAINT fk_iddmdachat_ff FOREIGN KEY (idDmdAchat) REFERENCES dmdAchat (id);

ALTER TABLE DMDACHAT ADD idObjet varchar(255);

INSERT INTO AS_INGREDIENTS
(ID, LIBELLE, SEUIL, UNITE, QUANTITEPARPACK, PU, ACTIF, PHOTO, CALORIE, DURRE, COMPOSE, CATEGORIEINGREDIENT, IDFOURNISSEUR, DATY, QTELIMITE, PV, LIBELLEVENTE, SEUILMIN, SEUILMAX, PUACHATUSD, PUACHATEURO, PUACHATAUTREDEVISE, PUVENTEUSD, PUVENTEEURO, PUVENTEAUTREDEVISE, ISVENTE, ISACHAT, COMPTE_VENTE, COMPTE_ACHAT, LIBELLEEXTACTE, TVA, FILEPATH, RESTE, TYPESTOCK, REFPOST, REFQUALIFICATION, IDCHAMBRE, ISPERISHABLE, PV2, IDFAMILLE, IDMAGASIN, PARFUMS)
VALUES('IGM000508', 'Service externe', 0, 'UNT00005', 0, 1, 0, NULL, 0, NULL, 1, 'CATM0001', NULL, TIMESTAMP '2025-07-31 00:00:00.000000', 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, '601100', '707110', NULL, 0, NULL, 0, 'CUMP', 'EX000041', 'QUAL0032', NULL, NULL, NULL, NULL, NULL, NULL);

CREATE OR REPLACE VIEW DMDACHATLIB AS
SELECT
    da.id,
    da.daty,
    da.fournisseur,
    f.nom AS fournisseurlib,
    da.remarque,
    da.dateLimite,
    m.val AS idMagasinLib,
    ci.val AS idCategorieLib,
    da.etat,
    CASE
        WHEN da.ETAT = 0
            THEN 'ANNUL&Eacute;(E)'
        WHEN da.ETAT = 1
            THEN 'CR&Eacute;&Eacute;(E)'
        WHEN da.ETAT = 11
            THEN 'VIS&Eacute;(E) par Directeur'
        WHEN da.ETAT = 3
            THEN 'VIS&Eacute;(E) par Chef de Fabrication'
        WHEN da.ETAT = 4
            THEN 'VIS&Eacute;(E) par Responsable achat'
        END AS etatlib,
    da.idObjet
FROM DMDACHAT da
         LEFT JOIN FOURNISSEUR f ON f.ID = da.fournisseur
         LEFT JOIN MAGASIN2 m ON da.idMagasin = m.ID
         LEFT JOIN categorieIngredient ci ON da.idCategorie = ci.id;

CREATE OR REPLACE VIEW FACTUREFOURNISSEURCPL_TRAVAUX AS
SELECT f.ID,
       f.IDFOURNISSEUR,
       f2.NOM  AS IDFOURNISSEURLIB,
       f.IDMODEPAIEMENT,
       m.VAL   AS IDMODEPAIEMENTLIB,
       f.DATY,
       f.DESIGNATION,
       f.DATEECHEANCEPAIEMENT,
       f.ETAT,
       CASE
           WHEN f.ETAT = 1
               THEN 'CREEE'
           WHEN f.ETAT = 0
               THEN 'ANNULEE'
           WHEN f.ETAT = 11
               THEN 'VISEE'
           END AS ETATLIB,
       f.REFERENCE,
       f.IDBC,
       f.IDMAGASIN,
       f.DEVISE,
       case
           when f.TAUX=0 then 1
           else f.TAUX
           end as taux,
       p.VAL   AS idMagasinLib,
       f3.IDDEVISE,
       cast(f3.MONTANTTVA as number(30,2)) as MONTANTTVA,
       CAST(f3.MONTANTTTC-f3.MONTANTTVA as number(30,2)) AS MONTANTHT,
       cast(f3.MONTANTTTC as number(30,2)) as montantttc,
       cast(f3.MONTANTTTC*f3.tauxdechange as number(30,2)) as MONTANTTTCAR,
       cast(nvl(mv.debit,0) AS NUMBER(30,2)) AS montantpaye,
       cast(f3.MONTANTTTC-nvl(mv.debit,0) AS NUMBER(30,2)) AS montantreste,
       cast(nvl(f3.tauxdechange,0) AS  NUMBER(30,2)) AS tauxdechange,
       prev.id as idPrevision,
       CASE
           WHEN f.estprevu=0 THEN 'NON'
           ELSE 'OUI'
           END
           AS estprevulib,
       f.IDOBJET,
       f.IDREF,
       f.IDTYPEFACTURE,
       tf.VAL as typefacture,
       f.numero,
       f.typeachat,
       t.id AS idTravaux
FROM FACTUREFOURNISSEUR f
         LEFT JOIN FOURNISSEUR f2 ON f2.ID = f.IDFOURNISSEUR
         LEFT JOIN MODEPAIEMENT m ON m.ID = f.IDMODEPAIEMENT
         LEFT JOIN MAGASIN p ON p.ID = f.IDMAGASIN
         JOIN FACTUREFOURNISSEURMONTANT f3 ON f.ID = f3.id
         LEFT JOIN mouvementcaisseGroupeFacture mv ON f.id=mv.IDORIGINE
         LEFT JOIN prevision prev ON prev.idfacture=f.id
         left join type_facture tf on tf.id = f.IDTYPEFACTURE
         LEFT JOIN dmdAchat d ON f.idDmdAchat = d.id
         LEFT JOIN TRAVAUX t ON d.idObjet = t.id;

ALTER TABLE TRAVAUX
    MODIFY dureeestimatif NUMBER(10,2);

CREATE OR REPLACE VIEW V_DUREE_REELLE_TRAVAUX AS
SELECT
    p.REFOBJET,
    p.OBJET,
    p.ACTION,
    p.DATEHISTORIQUE,
    p.HEURE,
    CASE
        WHEN p.HEURE IS NOT NULL THEN
                TO_NUMBER(SUBSTR(p.HEURE, 1, INSTR(p.HEURE, ':') - 1)) +
                (TO_NUMBER(SUBSTR(p.HEURE, INSTR(p.HEURE, ':') + 1)) / 60)
        ELSE NULL
        END AS DUREE_HEURES_DECIMALE,
    p.ECART
FROM PROCESS p
WHERE p.REFOBJET IS NOT NULL;

CREATE OR REPLACE VIEW V_DUREE_AGREGEE_TRAVAUX AS
SELECT
    REFOBJET,
    SUM(DUREE_HEURES_DECIMALE) AS DUREE_REELLE_TOTAL_HEURES,
    MAX(ECART) AS ECART_ENREGISTRE
FROM V_DUREE_REELLE_TRAVAUX
GROUP BY REFOBJET;

CREATE OR REPLACE VIEW V_DUREE_TRAVAUX_MACHINE AS
SELECT
    CASE
        WHEN aim.id IS NULL THEN ai.id
        ELSE aim.id
        END AS idIngredients,
    CASE
        WHEN aim.libelle IS NULL THEN ai.descriptionObjet
        ELSE aim.libelle
        END AS DESCRIPTIONOBJET,
    t.DATY,
    t.ID AS ID_TRAVAUX,
    NVL(t.DUREEESTIMATIF, 0) AS DUREE_ESTIMATIVE_HEURES,
    COALESCE(vd.DUREE_REELLE_TOTAL_HEURES, 0) AS DUREE_REELLE_HEURES,
    COALESCE(vd.DUREE_REELLE_TOTAL_HEURES, 0) - COALESCE (t.DUREEESTIMATIF, 0) AS ECART_HEURES,
    CASE
        WHEN t.DUREEESTIMATIF > 0 THEN
            ROUND(((COALESCE(vd.DUREE_REELLE_TOTAL_HEURES, 0) - t.DUREEESTIMATIF) / t.DUREEESTIMATIF) * 100, 2)
        ELSE NULL
        END AS ECART_POURCENTAGE,
    vd.ECART_ENREGISTRE
FROM ORDRETRAVAUXFILLE o
         LEFT JOIN AS_INGREDIENTS aim
                   ON o.IDINGREDIENTS = aim.ID
         LEFT JOIN as_ingredient_maintenance ai
                   ON o.IDINGREDIENTS = ai.ID
         JOIN TRAVAUX t
              ON o.id = t.IDOFFILLE
         LEFT JOIN V_DUREE_AGREGEE_TRAVAUX vd
                   ON vd.REFOBJET = t.ID;


CREATE OR REPLACE VIEW DureeTravauxMachine as
SELECT
    IDINGREDIENTS AS idMachine,
    DESCRIPTIONOBJET AS nomMachine,
    DATY,
    ID_TRAVAUX AS idTravaux,
    DUREE_ESTIMATIVE_HEURES AS DureeEstimatif ,
    DUREE_REELLE_HEURES as Duree ,
    ECART_HEURES AS ecart
FROM V_DUREE_TRAVAUX_MACHINE
ORDER BY DATY DESC;

CREATE OR REPLACE VIEW MOYENNETRAVAUXMACHINE AS
SELECT
    d.IDMACHINE,
    d.NOMMACHINE ,
    CAST (AVG(d.DUREEESTIMATIF) AS NUMBER(10, 2)) AS moyenneDureeEstimatif,
    CAST (AVG(d.DUREE) AS NUMBER(10, 2)) AS moyenneDuree,
    CAST (AVG(d.ECART) AS NUMBER(10, 2)) as moyenneEcart
FROM DUREETRAVAUXMACHINE d
GROUP BY d.IDMACHINE, d.NOMMACHINE ;

CREATE OR REPLACE VIEW TempsMoyenPannes AS
WITH ECARTS AS (
    SELECT
        CASE
            WHEN ai.id IS NULL THEN aim.id
            ELSE ai.id
        END AS idMachine,
        CASE
            WHEN ai.libelle IS NULL THEN aim.descriptionObjet
            ELSE ai.libelle
        END AS nomMachine,
        t.ID AS IDTRAVAUX,
        t.DATY,
        NVL(
            t.DATY - LAG(t.DATY) OVER (PARTITION BY o.IDINGREDIENTS ORDER BY t.DATY),
            0
        ) AS ECART_JOURS
    FROM TRAVAUX t
    LEFT JOIN ORDRETRAVAUXFILLE o
        ON t.IDOFFILLE = o.ID
    LEFT JOIN as_ingredients ai
        ON o.IDINGREDIENTS = ai.id
    LEFT JOIN AS_INGREDIENT_MAINTENANCE aim
        ON o.IDINGREDIENTS = aim.id
)
SELECT *
FROM ECARTS;

CREATE OR REPLACE VIEW MoyennePannesTravaux AS
SELECT
    idMachine,
    nomMachine,
    cast (ROUND(AVG(ECART_JOURS), 2) as number(10,2)) AS ECARTJOURS
FROM TempsMoyenPannes
WHERE ECART_JOURS IS NOT NULL
GROUP BY idMachine, nomMachine;

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MEND00220305056507', 'Moyenne de travaux par Machine', 'list_alt', 'module.jsp?but=maintenance/analyse/moyenne-travaux.jsp', 7, 3, 'MNDNMT013425678978545');
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MEND00220305056508', 'Moyenne de panne par machine', 'list_alt', 'module.jsp?but=maintenance/analyse/moyenne-ecart-panne.jsp', 8, 3, 'MNDNMT013425678978545');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MEND00220305056509', 'Co&ucirc;t de Maintenance par Machine', 'list_alt', 'module.jsp?but=maintenance/analyse/cout-maintenance.jsp', 9, 3, 'MNDNMT013425678978545');

CREATE OR REPLACE VIEW coutsMaintenance AS
SELECT
    o.IDINGREDIENTS AS idMachine,
    aim.DESCRIPTIONOBJET AS nomMachine,
    l.ID AS IDLIGNE ,
    l.VAL AS IDLIGNELIB,
    tr.ID AS idTravaux,
    t.DATY ,
    CAST (tr.MONTANTTOTAL AS NUMBER(10,2)) AS CoutTotal
FROM TRAVAUX_RECAP tr
         LEFT JOIN TRAVAUX t
                   ON tr.id = t.ID
         LEFT JOIN ORDRETRAVAUXFILLE o
                   ON t.IDOFFILLE = o.id
         LEFT JOIN AS_INGREDIENT_MAINTENANCE aim
                   ON o.IDINGREDIENTS = aim.ID
         LEFT JOIN LIGNE l
                   ON aim.IDLIGNE = l.ID
WHERE o.IDINGREDIENTS IS NOT NULL ;

CREATE OR REPLACE VIEW tauxDisponibiliteMachine AS
SELECT
    m.IDMACHINE ,
    m.NOMMACHINE ,
    l.ID AS idLigne,
    l.VAL AS idLigneLib,
    CASE
        WHEN m2.ECARTJOURS != 0 AND m.MOYENNEDUREE !=0 THEN (m2.ECARTJOURS * 24)/((m2.ECARTJOURS * 24)/m.MOYENNEDUREE)
		ELSE 0
END AS TauxDisponibilite
FROM MOYENNETRAVAUXMACHINE m
LEFT JOIN MOYENNEPANNESTRAVAUX m2
ON m.IDMACHINE = m2.IDMACHINE
LEFT JOIN AS_INGREDIENT_MAINTENANCE aim
ON m.IDMACHINE = aim.ID
LEFT JOIN LIGNE l
ON aim.IDLIGNE = l.ID ;

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MEND00220305056510', 'Taux de disponibilit&eacute; par Machine', 'list_alt', 'module.jsp?but=maintenance/analyse/taux-disponibilite.jsp', 10, 3, 'MNDNMT013425678978545');