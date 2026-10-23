update MENUDYNAMIQUE set ICONE = 'add' where LIBELLE like 'Saisie%';
update MENUDYNAMIQUE set ICONE = 'list_alt' where LIBELLE like 'Liste%';
update MENUDYNAMIQUE set ICONE = 'sticky_note_2' where LIBELLE not in ( select LIBELLE from VANIALA1311.MENUDYNAMIQUE where LIBELLE like 'Liste%' or LIBELLE like'Saisie%');

