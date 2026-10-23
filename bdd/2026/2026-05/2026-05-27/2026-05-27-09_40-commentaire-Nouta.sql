CREATE TABLE commentaireDemande (
    id VARCHAR(50) PRIMARY KEY,
    refuser INT,
    nomUser VARCHAR(100),
    daty DATE,
    commentaire VARCHAR(255)
);

ALTER TABLE commentaireDemande
ADD iddmdachat VARCHAR(100);

ALTER TABLE commentaireDemande
ADD CONSTRAINT fk_commentaireDemande_dmdachat
FOREIGN KEY (iddmdachat)
REFERENCES dmdachat(id);

CREATE sequence seqCommentaireDemande INCREMENT BY 1 MINVALUE 1 MAXVALUE 999999999999 NOCYCLE CACHE 20 NOORDER 
CREATE OR REPLACE FUNCTION get_seq_commentaireDemande
   RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
   SELECT seqCommentaireDemande.NEXTVAL INTO retour FROM DUAL;

   RETURN retour;
END; 

 
 
 
 
 