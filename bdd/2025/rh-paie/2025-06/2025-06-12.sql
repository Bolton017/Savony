-- ASYNCRH.PAIE_EDITION_ELTPAIE source

CREATE OR REPLACE VIEW ASYNCRH.PAIE_EDITION_ELTPAIE (ID, IDPERSONNEL, IDELEMENTPAIE, IDEDITION, MOIS, ANNEE, DROITS, RETENUES, DATEDEBUT, DATEFIN, REMARQUE, ELEMENT, CODE, RANG, RUBRIQUEDESCE, IMPOSABLE, RANGBULLETIN, AFFICHER, HEURENORMAL, HEURESUPNORMAL, HEURESUPNUIT, HEURESUPFERIE, HEURESUPWEEKEND, ABSENCE) AS
SELECT ed.id,
       ed.idpersonnel,
       ed.idelementpaie,
       ed.idedition,
       ed.mois,
       ed.annee,
       ed.gain AS droits,
       ed.retenue AS retenues,
       ed.datedebut,
       ed.datefin,
       ed.remarque,
       r.val AS element,
       r.code,
       r.rang,
       r.desce AS rubriquedesce,
       r.imposable,
       r.rangbulletin,
       r.afficher,
       p.HEURENORMAL,
       p.HEURESUPNORMAL,
       p.HEURESUPNUIT,
       p.HEURESUPFERIE,
       p.HEURESUPWEEKEND,
       p.ABSENCE
FROM paie_edition ed,
     paie_rubrique r,
     pointage p
WHERE ed.idelementpaie = r.id
  AND p.idpersonnel = ed.idpersonnel
  AND p.mois = ed.mois
  AND p.annee = ed.annee
  AND p.etat = 11;