-- creatino sequence OF
create sequence seqofab
    minvalue 1
    maxvalue 999999999999
    start with 1
    increment by 1
    cache 20;

-- fonction maka ilay sequence OF
CREATE OR REPLACE FUNCTION getseqofab
   RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
SELECT seqofab.NEXTVAL INTO retour FROM DUAL;

RETURN retour;
END;

-- creatino sequence OFFILLE
create sequence seqoffille
    minvalue 1
    maxvalue 999999999999
    start with 1
    increment by 1
    cache 20;

-- fonction maka ilay sequence OFFILLE
CREATE OR REPLACE FUNCTION getseqoffille
   RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
SELECT seqoffille.NEXTVAL INTO retour FROM DUAL;

RETURN retour;
END;