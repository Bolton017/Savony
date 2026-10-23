ALTER TABLE compta_compte
ADD (codeImpot VARCHAR2(50));

ALTER TABLE relever
ADD (datyDebut DATE);

ALTER TABLE relever
ADD (datyFin DATE);

ALTER TABLE releverdetail
ADD (solde NUMBER(15,2)); 


update menudynamique set rang = 5 where id = 'MENDYN1766386603290909';
insert into menudynamique (id,libelle,icone,href,rang,niveau,id_pere) values ('MENDYN0026122025','Manuel','list_alt','module.jsp?but=rapprochement/rib-async-manuel.jsp',4,3,'MENDYN1766386514657608');