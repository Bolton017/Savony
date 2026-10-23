
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MNDN00110901146001', 'Demande d`Achat', 'fa fa-line-chart', null, 5, 2, 'MNDN000000002');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MNDN00110901146002', 'Saisie', 'fa fa-plus', 'module.jsp?but=facturefournisseur/dmdachat/dmdachat-saisie.jsp', 1, 3, 'MNDN00110901146001');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MNDN00110901146003', 'Liste', 'fa fa-list', 'module.jsp?but=facturefournisseur/dmdachat/dmdachat-liste.jsp', 2, 3, 'MNDN00110901146001');

create table DMDACHAT
(
    ID          VARCHAR2(50) not null
        primary key,
    DATY        DATE,
    FOURNISSEUR VARCHAR2(50)
        constraint DMDACHAT_FRNS_FK
            references FOURNISSEUR,
    REMARQUE    VARCHAR2(255),
    ETAT        NUMBER
)
/

create table DMDACHATFILLE
(
    ID          VARCHAR2(50) not null
        primary key,
    IDMERE      VARCHAR2(50)
        constraint DMDACHAT_MEREFILLE_FK
            references DMDACHAT,
    IDPRODUIT   VARCHAR2(50)
        constraint DMDACHATFILLE_PROD_FK
            references AS_INGREDIENTS,
    DESIGNATION VARCHAR2(255),
    QUANTITE    NUMBER(20, 2),
    PU          NUMBER(20, 2),
    TVA         NUMBER(20, 2),
    QTESTOCK    NUMBER(30, 3)
)
/

create view DMDACHATLIB as
SELECT
    da.id,
    da.daty,
    da.fournisseur,
    f.nom AS fournisseurlib,
    da.remarque,
    da.etat,
    CASE
        WHEN da.ETAT = 0
            THEN 'ANNUL&Eacute;(E)'
        WHEN da.ETAT = 1
            THEN 'CR&Eacute;&Eacute;(E)'
        WHEN da.ETAT = 11
            THEN 'VIS&Eacute;(E)'
        END AS etatlib
FROM DMDACHAT da
         LEFT JOIN FOURNISSEUR f ON f.ID = da.fournisseur
/

create sequence SEQ_DMDACHAT
/



create FUNCTION GETSEQDMDACHAT
    RETURN NUMBER IS
    retour NUMBER;
BEGIN
    SELECT SEQ_DMDACHAT.nextval INTO retour FROM dual;
    return retour;
END;
/

create sequence SEQ_DMDACHATFILLE
/


create FUNCTION GETSEQDMDACHATFILLE
    RETURN NUMBER IS
    retour NUMBER;
BEGIN
    SELECT SEQ_DMDACHATFILLE.nextval INTO retour FROM dual;
    return retour;
END;
/

INSERT INTO CAISSE (ID, VAL, DESCE, IDTYPECAISSE, IDPOINT, IDPOMPISTE, ETAT, IDCATEGORIECAISSE, COMPTE, IDMAGASIN, IDDEVISE) VALUES ('CAIS001', '-', '-', 'TCA001', null, null, 11, 'CTC001', '5300000000000', null, 'AR');
update caisse set IDPOINT = 'PNT000084' where IDPOINT is null;





create sequence SEQ_MVTINTRACAISSE_FILLE
    maxvalue 999999999999999
/


create FUNCTION get_mvtintracaisse_fille
    RETURN NUMBER IS
    retour NUMBER;
BEGIN
    SELECT seq_mvtintracaisse_fille.nextval INTO retour FROM dual;
    return retour;
END;
/

create view MVTINTRACAISSE_LIB as
select mv.id,
       daty,
       mv.CAISSEDEPART  as caissedepartlib,
       mv.CAISSEARRIVEE as caissearriveelib,
       ca.VAL as caissedepart,
       ca1.VAL as caissearrivee,
       montant,
       mp.VAL as modepaiement,
       remarque,
       etat ,
       mv.designation
from mvtintracaisse mv
         left join CAISSE ca on ca.id=mv.caissedepart
         left join CAISSE ca1 on ca1.id=mv.caissearrivee
         left join MODEPAIEMENT mp on mp.id=mv.modepaiement
/


create view MVTINTRACAISSE_LIB_CREE as
select ID,DATY,CAISSEDEPART,CAISSEARRIVEE,MONTANT,MODEPAIEMENT,REMARQUE,ETAT
from mvtintracaisse_lib
where ETAT=1
/

create view MVTINTRACAISSE_LIB_VISEE as
select ID,DATY,CAISSEDEPART,CAISSEARRIVEE,MONTANT,MODEPAIEMENT,REMARQUE,ETAT
from mvtintracaisse_lib
where ETAT=11
/

create view MVTINTRACAISSE_LIBCOMPLET as
select mv.ID,mv.DATY,mv.CAISSEDEPART,mv.CAISSEARRIVEE,mv.MONTANT,mv.MODEPAIEMENT,mv.REMARQUE,mv.ETAT,
       ca.VAL  as caissedepartlib,
       ca1.VAL as caissearriveelib,
       mp.VAL  as modepaiementlib
from mvtintracaisse mv
         left join CAISSE ca on ca.id = mv.caissedepart
         left join CAISSE ca1 on ca1.id = mv.caissearrivee
         left join MODEPAIEMENT mp on mp.id = mv.modepaiement
/

create view MVTINTRACAISSETRAITE as
select
    mit.ID,mit.DATY,mit.CAISSEDEPART,mit.CAISSEARRIVEE,mit.MONTANT,mit.MODEPAIEMENT,mit.REMARQUE,mit.ETAT,mit.DESIGNATION,mit.IDTRAITE,mit.ETATVERSEMENT,mit.IDFINALEDESTINATION,
    t.daty as datetraite,
    t.dateecheance,
    t.montant as montanttraite
from MvtIntraCaisse mit
         left join Traite t on t.id = mit.idtraite
/

create view MVTINTRACAISSETRAITENONVERSEE as
SELECT
    mic.ID,mic.DATY,mic.CAISSEDEPART,mic.CAISSEARRIVEE,mic.MONTANT,mic.MODEPAIEMENT,mic.REMARQUE,mic.ETAT,mic.DESIGNATION,mic.IDTRAITE,mic.ETATVERSEMENT,mic.IDFINALEDESTINATION,
    t.DATEECHEANCE
from mvtintracaisse mic
         JOIN traite t on t.id = mic.idtraite
/

create view TRAITE_FCLIB as
SELECT t.IDTRAITE ,t.idFc AS idfact,t.code FROM TRAITE_FC t
/


create view TRAITELIB_GRP as
SELECT  IDTRAITE,LISTAGG(CODE , ';') WITHIN GROUP (ORDER BY CODE) AS CODE FROM TRAITE_FCLIB tf
GROUP BY IDTRAITE
/

create view MVTINTRACAISSETRAITEV as
SELECT
    mic.ID,mic.DATY,mic.CAISSEDEPART,mic.CAISSEARRIVEE,mic.MONTANT,mic.MODEPAIEMENT,mic.REMARQUE,mic.ETAT,mic.DESIGNATION,mic.IDTRAITE,mic.ETATVERSEMENT,mic.IDFINALEDESTINATION,
    t.Dateecheance,t.reference,t.tiers,t.CDCLT AS codeclient,
    c1.val AS caissedepartlib,
    c2.val AS caissearriveelib,
    m.Desce as modepaiementlib,
    case
        when mic.etat = 1 then 'CREE'
        when mic.etat >= 11 then 'VISE'
        else '' end                           as etatlib,
    case
        when mic.etatversement = -2 then 'encaissée'
        when mic.etatversement = 11 then 'versée'
        else '' end                           as etatversementlib,
    c3.val AS finaledestinationlib,
    grp.code AS facture
from mvtintracaisse mic
         JOIN traite_lib t on t.id = mic.idtraite
         LEFT JOIN CAISSE C1 on C1.id = mic.caissedepart
         LEFT JOIN CAISSE C2 on C2.id = mic.caissearrivee
         LEFT JOIN caisse C3 ON c3.id= mic.IDFINALEDESTINATION
         LEFT JOIN MODEPAIEMENT m on m.id = mic.modepaiement
         LEFT JOIN TRAITELIB_GRP grp ON mic.IDTRAITE = grp.idTraite
where mic.etatversement = 11 AND mic.IDTRAITE NOT IN (SELECT IDTRAITE FROM mvtintracaisse WHERE ETATVERSEMENT  = -2)
/
create view MVTINTRACAISSETRAITEVCAISSE as
SELECT
    mic.ID,
    mic.DATY,
    mic.CAISSEDEPART,
    mic.CAISSEARRIVEE,
    CAST(mic.MONTANT AS NUMBER(30,2)) AS MONTANT,
    mic.MODEPAIEMENT,
    mic.REMARQUE,
    mic.ETAT,
    mic.DESIGNATION,
    mic.IDTRAITE,
    mic.ETATVERSEMENT,
    mic.IDFINALEDESTINATION,
    t.DATEECHEANCE
FROM
    mvtintracaisse mic
        JOIN traite t ON
        t.id = mic.idtraite
WHERE
    mic.etatversement IN (11, -2)
/


create or replace view TRAITEMTTFC as
SELECT
    t.ID,
    cast(nvl(sum(f.montant),0) as number(30,2)) AS montantenlevetraite
FROM traite t
         LEFT JOIN LIAISONPAIEMENT f ON t.ID = f.ID2
GROUP BY t.ID
/

create view TRAITEMTTRESTE as
SELECT t.ID,
       t.DATY,
       t.TIERS,
       t.BANQUE,
       t.DATEECHEANCE,
       t.ETAT,
       CAST(nvl(t.MONTANT,0) AS NUMBER(30, 2))                          AS montant,
       t.ESCOMPTE,
       CAST(nvl(t.TOTAL,0) AS NUMBER(30, 2))                            AS total,
       t.REFERENCE,
       CAST((nvl(t.total,0) - nvl(tf.montantenlevetraite, 0)) AS NUMBER(30, 2)) AS montantreste,
       t.cdclt,
       t.idbanque,
       t.idtypepiece,
       t.typepiece,
       nvl(te.etatversement, 1)                                  as etatversement,
       case
           when te.etatversement = -2 then 'Encaissee'
           when te.etatversement = 11 then 'Versee'
           else
               'Non Versee' end                                  as etatversementlib
FROM TRAITE_LIBMTT t
         LEFT JOIN traitemttfc tf ON tf.id = t.id
         LEFT JOIN traiteetatversement te on te.IDTRAITE = t.ID
/

create or replace view VENTE_CPL as
SELECT v.ID,
       v.DESIGNATION,
       v.IDMAGASIN,
       m.VAL AS IDMAGASINLIB,
       v.DATY,
       v.REMARQUE,
       v.ETAT,
       CASE
           WHEN v.ETAT = 1 THEN 'CRÉÉE'
           WHEN v.ETAT = 11 THEN 'VISÉE'
           WHEN v.ETAT = 0 THEN 'ANNULÉE'
           END
             AS ETATLIB,
       v2.MONTANTTOTAL,
       v2.IDDEVISE,
       v.IDCLIENT,
       c.NOM AS IDCLIENTLIB,
       cast(V2.MONTANTTVA as number(30,2)) as MONTANTTVA,
       cast(V2.MONTANTTTC as number(30,2)) as montantttc,
       cast(V2.MONTANTTTCAR as number(30,2)) as MONTANTTTCAR,
       cast(nvl(mv.montant,0)-nvl(ACG.MONTANTPAYE, 0) AS NUMBER(30,2)) AS montantpaye,
       cast(V2.MONTANTTTC-nvl(mv.montant,0)-nvl(ACG.resteapayer_avr, 0) AS NUMBER(30,2)) AS montantreste,
       cast(nvl(ACG.MONTANTTTC_avr, 0) as number(30,2))  as avoir,
       v2.tauxDeChange AS tauxDeChange,v2.MONTANTREVIENT,cast((V2.MONTANTTTCAR-v2.MONTANTREVIENT) as number(20,2))  as margeBrute,
       v.IDRESERVATION,
       case when v.DATYPREVU is null then daty else V.DATYPREVU end as datyprevu,
       rf.REFERENCE as referencefacture,
       montantremise
FROM VENTE v
         LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT
         LEFT JOIN MAGASINPOINT m ON m.ID = v.IDMAGASIN
         JOIN VENTEMONTANT v2 ON v2.ID = v.ID
         LEFT JOIN LIAISONPAIEMENTTOTAL mv ON v.id=mv.id2
         LEFT JOIN AVOIRFCLIB_CPL_GRP ACG on ACG.IDVENTE = v.ID
         LEFT JOIN REFERENCEFACTURE rf ON rf.idfacture=v.Id
/

create or replace view VENTEMONTANT as
SELECT v.ID,
       cast(SUM ((1-nvl(vd.remise/100,0))*(NVL (vd.QTE, 0) * NVL (vd.PU, 0))) as number(30,2)) AS montanttotal,
       cast(SUM ((NVL (vd.QTE, 0) * NVL (vd.PU, 0))) - SUM ((1-nvl(vd.remise/100,0))*(NVL (vd.QTE, 0) * NVL (vd.PU, 0))) as number(30,2)) AS montantremise,
       cast(SUM ( (NVL (vd.QTE, 0) * NVL (vd.PuAchat, 0))) as number(30,2)) AS montanttotalachat,
       cast(SUM ((1-nvl(vd.remise/100,0))* (NVL (vd.QTE, 0) * NVL (vd.PU, 0))* (NVL (VD.TVA , 0))/100) as number(30,2)) AS montantTva,
       cast(SUM ((1-nvl(vd.remise/100,0))* (NVL (vd.QTE, 0) * NVL (vd.PU, 0))* (NVL (VD.TVA , 0))/100)+SUM ((1-nvl(vd.remise/100,0))* (NVL (vd.QTE, 0) * NVL (vd.PU, 0)))as number(30,2))  as montantTTC,
       NVL (vd.IDDEVISE,'AR') AS IDDEVISE,
       NVL(avg(vd.tauxDeChange),1 ) AS tauxDeChange,
       cast(SUM ( (1-nvl(vd.remise/100,0))*(NVL (vd.QTE, 0) * NVL (vd.PU, 0)*NVL(VD.TAUXDECHANGE,1) )* (NVL (VD.TVA , 0))/100)+SUM ((1-nvl(vd.remise/100,0))* (NVL (vd.QTE, 0) * NVL (vd.PU, 0)*NVL(VD.TAUXDECHANGE,1)))as number(30,2)) as montantTTCAR,
       cast(sum(vd.PUREVIENT*vd.QTE) as number(20,2)) as montantRevient  ,
       v.IDRESERVATION
FROM VENTE_DETAILS vd LEFT JOIN VENTE v ON v.ID = vd.IDVENTE
GROUP BY v.ID, vd.IDDEVISE,v.IDRESERVATION
/
