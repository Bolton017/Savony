--Base socobispaie2111 :
--creer table
--ENFANTPERSONNEL
--id
--idPersonnel foreign key log_personnel
--nom
--dateNaissance
--genre number
--creer seq : getseqenfantpers

create table ENFANTPERSONNEL (
                                 id varchar(255) constraint ENFANTPERSONNEL_pk primary key,
                                 idPersonnel varchar(50) CONSTRAINT enfpers_log_fk REFERENCES LOG_PERSONNEL(id),
                                 nom varchar(255),
                                 dateNaissance DATE ,
                                 genre int
);


create sequence seqENFANTPERS
    minvalue 1
    maxvalue 999999999999
    start with 1
    increment by 1
    cache 20;



CREATE OR REPLACE FUNCTION getseqENFANTPERS
   RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
SELECT seqENFANTPERS.NEXTVAL INTO retour FROM DUAL;

RETURN retour;
END;

--creer vue :
--ENFANTPERSONNEL_CPL
--log.nom || ‘ ’ || log.prenom as nomPersonnel
--log.matricule
--age => alaina avy @ date de naissance
--* FROM ENFANTPERSONNEL
--LEFT JOIN LOG_PERSONNEL_V2 log on idpersonnel = log.id


CREATE VIEW ENFANTPERSONNEL_CPL
AS
SELECT
    e.*,
    log.nom ||' '|| log.prenom AS nomPersonnel,
    log.matricule,
    FLOOR(MONTHS_BETWEEN(SYSDATE, e.dateNaissance) / 12) AS age
FROM   ENFANTPERSONNEL e
           LEFT JOIN LOG_PERSONNEL_V2 log on idpersonnel = log.id ;



--Menu : creer menu dans GRH et Paie
--Gestion des éléments de paie
--icone : fa fa-folder
--Sous menu :
--Avance : icone : fa fa-money
--Saisie avance du 15
--but : paie/avance/paieperseltpaie-avance-saisie.jsp
--Liste avance du 15
--but :
--paie/avance/paieperseltpaie-avance-liste.jsp
--Indemnité diverse : fa fa-gift
--Saisie indemnité diverse
--but : paie/eltpaie/paieperseltpaie-indemnite-saisie.jsp
--Liste indemnité diverse
--but : paie/eltpaie/paieperseltpaie-indemnite-liste.jsp
--Dans GRH et paie => Gestion de la paie => Avance => Alana le menu Saisie avance


INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MD00021110001', 'Gestion des &eacute;l&eacute;ments de paie', 'fa fa-folder', NULL, 7, 2, 'ELM000010');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MD00021110002', 'Avance', 'fa fa-money', NULL, 1, 3, 'MD00021110001');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MD00021110003', 'Saisie avance du 15', 'fa fa-plus', 'module.jsp?but=paie/avance/paieperseltpaie-avance-saisie.jsp', 1, 4, 'MD00021110002');
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MD00021110004', 'Liste avance du 15', 'fa fa-list', 'module.jsp?but=paie/avance/paieperseltpaie-avance-liste.jsp', 2, 4, 'MD00021110002');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MD00021110005', 'Indemnit&eacute; diverse', 'fa fa-gift', NULL, 2, 3, 'MD00021110001');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MD00021110006', 'Saisie indemnit&eacute; diverse', 'fa fa-plus', 'module.jsp?but=paie/eltpaie/paieperseltpaie-indemnite-saisie.jsp', 1, 4, 'MD00021110005');
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MD00021110007', 'Liste indemnit&eacute; diverse', 'fa fa-list', 'module.jsp?but=paie/eltpaie/paieperseltpaie-indemnite-liste.jsp', 2, 4, 'MD00021110005');


UPDATE MENUDYNAMIQUE
SET ID_PERE='AMS006FAFANA'
WHERE ID='AMS010';

create or replace view PAIE_PERS_ELTPAIE_LIB_IND as
SELECT "ID",
       "MATRICULE",
       "CODE_RUBRIQUE",
       "CODE_RUBRIQUE",
       "DATE_DEBUT",
       "DATE_FIN",
       "GAIN",
       "RETENUE",
       "REMARQUE",
       "IDPERSONNEL",
       "ETAT",
       "ID_OBJET",
       "IDUSER",
       "MOISREGULARISATION",
       "ANNEEREGULARISATION",
       "IDCATEGORIE_QUALIFICATION",
       "IDFONCTION",
       "POURCENTAGE",
       -- Libellé du mois
       TO_CHAR(TO_DATE(pp.MOISREGULARISATION, 'MM'), 'MONTH', 'NLS_DATE_LANGUAGE=FRENCH')
           AS MOISREGULARISATIONLIB
FROM PAIE_PERS_ELTPAIE_LIB2 pp
WHERE pp.CODE_RUBRIQUE = 'PR000021';