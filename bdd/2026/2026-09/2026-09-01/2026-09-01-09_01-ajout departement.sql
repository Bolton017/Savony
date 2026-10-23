alter table CATEGORIEINGREDIENT add iddepartement  VARCHAR2(50) REFERENCES DEPARTEMENT (ID);

create or replace view CATEGORIEINGREDIENTLIB_ACHT as
SELECT
    cat.id,
    cat.val,
    cat.desce,
    cat.iddepartement
FROM
    CATEGORIEINGREDIENT cat
WHERE cat.estachat=1;

alter table utilisateur add iddepartement  VARCHAR2(50) REFERENCES DEPARTEMENT (ID);

create or replace view v_utilisateurlib_withdepart as
select u."REFUSER",u."LOGINUSER",u."PWDUSER",u."NOMUSER",u."ADRUSER",u."TELUSER",u."IDROLE",r.DESCROLE,u.iddepartement,dp.val as departementlib from UTILISATEUR u
                                                                                                                                                         left join ROLES r on r.IDROLE=u.IDROLE
                                                                                                                                                         LEFT JOIN departement dp on dp.id = u.iddepartement;