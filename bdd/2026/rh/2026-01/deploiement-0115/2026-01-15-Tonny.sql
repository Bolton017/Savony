CREATE OR REPLACE VIEW EFFECTIF_LOG_PERSONNEL AS
SELECT
    CASE
        WHEN sexe = 'Masculin' THEN 'Masculin'
        WHEN sexe = 'Feminin' THEN 'Feminin'
        ELSE 'Non d&eacute;fini'
        END AS sexe,
    COUNT(*) AS nombre,
    idCategorie,
    idCategorieLib,
    IDDEPARTEMENT AS idDepartement,
    departementLib
FROM LOG_PERSONNEL_GRAPHE
GROUP BY
    CASE
        WHEN sexe = 'Masculin' THEN 'Masculin'
        WHEN sexe = 'Feminin' THEN 'Feminin'
        ELSE 'Non d&eacute;fini'
        END,
    idCategorie,
    idCategorieLib,
    IDDEPARTEMENT,
    departementLib;

INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1768479181422720', 'Analyse', 'bar_chart', '', 6, 3, 'ELM000633');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1768479207973790', 'Effectif personnel', 'show_chart', 'module.jsp?but=paie/employe/analyse/effectif-personnel.jsp', 1, 4, 'MENDYN1768479181422720');

CREATE OR REPLACE VIEW SUM_HS_MONTH_LIB AS
SELECT
    EXTRACT(YEAR FROM dateFabrication) AS annee,
    EXTRACT(MONTH FROM dateFabrication) AS mois,
    TO_CHAR(dateFabrication, 'Month YYYY', 'NLS_DATE_LANGUAGE=FRENCH') AS monthLib,
    SUM(HS) AS avg_hs_per_month,
    IDDEPARTEMENT,
    departementLib
FROM HEURESUPFABRICATION_CPL
GROUP BY
    EXTRACT(YEAR FROM dateFabrication),
    EXTRACT(MONTH FROM dateFabrication),
    TO_CHAR(dateFabrication, 'Month YYYY', 'NLS_DATE_LANGUAGE=FRENCH'),
    IDDEPARTEMENT,
    departementLib
ORDER BY
    annee,
    mois;


CREATE OR REPLACE VIEW VIEW_VIDE_SOMME AS
SELECT
    CAST(NULL AS VARCHAR2(50)) AS id,
    CAST(NULL AS VARCHAR2(50)) AS idDepartement,
    CAST(NULL AS VARCHAR2(50)) AS idTypeSomme
FROM dual
WHERE 1 = 0;

create table typeSomme (
    id varchar(50) primary key ,
    val varchar(255),
    desce varchar(255)
);

INSERT INTO TYPESOMME values ('TS1', 'Par Jour', 'Par Jour');
INSERT INTO TYPESOMME values ('TS2', 'Par Mois', 'Par Mois');
INSERT INTO TYPESOMME values ('TS3', 'Par Annee', 'Par Annee');

INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1768485583329927', 'Moyenne HS', 'pie_chart', 'module.jsp?but=paie/employe/analyse/somme-hs.jsp', 2, 4, 'MENDYN1768479181422720');


