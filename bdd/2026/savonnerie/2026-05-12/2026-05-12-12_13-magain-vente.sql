INSERT INTO POINT (ID, VAL, DESCE) VALUES ('PNTVNT001', 'Vente', 'Vente');

UPDATE magasin2 SET  IDPOINT = 'PNTVNT001',VAL = 'Magasin centrale', DESCE = 'Magasin centrale' where ID = 'PHARM005' ;

create view MAGASINVENTE as
select * from MAGASIN2 where IDPOINT = 'PNTVNT001';