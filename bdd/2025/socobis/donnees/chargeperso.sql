UPDATE AS_INGREDIENTS SET UNITE = 'UNT00005', COMPOSE = 0 WHERE CATEGORIEINGREDIENT = 'CAT002';
UPDATE AS_INGREDIENTS SET LIBELLE = REPLACE(LIBELLE, 'Machiniste', 'Manoeuvre') WHERE LIBELLE LIKE '%Machiniste - M%';
UPDATE AS_INGREDIENTS SET LIBELLE = REPLACE(LIBELLE, 'Manoeuvre', 'Machiniste') WHERE LIBELLE LIKE '%Manoeuvre - O%';


UPDATE  AS_INGREDIENTS ai SET ai.REFPOST ='PST001'  WHERE ai.CATEGORIEINGREDIENT ='CAT002'
                                                      AND upper(ai.LIBELLE) LIKE '%MANOEUVRE%';

UPDATE  AS_INGREDIENTS ai SET ai.REFPOST ='EX000041'  WHERE ai.CATEGORIEINGREDIENT ='CAT002'
                                                        AND upper(ai.LIBELLE) LIKE '%MACHINISTE%';

UPDATE  AS_INGREDIENTS ai SET ai.REFQUALIFICATION ='QUAL0003'  WHERE ai.CATEGORIEINGREDIENT ='CAT002'
                                                                 AND ai.LIBELLE LIKE '%OS1-maxi%';

UPDATE  AS_INGREDIENTS ai SET ai.REFQUALIFICATION ='QUAL0004'  WHERE ai.CATEGORIEINGREDIENT ='CAT002'
                                                                 AND ai.LIBELLE LIKE '%OS2-mini%';


UPDATE  AS_INGREDIENTS ai SET ai.REFQUALIFICATION ='QUAL0005'  WHERE ai.CATEGORIEINGREDIENT ='CAT002'
                                                                 AND ai.LIBELLE LIKE '%M1-mini%';

UPDATE  AS_INGREDIENTS ai SET ai.REFQUALIFICATION ='QUAL0006'  WHERE ai.CATEGORIEINGREDIENT ='CAT002'
                                                                 AND ai.LIBELLE LIKE '%M1-maxi%';

UPDATE  AS_INGREDIENTS ai SET ai.REFQUALIFICATION ='QUAL0007'  WHERE ai.CATEGORIEINGREDIENT ='CAT002'
                                                                 AND ai.LIBELLE LIKE '%M2-mini%';

UPDATE  AS_INGREDIENTS ai SET ai.REFQUALIFICATION ='QUAL0008'  WHERE ai.CATEGORIEINGREDIENT ='CAT002'
                                                                 AND ai.LIBELLE LIKE '%M2-inter%';

UPDATE  AS_INGREDIENTS ai SET ai.REFQUALIFICATION ='QUAL0009'  WHERE ai.CATEGORIEINGREDIENT ='CAT002'
                                                                 AND ai.LIBELLE LIKE '%M2-maxi%';

UPDATE  AS_INGREDIENTS ai SET ai.REFQUALIFICATION ='QUAL0010'  WHERE ai.CATEGORIEINGREDIENT ='CAT002'
                                                                 AND ai.LIBELLE LIKE '%OS2-inter%';

UPDATE  AS_INGREDIENTS ai SET ai.REFQUALIFICATION ='QUAL0011'  WHERE ai.CATEGORIEINGREDIENT ='CAT002'
                                                                 AND ai.LIBELLE LIKE '%OS2-maxi%';

UPDATE  AS_INGREDIENTS ai SET ai.REFQUALIFICATION ='QUAL0012'  WHERE ai.CATEGORIEINGREDIENT ='CAT002'
                                                                 AND ai.LIBELLE LIKE '%OS3-mini%';

UPDATE  AS_INGREDIENTS ai SET ai.REFQUALIFICATION ='QUAL0013'  WHERE ai.CATEGORIEINGREDIENT ='CAT002'
                                                                 AND ai.LIBELLE LIKE '%OS3-interm%';

