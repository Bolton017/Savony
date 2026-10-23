
create view ECRITURE_IMPOT as
select se.*,ce.daty as datymere, cc.CODEIMPOT from COMPTA_SOUS_ECRITURE se join COMPTA_ECRITURE ce on ce.id=se.IDMERE join COMPTA_COMPTE cc on cc.COMPTE=se.COMPTE where cc.CODEIMPOT is not null and ce.ETAT=11;
