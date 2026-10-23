-- ETAT DE PAIE
UPDATE DETFORMU
SET MIN=0, MAX=-1, FORMULE='[101]+[102]+[103]+[104]+[105]+[106]+[107]+[108]+[109]+[110]+[111]+[112]+[113]+[114]+[900]+[150]+[130]+[151]+[131]', UNITE=1, REMARQUE=NULL, MERE='PRUSIS014', FORMULECONDITION='1>0', ETAT=11, CREATION=NULL
WHERE ID='DETSUMG';
UPDATE DETFORMU
SET MIN=0, MAX=-1, FORMULE='[201]+[202]+[203]+[205]+[206]+[207]+[230]+[300]+[800]+[810]+[170]', UNITE=1, REMARQUE=NULL, MERE='PRUSIS015', FORMULECONDITION='1>0', ETAT=11, CREATION=NULL
WHERE ID='DETSUMR';


CREATE OR REPLACE VIEW V_PAIE_RECAP AS
SELECT
    p.idpersonnel AS id,
    p.mois,
    p.annee,
    p.idedition,
    SUM(NVL(CASE WHEN p.regroupement = 1  THEN p.gain END, 0)) AS SALAIRE,
    SUM(NVL(CASE WHEN p.regroupement = 2  THEN p.gain END, 0)) AS HS_M,
    SUM(NVL(CASE WHEN p.regroupement = 3  THEN p.gain END, 0)) AS INDEM,
    SUM(NVL(CASE WHEN p.regroupement = 4  THEN p.gain END, 0)) AS ANCIEN,
    SUM(NVL(CASE WHEN p.regroupement = 5  THEN p.gain END, 0)) AS PRIME,
    SUM(NVL(CASE WHEN p.regroupement = 6  THEN p.gain END, 0)) AS AUTRES,
    SUM(NVL(CASE WHEN p.regroupement = 7  THEN p.gain END, 0)) AS TOTAL,
    SUM(NVL(CASE WHEN p.regroupement = 8  THEN p.retenue END, 0)) AS CNAPS,
    SUM(NVL(CASE WHEN p.regroupement = 9  THEN p.retenue END, 0)) AS OSTIE,
    SUM(NVL(CASE WHEN p.regroupement = 10 THEN p.retenue END, 0)) AS IRSA_E,
    SUM(NVL(CASE WHEN p.regroupement = 11 THEN p.retenue END, 0)) AS IRSA_S,
    SUM(NVL(CASE WHEN p.regroupement = 12 THEN p.retenue END, 0)) AS AV_SPE,
    SUM(NVL(CASE WHEN p.regroupement = 13 THEN p.retenue END, 0)) AS AUTRES2,
    SUM(NVL(CASE WHEN p.regroupement = 14 THEN p.gain END, 0)) AS A_PAYER
FROM
    PAIE_EDITION p
    LEFT JOIN log_personnel l ON l.id = p.idpersonnel
GROUP BY
    p.idedition,p.idpersonnel, p.mois, p.annee;


CREATE OR REPLACE VIEW SITUATION_SALAIRE_EDITION AS
SELECT 
    pinfo.matricule AS matricule,
    log.nom AS nom,
    v.*
FROM
    V_PAIE_RECAP v
    LEFT JOIN paie_info_personnel pinfo 
        ON v.id = pinfo.id
    LEFT JOIN log_personnel log 
        ON v.id = log.id;

 CREATE VIEW SITUATION_SALAIRE_AUTRE AS 
       SELECT 
     idpersonnel,
     idedition,
     mois,
     annee,
 	SUM(CASE WHEN IDELEMENTPAIE = 'PR0000130'  THEN gain ELSE 0 END) AS heuresupp30ni,
    SUM(CASE WHEN IDELEMENTPAIE = 'PR0000130I' THEN gain ELSE 0 END) AS heuresupp30i,
    SUM(CASE WHEN IDELEMENTPAIE = 'PR0000150'  THEN gain ELSE 0 END) AS heuresupp50ni,
    SUM(CASE WHEN IDELEMENTPAIE = 'PR0000150I'  THEN gain ELSE 0 END) AS heuresupp50i,
    SUM(CASE WHEN IDELEMENTPAIE = 'PR0000221' THEN gain ELSE 0 END) AS majnuit,
    SUM(CASE WHEN IDELEMENTPAIE = 'PR0000222'  THEN gain ELSE 0 END) AS majferie,
    SUM(CASE WHEN IDELEMENTPAIE = 'PR0000223'  THEN gain ELSE 0 END) AS majweekend,
    SUM(CASE WHEN IDELEMENTPAIE = 'PR000181'  THEN gain ELSE 0 END) AS abbatement
     FROM PAIE_EDITION pe
     GROUP BY 
     idpersonnel,idedition,mois,annee

 
	
