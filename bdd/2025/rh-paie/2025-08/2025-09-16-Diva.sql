INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES
('MNDN021', 'Paiement d''avance', 'fa fa-bank', '', 4, 4, 'AMS006');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES
    ('MNDN022', 'Saisie', 'fa fa-plus', 'module.jsp?but=paie/avance/paiementavance-saisie.jsp', 1, 5, 'MNDN021');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES
    ('MNDN023', 'Liste', 'fa fa-list', 'module.jsp?but=paie/avance/paiementavance-liste.jsp', 2, 5, 'MNDN021');


create or replace view PAIEMENTAVANCELIB as
SELECT
    pa.*,
    CASE
        WHEN pa.etat = 1 THEN 'CR&Eacute;E'
        WHEN pa.etat = 11 THEN 'VALID&Eacute;E'
        ELSE NULL
        END AS etatlib,
    TO_CHAR(
            TO_DATE(TO_CHAR(pa.mois, 'FM00'), 'MM'),
            'FMMonth',
            'NLS_DATE_LANGUAGE=FRENCH'
    ) AS moisLib,
    t.VAL AS typeavanceLib
FROM PAIEMENTAVANCE pa
         LEFT JOIN avance a ON a.id = pa.idavance
         LEFT JOIN typeavance t ON t.id = a.idtypeavance;



