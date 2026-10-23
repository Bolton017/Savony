CREATE OR REPLACE PROCEDURE REPORTSOLDE_RAN(EXO IN VARCHAR, IDUSER IN VARCHAR) AS
    idEcr VARCHAR2(50 BYTE);
    er varchar2(500);
    exo_num NUMBER;
BEGIN
    exo_num := TO_NUMBER(EXO);
    FOR sousecr IN (SELECT * FROM COMPTA_REPORT WHERE ANNEE = ''||EXO||'') LOOP
            idEcr := 'ECR'||getseqcomptaecriture();
            insert into compta_ecriture (ID,DATY,DATECOMPTABLE,EXERCICE,DESIGNATION,REMARQUE,ETAT,HORSEXERCICE,JOURNAL,OD,ORIGINE,CREDIT,DEBIT,IDUSER,PERIODE,TRIMESTRE,ANNEE,
                                         IDOBJET) values (idEcr, '01/01/'||(EXO+1), '01/01/'||(EXO+1), EXO + 1, 'R A N '||EXO, 'R A N '||EXO, 1,0, 'COMP000015', '-', 'MAN', sousecr.DEBIT, sousecr.CREDIT, IDUSER, (EXO + 1)||'01', 1,  (EXO + 1), '' );
            IF (sousecr.debit - sousecr.credit) > 0 THEN
                insert into compta_sous_ecriture (ID,COMPTE,DEBIT,CREDIT,REMARQUE,LIBELLEPIECE,IDMERE,REFERENCE_ENGAGEMENT,COMPTE_AUX,LETTRAGE,JOURNAL,EXERCICE,DATY,FOLIO,ANALYTIQUE,SOURCE,ETAT)
                values(seq_compta_sous_ecriture.NEXTVAL, sousecr.compte, sousecr.debit - sousecr.credit, 0, 'R A N '||EXO, 'R A N '||EXO, idEcr, '-', '-', '-', 'COMP000015', (EXO + 1),  '01/01/'||(EXO + 1),NULL,NULL,NULL,11);
                insert into compta_sous_ecriture (ID,COMPTE,DEBIT,CREDIT,REMARQUE,LIBELLEPIECE,IDMERE,REFERENCE_ENGAGEMENT,COMPTE_AUX,LETTRAGE,JOURNAL,EXERCICE,DATY,FOLIO,ANALYTIQUE,SOURCE,ETAT)
                values(seq_compta_sous_ecriture.NEXTVAL, '89000000', 0, sousecr.debit - sousecr.credit, 'R A N '||EXO, 'R A N '||EXO, idEcr, '-', '-', '-', 'COMP000015', (EXO + 1), '01/01/'||(EXO + 1),NULL,NULL,NULL,11);
            END IF;
            IF (sousecr.credit - sousecr.debit)>0 THEN
                insert into compta_sous_ecriture (ID,COMPTE,DEBIT,CREDIT,REMARQUE,LIBELLEPIECE,IDMERE,REFERENCE_ENGAGEMENT,COMPTE_AUX,LETTRAGE,JOURNAL,EXERCICE,DATY,FOLIO,ANALYTIQUE,SOURCE,ETAT)
                values(seq_compta_sous_ecriture.NEXTVAL, sousecr.compte, 0, sousecr.credit - sousecr.debit, 'R A N '||EXO, 'R A N '||EXO, idEcr, '-', '-', '-', 'COMP000015', (EXO + 1), '01/01/'||(EXO + 1),NULL,NULL,NULL,11);
                insert into compta_sous_ecriture (ID,COMPTE,DEBIT,CREDIT,REMARQUE,LIBELLEPIECE,IDMERE,REFERENCE_ENGAGEMENT,COMPTE_AUX,LETTRAGE,JOURNAL,EXERCICE,DATY,FOLIO,ANALYTIQUE,SOURCE,ETAT)
                values(seq_compta_sous_ecriture.NEXTVAL, '89000000', sousecr.credit - sousecr.debit, 0, 'R A N '||EXO, 'R A N '||EXO, idEcr, '-', '-', '-', 'COMP000015', (EXO + 1), '01/01/'||(EXO + 1),NULL,NULL,NULL,11);
            END IF;
        END LOOP;

exception
    WHEN OTHERS THEN
        er := SQLERRM;
        commit;
END;