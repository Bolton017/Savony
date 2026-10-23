CREATE OR REPLACE VIEW "SOLDECONGE_PERS_CPL" AS
SELECT
    CAST(sum(nvl(m.PLUS,0)) AS NUMBER(30, 2)) AS droit ,
    CAST(sum(nvl(m.MOINS ,0)) AS NUMBER(30, 2)) AS congePris ,
    CAST(sum(nvl(m.PLUS,0)) - sum(nvl(m.MOINS ,0)) AS NUMBER(30, 2)) AS solde ,
    lp.NOM || ' ' || lp.PRENOM AS nomPersonnel,
    lp.ID ,
    pip.MATRICULE
FROM MOUVEMENTABSENCE m
         LEFT JOIN LOG_PERSONNEL lp ON lp.ID = m.IDPERSONNEL
         LEFT JOIN PAIE_INFO_PERSONNEL pip ON pip.id = lp.ID WHERE m.IDSOURCE ='TYP000004'
GROUP BY lp.NOM ,
         lp.PRENOM , lp.ID, pip.MATRICULE ;


