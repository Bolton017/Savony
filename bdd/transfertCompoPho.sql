create table AS_UNITE
(
    ID    VARCHAR2(50) not null
        constraint PK_ASUNITE
            primary key,
    VAL   VARCHAR2(250),
    DESCE VARCHAR2(250)
);

insert into AS_UNITE (ID, VAL, DESCE)
values  ('UNT00006', 'L', 'litre'),
        ('UNT00007', 'cm', 'cm'),
        ('UNT00001', 'g', 'gramme'),
        ('UNT00004', 'ml', 'ml'),
        ('UNT00005', 'unite', 'unite'),
        ('UNT00008', 'fatana', 'fatana'),
        ('UNT00009', 'seconde', 'seconde');

-- auto-generated definition
create table CATEGORIEINGREDIENT
(
    ID    VARCHAR2(100) not null
        primary key,
    VAL   VARCHAR2(100),
    DESCE VARCHAR2(100)
);


create table typeCATEGORIEINGREDIENT
(
    ID    VARCHAR2(100) not null
        primary key,
    VAL   VARCHAR2(100),
    DESCE VARCHAR2(100)
);

insert into typeCATEGORIEINGREDIENT (ID, VAL, DESCE) values  ('TCCIng1', 'biens', '671');
insert into typeCATEGORIEINGREDIENT (ID, VAL, DESCE) values        ('TCCIng2', 'services', '672');
insert into typeCATEGORIEINGREDIENT (ID, VAL, DESCE) values        ('TCCIng3', 'Divers', '673');



insert into CATEGORIEINGREDIENT (ID, VAL, DESCE) values  ('CIING', 'carburant', 'TCCIng1');
insert into CATEGORIEINGREDIENT (ID, VAL, DESCE) values        ('CIEPICE', 'mat chimique', 'TCCIng1');
insert into CATEGORIEINGREDIENT (ID, VAL, DESCE) values        ('CIHUILE', 'Epices', 'TCCIng1');
insert into CATEGORIEINGREDIENT (ID, VAL, DESCE) values        ('CIRIZ', 'Colorant', 'TCCIng1');
insert into CATEGORIEINGREDIENT (ID, VAL, DESCE) values        ('CILEG', 'Autres', 'TCCIng1');
insert into CATEGORIEINGREDIENT (ID, VAL, DESCE) values        ('CINET', 'Traitement Machine 1', 'TCCIng2');
insert into CATEGORIEINGREDIENT (ID, VAL, DESCE) values        ('CI013', 'Traitement Machine 2', 'TCCIng2');

create view CATEGORIEINGREDIENTLIB as select cat.id,cat.val,ti.val as DESCE from CATEGORIEINGREDIENT cat 
left join typeCATEGORIEINGREDIENT ti on cat.DESCE=ti.id;

create table AS_INGREDIENTS
(
    ID                  VARCHAR2(50) not null
        primary key,
    LIBELLE             VARCHAR2(250),
    SEUIL               NUMBER(10, 2),
    UNITE               VARCHAR2(100)
        references AS_UNITE,
    QUANTITEPARPACK     NUMBER(10, 2),
    PU                  NUMBER(10, 2),
    ACTIF               NUMBER(2) default 1,
    PHOTO               VARCHAR2(100),
    CALORIE             NUMBER(5, 2),
    DURRE               NUMBER(3),
    COMPOSE             NUMBER(8) default 0,
    CATEGORIEINGREDIENT VARCHAR2(100)
        references CATEGORIEINGREDIENT,
    IDFOURNISSEUR       VARCHAR2(100),
    DATY                DATE,
    QTELIMITE           NUMBER(30, 2),
    PV                  NUMBER(30,2) default 0,
    libelleVente        VARCHAR2(250)
);

create sequence seqIngredients;
create function getSeqIngredients return NUMBER is retour NUMBER;
begin
select
seqIngredients.nextval
into
retour
from
dual;
return retour;
end;
/

create or replace view AS_PRODUITS as select * from AS_INGREDIENTS where pv>0;
create or replace view as_ingredients_Non_Vente as select * from AS_INGREDIENTS where pv=0;

create table AS_RECETTE
(
    ID            VARCHAR2(50) not null
        primary key,
    IDPRODUITS    VARCHAR2(100),
    IDINGREDIENTS VARCHAR2(100)
        references AS_INGREDIENTS,
    QUANTITE      NUMBER(10, 3),
    UNITE         VARCHAR2(50)
);

create sequence seqRecette;
create function getSeqRecette return NUMBER is retour NUMBER;
begin
select
seqRecette.nextval
into
retour
from
dual;
return retour;
end;
/

