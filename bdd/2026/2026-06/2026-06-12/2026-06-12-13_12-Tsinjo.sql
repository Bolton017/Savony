CREATE TABLE historiquevalidationdmdachat(
                                             id varchar2(255) PRIMARY KEY,
                                             idDmdAchat varchar2(255),
                                             refuser varchar2(255),
                                             nomUser varchar2(255),
                                             daty DATE,
                                             heure varchar2(255)
);

CREATE SEQUENCE seqhistoriquevalidationdmd INCREMENT BY 1 MINVALUE 1 MAXVALUE 999999999999999999999999999 NOCYCLE CACHE 20 NOORDER ;

create FUNCTION getseqhistoriquevalidationdmd
    RETURN NUMBER
        IS
           retour   NUMBER;
BEGIN
SELECT seqhistoriquevalidationdmd.NEXTVAL INTO retour FROM DUAL;
RETURN retour;
END;