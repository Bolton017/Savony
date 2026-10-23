-- SOCOBISPAIE2111.PAIE_PERS_ELTPAIE_LIB2 source

CREATE OR REPLACE VIEW PAIE_PERS_ELTPAIE_LIB2 AS
SELECT
    ppe.id,
    pip2.matricule,
    pr.id as id_code_rubrique,
    pr.val AS code_rubrique,
    ppe.date_debut,
    ppe.date_fin,
    ppe.gain,
    ppe.retenue,
    ppe.remarque,
    pip.nom || ' ' || pip.prenom AS idpersonnel,
    ppe.etat,
    ppe.id_objet,
    ppe.iduser,
    ppe.moisregularisation,
    ppe.anneeregularisation,
    cq.idcategorielib || ' ' || cq.categorie_qualificationlib AS idcategorie_qualification,
    pf.desce AS idfonction,
    ppe.pourcentage
FROM paie_personnel_elementpaie ppe
         LEFT JOIN log_personnel pip ON TO_CHAR(pip.id) = TO_CHAR(ppe.idpersonnel)
         LEFT JOIN categorie_qualification_libc cq ON TO_CHAR(ppe.idcategorie_qualification) = TO_CHAR(cq.id)
         LEFT JOIN paie_fonction pf ON TO_CHAR(ppe.idfonction) = TO_CHAR(pf.id)
         LEFT JOIN paie_rubrique pr ON TO_CHAR(pr.id) = TO_CHAR(ppe.code_rubrique)
         JOIN paie_info_personnel pip2 ON TO_CHAR(pip.id) = TO_CHAR(pip2.id);


---

CREATE OR REPLACE VIEW PAIE_PERS_ELTPAIE_LIB_AV AS
SELECT * FROM PAIE_PERS_ELTPAIE_LIB2 pp WHERE pp.ID_CODE_RUBRIQUE = 'PRU0447';