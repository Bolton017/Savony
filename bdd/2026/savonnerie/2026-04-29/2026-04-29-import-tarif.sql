CREATE SEQUENCE seqimportprix
    MINVALUE 1
    MAXVALUE 999999999999999999999999999
    START WITH 1
    INCREMENT BY 1;

-- procedure
create or replace FUNCTION GETseqimportprix
    RETURN NUMBER IS
    retour NUMBER;
BEGIN
    SELECT seqimportprix.nextval INTO retour FROM dual;
    return retour;
END;


CREATE SEQUENCE seqimportprixdetails
    MINVALUE 1
    MAXVALUE 999999999999999999999999999
    START WITH 1
    INCREMENT BY 1;

-- procedure
create or replace FUNCTION GETseqimportprixdetails
    RETURN NUMBER IS
    retour NUMBER;
BEGIN
    SELECT seqimportprixdetails.nextval INTO retour FROM dual;
    return retour;
END;


create  table importprix(
                            id varchar2(20) primary key,
                            DATY         DATE,
                            desce varchar2(255)
);

create  table importprixDetails(
                                   ID           VARCHAR2(255) not null
                                       primary key,
                                   IDTYPECLIENT VARCHAR2(100)
                                       references TYPECLIENT,
                                   IDINGREDIENT VARCHAR2(50)
                                       references AS_INGREDIENTS,
                                   DATY         DATE,
                                   PRIXUNITAIRE NUMBER(10, 2),
                                   UNITE        VARCHAR2(100),
                                   IDMERE       VARCHAR2(255)
                                       references importprix
);
