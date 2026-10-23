create table TYPEATELIER
(
    ID    VARCHAR2(100) not null constraint TYPEATELIER_PK primary key,
    VAL   VARCHAR2(100) not null,
    DESCE VARCHAR2(100) not null
)

CREATE SEQUENCE seq_typeatelier
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE OR REPLACE FUNCTION getSeqTypeAtelier
RETURN NUMBER IS
BEGIN
RETURN seq_typeatelier.NEXTVAL;
END;

INSERT INTO SAVONNERIE0126.TYPEATELIER (ID, VAL, DESCE) VALUES ('TPA1', 'Production', 'Production');
INSERT INTO SAVONNERIE0126.TYPEATELIER (ID, VAL, DESCE) VALUES ('TPA2', 'Fabrication', 'Fabrication');

create or replace view AS_RECOFFVUE as
SELECT ar.ID,
       ar.IDINGREDIENTS,
       ar.UNITE,
       ar.QTEAV,
       ar.QUANTITE,
       ar.IDPRODUITS,
       ar.IDUNITE,
       ar.COMPOSE,
       ar.NIVEAU,
       ai.LIBELLE                AS libIngredients,
       cast(0 as number(30, 10)) as resteStock,
       ai.TYPESTOCK,
       ai.ATELIER
FROM AS_RECETTEOFFFABTABLE ar
LEFT JOIN AS_INGREDIENTS ai ON ai.id = ar.IDINGREDIENTS;

create or replace view AS_RECOFFVUERESTEST as
SELECT a.ID,
       a.IDINGREDIENTS,
       a.UNITE,
       a.QTEAV,
       a.QUANTITE,
       a.IDPRODUITS,
       a.IDUNITE,
       a.COMPOSE,
       a.NIVEAU,
       a.LIBINGREDIENTS,
       a.resteStock,
       CAST(nvl(a.QUANTITE, 0) - nvl(a.RESTESTOCK, 0) AS NUMBER(30, 10)) AS raf,
       a.TYPESTOCK,
       a.ATELIER
FROM as_recOffVue a;

create or replace view AS_RECOFFVUESTFAB as
SELECT a."ID",
       a."IDINGREDIENTS",
       a."UNITE",
       a."QTEAV",
       a."QUANTITE",
       a."IDPRODUITS",
       a."IDUNITE",
       a."COMPOSE",
       a."NIVEAU",
       a."LIBINGREDIENTS",
       a."RESTESTOCK",
       cast(a.RAF as number(30, 10)) as raf,
       nvl(f.FabEncours, 0)          AS FabEncours,
       a.TYPESTOCK,
       a.ATELIER
FROM as_recOffVueResteSt a
         LEFT JOIN FabricationEncours f ON f.IDINGREDIENTS = a.IDINGREDIENTS
order by niveau DESC


