create table tarif_ingredients(
    id varchar(255) primary key ,
    idtypeclient references typeclient,
    idingredient references as_ingredients,
    daty date,
    prixunitaire number(10,2)
);

create sequence seq_tarif_ingredients
    start with 1
    increment by 1
    nomaxvalue
    nocycle;

CREATE OR REPLACE FUNCTION getSeqTarifIngredients
   RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
SELECT seq_tarif_ingredients.NEXTVAL INTO retour FROM DUAL;

RETURN retour;
END;

CREATE OR REPLACE VIEW tarif_ingredients_lib as
SELECT
    ti.* ,
    t.VAL AS idtypeclientlib,
    ai.LIBELLE AS idingredientlib
FROM
    TARIF_INGREDIENTS ti
LEFT JOIN
        TYPECLIENT t
ON ti.IDTYPECLIENT = t.ID
LEFT JOIN
        AS_INGREDIENTS ai
ON ti.IDINGREDIENT = ai.ID ;

ALTER TABLE CLIENT ADD idTypeClient varchar2(255);

ALTER TABLE client ADD CONSTRAINT fk_client_typeClient FOREIGN KEY (idTypeClient) REFERENCES typeClient(id);

CREATE OR REPLACE VIEW clientLib as
SELECT
    c.*,
    t.val AS idTypeClientLib
FROM CLIENT c
LEFT JOIN typeclient t
ON c.idTypeClient = t.id;