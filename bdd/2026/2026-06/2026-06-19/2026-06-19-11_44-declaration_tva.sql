-- auto-generated definition
create table DECLARATIONTVA
(
    ID          VARCHAR2(100) not null
        primary key,
    DESIGNATION VARCHAR2(255),
    DATYDEBUT   DATE,
    DATYFIN     DATE,
    ETAT        NUMBER
);

create view DECLARATIONTVALIB as
SELECT
    de.id,
    de.designation,
    de.datyDebut,
    de.datyFin,
    de.etat,
    CASE
        WHEN de.etat = 1 THEN 'Cree'
        WHEN de.etat = 11 THEN 'Valide'
        ELSE 'Inconnu'
        END AS etatLib,
    nvl(mv.DEBIT,nvl(fd.MONTANTTTC,0)) as montantpayer,
    case
        when mv.IDORIGINE is null then case when fd.IDBC='CREDIT' then 'Reporté' else 'Non payé' end
        else 'Payé'
        END as payementLib
FROM DeclarationTVA de left join FACTUREDECLARATIONCPL fd on de.id=fd.IDOBJET left join mouvementcaisse mv on mv.IDORIGINE=fd.id;

CREATE SEQUENCE SeqDeclarationTva
    MINVALUE 1
    MAXVALUE 999999999999999999999999999
    START WITH 1
    INCREMENT BY 1;

-- procedure
create or replace FUNCTION getSeqDeclarationTva
    RETURN NUMBER IS
    retour NUMBER;
BEGIN
    SELECT SeqDeclarationTva.nextval INTO retour FROM dual;
    return retour;
END;

create view COMPTASOUSECRITUREDECLARER as
SELECT cse.ID,
       cse.NUMERO,
       cse.COMPTE,
       cse.JOURNAL,
       cse.IDJOURNAL,
       cse.ECRITURE,
       cse.DATY,
       cse.CREDIT,
       cse.DEBIT,
       cse.DATECOMPTABLE,
       cse.EXERCICE,
       cse.REMARQUE,
       cse.ETAT,
       cse.IDMERE,
       cse.HORSEXERCICE,
       cse.OD,
       cse.ORIGINE,
       cse.TIERS,
       cse.LIBELLEPIECE,
       cse.COMPTE_AUX,
       cse.RAISONSOCIAL,
       cse.FOLIO,
       cse.LETTRAGE,
       cse.ANALYTIQUE,
       csed.MOISDECLARATION,
       case
           when csed.MOISDECLARATION is null then 'non'
           when csed.MOISDECLARATION =1 then 'Janvier'
           when csed.MOISDECLARATION =2 then 'Fevrier'
           when csed.MOISDECLARATION =3 then 'Mars'
           when csed.MOISDECLARATION =4 then 'Avril'
           when csed.MOISDECLARATION =5 then 'Mai'
           when csed.MOISDECLARATION =6 then 'Juin'
           when csed.MOISDECLARATION =7 then 'Juillet'
           when csed.MOISDECLARATION =8 then 'Aout'
           when csed.MOISDECLARATION =9 then 'Septembre'
           when csed.MOISDECLARATION =10 then 'Octobre'
           when csed.MOISDECLARATION =11 then 'Novembre'
           when csed.MOISDECLARATION =12 then 'Decembre'
           else 'oui'
           END AS declaration
FROM COMPTA_SOUSECRITURE_LIB cse
         LEFT JOIN SOUSECRITUREDECLARER csed
                   ON cse.id = csed.idSousEcriture;

create view LIAISONCODELIB as
SELECT
    id,
    idCodeImpot,
    idCompte,
    FORMULE,
    CASE
        WHEN TAXABLE = 1 THEN 'Oui'
        WHEN TAXABLE = 0 THEN 'Non'
        ELSE NULL
        END AS TAXABLE
FROM LiaisonCodeImpot;


create or replace view LIAISONCODESAISIE as
SELECT
    id,
    idCodeImpot,
    idCompte,
    FORMULE,
    TAXABLE,
    '' AS valeur
FROM LiaisonCodeImpot;

create or replace view COMPTASOUSECRITURETVA as
SELECT cse.ID,
       cse.NUMERO,
       cse.COMPTE,
       cse.JOURNAL,
       cse.IDJOURNAL,
       cse.ECRITURE,
       cse.DATY,
       cse.CREDIT,
       cse.DEBIT,
       cse.DATECOMPTABLE,
       cse.EXERCICE,
       cse.REMARQUE,
       cse.ETAT,
       cse.IDMERE,
       cse.HORSEXERCICE,
       cse.OD,
       cse.ORIGINE,
       cse.TIERS,
       cse.LIBELLEPIECE,
       cse.COMPTE_AUX,
       cse.RAISONSOCIAL,
       cse.FOLIO,
       cse.LETTRAGE,
       cse.ANALYTIQUE,
       csed.MOISDECLARATION,
       case
           when csed.MOISDECLARATION is null then 'non'
           when csed.MOISDECLARATION =1 then 'Janvier'
           when csed.MOISDECLARATION =2 then 'Fevrier'
           when csed.MOISDECLARATION =3 then 'Mars'
           when csed.MOISDECLARATION =4 then 'Avril'
           when csed.MOISDECLARATION =5 then 'Mai'
           when csed.MOISDECLARATION =6 then 'Juin'
           when csed.MOISDECLARATION =7 then 'Juillet'
           when csed.MOISDECLARATION =8 then 'Aout'
           when csed.MOISDECLARATION =9 then 'Septembre'
           when csed.MOISDECLARATION =10 then 'Octobre'
           when csed.MOISDECLARATION =11 then 'Novembre'
           when csed.MOISDECLARATION =12 then 'Decembre'
           else 'oui'
           END AS declaration
FROM COMPTA_SOUSECRITURE_LIB cse
         LEFT JOIN SOUSECRITUREDECLARER csed
                   ON cse.id = csed.idSousEcriture
WHERE COMPTE like '4457%' OR COMPTE like '4456%';

INSERT INTO COMPTA_COMPTE (ID, COMPTE, LIBELLE, TYPECOMPTE, CLASSY, ANALYTIQUE_OBLI, IDJOURNAL, CODEIMPOT) VALUES ('COMCSOC0003914P', '44551', '44551', '1', '4', null, 'COMP000035', null);
