create table LOT
(
    ID          VARCHAR2(255) not null primary key,
    DATY        DATE,
    IDPRODUIT   VARCHAR2(255) references AS_INGREDIENTS,
    IDEQUIPE    VARCHAR2(255),
    REMARQUE    VARCHAR2(255)
);

create sequence seqLot;

create function getSeqLot return NUMBER is retour NUMBER;
begin
select
    seqLot.nextval
into
    retour
from
    dual;
return retour;
end;
/