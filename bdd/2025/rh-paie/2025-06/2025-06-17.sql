
CREATE OR REPLACE VIEW ASYNCRH.SOLDECONGEPRIS_PERS (ID, PLUS, CONGEPRIS, NOMPERSONNEL, MATRICULE, IDDIRECTION) AS
SELECT
    lp.ID_PERS AS ID,
    sum(nvl(m.PLUS,0)) AS plus ,
    sum(nvl(m.MOINS ,0)) AS congepris ,
    lp.nom || ' ' || lp.prenom AS nomPersonnel,
    lp.matricule AS matricule,
    lp.iddirection AS idDirection
FROM MOUVEMENTABSENCE m
         LEFT JOIN LOG_PERSONNEL_V2 lp ON lp.ID = m.IDPERSONNEL
GROUP BY lp.NOM ,
         lp.PRENOM , lp.ID_PERS, lp.matricule, lp.IDDIRECTION
;



CREATE SEQUENCE SEQ_XC INCREMENT BY 1 MINVALUE 1 MAXVALUE 999999999999 NOCYCLE CACHE 20 NOORDER ;

CREATE OR REPLACE FUNCTION GET_SEQXC
 RETURN NUMBER
IS
  retour NUMBER;
BEGIN
SELECT SEQ_XC.NEXTVAL into retour from dual;
RETURN retour;
END;


INSERT INTO MENUDYNAMIQUE (id, LIBELLE , icone, href, rang, niveau, ID_PERE) VALUES
    ('MD00000993003', 'Saisie Paie rubrique', 'fa fa-plus', 'module.jsp?but=paie/rubrique/paierubrique-saisie.jsp', 6, 3, 'MD00000003004');

UPDATE MENUDYNAMIQUE m SET HREF = 'module.jsp?but=paie/rubrique/paierubrique-liste.jsp' WHERE id = 'MD00000003003';
UPDATE MENUDYNAMIQUE m SET libelle = 'Paie rubrique liste' WHERE id = 'MD00000003003';