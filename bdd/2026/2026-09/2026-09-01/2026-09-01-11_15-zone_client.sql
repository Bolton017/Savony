INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1788249939713651', 'Zone client', 'place', 'module.jsp?but=client/zone/zone-liste.jsp', 7, 2, 'MNDN00000002111');

CREATE SEQUENCE seq_ZoneClient
    MINVALUE 1
    MAXVALUE 999999999999999999999999999
    START WITH 1
    INCREMENT BY 1;

-- procedure
create or replace FUNCTION GETSEQZoneClient
    RETURN NUMBER IS
    retour NUMBER;
BEGIN
SELECT seq_ZoneClient.nextval INTO retour FROM dual;
return retour;
END;

