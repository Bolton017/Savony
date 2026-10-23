INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1765357174546422', 'Période de paie', 'fa fa-street-view', '', 7, 2, 'ELM000010');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1765357238059192', 'Saisie', 'fa fa-plus', 'module.jsp?but=paie/editions/periodepaie-saisie.jsp', 1, 3, 'MENDYN1765357174546422');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1765357253765670', 'Liste', 'fa fa-list', 'module.jsp?but=paie/editions/periodepaie-liste.jsp', 2, 3, 'MENDYN1765357174546422');

-- script pour l'usermenu

DELETE FROM usermenu WHERE id = 'USRM007'; -- 1 rows
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM78036263', 'ELM000010', '*', NULL, 0);

create table HSMOIS
(
    ID            VARCHAR2(50)
        primary key,
    IDCATEGORIE   VARCHAR2(50),
    MOIS          NUMBER(2),
    ANNEE         NUMBER(4),
    DATY          DATE,
    IDDEPARTEMENT VARCHAR2(50),
    ETAT          NUMBER(2)
);

create sequence seqHsMois;

create or replace function getSeqHsMois return NUMBER is 
    retour NUMBER;
begin
    select seqHsMois.nextval
    into retour
    from dual;
    
    return retour;
end;