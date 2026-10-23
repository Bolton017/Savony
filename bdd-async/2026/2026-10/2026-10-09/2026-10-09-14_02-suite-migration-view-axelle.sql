CREATE TABLE ARRET_TRAVAIL 
(	
   	ID VARCHAR2(50) PRIMARY KEY, 
	ID_ACCIDENT VARCHAR2(50), 
	DATY DATE, 
	DATE_DEBUT_ARRET DATE, 
	DATE_FIN_ARRET DATE, 
	NOMBRE_JOUR NUMBER(6,2), 
	TYPEARRET VARCHAR2(255)
);

CREATE TABLE ACTION_CORRECTIVE_ACCIDENT 
(	
   	ID VARCHAR2(50) PRIMARY KEY, 
	IDACCIDENT VARCHAR2(50), 
	IDRESPONSABLE VARCHAR2(50), 
	ACTIONCORRECTIVE VARCHAR2(4000), 
	DATEREALISATION DATE, 
	DATEDEADLINE DATE, 
	ETAT NUMBER(*, 0),
	CONSTRAINT fk_acc_accident
        FOREIGN KEY (IDACCIDENT)
        REFERENCES ACCIDENT(ID),

    CONSTRAINT fk_acc_resp
        FOREIGN KEY (IDRESPONSABLE)
        REFERENCES LOG_PERSONNEL(ID)
);

CREATE VIEW V_ACCIDENT_LIB (ID, DATY, DATE_DECLARATION, ID_PERSONNEL, ID_LIEU, ID_TYPE_ACCIDENT, ID_GRAVITE, ID_MACHINE, CAUSE, HEUREACCIDENT, HORAIREDEBUT, HORAIREFIN, ACTIVITE, LESIONS, CENTRESOIN, DETAILSTEMOIN1, DETAILSTEMOIN2, ETAT, FAITACCIDENT, TYPE, NUMERORAPPORT, ACTIONIMMEDIATE, ANALYSECAUSE, ACTIONCORRECTIVE, RESPONSABLE, RESPONSABLELIB, ID_MACHINE_LIB, ID_LIEU_LIB, ID_TYPE_ACCIDENT_LIB, ID_GRAVITE_LIB, ID_PERSONNEL_LIB, MATRICULE, ETAT_LIB, IDFONCTION, IDFONCTIONLIB, TYPELIB, IDSOCIETE, IDSOCIETELIB, AUTEURRAPPORT, AUTEURRAPPORTLIB, REPRESENTANTCSST, REPRESENTANTCSSTLIB, DESCRIPTIONBLESSURE, IDBU, IDBULIB, IDDIRECTION, IDDIRECTIONLIB, IDSERVICE, IDSERVICELIB, IDUNITE, IDUNITELIB, DESCRIPTIONDOMMAGEMATERIEL, DETAILSTEMOIN1LIB, MATRICULEDETAILSTEMOIN1, IDFONCTIONDETAILSTEMOIN1, RESPONSABLEACTION, DATEDEADLINE, DATEREALISATION, CUMUL) AS 
  SELECT acc.ID,
       acc.DATY,
       acc.DATE_DECLARATION,
       acc.ID_PERSONNEL,
       acc.ID_LIEU,
       acc.ID_TYPE_ACCIDENT,
       acc.ID_GRAVITE,
       acc.ID_MACHINE,
       acc.CAUSE,
       acc.HEUREACCIDENT,
       acc.HORAIREDEBUT,
       acc.HORAIREFIN,
       acc.ACTIVITE,
       acc.LESIONS,
       acc.CENTRESOIN,
       acc.DETAILSTEMOIN1,
       acc.DETAILSTEMOIN2,
       acc.ETAT,
       acc.FAITACCIDENT,
       acc.TYPE,
       acc.NUMERORAPPORT,
       acc.ACTIONIMMEDIATE,
       acc.ANALYSECAUSE,
       acc.ACTIONCORRECTIVE,
       acc.RESPONSABLE,
       resp1.nom || ' ' || resp1.prenom AS responsableLib,
       m.VAL                     AS id_machine_lib,
       lat.val                   AS id_lieu_lib,
       ta.VAL                    AS id_type_accident_lib,
       ga.val                    AS id_gravite_lib,
       lp.NOM || ' ' || lp.prenom AS id_personnel_lib,
       pip.MATRICULE            AS matricule,
       CASE
           WHEN acc.etat = 1  THEN 'Créé'
           WHEN acc.etat = 11 THEN 'Déclaré'
           ELSE 'inconnu'
           END AS etat_lib,
       pf.ID               AS IDFONCTION,
       pf.VAL              AS IDFONCTIONLIB,
       CASE
           WHEN  acc.Type=0 then 'INCIDENT'
           WHEN  acc.Type=1 then 'ACCIDENT'
           END AS typeLib,
       acc.idsociete AS idsociete,
       so.val AS idsocietelib,
       acc.auteurrapport AS auteurrapport,
       auteur.nom || ' ' || auteur.prenom AS auteurrapportlib,
       acc.representantCSST AS representantCSST,
       represCSs.nom|| ' ' || represCSs.prenom AS representantCSSTLib,
       acc.DESCRIPTIONBLESSURE,
       pip.idBu                                             AS idBu,
       bu.val                                               AS idBuLib,
       lp.direction                                         AS idDirection,
       ld.val                                               AS idDirectionLib,
       lp.service                                           AS idService,
       ls.libelle                                           AS idServiceLib,
       pip.unite                                            AS idUnite,
       lu.val                                               AS idUniteLib,
       acc.DESCRIPTIONDOMMAGEMATERIEL,
       temoin.nom || ' ' || temoin.prenom AS DETAILSTEMOIN1lib,
       pipTemoin.matricule AS MatriculeDETAILSTEMOIN1,
       pfTemoins.VAL            AS IDFONCTIONDETAILSTEMOIN1,
       resp.nom || ' ' || resp.prenom AS RESPONSABLEACTION,
       ACRA.DATEDEADLINE AS DATEDEADLINE,
       ACRA.DATEREALISATION AS DATEREALISATION,
       NVL(tot_arret.total_jours, 0) AS CUMUL
