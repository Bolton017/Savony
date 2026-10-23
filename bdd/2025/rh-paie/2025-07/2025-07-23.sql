ALTER TABLE DEMANDE ADD MOTIFREFU VARCHAR2(500)


CREATE OR REPLACE VIEW "DEMANDE_LIBCOMPLET" AS
SELECT d.id,
       d.idpersonnel,
       pip.matricule,
       pip.idfonction,
       pf.val AS fonctionlib,
       d.idtypedemande,
       t.val AS typedemandelib,
       d.titre,
       d.horairenormal,
       d.heuredepart,
       d.heurearrive,
       d.idtypeabsence,
       t2.desce AS typeabsencelib,
       d.motif,
       d.numero,
       d.desce,
       d.etat,
       d.daty,
       d.duree,
       d.datedepart,
       d.dateretour,
       d.observation,
       d.remarque,
       lp.nom,
       lp.prenom,
       lp.direction AS iddirection,
       ld.val AS directionlib,
       CASE
           WHEN d.etat = 1 THEN 'crée'
           WHEN d.etat = 11 THEN 'visée'
           ELSE NULL
           END AS etatlib,
       u.refuser,
       r.rang AS ranguser,
       d.idremplacents,
       rmp.remplacents,
       pip.matricule AS matricules,
       d.datefin,
       (lp.nom || ' ') || lp.prenom AS personnel,
       lp.idsup,
       d.avenant,
       CASE
           WHEN d.avenant IS NOT NULL THEN 'OUI'
           ELSE NULL
           END AS annuler,
       (pl.nom || ' ') || pl.prenom AS superieur,
       d.MOTIFREFU
FROM demande d
         LEFT JOIN paie_info_personnel pip ON d.idpersonnel = pip.id
         LEFT JOIN paie_fonction pf ON pf.id = pip.idfonction
         LEFT JOIN typedemande t ON t.id = d.idtypedemande
         LEFT JOIN typeabsence t2 ON t2.id = d.idtypeabsence
         LEFT JOIN log_personnel lp ON lp.id = pip.id
         LEFT JOIN log_direction ld ON ld.id = lp.direction
         LEFT JOIN utilisateur u ON u.refuser = lp.refuser
         LEFT JOIN roles r ON r.idrole = u.idrole
         LEFT JOIN demande_remplacents rmp ON rmp.id = d.id
         LEFT JOIN log_personnel pl ON pl.id = lp.idsup;



CREATE OR REPLACE VIEW NOTIFICATIONLIBCPLT (ID, RECEIVER, RECEIVERLIB, MESSAGE, DATY, HEURE, ETAT, REF, REFLIB, ETATLIB, LIEN, ECARTDATE) AS
SELECT
    n.id,
    n.receiver,
    u.nomuser AS receiverlib,
    n.message,
    n.daty,
    n.heure,
    n.etat,
    n.ref,
    sa.designation AS reflib,
    CASE
        WHEN n.etat = 11 THEN 'LU'
        WHEN n.etat = 1 THEN 'NON LU'
        ELSE NULL
        END AS etatlib,
    n.lien,
    CASE
        WHEN (SYSDATE - (n.daty + TO_DSINTERVAL('0 ' || n.heure))) * 24 * 60 < 1 THEN 'il y a moins d''une minute'
        WHEN (SYSDATE - (n.daty + TO_DSINTERVAL('0 ' || n.heure))) * 24 * 60 < 60 THEN 'il y a ' || FLOOR((SYSDATE - (n.daty + TO_DSINTERVAL('0 ' || n.heure))) * 24 * 60) || ' mn'
        WHEN (SYSDATE - (n.daty + TO_DSINTERVAL('0 ' || n.heure))) * 24 < 24 THEN 'il y a ' || FLOOR((SYSDATE - (n.daty + TO_DSINTERVAL('0 ' || n.heure))) * 24) || ' h'
        ELSE 'il y a ' || FLOOR(SYSDATE - (n.daty + TO_DSINTERVAL('0 ' || n.heure))) || ' jrs'
        END AS ecartdate
FROM notification n
         LEFT JOIN sousactivite sa ON n.ref = sa.id
         LEFT JOIN utilisateur u ON u.refuser = n.receiver;

