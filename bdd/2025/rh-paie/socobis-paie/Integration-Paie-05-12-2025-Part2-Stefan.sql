-- Part 1 branch: dev-socobispaie bdd/2025/rh-paie/socobis-paie/2025-11/2025-11-05/2025-11-05-debug.sql

create or replace view EMPLOYE_COMPLET as
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
       paie.code_postal
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
         LEFT JOIN etathierarchie et ON et.id = logp.idhierarchie;



create or replace view EMPLOYE_COMPLET_LIBELLE2 as
SELECT logp.id,
       logp.nom,
       logp.prenom,
       logp.id_pers,
       paie.initiale,
       paie.matricule AS matricule,
       logp.date_naissance,
       paie.lieu_naissance_commune,
       s.desce AS sexe,
       logp.numero_cin,
       logp.date_cin,
       logp.date_dupl_cin,
       paie.lieu_delivrance_cin,
       logp.adresse,
       sf.val AS fokotany,
       p.val AS nationalite,
       logp.acte_naissance,
       sitmat.desce AS situation_matrimonial,
       paie.idconjoint,
       ld.val AS direction,
       serv.libelle AS service,
       pf.desce AS idfonction,
       paie.ctg,
       pc.val AS idcategorie,
       paie.classee,
       paie.indicegrade,
       paie.indice_fonctionnel,
       paie.matricule_patron,
       paie.statut,
       pm.val AS mode_paiement,
       paie.code_agence_banque,
       paie.banque_compte_cle,
       paie.banque_numero_compte,
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
       paie.vehiculee,
       CASE paie.vehiculee
           WHEN 0 THEN 'non'
           WHEN 1 THEN 'oui'
           ELSE NULL
           END AS vehiculee_str,
       tab.date_dernierpromo,
       paie.heurejournalier,
       paie.heurehebdomadaire,
       paie.heuremensuel,
       paie.numero_cnaps,
       paie.numero_ostie,
       paie.temporaire,
       CASE
           WHEN paie.temporaire = '-1' THEN 'Temporaire'
           WHEN paie.temporaire = 0 THEN 'Permanent'
           WHEN paie.temporaire = 1 THEN 'Cadre'
           ELSE NULL
           END AS temporaire_lib,
       paie.nbenfant,
       lpnv.motif AS motif_debauche,
       ddt.val AS type_debauche,
       paie.adresse_ligne1,
       paie.adresse_ligne2,
       paie.mail,
       paie.telephone,
       paie.code_postal,
       reg.val AS region,
       paie.anneeexperience,
       fd.val AS formation,
       paie.discipline,
       paie.etat,
       cp.DESCE AS categoriePaieLib
FROM log_personnel logp
         LEFT JOIN ( SELECT paie_avancement.id_logpers,
                            max(paie_avancement.datedecision) AS date_dernierpromo
                     FROM paie_avancement
                     GROUP BY paie_avancement.id_logpers) tab ON logp.id = tab.id_logpers
         LEFT JOIN paie_info_personnel paie ON logp.id = paie.id
         LEFT JOIN log_service serv ON serv.id = logp.service
         LEFT JOIN trs_banques_agences trs ON paie.code_agence_banque = trs.id
         LEFT JOIN sexe s ON logp.sexe = s.id
         LEFT JOIN sig_fokontany sf ON logp.fokotany = sf.id
         LEFT JOIN pays p ON logp.nationalite = p.id
         LEFT JOIN log_direction ld ON logp.direction = ld.id
         LEFT JOIN paie_fonction pf ON paie.idfonction = pf.id
         LEFT JOIN paie_categorie pc ON paie.idcategorie = pc.id
         LEFT JOIN modepaiement pm ON paie.mode_paiement = pm.id
         LEFT JOIN situation_matrimoniale sitmat ON paie.situation_matrimonial = sitmat.id
         LEFT JOIN log_personnel_non_valide lpnv ON logp.id = lpnv.idlogpers
         LEFT JOIN dec_decision_type ddt ON lpnv.idtypedebauche = ddt.id
         LEFT JOIN region reg ON reg.id = paie.region
         LEFT JOIN formation_diplome fd ON fd.id = paie.formation
         LEFT JOIN categorie_paie cp ON paie.IDCATEGORIE_PAIE = cp.id
WHERE logp.id <> '1002067';


ALTER TABLE AVANCE ADD INTERET NUMBER(38, 2) default 0 not null;


create or replace view AVANCE_LIB2 as
SELECT av.id,
       (log.nom || ' ') || log.prenom AS idpersonnel,
       av.montant,
       av.nbremboursement,
       av.remarque,
       av.daty,
       av.dateavance,
       av.interet,
       av.etat,
       CASE
           WHEN av.etat = 1 THEN 'CREE'
           WHEN av.etat = 11 THEN 'VALIDE'
           ELSE NULL
           END AS etatlib,
       av.idtypeavance,
       ty.val AS idtypeavancelib,
       p.matricule
FROM avance av
         LEFT JOIN log_personnel log ON av.idpersonnel = log.id
         LEFT JOIN paie_info_personnel p ON p.id = log.id
         LEFT JOIN typeavance ty ON ty.id = av.idtypeavance;


create or replace view AVANCE_LIB as
SELECT av.id,
       (log.nom || ' ') || log.prenom AS idpersonnel,
       av.montant,
       av.nbremboursement,
       av.remarque,
       av.daty,
       av.dateavance,
       av.interet,
       av.etat,
       ty.val AS idtypeavance,
       p.matricule
FROM avance av
         LEFT JOIN log_personnel log ON av.idpersonnel = log.id
         LEFT JOIN paie_info_personnel p ON p.id = log.id
         LEFT JOIN typeavance ty ON ty.id = av.idtypeavance;


create or replace view ETAT_IRSA as
SELECT dp.id,
       dp.mois,
       mcp.desce AS mois_lib,
       dp.annee,
       dp.matricule,
       COALESCE(dp.numero_cnaps, '') AS numero_cnaps,
       dp.nom,
       dp.poste,
       dp.salaire_de_base AS salaire_de_base,
       dp.indemnitedepresentationbrut + dp.indemnite_de_transport AS indemnite,
       dp.avantages_en_nature AS avantages_en_nature,
       dp.montant_brut AS montant_brut,
       dp.cnaps,
       dp.net_a_payer,
       dp.imposable,
       dp.irsa,
       dp.reductionpourpersonnesacharge,
       dp.irsanet
FROM details_paie_edition_finalpdf dp
         LEFT JOIN moiscp mcp ON dp.mois = mcp.id;


create or replace view V1_OSTIE_AFFICHE_T1 as
SELECT
    rownum as numero,
    lpad(pip.matricule,5,'0') as matricule,
    Upper(trim(trailing ' ' from lp.NOM)) as nom,
    Upper(trim(trailing ' ' from lp.prenom)) as prenoms,
    sexe.val as sexe,
    lp.date_naissance,
    pip.dateembauche,
    case
        when extract(year from pip.date_depart)=nvl(s3.annee,nvl(s2.annee,nvl(s1.annee,0)))
            and (
                 extract(month from pip.date_depart) = 1
                     or
                 extract(month from pip.date_depart) = 2
                     or
                 extract(month from pip.date_depart) = 3
                 ) then pip.date_depart
        else
            null
        end as date_depart,
    upper(paf.desce) as fonction,
    upper(pip.NUMERO_CNAPS) as cnaps,
    lp.numero_cin as cin,
    nvl(s1.salairebase,0) as mois1,
    nvl(s2.salairebase,0) as mois2,
    nvl(s3.salairebase,0) as mois3,
    (nvl(s1.salairebase, 0)+nvl(s2.salairebase, 0)+nvl(s3.salairebase, 0)) as salaires_non_plafonnes,
    (
        case
            when nvl(s1.salairebase,0) >= (select cast(valmin as number) as maximum from configuration where id = 'CONF000140')
                then (select cast(valmin as number) as maximum from configuration where id = 'CONF000140')
            else
                nvl(s1.salairebase,0)
            end
        )+
    (
        case
            when nvl(s2.salairebase,0) >= (select cast(valmin as number) as maximum from configuration where id = 'CONF000140')
                then (select cast(valmin as number) as maximum from configuration where id = 'CONF000140')
            else
                nvl(s2.salairebase,0)
            end
        )+
    (
        case
            when nvl(s3.salairebase,0) >= (select cast(valmin as number) as maximum from configuration where id = 'CONF000140')
                then (select cast(valmin as number) as maximum from configuration where id = 'CONF000140')
            else
                nvl(s3.salairebase,0)
            end
        ) as salaires_plafonnes,
    nvl(ostie.retenue,0)*5 as employeur,
    nvl(ostie.retenue,0) as travailleur,
    (nvl(ostie.retenue,0)*5)+nvl(ostie.retenue,0) as total,
    ostie.annee,
    ostie.direction
FROM log_personnel lp
         JOIN paie_info_personnel pip ON pip.id=lp.id
         JOIN log_direction ld ON ld.id=lp.direction
         JOIN paie_fonction paf ON paf.id = pip.idfonction
         JOIN sexe ON sexe.id = lp.sexe
         LEFT JOIN
     (SELECT sum(round(retenue,0)) as retenue,idpersonnel,annee,direction FROM paie_edition WHERE
         (mois = 1 or mois=2 or mois =3) AND etat=11 AND IDELEMENTPAIE ='PRU000I710'
      group by idpersonnel,annee,direction) ostie
     ON ostie.idpersonnel = lp.id
         LEFT JOIN
     (select * from salairebasemois where mois = 1) s1
     ON lp.id = s1.idpersonnel and ostie.annee= s1.annee
         LEFT JOIN
     (select * from salairebasemois where mois = 2) s2
     ON lp.id = s2.idpersonnel and ostie.annee = s2.annee
         LEFT JOIN
     (select * from salairebasemois where mois = 3) s3
     ON lp.id = s3.idpersonnel and ostie.annee=s3.annee
WHERE nvl(ostie.retenue,0)!=0
ORDER BY annee,pip.matricule;


create or replace view V1_OSTIE_AFFICHE_T2 as
SELECT
    rownum as numero,
    lpad(pip.matricule,5,'0') as matricule,
    Upper(trim(trailing ' ' from lp.NOM)) as nom,
    Upper(trim(trailing ' ' from lp.prenom)) as prenoms,
    sexe.val as sexe,
    lp.date_naissance,
    pip.dateembauche,
    case
        when extract(year from pip.date_depart)=nvl(s3.annee,nvl(s2.annee,nvl(s1.annee,0)))
            and (
                 extract(month from pip.date_depart) = 4
                     or
                 extract(month from pip.date_depart) = 5
                     or
                 extract(month from pip.date_depart) = 6
                 ) then pip.date_depart
        else
            null
        end as date_depart,
    upper(paf.desce) as fonction,
    upper(pip.NUMERO_CNAPS) as cnaps,
    lp.numero_cin as cin,
    nvl(s1.salairebase,0) as mois1,
    nvl(s2.salairebase,0) as mois2,
    nvl(s3.salairebase,0) as mois3,
    (nvl(s1.salairebase, 0)+nvl(s2.salairebase, 0)+nvl(s3.salairebase, 0)) as salaires_non_plafonnes,
    (
        case
            when nvl(s1.salairebase,0) >= (select cast(valmin as number) as maximum from configuration where id = 'CONF000140')
                then (select cast(valmin as number) as maximum from configuration where id = 'CONF000140')
            else
                nvl(s1.salairebase,0)
            end
        )+
    (
        case
            when nvl(s2.salairebase,0) >= (select cast(valmin as number) as maximum from configuration where id = 'CONF000140')
                then (select cast(valmin as number) as maximum from configuration where id = 'CONF000140')
            else
                nvl(s2.salairebase,0)
            end
        )+
    (
        case
            when nvl(s3.salairebase,0) >= (select cast(valmin as number) as maximum from configuration where id = 'CONF000140')
                then (select cast(valmin as number) as maximum from configuration where id = 'CONF000140')
            else
                nvl(s3.salairebase,0)
            end
        ) as salaires_plafonnes,
    nvl(ostie.retenue,0)*5 as employeur,
    nvl(ostie.retenue,0) as travailleur,
    (nvl(ostie.retenue,0)*5)+nvl(ostie.retenue,0) as total,
    ostie.annee,
    ostie.direction
FROM log_personnel lp
         JOIN paie_info_personnel pip ON pip.id=lp.id
         JOIN log_direction ld ON ld.id=lp.direction
         JOIN paie_fonction paf ON paf.id = pip.idfonction
         JOIN sexe ON sexe.id = lp.sexe
         LEFT JOIN
     (SELECT sum(round(retenue,0)) as retenue,idpersonnel,annee,direction FROM paie_edition WHERE
         (mois = 4 or mois=5 or mois =6) AND etat=11 AND IDELEMENTPAIE ='PRU000I710'
      group by idpersonnel,annee,direction) ostie
     ON ostie.idpersonnel = lp.id
         LEFT JOIN
     (select * from salairebasemois where mois = 4) s1
     ON lp.id = s1.idpersonnel and ostie.annee= s1.annee
         LEFT JOIN
     (select * from salairebasemois where mois = 5) s2
     ON lp.id = s2.idpersonnel and ostie.annee = s2.annee
         LEFT JOIN
     (select * from salairebasemois where mois = 6) s3
     ON lp.id = s3.idpersonnel and ostie.annee=s3.annee
WHERE nvl(ostie.retenue,0)!=0
ORDER BY annee,pip.matricule;


create or replace view V1_OSTIE_AFFICHE_T3 as
SELECT
    rownum as numero,
    lpad(pip.matricule,5,'0') as matricule,
    Upper(trim(trailing ' ' from lp.NOM)) as nom,
    Upper(trim(trailing ' ' from lp.prenom)) as prenoms,
    sexe.val as sexe,
    lp.date_naissance,
    pip.dateembauche,
    case
        when extract(year from pip.date_depart)=nvl(s3.annee,nvl(s2.annee,nvl(s1.annee,0)))
            and (
                 extract(month from pip.date_depart) = 7
                     or
                 extract(month from pip.date_depart) = 8
                     or
                 extract(month from pip.date_depart) = 9
                 ) then pip.date_depart
        else
            null
        end as date_depart,
    upper(paf.desce) as fonction,
    upper(pip.NUMERO_CNAPS) as cnaps,
    lp.numero_cin as cin,
    nvl(s1.salairebase,0) as mois1,
    nvl(s2.salairebase,0) as mois2,
    nvl(s3.salairebase,0) as mois3,
    (nvl(s1.salairebase, 0)+nvl(s2.salairebase, 0)+nvl(s3.salairebase, 0)) as salaires_non_plafonnes,
    (
        case
            when nvl(s1.salairebase,0) >= (select cast(valmin as number) as maximum from configuration where id = 'CONF000140')
                then (select cast(valmin as number) as maximum from configuration where id = 'CONF000140')
            else
                nvl(s1.salairebase,0)
            end
        )+
    (
        case
            when nvl(s2.salairebase,0) >= (select cast(valmin as number) as maximum from configuration where id = 'CONF000140')
                then (select cast(valmin as number) as maximum from configuration where id = 'CONF000140')
            else
                nvl(s2.salairebase,0)
            end
        )+
    (
        case
            when nvl(s3.salairebase,0) >= (select cast(valmin as number) as maximum from configuration where id = 'CONF000140')
                then (select cast(valmin as number) as maximum from configuration where id = 'CONF000140')
            else
                nvl(s3.salairebase,0)
            end
        ) as salaires_plafonnes,
    nvl(ostie.retenue,0)*5 as employeur,
    nvl(ostie.retenue,0) as travailleur,
    (nvl(ostie.retenue,0)*5)+nvl(ostie.retenue,0) as total,
    ostie.annee,
    ostie.direction
FROM log_personnel lp
         JOIN paie_info_personnel pip ON pip.id=lp.id
         JOIN log_direction ld ON ld.id=lp.direction
         JOIN paie_fonction paf ON paf.id = pip.idfonction
         JOIN sexe ON sexe.id = lp.sexe
         LEFT JOIN
     (SELECT sum(round(retenue,0)) as retenue,idpersonnel,annee,direction FROM paie_edition WHERE
         (mois = 7 or mois=8 or mois =9) AND etat=11 AND IDELEMENTPAIE ='PRU000I710'
      group by idpersonnel,annee,direction) ostie
     ON ostie.idpersonnel = lp.id
         LEFT JOIN
     (select * from salairebasemois where mois = 7) s1
     ON lp.id = s1.idpersonnel and ostie.annee= s1.annee
         LEFT JOIN
     (select * from salairebasemois where mois = 8) s2
     ON lp.id = s2.idpersonnel and ostie.annee = s2.annee
         LEFT JOIN
     (select * from salairebasemois where mois = 9) s3
     ON lp.id = s3.idpersonnel and ostie.annee=s3.annee
WHERE nvl(ostie.retenue,0)!=0
ORDER BY annee,pip.matricule;


create or replace view V1_OSTIE_AFFICHE_T4 as
SELECT
    rownum as numero,
    lpad(pip.matricule,5,'0') as matricule,
    Upper(trim(trailing ' ' from lp.NOM)) as nom,
    Upper(trim(trailing ' ' from lp.prenom)) as prenoms,
    sexe.val as sexe,
    lp.date_naissance,
    pip.dateembauche,
    case
        when extract(year from pip.date_depart)=nvl(s3.annee,nvl(s2.annee,nvl(s1.annee,0)))
            and (
                 extract(month from pip.date_depart) = 10
                     or
                 extract(month from pip.date_depart) = 11
                     or
                 extract(month from pip.date_depart) = 12
                 ) then pip.date_depart
        else
            null
        end as date_depart,
    upper(paf.desce) as fonction,
    upper(pip.NUMERO_CNAPS) as cnaps,
    lp.numero_cin as cin,
    nvl(s1.salairebase,0) as mois1,
    nvl(s2.salairebase,0) as mois2,
    nvl(s3.salairebase,0) as mois3,
    (nvl(s1.salairebase, 0)+nvl(s2.salairebase, 0)+nvl(s3.salairebase, 0)) as salaires_non_plafonnes,
    (
        case
            when nvl(s1.salairebase,0) >= (select cast(valmin as number) as maximum from configuration where id = 'CONF000140')
                then (select cast(valmin as number) as maximum from configuration where id = 'CONF000140')
            else
                nvl(s1.salairebase,0)
            end
        )+
    (
        case
            when nvl(s2.salairebase,0) >= (select cast(valmin as number) as maximum from configuration where id = 'CONF000140')
                then (select cast(valmin as number) as maximum from configuration where id = 'CONF000140')
            else
                nvl(s2.salairebase,0)
            end
        )+
    (
        case
            when nvl(s3.salairebase,0) >= (select cast(valmin as number) as maximum from configuration where id = 'CONF000140')
                then (select cast(valmin as number) as maximum from configuration where id = 'CONF000140')
            else
                nvl(s3.salairebase,0)
            end
        ) as salaires_plafonnes,
    nvl(ostie.retenue,0)*5 as employeur,
    nvl(ostie.retenue,0) as travailleur,
    (nvl(ostie.retenue,0)*5)+nvl(ostie.retenue,0) as total,
    ostie.annee,
    ostie.direction
FROM log_personnel lp
         JOIN paie_info_personnel pip ON pip.id=lp.id
         JOIN log_direction ld ON ld.id=lp.direction
         JOIN paie_fonction paf ON paf.id = pip.idfonction
         JOIN sexe ON sexe.id = lp.sexe
         LEFT JOIN
     (SELECT sum(round(retenue,0)) as retenue,idpersonnel,annee,direction FROM paie_edition WHERE
         (mois = 10 or mois=11 or mois =12) AND etat=11 AND IDELEMENTPAIE ='PRU000I710'
      group by idpersonnel,annee,direction) ostie
     ON ostie.idpersonnel = lp.id
         LEFT JOIN
     (select * from salairebasemois where mois = 10) s1
     ON lp.id = s1.idpersonnel and ostie.annee= s1.annee
         LEFT JOIN
     (select * from salairebasemois where mois = 11) s2
     ON lp.id = s2.idpersonnel and ostie.annee = s2.annee
         LEFT JOIN
     (select * from salairebasemois where mois = 12) s3
     ON lp.id = s3.idpersonnel and ostie.annee=s3.annee
WHERE nvl(ostie.retenue,0)!=0
ORDER BY annee,pip.matricule;

-- Part 2 branch - dev-socobispaie: bdd/2025/rh-paie/socobis-paie/2025-10/2025-10-06-tsiky.sql

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

-- Part 3 branch - dev-socobispaie: bdd\2025\rh-paie\socobis-paie\2025-10\2025-10-23-socobispaie1209.sql

--bdd
--dans PAIE_INFO_PERSONNEL
--ajouter colonne departement

ALTER TABLE PAIE_INFO_PERSONNEL ADD iddepartement varchar(255);

--creer classe DEPARTEMENT
--id
--val
--desce
--getseqdepartement

create table DEPARTEMENT(
    id varchar(255) constraint DEPARTEMENT_pk primary key ,
    val varchar(255) ,
    desce varchar(255) 
);


create sequence seqDEPARTEMENT
      minvalue 1
      maxvalue 999999999999
      start with 1
      increment by 1
      cache 20;
      
      

CREATE OR REPLACE FUNCTION getseqDEPARTEMENT
   RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
   SELECT seqDEPARTEMENT.NEXTVAL INTO retour FROM DUAL;

   RETURN retour;
END; 


--creer table
--PAIEPERSELTMERE
--id
--idRattachement
--idDepartement
--moisRegularisation string
--anneeRegularisation string
--dateDebut
--dateFin
--idElementPaie


create table PAIEPERSELTMERE(
    id varchar(255) constraint PAIEPERSELTMERE_pk primary key ,
    idRattachement varchar(255) ,
    idDepartement varchar(255) ,
    moisRegularisation varchar(10),
    anneeRegularisation varchar(10),
    dateDebut DATE,
    dateFin DATE,
    idElementPaie varchar(255)
);


create sequence seqPAIEPERSELTMERE
      minvalue 1
      maxvalue 999999999999
      start with 1
      increment by 1
      cache 20;
      
      

CREATE OR REPLACE FUNCTION getseqPAIEPERSELTMERE
   RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
   SELECT seqPAIEPERSELTMERE.NEXTVAL INTO retour FROM DUAL;

   RETURN retour;
END; 


--vue : LOG_PERSONNEL_V2
--ampiana idDepartement


CREATE OR REPLACE  VIEW LOG_PERSONNEL_V2 (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, CODE_DR, MATRICULE, IDCATEGORIE, CTG, INDICEGRADE, INDICE_FONCTIONNEL, STATUT, CATEGORIEVAL, CTGVAL, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, RESTECONGE, CATEGORIE, QUALIFICATION, IDDIRECTION,iddepartement) AS 
  SELECT lpv.id,
       lpv.permis_conduire,
       lpv.chemin_permis,
       lpv.remarque,
       lpv.id_pers,
       lpv.nom,
       lpv.prenom,
       lpv.date_naissance,
       lpv.sexe,
       lpv.numero_cin,
       lpv.date_cin,
       lpv.date_dupl_cin,
       lpv.nationalite,
       lpv.adresse,
       lpv.fokotany,
       lpv.acte_naissance,
       lpv.direction,
       lpv.service,
       lpv.code_dr,
       lpv.matricule,
       lpv.idcategorie,
       lpv.ctg,
       lpv.indicegrade,
       lpv.indice_fonctionnel,
       lpv.statut,
       lpv.categorieval,
       lpv.ctgval,
       lpv.numero_cnaps,
       lpv.numero_ostie,
       lpv.temporaire,
       lpv.resteconge,
       cpl.val AS categorie,
       qp.val AS qualification,
       lpv.idDIRECTION,
       pinfo.iddepartement
FROM log_personnel_v lpv
         LEFT JOIN paie_info_personnel pinfo ON pinfo.id = lpv.id
         LEFT JOIN categorie_paie_lib cpl ON cpl.id = pinfo.idcategorie_paie
         LEFT JOIN qualification_paie qp ON qp.id = pinfo.idqualification;


--vue : EMPLOYE_COMPLET
--ampiana idDepartement de meme ny vue EMPLOYE_COMPLET2

CREATE OR REPLACE  VIEW EMPLOYE_COMPLET (ID, NOM, PRENOM, ID_PERS, INITIALE, MATRICULE, DATE_NAISSANCE, LIEU_NAISSANCE_COMMUNE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, LIEU_DELIVRANCE_CIN, ADRESSE, FOKOTANY, NATIONALITE, ACTE_NAISSANCE, SITUATION_MATRIMONIAL, IDCONJOINT, DIRECTION, SERVICE, IDFONCTION, CTG, IDCATEGORIE, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, MODE_PAIEMENT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, PERMIS_CONDUIRE, REMARQUE, CHEMIN_PERMIS, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, DATEEMBAUCHE, DATESAISIE, CODE_DR, BANQUE_CODE, ECHELON, ETAT, VEHICULEE, DATE_DERNIERPROMO, DROIT_HS, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, NBENFANT, INDESIRABLE, DUREE, TELEPHONE, MAIL, IDCATEGORIE_PAIE, IDQUALIFICATION, DISCIPLINE, FORMATION, ANNEEEXPERIENCE, PERSONNEL_ETAT, DEBUTCONTRAT, FINCONTRAT, REFUSER, IDETATHIERARCHIE, ETATVISA, ETATANNULE, TYPECONTRAT, CHEMINIMAGE,iddepartement) AS 
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
       paie.iddepartement
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
         LEFT JOIN etathierarchie et ON et.id = logp.idhierarchie;


CREATE OR REPLACE  VIEW EMPLOYE_COMPLET2 (ID, NOM, PRENOM, ID_PERS, INITIALE, MATRICULE, DATE_NAISSANCE, LIEU_NAISSANCE_COMMUNE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, LIEU_DELIVRANCE_CIN, ADRESSE, FOKOTANY, NATIONALITE, ACTE_NAISSANCE, SITUATION_MATRIMONIAL, IDCONJOINT, DIRECTION, SERVICE, IDFONCTION, CTG, IDCATEGORIE, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, MODE_PAIEMENT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, PERMIS_CONDUIRE, REMARQUE, CHEMIN_PERMIS, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, DATEEMBAUCHE, DATESAISIE, CODE_DR, BANQUE_CODE, ECHELON, ETAT, VEHICULEE, DATE_DERNIERPROMO, DROIT_HS, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, NBENFANT, INDESIRABLE, DUREE, TELEPHONE, MAIL, IDCATEGORIE_PAIE, IDQUALIFICATION, DISCIPLINE, FORMATION, ANNEEEXPERIENCE, PERSONNEL_ETAT, REFUSER, IDETATHIERARCHIE, ETATVISA, ETATANNULE, IDROLE, RANG,iddepartement) AS 
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
       logp.refuser,
       logp.idhierarchie AS idetathierarchie,
       et.etatvisa,
       et.etatannule,
       r.idrole,
       r.rang,
       paie.iddepartement
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
         LEFT JOIN categorie_qualification cq ON cq.idcategorie = paie.idcategorie_paie AND cq.idqualification = paie.idqualification
         LEFT JOIN etathierarchie et ON et.id = logp.idhierarchie
         LEFT JOIN utilisateur u ON logp.refuser = u.refuser
         LEFT JOIN roles r ON r.idrole = u.idrole;

-- Creation vue paiepers fille misy ny emp rehetra 
CREATE OR REPLACE VIEW PAIEPERS_ELTFILLE AS
SELECT
    '' as ID,
    v.ID as idPersonnel,
    v.NOM || ' ' || v.PRENOM as personnelLib,
    v.MATRICULE,
    0 as montant,
    null as remarque,
    v.IDDEPARTEMENT,
    v.IDDIRECTION
FROM LOG_PERSONNEL_V2 v;

-- Part 4 branch - dev-socobispaie: bdd\2025\rh-paie\socobis-paie\2025-11\2025-11-06\2025-11-06-Ravaka.sql

create or replace view SITUATION_SALAIRE_AUTRE as
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
    idpersonnel,idedition,mois,annee;

create or replace view V_PAIE_RECAP as
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

create or replace view SITUATION_SALAIRE_EDITION as
SELECT
    pinfo.matricule AS matricule,
    log.nom AS nom,
    v."ID",v."MOIS",v."ANNEE",v."IDEDITION",v."SALAIRE",v."HS_M",v."INDEM",v."ANCIEN",v."PRIME",v."AUTRES",v."TOTAL",v."CNAPS",v."OSTIE",v."IRSA_E",v."IRSA_S",v."AV_SPE",v."AUTRES2",v."A_PAYER"
FROM
    V_PAIE_RECAP v
        LEFT JOIN paie_info_personnel pinfo
                  ON v.id = pinfo.id
        LEFT JOIN log_personnel log
                  ON v.id = log.id;

create or replace view SITUATION_SALAIRE_AUTRE as
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
    idpersonnel,idedition,mois,annee;


create or replace view SITUATION_SALAIRE_COMPLET as
SELECT se.MATRICULE,se.NOM,(se.ID||'//'||sa.idedition) AS id,se.MOIS,se.ANNEE,se.IDEDITION,se.SALAIRE,se.HS_M,se.INDEM,se.ANCIEN,se.PRIME,se.AUTRES,se.TOTAL,se.CNAPS,se.OSTIE,se.IRSA_E,se.IRSA_S,se.AV_SPE,se.AUTRES2,se.A_PAYER,sa.heuresupp30ni,heuresupp30i,heuresupp50ni,heuresupp50i,majnuit,majferie,majweekend,abbatement
FROM SITUATION_SALAIRE_EDITION se
         LEFT JOIN SITUATION_SALAIRE_AUTRE sa
                   ON se.idedition =sa.idedition
                       AND se.id = sa.idpersonnel;

-- Part 5 branch - dev-socobispaie: bdd\2025\rh-paie\socobis-paie\2025-11-07-Tsiky.sql


CREATE TABLE CHARGEPERSONNELTEMP (
    ID              VARCHAR2(50) NOT NULL,
    IDPERSONNEL     VARCHAR2(50),
    IDPOSTE         VARCHAR2(50),
    IDCLASSE        VARCHAR2(50),
    HEUREHS         NUMBER(10,2),
    HEUREFERIE      NUMBER(10,2),
    HEUREDIM        NUMBER(10,2),
    HEURENUIT        NUMBER(10,2),
    HEUREIF         NUMBER(10,2),
    TAUX            NUMBER(10,2),
    CONSTRAINT PK_CHARGEPERSONNELTEMP PRIMARY KEY (ID),
    CONSTRAINT FK_CHARGE_PERSONNEL FOREIGN KEY (IDPERSONNEL) REFERENCES PAIE_INFO_PERSONNEL(ID)
);

CREATE SEQUENCE seq_chargepersonneltemp INCREMENT BY 1 MINVALUE 1 MAXVALUE 999999999999 NOCYCLE CACHE 20 NOORDER;

CREATE OR REPLACE FUNCTION getseq_chargepersonneltemp
   RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
   SELECT seq_chargepersonneltemp.NEXTVAL INTO retour FROM DUAL;

   RETURN retour;
END;



INSERT INTO POSTE (ID, VAL, DESCE) VALUES ('POST001', 'CM', 'CM');
INSERT INTO POSTE (ID, VAL, DESCE) VALUES ('POST002', 'FOUR', 'FOUR');
INSERT INTO POSTE (ID, VAL, DESCE) VALUES ('POST003', '785', '785');
INSERT INTO POSTE (ID, VAL, DESCE) VALUES ('POST004', 'RAM', 'RAM');
INSERT INTO POSTE (ID, VAL, DESCE) VALUES ('POST005', 'SOUD', 'SOUD');
INSERT INTO POSTE (ID, VAL, DESCE) VALUES ('POST006', 'MEG', 'MEG');
INSERT INTO POSTE (ID, VAL, DESCE) VALUES ('POST007', 'COLL', 'COLL');
INSERT INTO POSTE (ID, VAL, DESCE) VALUES ('POST008', 'PETRIN', 'PETRIN');
INSERT INTO POSTE (ID, VAL, DESCE) VALUES ('POST009', '928', '928');
INSERT INTO POSTE (ID, VAL, DESCE) VALUES ('POST010', 'MACH', 'MACH');
INSERT INTO POSTE (ID, VAL, DESCE) VALUES ('POST011', 'CLASS', 'CLASS');
INSERT INTO POSTE (ID, VAL, DESCE) VALUES ('POST012', 'LAM', 'LAM');
INSERT INTO POSTE (ID, VAL, DESCE) VALUES ('POST013', 'TRI-LAM', 'TRI-LAM');
INSERT INTO POSTE (ID, VAL, DESCE) VALUES ('POST014', 'CHARG', 'CHARG');
INSERT INTO POSTE (ID, VAL, DESCE) VALUES ('POST015', 'QLTE', 'QLTE');
INSERT INTO POSTE (ID, VAL, DESCE) VALUES ('POST016', 'DCHTS', 'DCHTS');
INSERT INTO POSTE (ID, VAL, DESCE) VALUES ('POST017', 'NETT', 'NETT');
INSERT INTO POSTE (ID, VAL, DESCE) VALUES ('POST018', '2198', '2198');
INSERT INTO POSTE (ID, VAL, DESCE) VALUES ('POST019', '1670', '1670');
INSERT INTO POSTE (ID, VAL, DESCE) VALUES ('POST020', '1638', '1638');
INSERT INTO POSTE (ID, VAL, DESCE) VALUES ('POST021', '1622', '1622');
INSERT INTO POSTE (ID, VAL, DESCE) VALUES ('POST022', '1610', '1610');

-- Part 6 branch - dev-socobispaie: bdd\2025\rh-paie\socobis-paie\2025-11-10-Tsiky.sql

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('AMS010', 'Saisie Avance', 'fa fa-plus', 'module.jsp?but=paie/avance/paiepersonnelelementpaie-saisie.jsp', 1, 4, 'AMS006');

-- Part 7 branch - dev-socobispaie: bdd\2025\rh-paie\socobis-paie\integration-donnees\integration-donnees-10-09-2025.sql
DELETE FROM MOUVEMENTABSENCE m;
DELETE FROM log_personnel;
delete FROM RESSOURCEPARFABRICATION r;
delete FROM HEURESUPFABRICATION r;
delete from RESSOURCEPARFABRICATION;
delete from HEURESUPFABRICATION;
delete from CHARGEPERSONNELTEMP;
DELETE FROM paie_info_personnel;


INSERT INTO CATEGORIE_PAIE (ID, VAL, DESCE, MONTANT, REMARQUE, DROIT_HEURE_SUP, ESSAIE) VALUES ('CP0000012', 'VACATAIRE', 'VACATAIRE', 0.00, 'aucun', 'o', 3.00);
INSERT INTO CATEGORIE_PAIE (ID, VAL, DESCE, MONTANT, REMARQUE, DROIT_HEURE_SUP, ESSAIE) VALUES ('CP000001', 'OUVRIER', 'OUVRIER', 0.00, 'aucun', 'o', 3.00);
INSERT INTO CATEGORIE_PAIE (ID, VAL, DESCE, MONTANT, REMARQUE, DROIT_HEURE_SUP, ESSAIE) VALUES ('CP000002', 'OUVRIER SPECIALISE', 'OUVRIER SPECIALISE', 0.00, 'aucun', 'n', 3.00);
INSERT INTO CATEGORIE_PAIE (ID, VAL, DESCE, MONTANT, REMARQUE, DROIT_HEURE_SUP, ESSAIE) VALUES ('CP0000010', 'TITULAIRE', 'TITULAIRE', 0.00, 'aucun', 'o', 3.00);
INSERT INTO CATEGORIE_PAIE (ID, VAL, DESCE, MONTANT, REMARQUE, DROIT_HEURE_SUP, ESSAIE) VALUES ('CP0000011', 'TEMPORAIRE', 'TEMPORAIRE', 0.00, 'aucun', 'o', 3.00);

--- insert into QUALIFICATION_PAIE  (reto qualification mbola tsy tafiditra tao) ---
INSERT INTO QUALIFICATION_PAIE (ID, VAL, DESCE, IDPOSTE) VALUES('QUAL0037', 'HC Inter', 'HC Inter', 'EX000041');
INSERT INTO QUALIFICATION_PAIE (ID, VAL, DESCE, IDPOSTE) VALUES('QUAL0038', 'HC', 'HC', 'EX000041');
INSERT INTO QUALIFICATION_PAIE (ID, VAL, DESCE, IDPOSTE) VALUES('QUAL0039', 'OP2A-4B', 'OP2A-4B', 'EX000041');
INSERT INTO QUALIFICATION_PAIE (ID, VAL, DESCE, IDPOSTE) VALUES('QUAL0040', 'OP3-5B', 'OP3-5B', 'EX000041');


--- insert paie_fonction (fonction mbola tsisy) ---
INSERT INTO PAIE_FONCTION (ID, VAL, DESCE, IDGROUPEFONCTION, GRATIFICATION)
VALUES('PAF010302', 'AIDE MAINTENANCIER', 'AIDE MAINTENANCIER', 'PAIE000017', NULL);
INSERT INTO PAIE_FONCTION (ID, VAL, DESCE, IDGROUPEFONCTION, GRATIFICATION)
VALUES('PAF010303', 'AGENT D''APPROVISIONNEMENT', 'AGENT D''APPROVISIONNEMENT', 'PAIE000017', NULL);
INSERT INTO PAIE_FONCTION (ID, VAL, DESCE, IDGROUPEFONCTION, GRATIFICATION)
VALUES('PAF010304', 'MAINTENANCIER', 'MAINTENANCIER', 'PAIE000017', NULL);
INSERT INTO PAIE_FONCTION (ID, VAL, DESCE, IDGROUPEFONCTION, GRATIFICATION)
VALUES('PAF010305', 'CONTROLEUR QUALITE', 'CONTROLEUR QUALITE', 'PAIE000017', NULL);
INSERT INTO PAIE_FONCTION (ID, VAL, DESCE, IDGROUPEFONCTION, GRATIFICATION)
VALUES('PAF010306', 'MANOEUVRE SPECIALISEE', 'MANOEUVRE SPECIALISEE', 'PAIE000017', NULL);
INSERT INTO PAIE_FONCTION (ID, VAL, DESCE, IDGROUPEFONCTION, GRATIFICATION)
VALUES('PAF010307', 'NETTOYEUR', 'NETTOYEUR', 'PAIE000017', NULL);
INSERT INTO PAIE_FONCTION (ID, VAL, DESCE, IDGROUPEFONCTION, GRATIFICATION)
VALUES('PAF010308', 'ASSISTANT COMMERCIAL', 'ASSISTANT COMMERCIAL', 'PAIE000017', NULL);
INSERT INTO PAIE_FONCTION (ID, VAL, DESCE, IDGROUPEFONCTION, GRATIFICATION)
VALUES('PAF010309', 'CONTREMAITRE', 'CONTREMAITRE', 'PAIE000017', NULL);
INSERT INTO PAIE_FONCTION (ID, VAL, DESCE, IDGROUPEFONCTION, GRATIFICATION)
VALUES('PAF010310', 'GARDE RAPROCHEE', 'GARDE RAPROCHEE', 'PAIE000017', NULL);
INSERT INTO PAIE_FONCTION (ID, VAL, DESCE, IDGROUPEFONCTION, GRATIFICATION)
VALUES('PAF010311', 'ASSISTANT R.H', 'ASSISTANT R.H', 'PAIE000017', NULL);
INSERT INTO PAIE_FONCTION (ID, VAL, DESCE, IDGROUPEFONCTION, GRATIFICATION)
VALUES('PAF010312', 'MANUTENTIONNAIRE', 'MANUTENTIONNAIRE', 'PAIE000017', NULL);
INSERT INTO PAIE_FONCTION (ID, VAL, DESCE, IDGROUPEFONCTION, GRATIFICATION)
VALUES('PAF010313', 'ASSISTANTE R.H', 'ASSISTANTE R.H', 'PAIE000017', NULL);
INSERT INTO PAIE_FONCTION (ID, VAL, DESCE, IDGROUPEFONCTION, GRATIFICATION)
VALUES('PAF010314', 'CHEF D''ATELIER', 'CHEF D''ATELIER', 'PAIE000017', NULL);
INSERT INTO PAIE_FONCTION (ID, VAL, DESCE, IDGROUPEFONCTION, GRATIFICATION)
VALUES('PAF010315', 'CONTROLEUR DE GESTION OPERATIONNEL', 'CONTROLEUR DE GESTION OPERATIONNEL', 'PAIE000017', NULL);
INSERT INTO PAIE_FONCTION (ID, VAL, DESCE, IDGROUPEFONCTION, GRATIFICATION)
VALUES('PAF010317', 'MANOEUVRE SPECIALISE', 'MANOEUVRE SPECIALISE', 'PAIE000017', NULL);
INSERT INTO PAIE_FONCTION (ID, VAL, DESCE, IDGROUPEFONCTION, GRATIFICATION)
VALUES('PAF010318', 'VENDEUR DIRECT', 'VENDEUR DIRECT', 'PAIE000017', NULL);
INSERT INTO PAIE_FONCTION (ID, VAL, DESCE, IDGROUPEFONCTION, GRATIFICATION)
VALUES('PAF010319', 'GESTIONNAIRE DE DECHETS', 'GESTIONNAIRE DE DECHETS', 'PAIE000017', NULL);
INSERT INTO PAIE_FONCTION (ID, VAL, DESCE, IDGROUPEFONCTION, GRATIFICATION)
VALUES('PAF010320', 'CHARGEE DE COORDINATION  ET D''APPRO INTERNE', 'CHARGEE DE COORDINATION  ET D''APPRO INTERNE', 'PAIE000017', NULL);
INSERT INTO PAIE_FONCTION (ID, VAL, DESCE, IDGROUPEFONCTION, GRATIFICATION)
VALUES('PAF010321', 'CONDUCTEUR FOUR', 'CONDUCTEUR FOUR', 'PAIE000017', NULL);
INSERT INTO PAIE_FONCTION (ID, VAL, DESCE, IDGROUPEFONCTION, GRATIFICATION)
VALUES('PAF010322', 'AIDE PREPARATEUR', 'AIDE PREPARATEUR', 'PAIE000017', NULL);
INSERT INTO PAIE_FONCTION (ID, VAL, DESCE, IDGROUPEFONCTION, GRATIFICATION)
VALUES('PAF010323', 'CONTROLE MERCHANDISER', 'CONTROLE MERCHANDISER', 'PAIE000017', NULL);
INSERT INTO PAIE_FONCTION (ID, VAL, DESCE, IDGROUPEFONCTION, GRATIFICATION)
VALUES('PAF010324', 'RECHERCHE ET DEVELOPPEMENT', 'RECHERCHE ET DEVELOPPEMENT', 'PAIE000017', NULL);
INSERT INTO PAIE_FONCTION (ID, VAL, DESCE, IDGROUPEFONCTION, GRATIFICATION)
VALUES('PAF010325', 'FISCLALISTE TRESORIER', 'FISCLALISTE TRESORIER', 'PAIE000017', NULL);
INSERT INTO PAIE_FONCTION (ID, VAL, DESCE, IDGROUPEFONCTION, GRATIFICATION)
VALUES('PAF010326', 'RESP SYSTEME D''INFO ET PARC INFO', 'RESP SYSTEME D''INFO ET PARC INFO', 'PAIE000017', NULL);
INSERT INTO PAIE_FONCTION (ID, VAL, DESCE, IDGROUPEFONCTION, GRATIFICATION)
VALUES('PAF010327', 'PREPARATEUR', 'PREPARATEUR', 'PAIE000017', NULL);
INSERT INTO PAIE_FONCTION (ID, VAL, DESCE, IDGROUPEFONCTION, GRATIFICATION)
VALUES('PAF010328', 'RESPONSABLE DES ACHAT LOCAUX', 'RESPONSABLE DES ACHAT LOCAUX', 'PAIE000017', NULL);
INSERT INTO PAIE_FONCTION (ID, VAL, DESCE, IDGROUPEFONCTION, GRATIFICATION)
VALUES('FONC0106232', 'CHAUFFEUR', 'CHAUFFEUR', 'PAIE000018', '0');
INSERT INTO PAIE_FONCTION (ID, VAL, DESCE, IDGROUPEFONCTION, GRATIFICATION)
VALUES('FONC0106233', 'SECRETAIRE', 'SECRETAIRE', 'PAIE000018', '0');
INSERT INTO PAIE_FONCTION (ID, VAL, DESCE, IDGROUPEFONCTION, GRATIFICATION)
VALUES('FONC0106234', 'RESP SYSTEME INFO ET PARC INFO', 'RESP SYSTEME INFO ET PARC INFO', 'PAIE000018', '0');
INSERT INTO PAIE_FONCTION (ID, VAL, DESCE, IDGROUPEFONCTION, GRATIFICATION)
VALUES('FONC0106235', 'JARDINIER', 'JARDINIER', 'PAIE000018', '0');
INSERT INTO PAIE_FONCTION (ID, VAL, DESCE, IDGROUPEFONCTION, GRATIFICATION)
VALUES('FONC0106236', 'MECANICIEN', 'MECANICIEN', 'PAIE000018', '0');
INSERT INTO PAIE_FONCTION (ID, VAL, DESCE, IDGROUPEFONCTION, GRATIFICATION)
VALUES('FONC0106237', 'MAGASINIER', 'MAGASINIER', 'PAIE000018', '0');
INSERT INTO PAIE_FONCTION (ID, VAL, DESCE, IDGROUPEFONCTION, GRATIFICATION)
VALUES('FONC0106238', 'FEMME DE MENAGE', 'FEMME DE MENAGE', 'PAIE000018', '0');
INSERT INTO PAIE_FONCTION (ID, VAL, DESCE, IDGROUPEFONCTION, GRATIFICATION)
VALUES('FONC0106239', 'CUISINIER', 'CUISINIER', 'PAIE000018', '0');
INSERT INTO PAIE_FONCTION (ID, VAL, DESCE, IDGROUPEFONCTION, GRATIFICATION)
VALUES('FONC0106240', 'CONVOYEUR', 'CONVOYEUR', 'PAIE000018', '0');
INSERT INTO PAIE_FONCTION (ID, VAL, DESCE, IDGROUPEFONCTION, GRATIFICATION)
VALUES('FONC0106241', 'COMPTABLE', 'COMPTABLE', 'PAIE000018', '0');
INSERT INTO PAIE_FONCTION (ID, VAL, DESCE, IDGROUPEFONCTION, GRATIFICATION)
VALUES('FONC0106242', 'CHEF ATELIER', 'CHEF ATELIER', 'PAIE000018', '0');
INSERT INTO PAIE_FONCTION (ID, VAL, DESCE, IDGROUPEFONCTION, GRATIFICATION)
VALUES('FONC0106243', 'CHARGEE DE COORDINATION  ET APPRO INTERNE', 'CHARGEE DE COORDINATION  ET APPRO INTERNE', 'PAIE000018', '0');
INSERT INTO PAIE_FONCTION (ID, VAL, DESCE, IDGROUPEFONCTION, GRATIFICATION)
VALUES('FONC0106244', 'CAISSIER','CAISSIER', 'PAIE000018', '0');
INSERT INTO PAIE_FONCTION (ID, VAL, DESCE, IDGROUPEFONCTION, GRATIFICATION)
VALUES('FONC0106245', 'AIDE MAGASINIER','AIDE MAGASINIER', 'PAIE000018', '0');
INSERT INTO PAIE_FONCTION (ID, VAL, DESCE, IDGROUPEFONCTION, GRATIFICATION)
VALUES('FONC0106246', 'AGENT APPROVISIONNEMENT','AGENT APPROVISIONNEMENT', 'PAIE000018', '0');
INSERT INTO PAIE_FONCTION (ID, VAL, DESCE, IDGROUPEFONCTION, GRATIFICATION)
VALUES('PAF010329', 'MAGASINIER EXPEDITEUR', 'MAGASINIER EXPEDITEUR', 'PAIE000017', NULL);
INSERT INTO PAIE_FONCTION (ID, VAL, DESCE, IDGROUPEFONCTION, GRATIFICATION)
VALUES('FONC0106247', 'MANOEUVRE','MANOEUVRE', 'PAIE000018', '0');
INSERT INTO PAIE_FONCTION (ID, VAL, DESCE, IDGROUPEFONCTION, GRATIFICATION)
VALUES('FONC0106248', 'JARDINIER','JARDINIER', 'PAIE000018', '0');
INSERT INTO PAIE_FONCTION (ID, VAL, DESCE, IDGROUPEFONCTION, GRATIFICATION)
VALUES('PAF010316', 'COMMERCIAL','COMMERCIAL', 'PAIE000018', '0');
INSERT INTO PAIE_FONCTION (ID, VAL, DESCE, IDGROUPEFONCTION, GRATIFICATION)
VALUES('FONC0106250', 'MANUTENTIONNAIRE','MANUTENTIONNAIRE', 'PAIE000018', '0');
INSERT INTO PAIE_FONCTION (ID, VAL, DESCE, IDGROUPEFONCTION, GRATIFICATION)
VALUES('FONC0106251', 'MERCHANDISER','MERCHANDISER', 'PAIE000018', '0');
INSERT INTO PAIE_FONCTION (ID, VAL, DESCE, IDGROUPEFONCTION, GRATIFICATION)
VALUES('PAF020316', 'SUPERVISEUR', 'SUPERVISEUR', 'PAIE000017', NULL);
INSERT INTO PAIE_FONCTION (ID, VAL, DESCE, IDGROUPEFONCTION, GRATIFICATION)
VALUES('PAF020317', 'SUPERVISEUR DETAIL', 'SUPERVISEUR DETAIL', 'PAIE000017', NULL);
INSERT INTO PAIE_FONCTION (ID, VAL, DESCE, IDGROUPEFONCTION, GRATIFICATION)
VALUES('PAF020318', 'SUPERVISEUR GROS', 'SUPERVISEUR GROS', 'PAIE000017', NULL);


--- paie_info_personnel --- (TITULAIRE: 213 ny isany)INSERT INTO PAIE_INFO_PERSONNEL
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001073', TIMESTAMP '2025-09-10 00:16:01.000000', '1073', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2024-03-01 00:00:00.000000', 'FONC0106238', 'TITULAIRE', '0002', 'M2-mini', 1841, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '932616003572', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '0', NULL, 'LOT AB 331 IV ANKADIVORY ANDRANONAHOATRA', NULL, NULL, NULL, 'CP0000010', 'QUAL0007', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2024-03-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001074', TIMESTAMP '2025-09-10 00:16:01.000000', '1074', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2024-03-01 00:00:00.000000', 'PAF00003', 'TITULAIRE', '0002', 'M2-mini', 1841, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '690816003971', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '341821934', NULL, 'LOT AB 11O BIS I AMBOHIMAMORY', NULL, NULL, NULL, 'CP0000010', 'QUAL0007', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2024-03-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001075', TIMESTAMP '2025-09-10 00:16:01.000000', '1075', NULL, NULL, 'SIT01', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2024-03-01 00:00:00.000000', 'PAF010312', 'TITULAIRE', '0003', 'M2-mini', 1841, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '030814000104', NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, '345747153', NULL, 'LOT 146 AF OUEST MANANJARA', NULL, NULL, NULL, 'CP0000010', 'QUAL0007', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2024-03-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001076', TIMESTAMP '2025-09-10 00:16:01.000000', '1076', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2024-03-01 00:00:00.000000', 'PAF010312', 'TITULAIRE', '0002', 'M2-mini', 1841, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '920301005329', NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '346747848', NULL, 'LOT II A T 182 K BIS AMPANDRANA EST', NULL, NULL, NULL, 'CP0000010', 'QUAL0007', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2024-03-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001077', TIMESTAMP '2025-09-10 00:16:01.000000', '1077', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2024-06-01 00:00:00.000000', 'PAF010312', 'TITULAIRE', '0002', 'M2-mini', 1841, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '000805000269', NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '0', NULL, 'LOT C 199 ALASORA', NULL, NULL, NULL, 'CP0000010', 'QUAL0007', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2024-06-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001078', TIMESTAMP '2025-09-10 00:16:01.000000', '1078', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2024-06-01 00:00:00.000000', 'PAF010302', 'TITULAIRE', '0002', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '930725004336', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '349408838', NULL, 'LOT IVA 62 ANTANETISOA', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2024-06-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001079', TIMESTAMP '2025-09-10 00:16:01.000000', '1079', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2024-06-01 00:00:00.000000', 'FONC0106232', 'TITULAIRE', '0003', 'OS3-maxi', 1946, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '940801004931', NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '343447313', NULL, 'II F 34 FDA ANDRAISORO', NULL, NULL, NULL, 'CP0000010', 'QUAL0014', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2024-06-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001081', TIMESTAMP '2025-09-10 00:16:01.000000', '1081', NULL, NULL, 'SIT01', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2024-06-01 00:00:00.000000', 'PAF010302', 'TITULAIRE', '0003', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '107131003826', NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, '337192067', NULL, 'II B 108 KAA AMBATOMAINTY', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2024-06-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001082', TIMESTAMP '2025-09-10 00:16:01.000000', '1082', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2024-06-01 00:00:00.000000', 'PAF010309', 'TITULAIRE', '0003', 'OP1B-mini', 2039, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '870807007125', NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '340460569', NULL, 'LOT VL 26 M AMBOHIBARY ANDRONDRA', NULL, NULL, NULL, 'CP0000010', 'QUAL0018', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2024-06-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001083', TIMESTAMP '2025-09-10 00:16:01.000000', '1083', NULL, NULL, 'SIT01', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2024-07-01 00:00:00.000000', 'PAF010323', 'TITULAIRE', '0002', 'OP2A-mini', 2182, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '101982115458', NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, '0', NULL, 'LOT C 138 ANDRANOMENA', NULL, NULL, NULL, 'CP0000010', 'QUAL0021', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2024-07-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001084', TIMESTAMP '2025-09-10 00:16:01.000000', '1084', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2024-09-01 00:00:00.000000', 'FONC0106238', 'TITULAIRE', '0002', 'M2-mini', 1841, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '822614001314', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '0', NULL, 'LOT IVL 18 ANKADIFOTSY', NULL, NULL, NULL, 'CP0000010', 'QUAL0007', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2024-09-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001086', TIMESTAMP '2025-09-10 00:16:01.000000', '1086', NULL, NULL, 'SIT01', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2025-01-02 00:00:00.000000', 'PAF010302', 'TITULAIRE', '0002', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '102051009286', NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, '0', NULL, 'AMBODIVONDAVA AMBOHIPENO AMBOHIMANAMBOLA', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2025-01-02 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001087', TIMESTAMP '2025-09-10 00:16:01.000000', '1087', NULL, NULL, 'SIT01', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2025-01-02 00:00:00.000000', 'FONC0106245', 'TITULAIRE', '0003', 'OP1A-mini', 1983, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '117312027626', NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, '0', NULL, 'LOT AKV I 22 AMBODISAHA ALAKAMISY FENOARIVO', NULL, NULL, NULL, 'CP0000010', 'QUAL0015', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2025-01-02 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001088', TIMESTAMP '2025-09-10 00:16:01.000000', '1088', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2025-01-02 00:00:00.000000', 'PAF00003', 'TITULAIRE', '0002', 'M2-mini', 1841, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '220231007072', NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, '0', NULL, 'LOT III S 378 ABZ OUEST ANKADIMBAHOAKA', NULL, NULL, NULL, 'CP0000010', 'QUAL0007', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2025-01-02 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001089', TIMESTAMP '2025-09-10 00:16:01.000000', '1089', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2025-01-02 00:00:00.000000', 'FONC0106232', 'TITULAIRE', '0002', 'OS3-maxi', 1946, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '115091024109', NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, '0', NULL, 'LOT IAV 301 G  MANDRIMENA IAVOLOHA', NULL, NULL, NULL, 'CP0000010', 'QUAL0014', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2025-01-02 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001090', TIMESTAMP '2025-09-10 00:16:01.000000', '1090', NULL, NULL, 'SIT01', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2025-01-02 00:00:00.000000', 'PAF010324', 'TITULAIRE', '0003', 'HC', 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '112991015168', NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, '0', NULL, 'BELAMBANANA ANDOHARANOFOTSY', NULL, NULL, NULL, 'CP0000010', 'QUAL0038', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2025-01-02 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001091', TIMESTAMP '2025-09-10 00:16:01.000000', '1091', NULL, NULL, 'SIT01', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2025-01-02 00:00:00.000000', 'PAF010302', 'TITULAIRE', '0002', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '101251210948', NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, '0', NULL, 'LOT II D 10 H MANJAKARAY', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2025-01-02 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000643', TIMESTAMP '2025-09-10 00:16:00.000000', '0643', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '1995-08-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0002', 'OS1-maxi', 1873, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '76231060', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '348504411', NULL, 'LOTIIB 122 BIS G MANJAKARAY', NULL, NULL, NULL, 'CP0000010', 'QUAL0003', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '1995-08-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000653', TIMESTAMP '2025-09-10 00:16:00.000000', '0653', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '1996-09-01 00:00:00.000000', 'PAF010308', 'TITULAIRE', '0002', 'HC Inter', 3958, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '71041060001B', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '340719497', NULL, 'LOT IIN 138 E ANJANAHARY', NULL, NULL, NULL, 'CP0000010', 'QUAL0037', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '1996-09-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000665', TIMESTAMP '2025-09-10 00:16:00.000000', '0665', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '1997-11-10 00:00:00.000000', 'FONC0106242', 'TITULAIRE', '0003', 'HC', 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '869141', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '331216244', NULL, 'ANTANANDRANO LOT 113 A', NULL, NULL, NULL, 'CP0000010', 'QUAL0038', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '1997-11-10 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000668', TIMESTAMP '2025-09-10 00:16:00.000000', '0668', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '1998-01-02 00:00:00.000000', 'FONC0106232', 'TITULAIRE', '0002', 'OP1A-maxi', 2025, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '740416000158', NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '334248176', NULL, 'B 94 ANDAFIAVARATRA AMBOHITRARAHABA', NULL, NULL, NULL, 'CP0000010', 'QUAL0017', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '1998-01-02 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000670', TIMESTAMP '2025-09-10 00:16:00.000000', '0670', NULL, NULL, 'SIT01', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '1998-01-02 00:00:00.000000', 'FONC0106237', 'TITULAIRE', '0002', 'OP2A-maxi', 2460, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '6932100100', NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, '347467254', NULL, 'LOT II B 1 C MANJAKARAY', NULL, NULL, NULL, 'CP0000010', 'QUAL0023', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '1998-01-02 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000684', TIMESTAMP '2025-09-10 00:16:00.000000', '0684', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '1999-11-29 00:00:00.000000', 'PAF010304', 'TITULAIRE', '0003', 'OP2B-maxi', 2888, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '760123001604', NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, '346427004', NULL, 'LOT II G 10 BIS FY AMBATOMARO', NULL, NULL, NULL, 'CP0000010', 'QUAL0026', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '1999-11-29 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000687', TIMESTAMP '2025-09-10 00:16:00.000000', '0687', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2000-06-02 00:00:00.000000', 'FONC0106233', 'TITULAIRE', '0002', 'OP2A-interm', 2324, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '670207000280', NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '0', NULL, 'LOT APN 17 BIS AMBATOLAMPY AMBOHITRIMANJAKA', NULL, NULL, NULL, 'CP0000010', 'QUAL0022', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2000-06-02 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000689', TIMESTAMP '2025-09-10 00:16:00.000000', '0689', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2000-12-01 00:00:00.000000', 'FONC0106240', 'TITULAIRE', '0002', 'OP2A-maxi', 2460, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '700803000301', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '340874056', NULL, 'LOT II N 10  AMBATOBE', NULL, NULL, NULL, 'CP0000010', 'QUAL0023', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2000-12-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000702', TIMESTAMP '2025-09-10 00:16:00.000000', '0702', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2002-07-01 00:00:00.000000', 'FONC0106237', 'TITULAIRE', '0002', 'OP2A-maxi', 2460, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '760413000219', NULL, 0, NULL, NULL, NULL, 3, NULL, NULL, NULL, NULL, NULL, '331140144', NULL, 'LOT II N 151 ANJANAHARY', NULL, NULL, NULL, 'CP0000010', 'QUAL0023', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2002-07-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000703', TIMESTAMP '2025-09-10 00:16:00.000000', '0703', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2002-12-26 00:00:00.000000', 'FONC0106242', 'TITULAIRE', '0003', 'HC', 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '760908001988', NULL, 0, NULL, NULL, NULL, 3, NULL, NULL, NULL, NULL, NULL, '320503866', NULL, 'LOT II C 72 E MANJAKARAY', NULL, NULL, NULL, 'CP0000010', 'QUAL0038', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2002-12-26 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000716', TIMESTAMP '2025-09-10 00:16:00.000000', '0716', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2004-02-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0002', 'OS3-interm', 1938, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '750226000930', NULL, 0, NULL, NULL, NULL, 3, NULL, NULL, NULL, NULL, NULL, '336818548', NULL, 'IID 67 MANJAKARAY', NULL, NULL, NULL, 'CP0000010', 'QUAL0013', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2004-02-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000733', TIMESTAMP '2025-09-10 00:16:00.000000', '0733', NULL, NULL, 'SIT01', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2004-02-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0003', 'OS1-maxi', 1873, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '752927002242', NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, '338235219', NULL, 'II B 105 B AMBATOMAINTY', NULL, NULL, NULL, 'CP0000010', 'QUAL0003', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2004-02-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000739', TIMESTAMP '2025-09-10 00:16:00.000000', '0739', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2004-02-01 00:00:00.000000', 'PAF010306', 'TITULAIRE', '0002', 'M2-maxi', 1845, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '854329', NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, '342390346', NULL, 'LOT IVI 10 ANDRAVOAHANGY', NULL, NULL, NULL, 'CP0000010', 'QUAL0009', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2004-02-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000742', TIMESTAMP '2025-09-10 00:16:00.000000', '0742', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2004-02-01 00:00:00.000000', 'PAF010306', 'TITULAIRE', '0002', 'M2-maxi', 1845, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '672427000183', NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, '345185513', NULL, 'CITE 267  AMBODIN''ISOTRY', NULL, NULL, NULL, 'CP0000010', 'QUAL0009', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2004-02-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000743', TIMESTAMP '2025-09-10 00:16:00.000000', '0743', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2004-02-01 00:00:00.000000', 'PAF010306', 'TITULAIRE', '0003', 'M2-maxi', 1845, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '662108000227', NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, '340102510', NULL, 'II B 84  AMBATOROKA_x000D_', NULL, NULL, NULL, 'CP0000010', 'QUAL0009', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2004-02-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000750', TIMESTAMP '2025-09-10 00:16:00.000000', '0750', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2004-02-01 00:00:00.000000', 'PAF010306', 'TITULAIRE', '0002', 'M2-maxi', 1845, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '672801000115', NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '0331438345/0387681990', NULL, 'LOT IIO 109 C ANJANAHARY', NULL, NULL, NULL, 'CP0000010', 'QUAL0009', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2004-02-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000754', TIMESTAMP '2025-09-10 00:16:00.000000', '0754', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2004-02-01 00:00:00.000000', 'PAF010306', 'TITULAIRE', '0002', 'M2-maxi', 1845, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '762427000133', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '334609087', NULL, 'LOT VM 88 CAB SAROPODY', NULL, NULL, NULL, 'CP0000010', 'QUAL0009', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2004-02-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000755', TIMESTAMP '2025-09-10 00:16:00.000000', '0755', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2004-02-01 00:00:00.000000', 'PAF010306', 'TITULAIRE', '0002', 'M2-maxi', 1845, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '75231050003T', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '0337468770/0381962837', NULL, 'LOT II J 120  AF  AMBODIVOANJO', NULL, NULL, NULL, 'CP0000010', 'QUAL0009', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2004-02-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000757', TIMESTAMP '2025-09-10 00:16:00.000000', '0757', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2004-02-01 00:00:00.000000', 'PAF010317', 'TITULAIRE', '0003', 'OS1-maxi', 1873, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '730930001360', NULL, 0, NULL, NULL, NULL, 3, NULL, NULL, NULL, NULL, NULL, '343144231', NULL, 'LOT II E 6 TER AMBOHIMIRARY', NULL, NULL, NULL, 'CP0000010', 'QUAL0003', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2004-02-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000758', TIMESTAMP '2025-09-10 00:16:00.000000', '0758', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2004-02-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0002', 'OS2-inter', 1901, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '771221000436', NULL, 0, NULL, NULL, NULL, 3, NULL, NULL, NULL, NULL, NULL, '0', NULL, 'LOT II C 70 MANJAKARAY', NULL, NULL, NULL, 'CP0000010', 'QUAL0010', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2004-02-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000760', TIMESTAMP '2025-09-10 00:16:00.000000', '0760', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2004-02-01 00:00:00.000000', 'PAF010309', 'TITULAIRE', '0002', 'OP2B-mini', 2514, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '780813000834', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '346646890', NULL, 'LOT II E 26 DA IADIAMBOLA NANISANA', NULL, NULL, NULL, 'CP0000010', 'QUAL0024', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2004-02-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000762', TIMESTAMP '2025-09-10 00:16:00.000000', '0762', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2004-02-01 00:00:00.000000', 'FONC0106233', 'TITULAIRE', '0003', 'OP2A-4B', 2460, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '772715002949', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '385200945', NULL, 'ANTANIMENAKELY_x000D_', NULL, NULL, NULL, 'CP0000010', 'QUAL0039', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2004-02-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000764', TIMESTAMP '2025-09-10 00:16:00.000000', '0764', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2004-02-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0002', 'OS2-inter', 1901, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '762809000880', NULL, 0, NULL, NULL, NULL, 3, NULL, NULL, NULL, NULL, NULL, '337599007', NULL, 'LOT II S 40 T ANJANAHARY', NULL, NULL, NULL, 'CP0000010', 'QUAL0010', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2004-02-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000765', TIMESTAMP '2025-09-10 00:16:00.000000', '0765', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2004-02-01 00:00:00.000000', 'FONC0106238', 'TITULAIRE', '0003', 'M2-maxi', 1845, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '672528000741', NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, '322860086', NULL, 'LOT 162 B II TSARAHASINA AMBOHIMANGAKELY', NULL, NULL, NULL, 'CP0000010', 'QUAL0009', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2004-02-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000774', TIMESTAMP '2025-09-10 00:16:00.000000', '0774', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2004-10-01 00:00:00.000000', 'FONC0106233', 'TITULAIRE', '0002', 'OP3-5B', 4948, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '773216002188', NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '345747523', NULL, 'LOT 131 TER MANJAKA ILAFY', NULL, NULL, NULL, 'CP0000010', 'QUAL0040', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2004-10-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000777', TIMESTAMP '2025-09-10 00:16:00.000000', '0777', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2006-03-01 00:00:00.000000', 'FONC0106238', 'TITULAIRE', '0002', 'M2-maxi', 1845, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '662125001744', NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, '347655244', NULL, 'LOT III V 86 AD BIS PRES ANOSIZATO EST I', NULL, NULL, NULL, 'CP0000010', 'QUAL0009', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2006-03-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000781', TIMESTAMP '2025-09-10 00:16:00.000000', '0781', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2006-07-10 00:00:00.000000', 'PAF010309', 'TITULAIRE', '0003', 'OP2B-mini', 2514, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '673006000707', NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, '330219840', NULL, 'LOT II N 26 JKB ANALAMAHITSY TANANA', NULL, NULL, NULL, 'CP0000010', 'QUAL0024', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2006-07-10 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000785', TIMESTAMP '2025-09-10 00:16:00.000000', '0785', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2006-12-11 00:00:00.000000', 'FONC0106237', 'TITULAIRE', '0003', 'OP1B-maxi', 2170, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '762615003645', NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '0', NULL, 'LOT II A 63 AMBATOMAINTY', NULL, NULL, NULL, 'CP0000010', 'QUAL0020', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2006-12-11 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000786', TIMESTAMP '2025-09-10 00:16:00.000000', '0786', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2006-12-11 00:00:00.000000', 'FONC0106237', 'TITULAIRE', '0003', 'OP1B-maxi', 2170, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '830307000784', NULL, 0, NULL, NULL, NULL, 4, NULL, NULL, NULL, NULL, NULL, '0330949664/0347942280', NULL, 'LOT VM 89 X  SAROPODY ANDRONDRAKELY', NULL, NULL, NULL, 'CP0000010', 'QUAL0020', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2006-12-11 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000789', TIMESTAMP '2025-09-10 00:16:00.000000', '0789', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2007-04-01 00:00:00.000000', 'FONC0106235', 'TITULAIRE', '0003', 'M2-maxi', 1845, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '730514000529', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '0', NULL, 'LOT F III L 11 MANANENASOA AMBOHIMANGAKELY', NULL, NULL, NULL, 'CP0000010', 'QUAL0009', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2007-04-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000795', TIMESTAMP '2025-09-10 00:16:00.000000', '0795', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2007-04-23 00:00:00.000000', 'PAF010304', 'TITULAIRE', '0003', 'OP1B-interm', 2081, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '770116002834', NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '340229626', NULL, 'LOT057 F TER AMBOHIBAO ANTEHIROKA', NULL, NULL, NULL, 'CP0000010', 'QUAL0019', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2007-04-23 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000799', TIMESTAMP '2025-09-10 00:16:00.000000', '0799', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2007-06-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0003', 'OS2-inter', 1901, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '740227001596', NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '0', NULL, 'LOT VS 67 BIS ANTSAHONDRA  MANJAKAMIADANA', NULL, NULL, NULL, 'CP0000010', 'QUAL0010', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2007-06-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000802', TIMESTAMP '2025-09-10 00:16:00.000000', '0802', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2007-06-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0002', 'OS1-maxi', 1873, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '782604000223', NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '348705443', NULL, 'LOT292 AI BIS AMBOHIMANGAKELY', NULL, NULL, NULL, 'CP0000010', 'QUAL0003', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2007-06-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000803', TIMESTAMP '2025-09-10 00:16:00.000000', '0803', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2024-12-02 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0003', 'OS2-inter', 1901, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '791002000796', NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, '0', NULL, 'LOT II N 20 D ANALAMAHITSY TANANA', NULL, NULL, NULL, 'CP0000010', 'QUAL0010', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2024-12-02 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000805', TIMESTAMP '2025-09-10 00:16:00.000000', '0805', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2007-06-01 00:00:00.000000', 'PAF010304', 'TITULAIRE', '0003', 'OS3-interm', 1938, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '820323000851', NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, '345906741', NULL, 'LOT N° 509 QUATER CITE ANALAMAHITSY', NULL, NULL, NULL, 'CP0000010', 'QUAL0013', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2007-06-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000806', TIMESTAMP '2025-09-10 00:16:00.000000', '0806', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2007-06-01 00:00:00.000000', 'PAF010309', 'TITULAIRE', '0003', 'OP2A-mini', 2182, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '700731003562', NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '0343904507/0332414227', NULL, 'II A 92 TER AB ANJANAHARY', NULL, NULL, NULL, 'CP0000010', 'QUAL0021', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2007-06-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000809', TIMESTAMP '2025-09-10 00:16:00.000000', '0809', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2007-06-01 00:00:00.000000', 'PAF010304', 'TITULAIRE', '0003', 'OS3-mini', 1928, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '840722000417', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '340468067', NULL, 'LOT IVF 58 BEHORIIRIKA', NULL, NULL, NULL, 'CP0000010', 'QUAL0012', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2007-06-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000811', TIMESTAMP '2025-09-10 00:16:00.000000', '0811', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2007-06-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0003', 'OS2-inter', 1901, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '810717002339', NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, '346089709', NULL, 'LOT VM 88 CAB_x000D_
 SAROPODY', NULL, NULL, NULL, 'CP0000010', 'QUAL0010', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2007-06-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000812', TIMESTAMP '2025-09-10 00:16:00.000000', '0812', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2007-06-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0002', 'OS2-inter', 1901, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '740424000678', NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '344025017', NULL, 'LOT III S 115 BIS AD ANOSIBE AMBOHIBARIKELY', NULL, NULL, NULL, 'CP0000010', 'QUAL0010', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2007-06-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000815', TIMESTAMP '2025-09-10 00:16:00.000000', '0815', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2007-05-18 00:00:00.000000', 'FONC0106246', 'TITULAIRE', '0003', 'OP2A-4B', 3298, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '830620000687', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '325046407', NULL, 'LOT II I 122 TER  ALAROBIA AMBONILOHA', NULL, NULL, NULL, 'CP0000010', 'QUAL0039', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2007-05-18 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000820', TIMESTAMP '2025-09-10 00:16:00.000000', '0820', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2007-07-02 00:00:00.000000', 'PAF010325', 'TITULAIRE', '0003', 'HC', 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '850727001759', NULL, 0, NULL, NULL, NULL, 3, NULL, NULL, NULL, NULL, NULL, '343853525', NULL, 'LOT F II 90 BIS AMBOHIMAHITSY', NULL, NULL, NULL, 'CP0000010', 'QUAL0038', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2007-07-02 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000827', TIMESTAMP '2025-09-10 00:16:00.000000', '0827', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2008-02-01 00:00:00.000000', 'FONC0106245', 'TITULAIRE', '0003', 'OS2-maxi', 1910, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '800224002178', NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '340305696', NULL, 'SAROPODY TANJOMBATO', NULL, NULL, NULL, 'CP0000010', 'QUAL0011', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2008-02-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000828', TIMESTAMP '2025-09-10 00:16:00.000000', '0828', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2008-02-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0003', 'OS1-maxi', 1873, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '690130000526', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '0346889624/0330397917', NULL, 'AVB 20 A AVARABOHITRA ITAOSY', NULL, NULL, NULL, 'CP0000010', 'QUAL0003', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2008-02-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000829', TIMESTAMP '2025-09-10 00:16:00.000000', '0829', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2008-02-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0003', 'OS1-maxi', 1873, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '821108001138', NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, '341173160', NULL, 'LOT II E 62 J BIS AMPANOTOKANA', NULL, NULL, NULL, 'CP0000010', 'QUAL0003', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2008-02-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000832', TIMESTAMP '2025-09-10 00:16:00.000000', '0832', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2008-02-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0002', 'OS1-maxi', 1873, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '710604003062', NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, '325812735', NULL, 'LOT II N 33 A bis ANJANAHARY', NULL, NULL, NULL, 'CP0000010', 'QUAL0003', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2008-02-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000833', TIMESTAMP '2025-09-10 00:16:00.000000', '0833', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2008-02-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0003', 'OS1-maxi', 1873, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '762215001412', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '340466053', NULL, 'LOT II V 138 TER AMPANDRANA  BESARETY', NULL, NULL, NULL, 'CP0000010', 'QUAL0003', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2008-02-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000837', TIMESTAMP '2025-09-10 00:16:00.000000', '0837', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2008-02-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0003', 'OS1-maxi', 1873, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '720612004031', NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '332048297', NULL, 'LOT II R 80 AMBOHITRAKELY_x000D_
TEL : 033 04 918 51', NULL, NULL, NULL, 'CP0000010', 'QUAL0003', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2008-02-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000838', TIMESTAMP '2025-09-10 00:16:00.000000', '0838', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2008-02-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0003', 'OS1-maxi', 1873, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '740106001224', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '333272848', NULL, 'LOTII O 85 ANJANAHARY', NULL, NULL, NULL, 'CP0000010', 'QUAL0003', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2008-02-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000841', TIMESTAMP '2025-09-10 00:16:00.000000', '0841', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2008-02-01 00:00:00.000000', 'FONC0106240', 'TITULAIRE', '0003', 'OP2A-maxi', 2460, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '850606003656', NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, '346956827', NULL, 'LOT II M 28 BIS MAHAVOKY', NULL, NULL, NULL, 'CP0000010', 'QUAL0023', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2008-02-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000850', TIMESTAMP '2025-09-10 00:16:00.000000', '0850', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2008-06-01 00:00:00.000000', 'PAF010321', 'TITULAIRE', '0003', 'OS3-interm', 1938, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '830107000831', NULL, 0, NULL, NULL, NULL, 3, NULL, NULL, NULL, NULL, NULL, '348095339', NULL, 'LOT  IIA 15  TANJOMBATO', NULL, NULL, NULL, 'CP0000010', 'QUAL0013', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2008-06-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000800', TIMESTAMP '2025-09-10 00:16:00.000000', '0800', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2007-06-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0003', 'OS2-inter', 1901, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '709366', NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '337588127', NULL, 'LOT II N 138 RA ANJANAHARY', NULL, NULL, NULL, 'CP0000010', 'QUAL0010', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2007-06-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000801', TIMESTAMP '2025-09-10 00:16:00.000000', '0801', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2007-06-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0002', 'OS2-inter', 1901, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '761205002147', NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, '340412071', NULL, 'LOT III H 30 B ANDREFAN''AMBOHIJANAHARY', NULL, NULL, NULL, 'CP0000010', 'QUAL0010', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2007-06-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000851', TIMESTAMP '2025-09-10 00:16:00.000000', '0851', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2008-06-01 00:00:00.000000', 'PAF010309', 'TITULAIRE', '0003', 'OP2B-mini', 2514, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '830307003010', NULL, 0, NULL, NULL, NULL, 3, NULL, NULL, NULL, NULL, NULL, '0341437429/0331437429', NULL, 'LOT II 223 AMPANDRANA EST', NULL, NULL, NULL, 'CP0000010', 'QUAL0024', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2008-06-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000852', TIMESTAMP '2025-09-10 00:16:00.000000', '0852', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2008-06-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0003', 'OS2-inter', 1901, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '800925004610', NULL, 0, NULL, NULL, NULL, 3, NULL, NULL, NULL, NULL, NULL, '0', NULL, 'IVK 855/BIS ANOSIVAVAKA', NULL, NULL, NULL, 'CP0000010', 'QUAL0010', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2008-06-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000856', TIMESTAMP '2025-09-10 00:16:00.000000', '0856', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2008-06-01 00:00:00.000000', 'PAF010309', 'TITULAIRE', '0003', 'OP2B-mini', 2514, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '761220003296', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '0336794590/0345833744', NULL, 'LOT II E 61 AG AMPANOTOKANA', NULL, NULL, NULL, 'CP0000010', 'QUAL0024', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2008-06-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000863', TIMESTAMP '2025-09-10 00:16:00.000000', '0863', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2009-08-01 00:00:00.000000', 'PAF010317', 'TITULAIRE', '0003', 'OS1-maxi', 1873, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '711223003815', NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '336421075', NULL, 'LOT VT 85  FD ANDOHANIMANDROSEZA', NULL, NULL, NULL, 'CP0000010', 'QUAL0003', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2009-08-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000865', TIMESTAMP '2025-09-10 00:16:00.000000', '0865', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2009-12-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0003', 'OS1-maxi', 1873, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '881028000690', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '348676335', NULL, 'LOT AE 2 BIS ANDRONONOBE', NULL, NULL, NULL, 'CP0000010', 'QUAL0003', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2009-12-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000870', TIMESTAMP '2025-09-10 00:16:00.000000', '0870', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2010-01-01 00:00:00.000000', 'PAF010329', 'TITULAIRE', '0003', 'OP3-5B', 3628, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '860448', NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, '342929742', NULL, 'LOT IVC 108 F AMBOHIMANDROSO AMBOHIMANARINA', NULL, NULL, NULL, 'CP0000010', 'QUAL0040', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2010-01-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000871', TIMESTAMP '2025-09-10 00:16:00.000000', '0871', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2010-04-01 00:00:00.000000', 'PAF010312', 'TITULAIRE', '0002', 'M2-maxi', 1845, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '741130002688', NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '0', NULL, 'LOT CM 94 MALAZA AMPITATAFIKA', NULL, NULL, NULL, 'CP0000010', 'QUAL0009', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2010-04-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000872', TIMESTAMP '2025-09-10 00:16:00.000000', '0872', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2010-04-18 00:00:00.000000', 'PAF010312', 'TITULAIRE', '0003', 'M2-maxi', 1845, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '860831000392', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '346082900', NULL, 'LOT II E 108 TER MANJAKARAY', NULL, NULL, NULL, 'CP0000010', 'QUAL0009', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2010-04-18 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000873', TIMESTAMP '2025-09-10 00:16:00.000000', '0873', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2010-04-01 00:00:00.000000', 'PAF010311', 'TITULAIRE', '0003', 'OP3-5B', 3628, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '851025002634', NULL, 0, NULL, NULL, NULL, 3, NULL, NULL, NULL, NULL, NULL, '337883032', NULL, 'LOT II B 108 K AA AMBATOMAINTY', NULL, NULL, NULL, 'CP0000010', 'QUAL0040', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2010-04-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000879', TIMESTAMP '2025-09-10 00:16:00.000000', '0879', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2010-04-01 00:00:00.000000', 'PAF010318', 'TITULAIRE', '0003', 'OS2-inter', 1901, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '700119000544', NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '347603580', NULL, 'ANKORONDRANO', NULL, NULL, NULL, 'CP0000010', 'QUAL0010', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2010-04-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000883', TIMESTAMP '2025-09-10 00:16:00.000000', '0883', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2011-04-01 00:00:00.000000', 'FONC0106236', 'TITULAIRE', '0002', 'OP1B-maxi', 2170, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '860711001995', NULL, 0, NULL, NULL, NULL, 3, NULL, NULL, NULL, NULL, NULL, '0', NULL, 'LOT BL 38 BELAMBANANA', NULL, NULL, NULL, 'CP0000010', 'QUAL0020', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2011-04-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000884', TIMESTAMP '2025-09-10 00:16:00.000000', '0884', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2011-04-01 00:00:00.000000', 'PAF010316', 'TITULAIRE', '0003', 'HC Inter', 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '852618002312', NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, '345080483', NULL, 'LOT II B 105 TER A AMBATOMAINTY', NULL, NULL, NULL, 'CP0000010', 'QUAL0037', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2011-04-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000885', TIMESTAMP '2025-09-10 00:16:00.000000', '0885', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2020-01-27 00:00:00.000000', 'FONC0106241', 'TITULAIRE', '0003', 'HC Inter', 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '852605003096', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '0345936062/0324432217', NULL, 'LOT IIN 26 K BIS ANALAMAHITSY TANANA', NULL, NULL, NULL, 'CP0000010', 'QUAL0037', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2020-01-27 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000889', TIMESTAMP '2025-09-10 00:16:00.000000', '0889', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2011-11-02 00:00:00.000000', 'PAF010304', 'TITULAIRE', '0003', 'OS3-maxi', 1946, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '780426004512', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '345408025', NULL, 'LOT IVK 127 BIS ANKADIFOTSY', NULL, NULL, NULL, 'CP0000010', 'QUAL0014', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2011-11-02 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000892', TIMESTAMP '2025-09-10 00:16:00.000000', '0892', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2011-03-17 00:00:00.000000', 'FONC0106237', 'TITULAIRE', '0003', 'OP2A-mini', 2182, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '902714000704', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '340819899', NULL, 'LOT IV 33 BIS MAHAZO', NULL, NULL, NULL, 'CP0000010', 'QUAL0021', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2011-03-17 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000893', TIMESTAMP '2025-09-10 00:16:00.000000', '0893', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2012-04-02 00:00:00.000000', 'PAF010316', 'TITULAIRE', '0002', 'HC Inter', 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '862117002750', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '340418067', NULL, 'LOT II 452 O AMBOHITRINIMANGA ANOSY AVARATRA', NULL, NULL, NULL, 'CP0000010', 'QUAL0037', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2012-04-02 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000895', TIMESTAMP '2025-09-10 00:16:00.000000', '0895', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2012-06-06 00:00:00.000000', 'PAF010304', 'TITULAIRE', '0003', 'OP1A-interm', 2011, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '740629000874', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '348535906', NULL, 'LOT II G 1ô BIS GSU AMBATOMARO ANTSOBOLO', NULL, NULL, NULL, 'CP0000010', 'QUAL0016', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2012-06-06 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000897', TIMESTAMP '2025-09-10 00:16:00.000000', '0897', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2012-10-16 00:00:00.000000', 'PAF010310', 'TITULAIRE', '0003', 'OP2B-mini', 2514, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '847271', NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, '0', NULL, 'LOT IVL 131 BIS ANDOHATAPENAKA', NULL, NULL, NULL, 'CP0000010', 'QUAL0024', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2012-10-16 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000904', TIMESTAMP '2025-09-10 00:16:01.000000', '0904', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2013-10-08 00:00:00.000000', 'PAF010304', 'TITULAIRE', '0003', 'OP1B-mini', 2039, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '870119000976', NULL, 0, NULL, NULL, NULL, 3, NULL, NULL, NULL, NULL, NULL, '0344792219/0334110630', NULL, 'LOT AB 250 A BIS AMBOHIMANAMBOLA', NULL, NULL, NULL, 'CP0000010', 'QUAL0018', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2013-10-08 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000905', TIMESTAMP '2025-09-10 00:16:01.000000', '0905', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2013-11-02 00:00:00.000000', 'FONC0106238', 'TITULAIRE', '0002', 'M2-mini', 1841, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '792725004829', NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '0', NULL, 'LOT AB 138 /II AMBODIRANO', NULL, NULL, NULL, 'CP0000010', 'QUAL0007', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2013-11-02 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000910', TIMESTAMP '2025-09-10 00:16:01.000000', '0910', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2014-11-02 00:00:00.000000', 'PAF010313', 'TITULAIRE', '0003', 'HC Inter', 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '873225002917', NULL, 0, NULL, NULL, NULL, 3, NULL, NULL, NULL, NULL, NULL, '348336205', NULL, 'LOT BM 87 BIS AMBOHIDAVENONA AMPITATAFIKA', NULL, NULL, NULL, 'CP0000010', 'QUAL0037', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2014-11-02 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000912', TIMESTAMP '2025-09-10 00:16:01.000000', '0912', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2015-10-01 00:00:00.000000', 'FONC0106232', 'TITULAIRE', '0003', 'OP1A-mini', 1983, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '831120005375', NULL, 0, NULL, NULL, NULL, 3, NULL, NULL, NULL, NULL, NULL, '0', NULL, 'SAROPODY', NULL, NULL, NULL, 'CP0000010', 'QUAL0015', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2015-10-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000914', TIMESTAMP '2025-09-10 00:16:01.000000', '0914', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', 'PAF010307', 'TITULAIRE', '0002', 'M2-maxi', 1845, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '69071020001C', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '348838019', NULL, 'IVC 39 TER AMBODIVOANJO', NULL, NULL, NULL, 'CP0000010', 'QUAL0009', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000915', TIMESTAMP '2025-09-10 00:16:01.000000', '0915', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', 'PAF010312', 'TITULAIRE', '0003', 'M2-mini', 1841, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '870201000130', NULL, 0, NULL, NULL, NULL, 3, NULL, NULL, NULL, NULL, NULL, '339619268', NULL, 'IJ M 4106 ITAOSY', NULL, NULL, NULL, 'CP0000010', 'QUAL0007', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000916', TIMESTAMP '2025-09-10 00:16:01.000000', '0916', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0002', 'OS1-maxi', 1873, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '890318000888', NULL, 0, NULL, NULL, NULL, 3, NULL, NULL, NULL, NULL, NULL, '346444863', NULL, 'IAC 86 A ANDRAMAHAVOLA  ITAOSY', NULL, NULL, NULL, 'CP0000010', 'QUAL0003', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000918', TIMESTAMP '2025-09-10 00:16:01.000000', '0918', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', 'PAF010305', 'TITULAIRE', '0003', 'OS3-mini', 1928, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '870322001566', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '342252067', NULL, 'AB 455 BIS AMPITATAFIKA', NULL, NULL, NULL, 'CP0000010', 'QUAL0012', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000919', TIMESTAMP '2025-09-10 00:16:01.000000', '0919', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', 'PAF010322', 'TITULAIRE', '0002', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '750920000791', NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '330270062', NULL, 'VM 88 CC BIS SAROPODY', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000920', TIMESTAMP '2025-09-10 00:16:01.000000', '0920', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', 'FONC0106237', 'TITULAIRE', '0002', 'OP1B-mini', 2039, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '73291170007F', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '334652142', NULL, 'VF 164 BIS VOLOTARA ANDOHARANOFOTSY', NULL, NULL, NULL, 'CP0000010', 'QUAL0018', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000921', TIMESTAMP '2025-09-10 00:16:01.000000', '0921', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0003', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '740413005162', NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '330357468', NULL, 'II N 09 BIS ANJANAHARY', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000923', TIMESTAMP '2025-09-10 00:16:01.000000', '0923', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', 'FONC0106237', 'TITULAIRE', '0003', 'OS3-maxi', 1946, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '850914000379', NULL, 0, NULL, NULL, NULL, 3, NULL, NULL, NULL, NULL, NULL, '0346096327/0338222961', NULL, 'VW 151 A BIS TSIMBAZAZA', NULL, NULL, NULL, 'CP0000010', 'QUAL0014', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000928', TIMESTAMP '2025-09-10 00:16:01.000000', '0928', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', 'PAF010312', 'TITULAIRE', '0003', 'M2-mini', 1841, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '870815000228', NULL, 0, NULL, NULL, NULL, 3, NULL, NULL, NULL, NULL, NULL, '0344653613/0342375151', NULL, 'III A 26 BIS ANDAFIATSIMO TANJOMBATO', NULL, NULL, NULL, 'CP0000010', 'QUAL0007', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000929', TIMESTAMP '2025-09-10 00:16:01.000000', '0929', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', 'PAF010312', 'TITULAIRE', '0003', 'M2-mini', 1841, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '850903000983', NULL, 0, NULL, NULL, NULL, 4, NULL, NULL, NULL, NULL, NULL, '383231073', NULL, 'IC 196 TER ANKADILALAMPOTSY', NULL, NULL, NULL, 'CP0000010', 'QUAL0007', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000930', TIMESTAMP '2025-09-10 00:16:01.000000', '0930', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', 'PAF010309', 'TITULAIRE', '0003', 'OP2B-mini', 2514, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '800912000353', NULL, 0, NULL, NULL, NULL, 3, NULL, NULL, NULL, NULL, NULL, '336342086', NULL, '114 AI ANTANAMBAO AMBOHIMANGAKELY_x000D_', NULL, NULL, NULL, 'CP0000010', 'QUAL0024', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000932', TIMESTAMP '2025-09-10 00:16:01.000000', '0932', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0003', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '877618', NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '339243314', NULL, 'II A 38 Z AMBATOMAINTY', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000933', TIMESTAMP '2025-09-10 00:16:01.000000', '0933', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0003', 'OS2-inter', 1901, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '890318000787', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '0347504021/0337271395', NULL, 'III S 181 TER ANDREFAN`AMBOHIJANAHARY', NULL, NULL, NULL, 'CP0000010', 'QUAL0010', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000934', TIMESTAMP '2025-09-10 00:16:01.000000', '0934', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0003', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '770426002407', NULL, 0, NULL, NULL, NULL, 3, NULL, NULL, NULL, NULL, NULL, '330375151', NULL, 'II G 3 V Z TER D ANTSAHAKELY AMBATOMARO', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000935', TIMESTAMP '2025-09-10 00:16:01.000000', '0935', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0003', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '871119001359', NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '328087810', NULL, 'VM 92 OVZ SAROPODY', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000936', TIMESTAMP '2025-09-10 00:16:01.000000', '0936', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0002', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '810817002366', NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '330389581', NULL, 'II N 22 B ANALAMAHITSY', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000937', TIMESTAMP '2025-09-10 00:16:01.000000', '0937', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0003', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '812323002239', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '339039014', NULL, 'IVP 72 ANTSALOVANA ANTOHOMADINIKA', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000939', TIMESTAMP '2025-09-10 00:16:01.000000', '0939', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0003', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '722417003168', NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, '342770521', NULL, 'II N 26 JKB ANALAMAHITSY', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000940', TIMESTAMP '2025-09-10 00:16:01.000000', '0940', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0003', 'OS1-maxi', 1873, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '880927001664', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '334091544', NULL, 'G III 28 SOAMANANDRARINY', NULL, NULL, NULL, 'CP0000010', 'QUAL0003', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000941', TIMESTAMP '2025-09-10 00:16:01.000000', '0941', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0003', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '792727001312', NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '343758086', NULL, 'II O 120 L BIS ANJANAHARY', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000942', TIMESTAMP '2025-09-10 00:16:01.000000', '0942', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0003', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '871023001368', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '348248332', NULL, 'IIM 43 TER MAHAVOKY', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000925', TIMESTAMP '2025-09-10 00:16:01.000000', '0925', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', 'PAF010306', 'TITULAIRE', '0002', 'M2-mini', 1841, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '854052', NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, '0', NULL, 'III A 83 TSIMIALONJAFY', NULL, NULL, NULL, 'CP0000010', 'QUAL0007', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000926', TIMESTAMP '2025-09-10 00:16:01.000000', '0926', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', 'FONC0106233', 'TITULAIRE', '0002', 'OP2A-mini', 2182, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '813020003621', NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '340804440', NULL, 'II B 109 MANJAKARAY', NULL, NULL, NULL, 'CP0000010', 'QUAL0021', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000944', TIMESTAMP '2025-09-10 00:16:01.000000', '0944', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', 'PAF010319', 'TITULAIRE', '0003', 'OS3-mini', 1928, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '890813000477', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '349512421', NULL, 'VF 176 VOLOTARA ANDOHARANOFOTSY', NULL, NULL, NULL, 'CP0000010', 'QUAL0012', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000945', TIMESTAMP '2025-09-10 00:16:01.000000', '0945', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0003', 'OS1-maxi', 1873, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '720227004563', NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '330135648', NULL, 'G VI 55 TER A AMBANIVATO SOAMANANDRARINY', NULL, NULL, NULL, 'CP0000010', 'QUAL0003', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000946', TIMESTAMP '2025-09-10 00:16:01.000000', '0946', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0003', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '855028', NULL, 0, NULL, NULL, NULL, 3, NULL, NULL, NULL, NULL, NULL, '342559524', NULL, 'LOT VM 92 ZCA SAROPODY', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000947', TIMESTAMP '2025-09-10 00:16:01.000000', '0947', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0002', 'OS1-maxi', 1873, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '920910000328', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '340628848', NULL, 'G III 17 SAOAMANANDRARINY', NULL, NULL, NULL, 'CP0000010', 'QUAL0003', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000948', TIMESTAMP '2025-09-10 00:16:01.000000', '0948', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', 'PAF010312', 'TITULAIRE', '0003', 'M2-mini', 1841, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '940515001037', NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '337448570', NULL, 'IVT 5 TSARAMASAY', NULL, NULL, NULL, 'CP0000010', 'QUAL0007', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000949', TIMESTAMP '2025-09-10 00:16:01.000000', '0949', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', 'PAF010302', 'TITULAIRE', '0003', 'OS2-maxi', 1910, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '720315', NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '332696193', NULL, 'NANISANA II A 104 GES', NULL, NULL, NULL, 'CP0000010', 'QUAL0011', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000950', TIMESTAMP '2025-09-10 00:16:01.000000', '0950', NULL, NULL, 'SIT01', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0002', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '901031003214', NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, '340459705', NULL, 'IJM 4018 MANGARIVOTRA ITAOSY', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000951', TIMESTAMP '2025-09-10 00:16:01.000000', '0951', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0003', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '910502002176', NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, '341698802', NULL, 'IVP 91 ANKADIFOTSY BEFELATANANA', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000953', TIMESTAMP '2025-09-10 00:16:01.000000', '0953', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0003', 'OS2-inter', 1901, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '711231000147', NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '345111018', NULL, 'III A 91 TSIMIALONJAFY', NULL, NULL, NULL, 'CP0000010', 'QUAL0010', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000954', TIMESTAMP '2025-09-10 00:16:01.000000', '0954', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0003', 'OS2-inter', 1901, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '850801000332', NULL, 0, NULL, NULL, NULL, 3, NULL, NULL, NULL, NULL, NULL, '346433083', NULL, 'II D 75 MANJAKARAY', NULL, NULL, NULL, 'CP0000010', 'QUAL0010', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000955', TIMESTAMP '2025-09-10 00:16:01.000000', '0955', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0003', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '700704004523', NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '0386604321/0349855098', NULL, 'III F 77 BIS MAHAMASINA SUD', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000957', TIMESTAMP '2025-09-10 00:16:01.000000', '0957', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0002', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '831119004154', NULL, 0, NULL, NULL, NULL, 4, NULL, NULL, NULL, NULL, NULL, '347077409', NULL, 'MANJAKARAY II B 131', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000958', TIMESTAMP '2025-09-10 00:16:01.000000', '0958', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0003', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '811210002314', NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, '339229231', NULL, 'III J 81 B ANDAVAMAMBA', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000959', TIMESTAMP '2025-09-10 00:16:01.000000', '0959', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0002', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '790916005551', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '347258886', NULL, 'AB 143 IKIANJA AMBOHIMANGAKELY', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000960', TIMESTAMP '2025-09-10 00:16:01.000000', '0960', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0003', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '771126005634', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '345469724', NULL, 'II G ISFA AMBATOMARO', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000961', TIMESTAMP '2025-09-10 00:16:01.000000', '0961', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', 'PAF010312', 'TITULAIRE', '0002', 'M2-mini', 1841, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '880118001759', NULL, 0, NULL, NULL, NULL, 4, NULL, NULL, NULL, NULL, NULL, '338273143', NULL, 'II F 33 IMB ANDRAISORO', NULL, NULL, NULL, 'CP0000010', 'QUAL0007', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000964', TIMESTAMP '2025-09-10 00:16:01.000000', '0964', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', 'PAF010306', 'TITULAIRE', '0003', 'M2-mini', 1841, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '870542', NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, '346101388', NULL, 'VM 88  SAROPODY', NULL, NULL, NULL, 'CP0000010', 'QUAL0007', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000966', TIMESTAMP '2025-09-10 00:16:01.000000', '0966', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', 'PAF010304', 'TITULAIRE', '0003', 'OS3-maxi', 1946, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '941109000442', NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '348781608', NULL, 'CA III 97 TER ANDOHANILEMPONA AMBOHIMIADANA', NULL, NULL, NULL, 'CP0000010', 'QUAL0014', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000967', TIMESTAMP '2025-09-10 00:16:01.000000', '0967', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', 'PAF010306', 'TITULAIRE', '0003', 'M2-mini', 1841, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '852527001861', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '336212210', NULL, 'II A 63 AMBATOMAINTY', NULL, NULL, NULL, 'CP0000010', 'QUAL0007', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000968', TIMESTAMP '2025-09-10 00:16:01.000000', '0968', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0003', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '760125000883', NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '0337889040/0331109352', NULL, 'II S 34 E ANJANAHARY', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000969', TIMESTAMP '2025-09-10 00:16:01.000000', '0969', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0003', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '863028000377', NULL, 0, NULL, NULL, NULL, 4, NULL, NULL, NULL, NULL, NULL, '347642122', NULL, 'II C 77 D B MANJAKARAY', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000970', TIMESTAMP '2025-09-10 00:16:01.000000', '0970', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', 'PAF010307', 'TITULAIRE', '0003', 'M2-mini', 1841, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '74121010017V', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '340689805', NULL, '200 B ANTANANDRANO', NULL, NULL, NULL, 'CP0000010', 'QUAL0007', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000971', TIMESTAMP '2025-09-10 00:16:01.000000', '0971', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0002', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '872222000483', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '383966387', NULL, 'III J 52 BIS ANDAVAMAMBA AMBILANIBE', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000973', TIMESTAMP '2025-09-10 00:16:01.000000', '0973', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0003', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '789376', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '0346820122/0333178018', NULL, 'IVL 215 ANDOHATAPENAKA II', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000974', TIMESTAMP '2025-09-10 00:16:01.000000', '0974', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', 'FONC0106233', 'TITULAIRE', '0003', 'OP2A-interm', 2324, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '860506002704', NULL, 0, NULL, NULL, NULL, 4, NULL, NULL, NULL, NULL, NULL, '0', NULL, 'II T 47 BESARETY', NULL, NULL, NULL, 'CP0000010', 'QUAL0022', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000976', TIMESTAMP '2025-09-10 00:16:01.000000', '0976', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', 'FONC0106232', 'TITULAIRE', '0003', 'OP1A-mini', 1983, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '870323003393', NULL, 0, NULL, NULL, NULL, 3, NULL, NULL, NULL, NULL, NULL, '337689096', NULL, 'LOT A 255 BIS ANGAVAO ALASORA', NULL, NULL, NULL, 'CP0000010', 'QUAL0015', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000977', TIMESTAMP '2025-09-10 00:16:01.000000', '0977', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', 'PAF010304', 'TITULAIRE', '0003', 'OS3-mini', 1928, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '870113002538', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '349713599', NULL, 'VM 88 CO SAROPODY', NULL, NULL, NULL, 'CP0000010', 'QUAL0012', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000978', TIMESTAMP '2025-09-10 00:16:01.000000', '0978', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', 'FONC0106243', 'TITULAIRE', '0003', 'OP3-5B', 4948, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '932810000946', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '332437854', NULL, 'LOT III S 144 TAB OUEST MANANJARA', NULL, NULL, NULL, 'CP0000010', 'QUAL0040', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000979', TIMESTAMP '2025-09-10 00:16:01.000000', '0979', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', 'FONC0106238', 'TITULAIRE', '0003', 'M2-mini', 1841, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '942609000459', NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '0', NULL, 'AMBOHIMANGAKELY', NULL, NULL, NULL, 'CP0000010', 'QUAL0007', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000981', TIMESTAMP '2025-09-10 00:16:01.000000', '0981', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', 'PAF010316', 'TITULAIRE', '0003', 'HC Inter', 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '892901002673', NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '341779457', NULL, 'LOT IC 184 ANKADILALAMPOTSY ANKARAOBATO', NULL, NULL, NULL, 'CP0000010', 'QUAL0037', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000983', TIMESTAMP '2025-09-10 00:16:01.000000', '0983', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', 'PAF010304', 'TITULAIRE', '0002', 'OS3-maxi', 1946, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '880618003518', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '341852681', NULL, 'II N 138 B ANJANAHARY', NULL, NULL, NULL, 'CP0000010', 'QUAL0014', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000985', TIMESTAMP '2025-09-10 00:16:01.000000', '0985', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', 'FONC0106241', 'TITULAIRE', '0003', 'OP3-5B', 4948, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '952920001338', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '342028356', NULL, 'LOT III C 105 AMBONIN''AMPAHAMARINANA', NULL, NULL, NULL, 'CP0000010', 'QUAL0040', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2017-12-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000989', TIMESTAMP '2025-09-10 00:16:01.000000', '0989', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2020-01-01 00:00:00.000000', 'FONC0106233', 'TITULAIRE', '0003', 'OP2A-4B', 2968, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '942325001738', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '331229344', NULL, 'BL 59 BIS BELAMBANANA ANDOHARANOFOTSY', NULL, NULL, NULL, 'CP0000010', 'QUAL0039', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2020-01-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000990', TIMESTAMP '2025-09-10 00:16:01.000000', '0990', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2020-01-02 00:00:00.000000', 'FONC0106232', 'TITULAIRE', '0003', 'OP1A-maxi', 2025, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '840326001149', NULL, 0, NULL, NULL, NULL, 3, NULL, NULL, NULL, NULL, NULL, '341745594', NULL, 'LOT IC 11 TER  ANKADILALAMPOTSY', NULL, NULL, NULL, 'CP0000010', 'QUAL0017', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2020-01-02 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000991', TIMESTAMP '2025-09-10 00:16:01.000000', '0991', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2020-01-02 00:00:00.000000', 'FONC0106232', 'TITULAIRE', '0003', 'OP1A-mini', 1983, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '711014001249', NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, '341929849', NULL, 'II A 181 TANJOMBATO IRAISTIMIVAKY', NULL, NULL, NULL, 'CP0000010', 'QUAL0015', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2020-01-02 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000994', TIMESTAMP '2025-09-10 00:16:01.000000', '0994', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2020-11-02 00:00:00.000000', 'FONC0106239', 'TITULAIRE', '0003', 'M2-mini', 1841, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '742606004808', NULL, 0, NULL, NULL, NULL, 3, NULL, NULL, NULL, NULL, NULL, '0', NULL, 'AB 307 AMBODIRANO AMBOHIMAMORY', NULL, NULL, NULL, 'CP0000010', 'QUAL0007', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2020-11-02 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000997', TIMESTAMP '2025-09-10 00:16:01.000000', '0997', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2021-02-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0003', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '790413001745', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '343280440', NULL, '106 BIS MANJAKARAY II C', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2021-02-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000998', TIMESTAMP '2025-09-10 00:16:01.000000', '0998', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2021-01-02 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0003', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '890829001134', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '342999927', NULL, 'BII 161 AMBOHIMANGAKELY', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2021-01-02 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS000999', TIMESTAMP '2025-09-10 00:16:01.000000', '0999', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2021-01-02 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0002', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '660508004670', NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, '349795222', NULL, 'H 44 BIS A MANANDONA MERIMANJAKA', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2021-01-02 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001000', TIMESTAMP '2025-09-10 00:16:01.000000', '1000', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2021-01-02 00:00:00.000000', 'PAF010307', 'TITULAIRE', '0003', 'M2-mini', 1841, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '891023001437', NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '349014052', NULL, 'IVT 17 TSARAMASAY', NULL, NULL, NULL, 'CP0000010', 'QUAL0007', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2021-01-02 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001001', TIMESTAMP '2025-09-10 00:16:01.000000', '1001', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2021-01-02 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0003', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '850421003135', NULL, 0, NULL, NULL, NULL, 3, NULL, NULL, NULL, NULL, NULL, '382866646', NULL, 'II E 2 X Q N AMBATOKARANANA', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2021-01-02 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001002', TIMESTAMP '2025-09-10 00:16:01.000000', '1002', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2021-01-02 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0003', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '940107000849', NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '384125399', NULL, 'VM 90 ANDRONDRAKELY', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2021-01-02 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001005', TIMESTAMP '2025-09-10 00:16:01.000000', '1005', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2021-01-02 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0003', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '930101078108', NULL, 0, NULL, NULL, NULL, 3, NULL, NULL, NULL, NULL, NULL, '0382014400/0331374134', NULL, 'III S 144 AFA OUEST MANANJARA', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2021-01-02 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001007', TIMESTAMP '2025-09-10 00:16:01.000000', '1007', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2021-02-01 00:00:00.000000', 'PAF010304', 'TITULAIRE', '0003', 'OS3-maxi', 1946, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '740805004592', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '347615051', NULL, 'LOT ITM 33 AMBODIFASIKA', NULL, NULL, NULL, 'CP0000010', 'QUAL0014', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2021-02-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001009', TIMESTAMP '2025-09-10 00:16:01.000000', '1009', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2021-02-01 00:00:00.000000', 'PAF010312', 'TITULAIRE', '0002', 'M2-mini', 1841, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '760509003404', NULL, 0, NULL, NULL, NULL, 3, NULL, NULL, NULL, NULL, NULL, '348920461', NULL, 'LOT IVT 4 TER TSARAMASAY', NULL, NULL, NULL, 'CP0000010', 'QUAL0007', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2021-02-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001010', TIMESTAMP '2025-09-10 00:16:01.000000', '1010', NULL, NULL, 'SIT01', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2021-02-01 00:00:00.000000', 'PAF010312', 'TITULAIRE', '0002', 'M2-mini', 1841, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '961111004036', NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, '0', NULL, 'LOT VT 85 ANDOHANIMANDROSEZA', NULL, NULL, NULL, 'CP0000010', 'QUAL0007', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2021-02-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001012', TIMESTAMP '2025-09-10 00:16:01.000000', '1012', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2021-03-03 00:00:00.000000', 'FONC0106232', 'TITULAIRE', '0003', 'OS3-mini', 1928, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '780918003565', NULL, 0, NULL, NULL, NULL, 3, NULL, NULL, NULL, NULL, NULL, '0', NULL, 'VM 92 EZ TER SAROPODY', NULL, NULL, NULL, 'CP0000010', 'QUAL0012', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2021-03-03 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001014', TIMESTAMP '2025-09-10 00:16:01.000000', '1014', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2021-10-01 00:00:00.000000', 'PAF010318', 'TITULAIRE', '0003', 'OS2-inter', 1901, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '940627002489', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '0', NULL, 'AMBOHITROMBY F 41', NULL, NULL, NULL, 'CP0000010', 'QUAL0010', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2021-10-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001015', TIMESTAMP '2025-09-10 00:16:01.000000', '1015', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2021-10-01 00:00:00.000000', 'PAF010305', 'TITULAIRE', '0003', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '870626004418', NULL, 0, NULL, NULL, NULL, 3, NULL, NULL, NULL, NULL, NULL, '0', NULL, 'II N 156 TER ANJANAHARY', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2021-10-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001016', TIMESTAMP '2025-09-10 00:16:01.000000', '1016', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2021-10-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0003', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '930712000575', NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, '340257236', NULL, 'LOT ICO TER B ANKADILALAMPOTSY', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2021-10-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001017', TIMESTAMP '2025-09-10 00:16:01.000000', '1017', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2021-10-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0003', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '891205000921', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '340152168', NULL, 'LOT C 58 A TER AMBOHINAORINA', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2021-10-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001018', TIMESTAMP '2025-09-10 00:16:01.000000', '1018', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2021-10-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0003', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '750204003690', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '0340413431/0333289483', NULL, 'II H 12 RF ANKERANA ANKADINDRAMAMY', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2021-10-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001019', TIMESTAMP '2025-09-10 00:16:01.000000', '1019', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2021-10-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0003', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '702101018630', NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, '330475976', NULL, 'LOT BA 252 AMPITATAFIKA  VAOVAO TANA 102', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2021-10-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001020', TIMESTAMP '2025-09-10 00:16:01.000000', '1020', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2021-10-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0003', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '812302002446', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '332863277', NULL, 'LOT 165 H BIS MANGARIVOTRA SABOTSY NAMEHANA', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2021-10-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001021', TIMESTAMP '2025-09-10 00:16:01.000000', '1021', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2021-10-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0002', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '800521004155', NULL, 0, NULL, NULL, NULL, 3, NULL, NULL, NULL, NULL, NULL, '0', NULL, 'II N 140 ANJANAHARY', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2021-10-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001022', TIMESTAMP '2025-09-10 00:16:01.000000', '1022', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2021-10-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0003', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '752322000486', NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, '346674326', NULL, 'II I 121 BIS AMBONILOHA', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2021-10-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001023', TIMESTAMP '2025-09-10 00:16:01.000000', '1023', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2021-10-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0003', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '802702005608', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '0', NULL, 'II O 140 BIS ANJANAHARY II', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2021-10-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001024', TIMESTAMP '2025-09-10 00:16:01.000000', '1024', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2021-10-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0002', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '742711003971', NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '347416893', NULL, 'II K 36 JA SOAVIMASOANDRO', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2021-10-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001025', TIMESTAMP '2025-09-10 00:16:01.000000', '1025', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2021-10-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0002', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '870531002315', NULL, 0, NULL, NULL, NULL, 3, NULL, NULL, NULL, NULL, NULL, '387118636', NULL, 'LOT VM 92 JG II SAROPODY', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2021-10-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001028', TIMESTAMP '2025-09-10 00:16:01.000000', '1028', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2021-10-01 00:00:00.000000', 'PAF010312', 'TITULAIRE', '0003', 'M2-mini', 1841, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '950514000103', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '0', NULL, 'III A 234 CITE ST JACQUES ANDAFIATSIMO MIJORO', NULL, NULL, NULL, 'CP0000010', 'QUAL0007', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2021-10-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001029', TIMESTAMP '2025-09-10 00:16:01.000000', '1029', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2021-10-01 00:00:00.000000', 'FONC0106238', 'TITULAIRE', '0003', 'M2-mini', 1841, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '862291', NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, '337675447', NULL, 'IAC 05 J ANDRAMAHAVOLA  AMBOHIDRAPETO', NULL, NULL, NULL, 'CP0000010', 'QUAL0007', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2021-10-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001030', TIMESTAMP '2025-09-10 00:16:01.000000', '1030', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2021-10-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0002', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '882711000103', NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, '334353869', NULL, 'IB 176 TER ANDOHARANOFOTSY', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2021-10-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001031', TIMESTAMP '2025-09-10 00:16:01.000000', '1031', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2021-10-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0003', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '890603002753', NULL, 0, NULL, NULL, NULL, 4, NULL, NULL, NULL, NULL, NULL, '386514858', NULL, 'PRES II B 1 AMBODITSIRY', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2021-10-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001032', TIMESTAMP '2025-09-10 00:16:01.000000', '1032', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2021-10-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0002', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '831021000610', NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '345985786', NULL, 'VM 92 JG II SAROPODY', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2021-10-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001033', TIMESTAMP '2025-09-10 00:16:01.000000', '1033', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2022-05-02 00:00:00.000000', 'FONC0106238', 'TITULAIRE', '0002', 'M2-mini', 1841, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '782430000237', NULL, 0, NULL, NULL, NULL, 4, NULL, NULL, NULL, NULL, NULL, '0', NULL, 'III S 121 TER OUEST MANANJARA', NULL, NULL, NULL, 'CP0000010', 'QUAL0007', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2022-05-02 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001034', TIMESTAMP '2025-09-10 00:16:01.000000', '1034', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2022-05-02 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0003', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '900312001939', NULL, 0, NULL, NULL, NULL, 4, NULL, NULL, NULL, NULL, NULL, '346854480', NULL, 'IVL 28 BIS ANKADIFOTSY ANTANIFOTSY', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2022-05-02 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001037', TIMESTAMP '2025-09-10 00:16:01.000000', '1037', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2022-05-02 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0002', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '812325004883', NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, '332974743', NULL, 'LOT II A 78 C AMBATOMAINTY', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2022-05-02 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001038', TIMESTAMP '2025-09-10 00:16:01.000000', '1038', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2022-05-02 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0003', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '840823005406', NULL, 0, NULL, NULL, NULL, 3, NULL, NULL, NULL, NULL, NULL, '342777618', NULL, 'LOT IVM 29 AMBODIVONA ANKADIFOTSY', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2022-05-02 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001039', TIMESTAMP '2025-09-10 00:16:01.000000', '1039', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2022-05-02 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0003', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '920911001953', NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '342014058', NULL, 'II C 07 ANKARAOBATO', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2022-05-02 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001040', TIMESTAMP '2025-09-10 00:16:01.000000', '1040', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2022-05-02 00:00:00.000000', 'PAF010307', 'TITULAIRE', '0002', 'M2-mini', 1841, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '940721002563', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '0347435634/0324876109', NULL, 'LOT II A 204 TANJOMBATO', NULL, NULL, NULL, 'CP0000010', 'QUAL0007', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2022-05-02 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001041', TIMESTAMP '2025-09-10 00:16:01.000000', '1041', NULL, NULL, 'SIT01', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2022-05-02 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0003', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '101251170567', NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, '381345277', NULL, 'II N 26 JKB ANALAMAHITSY TANANA', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2022-05-02 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001042', TIMESTAMP '2025-09-10 00:16:01.000000', '1042', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2022-05-02 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0002', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '961007000765', NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, '0', NULL, 'VV 201 TER T ANJANAHARY', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2022-05-02 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001043', TIMESTAMP '2025-09-10 00:16:01.000000', '1043', NULL, NULL, 'SIT01', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2022-05-02 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0003', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '101221127976', NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '384510034', NULL, 'LOT VN 56 BIS AMBOHITSOA  ANKAZOLAVA IVANJA', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2022-05-02 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001044', TIMESTAMP '2025-09-10 00:16:01.000000', '1044', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2022-05-02 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0003', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '950504001827', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '348644520', NULL, 'VM 92 A BIS SAROPODY', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2022-05-02 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001045', TIMESTAMP '2025-09-10 00:16:01.000000', '1045', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2022-05-02 00:00:00.000000', 'PAF010319', 'TITULAIRE', '0002', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '900920001868', NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, '348575350', NULL, 'IC 110 BIS ANKADILALAMPOTSY', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2022-05-02 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001046', TIMESTAMP '2025-09-10 00:16:01.000000', '1046', NULL, NULL, 'SIT01', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2022-05-02 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0003', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '990212000235', NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, '349988608', NULL, 'VM 88 SAROPODY', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2022-05-02 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001047', TIMESTAMP '2025-09-10 00:16:01.000000', '1047', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2022-05-02 00:00:00.000000', 'PAF010327', 'TITULAIRE', '0003', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '720920004693', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '337066455', NULL, 'IVL 211 ANDOHATAPENAKA', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2022-05-02 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001048', TIMESTAMP '2025-09-10 00:16:01.000000', '1048', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2022-05-02 00:00:00.000000', 'PAF010305', 'TITULAIRE', '0002', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '970322000994', NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, '0337603284/0329191362', NULL, 'VM 92 AO TER F SAROPODY', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2022-05-02 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001049', TIMESTAMP '2025-09-10 00:16:01.000000', '1049', NULL, NULL, 'SIT01', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2022-05-02 00:00:00.000000', 'PAF010305', 'TITULAIRE', '0003', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '117191016320', NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, '344243916', NULL, 'IVC 39 ANKARAOBATO', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2022-05-02 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001050', TIMESTAMP '2025-09-10 00:16:01.000000', '1050', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2022-09-01 00:00:00.000000', 'PAF010305', 'TITULAIRE', '0003', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '910720001491', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '0', NULL, 'AB 156 AMBOVOKELY AMBOHIMANGAKELY', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2022-09-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001051', TIMESTAMP '2025-09-10 00:16:01.000000', '1051', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2022-09-01 00:00:00.000000', 'PAF010322', 'TITULAIRE', '0002', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '921007002247', NULL, 0, NULL, NULL, NULL, 4, NULL, NULL, NULL, NULL, NULL, '385634911', NULL, 'JKD AMPEFILOHA AMBOHIJOKY', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2022-09-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001052', TIMESTAMP '2025-09-10 00:16:01.000000', '1052', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2022-09-01 00:00:00.000000', 'PAF00062', 'TITULAIRE', '0003', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '117151008169', NULL, 0, NULL, NULL, NULL, 3, NULL, NULL, NULL, NULL, NULL, '380818951', NULL, 'SAROPODY LOT VM 85 A', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2022-09-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001054', TIMESTAMP '2025-09-10 00:16:01.000000', '1054', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2022-09-07 00:00:00.000000', 'FONC0106241', 'TITULAIRE', '0002', 'OP3-5B', 4948, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '106321016084', NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, '349630922', NULL, '1076 BIS 67 HECTARES', NULL, NULL, NULL, 'CP0000010', 'QUAL0040', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2022-09-07 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001055', TIMESTAMP '2025-09-10 00:16:01.000000', '1055', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2022-11-02 00:00:00.000000', 'PAF010319', 'TITULAIRE', '0003', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '880616004914', NULL, 0, NULL, NULL, NULL, 3, NULL, NULL, NULL, NULL, NULL, '346114256', NULL, 'VQ 5 AC MANDROSEZA', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2022-11-02 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001057', TIMESTAMP '2025-09-10 00:16:01.000000', '1057', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2023-04-03 00:00:00.000000', 'PAF010304', 'TITULAIRE', '0003', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '106441014637', NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, '348929370', NULL, 'LT 66 ANKADIKELY', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2023-04-03 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001058', TIMESTAMP '2025-09-10 00:16:01.000000', '1058', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2023-04-03 00:00:00.000000', 'PAF010319', 'TITULAIRE', '0003', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '117151020534', NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '342286177', NULL, 'FA 06 AMBOHIMANATRIKA TANJOMBATO', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2023-04-03 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001059', TIMESTAMP '2025-09-10 00:16:01.000000', '1059', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2023-04-03 00:00:00.000000', 'PAF010305', 'TITULAIRE', '0002', 'OS1-mini', 1855, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '910501004389', NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '337675081', NULL, 'II E 30 QV BIS C AMBOHIDAHY', NULL, NULL, NULL, 'CP0000010', 'QUAL0001', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2023-04-03 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001060', TIMESTAMP '2025-09-10 00:16:01.000000', '1060', NULL, NULL, 'SIT01', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2023-08-01 00:00:00.000000', 'PAF010328', 'TITULAIRE', '0002', 'OP3-5B', 4948, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '101242189458', NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, '343729199', NULL, 'LOT IV W 4B ANOSIZATO EST II', NULL, NULL, NULL, 'CP0000010', 'QUAL0040', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2023-08-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001061', TIMESTAMP '2025-09-10 00:16:01.000000', '1061', NULL, NULL, 'SIT01', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2023-08-01 00:00:00.000000', 'PAF010315', 'TITULAIRE', '0002', 'HC', 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '101241150882', NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, '0322456213/0380578283', NULL, 'III X 7 B ANOSIBE OUEST II', NULL, NULL, NULL, 'CP0000010', 'QUAL0038', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2023-08-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001062', TIMESTAMP '2025-09-10 00:16:01.000000', '1062', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2023-09-01 00:00:00.000000', 'FONC0106244', 'TITULAIRE', '0002', 'OP3-5B', 3958, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '117151018129', NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '344786919', NULL, 'VH 85 AH SAROPODY', NULL, NULL, NULL, 'CP0000010', 'QUAL0040', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2023-09-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001063', TIMESTAMP '2025-09-10 00:16:01.000000', '1063', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2023-12-01 00:00:00.000000', 'FONC0106234', 'TITULAIRE', '0002', 'HC', 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '101251090267', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '0', NULL, 'LOT 21 D IMERINAFOVOANY TALATAMATY', NULL, NULL, NULL, 'CP0000010', 'QUAL0038', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2023-12-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001064', TIMESTAMP '2025-09-10 00:16:01.000000', '1064', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2024-03-01 00:00:00.000000', 'FONC0106232', 'TITULAIRE', '0002', 'OS1-maxi', 1873, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '71111010037D', NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '0', NULL, 'LOT AB 389 BIS III ANTANETY AMBOHIMAMORY', NULL, NULL, NULL, 'CP0000010', 'QUAL0003', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2024-03-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001065', TIMESTAMP '2025-09-10 00:16:01.000000', '1065', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2024-03-01 00:00:00.000000', 'FONC0106235', 'TITULAIRE', '0003', 'M2-mini', 1841, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '780313005370', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '0', NULL, 'ANTANETIBE AAVARABOHITRA TSIAFAHY', NULL, NULL, NULL, 'CP0000010', 'QUAL0007', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2024-03-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001066', TIMESTAMP '2025-09-10 00:16:01.000000', '1066', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2024-03-01 00:00:00.000000', 'PAF010312', 'TITULAIRE', '0003', 'M2-mini', 1841, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '961027001660', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '0332169546/0346501646', NULL, 'LOT PRES VM 88 B BIS SAROPODY', NULL, NULL, NULL, 'CP0000010', 'QUAL0007', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2024-03-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001067', TIMESTAMP '2025-09-10 00:16:01.000000', '1067', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2024-03-01 00:00:00.000000', 'PAF010312', 'TITULAIRE', '0003', 'M2-mini', 1841, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '940108000454', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '384786177', NULL, 'LOT III U 69 ANOSIMAHAVELONA ANKAZOTOHA', NULL, NULL, NULL, 'CP0000010', 'QUAL0007', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2024-03-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001068', TIMESTAMP '2025-09-10 00:16:01.000000', '1068', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2024-03-01 00:00:00.000000', 'PAF00003', 'TITULAIRE', '0003', 'M2-mini', 1841, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '731229003029', NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, '0', NULL, 'SAROPODY', NULL, NULL, NULL, 'CP0000010', 'QUAL0007', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2024-03-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001069', TIMESTAMP '2025-09-10 00:16:01.000000', '1069', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2024-03-01 00:00:00.000000', 'PAF00003', 'TITULAIRE', '0003', 'M2-mini', 1841, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '901005004180', NULL, 0, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, '348987578', NULL, 'LOT A 222 ANDAVAMAMBA', NULL, NULL, NULL, 'CP0000010', 'QUAL0007', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2024-03-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001070', TIMESTAMP '2025-09-10 00:16:01.000000', '1070', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2024-03-01 00:00:00.000000', 'PAF00003', 'TITULAIRE', '0003', 'M2-mini', 1841, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '990128001871', NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '380804619', NULL, 'ANKADIMBAHOAKA', NULL, NULL, NULL, 'CP0000010', 'QUAL0007', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2024-03-01 00:00:00.000000', NULL, NULL, 'TYP0000002');
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, LIEU_NAISSANCE_COMMUNE, LIEU_DELIVRANCE_CIN, SITUATION_MATRIMONIAL, INITIALE, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, IDCONJOINT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, DATEEMBAUCHE, IDFONCTION, IDCATEGORIE, MODE_PAIEMENT, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, DROIT_HS, VEHICULEE, ECHELON, ETAT, CTG, IDUSER, INDICE_CT, DATEPROMOTION, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, N_EMBAUCHE, DATE_DEPART, N_DEPART, NBENFANT, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, INDESIRABLE, DUREE, TELEPHONE, MAIL, ADRESSE_LIGNE1, ADRESSE_LIGNE2, CODE_POSTAL, REGION, IDCATEGORIE_PAIE, IDQUALIFICATION, FORMATION, DISCIPLINE, ANNEEEXPERIENCE, PERSONNEL_ETAT, PERIODE_ESSAI, DEBUTCONTRAT, FINCONTRAT, REFUSER, TYPECONTRAT)
VALUES('PRS001072', TIMESTAMP '2025-09-10 00:16:01.000000', '1072', NULL, NULL, 'SIT02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2024-03-01 00:00:00.000000', 'PAF00003', 'TITULAIRE', '0002', 'M2-mini', 1841, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '700419001451', NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '340389395', NULL, 'ANDRANOMANALINA CENTRE', NULL, NULL, NULL, 'CP0000010', 'QUAL0007', NULL, NULL, NULL, NULL, NULL, TIMESTAMP '2024-03-01 00:00:00.000000', NULL, NULL, 'TYP0000002');

--- log_personnel --- (TITULAIRE)
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000643', NULL, ' ', ' ', 'PERS000643', 'RAHAJANIRINA', 'VOLOLONIAINA', TIMESTAMP '1976-03-27 00:00:00.000000', '0', '101232103208', NULL, NULL, 'Malagasy', 'LOTIIB 122 BIS G MANJAKARAY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000653', NULL, ' ', ' ', 'PERS000653', 'RANDRIAMANANTENA', 'JEAN HILARIEN S', TIMESTAMP '1971-04-22 00:00:00.000000', '1', '106091000419', NULL, NULL, 'Malagasy', 'LOT IIN 138 E ANJANAHARY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000665', NULL, ' ', ' ', 'PERS000665', 'RAFARALAHY', 'JEAN CHRIST', TIMESTAMP '1971-04-24 00:00:00.000000', '1', '102071000001', NULL, NULL, 'Malagasy', 'ANTANANDRANO LOT 113 A', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000668', NULL, ' ', ' ', 'PERS000668', 'RANDRIAMIHAJA', 'JOHNNY HARILALA', TIMESTAMP '1974-04-16 00:00:00.000000', '1', '101231096065', NULL, NULL, 'Malagasy', 'B 94 ANDAFIAVARATRA AMBOHITRARAHABA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000670', NULL, ' ', ' ', 'PERS000670', 'RAZAIARISOA', 'LANTO', TIMESTAMP '1969-12-15 00:00:00.000000', '0', '101252069045', NULL, NULL, 'Malagasy', 'LOT II B 1 C MANJAKARAY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000684', NULL, ' ', ' ', 'PERS000684', 'RANDRIANARIVELO', 'LEON JOSE', TIMESTAMP '1976-01-23 00:00:00.000000', '1', '106361011751', NULL, NULL, 'Malagasy', 'LOT II G 10 BIS FY AMBATOMARO', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000687', NULL, ' ', ' ', 'PERS000687', 'RAMAHEFARIVOSON', 'LOVA TIANDRAIBE', TIMESTAMP '1967-02-07 00:00:00.000000', '1', '101231082532', NULL, NULL, 'Malagasy', 'LOT APN 17 BIS AMBATOLAMPY AMBOHITRIMANJAKA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000689', NULL, ' ', ' ', 'PERS000689', 'RANDRINDRA', 'ANTONIO', TIMESTAMP '1970-08-03 00:00:00.000000', '1', '101251072473', NULL, NULL, 'Malagasy', 'LOT II N 10  AMBATOBE', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000702', NULL, ' ', ' ', 'PERS000702', 'RAZANAKOTO', 'ANDRY BENJAMINA', TIMESTAMP '1976-04-13 00:00:00.000000', '1', '101251090363', NULL, NULL, 'Malagasy', 'LOT II N 151 ANJANAHARY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000703', NULL, ' ', ' ', 'PERS000703', 'RAMBALASOA', 'ANDRIAMIHAJA', TIMESTAMP '1976-09-08 00:00:00.000000', '1', '101251091627', NULL, NULL, 'Malagasy', 'LOT II C 72 E MANJAKARAY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000716', NULL, ' ', ' ', 'PERS000716', 'RAKOTOARISON', 'GUY OLIVIER', TIMESTAMP '1975-02-26 00:00:00.000000', '1', '101251080574', NULL, NULL, 'Malagasy', 'IID 67 MANJAKARAY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000733', NULL, ' ', ' ', 'PERS000733', 'RANDRIANARISOA', 'BODOMIHANTARIFI', TIMESTAMP '1975-09-27 00:00:00.000000', '1', '101232105468', NULL, NULL, 'Malagasy', 'II B 105 B AMBATOMAINTY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000739', NULL, ' ', ' ', 'PERS000739', 'RAZANADRASOA', 'IHARINIRINA', TIMESTAMP '1966-06-12 00:00:00.000000', '0', '101232075004', NULL, NULL, 'Malagasy', 'LOT IVI 10 ANDRAVOAHANGY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000742', NULL, ' ', ' ', 'PERS000742', 'RABEZARISON', 'JOSEA NICOLE', TIMESTAMP '1967-04-27 00:00:00.000000', '0', '101212100756', NULL, NULL, 'Malagasy', 'CITE 267  AMBODIN''ISOTRY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000743', NULL, ' ', ' ', 'PERS000743', 'RAHARIMALALA', 'SYLVIA', TIMESTAMP '1966-01-08 00:00:00.000000', '0', '101242064207', NULL, NULL, 'Malagasy', 'II B 84  AMBATOROKA_x000D_', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000750', NULL, ' ', ' ', 'PERS000750', 'RAMAMONJISOA', 'GILBERTHINE', TIMESTAMP '1967-08-01 00:00:00.000000', '0', '101232094467', NULL, NULL, 'Malagasy', 'LOT IIO 109 C ANJANAHARY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000754', NULL, ' ', ' ', 'PERS000754', 'RATIARAY', 'FANJANIAINA CHANTAL', TIMESTAMP '1976-04-27 00:00:00.000000', '0', '102312000719', NULL, NULL, 'Malagasy', 'LOT VM 88 CAB SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000755', NULL, ' ', ' ', 'PERS000755', 'RAZAFIARISOA', 'LALATIANA VEROSOA JULIETTE', TIMESTAMP '1975-03-21 00:00:00.000000', '0', '117012005340', NULL, NULL, 'Malagasy', 'LOT II J 120  AF  AMBODIVOANJO', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000757', NULL, ' ', ' ', 'PERS000757', 'RANDRIAMIHAJA', 'JEAN', TIMESTAMP '1973-09-07 00:00:00.000000', '1', '101251084062', NULL, NULL, 'Malagasy', 'LOT II E 6 TER AMBOHIMIRARY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000758', NULL, ' ', ' ', 'PERS000758', 'RAKOTONIRINA', 'HALISOA SEDY', TIMESTAMP '1977-12-21 00:00:00.000000', '1', '101251096435', NULL, NULL, 'Malagasy', 'LOT II C 70 MANJAKARAY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000760', NULL, ' ', ' ', 'PERS000760', 'RAZANAKOLONA', 'TOJONIRINA ANDRIAMISAINA AMBININTSOA', TIMESTAMP '1978-08-15 00:00:00.000000', '1', '101251099384', NULL, NULL, 'Malagasy', 'LOT II E 26 DA IADIAMBOLA NANISANA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000762', NULL, ' ', ' ', 'PERS000762', 'RAHERIFANJANIRINA', 'NOELINE', TIMESTAMP '1977-07-14 00:00:00.000000', '0', '101212144232', NULL, NULL, 'Malagasy', 'ANTANIMENAKELY_x000D_', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000764', NULL, ' ', ' ', 'PERS000764', 'RAZAOARINATOANDRO', 'PAQUITA', TIMESTAMP '1976-08-09 00:00:00.000000', '0', '101252096532', NULL, NULL, 'Malagasy', 'LOT II S 40 T ANJANAHARY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000765', NULL, ' ', ' ', 'PERS000765', 'RAVELOARISOA', 'MARGUERITE', TIMESTAMP '1967-05-28 00:00:00.000000', '0', '102092000621', NULL, NULL, 'Malagasy', 'LOT 162 B II TSARAHASINA AMBOHIMANGAKELY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000774', NULL, ' ', ' ', 'PERS000774', 'RAHOLIARIMANANA', 'EMILIENNE CLARA', TIMESTAMP '1977-12-16 00:00:00.000000', '0', '101252096948', NULL, NULL, 'Malagasy', 'LOT 131 TER MANJAKA ILAFY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000777', NULL, ' ', ' ', 'PERS000777', 'RAMANANTENA', 'JULIENNE', TIMESTAMP '1966-01-25 00:00:00.000000', '0', '101212096944', NULL, NULL, 'Malagasy', 'LOT III V 86 AD BIS PRES ANOSIZATO EST I', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000781', NULL, ' ', ' ', 'PERS000781', 'RAHARIVOLOLONA', 'LAURENCE AMELIE', TIMESTAMP '1967-10-07 00:00:00.000000', '0', '101252062870', NULL, NULL, 'Malagasy', 'LOT II N 26 JKB ANALAMAHITSY TANANA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000785', NULL, ' ', ' ', 'PERS000785', 'RASOAZANAMANANA', 'EMILIENNE CAROLINE', TIMESTAMP '1976-06-15 00:00:00.000000', '0', '101252090097', NULL, NULL, 'Malagasy', 'LOT II A 63 AMBATOMAINTY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000786', NULL, ' ', ' ', 'PERS000786', 'JAOMAMISOA', 'JUSTIN', TIMESTAMP '1983-03-03 00:00:00.000000', '1', '111011008414', NULL, NULL, 'Malagasy', 'LOT VM 89 X  SAROPODY ANDRONDRAKELY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000789', NULL, ' ', ' ', 'PERS000789', 'ANDRIANONY', 'JOSOA', TIMESTAMP '1973-05-14 00:00:00.000000', '1', '102091003049', NULL, NULL, 'Malagasy', 'LOT F III L 11 MANANENASOA AMBOHIMANGAKELY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000795', NULL, ' ', ' ', 'PERS000795', 'RAMANATOMBOTSOA', 'SOLONJATOVO', TIMESTAMP '1977-01-16 00:00:00.000000', '1', '101251103750', NULL, NULL, 'Malagasy', 'LOT057 F TER AMBOHIBAO ANTEHIROKA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000799', NULL, ' ', ' ', 'PERS000799', 'SALIM', 'HERVE', TIMESTAMP '1974-02-27 00:00:00.000000', '1', '113091010048', NULL, NULL, 'Malagasy', 'LOT VS 67 BIS ANTSAHONDRA  MANJAKAMIADANA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000800', NULL, ' ', ' ', 'PERS000800', 'RAZAFIMAMONJY', 'HAINGO JOACHIM', TIMESTAMP '1967-04-03 00:00:00.000000', '1', '101251057651', NULL, NULL, 'Malagasy', 'LOT II N 138 RA ANJANAHARY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000801', NULL, ' ', ' ', 'PERS000801', 'ANDRIANOMENJANAHARY', 'RAMAHEFARIVO RADOLALAINA', TIMESTAMP '1976-12-05 00:00:00.000000', '1', '103131004371', NULL, NULL, 'Malagasy', 'LOT III H 30 B ANDREFAN''AMBOHIJANAHARY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000802', NULL, ' ', ' ', 'PERS000802', 'MANDRINDRASOA', 'NOROLALAINA', TIMESTAMP '1978-06-04 00:00:00.000000', '0', '101212140395', NULL, NULL, 'Malagasy', 'LOT292 AI BIS AMBOHIMANGAKELY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000803', NULL, ' ', ' ', 'PERS000803', 'RANDRIANARIVONY', 'HERILALAINA FREDERIC', TIMESTAMP '1979-10-01 00:00:00.000000', '1', '101251113088', NULL, NULL, 'Malagasy', 'LOT II N 20 D ANALAMAHITSY TANANA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000805', NULL, ' ', ' ', 'PERS000805', 'RAKOTOARISOA', 'SOLOFOHERY FREDERIC', TIMESTAMP '1982-03-23 00:00:00.000000', '1', '101251120398', NULL, NULL, 'Malagasy', 'LOT N° 509 QUATER CITE ANALAMAHITSY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000806', NULL, ' ', ' ', 'PERS000806', 'ANDRIAKOTONIAINA', 'HARILANTO', TIMESTAMP '1970-07-11 00:00:00.000000', '1', '501011001064', NULL, NULL, 'Malagasy', 'II A 92 TER AB ANJANAHARY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000809', NULL, ' ', ' ', 'PERS000809', 'RAKOTOELISON', 'NJARA TOKY FENOSOA', TIMESTAMP '1984-07-22 00:00:00.000000', '1', '102371004191', NULL, NULL, 'Malagasy', 'LOT IVF 58 BEHORIIRIKA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000811', NULL, ' ', ' ', 'PERS000811', 'RANAIVOARIMBOLA', 'JOACHIM DIETRICH', TIMESTAMP '1981-07-17 00:00:00.000000', '1', '117151006532', NULL, NULL, 'Malagasy', 'LOT VM 88 CAB_x000D_
 SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000812', NULL, ' ', ' ', 'PERS000812', 'HERINJAKA', 'JOSIA PASCAL', TIMESTAMP '1974-04-24 00:00:00.000000', '1', '114011007585', NULL, NULL, 'Malagasy', 'LOT III S 115 BIS AD ANOSIBE AMBOHIBARIKELY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000815', NULL, ' ', ' ', 'PERS000815', 'RAKOTOARISOA', 'ANDRIANTSIALONINA', TIMESTAMP '1983-06-20 00:00:00.000000', '1', '101251128303', NULL, NULL, 'Malagasy', 'LOT II I 122 TER  ALAROBIA AMBONILOHA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000820', NULL, ' ', ' ', 'PERS000820', 'MAX', 'HERINIAINA LUCIO LARAH', TIMESTAMP '1985-07-27 00:00:00.000000', '1', '101231130560', NULL, NULL, 'Malagasy', 'LOT F II 90 BIS AMBOHIMAHITSY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000827', NULL, ' ', ' ', 'PERS000827', 'RATSIMBAZAFY', 'SOLOFONIAINA ROBEL', TIMESTAMP '1980-02-24 00:00:00.000000', '1', '101211153456', NULL, NULL, 'Malagasy', 'SAROPODY TANJOMBATO', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000828', NULL, ' ', ' ', 'PERS000828', 'ANDRIANARIVONY', 'YVES BRUNO', TIMESTAMP '1969-06-30 00:00:00.000000', '1', '301091003045', NULL, NULL, 'Malagasy', 'AVB 20 A AVARABOHITRA ITAOSY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000829', NULL, ' ', ' ', 'PERS000829', 'RANAIVOZAFINARIVO', 'SOLONIRINA RAMINOSON', TIMESTAMP '1982-11-08 00:00:00.000000', '1', '101221077839', NULL, NULL, 'Malagasy', 'LOT II E 62 J BIS AMPANOTOKANA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000832', NULL, ' ', ' ', 'PERS000832', 'RAMAMONJISOA', 'HARIMANANA GILBERTHIN', TIMESTAMP '1971-06-04 00:00:00.000000', '1', '101241076236', NULL, NULL, 'Malagasy', 'LOT II N 33 A bis ANJANAHARY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000833', NULL, ' ', ' ', 'PERS000833', 'RAKOTOVAO', 'ANDRIANIMARO NIRINA', TIMESTAMP '1976-06-15 00:00:00.000000', '0', '110012004491', NULL, NULL, 'Malagasy', 'LOT II V 138 TER AMPANDRANA  BESARETY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000837', NULL, ' ', ' ', 'PERS000837', 'RABENANDRASANA', 'LIOKA', TIMESTAMP '1972-06-12 00:00:00.000000', '1', '101981043185', NULL, NULL, 'Malagasy', 'LOT II R 80 AMBOHITRAKELY_x000D_
TEL : 033 04 918 51', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000838', NULL, ' ', ' ', 'PERS000838', 'RALANTOTSIVERY', 'HASINA THUBYRS', TIMESTAMP '1974-01-06 00:00:00.000000', '1', '101231094992', NULL, NULL, 'Malagasy', 'LOTII O 85 ANJANAHARY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000841', NULL, ' ', ' ', 'PERS000841', 'RAZAKAMAHEFA', 'HAJANIRINA', TIMESTAMP '1985-06-06 00:00:00.000000', '1', '101231130860', NULL, NULL, 'Malagasy', 'LOT II M 28 BIS MAHAVOKY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000850', NULL, ' ', ' ', 'PERS000850', 'RAHAJANIRINA', 'PRISCA ARISTIDE', TIMESTAMP '1983-01-07 00:00:00.000000', '1', '117331002122', NULL, NULL, 'Malagasy', 'LOT  IIA 15  TANJOMBATO', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000851', NULL, ' ', ' ', 'PERS000851', 'RABARIMANANTENA', 'RIJASON JULES', TIMESTAMP '1983-03-03 00:00:00.000000', '1', '101231120331', NULL, NULL, 'Malagasy', 'LOT II 223 AMPANDRANA EST', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000852', NULL, ' ', ' ', 'PERS000852', 'RAMILISON', 'LALAINA GHISLAIN', TIMESTAMP '1980-09-25 00:00:00.000000', '1', '101231120095', NULL, NULL, 'Malagasy', 'IVK 855/BIS ANOSIVAVAKA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000856', NULL, ' ', ' ', 'PERS000856', 'RAKOTOARIMALALA', 'JULES SOLOFONIAINA', TIMESTAMP '1976-12-20 00:00:00.000000', '1', '101251093505', NULL, NULL, 'Malagasy', 'LOT II E 61 AG AMPANOTOKANA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000863', NULL, ' ', ' ', 'PERS000863', 'ANDRIANARIVELO', 'MAMINIRINA', TIMESTAMP '1971-12-23 00:00:00.000000', '1', '101251073996', NULL, NULL, 'Malagasy', 'LOT VT 85  FD ANDOHANIMANDROSEZA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000865', NULL, ' ', ' ', 'PERS000865', 'RAVELOJAONA', 'TIANA MANITRA', TIMESTAMP '1988-10-28 00:00:00.000000', '1', '101211186998', NULL, NULL, 'Malagasy', 'LOT AE 2 BIS ANDRONONOBE', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000870', NULL, ' ', ' ', 'PERS000870', 'RAHARIMANANA', 'BERNADETTE', TIMESTAMP '1971-01-28 00:00:00.000000', '0', '101212116580', NULL, NULL, 'Malagasy', 'LOT IVC 108 F AMBOHIMANDROSO AMBOHIMANARINA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000871', NULL, ' ', ' ', 'PERS000871', 'RAKOTOARISOA', '-', TIMESTAMP '1974-11-30 00:00:00.000000', '1', '117011003756', NULL, NULL, 'Malagasy', 'LOT CM 94 MALAZA AMPITATAFIKA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000872', NULL, ' ', ' ', 'PERS000872', 'RANDRIAMBOLOLONA', 'HENRI PATRICK', TIMESTAMP '1986-08-11 00:00:00.000000', '1', '101251139739', NULL, NULL, 'Malagasy', 'LOT II E 108 TER MANJAKARAY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000873', NULL, ' ', ' ', 'PERS000873', 'RANDRIANANDRASANA', 'HAJATIANA', TIMESTAMP '1985-10-25 00:00:00.000000', '1', '101251134196', NULL, NULL, 'Malagasy', 'LOT II B 108 K AA AMBATOMAINTY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000879', NULL, ' ', ' ', 'PERS000879', 'RASOLOFOSON', 'JULIEN FREDERIC', TIMESTAMP '1970-01-19 00:00:00.000000', '1', '101231087422', NULL, NULL, 'Malagasy', 'ANKORONDRANO', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000883', NULL, ' ', ' ', 'PERS000883', 'RAHARINOMENJANAHARY', 'MASY TANTELY', TIMESTAMP '1986-07-11 00:00:00.000000', '1', '101231134430', NULL, NULL, 'Malagasy', 'LOT BL 38 BELAMBANANA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000884', NULL, ' ', ' ', 'PERS000884', 'RAZAFINDRABEARINORO', 'HARY LOVA', TIMESTAMP '1985-06-18 00:00:00.000000', '0', '101252132099', NULL, NULL, 'Malagasy', 'LOT II B 105 TER A AMBATOMAINTY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000885', NULL, ' ', ' ', 'PERS000885', 'MBOLANOMENJANAHARY', 'SARINDRA', TIMESTAMP '1985-06-05 00:00:00.000000', '0', '101252138710', NULL, NULL, 'Malagasy', 'LOT IIN 26 K BIS ANALAMAHITSY TANANA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000889', NULL, ' ', ' ', 'PERS000889', 'RARIVOARISON', 'ANDRY HERIZO', TIMESTAMP '1978-04-26 00:00:00.000000', '1', '108071007871', NULL, NULL, 'Malagasy', 'LOT IVK 127 BIS ANKADIFOTSY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000892', NULL, ' ', ' ', 'PERS000892', 'RAHARIMANANIRINA', 'SOLOFOTIANA NADIA', TIMESTAMP '1990-07-14 00:00:00.000000', '0', '101252156501', NULL, NULL, 'Malagasy', 'LOT IV 33 BIS MAHAZO', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000893', NULL, ' ', ' ', 'PERS000893', 'RAKOTOARISOA', 'ZO MALALALA MANDIAHERY', TIMESTAMP '1986-01-17 00:00:00.000000', '0', '106302028432', NULL, NULL, 'Malagasy', 'LOT II 452 O AMBOHITRINIMANGA ANOSY AVARATRA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000895', NULL, ' ', ' ', 'PERS000895', 'RANDRIAHARIVELO', 'AINA NOMENJANAHARY TAHINA', TIMESTAMP '1974-06-29 00:00:00.000000', '1', '106301021855', NULL, NULL, 'Malagasy', 'LOT II G 1ô BIS GSU AMBATOMARO ANTSOBOLO', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000897', NULL, ' ', ' ', 'PERS000897', 'RANDRIANALISON', 'PATRICK MAMY', TIMESTAMP '1971-02-06 00:00:00.000000', '1', '101211119397', NULL, NULL, 'Malagasy', 'LOT IVL 131 BIS ANDOHATAPENAKA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000904', NULL, ' ', ' ', 'PERS000904', 'RAZAKANIRINA', 'HASINA TOLOJANAHARY', TIMESTAMP '1987-01-19 00:00:00.000000', '1', '102051004188', NULL, NULL, 'Malagasy', 'LOT AB 250 A BIS AMBOHIMANAMBOLA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000905', NULL, ' ', ' ', 'PERS000905', 'RAZANAMANGA', 'PAULINE MARIE LOUISE', TIMESTAMP '1979-07-25 00:00:00.000000', '0', '105232004453', NULL, NULL, 'Malagasy', 'LOT AB 138 /II AMBODIRANO', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000910', NULL, ' ', ' ', 'PERS000910', 'RAVELOSAONA', 'MANITRISA CHRISTIANE', TIMESTAMP '1987-12-25 00:00:00.000000', '0', '110012011845', NULL, NULL, 'Malagasy', 'LOT BM 87 BIS AMBOHIDAVENONA AMPITATAFIKA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000912', NULL, ' ', ' ', 'PERS000912', 'RAVELOSON', 'HERY', TIMESTAMP '1983-11-20 00:00:00.000000', '1', '101241117416', NULL, NULL, 'Malagasy', 'SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000914', NULL, ' ', ' ', 'PERS000914', 'RAKOTOARISON', 'ALBERT', TIMESTAMP '1969-07-07 00:00:00.000000', '1', '102231000270', NULL, NULL, 'Malagasy', 'IVC 39 TER AMBODIVOANJO', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000915', NULL, ' ', ' ', 'PERS000915', 'ANDRIARIMALALA', 'JONAH', TIMESTAMP '1987-02-01 00:00:00.000000', '1', '101981072096', NULL, NULL, 'Malagasy', 'IJ M 4106 ITAOSY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000916', NULL, ' ', ' ', 'PERS000916', 'RANAIVOSON', 'MAMPIONONA', TIMESTAMP '1989-03-18 00:00:00.000000', '1', '117231004298', NULL, NULL, 'Malagasy', 'IAC 86 A ANDRAMAHAVOLA  ITAOSY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000918', NULL, ' ', ' ', 'PERS000918', 'ANDRIAMPARANY', 'RAVOFETRA HONORE', TIMESTAMP '1987-03-22 00:00:00.000000', '1', '102311003574', NULL, NULL, 'Malagasy', 'AB 455 BIS AMPITATAFIKA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000919', NULL, ' ', ' ', 'PERS000919', 'RAKOTOMALALA', 'DONNE', TIMESTAMP '1975-09-20 00:00:00.000000', '1', '101221065533', NULL, NULL, 'Malagasy', 'VM 88 CC BIS SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000920', NULL, ' ', ' ', 'PERS000920', 'RASOALIMANANA', 'ALINE', TIMESTAMP '1973-09-23 00:00:00.000000', '0', '117172002441', NULL, NULL, 'Malagasy', 'VF 164 BIS VOLOTARA ANDOHARANOFOTSY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000921', NULL, ' ', ' ', 'PERS000921', 'RAZAFINARIVO', 'MANANTOANDRO BENJAMIN', TIMESTAMP '1974-04-13 00:00:00.000000', '1', '106501009009', NULL, NULL, 'Malagasy', 'II N 09 BIS ANJANAHARY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000923', NULL, ' ', ' ', 'PERS000923', 'RANDRIANANDRASANA', 'JAMES', TIMESTAMP '1985-09-14 00:00:00.000000', '1', '101221082721', NULL, NULL, 'Malagasy', 'VW 151 A BIS TSIMBAZAZA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000925', NULL, ' ', ' ', 'PERS000925', 'RAHARIMALALA', 'FRANCINE LAURENCE', TIMESTAMP '1969-03-14 00:00:00.000000', '0', '101242073721', NULL, NULL, 'Malagasy', 'III A 83 TSIMIALONJAFY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000926', NULL, ' ', ' ', 'PERS000926', 'RAHARIMALALA', 'SOLO NAMPIONONA', TIMESTAMP '1981-10-20 00:00:00.000000', '0', '101232122395', NULL, NULL, 'Malagasy', 'II B 109 MANJAKARAY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000928', NULL, ' ', ' ', 'PERS000928', 'RAKOTOANDRIANJAKARIVONY', 'JOSOA RICHARD', TIMESTAMP '1987-08-15 00:00:00.000000', '1', '117151011453', NULL, NULL, 'Malagasy', 'III A 26 BIS ANDAFIATSIMO TANJOMBATO', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000929', NULL, ' ', ' ', 'PERS000929', 'RAKOTONDRAIBE', 'TOLOTRA DIMBINIAINA', TIMESTAMP '1985-09-03 00:00:00.000000', '1', '117191006478', NULL, NULL, 'Malagasy', 'IC 196 TER ANKADILALAMPOTSY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000930', NULL, ' ', ' ', 'PERS000930', 'RABEARIVELO', 'MAMY NIRIANA AUGUSTIN', TIMESTAMP '1980-09-12 00:00:00.000000', '1', '115091008771', NULL, NULL, 'Malagasy', '114 AI ANTANAMBAO AMBOHIMANGAKELY_x000D_', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000932', NULL, ' ', ' ', 'PERS000932', 'ANDRIANARISOA', 'ALAIN', TIMESTAMP '1966-12-05 00:00:00.000000', '1', '101251060794', NULL, NULL, 'Malagasy', 'II A 38 Z AMBATOMAINTY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000933', NULL, ' ', ' ', 'PERS000933', 'ANDRIAMIANDRISOA', 'JACKY PATRICK', TIMESTAMP '1989-03-18 00:00:00.000000', '1', '101241136367', NULL, NULL, 'Malagasy', 'III S 181 TER ANDREFAN`AMBOHIJANAHARY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000934', NULL, ' ', ' ', 'PERS000934', 'RAFANOMEZANTSOA', 'RIVONIAINA', TIMESTAMP '1977-04-26 00:00:00.000000', '1', '101251097981', NULL, NULL, 'Malagasy', 'II G 3 V Z TER D ANTSAHAKELY AMBATOMARO', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000935', NULL, ' ', ' ', 'PERS000935', 'RAJAONARIVO', 'FANOMEZANTSOA BERNARDIN', TIMESTAMP '1987-11-19 00:00:00.000000', '1', '101251145417', NULL, NULL, 'Malagasy', 'VM 92 OVZ SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000936', NULL, ' ', ' ', 'PERS000936', 'RAKOTOMANGA', 'HAINGOTIANA JEAN CHARLES', TIMESTAMP '1981-08-17 00:00:00.000000', '1', '101251116875', NULL, NULL, 'Malagasy', 'II N 22 B ANALAMAHITSY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000937', NULL, ' ', ' ', 'PERS000937', 'RAMAKAVELO', 'RAHARISOA BAKOLY', TIMESTAMP '1981-03-23 00:00:00.000000', '0', '101212158008', NULL, NULL, 'Malagasy', 'IVP 72 ANTSALOVANA ANTOHOMADINIKA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000939', NULL, ' ', ' ', 'PERS000939', 'RANDRIANJATOVO', 'NIRINA MONIQUE', TIMESTAMP '1972-04-17 00:00:00.000000', '0', '107232001008', NULL, NULL, 'Malagasy', 'II N 26 JKB ANALAMAHITSY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000940', NULL, ' ', ' ', 'PERS000940', 'RAOILISON', 'SITRAKINIAINA JEAN ERIC', TIMESTAMP '1988-09-27 00:00:00.000000', '1', '101251152086', NULL, NULL, 'Malagasy', 'G III 28 SOAMANANDRARINY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000941', NULL, ' ', ' ', 'PERS000941', 'MINOSOA', 'HANITRINIALA ANDRIANTAHIANARIVONY', TIMESTAMP '1979-07-27 00:00:00.000000', '0', '101252112793', NULL, NULL, 'Malagasy', 'II O 120 L BIS ANJANAHARY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000942', NULL, ' ', ' ', 'PERS000942', 'RAKOTOMAHARO', 'TOKINIAINA FANIRY', TIMESTAMP '1987-10-23 00:00:00.000000', '1', '101231136440', NULL, NULL, 'Malagasy', 'IIM 43 TER MAHAVOKY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000944', NULL, ' ', ' ', 'PERS000944', 'RABEARIMALALA', 'MAHENINA MATIA', TIMESTAMP '1989-08-13 00:00:00.000000', '1', '106301030729', NULL, NULL, 'Malagasy', 'VF 176 VOLOTARA ANDOHARANOFOTSY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000945', NULL, ' ', ' ', 'PERS000945', 'RANDRIANOELONA', 'HAJA JEAN MICHEL', TIMESTAMP '1972-02-27 00:00:00.000000', '1', '117351001695', NULL, NULL, 'Malagasy', 'G VI 55 TER A AMBANIVATO SOAMANANDRARINY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000946', NULL, ' ', ' ', 'PERS000946', 'RAKOTONIAINA', 'ANDRIAMAHEFA RAYMOND', TIMESTAMP '1971-07-20 00:00:00.000000', '1', '313011003698', NULL, NULL, 'Malagasy', 'LOT VM 92 ZCA SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000947', NULL, ' ', ' ', 'PERS000947', 'ANDRIANANDRASANA', 'RIJA TOKY', TIMESTAMP '1992-09-10 00:00:00.000000', '1', '102211000882', NULL, NULL, 'Malagasy', 'G III 17 SAOAMANANDRARINY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000948', NULL, ' ', ' ', 'PERS000948', 'RANAIVOARIMANANA', 'ANDRIANTSILAVO EDOUARD', TIMESTAMP '1994-05-15 00:00:00.000000', '1', '101231153908', NULL, NULL, 'Malagasy', 'IVT 5 TSARAMASAY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000949', NULL, ' ', ' ', 'PERS000949', 'RASOLOFONERA', 'MARCELLIN', TIMESTAMP '1968-03-21 00:00:00.000000', '1', '101211064634', NULL, NULL, 'Malagasy', 'NANISANA II A 104 GES', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000950', NULL, ' ', ' ', 'PERS000950', 'ANDRIAMIHARIJAONA', 'TSIORY NAMBININTSOA', TIMESTAMP '1990-10-11 00:00:00.000000', '1', '102031019310', NULL, NULL, 'Malagasy', 'IJM 4018 MANGARIVOTRA ITAOSY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000951', NULL, ' ', ' ', 'PERS000951', 'RANDRIANARISOA', 'FANANTENANA YANNICK NOA', TIMESTAMP '1991-05-02 00:00:00.000000', '1', '102311004632', NULL, NULL, 'Malagasy', 'IVP 91 ANKADIFOTSY BEFELATANANA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000953', NULL, ' ', ' ', 'PERS000953', 'ANDRIAMAMPIANINA', 'ROBERT', TIMESTAMP '1971-12-31 00:00:00.000000', '1', '101241076277', NULL, NULL, 'Malagasy', 'III A 91 TSIMIALONJAFY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000954', NULL, ' ', ' ', 'PERS000954', 'RAKOTONIRINA', 'MAHOLISON FETRA', TIMESTAMP '1985-08-01 00:00:00.000000', '1', '101251138632', NULL, NULL, 'Malagasy', 'II D 75 MANJAKARAY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000955', NULL, ' ', ' ', 'PERS000955', 'RAMANAMISATA', 'RADONIAINA HARINAIVO', TIMESTAMP '1970-07-04 00:00:00.000000', '1', '101241074013', NULL, NULL, 'Malagasy', 'III F 77 BIS MAHAMASINA SUD', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000957', NULL, ' ', ' ', 'PERS000957', 'RAHERINANTENAINA', 'MAMISOA', TIMESTAMP '1983-11-19 00:00:00.000000', '1', '101251127105', NULL, NULL, 'Malagasy', 'MANJAKARAY II B 131', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000958', NULL, ' ', ' ', 'PERS000958', 'RAKOTONARIVO', 'FENOMANANA YVON', TIMESTAMP '1981-12-10 00:00:00.000000', '1', '101241107337', NULL, NULL, 'Malagasy', 'III J 81 B ANDAVAMAMBA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000959', NULL, ' ', ' ', 'PERS000959', 'ANDRIANIRINA', 'LOVASOA', TIMESTAMP '1979-09-16 00:00:00.000000', '1', '102091006648', NULL, NULL, 'Malagasy', 'AB 143 IKIANJA AMBOHIMANGAKELY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000960', NULL, ' ', ' ', 'PERS000960', 'RAMILIJAONA', 'BERNARD', TIMESTAMP '1977-11-26 00:00:00.000000', '1', '106501009610', NULL, NULL, 'Malagasy', 'II G ISFA AMBATOMARO', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000961', NULL, ' ', ' ', 'PERS000961', 'RAHARONANDRASANA', 'HERY LAZA', TIMESTAMP '1988-01-18 00:00:00.000000', '1', '101251149939', NULL, NULL, 'Malagasy', 'II F 33 IMB ANDRAISORO', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000964', NULL, ' ', ' ', 'PERS000964', 'HARISOLOMALALA', 'JOSEANE CLARICE', TIMESTAMP '1971-04-08 00:00:00.000000', '0', '101232092100', NULL, NULL, 'Malagasy', 'VM 88  SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000966', NULL, ' ', ' ', 'PERS000966', 'RANDRIAMANANTENA', 'TOLOTRA FITIAVANA', TIMESTAMP '1994-11-09 00:00:00.000000', '1', '102031025632', NULL, NULL, 'Malagasy', 'CA III 97 TER ANDOHANILEMPONA AMBOHIMIADANA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000967', NULL, ' ', ' ', 'PERS000967', 'RAVELOTAFIKA', 'LOUISETTE', TIMESTAMP '1985-05-27 00:00:00.000000', '0', '101242122717', NULL, NULL, 'Malagasy', 'II A 63 AMBATOMAINTY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000968', NULL, ' ', ' ', 'PERS000968', 'ANDRIANARIVONY', 'RAMPANARIVOSON ALAIN', TIMESTAMP '1976-01-25 00:00:00.000000', '1', '301091008316', NULL, NULL, 'Malagasy', 'II S 34 E ANJANAHARY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000969', NULL, ' ', ' ', 'PERS000969', 'RAHARIVONY', 'HANITRA SYLVIANE', TIMESTAMP '1986-10-28 00:00:00.000000', '0', '101252142696', NULL, NULL, 'Malagasy', 'II C 77 D B MANJAKARAY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000970', NULL, ' ', ' ', 'PERS000970', 'RANDRIANASOLO', 'JEAN YANGOTIANA', TIMESTAMP '1974-12-10 00:00:00.000000', '1', '101211128052', NULL, NULL, 'Malagasy', '200 B ANTANANDRANO', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000971', NULL, ' ', ' ', 'PERS000971', 'RAZAFINDRAMANGAVELO', 'HANTA CLAIRETTE', TIMESTAMP '1987-02-22 00:00:00.000000', '0', '101242128976', NULL, NULL, 'Malagasy', 'III J 52 BIS ANDAVAMAMBA AMBILANIBE', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000973', NULL, ' ', ' ', 'PERS000973', 'RAZAFIMAHATRATRA', 'JEAN DE DIEU', TIMESTAMP '1968-09-06 00:00:00.000000', '1', '401011002117', NULL, NULL, 'Malagasy', 'IVL 215 ANDOHATAPENAKA II', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000974', NULL, ' ', ' ', 'PERS000974', 'RAZAFINDRASATA', 'RADONIRINA ANDRIANINA FRANCK', TIMESTAMP '1986-05-06 00:00:00.000000', '1', '101231134453', NULL, NULL, 'Malagasy', 'II T 47 BESARETY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000976', NULL, ' ', ' ', 'PERS000976', 'RABARIVELO', 'PATRICE', TIMESTAMP '1987-03-23 00:00:00.000000', '1', '101251144112', NULL, NULL, 'Malagasy', 'LOT A 255 BIS ANGAVAO ALASORA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000977', NULL, ' ', ' ', 'PERS000977', 'HARISOANAMBININA', 'TAHIRIZO HERMAN', TIMESTAMP '1987-01-13 00:00:00.000000', '1', '220251007949', NULL, NULL, 'Malagasy', 'VM 88 CO SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000978', NULL, ' ', ' ', 'PERS000978', 'RASOLOFONIRINA', 'CLAUDIA ESPERANCE', TIMESTAMP '1993-08-10 00:00:00.000000', '0', '101252172166', NULL, NULL, 'Malagasy', 'LOT III S 144 TAB OUEST MANANJARA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000979', NULL, ' ', ' ', 'PERS000979', 'MANDRINDRASOA', 'ONJANIAINA MARIETTE', TIMESTAMP '1994-06-09 00:00:00.000000', '0', '102092022135', NULL, NULL, 'Malagasy', 'AMBOHIMANGAKELY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000981', NULL, ' ', ' ', 'PERS000981', 'RAKOTOARINANTENAINA', 'RAVAKA', TIMESTAMP '1989-09-01 00:00:00.000000', '0', '101121144831', NULL, NULL, 'Malagasy', 'LOT IC 184 ANKADILALAMPOTSY ANKARAOBATO', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000983', NULL, ' ', ' ', 'PERS000983', 'RAZANAMINO', 'ZARASOA', TIMESTAMP '1988-06-18 00:00:00.000000', '1', '101251155182', NULL, NULL, 'Malagasy', 'II N 138 B ANJANAHARY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000985', NULL, ' ', ' ', 'PERS000985', 'RAZAFINDRASOA', 'SANDRATRINIAINA JACQUELINE', TIMESTAMP '1995-09-20 00:00:00.000000', '0', '117192012445', NULL, NULL, 'Malagasy', 'LOT III C 105 AMBONIN''AMPAHAMARINANA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000989', NULL, ' ', ' ', 'PERS000989', 'RAHARIMANANIVO', 'PAKIZA', TIMESTAMP '1994-03-25 00:00:00.000000', '0', '101252173833', NULL, NULL, 'Malagasy', 'BL 59 BIS BELAMBANANA ANDOHARANOFOTSY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000990', NULL, ' ', ' ', 'PERS000990', 'RANDRIANIAINA', 'CHRISTOPHE', TIMESTAMP '1984-03-26 00:00:00.000000', '1', '117191005616', NULL, NULL, 'Malagasy', 'LOT IC 11 TER  ANKADILALAMPOTSY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000991', NULL, ' ', ' ', 'PERS000991', 'FANJA', 'RAMANANJANAHARY LOVATIANA BARNABE', TIMESTAMP '1971-10-14 00:00:00.000000', '1', '314251004014', NULL, NULL, 'Malagasy', 'II A 181 TANJOMBATO IRAISTIMIVAKY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000994', NULL, ' ', ' ', 'PERS000994', 'RAZANADRAKOTO', 'LALATIANA', TIMESTAMP '1974-06-06 00:00:00.000000', '0', '117032004910', NULL, NULL, 'Malagasy', 'AB 307 AMBODIRANO AMBOHIMAMORY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000997', NULL, ' ', ' ', 'PERS000997', 'RANDRIANARIVELO', 'SOLONIAINA JULIEN LUC', TIMESTAMP '1979-04-13 00:00:00.000000', '1', '101251100567', NULL, NULL, 'Malagasy', '106 BIS MANJAKARAY II C', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000998', NULL, ' ', ' ', 'PERS000998', 'RAHARIJAONA', 'TOLOTRA PATRICK', TIMESTAMP '1984-01-27 00:00:00.000000', '1', '102091014770', NULL, NULL, 'Malagasy', 'BII 161 AMBOHIMANGAKELY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS000999', NULL, ' ', ' ', 'PERS000999', 'MAMINIRINA', 'ARSENE', TIMESTAMP '1966-05-08 00:00:00.000000', '1', '101231075752', NULL, NULL, 'Malagasy', 'H 44 BIS A MANANDONA MERIMANJAKA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001000', NULL, ' ', ' ', 'PERS001000', 'RATOVOARIVELO', 'JOSUE', TIMESTAMP '1989-10-23 00:00:00.000000', '1', '101231142188', NULL, NULL, 'Malagasy', 'IVT 17 TSARAMASAY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001001', NULL, ' ', ' ', 'PERS001001', 'RAZAFINDRAZAKA', 'RIJA RAVAKA', TIMESTAMP '1985-04-21 00:00:00.000000', '1', '101251132726', NULL, NULL, 'Malagasy', 'II E 2 X Q N AMBATOKARANANA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001002', NULL, ' ', ' ', 'PERS001002', 'RAKOTOARISOA', 'TSIRINIAINA JEAN RENE', TIMESTAMP '1994-01-07 00:00:00.000000', '1', '208271006588', NULL, NULL, 'Malagasy', 'VM 90 ANDRONDRAKELY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001005', NULL, ' ', ' ', 'PERS001005', 'ANDRIAMANAMPISOA', 'TIAMBOLA', TIMESTAMP '1993-01-01 00:00:00.000000', '1', '114051013300', NULL, NULL, 'Malagasy', 'III S 144 AFA OUEST MANANJARA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001007', NULL, ' ', ' ', 'PERS001007', 'RAZAFINISAONA', 'GERARD WOLFAND', TIMESTAMP '1974-08-05 00:00:00.000000', '1', '220391000944', NULL, NULL, 'Malagasy', 'LOT ITM 33 AMBODIFASIKA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001009', NULL, ' ', ' ', 'PERS001009', 'ANDRIANARIVELO', 'JULES', TIMESTAMP '1976-05-09 00:00:00.000000', '1', '101231111798', NULL, NULL, 'Malagasy', 'LOT IVT 4 TER TSARAMASAY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001010', NULL, ' ', ' ', 'PERS001010', 'RAKOTONANDRASANA', 'JEAN NANOU ETIENNE', TIMESTAMP '1996-11-11 00:00:00.000000', '1', '101221118755', NULL, NULL, 'Malagasy', 'LOT VT 85 ANDOHANIMANDROSEZA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001012', NULL, ' ', ' ', 'PERS001012', 'RABENJANAHARY', 'MARIE JULIEN', TIMESTAMP '1978-09-18 00:00:00.000000', '1', '117171003956', NULL, NULL, 'Malagasy', 'VM 92 EZ TER SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001014', NULL, ' ', ' ', 'PERS001014', 'ROBIJANAHARY', 'TOKY VALISOA', TIMESTAMP '1996-09-14 00:00:00.000000', '1', '102011016735', NULL, NULL, 'Malagasy', 'AMBOHITROMBY F 41', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001015', NULL, ' ', ' ', 'PERS001015', 'RATIARAIBE', 'ANDRISOA', TIMESTAMP '1987-06-16 00:00:00.000000', '1', '101252141592', NULL, NULL, 'Malagasy', 'II N 156 TER ANJANAHARY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001016', NULL, ' ', ' ', 'PERS001016', 'RABEHARIMISA', 'TSILAVINIAINA MAMPIONONA', TIMESTAMP '1993-07-12 00:00:00.000000', '1', '117191010893', NULL, NULL, 'Malagasy', 'LOT ICO TER B ANKADILALAMPOTSY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001017', NULL, ' ', ' ', 'PERS001017', 'ANDRIATSITOHAINA', 'JEAN', TIMESTAMP '1989-12-05 00:00:00.000000', '1', '102071014719', NULL, NULL, 'Malagasy', 'LOT C 58 A TER AMBOHINAORINA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001018', NULL, ' ', ' ', 'PERS001018', 'RAKOTOMALALA', 'NIAINA JULES', TIMESTAMP '1975-02-04 00:00:00.000000', '1', '101251086548', NULL, NULL, 'Malagasy', 'II H 12 RF ANKERANA ANKADINDRAMAMY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001019', NULL, ' ', ' ', 'PERS001019', 'RALALANIAINA', 'MONIQUE', TIMESTAMP '1970-01-01 00:00:00.000000', '0', '105012007596', NULL, NULL, 'Malagasy', 'LOT BA 252 AMPITATAFIKA  VAOVAO TANA 102', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001020', NULL, ' ', ' ', 'PERS001020', 'RAFARAHARIMISA', 'LOVAMANDIMBIHASINA MILSONNE', TIMESTAMP '1981-03-03 00:00:00.000000', '0', '102072007203', NULL, NULL, 'Malagasy', 'LOT 165 H BIS MANGARIVOTRA SABOTSY NAMEHANA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001021', NULL, ' ', ' ', 'PERS001021', 'RAZANABARIMANANA', 'LALAINA FENOSOA', TIMESTAMP '1980-05-21 00:00:00.000000', '1', '313071004395', NULL, NULL, 'Malagasy', 'II N 140 ANJANAHARY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001022', NULL, ' ', ' ', 'PERS001022', 'MAOLISON', 'LALAINA', TIMESTAMP '1975-03-22 00:00:00.000000', '0', '313012007855', NULL, NULL, 'Malagasy', 'II I 121 BIS AMBONILOHA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001023', NULL, ' ', ' ', 'PERS001023', 'RAVONINJANAHARY', 'FELANA EVASOA', TIMESTAMP '1980-07-02 00:00:00.000000', '0', '101252116301', NULL, NULL, 'Malagasy', 'II O 140 BIS ANJANAHARY II', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001024', NULL, ' ', ' ', 'PERS001024', 'ANDRIAMAMISOA', 'YVANON EDITH', TIMESTAMP '1974-07-11 00:00:00.000000', '0', '101252089129', NULL, NULL, 'Malagasy', 'II K 36 JA SOAVIMASOANDRO', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001025', NULL, ' ', ' ', 'PERS001025', 'RAKOTONDRANAIVO', 'JEAN CHRIST', TIMESTAMP '1987-05-31 00:00:00.000000', '1', '114011023122', NULL, NULL, 'Malagasy', 'LOT VM 92 JG II SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001028', NULL, ' ', ' ', 'PERS001028', 'RAJAONARIZAKA', 'GILBERTIN', TIMESTAMP '1995-05-14 00:00:00.000000', '1', '117151018469', NULL, NULL, 'Malagasy', 'III A 234 CITE ST JACQUES ANDAFIATSIMO MIJORO', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001029', NULL, ' ', ' ', 'PERS001029', 'RAHARIMAHENINA', 'SAHONDRA AIMEE', TIMESTAMP '1970-03-01 00:00:00.000000', '0', '101212125474', NULL, NULL, 'Malagasy', 'IAC 05 J ANDRAMAHAVOLA  AMBOHIDRAPETO', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001030', NULL, ' ', ' ', 'PERS001030', 'MANDRINDRASOA', 'HERIMAMPIONONA RINASOA', TIMESTAMP '1988-07-11 00:00:00.000000', '0', '101212185257', NULL, NULL, 'Malagasy', 'IB 176 TER ANDOHARANOFOTSY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001031', NULL, ' ', ' ', 'PERS001031', 'RAMILIARIJAONA', 'FANOMEZANTSOA', TIMESTAMP '1989-06-03 00:00:00.000000', '1', '101251153038', NULL, NULL, 'Malagasy', 'PRES II B 1 AMBODITSIRY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001032', NULL, ' ', ' ', 'PERS001032', 'RANAIVOJAONA', 'VONJINIAINA ROLLAND', TIMESTAMP '1983-10-21 00:00:00.000000', '1', '101251125626', NULL, NULL, 'Malagasy', 'VM 92 JG II SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001033', NULL, ' ', ' ', 'PERS001033', 'RAJAONERA', 'SEHENONIRINA EUPHEMIE', TIMESTAMP '1978-04-30 00:00:00.000000', '0', '101222065431', NULL, NULL, 'Malagasy', 'III S 121 TER OUEST MANANJARA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001034', NULL, ' ', ' ', 'PERS001034', 'ANDRIMANAMPISOA', 'JEAN ERIC', TIMESTAMP '1990-03-12 00:00:00.000000', '1', '106521014369', NULL, NULL, 'Malagasy', 'IVL 28 BIS ANKADIFOTSY ANTANIFOTSY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001037', NULL, ' ', ' ', 'PERS001037', 'FELANIAINA', 'TANTELY', TIMESTAMP '1981-03-25 00:00:00.000000', '0', '220312005279', NULL, NULL, 'Malagasy', 'LOT II A 78 C AMBATOMAINTY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001038', NULL, ' ', ' ', 'PERS001038', 'RANDRIANIRINA', 'JOSE', TIMESTAMP '1984-08-23 00:00:00.000000', '1', '101251133950', NULL, NULL, 'Malagasy', 'LOT IVM 29 AMBODIVONA ANKADIFOTSY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001039', NULL, ' ', ' ', 'PERS001039', 'RAMAROSON', 'TSIKY FIFALIANA NOMENA', TIMESTAMP '1992-09-11 00:00:00.000000', '1', '117191010397', NULL, NULL, 'Malagasy', 'II C 07 ANKARAOBATO', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001040', NULL, ' ', ' ', 'PERS001040', 'RAKOTONDRANAIVO', 'HERITIANA JOCELYN', TIMESTAMP '1994-07-21 00:00:00.000000', '1', '109371016324', NULL, NULL, 'Malagasy', 'LOT II A 204 TANJOMBATO', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001041', NULL, ' ', ' ', 'PERS001041', 'RANDRIARINAIVO', 'NJATONIRINA MICKAEL', TIMESTAMP '1992-08-20 00:00:00.000000', '1', '101251170567', NULL, NULL, 'Malagasy', 'II N 26 JKB ANALAMAHITSY TANANA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001042', NULL, ' ', ' ', 'PERS001042', 'RAKOTONIAINA', 'MIANDRISOA NANTENAINA H', TIMESTAMP '1996-10-07 00:00:00.000000', '1', '101241171477', NULL, NULL, 'Malagasy', 'VV 201 TER T ANJANAHARY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001043', NULL, ' ', ' ', 'PERS001043', 'RAKOTONIRINA', 'JEAN BAPTISTE', TIMESTAMP '1999-06-15 00:00:00.000000', '1', '101221127976', NULL, NULL, 'Malagasy', 'LOT VN 56 BIS AMBOHITSOA  ANKAZOLAVA IVANJA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001044', NULL, ' ', ' ', 'PERS001044', 'RAKOTOSON', 'ANTSA STEPHAN', TIMESTAMP '1995-05-04 00:00:00.000000', '1', '101221112307', NULL, NULL, 'Malagasy', 'VM 92 A BIS SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001045', NULL, ' ', ' ', 'PERS001045', 'ANDRIANANTENAINA', 'ANDO HERINIAINA VANILLI', TIMESTAMP '1990-09-20 00:00:00.000000', '1', '117191009929', NULL, NULL, 'Malagasy', 'IC 110 BIS ANKADILALAMPOTSY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001046', NULL, ' ', ' ', 'PERS001046', 'RABENJANAHARY', 'AMEDE JEREMY', TIMESTAMP '1999-02-12 00:00:00.000000', '1', '115171005989', NULL, NULL, 'Malagasy', 'VM 88 SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001047', NULL, ' ', ' ', 'PERS001047', 'SOLOFONOMENJANAHARY', '', TIMESTAMP '1972-09-20 00:00:00.000000', '1', '118311000424', NULL, NULL, 'Malagasy', 'IVL 211 ANDOHATAPENAKA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001048', NULL, ' ', ' ', 'PERS001048', 'RAMAROKOTO', 'SAMBATRA TAHIRY', TIMESTAMP '1997-03-22 00:00:00.000000', '1', '101221118232', NULL, NULL, 'Malagasy', 'VM 92 AO TER F SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001049', NULL, ' ', ' ', 'PERS001049', 'RANDRIATINA', 'SITRAKA ALBERTO', TIMESTAMP '1999-05-13 00:00:00.000000', '1', '117191016320', NULL, NULL, 'Malagasy', 'IVC 39 ANKARAOBATO', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001050', NULL, ' ', ' ', 'PERS001050', 'RANDRIAMANAIKIARIVO', 'HERITOKY', TIMESTAMP '1991-07-20 00:00:00.000000', '1', '107211007781', NULL, NULL, 'Malagasy', 'AB 156 AMBOVOKELY AMBOHIMANGAKELY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001051', NULL, ' ', ' ', 'PERS001051', 'RAMAHANDRITSILAVO', 'ONJA DAVID', TIMESTAMP '1992-10-07 00:00:00.000000', '1', '117231005243', NULL, NULL, 'Malagasy', 'JKD AMPEFILOHA AMBOHIJOKY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001052', NULL, ' ', ' ', 'PERS001052', 'RANDRIANANTENAINA', 'NOMENJANAHARY MARCELLIN', TIMESTAMP '1985-05-24 00:00:00.000000', '1', '117151008169', NULL, NULL, 'Malagasy', 'SAROPODY LOT VM 85 A', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001054', NULL, ' ', ' ', 'PERS001054', 'ANDRIANJATOVO', 'ERIC', TIMESTAMP '1997-01-06 00:00:00.000000', '1', '106321016084', NULL, NULL, 'Malagasy', '1076 BIS 67 HECTARES', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001055', NULL, ' ', ' ', 'PERS001055', 'RAMANANTOANINA', 'HASINIRINA ALFRED', TIMESTAMP '1988-06-16 00:00:00.000000', '1', '101221090034', NULL, NULL, 'Malagasy', 'VQ 5 AC MANDROSEZA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001057', NULL, ' ', ' ', 'PERS001057', 'RANDRIARINOSY', 'ALBERT', TIMESTAMP '1993-01-15 00:00:00.000000', '1', '106441014637', NULL, NULL, 'Malagasy', 'LT 66 ANKADIKELY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001058', NULL, ' ', ' ', 'PERS001058', 'RANAIVOHARINABO', 'ONINA DINANIAINA', TIMESTAMP '1996-07-21 00:00:00.000000', '1', '117151020534', NULL, NULL, 'Malagasy', 'FA 06 AMBOHIMANATRIKA TANJOMBATO', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001059', NULL, ' ', ' ', 'PERS001059', 'ANDRIANTSIMBA', 'DINA TANTELY TIANA', TIMESTAMP '1991-05-01 00:00:00.000000', '1', '101251161260', NULL, NULL, 'Malagasy', 'II E 30 QV BIS C AMBOHIDAHY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001060', NULL, ' ', ' ', 'PERS001060', 'RAHARINOKASAINA', 'HOBISITRAKA VANESSA', TIMESTAMP '2000-02-08 00:00:00.000000', '0', '101242189458', NULL, NULL, 'Malagasy', 'LOT IV W 4B ANOSIZATO EST II', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001061', NULL, ' ', ' ', 'PERS001061', 'TAHIANJANAHARY', 'MAMITIANA DIAMONDRA', TIMESTAMP '1992-01-07 00:00:00.000000', '1', '101241150882', NULL, NULL, 'Malagasy', 'III X 7 B ANOSIBE OUEST II', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001062', NULL, ' ', ' ', 'PERS001062', 'SITRAKINIAINA', 'FALY ERNESTE', TIMESTAMP '1995-01-15 00:00:00.000000', '1', '117151018129', NULL, NULL, 'Malagasy', 'VH 85 AH SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001063', NULL, ' ', ' ', 'PERS001063', 'RATSIMANDRESY', 'ANDRIAMPARANY JEAN CLAUDE', TIMESTAMP '1976-05-12 00:00:00.000000', '1', '101251090267', NULL, NULL, 'Malagasy', 'LOT 21 D IMERINAFOVOANY TALATAMATY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001064', NULL, ' ', ' ', 'PERS001064', 'RAZANAKOTO', 'HERY JOHN HENRI', TIMESTAMP '1971-11-11 00:00:00.000000', '1', '101241082914', NULL, NULL, 'Malagasy', 'LOT AB 389 BIS III ANTANETY AMBOHIMAMORY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001065', NULL, ' ', ' ', 'PERS001065', 'RAFANOMEZANTSOA', 'JEAN FIDELE', TIMESTAMP '1978-03-13 00:00:00.000000', '1', '117431001862', NULL, NULL, 'Malagasy', 'ANTANETIBE AAVARABOHITRA TSIAFAHY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001066', NULL, ' ', ' ', 'PERS001066', 'RATSINJOMANANA', 'FANIRINIAINA HENRI', TIMESTAMP '1996-10-27 00:00:00.000000', '1', '117391007321', NULL, NULL, 'Malagasy', 'LOT PRES VM 88 B BIS SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001067', NULL, ' ', ' ', 'PERS001067', 'RAZANAMANDIMBY', 'ERISON', TIMESTAMP '1994-01-08 00:00:00.000000', '1', '117151017831', NULL, NULL, 'Malagasy', 'LOT III U 69 ANOSIMAHAVELONA ANKAZOTOHA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001068', NULL, ' ', ' ', 'PERS001068', 'RALAIARINARIVO', 'DAVIDA', TIMESTAMP '1973-12-29 00:00:00.000000', '1', '106441009243', NULL, NULL, 'Malagasy', 'SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001069', NULL, ' ', ' ', 'PERS001069', 'RAJAONARIVELO', 'HONORE BIENVENU', TIMESTAMP '1990-10-05 00:00:00.000000', '1', '101251165241', NULL, NULL, 'Malagasy', 'LOT A 222 ANDAVAMAMBA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001070', NULL, ' ', ' ', 'PERS001070', 'RAKOTOJAONA', 'PHILIBERT', TIMESTAMP '1999-01-28 00:00:00.000000', '1', '108031010406', NULL, NULL, 'Malagasy', 'ANKADIMBAHOAKA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001072', NULL, ' ', ' ', 'PERS001072', 'RANDRIANJAFY', 'TIANA TSIKIVY', TIMESTAMP '1970-04-19 00:00:00.000000', '1', '101211112696', NULL, NULL, 'Malagasy', 'ANDRANOMANALINA CENTRE', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001073', NULL, ' ', ' ', 'PERS001073', 'RAJAONARIVELO', 'ANGELINE', TIMESTAMP '1993-06-16 00:00:00.000000', '0', '117032017625', NULL, NULL, 'Malagasy', 'LOT AB 331 IV ANKADIVORY ANDRANONAHOATRA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001074', NULL, ' ', ' ', 'PERS001074', 'ANDRIAMISAMANANA', 'MAMY TIANA CLEMENT', TIMESTAMP '1969-08-16 00:00:00.000000', '1', '101241071937', NULL, NULL, 'Malagasy', 'LOT AB 11O BIS I AMBOHIMAMORY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001075', NULL, ' ', ' ', 'PERS001075', 'RAZAFIMAMPIONONA', 'ARMAND TANTELY', TIMESTAMP '2003-08-14 00:00:00.000000', '1', '101241209447', NULL, NULL, 'Malagasy', 'LOT 146 AF OUEST MANANJARA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001076', NULL, ' ', ' ', 'PERS001076', 'RAKOTONIAINA', 'LOVASOA DESIRE PHILIPPE', TIMESTAMP '1992-03-01 00:00:00.000000', '1', '204171007331', NULL, NULL, 'Malagasy', 'LOT II A T 182 K BIS AMPANDRANA EST', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001077', NULL, ' ', ' ', 'PERS001077', 'ROBIJANAHARY', 'HERITIANA RADO', TIMESTAMP '2000-08-05 00:00:00.000000', '1', '102011021287', NULL, NULL, 'Malagasy', 'LOT C 199 ALASORA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001078', NULL, ' ', ' ', 'PERS001078', 'RAJAONARISON', 'SITRAKINIAINA JOSOA', TIMESTAMP '1993-07-25 00:00:00.000000', '1', '117191010710', NULL, NULL, 'Malagasy', 'LOT IVA 62 ANTANETISOA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001079', NULL, ' ', ' ', 'PERS001079', 'RAKOTOZAFY', 'HERY ZO CAPRICIEN', TIMESTAMP '1994-08-10 00:00:00.000000', '1', '107051002464', NULL, NULL, 'Malagasy', 'II F 34 FDA ANDRAISORO', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001081', NULL, ' ', ' ', 'PERS001081', 'NASANDRATRINIAVO', 'HARILALA TSILAVINA', TIMESTAMP '2004-05-18 00:00:00.000000', '1', '107131003826', NULL, NULL, 'Malagasy', 'II B 108 KAA AMBATOMAINTY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001082', NULL, ' ', ' ', 'PERS001082', 'RANDRIANANTOANDRO', 'HERY MAMPIONONA', TIMESTAMP '1987-08-07 00:00:00.000000', '1', '102091012916', NULL, NULL, 'Malagasy', 'LOT VL 26 M AMBOHIBARY ANDRONDRA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001083', NULL, ' ', ' ', 'PERS001083', 'RASOAMALALA', 'HANITRINIAINA ROVA FITIAVANA', TIMESTAMP '2002-11-18 00:00:00.000000', '0', '101982115458', NULL, NULL, 'Malagasy', 'LOT C 138 ANDRANOMENA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001084', NULL, ' ', ' ', 'PERS001084', 'SOLOARITIANA', 'ANNIE JOSIANE', TIMESTAMP '1982-06-14 00:00:00.000000', '0', '101232120050', NULL, NULL, 'Malagasy', 'LOT IVL 18 ANKADIFOTSY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001086', NULL, ' ', ' ', 'PERS001086', 'RAKOTOARISOA', 'TSIARO HERY MANJAKANIARY', TIMESTAMP '2002-04-08 00:00:00.000000', '1', '102051009286', NULL, NULL, 'Malagasy', 'AMBODIVONDAVA AMBOHIPENO AMBOHIMANAMBOLA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001087', NULL, ' ', ' ', 'PERS001087', 'RAKOTOMALANTOARIVO', 'MIHOBY NATACHA', TIMESTAMP '2005-05-11 00:00:00.000000', '0', '117312027626', NULL, NULL, 'Malagasy', 'LOT AKV I 22 AMBODISAHA ALAKAMISY FENOARIVO', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001088', NULL, ' ', ' ', 'PERS001088', 'FANDRESENIAVO', 'ALFA JEAN DE', TIMESTAMP '2003-09-01 00:00:00.000000', '1', '220231007072', NULL, NULL, 'Malagasy', 'LOT III S 378 ABZ OUEST ANKADIMBAHOAKA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001089', NULL, ' ', ' ', 'PERS001089', 'RANAIVOMANANA', 'TOJONIRIANA MAMISENDRA ELIA', TIMESTAMP '2001-03-03 00:00:00.000000', '1', '115091024109', NULL, NULL, 'Malagasy', 'LOT IAV 301 G  MANDRIMENA IAVOLOHA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001090', NULL, ' ', ' ', 'PERS001090', 'TOJOFANAMBINANTSOA', 'FAMENONIRINA', TIMESTAMP '1997-05-08 00:00:00.000000', '1', '112991015168', NULL, NULL, 'Malagasy', 'BELAMBANANA ANDOHARANOFOTSY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS001091', NULL, ' ', ' ', 'PERS001091', 'RATIARISON', 'RINDRA NIAINA DANIE', TIMESTAMP '2000-05-11 00:00:00.000000', '1', '101251210948', NULL, NULL, 'Malagasy', 'LOT II D 10 H MANJAKARAY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);


---categorie_paie pour temporaire
INSERT INTO CATEGORIE_PAIE
(ID, VAL, DESCE, MONTANT, REMARQUE, DROIT_HEURE_SUP, ESSAIE)
VALUES('CP0000011', 'TEMPORAIRE', 'TEMPORAIRE', 0, 'aucun', 'o', 3);


--- paie_info_personnel temporaire
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0001', SYSDATE, '037A', '101242095435', 'LOT III J 188 SOANIERANA',
       TO_DATE('14/09/2004', 'DD/MM/YYYY'), TO_DATE('14/09/2004', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0002', SYSDATE, '063A', '201032004204', 'LOT VM 85 C SAROPODY',
       TO_DATE('14/09/2004', 'DD/MM/YYYY'), TO_DATE('14/09/2004', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0003', SYSDATE, '143A', '101242090142', 'LOT III A 91 TSIMIALONJAFY TANA IV',
       TO_DATE('25/07/2005', 'DD/MM/YYYY'), TO_DATE('25/07/2005', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0004', SYSDATE, '201A', '117172003380', 'LOT VB I 015 TONGARIVO',
       TO_DATE('05/10/2005', 'DD/MM/YYYY'), TO_DATE('05/10/2005', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0005', SYSDATE, '206A', '106322011770', 'LOT II C 3 MANJAKARAY',
       TO_DATE('05/10/2005', 'DD/MM/YYYY'), TO_DATE('05/10/2005', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0006', SYSDATE, '302A', '117152001271', 'LOT ENDUMA SAROPODY',
       TO_DATE('19/05/2006', 'DD/MM/YYYY'), TO_DATE('19/05/2006', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0007', SYSDATE, '370A', '102011004953', 'LOT 44 ANKAZOBE ALASORA',
       TO_DATE('14/06/2006', 'DD/MM/YYYY'), TO_DATE('14/06/2006', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0008', SYSDATE, '383A', '117191006407', 'LOT II A 270 BIS TANJOMBATO',
       TO_DATE('10/07/2006', 'DD/MM/YYYY'), TO_DATE('10/07/2006', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0009', SYSDATE, '458A', '401012027594', 'LOT F III L 11 AMBOHIMAHITSY',
       TO_DATE('02/11/2006', 'DD/MM/YYYY'), TO_DATE('02/11/2006', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0010', SYSDATE, '484A', '101252074275', 'LOT IVB 99 ANDRAVOAHANGY ANDREFANA',
       TO_DATE('01/09/2019', 'DD/MM/YYYY'), TO_DATE('01/09/2019', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0011', SYSDATE, '595A', '101222092125', 'LOT VM 94 GAI SAROPODY',
       TO_DATE('17/08/2007', 'DD/MM/YYYY'), TO_DATE('17/08/2007', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0012', SYSDATE, '639A', '101252095644', 'LOT II S 19 ANJANAHARY',
       TO_DATE('07/12/2007', 'DD/MM/YYYY'), TO_DATE('07/12/2007', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0013', SYSDATE, '643A', '101222072493', 'LOT IA 62 TANJOMBATO',
       TO_DATE('19/12/2007', 'DD/MM/YYYY'), TO_DATE('19/12/2007', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0014', SYSDATE, '655A', '101211173525', 'F III H 52 AMBOHIMAHITSY',
       TO_DATE('11/02/2008', 'DD/MM/YYYY'), TO_DATE('11/02/2008', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0015', SYSDATE, '674A', '101241116449', 'LOT III H 82 OUEST AMBOHIJANAHARY',
       TO_DATE('02/01/2019', 'DD/MM/YYYY'), TO_DATE('02/01/2019', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0016', SYSDATE, '694A', '101251060523', 'Lot II O 122 Ter Anjanahary',
       TO_DATE('05/02/2008', 'DD/MM/YYYY'), TO_DATE('05/02/2008', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0017', SYSDATE, '719A', '101242092747', 'LOT III S 115 BIS ANOSIBE AMBOHIBARIKELY',
       TO_DATE('28/02/2008', 'DD/MM/YYYY'), TO_DATE('28/02/2008', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0018', SYSDATE, '767A', '313012022547', 'LOT IVT 8 TSARAMASAY',
       TO_DATE('01/08/2017', 'DD/MM/YYYY'), TO_DATE('01/08/2017', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0019', SYSDATE, '793A', '117152012467', 'LOT III A 23 TANJOMBATO',
       TO_DATE('30/05/2008', 'DD/MM/YYYY'), TO_DATE('30/05/2008', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0020', SYSDATE, '795A', '117071013416', 'LOT IPA 330',
       TO_DATE('29/05/2008', 'DD/MM/YYYY'), TO_DATE('29/05/2008', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0021', SYSDATE, '817A', '102091009600', 'F III H 121 AMBOHIMAHINTSY AMBOHIMANGAKELY',
       TO_DATE('02/06/2008', 'DD/MM/YYYY'), TO_DATE('02/06/2008', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0022', SYSDATE, '841A', '101241155652', 'LOT IIIV 53 ANOSIPATRANA ANTSINANANA',
       TO_DATE('14/07/2008', 'DD/MM/YYYY'), TO_DATE('14/07/2008', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0023', SYSDATE, '1079A', '209011028441', 'LOT VM 92 AC SAROPODY',
       TO_DATE('09/10/2009', 'DD/MM/YYYY'), TO_DATE('09/10/2009', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0024', SYSDATE, '1151A', '101211155432', 'LOGT 369 CITE AMBODIN''ISOTRY',
       TO_DATE('25/05/2010', 'DD/MM/YYYY'), TO_DATE('25/05/2010', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0025', SYSDATE, '1190A', '101252114581', 'LOT II B 133 B MANJAKARAY',
       TO_DATE('23/06/2010', 'DD/MM/YYYY'), TO_DATE('23/06/2010', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0026', SYSDATE, '1269A', '101242095350', 'LOT VM 5 AMPARARIBE',
       TO_DATE('18/01/2011', 'DD/MM/YYYY'), TO_DATE('18/01/2011', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0027', SYSDATE, '1275A', '101231145311', 'LOT IVP 171 ANKADIFOTSY',
       TO_DATE('18/01/2011', 'DD/MM/YYYY'), TO_DATE('18/01/2011', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0028', SYSDATE, '1352A', '101251140228', 'LOT II O 164 ANJANAHARY',
       TO_DATE('01/01/2021', 'DD/MM/YYYY'), TO_DATE('01/01/2021', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0029', SYSDATE, '1369A', '101231137335', 'LOT IVT 5 BIS TSARAMASAY',
       TO_DATE('20/06/2011', 'DD/MM/YYYY'), TO_DATE('20/06/2011', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0030', SYSDATE, '1386A', '108992054215', 'LOT II V 21 AMPANDRANA BESARETY',
       TO_DATE('21/06/2011', 'DD/MM/YYYY'), TO_DATE('21/06/2011', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0031', SYSDATE, '1387A', '101212110622', 'LOT II M 13 BIS MAHAVOKY',
       TO_DATE('21/06/2011', 'DD/MM/YYYY'), TO_DATE('21/06/2011', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0032', SYSDATE, '1443A', '101222101263', 'LOT VN 22 MA TER ANKAZOLAVA AMBIHITSOA',
       TO_DATE('21/07/2011', 'DD/MM/YYYY'), TO_DATE('21/07/2011', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0033', SYSDATE, '1483A', '101252139555', 'LOT II B 133 BIS MANJAKARAY',
       TO_DATE('26/07/2011', 'DD/MM/YYYY'), TO_DATE('26/07/2011', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0034', SYSDATE, '1494A', '203292002694', 'LOT VT 85  H BP ANDOHANIMANDROSEZA',
       TO_DATE('11/01/2021', 'DD/MM/YYYY'), TO_DATE('11/01/2021', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0035', SYSDATE, '1525A', '102411002757', 'LOT 106 B AMBOHIBAO',
       TO_DATE('23/01/2012', 'DD/MM/YYYY'), TO_DATE('23/01/2012', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0036', SYSDATE, '1529A', '103011003073', 'LOT III S 128 A ANOSIBE AMBOHIBARIKELY',
       TO_DATE('23/01/2012', 'DD/MM/YYYY'), TO_DATE('23/01/2012', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0037', SYSDATE, '1544A', '101222080755', 'LOT VM 88 BIS ANDRONDRAKELY SAROPODY',
       TO_DATE('31/01/2012', 'DD/MM/YYYY'), TO_DATE('31/01/2012', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0038', SYSDATE, '1621A', '101211209820', 'LOT 65 CITE AMBODIN''ISOTRY',
       TO_DATE('10/08/2012', 'DD/MM/YYYY'), TO_DATE('10/08/2012', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0039', SYSDATE, '1627A', '101221105057', 'LOT VM 88 CC SAROPODY',
       TO_DATE('10/08/2012', 'DD/MM/YYYY'), TO_DATE('10/08/2012', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0040', SYSDATE, '1638A', '313152000558', 'LOT VU 218 AMBATOMITSANGANA MANJAKAMIADANA HAUTE V',
       TO_DATE('03/09/2012', 'DD/MM/YYYY'), TO_DATE('03/09/2012', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0041', SYSDATE, '1730A', '101231133433', 'LOT II T 90 H AMPANDRANA EST',
       TO_DATE('27/05/2013', 'DD/MM/YYYY'), TO_DATE('27/05/2013', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0042', SYSDATE, '1747A', '101251162279', 'LOT II E 21 TER AMBOHIMIRARY',
       TO_DATE('27/05/2013', 'DD/MM/YYYY'), TO_DATE('27/05/2013', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0043', SYSDATE, '1779A', '101232094309', 'LOT II P 155 TER AVARADOHA',
       TO_DATE('13/11/2013', 'DD/MM/YYYY'), TO_DATE('13/11/2013', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0044', SYSDATE, '1792A', '117172010511', 'LOT II S 58 PRES',
       TO_DATE('04/12/2013', 'DD/MM/YYYY'), TO_DATE('04/12/2013', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0045', SYSDATE, '1809A', '114171015604', 'LOT FIVR 185 MANGARIVOTRA',
       TO_DATE('09/05/2014', 'DD/MM/YYYY'), TO_DATE('09/05/2014', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0046', SYSDATE, '1838A', '101251173600', 'LOT II S 40 S ANJANAHARY',
       TO_DATE('01/07/2020', 'DD/MM/YYYY'), TO_DATE('01/07/2020', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0047', SYSDATE, '1849A', '101232111246', 'LOT AV 8 BIS AMBOHIJANAMASOANDO ITAOSY',
       TO_DATE('26/08/2014', 'DD/MM/YYYY'), TO_DATE('26/08/2014', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0048', SYSDATE, '1909A', '112991010419', 'LOT II A 71 TANJOMBATO',
       TO_DATE('09/03/2015', 'DD/MM/YYYY'), TO_DATE('09/03/2015', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0049', SYSDATE, '1921A', '101222062662', 'LOT VM 88 CH TER F SAROPODY',
       TO_DATE('09/03/2015', 'DD/MM/YYYY'), TO_DATE('09/03/2015', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0050', SYSDATE, '1925A', '103152012635', 'LOT VM 89 A SAROPODY',
       TO_DATE('09/03/2015', 'DD/MM/YYYY'), TO_DATE('09/03/2015', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0051', SYSDATE, '1931A', '117152011849', 'LOT IA 150 TANJOMBATO',
       TO_DATE('09/03/2015', 'DD/MM/YYYY'), TO_DATE('09/03/2015', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0052', SYSDATE, '1953A', '102032026434', 'LOT AD 70 BIS ANKADIKELY',
       TO_DATE('01/08/2018', 'DD/MM/YYYY'), TO_DATE('01/08/2018', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0053', SYSDATE, '2034A', '101222117792', 'VM 92 APA SAROPODY',
       TO_DATE('12/10/2017', 'DD/MM/YYYY'), TO_DATE('12/10/2017', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0054', SYSDATE, '2035A', '101222095178', 'VM 92 AG BIS SAROPODY',
       TO_DATE('12/10/2017', 'DD/MM/YYYY'), TO_DATE('12/10/2017', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0055', SYSDATE, '2036A', '117171004015', 'IIIC 141 BIS IFARIHY ANKARAOBATO',
       TO_DATE('12/10/2017', 'DD/MM/YYYY'), TO_DATE('12/10/2017', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0056', SYSDATE, '2037A', '117151021093', 'VM 92 AC SAROPODY',
       TO_DATE('12/10/2017', 'DD/MM/YYYY'), TO_DATE('12/10/2017', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0057', SYSDATE, '2041A', '101211267434', 'ANDOHATAPENAKA',
       TO_DATE('27/10/2017', 'DD/MM/YYYY'), TO_DATE('27/10/2017', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0058', SYSDATE, '2042A', '101222086670', 'VM 92 AG BIS SAROPODY',
       TO_DATE('06/11/2017', 'DD/MM/YYYY'), TO_DATE('06/11/2017', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0059', SYSDATE, '2044a', '101982088985', 'IVC 108 F AMBOHIMANARINA AMBOHIMANDROSO',
       TO_DATE('17/01/2018', 'DD/MM/YYYY'), TO_DATE('17/01/2018', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0060', SYSDATE, '2067A', '102072006738', 'VM 92 APX SAROPODY',
       TO_DATE('03/07/2018', 'DD/MM/YYYY'), TO_DATE('03/07/2018', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0061', SYSDATE, '2068A', '101222107785', 'VM 88 CB SAROPODY',
       TO_DATE('22/06/2018', 'DD/MM/YYYY'), TO_DATE('22/06/2018', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0062', SYSDATE, '2078A', '101231160160', 'II M 13 BIS MAHAVOKY',
       TO_DATE('10/07/2018', 'DD/MM/YYYY'), TO_DATE('10/07/2018', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0063', SYSDATE, '2100A', '201031030658', 'IVD 26 TER AMBOHIBAHINY',
       TO_DATE('24/07/2018', 'DD/MM/YYYY'), TO_DATE('24/07/2018', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0064', SYSDATE, '2140A', '106211001642', 'AMBOHIDRALAMBO',
       TO_DATE('02/11/2018', 'DD/MM/YYYY'), TO_DATE('02/11/2018', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0065', SYSDATE, '2154A', '114011037316', 'VM 31 TER ANDRONDRAKELY',
       TO_DATE('01/09/2020', 'DD/MM/YYYY'), TO_DATE('01/09/2020', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0066', SYSDATE, '2163A', '101251073324', 'II D 75 BIS',
       TO_DATE('17/12/2018', 'DD/MM/YYYY'), TO_DATE('17/12/2018', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0067', SYSDATE, '2176A', '101242168192', 'III U 69G TER H ANKAZOTOHO ANOSIMAHAVELONA',
       TO_DATE('27/02/2019', 'DD/MM/YYYY'), TO_DATE('27/02/2019', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0068', SYSDATE, '2179A', '101222132733', 'VM 88 CC BIS SAROPODY',
       TO_DATE('05/02/2019', 'DD/MM/YYYY'), TO_DATE('05/02/2019', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0069', SYSDATE, '2191A', '308301036723', 'VM 92 AKA SAROPODY',
       TO_DATE('01/02/2021', 'DD/MM/YYYY'), TO_DATE('01/02/2021', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0070', SYSDATE, '2214A', '101221132258', 'VM 94 AW SAROPODY',
       TO_DATE('11/11/2019', 'DD/MM/YYYY'), TO_DATE('11/11/2019', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0071', SYSDATE, '2222A', '204011010709', 'III A 91 TSIMIALONJAFY',
       TO_DATE('14/11/2019', 'DD/MM/YYYY'), TO_DATE('14/11/2019', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0072', SYSDATE, '2244A', '106301029160', 'IT M/70 AMBODIFASIKA ITAOSY',
       TO_DATE('22/07/2020', 'DD/MM/YYYY'), TO_DATE('22/07/2020', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0073', SYSDATE, '2249A', '101211241489', 'AV 1 AMBOHIJANAMASOANDRO AMBAVAHADITOKANA',
       TO_DATE('17/08/2020', 'DD/MM/YYYY'), TO_DATE('17/08/2020', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0074', SYSDATE, '2252A', '117152021570', 'II A 232 TANJOMBATO',
       TO_DATE('28/09/2020', 'DD/MM/YYYY'), TO_DATE('28/09/2020', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0075', SYSDATE, '2253A', '111192003997', 'LOT VM 89 Y SAROPODY',
       TO_DATE('28/09/2020', 'DD/MM/YYYY'), TO_DATE('28/09/2020', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0076', SYSDATE, '2259A', '117151024624', 'PV 21 TANJOMBATO IRAITSIMIVAKY',
       TO_DATE('28/04/2025', 'DD/MM/YYYY'), TO_DATE('28/04/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0077', SYSDATE, '2266A', '101221139295', 'VM 92 AC BIS SAROPODY',
       TO_DATE('05/10/2020', 'DD/MM/YYYY'), TO_DATE('05/10/2020', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0078', SYSDATE, '2269A', '101221138258', 'VM 94 BIS ANDRONDRAKELY SAROPODY',
       TO_DATE('09/10/2020', 'DD/MM/YYYY'), TO_DATE('09/10/2020', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0079', SYSDATE, '2275A', '101221140738', 'VM 92 AG BIS SAROPODY',
       TO_DATE('10/11/2020', 'DD/MM/YYYY'), TO_DATE('10/11/2020', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0080', SYSDATE, '2282A', '210012035971', 'VM 88 BZ SAROPODY',
       TO_DATE('05/02/2021', 'DD/MM/YYYY'), TO_DATE('05/02/2021', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0081', SYSDATE, '2317A', '101221135083', 'VM 85 C SAROPODY',
       TO_DATE('16/01/2021', 'DD/MM/YYYY'), TO_DATE('16/01/2021', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0082', SYSDATE, '2318A', '210012033494', 'VM 92 TER EC SAROPODY',
       TO_DATE('26/07/2021', 'DD/MM/YYYY'), TO_DATE('26/07/2021', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0083', SYSDATE, '2355A', '116031004769', 'IVG 76 BEHORIRIKA ANKADITAPAKA',
       TO_DATE('21/03/2022', 'DD/MM/YYYY'), TO_DATE('21/03/2022', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0084', SYSDATE, '2364A', '101221144549', 'LOT VM 92 C SAROPODY',
       TO_DATE('01/04/2022', 'DD/MM/YYYY'), TO_DATE('01/04/2022', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0085', SYSDATE, '2371A', '117392005390', 'II D 46 AMBOHIDRAZANA',
       TO_DATE('01/06/2022', 'DD/MM/YYYY'), TO_DATE('01/06/2022', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0086', SYSDATE, '2376A', '110052010869', 'VM 92 ZI X TER SAROPODY',
       TO_DATE('01/06/2022', 'DD/MM/YYYY'), TO_DATE('01/06/2022', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0087', SYSDATE, '2378A', '101251231848', 'II B OC AMBODITSIRY',
       TO_DATE('01/06/2022', 'DD/MM/YYYY'), TO_DATE('01/06/2022', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0088', SYSDATE, '2388A', '101251126391', 'AV 01 LOHARANOMBATO AMBAVAHADITOKANA',
       TO_DATE('13/06/2022', 'DD/MM/YYYY'), TO_DATE('13/06/2022', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0089', SYSDATE, '2394A', '101231176138', 'II M 13 BIS MAHAVOKY',
       TO_DATE('25/07/2022', 'DD/MM/YYYY'), TO_DATE('25/07/2022', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0090', SYSDATE, '2404A', '210011045506', 'VM 88 SAROPODY',
       TO_DATE('26/09/2022', 'DD/MM/YYYY'), TO_DATE('26/09/2022', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0091', SYSDATE, '2405A', '101221142451', 'III L 63 BIS FIADANANA TAAN IV',
       TO_DATE('26/09/2022', 'DD/MM/YYYY'), TO_DATE('26/09/2022', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0092', SYSDATE, '2406A', '101251228231', 'II E 65 B AMPANOTOKANA',
       TO_DATE('26/09/2022', 'DD/MM/YYYY'), TO_DATE('26/09/2022', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0093', SYSDATE, '2407A', '103131019400', 'ABE 106 ANTANETIBE AMBOHITRIMANJAKA',
       TO_DATE('26/09/2022', 'DD/MM/YYYY'), TO_DATE('26/09/2022', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0094', SYSDATE, '2442A', '101251228161', 'II C 70 MANJAKARAY',
       TO_DATE('28/11/2022', 'DD/MM/YYYY'), TO_DATE('28/11/2022', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0095', SYSDATE, '2456A', '117431009712', 'X 440 AVARABOHITRA TSIAFAHY',
       TO_DATE('28/11/2022', 'DD/MM/YYYY'), TO_DATE('28/11/2022', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0096', SYSDATE, '2461A', '117151008091', 'IA 71 BIS TANJOMBATO',
       TO_DATE('28/11/2022', 'DD/MM/YYYY'), TO_DATE('28/11/2022', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0097', SYSDATE, '2463A', '101221068552', 'CVC 70 ANKADILALAMPOTSY TANJOMBATO',
       TO_DATE('28/11/2022', 'DD/MM/YYYY'), TO_DATE('28/11/2022', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0098', SYSDATE, '2473A', '101251234953', 'LOT II D 10 FB MANJAKARAY',
       TO_DATE('27/03/2023', 'DD/MM/YYYY'), TO_DATE('27/03/2023', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0099', SYSDATE, '2485A', '101982091146', 'ANTANJOMBE AMBOHIMANARINA',
       TO_DATE('24/04/2023', 'DD/MM/YYYY'), TO_DATE('24/04/2023', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0100', SYSDATE, '2497A', '220551500101', 'LOT II A 88 TANJOMBATO',
       TO_DATE('24/04/2023', 'DD/MM/YYYY'), TO_DATE('24/04/2023', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0101', SYSDATE, '2500A', '101981180063', 'IVF 57 BIS AMBODIMITA',
       TO_DATE('15/05/2023', 'DD/MM/YYYY'), TO_DATE('15/05/2023', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0102', SYSDATE, '2501A', '101221152116', 'LOT VM 43 SAROPODY ANDRONDRAKELY',
       TO_DATE('15/05/2023', 'DD/MM/YYYY'), TO_DATE('15/05/2023', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0103', SYSDATE, '2505A', '101221110649', 'III T 120 A MANDRANGOMBATO',
       TO_DATE('15/05/2023', 'DD/MM/YYYY'), TO_DATE('15/05/2023', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0104', SYSDATE, '2506A', '110111006112', 'VM 89 Y2 SAROPODY',
       TO_DATE('15/05/2023', 'DD/MM/YYYY'), TO_DATE('15/05/2023', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0105', SYSDATE, '2513A', '101242136562', '320 BIS IVY ANOSIPATRANA',
       TO_DATE('30/05/2023', 'DD/MM/YYYY'), TO_DATE('30/05/2023', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0106', SYSDATE, '2522A', '101241214869', 'III A 91 TSIMIALONJAFY',
       TO_DATE('28/08/2023', 'DD/MM/YYYY'), TO_DATE('28/08/2023', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0107', SYSDATE, '2523A', '102012005637', 'VM 89 YGA SAROPODY',
       TO_DATE('28/08/2023', 'DD/MM/YYYY'), TO_DATE('28/08/2023', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0108', SYSDATE, '2524A', '101212215269', 'VM 94 AW SAROPODY',
       TO_DATE('28/08/2023', 'DD/MM/YYYY'), TO_DATE('28/08/2023', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0109', SYSDATE, '2532A', '101231185018', 'LOT IVG 76BEHORIRIKA ANKADITAPAKA',
       TO_DATE('28/08/2023', 'DD/MM/YYYY'), TO_DATE('28/08/2023', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0110', SYSDATE, '2542A', '117152029583', 'VM 92 F TER SAROPODY',
       TO_DATE('25/09/2023', 'DD/MM/YYYY'), TO_DATE('25/09/2023', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0111', SYSDATE, '2547A', '117271006950', 'LOT FAIV 063 MALAHO AMPANEFY',
       TO_DATE('02/10/2023', 'DD/MM/YYYY'), TO_DATE('02/10/2023', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0112', SYSDATE, '2550A', '101241195771', 'III S 362 F MADERA NAMONTANA',
       TO_DATE('02/10/2023', 'DD/MM/YYYY'), TO_DATE('02/10/2023', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0113', SYSDATE, '2558A', '117151032227', 'LOT BM 72 ZAB TANJOMBATO',
       TO_DATE('27/11/2023', 'DD/MM/YYYY'), TO_DATE('27/11/2023', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0114', SYSDATE, '2564A', '115072023053', 'III N 21 FIADANANA TANA IV',
       TO_DATE('22/01/2024', 'DD/MM/YYYY'), TO_DATE('22/01/2024', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0115', SYSDATE, '2590A', '107131003032', 'LOT VM 92 ZAC SAROPODY',
       TO_DATE('04/03/2024', 'DD/MM/YYYY'), TO_DATE('04/03/2024', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0116', SYSDATE, '2598A', '101211225663', 'LOT II IC 67 B ANKADITOHO MAROHOHO',
       TO_DATE('26/03/2024', 'DD/MM/YYYY'), TO_DATE('26/03/2024', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0117', SYSDATE, '2602A', '101241170589', 'III S 371 AC MADERA NAMONTANA',
       TO_DATE('20/06/2024', 'DD/MM/YYYY'), TO_DATE('20/06/2024', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0118', SYSDATE, '2603A', '101211278480', 'IVL 215 ANDOHATAPENAKA II',
       TO_DATE('20/06/2024', 'DD/MM/YYYY'), TO_DATE('20/06/2024', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0119', SYSDATE, '2606A', '117172028174', 'BL 090 BELAMBANANA',
       TO_DATE('24/06/2024', 'DD/MM/YYYY'), TO_DATE('24/06/2024', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0120', SYSDATE, '2608A', '101251222724', 'II C 2 TER FP MANJAKARAY',
       TO_DATE('24/06/2024', 'DD/MM/YYYY'), TO_DATE('24/06/2024', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0121', SYSDATE, '2609A', '10124121010', 'III C 29 BIS AMBANINAMPAMARINANA',
       TO_DATE('26/04/2024', 'DD/MM/YYYY'), TO_DATE('26/04/2024', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0122', SYSDATE, '2620A', '117151031335', 'IA 199 TANJOMBATO',
       TO_DATE('24/06/2024', 'DD/MM/YYYY'), TO_DATE('24/06/2024', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0123', SYSDATE, '2629A', '210311012831', 'VM 88 TER SAROPODY',
       TO_DATE('01/07/2024', 'DD/MM/YYYY'), TO_DATE('01/07/2024', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0124', SYSDATE, '2630A', '116011021892', 'II S 40 T BIS ANJANAHARY',
       TO_DATE('01/07/2024', 'DD/MM/YYYY'), TO_DATE('01/07/2024', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0125', SYSDATE, '2633A', '212191004201', 'VM 92 BIS SAROPODY',
       TO_DATE('01/07/2024', 'DD/MM/YYYY'), TO_DATE('01/07/2024', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0126', SYSDATE, '2635A', '116031011021', 'LOT II AC 263 TANJOMBATO',
       TO_DATE('29/07/2024', 'DD/MM/YYYY'), TO_DATE('29/07/2024', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0127', SYSDATE, '2638A', '101221149984', 'LOT VM 91 UAR SAROPODY',
       TO_DATE('29/07/2024', 'DD/MM/YYYY'), TO_DATE('29/07/2024', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0128', SYSDATE, '2639A', '101222146009', 'VM 88 ZCE SAROPODY',
       TO_DATE('31/07/2024', 'DD/MM/YYYY'), TO_DATE('31/07/2024', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0129', SYSDATE, '2645A', '117152020056', 'LOT FA 198 BIS AMBOHIMANATRIKA TANJOMBATO',
       TO_DATE('26/08/2024', 'DD/MM/YYYY'), TO_DATE('26/08/2024', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0130', SYSDATE, '2648A', '117191019797', 'LOT IB 713 ANDOHARANOFOTSY',
       TO_DATE('26/08/2024', 'DD/MM/YYYY'), TO_DATE('26/08/2024', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0131', SYSDATE, '2649A', '117191021118', 'LOT IAC 44 ANTSAHASOA ANKARAOBATO',
       TO_DATE('26/08/2024', 'DD/MM/YYYY'), TO_DATE('26/08/2024', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0132', SYSDATE, '2650A', '101212150934', 'LOT VD 15 AMPARIBE',
       TO_DATE('26/08/2024', 'DD/MM/YYYY'), TO_DATE('26/08/2024', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0133', SYSDATE, '2652A', '103301028111', 'LOT VM 92 OJK SAROPODY',
       TO_DATE('26/08/2024', 'DD/MM/YYYY'), TO_DATE('26/08/2024', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0134', SYSDATE, '2653A', '101222127527', 'SAROPODY',
       TO_DATE('26/08/2024', 'DD/MM/YYYY'), TO_DATE('26/08/2024', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0135', SYSDATE, '2654A', '117392007398', 'LOT IN 34 ANDRANONANAHARY',
       TO_DATE('26/08/2027', 'DD/MM/YYYY'), TO_DATE('26/08/2027', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0136', SYSDATE, '2655A', '101252232424', 'LOT II O 140 BIS ANJANAHARY',
       TO_DATE('26/08/2024', 'DD/MM/YYYY'), TO_DATE('26/08/2024', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0137', SYSDATE, '2656A', '103132020524', 'LOT HTS 33 ANDRANNOMAHINTSY',
       TO_DATE('26/08/2024', 'DD/MM/YYYY'), TO_DATE('26/08/2024', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0138', SYSDATE, '2658A', '10122115643', 'LOT VM 92 D SAROPODY',
       TO_DATE('26/08/2024', 'DD/MM/YYYY'), TO_DATE('26/08/2024', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0139', SYSDATE, '2662A', '101221095829', '',
       TO_DATE('26/08/2024', 'DD/MM/YYYY'), TO_DATE('26/08/2024', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0140', SYSDATE, '2668A', '101222110471', 'LOT VM P SAROPODY',
       TO_DATE('03/09/2024', 'DD/MM/YYYY'), TO_DATE('03/09/2024', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0141', SYSDATE, '2670A', '101221140223', '',
       TO_DATE('26/08/2024', 'DD/MM/YYYY'), TO_DATE('26/08/2024', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0142', SYSDATE, '2671A', '118051008603', 'AMBOANJOBE',
       TO_DATE('01/12/2024', 'DD/MM/YYYY'), TO_DATE('01/12/2024', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0143', SYSDATE, '2707A', '117151021932', 'LOT II A 220 TANJPMBATO IRAITSIMIVAKY',
       TO_DATE('25/11/2024', 'DD/MM/YYYY'), TO_DATE('25/11/2024', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0144', SYSDATE, '2712A', '117011026203', 'LOT AB 172/III ANTANETY AMBHIMAMORY',
       TO_DATE('03/01/2025', 'DD/MM/YYYY'), TO_DATE('03/01/2025', 'DD/MM/YYYY'), 'PAF00003', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0145', SYSDATE, '2713A', '101222135701', 'LOT VT 29 ABX AMPAHATEZA AMBOHIPO',
       TO_DATE('29/01/2025', 'DD/MM/YYYY'), TO_DATE('29/01/2025', 'DD/MM/YYYY'), 'FONC0106233', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0146', SYSDATE, '2720A', '102092029622', 'LOT B 48 AMBODITSIRY',
       TO_DATE('04/03/2025', 'DD/MM/YYYY'), TO_DATE('04/03/2025', 'DD/MM/YYYY'), 'FONC0106251', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0147', SYSDATE, '2738A', '101252218939', 'LOT II N 10 AMBATOBE',
       TO_DATE('14/04/2025', 'DD/MM/YYYY'), TO_DATE('14/04/2025', 'DD/MM/YYYY'), 'PAF010316', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0148', SYSDATE, '2739A', '101211279589', 'LOT FMAI 30 67 HA SUD',
       TO_DATE('28/04/2025', 'DD/MM/YYYY'), TO_DATE('28/04/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0149', SYSDATE, '2740A', '117452003773', 'LOT IC 174 BIS ANKADILALAMPOTSY',
       TO_DATE('28/04/2025', 'DD/MM/YYYY'), TO_DATE('28/04/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0150', SYSDATE, '2741A', '106091011498', 'AMBOHIMANGAKELY',
       TO_DATE('28/04/2025', 'DD/MM/YYYY'), TO_DATE('28/04/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0151', SYSDATE, '2742A', '117151032275', 'LOT VM 92 ZAB SAROPODY',
       TO_DATE('28/04/2025', 'DD/MM/YYYY'), TO_DATE('28/04/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0152', SYSDATE, '2743A', '117151029743', 'LOT IA 150 TANJOMBATO',
       TO_DATE('28/04/2025', 'DD/MM/YYYY'), TO_DATE('28/04/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0153', SYSDATE, '2745A', '101221160889', 'LOT VM 88 A ANDRONDRAKELY',
       TO_DATE('28/04/2025', 'DD/MM/YYYY'), TO_DATE('28/04/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0154', SYSDATE, '2746A', '117151025944', 'LOT II A 71 TANJOMBATO',
       TO_DATE('28/04/2025', 'DD/MM/YYYY'), TO_DATE('28/04/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0155', SYSDATE, '2747A', '117151029321', 'LOT VM 96 KE ANDRONDRAKELY',
       TO_DATE('28/04/2025', 'DD/MM/YYYY'), TO_DATE('28/04/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0156', SYSDATE, '2748A', '101221139427', 'LOT VM 94 BIS D SAROPODY',
       TO_DATE('28/04/2025', 'DD/MM/YYYY'), TO_DATE('28/04/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0157', SYSDATE, '2749A', '114011041138', 'SAROPODY',
       TO_DATE('28/04/2025', 'DD/MM/YYYY'), TO_DATE('28/04/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0158', SYSDATE, '2750A', '101221153675', 'LOT VM 92 AKE SAROPODY',
       TO_DATE('28/04/2025', 'DD/MM/YYYY'), TO_DATE('28/04/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0159', SYSDATE, '2751A', '117151034253', 'LOT VM 92 AKE SAROPODY ANDRONDRAKELY',
       TO_DATE('28/04/2025', 'DD/MM/YYYY'), TO_DATE('28/04/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0160', SYSDATE, '2752A', '101221155571', 'LOT VM 92 II NE SAROPODY',
       TO_DATE('28/04/2025', 'DD/MM/YYYY'), TO_DATE('28/04/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0161', SYSDATE, '2753A', '101221115391', 'LOT VT 69 BIS ANDOHANIMANDROSEZA',
       TO_DATE('28/04/2025', 'DD/MM/YYYY'), TO_DATE('28/04/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0162', SYSDATE, '2755A', '101221158192', 'LOT UL 26 K AMBOHIBARY',
       TO_DATE('28/04/2025', 'DD/MM/YYYY'), TO_DATE('28/04/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0163', SYSDATE, '2756A', '101221158146', 'LOT VM 92 SAROPODY',
       TO_DATE('28/04/2025', 'DD/MM/YYYY'), TO_DATE('28/04/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0164', SYSDATE, '2757A', '109371028147', 'LOT IA 16 TANJOMBATO',
       TO_DATE('28/04/2025', 'DD/MM/YYYY'), TO_DATE('28/04/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0165', SYSDATE, '2758A', '117171023930', 'LOT VF 164 VOLOTARA ANDOHARANOFOTSY',
       TO_DATE('28/04/2025', 'DD/MM/YYYY'), TO_DATE('28/04/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0166', SYSDATE, '2759A',null,'LOT IC 17 BIS ANKARAOBATO',
       TO_DATE('28/04/2025', 'DD/MM/YYYY'), TO_DATE('28/04/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0167', SYSDATE, '2760A', '101241193017', 'LOT III S 364 B OUEST MANANJARA',
       TO_DATE('28/04/2025', 'DD/MM/YYYY'), TO_DATE('28/04/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0168', SYSDATE, '2761A', '101241173098', 'OUEST SOANIERANA',
       TO_DATE('28/04/2025', 'DD/MM/YYYY'), TO_DATE('28/04/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0169', SYSDATE, '2762A', '101241171846', 'LOT III I 137 SOANIERANA',
       TO_DATE('28/04/2025', 'DD/MM/YYYY'), TO_DATE('28/04/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0170', SYSDATE, '2763A', '101251222265', 'LOT II N 88 BIS ANJANAHARY II',
       TO_DATE('28/04/2025', 'DD/MM/YYYY'), TO_DATE('28/04/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0171', SYSDATE, '2764A', '101221138128', 'LOT VM 92 DS BIS SAROPODY',
       TO_DATE('28/04/2025', 'DD/MM/YYYY'), TO_DATE('28/04/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0172', SYSDATE, '2765A', '520111014028', 'LOT 199 TER AMBOHIMANATRIKA',
       TO_DATE('28/04/2025', 'DD/MM/YYYY'), TO_DATE('28/04/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0173', SYSDATE, '2766A', '501111020515', 'LOT II O ANJANAHARY II O 21',
       TO_DATE('28/02/2025', 'DD/MM/YYYY'), TO_DATE('28/02/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0174', SYSDATE, '2767A', '115091023552', 'LOT SI 041 BIS D SOAVINA',
       TO_DATE('28/04/2025', 'DD/MM/YYYY'), TO_DATE('28/04/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0175', SYSDATE, '2768A', '101221097856', 'LOT VM 94 6AR SAROPODY',
       TO_DATE('28/04/2025', 'DD/MM/YYYY'), TO_DATE('28/04/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0176', SYSDATE, '2769A', '101241215971', 'MADERA NAMONTANA',
       TO_DATE('28/04/2025', 'DD/MM/YYYY'), TO_DATE('28/04/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0177', SYSDATE, '2770A', '101221142770', 'LOT VM 88 SAROPODY',
       TO_DATE('28/04/2025', 'DD/MM/YYYY'), TO_DATE('28/04/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0178', SYSDATE, '2771A', '115171006581', 'AMBOHIMANGAKELY',
       TO_DATE('28/04/2025', 'DD/MM/YYYY'), TO_DATE('28/04/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0179', SYSDATE, '2772A', '117152022435', 'LOT VM 88 SM SAROPODY',
       TO_DATE('28/04/2025', 'DD/MM/YYYY'), TO_DATE('28/04/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0180', SYSDATE, '2773A', '117151030760', 'LOT II A 288 TANJOMBATO IRAITSIMIVAKY',
       TO_DATE('28/04/2025', 'DD/MM/YYYY'), TO_DATE('28/04/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0181', SYSDATE, '2774A', '102071026707', 'LOT C 19 B AMBOHINAORINA SABOTSY NAMEHANA',
       TO_DATE('28/04/2025', 'DD/MM/YYYY'), TO_DATE('28/04/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0182', SYSDATE, '2775A', '106401008108', 'LOT VL 11 SDA ANDRONDRA AMPAMANTANANA',
       TO_DATE('28/04/2025', 'DD/MM/YYYY'), TO_DATE('28/04/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0183', SYSDATE, '2776A', '117271008284', 'LOT CIL 13 ANKADIVORIBE',
       TO_DATE('28/04/2025', 'DD/MM/YYYY'), TO_DATE('28/04/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0184', SYSDATE, '2777A', '501011007213', 'TANJOMBATO IRAITSIMIVAKY',
       TO_DATE('28/04/2025', 'DD/MM/YYYY'), TO_DATE('28/04/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0185', SYSDATE, '2778A', '212131004017', 'AMBATOMAINTY',
       TO_DATE('28/04/2025', 'DD/MM/YYYY'), TO_DATE('28/04/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0186', SYSDATE, '2779A', '115112008436', 'LOT III T 190 GAE ANGARANGARANA',
       TO_DATE('28/04/2025', 'DD/MM/YYYY'), TO_DATE('28/04/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0187', SYSDATE, '2780A', '102431003573', 'LOT AVB AVARABOHITRA ITAOSY',
       TO_DATE('02/05/2025', 'DD/MM/YYYY'), TO_DATE('02/05/2025', 'DD/MM/YYYY'), 'FONC0106235', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0188', SYSDATE, '2781A', '102091032713', 'LOT GIV 33 BIS MAHAZO SOAMANANDRARINY',
       TO_DATE('02/06/2025', 'DD/MM/YYYY'), TO_DATE('02/06/2025', 'DD/MM/YYYY'), 'PAF010316', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0189', SYSDATE, '2782A', '101221125421', 'LOT H 41 ANTANETY MIADANA ALASORA',
       TO_DATE('23/06/2025', 'DD/MM/YYYY'), TO_DATE('23/06/2025', 'DD/MM/YYYY'), 'FONC0106250', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0190', SYSDATE, '2783A', '117191015591', 'ANKARAOBATO',
       TO_DATE('03/07/2025', 'DD/MM/YYYY'), TO_DATE('03/07/2025', 'DD/MM/YYYY'), 'FONC0106232', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0191', SYSDATE, '2784A', '101241146417', 'LOT VM 91 B BIS SAROPODY',
       TO_DATE('07/07/2025', 'DD/MM/YYYY'), TO_DATE('07/07/2025', 'DD/MM/YYYY'), 'FONC0106232', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0192', SYSDATE, '2785A', '101222105042', '',
       TO_DATE('28/07/2025', 'DD/MM/YYYY'), TO_DATE('28/07/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0193', SYSDATE, '2786A', '209012037108', 'LOT VM92 AJT SAROPODY',
       TO_DATE('28/07/2025', 'DD/MM/YYYY'), TO_DATE('28/07/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0194', SYSDATE, '2787A', '101981129888', 'LOT IVH 41T AMBODIMITA',
       TO_DATE('28/07/2025', 'DD/MM/YYYY'), TO_DATE('28/07/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0195', SYSDATE, '2788A', '101211272843', 'LOT IVO 181 ANTOHOMADINIKA SUD',
       TO_DATE('28/07/2025', 'DD/MM/YYYY'), TO_DATE('28/07/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0196', SYSDATE, '2789A', '101221151213', 'LOT VL 1 TER P AMPAMANTANANA',
       TO_DATE('28/07/2025', 'DD/MM/YYYY'), TO_DATE('28/07/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0197', SYSDATE, '2790A', '106461014088', 'LOT VA 32 LF TSIADANA',
       TO_DATE('28/07/2025', 'DD/MM/YYYY'), TO_DATE('28/07/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0198', SYSDATE, '2791A', '101221151531', 'LOT VM 88 A SAROPODY',
       TO_DATE('28/07/2025', 'DD/MM/YYYY'), TO_DATE('28/07/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0199', SYSDATE, '2792A', '101222127396', 'LOT VM 8993 SAROPODY',
       TO_DATE('28/07/2025', 'DD/MM/YYYY'), TO_DATE('28/07/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0200', SYSDATE, '2793A', '117432012257', 'LOT VM 92 AB SAROPODY',
       TO_DATE('28/07/2025', 'DD/MM/YYYY'), TO_DATE('28/07/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0201', SYSDATE, '2794A', '315011037401', 'LOT VM 92 AZ SAROPODY',
       TO_DATE('28/07/2025', 'DD/MM/YYYY'), TO_DATE('28/07/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0202', SYSDATE, '2795A', '101251243345', 'LOT II C 106 BIS MANJAKARAY',
       TO_DATE('28/07/2025', 'DD/MM/YYYY'), TO_DATE('28/07/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0203', SYSDATE, '2796A', '101221160645', 'LOTVM 88 V ATER SAROPODY',
       TO_DATE('28/07/2025', 'DD/MM/YYYY'), TO_DATE('28/07/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0204', SYSDATE, '2797A', '117151026122', 'LOT VM 88 E SAROPODY',
       TO_DATE('28/07/2025', 'DD/MM/YYYY'), TO_DATE('28/07/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0205', SYSDATE, '2798A', '117191021574', 'LOT II C 46 ANKADINANDRIANA',
       TO_DATE('28/07/2025', 'DD/MM/YYYY'), TO_DATE('28/07/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0206', SYSDATE, '2799A', '201011036349', 'LOT VM 92 AZ SAROPODY',
       TO_DATE('28/07/2025', 'DD/MM/YYYY'), TO_DATE('28/07/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0207', SYSDATE, '2800A', '117151034064', '',
       TO_DATE('28/07/2025', 'DD/MM/YYYY'), TO_DATE('28/07/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0208', SYSDATE, '2801A', '101231165655', 'LOT 360 AI TER ANTANAMBAO AMBOHIMANGAKELY',
       TO_DATE('28/07/2025', 'DD/MM/YYYY'), TO_DATE('28/07/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0209', SYSDATE, '2802A', '101221159670', 'LOT VL 2 AMPAMANTANANA',
       TO_DATE('28/07/2025', 'DD/MM/YYYY'), TO_DATE('28/07/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0210', SYSDATE, '2803A', '101221124653', 'LOT II A 98 T TANJOMBATO IRAITSIMIVAKY',
       TO_DATE('28/07/2025', 'DD/MM/YYYY'), TO_DATE('28/07/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0211', SYSDATE, '015T', '108092000021', 'LOT III VB 070 TANJOMBATO TONGARIVO',
       TO_DATE('10/06/2010', 'DD/MM/YYYY'), TO_DATE('10/06/2010', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0212', SYSDATE, '063T', '117152003118', 'LOT II A 71 TANJOMBATO',
       TO_DATE('09/12/2009', 'DD/MM/YYYY'), TO_DATE('09/12/2009', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0213', SYSDATE, '064T', '117152006266', 'LOT II A 71 TANJOMBATO',
       TO_DATE('09/12/2009', 'DD/MM/YYYY'), TO_DATE('09/12/2009', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0214', SYSDATE, '104T', '117152001150', 'LOT II A 71 TANJOMBATO',
       TO_DATE('09/12/2009', 'DD/MM/YYYY'), TO_DATE('09/12/2009', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0215', SYSDATE, '730T', '104052000775', 'LOT III A 117 BIS ANDAFIATSIMO TANJOMBATO',
       TO_DATE('14/10/2006', 'DD/MM/YYYY'), TO_DATE('14/10/2006', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0216', SYSDATE, '912T', '102012005476', 'VM 50 B ANDRONDRAKELY',
       TO_DATE('04/09/2003', 'DD/MM/YYYY'), TO_DATE('04/09/2003', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0217', SYSDATE, '930T', '201032013201', 'LOT VM 92 BIS II SAROPODY',
       TO_DATE('15/05/2006', 'DD/MM/YYYY'), TO_DATE('15/05/2006', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0218', SYSDATE, '931T', '101242118516', 'LOT IIIS 84 B ANOSIBE',
       TO_DATE('01/12/2024', 'DD/MM/YYYY'), TO_DATE('01/12/2024', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0219', SYSDATE, '951T', '117152008811', 'LOT IA 40 TANJOMBATO',
       TO_DATE('28/04/2025', 'DD/MM/YYYY'), TO_DATE('28/04/2025', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0220', SYSDATE, '976T', '101241070448', 'LOT II L 28 ANDRAVOAHANGY',
       TO_DATE('12/10/2006', 'DD/MM/YYYY'), TO_DATE('12/10/2006', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);
INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT, IDFONCTION, MODE_PAIEMENT,
 IDCATEGORIE_PAIE, TYPECONTRAT, CLASSEE, INDICEGRADE, NBENFANT, IDQUALIFICATION, TEMPORAIRE)
VALUES('PRS_TEMP_0221', SYSDATE, '989T', '117191006146', 'LOT III C 141 BIS ANKARAOBATO',
       TO_DATE('09/08/2004', 'DD/MM/YYYY'), TO_DATE('09/08/2004', 'DD/MM/YYYY'), 'FONC0106247', '0002',
       'CP0000011', 'TYP0000001', NULL, 0, 0, 'QUAL0001', -1);


INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0001', NULL, ' ', ' ', 'PRS_TEMP_0001', 'HARISOA', 'JERIA MARIE ANGELE', TO_DATE('06/08/1977', 'DD/MM/YYYY'), 0, '101242095435', NULL, NULL, 'Malagasy', 'LOT III J 188 SOANIERANA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0002', NULL, ' ', ' ', 'PRS_TEMP_0002', 'RASOAMAMPIONONAVOAHAN', 'AURELIE VIVIANE', TO_DATE('06/03/1970', 'DD/MM/YYYY'), 0, '201032004204', NULL, NULL, 'Malagasy', 'LOT VM 85 C SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0003', NULL, ' ', ' ', 'PRS_TEMP_0003', 'RALAIHARIMALALA', 'MYRA GORETI', TO_DATE('20/01/1976', 'DD/MM/YYYY'), 0, '101242090142', NULL, NULL, 'Malagasy', 'LOT III A 91 TSIMIALONJAFY TANA IV', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0004', NULL, ' ', ' ', 'PRS_TEMP_0004', 'RANAIVOARISOA', 'SARAH MEUILLY', TO_DATE('07/12/1976', 'DD/MM/YYYY'), 0, '117172003380', NULL, NULL, 'Malagasy', 'LOT VB I 015 TONGARIVO', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0005', NULL, ' ', ' ', 'PRS_TEMP_0005', 'RASOAMIHAJA', 'VOLATIANA LUCIE', TO_DATE('16/06/1969', 'DD/MM/YYYY'), 0, '106322011770', NULL, NULL, 'Malagasy', 'LOT II C 3 MANJAKARAY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0006', NULL, ' ', ' ', 'PRS_TEMP_0006', 'RAJAONARISOA', 'NIVO MARIE THERESE DE L ENFANT JESUS', TO_DATE('29/12/1970', 'DD/MM/YYYY'), 0, '117152001271', NULL, NULL, 'Malagasy', 'LOT ENDUMA SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0007', NULL, ' ', ' ', 'PRS_TEMP_0007', 'RAKOTOMAMONJY', ' RIVO HERIFIDY', TO_DATE('27/06/2006', 'DD/MM/YYYY'), 1, '102011004953', NULL, NULL, 'Malagasy', 'LOT 44 ANKAZOBE ALASORA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0008', NULL, ' ', ' ', 'PRS_TEMP_0008', 'RASATASON', 'MANOHISOA DOLIN', TO_DATE('04/12/1985', 'DD/MM/YYYY'), 1, '117191006407', NULL, NULL, 'Malagasy', 'LOT II A 270 BIS TANJOMBATO', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0009', NULL, ' ', ' ', 'PRS_TEMP_0009', 'RAHARINIRINA', 'MALALATIANA VIRGINIE', TO_DATE('11/01/1981', 'DD/MM/YYYY'), 0, '401012027594', NULL, NULL, 'Malagasy', 'LOT F III L 11 AMBOHIMAHITSY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0010', NULL, ' ', ' ', 'PRS_TEMP_0010', 'RAZANAKINIAINA', 'EUGENIE DOROTTE', TO_DATE('05/11/1970', 'DD/MM/YYYY'), 0, '101252074275', NULL, NULL, 'Malagasy', 'LOT IVB 99 ANDRAVOAHANGY ANDREFANA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0011', NULL, ' ', ' ', 'PRS_TEMP_0011', 'RASOAZANANIVO', 'FELANA ANGELINE', TO_DATE('27/07/1987', 'DD/MM/YYYY'), 0, '101222092125', NULL, NULL, 'Malagasy', 'LOT VM 94 GAI SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0012', NULL, ' ', ' ', 'PRS_TEMP_0012', 'ANDRIANARIVONY', ' VERONIAINA SABRINA', TO_DATE('15/05/1972', 'DD/MM/YYYY'), 0, '101252095644', NULL, NULL, 'Malagasy', 'LOT II S 19 ANJANAHARY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0013', NULL, ' ', ' ', 'PRS_TEMP_0013', 'RAZAFIARIVELO', 'EDMEE NIRINA  SOLANGE', TO_DATE('28/06/1980', 'DD/MM/YYYY'), 0, '101222072493', NULL, NULL, 'Malagasy', 'LOT IA 62 TANJOMBATO', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0014', NULL, ' ', ' ', 'PRS_TEMP_0014', 'RAKOTOARISOA', 'PATRICK', TO_DATE('28/05/1985', 'DD/MM/YYYY'), 1, '101211173525', NULL, NULL, 'Malagasy', 'F III H 52 AMBOHIMAHITSY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0015', NULL, ' ', ' ', 'PRS_TEMP_0015', 'RALAIARISON', 'TIANA JULIA', TO_DATE('07/07/1981', 'DD/MM/YYYY'), 1, '101241116449', NULL, NULL, 'Malagasy', 'LOT III H 82 OUEST AMBOHIJANAHARY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0016', NULL, ' ', ' ', 'PRS_TEMP_0016', 'RANDREJARISON', 'Noel', TO_DATE('21/12/1967', 'DD/MM/YYYY'), 1, '101251060523', NULL, NULL, 'Malagasy', 'Lot II O 122 Ter Anjanahary', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0017', NULL, ' ', ' ', 'PRS_TEMP_0017', 'RAVONIARIVELO', 'HANITRINIAINA EVELYNE', TO_DATE('26/10/1975', 'DD/MM/YYYY'), 0, '101242092747', NULL, NULL, 'Malagasy', 'LOT III S 115 BIS ANOSIBE AMBOHIBARIKELY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0018', NULL, ' ', ' ', 'PRS_TEMP_0018', 'MAHOLISON', ' FARANISAINANA  EVA', TO_DATE('02/04/1989', 'DD/MM/YYYY'), 0, '313012022547', NULL, NULL, 'Malagasy', 'LOT IVT 8 TSARAMASAY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0019', NULL, ' ', ' ', 'PRS_TEMP_0019', 'RANIVOARISOA', ' HOLLANDE', TO_DATE('23/10/1987', 'DD/MM/YYYY'), 0, '117152012467', NULL, NULL, 'Malagasy', 'LOT III A 23 TANJOMBATO', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0020', NULL, ' ', ' ', 'PRS_TEMP_0020', 'RANDRIANIAINA', 'TODISOA', TO_DATE('02/02/1988', 'DD/MM/YYYY'), 1, '117071013416', NULL, NULL, 'Malagasy', 'LOT IPA 330', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0021', NULL, ' ', ' ', 'PRS_TEMP_0021', 'RAKOTONANDRASANA', 'Gilbert', TO_DATE('29/03/1981', 'DD/MM/YYYY'), 1, '102091009600', NULL, NULL, 'Malagasy', 'F III H 121 AMBOHIMAHINTSY AMBOHIMANGAKELY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0022', NULL, ' ', ' ', 'PRS_TEMP_0022', 'ANDRIANTSARAFARA', 'MARINOT', TO_DATE('24/01/1986', 'DD/MM/YYYY'), 1, '101241155652', NULL, NULL, 'Malagasy', 'LOT IIIV 53 ANOSIPATRANA ANTSINANANA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0023', NULL, ' ', ' ', 'PRS_TEMP_0023', 'RAZAFINDRALAKA', ' ARMAND MEDERIC', TO_DATE('15/08/1982', 'DD/MM/YYYY'), 1, '209011028441', NULL, NULL, 'Malagasy', 'LOT VM 92 AC SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0024', NULL, ' ', ' ', 'PRS_TEMP_0024', 'RANDRIANARISOA', 'NJAKANIAINA', TO_DATE('19/03/1982', 'DD/MM/YYYY'), 1, '101211155432', NULL, NULL, 'Malagasy', 'LOGT 369 CITE AMBODIN''ISOTRY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0025', NULL, ' ', ' ', 'PRS_TEMP_0025', 'HANITRINIAINA', 'PAULINE', TO_DATE('03/11/1980', 'DD/MM/YYYY'), 0, '101252114581', NULL, NULL, 'Malagasy', 'LOT II B 133 B MANJAKARAY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0026', NULL, ' ', ' ', 'PRS_TEMP_0026', 'RAZAFIMAHARO', 'SYLVIE AIMEE', TO_DATE('03/09/1977', 'DD/MM/YYYY'), 0, '101242095350', NULL, NULL, 'Malagasy', 'LOT VM 5 AMPARARIBE', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0027', NULL, ' ', ' ', 'PRS_TEMP_0027', 'RAHERIMANANA', 'JONAH FRANCOIS', TO_DATE('06/08/1990', 'DD/MM/YYYY'), 1, '101231145311', NULL, NULL, 'Malagasy', 'LOT IVP 171 ANKADIFOTSY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0028', NULL, ' ', ' ', 'PRS_TEMP_0028', 'RANDRIAMBOLANORO', 'FANANTENANA ELOI', TO_DATE('18/01/1984', 'DD/MM/YYYY'), 1, '101251140228', NULL, NULL, 'Malagasy', 'LOT II O 164 ANJANAHARY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0029', NULL, ' ', ' ', 'PRS_TEMP_0029', 'RAZAFINANDRASANA', 'FANOMEZANTSOA LOVA A', TO_DATE('24/11/1987', 'DD/MM/YYYY'), 1, '101231137335', NULL, NULL, 'Malagasy', 'LOT IVT 5 BIS TSARAMASAY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0030', NULL, ' ', ' ', 'PRS_TEMP_0030', 'RAZANAMALALA', 'CLARISSE', TO_DATE('28/11/1962', 'DD/MM/YYYY'), 0, '108992054215', NULL, NULL, 'Malagasy', 'LOT II V 21 AMPANDRANA BESARETY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0031', NULL, ' ', ' ', 'PRS_TEMP_0031', 'RABENAIVO', 'MIHONE NICOLE STANISLAS', TO_DATE('12/02/1967', 'DD/MM/YYYY'), 0, '101212110622', NULL, NULL, 'Malagasy', 'LOT II M 13 BIS MAHAVOKY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0032', NULL, ' ', ' ', 'PRS_TEMP_0032', 'RAVOLOLONJATOVO', 'HAINGONIRINA FRANCIA', TO_DATE('04/02/1982', 'DD/MM/YYYY'), 0, '101222101263', NULL, NULL, 'Malagasy', 'LOT VN 22 MA TER ANKAZOLAVA AMBIHITSOA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0033', NULL, ' ', ' ', 'PRS_TEMP_0033', 'RASOANIRINA', ' FANJA ARLETTE', TO_DATE('25/09/1986', 'DD/MM/YYYY'), 0, '101252139555', NULL, NULL, 'Malagasy', 'LOT II B 133 BIS MANJAKARAY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0034', NULL, ' ', ' ', 'PRS_TEMP_0034', 'RASOANIAINA', ' MARIE JUSTINE', TO_DATE('04/02/1977', 'DD/MM/YYYY'), 0, '203292002694', NULL, NULL, 'Malagasy', 'LOT VT 85  H BP ANDOHANIMANDROSEZA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0035', NULL, ' ', ' ', 'PRS_TEMP_0035', 'RABEHARIZAKA', 'FENOSOA RIJA', TO_DATE('07/02/1984', 'DD/MM/YYYY'), 1, '102411002757', NULL, NULL, 'Malagasy', 'LOT 106 B AMBOHIBAO', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0036', NULL, ' ', ' ', 'PRS_TEMP_0036', 'RAKOTONDRAZAFY', ' FALISOA', TO_DATE('23/06/1982', 'DD/MM/YYYY'), 1, '103011003073', NULL, NULL, 'Malagasy', 'LOT III S 128 A ANOSIBE AMBOHIBARIKELY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0037', NULL, ' ', ' ', 'PRS_TEMP_0037', 'RAHARINIRINA', 'FANJA LALAO', TO_DATE('16/05/1984', 'DD/MM/YYYY'), 0, '101222080755', NULL, NULL, 'Malagasy', 'LOT VM 88 BIS ANDRONDRAKELY SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0038', NULL, ' ', ' ', 'PRS_TEMP_0038', 'RAZAFIMAHATRATRA', 'ANDRIANARY', TO_DATE('30/06/1991', 'DD/MM/YYYY'), 1, '101211209820', NULL, NULL, 'Malagasy', 'LOT 65 CITE AMBODIN''ISOTRY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0039', NULL, ' ', ' ', 'PRS_TEMP_0039', 'RAVELOMANANTSOA', 'SERGE', TO_DATE('20/04/1993', 'DD/MM/YYYY'), 1, '101221105057', NULL, NULL, 'Malagasy', 'LOT VM 88 CC SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0040', NULL, ' ', ' ', 'PRS_TEMP_0040', 'FANJAHARISOA', 'LEONTINE', TO_DATE('01/10/1969', 'DD/MM/YYYY'), 0, '313152000558', NULL, NULL, 'Malagasy', 'LOT VU 218 AMBATOMITSANGANA MANJAKAMIADANA HAUTE V', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0041', NULL, ' ', ' ', 'PRS_TEMP_0041', 'ANDRIANAVALISON', 'RIJA SERGE', TO_DATE('09/04/1983', 'DD/MM/YYYY'), 1, '101231133433', NULL, NULL, 'Malagasy', 'LOT II T 90 H AMPANDRANA EST', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0042', NULL, ' ', ' ', 'PRS_TEMP_0042', 'RAZANAKOTO', ' GILBERT', TO_DATE('02/05/1991', 'DD/MM/YYYY'), 1, '101251162279', NULL, NULL, 'Malagasy', 'LOT II E 21 TER AMBOHIMIRARY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0043', NULL, ' ', ' ', 'PRS_TEMP_0043', 'RAZANABOLOLONA', 'NORINE', TO_DATE('09/03/1971', 'DD/MM/YYYY'), 0, '101232094309', NULL, NULL, 'Malagasy', 'LOT II P 155 TER AVARADOHA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0044', NULL, ' ', ' ', 'PRS_TEMP_0044', 'RASOARIMALALA', 'VICTORINE', TO_DATE('07/09/1987', 'DD/MM/YYYY'), 0, '117172010511', NULL, NULL, 'Malagasy', 'LOT II S 58 PRES', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0045', NULL, ' ', ' ', 'PRS_TEMP_0045', 'RA', 'JEAN CLAUDE DIDIER', TO_DATE('01/04/1992', 'DD/MM/YYYY'), 1, '114171015604', NULL, NULL, 'Malagasy', 'LOT FIVR 185 MANGARIVOTRA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0046', NULL, ' ', ' ', 'PRS_TEMP_0046', 'RAMILIARIJAONA', 'FENOSOA', TO_DATE('10/05/2004', 'DD/MM/YYYY'), 1, '101251173600', NULL, NULL, 'Malagasy', 'LOT II S 40 S ANJANAHARY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0047', NULL, ' ', ' ', 'PRS_TEMP_0047', 'FANOMEZANTSOA', 'SAHOBIMALALA NIRINA TATIANA', TO_DATE('18/01/1979', 'DD/MM/YYYY'), 0, '101232111246', NULL, NULL, 'Malagasy', 'LOT AV 8 BIS AMBOHIJANAMASOANDO ITAOSY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0048', NULL, ' ', ' ', 'PRS_TEMP_0048', 'RANAIVOARISON', 'MAMINIRINA RIJASON', TO_DATE('30/05/1981', 'DD/MM/YYYY'), 1, '112991010419', NULL, NULL, 'Malagasy', 'LOT II A 71 TANJOMBATO', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0049', NULL, ' ', ' ', 'PRS_TEMP_0049', 'RASOLOVAO', ' PASCALINE', TO_DATE('13/04/1974', 'DD/MM/YYYY'), 0, '101222062662', NULL, NULL, 'Malagasy', 'LOT VM 88 CH TER F SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0050', NULL, ' ', ' ', 'PRS_TEMP_0050', 'RAVELOARISOA', 'VONINIRINA LUCIE', TO_DATE('04/08/1989', 'DD/MM/YYYY'), 0, '103152012635', NULL, NULL, 'Malagasy', 'LOT VM 89 A SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0051', NULL, ' ', ' ', 'PRS_TEMP_0051', 'RAZAKAVOLA', ' TANTELY', TO_DATE('08/02/1988', 'DD/MM/YYYY'), 0, '117152011849', NULL, NULL, 'Malagasy', 'LOT IA 150 TANJOMBATO', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0052', NULL, ' ', ' ', 'PRS_TEMP_0052', 'RASOANAIVO', ' JOHARY MIRANA STEFANIE', TO_DATE('02/02/1995', 'DD/MM/YYYY'), 0, '102032026434', NULL, NULL, 'Malagasy', 'LOT AD 70 BIS ANKADIKELY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0053', NULL, ' ', ' ', 'PRS_TEMP_0053', 'RALAMBOHERINJATO', 'TOJOLALAINA ANNIE', TO_DATE('03/01/1997', 'DD/MM/YYYY'), 0, '101222117792', NULL, NULL, 'Malagasy', 'VM 92 APA SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0054', NULL, ' ', ' ', 'PRS_TEMP_0054', 'RAZAFIARISOA', 'MARINA ERNESTINE', TO_DATE('27/12/1989', 'DD/MM/YYYY'), 0, '101222095178', NULL, NULL, 'Malagasy', 'VM 92 AG BIS SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0055', NULL, ' ', ' ', 'PRS_TEMP_0055', 'RAMAHATSARA', ' GISLAIN', TO_DATE('21/05/1980', 'DD/MM/YYYY'), 1, '117171004015', NULL, NULL, 'Malagasy', 'IIIC 141 BIS IFARIHY ANKARAOBATO', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0056', NULL, ' ', ' ', 'PRS_TEMP_0056', 'RAKOTONIAINA', 'NIRINA JEAN CLAUDE', TO_DATE('02/02/1997', 'DD/MM/YYYY'), 1, '117151021093', NULL, NULL, 'Malagasy', 'VM 92 AC SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0057', NULL, ' ', ' ', 'PRS_TEMP_0057', 'RAZAFIMAHATRATRA', 'JEAN DOLY', TO_DATE('04/07/1998', 'DD/MM/YYYY'), 1, '101211267434', NULL, NULL, 'Malagasy', 'ANDOHATAPENAKA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0058', NULL, ' ', ' ', 'PRS_TEMP_0058', 'RANOROARISOA', 'HASINIRINA MARIE CLAUDIA', TO_DATE('10/01/1987', 'DD/MM/YYYY'), 0, '101222086670', NULL, NULL, 'Malagasy', 'VM 92 AG BIS SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0059', NULL, ' ', ' ', 'PRS_TEMP_0059', 'RAKOTOMALALA', 'MIRANA', TO_DATE('19/02/1994', 'DD/MM/YYYY'), 0, '101982088985', NULL, NULL, 'Malagasy', 'IVC 108 F AMBOHIMANARINA AMBOHIMANDROSO', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0060', NULL, ' ', ' ', 'PRS_TEMP_0060', 'RAHARIMALALA', 'MAMY NIRINA SYLVIENNE', TO_DATE('28/09/1982', 'DD/MM/YYYY'), 0, '102072006738', NULL, NULL, 'Malagasy', 'VM 92 APX SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0061', NULL, ' ', ' ', 'PRS_TEMP_0061', 'RAMIARANTSOA', ' ALPHONSINE', TO_DATE('01/05/1994', 'DD/MM/YYYY'), 0, '101222107785', NULL, NULL, 'Malagasy', 'VM 88 CB SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0062', NULL, ' ', ' ', 'PRS_TEMP_0062', 'RAKOTONDRASOA', ' MIHONE NY AVO FABRICE', TO_DATE('26/06/1996', 'DD/MM/YYYY'), 1, '101231160160', NULL, NULL, 'Malagasy', 'II M 13 BIS MAHAVOKY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0063', NULL, ' ', ' ', 'PRS_TEMP_0063', 'RAZAFIMANDIMBY', ' JULIOT TOUSSAINT', TO_DATE('27/12/1987', 'DD/MM/YYYY'), 1, '201031030658', NULL, NULL, 'Malagasy', 'IVD 26 TER AMBOHIBAHINY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0064', NULL, ' ', ' ', 'PRS_TEMP_0064', 'RAFALIMANANA', ' PIERRE', TO_DATE('12/05/1983', 'DD/MM/YYYY'), 1, '106211001642', NULL, NULL, 'Malagasy', 'AMBOHIDRALAMBO', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0065', NULL, ' ', ' ', 'PRS_TEMP_0065', 'RAKOTONIAINA', 'BENJAMIN', TO_DATE('27/02/1996', 'DD/MM/YYYY'), 1, '114011037316', NULL, NULL, 'Malagasy', 'VM 31 TER ANDRONDRAKELY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0066', NULL, ' ', ' ', 'PRS_TEMP_0066', 'RAKOTOARISOA', ' GILBERT', TO_DATE('23/06/1968', 'DD/MM/YYYY'), 1, '101251073324', NULL, NULL, 'Malagasy', 'II D 75 BIS', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0067', NULL, ' ', ' ', 'PRS_TEMP_0067', 'TOLOJANAHARY', 'NANJA', TO_DATE('25/10/1995', 'DD/MM/YYYY'), 0, '101242168192', NULL, NULL, 'Malagasy', 'III U 69G TER H ANKAZOTOHO ANOSIMAHAVELONA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0068', NULL, ' ', ' ', 'PRS_TEMP_0068', 'RAZAFIARISOA', 'HAINGOTIANA LARICIA', TO_DATE('18/09/2000', 'DD/MM/YYYY'), 0, '101222132733', NULL, NULL, 'Malagasy', 'VM 88 CC BIS SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0069', NULL, ' ', ' ', 'PRS_TEMP_0069', 'MASOLO', 'JEAN IANOK', TO_DATE('26/12/1997', 'DD/MM/YYYY'), 1, '308301036723', NULL, NULL, 'Malagasy', 'VM 92 AKA SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0070', NULL, ' ', ' ', 'PRS_TEMP_0070', 'ANDRIAHARISOA', 'HERINIAINA OLEA', TO_DATE('02/09/2000', 'DD/MM/YYYY'), 1, '101221132258', NULL, NULL, 'Malagasy', 'VM 94 AW SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0071', NULL, ' ', ' ', 'PRS_TEMP_0071', 'RAZAFINARIVOSAONA', 'PHILIBERT', TO_DATE('24/09/1984', 'DD/MM/YYYY'), 1, '204011010709', NULL, NULL, 'Malagasy', 'III A 91 TSIMIALONJAFY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0072', NULL, ' ', ' ', 'PRS_TEMP_0072', 'RANDRIAMANDIMBY', 'JEAN NOEL HONORIN', TO_DATE('24/12/1986', 'DD/MM/YYYY'), 1, '106301029160', NULL, NULL, 'Malagasy', 'IT M/70 AMBODIFASIKA ITAOSY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0073', NULL, ' ', ' ', 'PRS_TEMP_0073', 'FANOMEZANTSOA', ' VONJINIAINA JARRY', TO_DATE('20/02/1999', 'DD/MM/YYYY'), 1, '101211241489', NULL, NULL, 'Malagasy', 'AV 1 AMBOHIJANAMASOANDRO AMBAVAHADITOKANA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0074', NULL, ' ', ' ', 'PRS_TEMP_0074', 'RAMINOSAMBATRA', ' TOJO FANKASITRAHANA', TO_DATE('29/11/1994', 'DD/MM/YYYY'), 0, '117152021570', NULL, NULL, 'Malagasy', 'II A 232 TANJOMBATO', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0075', NULL, ' ', ' ', 'PRS_TEMP_0075', 'RAHANTARISOA', 'ANDONAMBININA JOCELYNE', TO_DATE('24/12/1991', 'DD/MM/YYYY'), 0, '111192003997', NULL, NULL, 'Malagasy', 'LOT VM 89 Y SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0076', NULL, ' ', ' ', 'PRS_TEMP_0076', 'RIKIARITINA', 'LANDRY BRUNO', TO_DATE('22/10/2000', 'DD/MM/YYYY'), 1, '117151024624', NULL, NULL, 'Malagasy', 'PV 21 TANJOMBATO IRAITSIMIVAKY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0077', NULL, ' ', ' ', 'PRS_TEMP_0077', 'RADOSON', ' MARIO', TO_DATE('13/06/2002', 'DD/MM/YYYY'), 1, '101221139295', NULL, NULL, 'Malagasy', 'VM 92 AC BIS SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0078', NULL, ' ', ' ', 'PRS_TEMP_0078', 'RAKOTONIRINA', ' HASIMBOLA ALPHONSE', TO_DATE('09/11/2001', 'DD/MM/YYYY'), 1, '101221138258', NULL, NULL, 'Malagasy', 'VM 94 BIS ANDRONDRAKELY SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0079', NULL, ' ', ' ', 'PRS_TEMP_0079', 'RAKOTONIAINA', ' FABIENNE CHRISTOPHE', TO_DATE('08/10/2002', 'DD/MM/YYYY'), 1, '101221140738', NULL, NULL, 'Malagasy', 'VM 92 AG BIS SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0080', NULL, ' ', ' ', 'PRS_TEMP_0080', 'RAFANOMEZANTSOA', 'HELENE', TO_DATE('28/07/1994', 'DD/MM/YYYY'), 0, '210012035971', NULL, NULL, 'Malagasy', 'VM 88 BZ SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0081', NULL, ' ', ' ', 'PRS_TEMP_0081', 'RAMILIARIJAONA', ' RAVONIRINA', TO_DATE('06/03/2001', 'DD/MM/YYYY'), 1, '101221135083', NULL, NULL, 'Malagasy', 'VM 85 C SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0082', NULL, ' ', ' ', 'PRS_TEMP_0082', 'SYNTHIA', 'CLEMENTINE MARCELLINAH', TO_DATE('02/04/1994', 'DD/MM/YYYY'), 0, '210012033494', NULL, NULL, 'Malagasy', 'VM 92 TER EC SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0083', NULL, ' ', ' ', 'PRS_TEMP_0083', 'RANAIVOMANANA', 'ELIE JEAN', TO_DATE('20/12/1984', 'DD/MM/YYYY'), 1, '116031004769', NULL, NULL, 'Malagasy', 'IVG 76 BEHORIRIKA ANKADITAPAKA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0084', NULL, ' ', ' ', 'PRS_TEMP_0084', 'RAKOTONIAVO', 'MBOLANIRINA ROLLAND', TO_DATE('18/04/2003', 'DD/MM/YYYY'), 1, '101221144549', NULL, NULL, 'Malagasy', 'LOT VM 92 C SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0085', NULL, ' ', ' ', 'PRS_TEMP_0085', 'RAZAFINARINDRA', 'TIANA VIVIANE', TO_DATE('25/10/1992', 'DD/MM/YYYY'), 0, '117392005390', NULL, NULL, 'Malagasy', 'II D 46 AMBOHIDRAZANA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0086', NULL, ' ', ' ', 'PRS_TEMP_0086', 'ANDRIATAHIANA', ' FANOMEZANTSOA FRANCE', TO_DATE('01/03/2000', 'DD/MM/YYYY'), 0, '110052010869', NULL, NULL, 'Malagasy', 'VM 92 ZI X TER SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0087', NULL, ' ', ' ', 'PRS_TEMP_0087', 'CAMARA', ' ANTHONIO LITO', TO_DATE('01/12/2003', 'DD/MM/YYYY'), 1, '101251231848', NULL, NULL, 'Malagasy', 'II B OC AMBODITSIRY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0088', NULL, ' ', ' ', 'PRS_TEMP_0088', 'HASIARIVOLA', ' DIEU DONNE', TO_DATE('15/07/1980', 'DD/MM/YYYY'), 1, '101251126391', NULL, NULL, 'Malagasy', 'AV 01 LOHARANOMBATO AMBAVAHADITOKANA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0089', NULL, ' ', ' ', 'PRS_TEMP_0089', 'RAKOTONDRASOA', 'MIHONE NARY HERVE', TO_DATE('02/03/2002', 'DD/MM/YYYY'), 1, '101231176138', NULL, NULL, 'Malagasy', 'II M 13 BIS MAHAVOKY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0090', NULL, ' ', ' ', 'PRS_TEMP_0090', 'RANDRIAMILAMINA', 'HOREL ANGELUSCO', TO_DATE('22/08/2000', 'DD/MM/YYYY'), 1, '210011045506', NULL, NULL, 'Malagasy', 'VM 88 SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0091', NULL, ' ', ' ', 'PRS_TEMP_0091', 'RANDRIATSIMANDEFITRA', 'JANVIER', TO_DATE('30/01/2003', 'DD/MM/YYYY'), 1, '101221142451', NULL, NULL, 'Malagasy', 'III L 63 BIS FIADANANA TAAN IV', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0092', NULL, ' ', ' ', 'PRS_TEMP_0092', 'RATSISETRAINA', 'MAMITIANA ANTHONIO', TO_DATE('10/10/2002', 'DD/MM/YYYY'), 1, '101251228231', NULL, NULL, 'Malagasy', 'II E 65 B AMPANOTOKANA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0093', NULL, ' ', ' ', 'PRS_TEMP_0093', 'RAHOELIMIARANTSOA', 'HERINIAINA', TO_DATE('25/01/1999', 'DD/MM/YYYY'), 1, '103131019400', NULL, NULL, 'Malagasy', 'ABE 106 ANTANETIBE AMBOHITRIMANJAKA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0094', NULL, ' ', ' ', 'PRS_TEMP_0094', 'RAKOTOMALALA', 'SITRAKA JOSELITO', TO_DATE('23/05/2003', 'DD/MM/YYYY'), 1, '101251228161', NULL, NULL, 'Malagasy', 'II C 70 MANJAKARAY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0095', NULL, ' ', ' ', 'PRS_TEMP_0095', 'RAKOTONIRINA', 'FENOSOA DOUDOU', TO_DATE('06/07/2002', 'DD/MM/YYYY'), 1, '117431009712', NULL, NULL, 'Malagasy', 'X 440 AVARABOHITRA TSIAFAHY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0096', NULL, ' ', ' ', 'PRS_TEMP_0096', 'RANDRIANANDRASANA', 'CHRISTIAN', TO_DATE('05/07/1984', 'DD/MM/YYYY'), 1, '117151008091', NULL, NULL, 'Malagasy', 'IA 71 BIS TANJOMBATO', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0097', NULL, ' ', ' ', 'PRS_TEMP_0097', 'RANOHATRA', 'HAJANIRINA', TO_DATE('11/01/1979', 'DD/MM/YYYY'), 1, '101221068552', NULL, NULL, 'Malagasy', 'CVC 70 ANKADILALAMPOTSY TANJOMBATO', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0098', NULL, ' ', ' ', 'PRS_TEMP_0098', 'RANDRIAMIHAJAMANANA', 'TANTELY NIRINA', TO_DATE('20/07/2001', 'DD/MM/YYYY'), 1, '101251234953', NULL, NULL, 'Malagasy', 'LOT II D 10 FB MANJAKARAY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0099', NULL, ' ', ' ', 'PRS_TEMP_0099', 'RAZANARIVONY', ' NINA', TO_DATE('15/12/1994', 'DD/MM/YYYY'), 0, '101982091146', NULL, NULL, 'Malagasy', 'ANTANJOMBE AMBOHIMANARINA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0100', NULL, ' ', ' ', 'PRS_TEMP_0100', 'RAFALINDRAIBE', 'JOSEPH', TO_DATE('08/03/2004', 'DD/MM/YYYY'), 1, '220551500101', NULL, NULL, 'Malagasy', 'LOT II A 88 TANJOMBATO', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0101', NULL, ' ', ' ', 'PRS_TEMP_0101', 'RANDRIA', 'ROLLAND MANANTENA CHRISTIAN', TO_DATE('13/11/2003', 'DD/MM/YYYY'), 1, '101981180063', NULL, NULL, 'Malagasy', 'IVF 57 BIS AMBODIMITA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0102', NULL, ' ', ' ', 'PRS_TEMP_0102', 'RAKOTONIAINA', ' JEAN ODILON', TO_DATE('14/06/2008', 'DD/MM/YYYY'), 1, '101221152116', NULL, NULL, 'Malagasy', 'LOT VM 43 SAROPODY ANDRONDRAKELY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0103', NULL, ' ', ' ', 'PRS_TEMP_0103', 'RANDRIANIRINA', 'XAVIER SYLVAIN', TO_DATE('12/01/1995', 'DD/MM/YYYY'), 1, '101221110649', NULL, NULL, 'Malagasy', 'III T 120 A MANDRANGOMBATO', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0104', NULL, ' ', ' ', 'PRS_TEMP_0104', 'RAFALINOMENJANAHARY', 'SITRAKINIAINA FRANCOIS', TO_DATE('31/01/2005', 'DD/MM/YYYY'), 1, '110111006112', NULL, NULL, 'Malagasy', 'VM 89 Y2 SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0105', NULL, ' ', ' ', 'PRS_TEMP_0105', 'RAHANTARIVELO', 'MITIANANTENAINA', TO_DATE('27/09/1988', 'DD/MM/YYYY'), 0, '101242136562', NULL, NULL, 'Malagasy', '320 BIS IVY ANOSIPATRANA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0106', NULL, ' ', ' ', 'PRS_TEMP_0106', 'RAKOTOMALALA', ' TAFITASOA PHILIBERT', TO_DATE('15/05/2004', 'DD/MM/YYYY'), 1, '101241214869', NULL, NULL, 'Malagasy', 'III A 91 TSIMIALONJAFY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0107', NULL, ' ', ' ', 'PRS_TEMP_0107', 'RAZAFIMBAHOAKA', ' MARIE CHANTAL', TO_DATE('11/07/1982', 'DD/MM/YYYY'), 0, '102012005637', NULL, NULL, 'Malagasy', 'VM 89 YGA SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0108', NULL, ' ', ' ', 'PRS_TEMP_0108', 'RAFANOMEZANTSOA', ' ODILE', TO_DATE('07/06/1994', 'DD/MM/YYYY'), 0, '101212215269', NULL, NULL, 'Malagasy', 'VM 94 AW SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0109', NULL, ' ', ' ', 'PRS_TEMP_0109', 'RANDRIAMIHAJA', 'HERVE', TO_DATE('06/05/2005', 'DD/MM/YYYY'), 1, '101231185018', NULL, NULL, 'Malagasy', 'LOT IVG 76BEHORIRIKA ANKADITAPAKA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0110', NULL, ' ', ' ', 'PRS_TEMP_0110', 'ROVASOA', ' PATRICIA', TO_DATE('24/01/2001', 'DD/MM/YYYY'), 0, '117152029583', NULL, NULL, 'Malagasy', 'VM 92 F TER SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0111', NULL, ' ', ' ', 'PRS_TEMP_0111', 'RAKOTONDRAINY', 'THIERY BRUNO', TO_DATE('15/08/1999', 'DD/MM/YYYY'), 1, '117271006950', NULL, NULL, 'Malagasy', 'LOT FAIV 063 MALAHO AMPANEFY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0112', NULL, ' ', ' ', 'PRS_TEMP_0112', 'HAJANIAINA', 'ERIC MARIO ANTONIO', TO_DATE('30/12/2000', 'DD/MM/YYYY'), 1, '101241195771', NULL, NULL, 'Malagasy', 'III S 362 F MADERA NAMONTANA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0113', NULL, ' ', ' ', 'PRS_TEMP_0113', 'RANDRIANANDRASANA', 'EZEKELA FANANTENANA', TO_DATE('21/08/2005', 'DD/MM/YYYY'), 1, '117151032227', NULL, NULL, 'Malagasy', 'LOT BM 72 ZAB TANJOMBATO', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0114', NULL, ' ', ' ', 'PRS_TEMP_0114', 'NARINDRAMPIFALIANA', 'MANOISOA SARIAKA', TO_DATE('10/05/2004', 'DD/MM/YYYY'), 0, '115072023053', NULL, NULL, 'Malagasy', 'III N 21 FIADANANA TANA IV', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0115', NULL, ' ', ' ', 'PRS_TEMP_0115', 'SAFIDINIRINA', 'TOLOJANAHARY SAHAZANIAINA', TO_DATE('17/10/1999', 'DD/MM/YYYY'), 1, '107131003032', NULL, NULL, 'Malagasy', 'LOT VM 92 ZAC SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0116', NULL, ' ', ' ', 'PRS_TEMP_0116', 'RAKOTOMALALA', 'MAMY LALAINA', TO_DATE('15/06/2024', 'DD/MM/YYYY'), 1, '101211225663', NULL, NULL, 'Malagasy', 'LOT II IC 67 B ANKADITOHO MAROHOHO', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0117', NULL, ' ', ' ', 'PRS_TEMP_0117', 'RAZAFIMANANTSOA', 'LIOKA MAMPIONONA', TO_DATE('17/07/1996', 'DD/MM/YYYY'), 1, '101241170589', NULL, NULL, 'Malagasy', 'III S 371 AC MADERA NAMONTANA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0118', NULL, ' ', ' ', 'PRS_TEMP_0118', 'RAZAFINDRAJOHANESA', 'JEAN PHILIPPE RAYMOND', TO_DATE('09/12/2003', 'DD/MM/YYYY'), 1, '101211278480', NULL, NULL, 'Malagasy', 'IVL 215 ANDOHATAPENAKA II', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0119', NULL, ' ', ' ', 'PRS_TEMP_0119', 'RAJAONARISOA', ' TAHINJANAHARY NANTENAINA DOMOINA LIA', TO_DATE('29/06/2004', 'DD/MM/YYYY'), 0, '117172028174', NULL, NULL, 'Malagasy', 'BL 090 BELAMBANANA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0120', NULL, ' ', ' ', 'PRS_TEMP_0120', 'RAVALOHERY', 'MICKAEL HYGENIE', TO_DATE('23/08/2002', 'DD/MM/YYYY'), 1, '101251222724', NULL, NULL, 'Malagasy', 'II C 2 TER FP MANJAKARAY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0121', NULL, ' ', ' ', 'PRS_TEMP_0121', 'RAFALIMANANA', 'SOLO ANDRE', TO_DATE('20/03/2000', 'DD/MM/YYYY'), 1, '10124121010', NULL, NULL, 'Malagasy', 'III C 29 BIS AMBANINAMPAMARINANA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0122', NULL, ' ', ' ', 'PRS_TEMP_0122', 'MBOLATIANA', 'TAHIRY NANTENAINA', TO_DATE('24/12/2004', 'DD/MM/YYYY'), 1, '117151031335', NULL, NULL, 'Malagasy', 'IA 199 TANJOMBATO', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0123', NULL, ' ', ' ', 'PRS_TEMP_0123', 'RAHARINIRINA', 'CLAVIN', TO_DATE('19/06/2003', 'DD/MM/YYYY'), 1, '210311012831', NULL, NULL, 'Malagasy', 'VM 88 TER SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0124', NULL, ' ', ' ', 'PRS_TEMP_0124', 'TAHIANARISON', 'JEAN MARC', TO_DATE('07/05/1997', 'DD/MM/YYYY'), 1, '116011021892', NULL, NULL, 'Malagasy', 'II S 40 T BIS ANJANAHARY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0125', NULL, ' ', ' ', 'PRS_TEMP_0125', 'RANDRIAMITANA', 'BERTOLET', TO_DATE('31/12/1992', 'DD/MM/YYYY'), 1, '212191004201', NULL, NULL, 'Malagasy', 'VM 92 BIS SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0126', NULL, ' ', ' ', 'PRS_TEMP_0126', 'RASOLONDRIANAINA', '', TO_DATE('02/01/1997', 'DD/MM/YYYY'), 1, '116031011021', NULL, NULL, 'Malagasy', 'LOT II AC 263 TANJOMBATO', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0127', NULL, ' ', ' ', 'PRS_TEMP_0127', 'RANDRIAMANANTSOA', ' HERY NY AINA FRANCOIS', TO_DATE('18/11/2004', 'DD/MM/YYYY'), 1, '101221149984', NULL, NULL, 'Malagasy', 'LOT VM 91 UAR SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0128', NULL, ' ', ' ', 'PRS_TEMP_0128', 'RAMIALITIANA', ' OLIVIA RINAH', TO_DATE('03/11/2003', 'DD/MM/YYYY'), 0, '101222146009', NULL, NULL, 'Malagasy', 'VM 88 ZCE SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0129', NULL, ' ', ' ', 'PRS_TEMP_0129', 'RAMAHAIMANANA', 'SERAPHINE CLAUDIA', TO_DATE('07/10/1996', 'DD/MM/YYYY'), 0, '117152020056', NULL, NULL, 'Malagasy', 'LOT FA 198 BIS AMBOHIMANATRIKA TANJOMBATO', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0130', NULL, ' ', ' ', 'PRS_TEMP_0130', 'RAKOTONIRINA', 'NAMBININTSOA', TO_DATE('18/07/2003', 'DD/MM/YYYY'), 1, '117191019797', NULL, NULL, 'Malagasy', 'LOT IB 713 ANDOHARANOFOTSY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0131', NULL, ' ', ' ', 'PRS_TEMP_0131', 'RANDRIAMBOAVONJY', 'TSIRINIAINA SAROBIDY', TO_DATE('15/07/2005', 'DD/MM/YYYY'), 1, '117191021118', NULL, NULL, 'Malagasy', 'LOT IAC 44 ANTSAHASOA ANKARAOBATO', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0132', NULL, ' ', ' ', 'PRS_TEMP_0132', 'RAFANOHARANA', 'MIARY MALALA', TO_DATE('06/09/1979', 'DD/MM/YYYY'), 0, '101212150934', NULL, NULL, 'Malagasy', 'LOT VD 15 AMPARIBE', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0133', NULL, ' ', ' ', 'PRS_TEMP_0133', 'RAKOTONDRAZAKA', ' OLIVIER', TO_DATE('08/03/2024', 'DD/MM/YYYY'), 1, '103301028111', NULL, NULL, 'Malagasy', 'LOT VM 92 OJK SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0134', NULL, ' ', ' ', 'PRS_TEMP_0134', 'RAZAFINDRAVONY', 'JONCE ANJATIANA', TO_DATE('10/10/1998', 'DD/MM/YYYY'), 0, '101222127527', NULL, NULL, 'Malagasy', 'SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0135', NULL, ' ', ' ', 'PRS_TEMP_0135', 'RAZANAMARY', 'HERINIAINA NATACHA', TO_DATE('25/08/1997', 'DD/MM/YYYY'), 0, '117392007398', NULL, NULL, 'Malagasy', 'LOT IN 34 ANDRANONANAHARY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0136', NULL, ' ', ' ', 'PRS_TEMP_0136', 'RASOANIRINA', 'ROLLINE', TO_DATE('07/01/2004', 'DD/MM/YYYY'), 0, '101252232424', NULL, NULL, 'Malagasy', 'LOT II O 140 BIS ANJANAHARY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0137', NULL, ' ', ' ', 'PRS_TEMP_0137', 'MASY', 'MAMITIANA JIONAH LINDA TURNER', TO_DATE('03/03/2001', 'DD/MM/YYYY'), 0, '103132020524', NULL, NULL, 'Malagasy', 'LOT HTS 33 ANDRANNOMAHINTSY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0138', NULL, ' ', ' ', 'PRS_TEMP_0138', 'RAFANOMEZANTSOA', ' NIAINA MARIO', TO_DATE('03/03/2006', 'DD/MM/YYYY'), 1, '10122115643', NULL, NULL, 'Malagasy', 'LOT VM 92 D SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0139', NULL, ' ', ' ', 'PRS_TEMP_0139', 'RAKOTOARISOA', ' LALAINA THIERRY', TO_DATE('16/05/1990', 'DD/MM/YYYY'), 1, '101221095829', NULL, NULL, 'Malagasy', '', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0140', NULL, ' ', ' ', 'PRS_TEMP_0140', 'NOMENJANAHARY', ' MIRANA HONORINE', TO_DATE('20/01/1995', 'DD/MM/YYYY'), 0, '101222110471', NULL, NULL, 'Malagasy', 'LOT VM P SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0141', NULL, ' ', ' ', 'PRS_TEMP_0141', 'RAZANADRABE', ' HERINIAINA SITRAKA', TO_DATE('13/09/2002', 'DD/MM/YYYY'), 1, '101221140223', NULL, NULL, 'Malagasy', '', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0142', NULL, ' ', ' ', 'PRS_TEMP_0142', 'RASOAMANJARY', 'EMBININA', TO_DATE('20/04/1996', 'DD/MM/YYYY'), 1, '118051008603', NULL, NULL, 'Malagasy', 'AMBOANJOBE', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0143', NULL, ' ', ' ', 'PRS_TEMP_0143', 'RABENAIVOSON', 'PATRICK ANDRE', TO_DATE('16/02/1998', 'DD/MM/YYYY'), 1, '117151021932', NULL, NULL, 'Malagasy', 'LOT II A 220 TANJPMBATO IRAITSIMIVAKY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0144', NULL, ' ', ' ', 'PRS_TEMP_0144', 'MAHAFATOKY', 'GUY AMEDE', TO_DATE('16/05/1993', 'DD/MM/YYYY'), 1, '117011026203', NULL, NULL, 'Malagasy', 'LOT AB 172/III ANTANETY AMBHIMAMORY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0145', NULL, ' ', ' ', 'PRS_TEMP_0145', 'ANDRIAMASINAVALONA', 'TSILAVINA MARIE ANNE', TO_DATE('16/06/2001', 'DD/MM/YYYY'), 0, '101222135701', NULL, NULL, 'Malagasy', 'LOT VT 29 ABX AMPAHATEZA AMBOHIPO', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0146', NULL, ' ', ' ', 'PRS_TEMP_0146', 'RAVELOARINORO', 'NATACHA', TO_DATE('29/01/1999', 'DD/MM/YYYY'), 0, '102092029622', NULL, NULL, 'Malagasy', 'LOT B 48 AMBODITSIRY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0147', NULL, ' ', ' ', 'PRS_TEMP_0147', 'RANDRINDRA', 'ONJAMAHEFA ANNA', TO_DATE('21/10/2001', 'DD/MM/YYYY'), 0, '101252218939', NULL, NULL, 'Malagasy', 'LOT II N 10 AMBATOBE', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0148', NULL, ' ', ' ', 'PRS_TEMP_0148', 'RANDRIAMALALA', 'TOJOFIONONANA SEBASTIEN FIFALIANA', TO_DATE('07/03/2005', 'DD/MM/YYYY'), 1, '101211279589', NULL, NULL, 'Malagasy', 'LOT FMAI 30 67 HA SUD', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0149', NULL, ' ', ' ', 'PRS_TEMP_0149', 'RABODONARIVO', 'TANJONA VOASAINA', TO_DATE('21/10/1994', 'DD/MM/YYYY'), 0, '117452003773', NULL, NULL, 'Malagasy', 'LOT IC 174 BIS ANKADILALAMPOTSY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0150', NULL, ' ', ' ', 'PRS_TEMP_0150', 'RANDRIAMAHAFALIARINIVO', 'NEHEMIA', TO_DATE('02/06/2005', 'DD/MM/YYYY'), 1, '106091011498', NULL, NULL, 'Malagasy', 'AMBOHIMANGAKELY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0151', NULL, ' ', ' ', 'PRS_TEMP_0151', 'RAKOTOARIVELOSON', 'JEAN BARTHELEMY', TO_DATE('24/01/2003', 'DD/MM/YYYY'), 1, '117151032275', NULL, NULL, 'Malagasy', 'LOT VM 92 ZAB SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0152', NULL, ' ', ' ', 'PRS_TEMP_0152', 'RAJAONARIVELO', 'YVES WILLIAM', TO_DATE('07/11/2002', 'DD/MM/YYYY'), 1, '117151029743', NULL, NULL, 'Malagasy', 'LOT IA 150 TANJOMBATO', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0153', NULL, ' ', ' ', 'PRS_TEMP_0153', 'FALINIRINA', 'HOSEA', TO_DATE('09/06/2006', 'DD/MM/YYYY'), 1, '101221160889', NULL, NULL, 'Malagasy', 'LOT VM 88 A ANDRONDRAKELY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0154', NULL, ' ', ' ', 'PRS_TEMP_0154', 'RANDRIANJATOVO', 'LOVASOA JACQUIS', TO_DATE('18/05/2001', 'DD/MM/YYYY'), 1, '117151025944', NULL, NULL, 'Malagasy', 'LOT II A 71 TANJOMBATO', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0155', NULL, ' ', ' ', 'PRS_TEMP_0155', 'FENOFITAHIANA', ' LAHATRA', TO_DATE('14/12/2003', 'DD/MM/YYYY'), 1, '117151029321', NULL, NULL, 'Malagasy', 'LOT VM 96 KE ANDRONDRAKELY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0156', NULL, ' ', ' ', 'PRS_TEMP_0156', 'RABEMANANTSOA', 'ANDRIANARIJAONA MAHARAVO FIDELE', TO_DATE('25/06/2002', 'DD/MM/YYYY'), 1, '101221139427', NULL, NULL, 'Malagasy', 'LOT VM 94 BIS D SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0157', NULL, ' ', ' ', 'PRS_TEMP_0157', 'RAFANOMEZANTSOA', ' RAYMOND', TO_DATE('17/05/2000', 'DD/MM/YYYY'), 1, '114011041138', NULL, NULL, 'Malagasy', 'SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0158', NULL, ' ', ' ', 'PRS_TEMP_0158', 'RAFANOMEZANTSOA', 'LESITERA FIDELIN', TO_DATE('05/07/2005', 'DD/MM/YYYY'), 1, '101221153675', NULL, NULL, 'Malagasy', 'LOT VM 92 AKE SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0159', NULL, ' ', ' ', 'PRS_TEMP_0159', 'RINDRANIAINA', 'FITAHIANA', TO_DATE('17/12/2006', 'DD/MM/YYYY'), 1, '117151034253', NULL, NULL, 'Malagasy', 'LOT VM 92 AKE SAROPODY ANDRONDRAKELY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0160', NULL, ' ', ' ', 'PRS_TEMP_0160', 'ANDRIAMAMORY', 'JEAN ELIE', TO_DATE('05/12/2005', 'DD/MM/YYYY'), 1, '101221155571', NULL, NULL, 'Malagasy', 'LOT VM 92 II NE SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0161', NULL, ' ', ' ', 'PRS_TEMP_0161', 'RASAMISON', 'JAONA TSILAVINIRINA PASCAL', TO_DATE('07/04/1996', 'DD/MM/YYYY'), 1, '101221115391', NULL, NULL, 'Malagasy', 'LOT VT 69 BIS ANDOHANIMANDROSEZA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0162', NULL, ' ', ' ', 'PRS_TEMP_0162', 'RAKOTONDRAZAKA', ' HERITIANA ALTINO', TO_DATE('02/07/2006', 'DD/MM/YYYY'), 1, '101221158192', NULL, NULL, 'Malagasy', 'LOT UL 26 K AMBOHIBARY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0163', NULL, ' ', ' ', 'PRS_TEMP_0163', 'RAKOTONDRANAIVO', 'TANJONIRINA HERINIAINA', TO_DATE('21/07/2006', 'DD/MM/YYYY'), 1, '101221158146', NULL, NULL, 'Malagasy', 'LOT VM 92 SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0164', NULL, ' ', ' ', 'PRS_TEMP_0164', 'RANDRIANANTENAINA', 'FABIEN AIME', TO_DATE('13/12/2001', 'DD/MM/YYYY'), 1, '109371028147', NULL, NULL, 'Malagasy', 'LOT IA 16 TANJOMBATO', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0165', NULL, ' ', ' ', 'PRS_TEMP_0165', 'RABEARIMALALA', 'MAHENINA JEFTA', TO_DATE('12/09/2000', 'DD/MM/YYYY'), 1, '117171023930', NULL, NULL, 'Malagasy', 'LOT VF 164 VOLOTARA ANDOHARANOFOTSY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0166', NULL, ' ', ' ', 'PRS_TEMP_0166', 'RAZAFINDRALAKA', 'FREDERIC', TO_DATE('15/02/2004', 'DD/MM/YYYY'), 1, '117191020428', NULL, NULL, 'Malagasy', 'LOT IC 17 BIS ANKARAOBATO', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0167', NULL, ' ', ' ', 'PRS_TEMP_0167', 'RAKOTONIAINA', 'MIANDRIVOLA FITIAVANA', TO_DATE('02/05/2000', 'DD/MM/YYYY'), 1, '101241193017', NULL, NULL, 'Malagasy', 'LOT III S 364 B OUEST MANANJARA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0168', NULL, ' ', ' ', 'PRS_TEMP_0168', 'RANDRIAMISA', 'DOLIVA', TO_DATE('22/03/1997', 'DD/MM/YYYY'), 1, '101241173098', NULL, NULL, 'Malagasy', 'OUEST SOANIERANA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0169', NULL, ' ', ' ', 'PRS_TEMP_0169', 'RAMAROSON', 'ANDRIATOLOJANAHARY SEDRANIAINA', TO_DATE('20/11/1996', 'DD/MM/YYYY'), 1, '101241171846', NULL, NULL, 'Malagasy', 'LOT III I 137 SOANIERANA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0170', NULL, ' ', ' ', 'PRS_TEMP_0170', 'RATSIMBAZAFY', 'LOVASOA JOACHIM', TO_DATE('07/12/2001', 'DD/MM/YYYY'), 1, '101251222265', NULL, NULL, 'Malagasy', 'LOT II N 88 BIS ANJANAHARY II', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0171', NULL, ' ', ' ', 'PRS_TEMP_0171', 'RAZAFINDRATSIMBA', 'WILLI', TO_DATE('31/12/2001', 'DD/MM/YYYY'), 1, '101221138128', NULL, NULL, 'Malagasy', 'LOT VM 92 DS BIS SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0172', NULL, ' ', ' ', 'PRS_TEMP_0172', 'RAKOTONDRAVELO', 'FRANCOIS FREDE', TO_DATE('26/06/2004', 'DD/MM/YYYY'), 1, '520111014028', NULL, NULL, 'Malagasy', 'LOT 199 TER AMBOHIMANATRIKA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0173', NULL, ' ', ' ', 'PRS_TEMP_0173', 'RANDRIAMIFIDISON', 'JEAN SEBASTIEN PATRICK', TO_DATE('04/04/1993', 'DD/MM/YYYY'), 1, '501111020515', NULL, NULL, 'Malagasy', 'LOT II O ANJANAHARY II O 21', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0174', NULL, ' ', ' ', 'PRS_TEMP_0174', 'RAMANANTSOA', 'HERITINA', TO_DATE('12/06/2000', 'DD/MM/YYYY'), 1, '115091023552', NULL, NULL, 'Malagasy', 'LOT SI 041 BIS D SOAVINA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0175', NULL, ' ', ' ', 'PRS_TEMP_0175', 'RANAIVOHARINABO', 'HANTSA TAHIRINAINA', TO_DATE('23/06/1990', 'DD/MM/YYYY'), 1, '101221097856', NULL, NULL, 'Malagasy', 'LOT VM 94 6AR SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0176', NULL, ' ', ' ', 'PRS_TEMP_0176', 'RAAKOTONDRAMANANA', 'FINOANASOA FANDRESENA', TO_DATE('07/04/2003', 'DD/MM/YYYY'), 1, '101241215971', NULL, NULL, 'Malagasy', 'MADERA NAMONTANA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0177', NULL, ' ', ' ', 'PRS_TEMP_0177', 'RAKOTO', 'ALBERT JEAN LUCA', TO_DATE('31/03/2003', 'DD/MM/YYYY'), 1, '101221142770', NULL, NULL, 'Malagasy', 'LOT VM 88 SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0178', NULL, ' ', ' ', 'PRS_TEMP_0178', 'RANDRIAMAHERISON', 'AVOTRINIAINA ESMAEL', TO_DATE('30/07/2000', 'DD/MM/YYYY'), 1, '115171006581', NULL, NULL, 'Malagasy', 'AMBOHIMANGAKELY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0179', NULL, ' ', ' ', 'PRS_TEMP_0179', 'RAVEROMALALA', 'NORONIRINA SYLVIE', TO_DATE('04/11/1997', 'DD/MM/YYYY'), 0, '117152022435', NULL, NULL, 'Malagasy', 'LOT VM 88 SM SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0180', NULL, ' ', ' ', 'PRS_TEMP_0180', 'RAHARINIRINA', 'LAMBERCIE STEVIE', TO_DATE('31/07/2004', 'DD/MM/YYYY'), 1, '117151030760', NULL, NULL, 'Malagasy', 'LOT II A 288 TANJOMBATO IRAITSIMIVAKY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0181', NULL, ' ', ' ', 'PRS_TEMP_0181', 'ANDRIANIRINA', 'LOVASOA SEDRA ONJA', TO_DATE('17/10/1999', 'DD/MM/YYYY'), 1, '102071026707', NULL, NULL, 'Malagasy', 'LOT C 19 B AMBOHINAORINA SABOTSY NAMEHANA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0182', NULL, ' ', ' ', 'PRS_TEMP_0182', 'RAKOTONDRANAIVO', 'HERINANTENAINA LAZASOA', TO_DATE('06/09/1999', 'DD/MM/YYYY'), 1, '106401008108', NULL, NULL, 'Malagasy', 'LOT VL 11 SDA ANDRONDRA AMPAMANTANANA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0183', NULL, ' ', ' ', 'PRS_TEMP_0183', 'RAKOTOARISOA', 'HENRI CHRISTOPHE', TO_DATE('20/03/2002', 'DD/MM/YYYY'), 1, '117271008284', NULL, NULL, 'Malagasy', 'LOT CIL 13 ANKADIVORIBE', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0184', NULL, ' ', ' ', 'PRS_TEMP_0184', 'VANO', ' ANGELIN', TO_DATE('22/05/1981', 'DD/MM/YYYY'), 1, '501011007213', NULL, NULL, 'Malagasy', 'TANJOMBATO IRAITSIMIVAKY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0185', NULL, ' ', ' ', 'PRS_TEMP_0185', 'ROMARIO', 'ZAFITIANA', TO_DATE('16/08/2000', 'DD/MM/YYYY'), 1, '212131004017', NULL, NULL, 'Malagasy', 'AMBATOMAINTY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0186', NULL, ' ', ' ', 'PRS_TEMP_0186', 'RAHARINIAINA', 'VOLOLONIRINA ONJARINA', TO_DATE('06/02/1992', 'DD/MM/YYYY'), 0, '115112008436', NULL, NULL, 'Malagasy', 'LOT III T 190 GAE ANGARANGARANA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0187', NULL, ' ', ' ', 'PRS_TEMP_0187', 'RAHARITIASOA', 'ERNEST', TO_DATE('20/06/1981', 'DD/MM/YYYY'), 1, '102431003573', NULL, NULL, 'Malagasy', 'LOT AVB AVARABOHITRA ITAOSY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0188', NULL, ' ', ' ', 'PRS_TEMP_0188', 'RAKOTOMALALA', 'FANOMEZANTSOA ANTENAINA', TO_DATE('30/12/2000', 'DD/MM/YYYY'), 1, '102091032713', NULL, NULL, 'Malagasy', 'LOT GIV 33 BIS MAHAZO SOAMANANDRARINY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0189', NULL, ' ', ' ', 'PRS_TEMP_0189', 'RAZAFINDRABE', 'FETRANIAINA MARINOT', TO_DATE('01/01/1999', 'DD/MM/YYYY'), 1, '101221125421', NULL, NULL, 'Malagasy', 'LOT H 41 ANTANETY MIADANA ALASORA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0190', NULL, ' ', ' ', 'PRS_TEMP_0190', 'RAKOTOARIMALALA', 'NOMENJANAHARY FRANCK ERICA', TO_DATE('27/07/1998', 'DD/MM/YYYY'), 1, '117191015591', NULL, NULL, 'Malagasy', 'ANKARAOBATO', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0191', NULL, ' ', ' ', 'PRS_TEMP_0191', 'RAZANAJAONA', 'LALA HARIMBOLA', TO_DATE('30/05/1991', 'DD/MM/YYYY'), 1, '101241146417', NULL, NULL, 'Malagasy', 'LOT VM 91 B BIS SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0192', NULL, ' ', ' ', 'PRS_TEMP_0192', 'RASOARINORO', 'ANJA JOELLE', TO_DATE('17/04/1993', 'DD/MM/YYYY'), 0, '101222105042', NULL, NULL, 'Malagasy', '', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0193', NULL, ' ', ' ', 'PRS_TEMP_0193', 'RAZAFINDRAHELY', 'DAUDETTE EMANUELLA ERVEA', TO_DATE('21/12/1995', 'DD/MM/YYYY'), 0, '209012037108', NULL, NULL, 'Malagasy', 'LOT VM92 AJT SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0194', NULL, ' ', ' ', 'PRS_TEMP_0194', 'LOUVEINS', 'MAMY NIAINA NY HARENA FITAHIANA', TO_DATE('08/05/2007', 'DD/MM/YYYY'), 1, '101981129888', NULL, NULL, 'Malagasy', 'LOT IVH 41T AMBODIMITA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0195', NULL, ' ', ' ', 'PRS_TEMP_0195', 'RAHARILALA', 'ERIC JAMY', TO_DATE('10/06/2004', 'DD/MM/YYYY'), 1, '101211272843', NULL, NULL, 'Malagasy', 'LOT IVO 181 ANTOHOMADINIKA SUD', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0196', NULL, ' ', ' ', 'PRS_TEMP_0196', 'RATSIMBAZAFY', 'TAFITANIAINA GINOT', TO_DATE('07/12/2004', 'DD/MM/YYYY'), 1, '101221151213', NULL, NULL, 'Malagasy', 'LOT VL 1 TER P AMPAMANTANANA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0197', NULL, ' ', ' ', 'PRS_TEMP_0197', 'RANDRIANARIMANANA', ' THIERRY ALPHONSE', TO_DATE('01/08/2002', 'DD/MM/YYYY'), 1, '106461014088', NULL, NULL, 'Malagasy', 'LOT VA 32 LF TSIADANA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0198', NULL, ' ', ' ', 'PRS_TEMP_0198', 'RAKOTOARISOA', 'HERY DANIEL', TO_DATE('27/01/2005', 'DD/MM/YYYY'), 1, '101221151531', NULL, NULL, 'Malagasy', 'LOT VM 88 A SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0199', NULL, ' ', ' ', 'PRS_TEMP_0199', 'RASOARIMANANA', 'PATI EUGENIE', TO_DATE('18/04/1997', 'DD/MM/YYYY'), 0, '101222127396', NULL, NULL, 'Malagasy', 'LOT VM 8993 SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0200', NULL, ' ', ' ', 'PRS_TEMP_0200', 'RAFARASOA', 'MIARY CELESTINE', TO_DATE('12/04/2007', 'DD/MM/YYYY'), 0, '117432012257', NULL, NULL, 'Malagasy', 'LOT VM 92 AB SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0201', NULL, ' ', ' ', 'PRS_TEMP_0201', 'AFERNOLIN', ' PATRISCA', TO_DATE('30/12/1998', 'DD/MM/YYYY'), 1, '315011037401', NULL, NULL, 'Malagasy', 'LOT VM 92 AZ SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0202', NULL, ' ', ' ', 'PRS_TEMP_0202', 'RAFANOMEZANTSOA', 'MAMITIANA CHRISTIEN', TO_DATE('17/07/2005', 'DD/MM/YYYY'), 1, '101251243345', NULL, NULL, 'Malagasy', 'LOT II C 106 BIS MANJAKARAY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0203', NULL, ' ', ' ', 'PRS_TEMP_0203', 'RAKOTONIRINA', 'AVOTRINIAINA CARTI', TO_DATE('18/03/2007', 'DD/MM/YYYY'), 1, '101221160645', NULL, NULL, 'Malagasy', 'LOTVM 88 V ATER SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0204', NULL, ' ', ' ', 'PRS_TEMP_0204', 'RANDRIAMANALINA', 'NOREL CELESTINE', TO_DATE('29/07/1998', 'DD/MM/YYYY'), 1, '117151026122', NULL, NULL, 'Malagasy', 'LOT VM 88 E SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0205', NULL, ' ', ' ', 'PRS_TEMP_0205', 'ANDRIAMANARIVO', 'ELIA FIDERANA', TO_DATE('23/12/2005', 'DD/MM/YYYY'), 1, '117191021574', NULL, NULL, 'Malagasy', 'LOT II C 46 ANKADINANDRIANA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0206', NULL, ' ', ' ', 'PRS_TEMP_0206', 'TOLY', ' JEAN FREDERIC CHARLIE', TO_DATE('06/02/2003', 'DD/MM/YYYY'), 1, '201011036349', NULL, NULL, 'Malagasy', 'LOT VM 92 AZ SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0207', NULL, ' ', ' ', 'PRS_TEMP_0207', 'RANDRIAMANTENA', ' HERIZO', TO_DATE('14/10/2006', 'DD/MM/YYYY'), 1, '117151034064', NULL, NULL, 'Malagasy', '', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0208', NULL, ' ', ' ', 'PRS_TEMP_0208', 'RAVELOMANJAKA', 'TURIBE', TO_DATE('01/01/1998', 'DD/MM/YYYY'), 1, '101231165655', NULL, NULL, 'Malagasy', 'LOT 360 AI TER ANTANAMBAO AMBOHIMANGAKELY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0209', NULL, ' ', ' ', 'PRS_TEMP_0209', 'NOMENJANAHARY', 'CHRISTIAN TSILAVINA', TO_DATE('14/11/2006', 'DD/MM/YYYY'), 1, '101221159670', NULL, NULL, 'Malagasy', 'LOT VL 2 AMPAMANTANANA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0210', NULL, ' ', ' ', 'PRS_TEMP_0210', 'RANDRIANANTENAINA', ' FALY ANGELO FLAVIEN', TO_DATE('01/01/1999', 'DD/MM/YYYY'), 1, '101221124653', NULL, NULL, 'Malagasy', 'LOT II A 98 T TANJOMBATO IRAITSIMIVAKY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0211', NULL, ' ', ' ', 'PRS_TEMP_0211', 'RAZAFINIERANA', 'SUZANNE', TO_DATE('08/04/1966', 'DD/MM/YYYY'), 0, '108092000021', NULL, NULL, 'Malagasy', 'LOT III VB 070 TANJOMBATO TONGARIVO', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0212', NULL, ' ', ' ', 'PRS_TEMP_0212', 'RASOAZANAMIARANA', ' JEANNE', TO_DATE('26/04/1975', 'DD/MM/YYYY'), 0, '117152003118', NULL, NULL, 'Malagasy', 'LOT II A 71 TANJOMBATO', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0213', NULL, ' ', ' ', 'PRS_TEMP_0213', 'RAFARASOA', 'ANNE  MARIE JEANNE', TO_DATE('16/11/1979', 'DD/MM/YYYY'), 0, '117152006266', NULL, NULL, 'Malagasy', 'LOT II A 71 TANJOMBATO', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0214', NULL, ' ', ' ', 'PRS_TEMP_0214', 'RAMASIARISOA', 'JACQUELINE', TO_DATE('08/02/1967', 'DD/MM/YYYY'), 0, '117152001150', NULL, NULL, 'Malagasy', 'LOT II A 71 TANJOMBATO', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0215', NULL, ' ', ' ', 'PRS_TEMP_0215', 'RAVONIARISOA', 'HERLINE', TO_DATE('03/04/1974', 'DD/MM/YYYY'), 0, '104052000775', NULL, NULL, 'Malagasy', 'LOT III A 117 BIS ANDAFIATSIMO TANJOMBATO', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0216', NULL, ' ', ' ', 'PRS_TEMP_0216', 'RAVONIARISOA', 'LEONTINE', TO_DATE('29/07/1981', 'DD/MM/YYYY'), 0, '102012005476', NULL, NULL, 'Malagasy', 'VM 50 B ANDRONDRAKELY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0217', NULL, ' ', ' ', 'PRS_TEMP_0217', 'RASOANJANAHARY', 'HOLIHANITRA MARIE JOSIANE', TO_DATE('08/11/1979', 'DD/MM/YYYY'), 0, '201032013201', NULL, NULL, 'Malagasy', 'LOT VM 92 BIS II SAROPODY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0218', NULL, ' ', ' ', 'PRS_TEMP_0218', 'RAHARIVOLOLOMANGA', 'FANJANIRINA', TO_DATE('13/01/1984', 'DD/MM/YYYY'), 0, '101242118516', NULL, NULL, 'Malagasy', 'LOT IIIS 84 B ANOSIBE', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0219', NULL, ' ', ' ', 'PRS_TEMP_0219', 'ANDRIANANTENAINA', 'DAVID CHRISTIAN', TO_DATE('28/01/1985', 'DD/MM/YYYY'), 1, '117152008811', NULL, NULL, 'Malagasy', 'LOT IA 40 TANJOMBATO', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0220', NULL, ' ', ' ', 'PRS_TEMP_0220', 'VOLOLONIRINA', 'YOLANDE ADRIENNE', TO_DATE('15/09/1967', 'DD/MM/YYYY'), 0, '101241070448', NULL, NULL, 'Malagasy', 'LOT II L 28 ANDRAVOAHANGY', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE) VALUES('PRS_TEMP_0221', NULL, ' ', ' ', 'PRS_TEMP_0221', 'RABENIAINA', 'EDOUARDO', TO_DATE('01/05/1985', 'DD/MM/YYYY'), 1, '117191006146', NULL, NULL, 'Malagasy', 'LOT III C 141 BIS ANKARAOBATO', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);



---update etat=11
update paie_info_personnel set etat=11;




-- PAIE INFO PERSONNEL POUR LES PERSONNELS VACATAIRES
    INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, SITUATION_MATRIMONIAL, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT,
 IDFONCTION, TELEPHONE, MODE_PAIEMENT, IDCATEGORIE_PAIE, TYPECONTRAT, IDQUALIFICATION, INDICEGRADE, NBENFANT, TEMPORAIRE)
VALUES('PRS000100', SYSDATE, '100', '752716001521', 'SIT02', 'LOT 21 B 190 AVARATSENA AMBOHIMIANDRISOA ANTSIRABE', TO_DATE('01/12/2017','DD/MM/YYYY'), TO_DATE('01/12/2017','DD/MM/YYYY'),
    'PAF010316', NULL, '0003', 'CP0000011', 'TYP0000002', 'QUAL0011', 1910, 1, -1);

INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, SITUATION_MATRIMONIAL, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT,
 IDFONCTION, TELEPHONE, MODE_PAIEMENT, IDCATEGORIE_PAIE, TYPECONTRAT, IDQUALIFICATION, INDICEGRADE, NBENFANT, TEMPORAIRE)
VALUES('PRS000110', SYSDATE, '110', '901215005039', 'SIT02', 'LOT 319 P/LLE 21/73 TANAMBAO VERERIETOAMASINA', TO_DATE('11/08/2012','DD/MM/YYYY'), TO_DATE('11/08/2012','DD/MM/YYYY'),
       'PAF010316', NULL, '0003', 'CP0000011', 'TYP0000002', 'QUAL0011', 1910, 2, -1);

INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, SITUATION_MATRIMONIAL, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT,
 IDFONCTION, TELEPHONE, MODE_PAIEMENT, IDCATEGORIE_PAIE, TYPECONTRAT, IDQUALIFICATION, INDICEGRADE, NBENFANT, TEMPORAIRE)
VALUES('PRS000119', SYSDATE, '119', '860218005256', 'SIT02', 'LOT BIS 420/IB/3611 TANAMBAO ZOARA', TO_DATE('01/08/2012','DD/MM/YYYY'), TO_DATE('01/08/2012','DD/MM/YYYY'),
       'PAF020316', NULL, '0003', 'CP0000011', 'TYP0000002', 'QUAL0023', 2460, 3, -1);

INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, SITUATION_MATRIMONIAL, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT,
 IDFONCTION, TELEPHONE, MODE_PAIEMENT, IDCATEGORIE_PAIE, TYPECONTRAT, IDQUALIFICATION, INDICEGRADE, NBENFANT, TEMPORAIRE)
VALUES('PRS000138', SYSDATE, '138', '861019004580', 'SIT02', 'LOT  TANAMBAO MORAFENO EN FACE EXE SOMASOA', TO_DATE('18/05/2013','DD/MM/YYYY'), TO_DATE('18/05/2013','DD/MM/YYYY'),
       'PAF020316', NULL, '0003', 'CP0000011', 'TYP0000002', 'QUAL0023', 2460, 0, -1);

INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, SITUATION_MATRIMONIAL, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT,
 IDFONCTION, TELEPHONE, MODE_PAIEMENT, IDCATEGORIE_PAIE, TYPECONTRAT, IDQUALIFICATION, INDICEGRADE, NBENFANT, TEMPORAIRE)
VALUES('PRS000139', SYSDATE, '139', '890123003509', 'SIT02', 'BLOC 33/H CU MANINDAY TOLIARA', TO_DATE('18/05/2013','DD/MM/YYYY'), TO_DATE('18/05/2013','DD/MM/YYYY'),
       'PAF010316', NULL, '0003', 'CP0000011', 'TYP0000002', 'QUAL0011', 1910, 1, -1);

INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, SITUATION_MATRIMONIAL, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT,
 IDFONCTION, TELEPHONE, MODE_PAIEMENT, IDCATEGORIE_PAIE, TYPECONTRAT, IDQUALIFICATION, INDICEGRADE, NBENFANT, TEMPORAIRE)
VALUES('PRS000163', SYSDATE, '163', '893108002996', 'SIT02', 'MAROVATO ABATTOIR MAJUNGA', TO_DATE('01/04/2020','DD/MM/YYYY'), TO_DATE('01/04/2020','DD/MM/YYYY'),
       'PAF020317', NULL, '0003', 'CP0000011', 'TYP0000002', 'QUAL0023', 2208, 2, -1);

INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, SITUATION_MATRIMONIAL, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT,
 IDFONCTION, TELEPHONE, MODE_PAIEMENT, IDCATEGORIE_PAIE, TYPECONTRAT, IDQUALIFICATION, INDICEGRADE, NBENFANT, TEMPORAIRE)
VALUES('PRS000165', SYSDATE, '165', '830106005468', 'SIT02', 'LOT 266 GRAND PAVOIS COM URB DIEGO SUAREZ', TO_DATE('15/12/2014','DD/MM/YYYY'), TO_DATE('15/12/2014','DD/MM/YYYY'),
       'PAF020316', NULL, '0003', 'CP0000011', 'TYP0000002', 'QUAL0023', 2460, 0, -1);

INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, SITUATION_MATRIMONIAL, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT,
 IDFONCTION, TELEPHONE, MODE_PAIEMENT, IDCATEGORIE_PAIE, TYPECONTRAT, IDQUALIFICATION, INDICEGRADE, NBENFANT, TEMPORAIRE)
VALUES('PRS000173', SYSDATE, '173', '921114001129', 'SIT02', 'LOT 19 C 131 MAHAZOARIVO SUD ANTSIRABE', TO_DATE('02/05/2015','DD/MM/YYYY'), TO_DATE('02/05/2015','DD/MM/YYYY'),
       'PAF010316', NULL, '0003', 'CP0000011', 'TYP0000002', 'QUAL0011', 1910, 0, -1);

INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, SITUATION_MATRIMONIAL, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT,
 IDFONCTION, TELEPHONE, MODE_PAIEMENT, IDCATEGORIE_PAIE, TYPECONTRAT, IDQUALIFICATION, INDICEGRADE, NBENFANT, TEMPORAIRE)
VALUES('PRS000190', SYSDATE, '190', '921022003194', 'SIT02', 'NAHAMORA SUD', TO_DATE('01/02/2017','DD/MM/YYYY'), TO_DATE('01/02/2017','DD/MM/YYYY'),
       'PAF020316', NULL, '0003', 'CP0000011', 'TYP0000002', 'QUAL0023', 2208, 1, -1);

INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, SITUATION_MATRIMONIAL, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT,
 IDFONCTION, TELEPHONE, MODE_PAIEMENT, IDCATEGORIE_PAIE, TYPECONTRAT, IDQUALIFICATION, INDICEGRADE, NBENFANT, TEMPORAIRE)
VALUES('PRS000192', SYSDATE, '192', '881014003691', 'SIT02', '09 IC H 48 MAHAFALY AMBILOBE', TO_DATE('02/05/2017','DD/MM/YYYY'), TO_DATE('02/05/2017','DD/MM/YYYY'),
       'PAF010316', NULL, '0003', 'CP0000011', 'TYP0000002', 'QUAL0011', 1910, 1, -1);

INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, SITUATION_MATRIMONIAL, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT,
 IDFONCTION, TELEPHONE, MODE_PAIEMENT, IDCATEGORIE_PAIE, TYPECONTRAT, IDQUALIFICATION, INDICEGRADE, NBENFANT, TEMPORAIRE)
VALUES('PRS000193', SYSDATE, '193', '953214001062', 'SIT02', 'AMBAIBO AMBANJA', TO_DATE('01/12/2017','DD/MM/YYYY'), TO_DATE('01/12/2017','DD/MM/YYYY'),
       'PAF010316', NULL, '0003', 'CP0000011', 'TYP0000002', 'QUAL0011', 1910, 1, -1);

INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, SITUATION_MATRIMONIAL, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT,
 IDFONCTION, TELEPHONE, MODE_PAIEMENT, IDCATEGORIE_PAIE, TYPECONTRAT, IDQUALIFICATION, INDICEGRADE, NBENFANT, TEMPORAIRE)
VALUES('PRS000195', SYSDATE, '195', '890308006050', 'SIT02', 'NAMAHORA SUD', TO_DATE('01/04/2019','DD/MM/YYYY'), TO_DATE('01/04/2019','DD/MM/YYYY'),
       'PAF010316', NULL, '0003', 'CP0000011', 'TYP0000002', 'QUAL0011', 1910, 2, -1);

INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, SITUATION_MATRIMONIAL, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT,
 IDFONCTION, TELEPHONE, MODE_PAIEMENT, IDCATEGORIE_PAIE, TYPECONTRAT, IDQUALIFICATION, INDICEGRADE, NBENFANT, TEMPORAIRE)
VALUES('PRS000196', SYSDATE, '196', '932628002876', 'SIT02', 'LOT 0202E 0259 ANTANIMASAJA MAHAJANGA', TO_DATE('27/06/2019','DD/MM/YYYY'), TO_DATE('27/06/2019','DD/MM/YYYY'),
       'PAF020318', NULL, '0003', 'CP0000011', 'TYP0000002', 'QUAL0023', 2208, 1, -1);

INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, SITUATION_MATRIMONIAL, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT,
 IDFONCTION, TELEPHONE, MODE_PAIEMENT, IDCATEGORIE_PAIE, TYPECONTRAT, IDQUALIFICATION, INDICEGRADE, NBENFANT, TEMPORAIRE)
VALUES('PRS000198', SYSDATE, '198', '508072011763', 'SIT02', '1120 B 168 MAHAZOARIVO MIARAMASOANDRO', TO_DATE('05/01/2022','DD/MM/YYYY'), TO_DATE('05/01/2022','DD/MM/YYYY'),
       'PAF020316', NULL, '0003', 'CP0000011', 'TYP0000002', 'QUAL0023', 2208, 1, -1);

INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, SITUATION_MATRIMONIAL, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT,
 IDFONCTION, TELEPHONE, MODE_PAIEMENT, IDCATEGORIE_PAIE, TYPECONTRAT, IDQUALIFICATION, INDICEGRADE, NBENFANT, TEMPORAIRE)
VALUES('PRS000209', SYSDATE, '209', '210011034203', 'SIT01', 'LOT 064 CARREAU III', TO_DATE('08/02/2024','DD/MM/YYYY'), TO_DATE('08/02/2024','DD/MM/YYYY'),
       'PAF010316', NULL, '0002', 'CP0000011', 'TYP0000002', 'QUAL0004', 1891, 0, -1);

INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, SITUATION_MATRIMONIAL, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT,
 IDFONCTION, TELEPHONE, MODE_PAIEMENT, IDCATEGORIE_PAIE, TYPECONTRAT, IDQUALIFICATION, INDICEGRADE, NBENFANT, TEMPORAIRE)
VALUES('PRS000211', SYSDATE, '211', '990808004761', 'SIT01', 'ANTANISOA AMBOHIMANJAKA', TO_DATE('30/05/2024','DD/MM/YYYY'), TO_DATE('30/05/2024','DD/MM/YYYY'),
       'PAF010316', NULL, '0003', 'CP0000011', 'TYP0000002', 'QUAL0032', 1733, 0, -1);

INSERT INTO PAIE_INFO_PERSONNEL
(ID, DATESAISIE, MATRICULE, NUMERO_CNAPS, SITUATION_MATRIMONIAL, ADRESSE_LIGNE1, DATEEMBAUCHE, DEBUTCONTRAT,
 IDFONCTION, TELEPHONE, MODE_PAIEMENT, IDCATEGORIE_PAIE, TYPECONTRAT, IDQUALIFICATION, INDICEGRADE, NBENFANT, TEMPORAIRE)
VALUES('PRS000212', SYSDATE, '212', '711992057435', 'SIT01', 'LOT 346 S V ANTSIRABE SAMBAVA', TO_DATE('28/04/2025','DD/MM/YYYY'), TO_DATE('28/04/2025','DD/MM/YYYY'),
       'PAF010316', NULL, '0002', 'CP0000011', 'TYP0000002', 'QUAL0032', 1733, 0, -1);



---- log personnel vacataire---
INSERT INTO LOG_PERSONNEL
(ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE)
VALUES('PRS000100', NULL, ' ', ' ', 'PRS000100', 'RAHOLIARISOA', 'TANTELY HARIMAMY ', TO_DATE('17/07/1975', 'DD/MM/YYYY'), '0', '116012005403', TO_DATE('17/07/1975', 'DD/MM/YYYY'), NULL, 'Malagasy', 'LOT 21 B 190 AVARATSENA AMBOHIMIANDRISOA ANTSIRABE', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL
(ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE)
VALUES('PRS000110', NULL, ' ', ' ', 'PRS000110', 'RAZAFY', 'ERIC PHILIBERT ', TO_DATE('15/12/1990', 'DD/MM/YYYY'), '1', '301071030060', TO_DATE('15/12/1990', 'DD/MM/YYYY'), NULL, 'Malagasy', 'LOT 319 P/LLE 21/73 TANAMBAO VERERIETOAMASINA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL
(ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE)
VALUES('PRS000119', NULL, ' ', ' ', 'PRS000119', 'RABIALISON', 'DAUDET CLOTAIRE ', TO_DATE('18/02/1986', 'DD/MM/YYYY'), '1', '205011011736', TO_DATE('18/02/1986', 'DD/MM/YYYY'), NULL, 'Malagasy', 'LOT BIS 420/IB/3611 TANAMBAO ZOARA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL
(ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE)
VALUES('PRS000138', NULL, ' ', ' ', 'PRS000138', 'DARINY', 'FANDIERA  ', TO_DATE('19/09/1986', 'DD/MM/YYYY'), '1', '501111014664', TO_DATE('19/09/1986', 'DD/MM/YYYY'), NULL, 'Malagasy', 'LOT  TANAMBAO MORAFENO EN FACE EXE SOMASOA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL
(ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE)
VALUES('PRS000139', NULL, ' ', ' ', 'PRS000139', 'RALAINIRINA', 'PATRICK JEAN AIME', TO_DATE('23/01/1984', 'DD/MM/YYYY'), '1', '201011014887', TO_DATE('23/01/1984', 'DD/MM/YYYY'), NULL, 'Malagasy', 'BLOC 33/H CU MANINDAY TOLIARA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL
(ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE)
VALUES('PRS000163', NULL, ' ', ' ', 'PRS000163', 'RAFANOMEZANJANAHARY', 'MARIE GEORGINA ', TO_DATE('08/11/1989', 'DD/MM/YYYY'), '0', '401012042720', TO_DATE('08/11/1989', 'DD/MM/YYYY'), NULL, 'Malagasy', 'MAROVATO ABATTOIR MAJUNGA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL
(ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE)
VALUES('PRS000165', NULL, ' ', ' ', 'PRS000165', 'RAFIDISON', 'RADONIAINA OLIVIER ', TO_DATE('06/01/1983', 'DD/MM/YYYY'), '1', '715011010581', TO_DATE('06/01/1983', 'DD/MM/YYYY'), NULL, 'Malagasy', 'LOT 266 GRAND PAVOIS COM URB DIEGO SUAREZ', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL
(ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE)
VALUES('PRS000173', NULL, ' ', ' ', 'PRS000173', 'TAHINJANAHARY', 'FIONONANA MARCELLIN ', TO_DATE('14/11/1992', 'DD/MM/YYYY'), '1', '108111023563', TO_DATE('14/11/1992', 'DD/MM/YYYY'), NULL, 'Malagasy', 'LOT 19 C 131 MAHAZOARIVO SUD ANTSIRABE', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL
(ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE)
VALUES('PRS000190', NULL, ' ', ' ', 'PRS000190', 'LANJA', 'NOMENJANAHARY JUSTIN ', TO_DATE('22/10/1992', 'DD/MM/YYYY'), '1', '508991025840', TO_DATE('22/10/1992', 'DD/MM/YYYY'), NULL, 'Malagasy', 'NAHAMORA SUD', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL
(ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE)
VALUES('PRS000192', NULL, ' ', ' ', 'PRS000192', 'FARANIRIANA', 'ANDRE  ', TO_DATE('14/10/1988', 'DD/MM/YYYY'), '1', '108091008573', TO_DATE('14/10/1988', 'DD/MM/YYYY'), NULL, 'Malagasy', '09 IC H 48 MAHAFALY AMBILOBE', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL
(ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE)
VALUES('PRS000193', NULL, ' ', ' ', 'PRS000193', 'AMIDA', '-  ', TO_DATE('14/12/1995', 'DD/MM/YYYY'), '0', '719012028856', TO_DATE('14/12/1995', 'DD/MM/YYYY'), NULL, 'Malagasy', 'AMBAIBO AMBANJA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL
(ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE)
VALUES('PRS000195', NULL, ' ', ' ', 'PRS000195', 'RAKOTONIRINA', 'ROGER JUSTIN ', TO_DATE('08/03/1989', 'DD/MM/YYYY'), '1', '508991018735', TO_DATE('08/03/1989', 'DD/MM/YYYY'), NULL, 'Malagasy', 'NAMAHORA SUD', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL
(ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE)
VALUES('PRS000196', NULL, ' ', ' ', 'PRS000196', 'ANDRIAMIALY', 'DIAMONDRA HANITRINIALA ', TO_DATE('28/06/1993', 'DD/MM/YYYY'), '0', '401012045936', TO_DATE('28/06/1993', 'DD/MM/YYYY'), NULL, 'Malagasy', 'LOT 0202E 0259 ANTANIMASAJA MAHAJANGA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL
(ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE)
VALUES('PRS000198', NULL, ' ', ' ', 'PRS000198', 'SOLOHARIMANANA', 'AINA SEHENO ', TO_DATE('20/01/2000', 'DD/MM/YYYY'), '0', '508072011763', TO_DATE('20/01/2000', 'DD/MM/YYYY'), NULL, 'Malagasy', '1120 B 168 MAHAZOARIVO MIARAMASOANDRO', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL
(ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE)
VALUES('PRS000209', NULL, ' ', ' ', 'PRS000209', 'RANDRIAMAMPIONINA', 'FRANCIS RAVONONA', TO_DATE('16/09/1993', 'DD/MM/YYYY'), '1', '210011034203', TO_DATE('16/09/1993', 'DD/MM/YYYY'), NULL, 'Malagasy', 'LOT 064 CARREAU III', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL
(ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE)
VALUES('PRS000211', NULL, ' ', ' ', 'PRS000211', 'HERINIAINA ', 'MAMITIANA JEAN DONNE', TO_DATE('08/08/1999', 'DD/MM/YYYY'), '1', '116111021374', TO_DATE('08/08/1999', 'DD/MM/YYYY'), NULL, 'Malagasy', 'ANTANISOA AMBOHIMANJAKA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);
INSERT INTO LOG_PERSONNEL
(ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, REFUSER, IDSUP, IDHIERARCHIE, CHEMINIMAGE)
VALUES('PRS000212', NULL, ' ', ' ', 'PRS000212', 'AVIZARA', 'JEANNIELA', TO_DATE('22/04/1997', 'DD/MM/YYYY'), '0', '711992057435', TO_DATE('22/04/1997', 'DD/MM/YYYY'), NULL, 'Malagasy', 'LOT 346 S V ANTSIRABE SAMBAVA', NULL, NULL, 'DIR00001', 'SERV1', 1060, NULL, NULL, NULL);

UPDATE PAIE_INFO_PERSONNEL SET ETAT=11;



delete from CATEGORIE_QUALIFICATION;

ALTER TABLE CATEGORIE_QUALIFICATION ADD INDICE NUMBER(30, 3);
-- Personnel Tit tsy HC sy HS INterm ny qualification any
INSERT INTO CATEGORIE_QUALIFICATION (ID, IDCATEGORIE, IDQUALIFICATION, REMARQUE, ETAT, MONTANT, DATE_DEBUT, DATE_FIN, AVENANT, IDPOSTE, INDICE) VALUES ('CATQLTIT0001', 'CP0000010', 'QUAL0003', '-', 11, 305200, null, null, null, 'EX000041', 1873);
INSERT INTO CATEGORIE_QUALIFICATION (ID, IDCATEGORIE, IDQUALIFICATION, REMARQUE, ETAT, MONTANT, DATE_DEBUT, DATE_FIN, AVENANT, IDPOSTE, INDICE) VALUES ('CATQLTIT0004', 'CP0000010', 'QUAL0017', '-', 11, 330000, null, null, null, 'EX000041', 2025);
INSERT INTO CATEGORIE_QUALIFICATION (ID, IDCATEGORIE, IDQUALIFICATION, REMARQUE, ETAT, MONTANT, DATE_DEBUT, DATE_FIN, AVENANT, IDPOSTE, INDICE) VALUES ('CATQLTIT0005', 'CP0000010', 'QUAL0023', '-', 11, 401000, null, null, null, 'EX000041', 2460);
INSERT INTO CATEGORIE_QUALIFICATION (ID, IDCATEGORIE, IDQUALIFICATION, REMARQUE, ETAT, MONTANT, DATE_DEBUT, DATE_FIN, AVENANT, IDPOSTE, INDICE) VALUES ('CATQLTIT0006', 'CP0000010', 'QUAL0026', '-', 11, 470500, null, null, null, 'EX000041', 2888);
INSERT INTO CATEGORIE_QUALIFICATION (ID, IDCATEGORIE, IDQUALIFICATION, REMARQUE, ETAT, MONTANT, DATE_DEBUT, DATE_FIN, AVENANT, IDPOSTE, INDICE) VALUES ('CATQLTIT0007', 'CP0000010', 'QUAL0022', '-', 11, 378700, null, null, null, 'EX000041', 2324);
INSERT INTO CATEGORIE_QUALIFICATION (ID, IDCATEGORIE, IDQUALIFICATION, REMARQUE, ETAT, MONTANT, DATE_DEBUT, DATE_FIN, AVENANT, IDPOSTE, INDICE) VALUES ('CATQLTIT0008', 'CP0000010', 'QUAL0013', '-', 11, 315700, null, null, null, 'EX000041', 1938);
INSERT INTO CATEGORIE_QUALIFICATION (ID, IDCATEGORIE, IDQUALIFICATION, REMARQUE, ETAT, MONTANT, DATE_DEBUT, DATE_FIN, AVENANT, IDPOSTE, INDICE) VALUES ('CATQLTIT0009', 'CP0000010', 'QUAL0009', '-', 11, 300700, null, null, null, 'EX000041', 1845);
INSERT INTO CATEGORIE_QUALIFICATION (ID, IDCATEGORIE, IDQUALIFICATION, REMARQUE, ETAT, MONTANT, DATE_DEBUT, DATE_FIN, AVENANT, IDPOSTE, INDICE) VALUES ('CATQLTIT0010', 'CP0000010', 'QUAL0010', '-', 11, 309700, null, null, null, 'EX000041', 1901);
INSERT INTO CATEGORIE_QUALIFICATION (ID, IDCATEGORIE, IDQUALIFICATION, REMARQUE, ETAT, MONTANT, DATE_DEBUT, DATE_FIN, AVENANT, IDPOSTE, INDICE) VALUES ('CATQLTIT0011', 'CP0000010', 'QUAL0024', '-', 11, 409600, null, null, null, 'EX000041', 2514);
INSERT INTO CATEGORIE_QUALIFICATION (ID, IDCATEGORIE, IDQUALIFICATION, REMARQUE, ETAT, MONTANT, DATE_DEBUT, DATE_FIN, AVENANT, IDPOSTE, INDICE) VALUES ('CATQLTIT0012', 'CP0000010', 'QUAL0040', '-', 11, 750000, null, null, null, 'EX000041', 4948);
INSERT INTO CATEGORIE_QUALIFICATION (ID, IDCATEGORIE, IDQUALIFICATION, REMARQUE, ETAT, MONTANT, DATE_DEBUT, DATE_FIN, AVENANT, IDPOSTE, INDICE) VALUES ('CATQLTIT0013', 'CP0000010', 'QUAL0020', '-', 11, 353600, null, null, null, 'EX000041', 2170);
INSERT INTO CATEGORIE_QUALIFICATION (ID, IDCATEGORIE, IDQUALIFICATION, REMARQUE, ETAT, MONTANT, DATE_DEBUT, DATE_FIN, AVENANT, IDPOSTE, INDICE) VALUES ('CATQLTIT0014', 'CP0000010', 'QUAL0019', '-', 11, 339200, null, null, null, 'EX000041', 2081);
INSERT INTO CATEGORIE_QUALIFICATION (ID, IDCATEGORIE, IDQUALIFICATION, REMARQUE, ETAT, MONTANT, DATE_DEBUT, DATE_FIN, AVENANT, IDPOSTE, INDICE) VALUES ('CATQLTIT0015', 'CP0000010', 'QUAL0021', '-', 11, 355600, null, null, null, 'EX000041', 2182);
INSERT INTO CATEGORIE_QUALIFICATION (ID, IDCATEGORIE, IDQUALIFICATION, REMARQUE, ETAT, MONTANT, DATE_DEBUT, DATE_FIN, AVENANT, IDPOSTE, INDICE) VALUES ('CATQLTIT0016', 'CP0000010', 'QUAL0012', '-', 11, 314200, null, null, null, 'EX000041', 1928);
INSERT INTO CATEGORIE_QUALIFICATION (ID, IDCATEGORIE, IDQUALIFICATION, REMARQUE, ETAT, MONTANT, DATE_DEBUT, DATE_FIN, AVENANT, IDPOSTE, INDICE) VALUES ('CATQLTIT0017', 'CP0000010', 'QUAL0039', '-', 11, 500000, null, null, null, 'EX000041', 3298);
INSERT INTO CATEGORIE_QUALIFICATION (ID, IDCATEGORIE, IDQUALIFICATION, REMARQUE, ETAT, MONTANT, DATE_DEBUT, DATE_FIN, AVENANT, IDPOSTE, INDICE) VALUES ('CATQLTIT0018', 'CP0000010', 'QUAL0011', '-', 11, 311200, null, null, null, 'EX000041', 1910);
INSERT INTO CATEGORIE_QUALIFICATION (ID, IDCATEGORIE, IDQUALIFICATION, REMARQUE, ETAT, MONTANT, DATE_DEBUT, DATE_FIN, AVENANT, IDPOSTE, INDICE) VALUES ('CATQLTIT0019', 'CP0000010', 'QUAL0028', '-', 11, 317100, null, null, null, 'EX000041', 1946);
INSERT INTO CATEGORIE_QUALIFICATION (ID, IDCATEGORIE, IDQUALIFICATION, REMARQUE, ETAT, MONTANT, DATE_DEBUT, DATE_FIN, AVENANT, IDPOSTE, INDICE) VALUES ('CATQLTIT0020', 'CP0000010', 'QUAL0016', '-', 11, 327700, null, null, null, 'EX000041', 2011);
INSERT INTO CATEGORIE_QUALIFICATION (ID, IDCATEGORIE, IDQUALIFICATION, REMARQUE, ETAT, MONTANT, DATE_DEBUT, DATE_FIN, AVENANT, IDPOSTE, INDICE) VALUES ('CATQLTIT0021', 'CP0000010', 'QUAL0018', '-', 11, 332200, null, null, null, 'EX000041', 2039);
INSERT INTO CATEGORIE_QUALIFICATION (ID, IDCATEGORIE, IDQUALIFICATION, REMARQUE, ETAT, MONTANT, DATE_DEBUT, DATE_FIN, AVENANT, IDPOSTE, INDICE) VALUES ('CATQLTIT0022', 'CP0000010', 'QUAL0007', '-', 11, 300000, null, null, null, 'EX000041', 1841);
INSERT INTO CATEGORIE_QUALIFICATION (ID, IDCATEGORIE, IDQUALIFICATION, REMARQUE, ETAT, MONTANT, DATE_DEBUT, DATE_FIN, AVENANT, IDPOSTE, INDICE) VALUES ('CATQLTIT0023', 'CP0000010', 'QUAL0015', '-', 11, 323100, null, null, null, 'EX000041', 1983);
INSERT INTO CATEGORIE_QUALIFICATION (ID, IDCATEGORIE, IDQUALIFICATION, REMARQUE, ETAT, MONTANT, DATE_DEBUT, DATE_FIN, AVENANT, IDPOSTE, INDICE) VALUES ('CATQLTIT0024', 'CP0000010', 'QUAL0001', '-', 11, 302300, null, null, null, 'EX000041', 1855);
INSERT INTO CATEGORIE_QUALIFICATION (ID, IDCATEGORIE, IDQUALIFICATION, REMARQUE, ETAT, MONTANT, DATE_DEBUT, DATE_FIN, AVENANT, IDPOSTE, INDICE) VALUES ('CATQLTIT0025', 'CP0000010', 'QUAL0014', '-', 11, 317100, null, null, null, 'EX000041', 1946);

-- categorie cal hoan'ny HC intern
INSERT INTO CATEGORIE_QUALIFICATION (ID, IDCATEGORIE, IDQUALIFICATION, REMARQUE, ETAT, MONTANT, DATE_DEBUT, DATE_FIN, AVENANT, IDPOSTE, INDICE) VALUES ('CATQLTIT0026', 'CP0000010', 'QUAL0037', 'PRS000653', 1, 800000, null, null, null, 'EX000041', 3958);

INSERT INTO CATEGORIE_QUALIFICATION (ID, IDCATEGORIE, IDQUALIFICATION, REMARQUE, ETAT, MONTANT, DATE_DEBUT, DATE_FIN, AVENANT, IDPOSTE, INDICE) VALUES ('CATQLTIT0027', 'CP0000010', 'QUAL0037', 'PRS000884', 1, 1000000, null, null, null, 'EX000041', 0);

INSERT INTO CATEGORIE_QUALIFICATION (ID, IDCATEGORIE, IDQUALIFICATION, REMARQUE, ETAT, MONTANT, DATE_DEBUT, DATE_FIN, AVENANT, IDPOSTE, INDICE) VALUES ('CATQLTIT0028', 'CP0000010', 'QUAL0037', 'PRS000893', 1, 1000000, null, null, null, 'EX000041', 0);

INSERT INTO CATEGORIE_QUALIFICATION (ID, IDCATEGORIE, IDQUALIFICATION, REMARQUE, ETAT, MONTANT, DATE_DEBUT, DATE_FIN, AVENANT, IDPOSTE, INDICE) VALUES ('CATQLTIT0029', 'CP0000010', 'QUAL0037', 'PRS000885', 1, 1000000, null, null, null, 'EX000041', 0);

INSERT INTO CATEGORIE_QUALIFICATION (ID, IDCATEGORIE, IDQUALIFICATION, REMARQUE, ETAT, MONTANT, DATE_DEBUT, DATE_FIN, AVENANT, IDPOSTE, INDICE) VALUES ('CATQLTIT0030', 'CP0000010', 'QUAL0037', 'PRS000910', 1, 1000000, null, null, null, 'EX000041', 0);

INSERT INTO CATEGORIE_QUALIFICATION (ID, IDCATEGORIE, IDQUALIFICATION, REMARQUE, ETAT, MONTANT, DATE_DEBUT, DATE_FIN, AVENANT, IDPOSTE, INDICE) VALUES ('CATQLTIT0031', 'CP0000010', 'QUAL0037', 'PRS000981', 1, 1000000, null, null, null, 'EX000041', 0);




UPDATE CATEGORIE_QUALIFICATION SET ETAT=1;
UPDATE CATEGORIE_QUALIFICATION SET REMARQUE='';


-- Categ qualification ho an'ny HC
INSERT INTO CATEGORIE_QUALIFICATION (ID, IDCATEGORIE, IDQUALIFICATION, REMARQUE, ETAT, MONTANT, DATE_DEBUT, DATE_FIN, AVENANT, IDPOSTE, INDICE) VALUES ('CATQLTIT0032', 'CP0000010', 'QUAL0038', 'PRS000665', 1, 1500000, null, null, null, 'EX000041', 0);

INSERT INTO CATEGORIE_QUALIFICATION (ID, IDCATEGORIE, IDQUALIFICATION, REMARQUE, ETAT, MONTANT, DATE_DEBUT, DATE_FIN, AVENANT, IDPOSTE, INDICE) VALUES ('CATQLTIT0033', 'CP0000010', 'QUAL0038', 'PRS000703', 1, 1500000, null, null, null, 'EX000041', 0);

INSERT INTO CATEGORIE_QUALIFICATION (ID, IDCATEGORIE, IDQUALIFICATION, REMARQUE, ETAT, MONTANT, DATE_DEBUT, DATE_FIN, AVENANT, IDPOSTE, INDICE) VALUES ('CATQLTIT0034', 'CP0000010', 'QUAL0038', 'PRS000820', 1, 1200000, null, null, null, 'EX000041', 0);

INSERT INTO CATEGORIE_QUALIFICATION (ID, IDCATEGORIE, IDQUALIFICATION, REMARQUE, ETAT, MONTANT, DATE_DEBUT, DATE_FIN, AVENANT, IDPOSTE, INDICE) VALUES ('CATQLTIT0035', 'CP0000010', 'QUAL0038', 'PRS001061', 1, 1200000, null, null, null, 'EX000041', 0);

INSERT INTO CATEGORIE_QUALIFICATION (ID, IDCATEGORIE, IDQUALIFICATION, REMARQUE, ETAT, MONTANT, DATE_DEBUT, DATE_FIN, AVENANT, IDPOSTE, INDICE) VALUES ('CATQLTIT0036', 'CP0000010', 'QUAL0038', 'PRS001063', 1, 1200000, null, null, null, 'EX000041', 0);

INSERT INTO CATEGORIE_QUALIFICATION (ID, IDCATEGORIE, IDQUALIFICATION, REMARQUE, ETAT, MONTANT, DATE_DEBUT, DATE_FIN, AVENANT, IDPOSTE, INDICE) VALUES ('CATQLTIT0037', 'CP0000010', 'QUAL0038', 'PRS001090', 1, 800000, null, null, null, 'EX000041', 0);



-- rectif donnees temporaire
UPDATE PAIE_INFO_PERSONNEL SET IDQUALIFICATION='QUAL0005' WHERE IDCATEGORIE_PAIE='CP0000011';
-- Categ Qual hoan'ny temporaire: par defaut M1 daholo zareo
INSERT INTO CATEGORIE_QUALIFICATION (ID, IDCATEGORIE, IDQUALIFICATION, REMARQUE, ETAT, MONTANT, DATE_DEBUT, DATE_FIN, AVENANT, IDPOSTE, INDICE) VALUES ('CATQLTIT0038', 'CP0000011', 'QUAL0005', '', 1, 282400, null, null, null, 'EX000041', 0);
UPDATE CATEGORIE_QUALIFICATION SET INDICE='1863' WHERE ID='CATQLTIT0038';



-- ajout categ qualif pour les vacataires
-- INSERT INTO CATEGORIE_PAIE (ID, VAL, DESCE, MONTANT, REMARQUE, DROIT_HEURE_SUP, ESSAIE) VALUES ('CP0000012', 'VACATAIRE', 'VACATAIRE', 0.00, 'aucun', 'o', 3.00);

update PAIE_INFO_PERSONNEL SET IDCATEGORIE_PAIE='CP0000012' WHERE ID IN('PRS000100', 'PRS000110', 'PRS000119', 'PRS000138',
                                                                        'PRS000139', 'PRS000163', 'PRS000165', 'PRS000173', 'PRS000190',
                                                                        'PRS000192', 'PRS000193', 'PRS000195', 'PRS000196', 'PRS000198',
                                                                        'PRS000209', 'PRS000211', 'PRS000212');


INSERT INTO CATEGORIE_QUALIFICATION (ID, IDCATEGORIE, IDQUALIFICATION, REMARQUE, ETAT, MONTANT, DATE_DEBUT, DATE_FIN, AVENANT, IDPOSTE, INDICE) VALUES ('CATQLVAC0002', 'CP0000012', 'QUAL0011', 'PRS000100', 1, 289500, null, null, null, 'EX000041', 1910);
INSERT INTO CATEGORIE_QUALIFICATION (ID, IDCATEGORIE, IDQUALIFICATION, REMARQUE, ETAT, MONTANT, DATE_DEBUT, DATE_FIN, AVENANT, IDPOSTE, INDICE) VALUES ('CATQLVAC0003', 'CP0000012', 'QUAL0011', 'PRS000110', 1, 289500, null, null, null, 'EX000041', 1910);
INSERT INTO CATEGORIE_QUALIFICATION (ID, IDCATEGORIE, IDQUALIFICATION, REMARQUE, ETAT, MONTANT, DATE_DEBUT, DATE_FIN, AVENANT, IDPOSTE, INDICE) VALUES ('CATQLVAC0004', 'CP0000012', 'QUAL0023', 'PRS000119', 1, 372900, null, null, null, 'EX000041', 2460);
INSERT INTO CATEGORIE_QUALIFICATION (ID, IDCATEGORIE, IDQUALIFICATION, REMARQUE, ETAT, MONTANT, DATE_DEBUT, DATE_FIN, AVENANT, IDPOSTE, INDICE) VALUES ('CATQLVAC0005', 'CP0000012', 'QUAL0023', 'PRS000138', 1, 372900, null, null, null, 'EX000041', 2460);
INSERT INTO CATEGORIE_QUALIFICATION (ID, IDCATEGORIE, IDQUALIFICATION, REMARQUE, ETAT, MONTANT, DATE_DEBUT, DATE_FIN, AVENANT, IDPOSTE, INDICE) VALUES ('CATQLVAC0006', 'CP0000012', 'QUAL0011', 'PRS000139', 1, 289500, null, null, null, 'EX000041', 1910);
INSERT INTO CATEGORIE_QUALIFICATION (ID, IDCATEGORIE, IDQUALIFICATION, REMARQUE, ETAT, MONTANT, DATE_DEBUT, DATE_FIN, AVENANT, IDPOSTE, INDICE) VALUES ('CATQLVAC0007', 'CP0000012', 'QUAL0023', 'PRS000163', 1, 334800, null, null, null, 'EX000041', 2208);
INSERT INTO CATEGORIE_QUALIFICATION (ID, IDCATEGORIE, IDQUALIFICATION, REMARQUE, ETAT, MONTANT, DATE_DEBUT, DATE_FIN, AVENANT, IDPOSTE, INDICE) VALUES ('CATQLVAC0008', 'CP0000012', 'QUAL0023', 'PRS000165', 1, 372900, null, null, null, 'EX000041', 2460);
INSERT INTO CATEGORIE_QUALIFICATION (ID, IDCATEGORIE, IDQUALIFICATION, REMARQUE, ETAT, MONTANT, DATE_DEBUT, DATE_FIN, AVENANT, IDPOSTE, INDICE) VALUES ('CATQLVAC0009', 'CP0000012', 'QUAL0011', 'PRS000173', 1, 289500, null, null, null, 'EX000041', 1910);
INSERT INTO CATEGORIE_QUALIFICATION (ID, IDCATEGORIE, IDQUALIFICATION, REMARQUE, ETAT, MONTANT, DATE_DEBUT, DATE_FIN, AVENANT, IDPOSTE, INDICE) VALUES ('CATQLVAC0010', 'CP0000012', 'QUAL0023', 'PRS000190', 1, 334800, null, null, null, 'EX000041', 2208);
INSERT INTO CATEGORIE_QUALIFICATION (ID, IDCATEGORIE, IDQUALIFICATION, REMARQUE, ETAT, MONTANT, DATE_DEBUT, DATE_FIN, AVENANT, IDPOSTE, INDICE) VALUES ('CATQLVAC0011', 'CP0000012', 'QUAL0011', 'PRS000192', 1, 289500, null, null, null, 'EX000041', 1910);
INSERT INTO CATEGORIE_QUALIFICATION (ID, IDCATEGORIE, IDQUALIFICATION, REMARQUE, ETAT, MONTANT, DATE_DEBUT, DATE_FIN, AVENANT, IDPOSTE, INDICE) VALUES ('CATQLVAC0012', 'CP0000012', 'QUAL0011', 'PRS000193', 1, 289500, null, null, null, 'EX000041', 1910);
INSERT INTO CATEGORIE_QUALIFICATION (ID, IDCATEGORIE, IDQUALIFICATION, REMARQUE, ETAT, MONTANT, DATE_DEBUT, DATE_FIN, AVENANT, IDPOSTE, INDICE) VALUES ('CATQLVAC0013', 'CP0000012', 'QUAL0011', 'PRS000195', 1, 289500, null, null, null, 'EX000041', 1910);
INSERT INTO CATEGORIE_QUALIFICATION (ID, IDCATEGORIE, IDQUALIFICATION, REMARQUE, ETAT, MONTANT, DATE_DEBUT, DATE_FIN, AVENANT, IDPOSTE, INDICE) VALUES ('CATQLVAC0014', 'CP0000012', 'QUAL0023', 'PRS000196', 1, 334800, null, null, null, 'EX000041', 2208);
INSERT INTO CATEGORIE_QUALIFICATION (ID, IDCATEGORIE, IDQUALIFICATION, REMARQUE, ETAT, MONTANT, DATE_DEBUT, DATE_FIN, AVENANT, IDPOSTE, INDICE) VALUES ('CATQLVAC0015', 'CP0000012', 'QUAL0023', 'PRS000198', 1, 334800, null, null, null, 'EX000041', 2208);
INSERT INTO CATEGORIE_QUALIFICATION (ID, IDCATEGORIE, IDQUALIFICATION, REMARQUE, ETAT, MONTANT, DATE_DEBUT, DATE_FIN, AVENANT, IDPOSTE, INDICE) VALUES ('CATQLVAC0016', 'CP0000012', 'QUAL0004', 'PRS000209', 1, 286700, null, null, null, 'EX000041', 1891);
INSERT INTO CATEGORIE_QUALIFICATION (ID, IDCATEGORIE, IDQUALIFICATION, REMARQUE, ETAT, MONTANT, DATE_DEBUT, DATE_FIN, AVENANT, IDPOSTE, INDICE) VALUES ('CATQLVAC0017', 'CP0000012', 'QUAL0032', 'PRS000211', 1, 262700, null, null, null, 'EX000041', 1733);
INSERT INTO CATEGORIE_QUALIFICATION (ID, IDCATEGORIE, IDQUALIFICATION, REMARQUE, ETAT, MONTANT, DATE_DEBUT, DATE_FIN, AVENANT, IDPOSTE, INDICE) VALUES ('CATQLVAC0018', 'CP0000012', 'QUAL0032', 'PRS000212', 1, 262700, null, null, null, 'EX000041', 1733);

