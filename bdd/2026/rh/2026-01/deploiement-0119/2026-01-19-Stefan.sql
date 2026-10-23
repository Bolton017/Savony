CREATE OR REPLACE VIEW HEURESUPFABRICATION_CPL ("ID", "IDRESSPARFAB", "HEURENORMALE", "HS", "MN", "JF", "HD", "IF", "ETAT", "REMARQUE", "IDPERSONNE", "IDFABRICATION", "DATEFABRICATION", "ETATLIB", "IDPERSONNELIB", "MATRICULE", "TAUXHORAIRE", "TAUXHORAIREEFFECTIVE", "TEMPORAIRE", "MONTANT", "IDQUALIFICATION", "MONTANTJF", "MONTANTHD", "MONTANTIF", "MONTANTMN", "MONTANTHN", "IDDEPARTEMENT", "DEPARTEMENTLIB") AS
SELECT
    h.ID,h.IDRESSPARFAB,h.HEURENORMALE ,h.HS,h.MN,h.JF,h.HD,h.IF,h.ETAT,h.REMARQUE,
    p.id AS  idPersonne,
    h.idFabrication,
    fab.daty as dateFabrication,
    CASE
        WHEN h.etat=0
            THEN 'ANNULEE'
        WHEN h.etat=1
            THEN 'CREE'
        WHEN h.etat=11
            THEN 'VISEE'
        END AS etatlib,
    pm.NOM || ' ' || pm.PRENOM AS idPersonnelib,
    p.MATRICULE,
    r.TAUXHORAIRE,
    CAST(nvl(c.montant,0)/((40*52)/12) AS NUMBER(30,2) ) AS TAUXHORAIREEFFECTIVE,
    p.temporaire,
    h.MONTANT,
    r.IDQUALIFICATION,
    NVL(h.montantJF, 0) as montantJF,
    NVL(h.montantHD, 0) as montantHD,
    NVL(h.montantIF,0) as montantIF,
    NVL(h.montantMN, 0) as montantMN,
    NVL(h.MONTANTHN, 0) as montantHN,
    p.IDDEPARTEMENT,
    d.val as departementLib
FROM HEURESUPFABRICATION h
         LEFT JOIN RESSOURCEPARFABRICATIONCOMPLET r ON r.id = h.IDRESSPARFAB
         LEFT JOIN PAIE_INFO_PERSONNEL p ON p.id = r.idRessource
         LEFT JOIN CATEGORIE_QUALIFICATION c
                   ON c.IDQUALIFICATION = r.IDQUALIFICATION
                       AND c.IDCATEGORIE = r.IDCATEGORIE
                       AND (
                          (c.REMARQUE IS NULL)
                              OR (c.REMARQUE = r.IDRESSOURCE)
                          )
         LEFT JOIN LOG_PERSONNEL pm ON pm.id = r.IDRESSOURCE
         LEFT JOIN FABRICATION fab ON fab.ID = h.IDFABRICATION
         LEFT JOIN DEPARTEMENT d on d.id = p.IDDEPARTEMENT;


CREATE TABLE CIVILITE (
    ID VARCHAR(255),
    VAL VARCHAR(255),
    DESCE VARCHAR(255),
    CONSTRAINT PK_CIVILITE PRIMARY KEY (ID)
);


ALTER TABLE LOG_PERSONNEL ADD (
    IDCIVILITE VARCHAR(255),
    MERE VARCHAR(255),
    PERE VARCHAR(255)
);

ALTER TABLE LOG_PERSONNEL
    ADD CONSTRAINT FK_LOG_PERSONNEL_CIVILITE
        FOREIGN KEY (IDCIVILITE)
            REFERENCES CIVILITE(ID);


CREATE TABLE BANQUE_AGENCE(
    ID VARCHAR(255),
    NOM VARCHAR(255),
    CODEAGENCE VARCHAR(255),
    IDBANQUE VARCHAR(255),
    CONSTRAINT AGENCE_PK PRIMARY KEY (ID),
    CONSTRAINT fk_banque_agence
    FOREIGN KEY (IDBANQUE)
    REFERENCES BANQUE(ID)
);

