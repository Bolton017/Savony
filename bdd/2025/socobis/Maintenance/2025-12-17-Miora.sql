alter table motravaux rename column idpersonnel to logpersonnel;


  CREATE OR REPLACE VIEW MOTRAVAUXLIB ("ID", "logpersonnel", "DUREEESTIMATIF", "TAUXHORAIRE", "IDTRAVAUX", "DUREEESTIMATIFLIB", "MONTANT", "IDPERSONNELLIB") AS 
  SELECT
        mo."ID",mo."LOGPERSONNEL",mo."DUREEESTIMATIF",mo."TAUXHORAIRE",mo."IDTRAVAUX",
        LPAD(FLOOR(TO_NUMBER(mo.DUREEESTIMATIF) / 3600), 2, '0') || ':' ||
        LPAD(FLOOR(MOD(TO_NUMBER(mo.DUREEESTIMATIF), 3600) / 60), 2, '0') || ':' ||
        LPAD(MOD(TO_NUMBER(mo.DUREEESTIMATIF), 60), 2, '0')
            AS dureeEstimatifLib,
        ((mo.DUREEESTIMATIF/60)/60)*mo.TAUXHORAIRE AS montant,
        p.NOM AS idPersonnelLib
    FROM MOTRAVAUX mo
    LEFT JOIN PERSONNEL p ON p.ID = mo.logpersonnel