create index IDXREC
    on AS_RECETTE (IDPRODUITS, IDINGREDIENTS);


create view AS_RECETTECOMPOSE as
select r."ID",r."IDPRODUITS",r."IDINGREDIENTS",r."QUANTITE",r."UNITE",ing.compose from as_recette r,as_ingredients ing
  where r.IDINGREDIENTS=ing.id;

  create view AS_INGREDIENTS_LIB as
SELECT ing.id,
          ing.LIBELLE,
          ing.SEUIL,
          au.VAL AS unite,
          ing.QUANTITEPARPACK,
          ing.pu,
          ing.ACTIF,
          ing.PHOTO,
          ing.CALORIE,
          ing.DURRE,
          ing.COMPOSE,
          cating.id AS IDCATEGORIEINGREDIENT ,
          catIng.VAL AS CATEGORIEINGREDIENT,
          ing.CATEGORIEINGREDIENT AS idcategorie,
          ing.idfournisseur,
          ing.daty,
            catIng.desce as bienOuServ
     FROM as_ingredients ing
          JOIN AS_UNITE AU ON ing.UNITE = AU.ID
          JOIN CATEGORIEINGREDIENTLIB catIng
             ON catIng.id = ing.CATEGORIEINGREDIENT;

create or replace view AS_RECETTE_LIBCOMPLET as
select rec."ID",rec."IDPRODUITS",rec."IDINGREDIENTS",rec."QUANTITE",ing."UNITE",
ing.LIBELLE as libelleingredient,
       ing2.libelle as libelleproduit,
un.id as idunite,
un.val as valunite,
ing.pu
from as_recette rec
left join as_ingredients ing on
ing.id=rec.idingredients
left join as_ingredients ing2 on
ing2.id=rec.IDPRODUITS
left join as_unite un on
un.id=ing.unite
order by rec.id asc;

create view RECETTEMONTANT as
select
rec."ID",rec."IDPRODUITS",rec."IDINGREDIENTS",rec."QUANTITE",rec."UNITE",
cast(0 as number(12,2)) as qteav,
cast(0 as number(12,2)) as qtetotal
from as_recette rec;

alter table AS_INGREDIENTS add seuilMin Number(30, 2);

alter table AS_INGREDIENTS add seuilmax number(30, 2);

alter table AS_INGREDIENTS add puAchatUsd number(30, 2);

alter table AS_INGREDIENTS add puAchatEuro Number(30, 2);

alter table AS_INGREDIENTS add puAchatAutreDevise number(30, 2);

alter table AS_INGREDIENTS add puVenteUsd number(30, 2);

alter table AS_INGREDIENTS add puVenteEuro number(30, 2);

alter table AS_INGREDIENTS add puVenteAutreDevise number(30, 2);

alter table AS_INGREDIENTS add isVente number(5);

alter table AS_INGREDIENTS add isAchat number(5);

alter table AS_INGREDIENTS add Compte_Vente Varchar2(100);
alter table AS_INGREDIENTS add compte_achat varchar2(100);

create or replace view AS_PRODUITS as select * from AS_INGREDIENTS where pv>0;

create or replace view PRODUIT_LIB as
SELECT p.ID,
       p.LIBELLE as val,
       p.LIBELLE as DESCE,
       '-' as IDTYPEPRODUIT,
       '-' AS IDTYPEPRODUITLIB,
       p.PU as PUACHAT,
       p.pv as PUVENTE,
       p.UNITE as idunite,
       u.VAL  AS IDUNITELIB,
       p.CATEGORIEINGREDIENT as IDCATEGORIE,
       c.VAL  AS IDCATEGORIELIB,
       '-'  AS IDSOUSCATEGORIELIB,
       p.seuilmin,
       p.seuilmax,
       p.puAchatUsd,
  	   p.puAchatEuro,
	   p.puAchatAutreDevise,
	   p.puVenteUsd,
	   p.puVenteEuro,
	   p.puVenteAutreDevise,
	   p.isvente,
	   p.isachat,
	   p.compte_vente,
	   p.compte_achat
FROM AS_INGREDIENTS p
         LEFT JOIN CATEGORIEINGREDIENT c ON c.ID = p.CATEGORIEINGREDIENT
         LEFT JOIN as_UNITE u ON u.ID = p.unite;