create sequence SeqBanque_Agence
    minvalue 1
    maxvalue 999999999999
    start with 1
    increment by 1
    cache 20;

CREATE OR REPLACE FUNCTION getSeqBanque_Agence
   RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
SELECT SeqBanque_Agence.NEXTVAL INTO retour FROM DUAL;
RETURN retour;
END;

ALTER TABLE PAIE_INFO_PERSONNEL ADD(
    IDBANQUE VARCHAR(255),
    IDAGENCE VARCHAR(255)
);

ALTER TABLE PAIE_INFO_PERSONNEL
    ADD CONSTRAINT FK_PAIEINFO_AGENCE
        FOREIGN KEY (IDAGENCE)
            REFERENCES BANQUE_AGENCE(ID);

ALTER TABLE PAIE_INFO_PERSONNEL
    ADD CONSTRAINT FK_PAIEINFO_BANQUE
        FOREIGN KEY (IDBANQUE)
            REFERENCES BANQUE(ID);


CREATE OR REPLACE FORCE VIEW BanqueAgenceLib
AS SELECT
       bqa.id,
       bqa.nom,
       bqa.codeAgence,
       bqa.idBanque,
       b.val as idBanqueLib
FROM BANQUE_AGENCE bqa
   LEFT JOIN Banque b ON bqa.idBanque = b.id;

