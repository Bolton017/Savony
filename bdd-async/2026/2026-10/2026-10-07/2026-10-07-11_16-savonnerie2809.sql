--Dans la table fabrication 
--
--ajouter colonne 
--
--estUnProjet (1,0)
--
--lanceur (int) reference utilisateur

ALTER TABLE FABRICATION ADD estUnProjet NUMBER(1,0);

ALTER TABLE FABRICATION ADD lanceur NUMBER CONSTRAINT fab_lanceur_fk REFERENCES UTILISATEUR(REFUSER);