create or replace view PRODUIT_LIB_MGA as
SELECT
	   pl.ID,
       pl.VAL,
       pl.DESCE,
       pl.IDTYPEPRODUIT,
       pl.IDTYPEPRODUITLIB,
       pl.PUACHAT*1 AS  PUACHAT,
       pl.PUVENTE*1 AS PUVENTE,
       pl.IDUNITE,
       pl.IDUNITELIB,
       pl.IDCATEGORIE,
       pl.IDCATEGORIELIB,
       pl.IDSOUSCATEGORIELIB,
       pl.seuilmin,
       pl.seuilmax,
       pl.puAchatUsd,
  	   pl.puAchatEuro,
	   pl.puAchatAutreDevise,
	   pl.puVenteUsd,
	   pl.puVenteEuro,
	   pl.puVenteAutreDevise,
	   1 AS taux,
	   pl.isvente,
	   pl.compte_vente AS compte
FROM PRODUIT_LIB pl
WHERE pl.PUVENTE>0;

create table PROCESS
(
    IDHISTORIQUE   VARCHAR2(20) not null
        primary key,
    DATEHISTORIQUE DATE,
    HEURE          VARCHAR2(25),
    OBJET          VARCHAR2(100),
    ACTION         VARCHAR2(50),
    IDUTILISATEUR  NUMBER default 1,
    REFOBJET       VARCHAR2(255),
    ACTEUR         VARCHAR2(50),
    REMARQUE       VARCHAR2(150)
);

create table PERSONNEL
(
    ID        VARCHAR2(255) not null
        primary key,
    NOM       VARCHAR2(255),
    TELEPHONE VARCHAR2(255),
    MAIL      VARCHAR2(255),
    ADRESSE   VARCHAR2(255),
    REMARQUE  VARCHAR2(255),
    COMPTE    VARCHAR2(100)
);

insert into PERSONNEL values('PERS0001','Rabekoto','0344343556','george@gmail.com','VEMahamasina','rem1','OOOOO');
insert into PERSONNEL values('PERS0002','Alphonse mahery','0384343446','mahery@gmail.com','Andrefana','rem2','OOOOO');


create view PROCESSLIB as
select p.IDHISTORIQUE,p.DATEHISTORIQUE,p.HEURE,p.OBJET,p.ACTION,p.IDUTILISATEUR,p.REFOBJET,pers.NOM||' '||pers.TELEPHONE as acteur,p.REMARQUE from PROCESS p
left join PERSONNEL pers on p.acteur=pers.id;

create table OFab
(
    ID        VARCHAR2(255) not null
    primary key,
    lancePar       VARCHAR2(255) references point(id),
    cible VARCHAR2(255) references point(id),
    remarque      VARCHAR2(255),
    libelle   VARCHAR2(255),
    besoin  DATE,
    daty    DATE
);

create table OFFille
(
    ID        VARCHAR2(255) not null
    primary key,
    idingredients       VARCHAR2(255),
    libelle VARCHAR2(255),
    remarque      VARCHAR2(255),
    idMere   VARCHAR2(255) references ofab(id),
    datyBesoin  DATE,
    qte    NUMBER(20,2),
    idUnite varchar2(100)
);

create table fabrication
(
    ID        VARCHAR2(255) not null
    primary key,
    lancePar       VARCHAR2(255) references point(id),
    cible VARCHAR2(255) references point(id),
    remarque      VARCHAR2(255),
    libelle   VARCHAR2(255),
    besoin  DATE,
    daty    DATE,
    idOf varchar2(255)
);


create table FabricationFille
(
    ID        VARCHAR2(255) not null
    primary key,
    idingredients       VARCHAR2(255),
    libelle VARCHAR2(255),
    remarque      VARCHAR2(255),
    idMere   VARCHAR2(255) references fabrication(id),
    datyBesoin  DATE,
    qte    NUMBER(20,2),
    idUnite varchar2(100)
);

create or replace view as_recetteOf as select offi.id,offi.idMere as IDPRODUITS,offi.idingredients,
offi.qte*nvl(e.qte,1) as quantite,ing.unite,ing.compose from OFFille offi left join equivalence e 
on e.idproduit=offi.idingredients and e.idunite=offi.idunite
left join as_ingredients ing on ing.id=offi.idingredients;

create or replace view as_recetteFab as select offi.id,offi.idMere as IDPRODUITS,offi.idingredients,
offi.qte*nvl(e.qte,1) as quantite,ing.unite,ing.compose from FabricationFille offi left join equivalence e 
on e.idproduit=offi.idingredients and e.idunite=offi.idunite
left join as_ingredients ing on ing.id=offi.idingredients;

insert into OFab values('of1',null,null,'',null,null,null);
insert into OFFille values('offf1','PF0013',null,null,'of1',null,10,'UNT00001');



