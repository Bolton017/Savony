-- 1. Création de la table VALIDATION_ROLE
create table VALIDATION_ROLE(
    id varchar(255) primary key not null,
    refobject varchar(255),
    mapping varchar(255),
    niveau int,
    role varchar(255) references ROLES (IDROLE),
    personne varchar(255),
    valeuretat int
);
/

-- 2. Création de la Séquence
CREATE SEQUENCE seq_validation_role
    MINVALUE 1
    MAXVALUE 999999999999999999999999999
    START WITH 1
    INCREMENT BY 1;
/

-- 3. Création de la fonction pour récupérer la valeur suivante de la séquence
create or replace FUNCTION GETSEQVALIDATIONROLE
  RETURN NUMBER IS
  retour NUMBER;
BEGIN
SELECT seq_validation_role.nextval INTO retour FROM dual;
return retour;
END;
/

-- 4. Création de la vue compagnon
create or replace view VALIDATION_ROLE_LIB_CPL as
select
    vr.*,
    u.NOMUSER,
    r.DESCROLE
from
    VALIDATION_ROLE vr
left join UTILISATEUR u on u.REFUSER = vr.personne
left join ROLES r on r.IDROLE = vr.role;
/

-- 5. Configuration des rôles de validation pour faturefournisseur.DmdAchat
-- Rôles : cheffab (niveau 1, etat 3), respachat (niveau 2, etat 4), cg (niveau 3, etat 9), dg (niveau 4, etat 11)
INSERT INTO VALIDATION_ROLE (ID, REFOBJECT, MAPPING, NIVEAU, ROLE, PERSONNE, VALEURETAT) 
VALUES ('VDMDAC0001', null, 'faturefournisseur.DmdAchat', 1, 'cheffab', '*', 3);

INSERT INTO VALIDATION_ROLE (ID, REFOBJECT, MAPPING, NIVEAU, ROLE, PERSONNE, VALEURETAT) 
VALUES ('VDMDAC0002', null, 'faturefournisseur.DmdAchat', 2, 'respachat', '*', 4);

--insert CG
INSERT INTO ROLES (IDROLE, DESCROLE, RANG)
VALUES ('cg', 'CG', 3);


INSERT INTO VALIDATION_ROLE (ID, REFOBJECT, MAPPING, NIVEAU, ROLE, PERSONNE, VALEURETAT) 
VALUES ('VDMDAC0003', null, 'faturefournisseur.DmdAchat', 3, 'cg', '*', 9);


INSERT INTO VALIDATION_ROLE (ID, REFOBJECT, MAPPING, NIVEAU, ROLE, PERSONNE, VALEURETAT) 
VALUES ('VDMDAC0004', null, 'faturefournisseur.DmdAchat', 4, 'dg', '*', 11);
/




