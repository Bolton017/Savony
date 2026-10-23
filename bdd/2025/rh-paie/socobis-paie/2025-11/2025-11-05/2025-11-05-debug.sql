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