FROM Accident acc
         LEFT JOIN MACHINE m                        ON m.ID   = acc.Id_machine
         LEFT JOIN lieu_accident_travail lat         ON lat.ID = acc.id_lieu
         LEFT JOIN type_accident ta                  ON ta.id  = acc.id_type_accident
         LEFT JOIN gravite_accident ga               ON ga.id  = acc.id_gravite
         LEFT JOIN LOG_PERSONNEL lp                  ON lp.ID  = acc.ID_PERSONNEL
         LEFT JOIN PAIE_INFO_PERSONNEL pip           ON pip.id = acc.ID_PERSONNEL
         LEFT JOIN PAIE_FONCTION pf                  ON pip.IDFONCTION = pf.ID
         LEFT JOIN SOCIETE so ON so.id=acc.idsociete
         LEFT JOIN log_personnel auteur ON auteur.id=acc.auteurrapport
         LEFT JOIN log_personnel represCss ON represCss.id=acc.representantCSST
         LEFT JOIN Business_unite bu                 ON pip.idBu = bu.id
         LEFT JOIN log_direction ld                  ON lp.direction = ld.id
         LEFT JOIN log_service ls                    ON lp.service = ls.id
         LEFT JOIN log_unite lu                      ON pip.unite = lu.id
         LEFT JOIN LOG_PERSONNEL temoin ON acc.DETAILSTEMOIN1=temoin.id
         LEFT JOIN PAIE_INFO_PERSONNEL pipTemoin  ON pipTemoin.id = acc.DETAILSTEMOIN1
         LEFT JOIN PAIE_FONCTION pfTemoins           ON pipTemoin.IDFONCTION = pfTemoins.ID
         LEFT JOIN ACTION_CORRECTIVE_ACCIDENT ACRA ON acc.ACTIONCORRECTIVE = ACRA.id
         LEFT JOIN LOG_PERSONNEL resp ON acc.ACTIONCORRECTIVE = resp.id
         LEFT JOIN LOG_PERSONNEL resp1 ON acc.RESPONSABLE = resp1.id
         LEFT JOIN (
    SELECT id_accident, SUM(NOMBRE_JOUR) AS total_jours
    FROM ARRET_TRAVAIL
    GROUP BY id_accident
) tot_arret ON acc.id = tot_arret.id_accident;

CREATE VIEW VW_ACCIDENT_PAR_TYPE (ID_TYPE_ACCIDENT, ID_TYPE_ACCIDENT_LIB, NOMBREACCIDENTS) AS 
  SELECT
    ta.ID AS id_type_accident,
    ta.val AS id_type_accident_lib,
    COUNT(a.ID) AS nombreAccidents
FROM ACCIDENT a
         JOIN TYPE_ACCIDENT ta
              ON a.ID_TYPE_ACCIDENT = ta.ID
GROUP BY
    ta.ID, ta.val
ORDER BY
    nombreAccidents DESC;

CREATE VIEW V_ACCIDENT_PAR_BUSS_UNITE (IDBU, IDBULIB, NOMBREACCIDENTS) AS 
  SELECT
    a.idBu,
    bu.VAL AS idBuLib,
    COUNT(a.ID) AS nombreAccidents
FROM V_ACCIDENT_LIB a
         JOIN BUSINESS_UNITE bu
              ON bu.ID = a.IDBU
