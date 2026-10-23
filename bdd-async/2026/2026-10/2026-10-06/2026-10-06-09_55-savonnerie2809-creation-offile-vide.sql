-- Edouardo

create view OFFILLE_VIDE as
    select
        o.*,
        '' as idUniteLib
    from OFFILLE o;
 
