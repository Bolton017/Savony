create view HISTORIQUEAVECUSER as
select
    idhistorique,
    datehistorique,
    heure,
    SUBSTR(objet, INSTR(objet, '.', -1) + 1) as objet,
        action,
        u.LOGINUSER as idutilisateur,
        refobjet
        from HISTORIQUE h
        join UTILISATEUR u on u.REFUSER = h.IDUTILISATEUR
        order by h.DATEHISTORIQUE desc, h.heure desc;