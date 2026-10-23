create or replace view localisationLib as
select l.*, ctc.val as typecomptelib
from localisation l
         left join COMPTA_TYPE_COMPTE ctc on ctc.id = l.TYPECOMPTE;

