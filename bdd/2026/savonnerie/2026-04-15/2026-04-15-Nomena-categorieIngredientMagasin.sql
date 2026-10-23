CREATE TABLE categorieIngredientMagasin (
                                            id                    VARCHAR2(255) NOT NULL
                                                CONSTRAINT pk_categorieIngredientMagasin PRIMARY KEY,
                                            idMagasin             VARCHAR2(255) NOT NULL,
                                            idCategorieIngredient VARCHAR2(255) NOT NULL
);

CREATE SEQUENCE seq_CIM INCREMENT BY 1 MINVALUE 1 MAXVALUE 999999999999999999999999999 NOCYCLE NOCACHE NOORDER;

CREATE OR REPLACE FUNCTION get_seq_CIM
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT seq_CIM.NEXTVAL INTO retour FROM DUAL;

    RETURN retour;
END;

CREATE OR REPLACE VIEW v_categorieIngredientMaglib AS
SELECT
    cim.*,
    mp.VAL   AS idMagasinLib,
    ci.VAL   AS idCategorieIngredientLib

FROM categorieIngredientMagasin  cim
         INNER JOIN magasinPoint          mp  ON mp.id = cim.idMagasin
         INNER JOIN categorieIngredient   ci  ON ci.id = cim.idCategorieIngredient;

INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1776235029270401', 'Magasin', 'shopping_cart', '', 21, 1, NULL);
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1776235042876895', 'Saisie', 'add', 'module.jsp?but=categorieIngredientMagasin/categorieIngredient-saisie.jsp', 1, 2, 'MENDYN1776235029270401');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1776235059604679', 'Liste', 'view_list', 'module.jsp?but=categorieIngredientMagasin/categorieIngredient-liste.jsp', 2, 2, 'MENDYN1776235029270401');
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMECE24F7C', 'MENDYN1776235029270401', '*', NULL, 0);