UPDATE  AS_INGREDIENTS ai SET ai.REFQUALIFICATION ='QUAL0014'  WHERE ai.CATEGORIEINGREDIENT ='CAT002'
                                                                 AND ai.LIBELLE LIKE '%OS3-maxi%';

UPDATE  AS_INGREDIENTS ai SET ai.REFQUALIFICATION ='QUAL0015'  WHERE ai.CATEGORIEINGREDIENT ='CAT002'
                                                                 AND ai.LIBELLE LIKE '%OP1A-mini%';

UPDATE  AS_INGREDIENTS ai SET ai.REFQUALIFICATION ='QUAL0016'  WHERE ai.CATEGORIEINGREDIENT ='CAT002'
                                                                 AND ai.LIBELLE LIKE '%OP1A-interm%';

UPDATE  AS_INGREDIENTS ai SET ai.REFQUALIFICATION ='QUAL0017'  WHERE ai.CATEGORIEINGREDIENT ='CAT002'
                                                                 AND ai.LIBELLE LIKE '%OP1A-maxi%';

UPDATE  AS_INGREDIENTS ai SET ai.REFQUALIFICATION ='QUAL0018'  WHERE ai.CATEGORIEINGREDIENT ='CAT002'
                                                                 AND ai.LIBELLE LIKE '%OP1B-mini%';

UPDATE  AS_INGREDIENTS ai SET ai.REFQUALIFICATION ='QUAL0019'  WHERE ai.CATEGORIEINGREDIENT ='CAT002'
                                                                 AND ai.LIBELLE LIKE '%OP1B-interm%';

UPDATE  AS_INGREDIENTS ai SET ai.REFQUALIFICATION ='QUAL0020'  WHERE ai.CATEGORIEINGREDIENT ='CAT002'
                                                                 AND ai.LIBELLE LIKE '%OP1B-maxi%';

UPDATE  AS_INGREDIENTS ai SET ai.REFQUALIFICATION ='QUAL0021'  WHERE ai.CATEGORIEINGREDIENT ='CAT002'
                                                                 AND ai.LIBELLE LIKE '%OP2A-mini%';

UPDATE  AS_INGREDIENTS ai SET ai.REFQUALIFICATION ='QUAL0022'  WHERE ai.CATEGORIEINGREDIENT ='CAT002'
                                                                 AND ai.LIBELLE LIKE '%OP2A-interm%';


UPDATE  AS_INGREDIENTS ai SET ai.REFQUALIFICATION ='QUAL0023'  WHERE ai.CATEGORIEINGREDIENT ='CAT002'
                                                                 AND ai.LIBELLE LIKE '%OP2A-maxi%';

UPDATE  AS_INGREDIENTS ai SET ai.REFQUALIFICATION ='QUAL0024'  WHERE ai.CATEGORIEINGREDIENT ='CAT002'
                                                                 AND ai.LIBELLE LIKE '%OP2B-mini%';

UPDATE  AS_INGREDIENTS ai SET ai.REFQUALIFICATION ='QUAL0025'  WHERE ai.CATEGORIEINGREDIENT ='CAT002'
                                                                 AND ai.LIBELLE LIKE '%OP2B-interm%';

UPDATE  AS_INGREDIENTS ai SET ai.REFQUALIFICATION ='QUAL0026'  WHERE ai.CATEGORIEINGREDIENT ='CAT002'
                                                                 AND ai.LIBELLE LIKE '%OP2B-maxi%';

UPDATE  AS_INGREDIENTS ai SET ai.REFQUALIFICATION ='QUAL0027'  WHERE ai.CATEGORIEINGREDIENT ='CAT002'
                                                                 AND ai.LIBELLE LIKE '%OP3-mini%';

UPDATE  AS_INGREDIENTS ai SET ai.REFQUALIFICATION ='QUAL0028'  WHERE ai.CATEGORIEINGREDIENT ='CAT002'
                                                                 AND ai.LIBELLE LIKE '%OP3-maxi%';