CREATE OR REPLACE VIEW EMPLOYE_COMPLET ("ID", "NOM", "PRENOM", "ID_PERS", "INITIALE", "MATRICULE", "DATE_NAISSANCE", "LIEU_NAISSANCE_COMMUNE", "SEXE", "NUMERO_CIN", "DATE_CIN", "DATE_DUPL_CIN", "LIEU_DELIVRANCE_CIN", "ADRESSE", "FOKOTANY", "NATIONALITE", "ACTE_NAISSANCE", "SITUATION_MATRIMONIAL", "IDCONJOINT", "DIRECTION", "SERVICE", "IDFONCTION", "CTG", "IDCATEGORIE", "CLASSEE", "INDICEGRADE", "INDICE_FONCTIONNEL", "MATRICULE_PATRON", "STATUT", "MODE_PAIEMENT", "CODE_AGENCE_BANQUE", "BANQUE_NUMERO_COMPTE", "BANQUE_COMPTE_CLE", "PERMIS_CONDUIRE", "REMARQUE", "CHEMIN_PERMIS", "CTURGENCE_NOM_PRENOM", "CTURGENCE_TELEPHONE1", "CTURGENCE_TELEPHONE2", "CTURGENCE_TELEPHONE3", "DATEEMBAUCHE", "DATESAISIE", "CODE_DR", "BANQUE_CODE", "ECHELON", "ETAT", "VEHICULEE", "DATE_DERNIERPROMO", "DROIT_HS", "HEUREJOURNALIER", "HEUREHEBDOMADAIRE", "HEUREMENSUEL", "NUMERO_CNAPS", "NUMERO_OSTIE", "TEMPORAIRE", "NBENFANT", "INDESIRABLE", "DUREE", "TELEPHONE", "MAIL", "IDCATEGORIE_PAIE", "IDQUALIFICATION", "DISCIPLINE", "FORMATION", "ANNEEEXPERIENCE", "PERSONNEL_ETAT", "DEBUTCONTRAT", "FINCONTRAT", "REFUSER", "IDETATHIERARCHIE", "ETATVISA", "ETATANNULE", "TYPECONTRAT", "CHEMINIMAGE", "CODE_POSTAL", "IDDEPARTEMENT", "MERE", "PERE", "IDCIVILITELIB", "IDCIVILITE" ,"IDBANQUE", "IDBANQUELIB", "IDAGENCE", "CODEAGENCE", "IDAGENCELIB") AS
SELECT logp.id,
       logp.nom,
       logp.prenom,
       logp.id_pers,
       paie.initiale,
       paie.matricule,
       logp.date_naissance,
       paie.lieu_naissance_commune,
       logp.sexe,
       logp.numero_cin,
       logp.date_cin,
       logp.date_dupl_cin,
       paie.lieu_delivrance_cin,
       logp.adresse,
       logp.fokotany,
       logp.nationalite,
       logp.acte_naissance,
       paie.situation_matrimonial,
       paie.idconjoint,
       logp.direction,
       logp.service,
       paie.idfonction,
       paie.ctg,
       paie.idcategorie,
       paie.classee,
       paie.indicegrade,
       paie.indice_fonctionnel,
       paie.matricule_patron,
       paie.statut,
       paie.mode_paiement,
       paie.code_agence_banque,
       paie.banque_numero_compte,
       paie.banque_compte_cle,
       logp.permis_conduire,
       logp.remarque,
       logp.chemin_permis,
       paie.cturgence_nom_prenom,
       paie.cturgence_telephone1,
       paie.cturgence_telephone2,
       paie.cturgence_telephone3,
       paie.dateembauche,
       paie.datesaisie,
       serv.code_dr,
       trs.val AS banque_code,
       paie.echelon,
       paie.etat,
       paie.vehiculee,
       tab.date_dernierpromo,
       paie.droit_hs,
       paie.heurejournalier,
       paie.heurehebdomadaire,
       paie.heuremensuel,
       paie.numero_cnaps,
       paie.numero_ostie,
       paie.temporaire,
       paie.nbenfant,
       paie.indesirable,
       paie.duree,
       paie.telephone,
       paie.mail,
       paie.idcategorie_paie,
       paie.idqualification,
       paie.discipline,
       paie.formation,
       paie.anneeexperience,
       paie.personnel_etat,
       paie.debutcontrat,
       paie.fincontrat,
       logp.refuser,
       logp.idhierarchie AS idetathierarchie,
       et.etatvisa,
       et.etatannule,
       paie.typecontrat,
       logp.cheminImage,
       paie.code_postal,
       paie.IDDEPARTEMENT,
       logp.mere,
       logp.pere,
       civ.val as idcivilitelib,
       logp.IDCIVILITE,
       paie.idbanque,
       bnq.val as idbanquelib,
       paie.idagence,
       bnqa.codeagence,
       bnqa.nom as idagencelib
FROM log_personnel logp
         LEFT JOIN ( SELECT paie_avancement.id_logpers,
                            max(paie_avancement.datedecision) AS date_dernierpromo
                     FROM paie_avancement
                     GROUP BY paie_avancement.id_logpers) tab ON logp.id = tab.id_logpers
         LEFT JOIN paie_info_personnel paie ON logp.id = paie.id
         LEFT JOIN log_service serv ON serv.id = logp.service
         LEFT JOIN trs_banques_agences trs ON paie.code_agence_banque = trs.id
         LEFT JOIN categorie_paie cp ON cp.id = paie.idcategorie_paie
         LEFT JOIN qualification_paie qp ON qp.id = paie.idqualification
         LEFT JOIN categorie_qualification cq ON cq.idcategorie = paie.idcategorie_paie AND cq.idqualification = paie.idqualification AND cq.REMARQUE = logp.id
         LEFT JOIN etathierarchie et ON et.id = logp.idhierarchie
         LEFT JOIN civilite civ ON logp.idcivilite = civ.id
         LEFT JOIN banque bnq ON bnq.id = paie.idbanque
         LEFT JOIN BANQUE_AGENCE bnqa ON bnqa.id = paie.idagence;




INSERT INTO CIVILITE (ID, VAL, DESCE) VALUES ('CVL001', 'M.', 'M.');
INSERT INTO CIVILITE (ID, VAL, DESCE) VALUES ('CVL002', 'Mme.', 'Mme.');
