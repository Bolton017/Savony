CREATE SEQUENCE seqlieuClient
    MINVALUE 1
    MAXVALUE 999999999999999999999999999
    START WITH 1
    INCREMENT BY 1;

create or replace FUNCTION GETSEQLIEUCLIENT
    RETURN NUMBER IS
    retour NUMBER;
BEGIN
    SELECT seqlieuClient.nextval INTO retour FROM dual;
    return retour;
END;

CREATE table lieuClient (
                            id  VARCHAR2(250) not null primary key,
                            val varchar2(250),
                            desce varchar2(250),
                            idZone varchar2(250) constraint fk_lieuclient_zoneclient references zoneclient(id)
);