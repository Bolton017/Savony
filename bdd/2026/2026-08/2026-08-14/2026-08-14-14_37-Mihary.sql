insert into ROLES (IDROLE, DESCROLE, RANG)
values ('securite', 'Securite', 6);

insert into VALIDATION_ROLE (ID, REFOBJECT, MAPPING, NIVEAU, ROLE, PERSONNE, VALEURETAT)
values ('VDMDAC0006', NULL, 'faturefournisseur.As_BonDeLivraison', '1', 'securite', '*', '8');

insert into VALIDATION_ROLE (ID, REFOBJECT, MAPPING, NIVEAU, ROLE, PERSONNE, VALEURETAT)
values ('VDMDAC0007', NULL, 'faturefournisseur.As_BonDeLivraison', '2', 'respachat', '*', '11');

insert into UTILISATEUR (REFUSER, LOGINUSER, PWDUSER, NOMUSER, ADRUSER, TELUSER, IDROLE, IDSERVICE)
values ('980716', 'securite', 'paop', 'Securite', 'DIR42', null, 'securite', 73);

INSERT INTO PARAMCRYPT (ID, NIVEAU, CROISSANTE, IDUTILISATEUR) VALUES ('CRY009894', 4, 1, '980716');

INSERT INTO CNAPS_USER (ID, CODE_DR, USER_INIT, AGENT_MO, AGENT_DISPONIBLE, USERNAME, CODE_SERVICE, ID_UTILISATEUR) VALUES ('CNP0009431025', 'DIR00001', '1', '1', '1', 'Securite', '1', '980716');

create or replace view AS_BONDELIVRAISON_LIBMP as
select bl.ID,
       bl.REMARQUE,
       bl.IDBC,
       bl.DATY,
       bl.ETAT,
       bl.MAGASIN,
       m.VAL as MAGASINlib,
       case
           when bl.etat = 1 then 'CR&Eacute;&Eacute;(E)'
           when bl.etat = 8 then 'VIS&Eacute;(E) PAR S&Eacute;CURIT&Eacute;(E)'
           when bl.etat = 11 then 'VIS&Eacute;(E)'
           end as etatlib,
       bl.idfournisseur,
       f.nom AS idfournisseurlib,
       bl.IDFACTUREFOURNISSEUR
from AS_BONDELIVRAISON bl
         left join MAGASINPOINT m on bl.MAGASIN = m.ID
         LEFT JOIN fournisseur f ON f.id=bl.idfournisseur;