create sequence seqingmain
    minvalue 1
    maxvalue 999999999999
    start with 1
    increment by 1
    cache 20;

CREATE OR REPLACE FUNCTION GET_SEQ_ING_MAIN
    RETURN NUMBER
    IS
    retour NUMBER;
BEGIN
SELECT seqingmain.NEXTVAL INTO retour FROM DUAL;

RETURN retour;
END;