GROUP BY a.idbu,bu.VAL
ORDER BY nombreAccidents DESC;

CREATE OR REPLACE VIEW V_ACCIDENT_PAR_BUSS_UNITE (IDBU, IDBULIB, NOMBREACCIDENTS) AS 
  SELECT
    a.idBu,
    bu.VAL AS idBuLib,
    COUNT(a.ID) AS nombreAccidents
FROM V_ACCIDENT_LIB a
         JOIN BUSINESS_UNITE bu
              ON bu.ID = a.IDBU
GROUP BY a.idbu,bu.VAL
ORDER BY nombreAccidents DESC;

CREATE VIEW V_ACCIDENT_EVOLUTION (MOISINT, MOIS, NOMBREACCIDENTS) AS 
  SELECT
    m.num_mois AS moisInt,
    m.mois,
    NVL(COUNT(a.ID), 0) AS nombreAccidents
FROM (
         SELECT 1 AS num_mois, 'Janvier' AS mois FROM dual UNION ALL
         SELECT 2, 'Février' FROM dual UNION ALL
         SELECT 3, 'Mars' FROM dual UNION ALL
         SELECT 4, 'Avril' FROM dual UNION ALL
         SELECT 5, 'Mai' FROM dual UNION ALL
         SELECT 6, 'Juin' FROM dual UNION ALL
         SELECT 7, 'Juillet' FROM dual UNION ALL
         SELECT 8, 'Août' FROM dual UNION ALL
         SELECT 9, 'Septembre' FROM dual UNION ALL
         SELECT 10, 'Octobre' FROM dual UNION ALL
         SELECT 11, 'Novembre' FROM dual UNION ALL
         SELECT 12, 'Décembre' FROM dual
     ) m
         LEFT JOIN ACCIDENT a
                   ON EXTRACT(MONTH FROM a.daty) = m.num_mois
GROUP BY m.num_mois, m.mois
ORDER BY m.num_mois;

CREATE VIEW V_DASHBOARD_ACCIDENT_JOURS (ID, MOISLIB, CUMULJOURSARRET) AS 
  SELECT
    m.num_mois AS id,
    m.lib_mois AS moislib,
    NVL(SUM(at.NOMBRE_JOUR), 0) AS cumulJoursArret
FROM (
         -- Création d'une table virtuelle contenant toujours les 12 mois
         SELECT '01' AS num_mois, 'Janvier' AS lib_mois FROM DUAL UNION ALL
         SELECT '02', 'Février' FROM DUAL UNION ALL
         SELECT '03', 'Mars' FROM DUAL UNION ALL
         SELECT '04', 'Avril' FROM DUAL UNION ALL
         SELECT '05', 'Mai' FROM DUAL UNION ALL
         SELECT '06', 'Juin' FROM DUAL UNION ALL
         SELECT '07', 'Juillet' FROM DUAL UNION ALL
         SELECT '08', 'Août' FROM DUAL UNION ALL
         SELECT '09', 'Septembre' FROM DUAL UNION ALL
         SELECT '10', 'Octobre' FROM DUAL UNION ALL
         SELECT '11', 'Novembre' FROM DUAL UNION ALL
         SELECT '12', 'Décembre' FROM DUAL
     ) m
-- On fait un LEFT JOIN avec les accidents de l'année en cours
         LEFT JOIN ACCIDENT a
                   ON TO_CHAR(a.DATY, 'MM') = m.num_mois
                       AND EXTRACT(YEAR FROM a.DATY) = EXTRACT(YEAR FROM SYSDATE)
         LEFT JOIN ARRET_TRAVAIL at
ON a.ID = at.ID_ACCIDENT
GROUP BY
    m.num_mois,
    m.lib_mois
ORDER BY
    m.num_mois ASC;

CREATE VIEW V_DASHBOARD_ACCIDENT_MACHINE (ID_MACHINE_LIB, NOMBREACCIDENTS) AS 
  SELECT
    m.VAL AS id_machine_lib,
    COUNT(a.ID) AS nombreAccidents
FROM ACCIDENT a
         LEFT JOIN MACHINE m ON a.ID_MACHINE = m.ID
GROUP BY m.VAL
ORDER BY nombreAccidents DESC;

CREATE VIEW V_DASHBOARD_ACTION_CORRECTIVE (ID, ACTIONSREALISEES, ACTIONSNONREALISEES) AS 
  SELECT
    'ACTION CORRECTIVE' AS id,

    NVL(SUM(CASE WHEN ETAT = 11 THEN 1 ELSE 0 END), 0) AS actionsrealisees,
    NVL(SUM(CASE WHEN ETAT = 1 THEN 1 ELSE 0 END), 0) AS actionsnonrealisees
FROM
    ACTION_CORRECTIVE_ACCIDENT;
