package budget;

import bean.CGenUtil;
import bean.ResultatEtSomme;
import utilitaire.Utilitaire;

import java.sql.Connection;

public class SituationBudgetDepensesAnnuel extends SituationBudgetDepenses{
    private int moisdebut = 1,moisfin = 12;
    private String moisdebutlib,moisfinlib;

    public int getMoisdebut() {
        return moisdebut;
    }

    public void setMoisdebut(int moisdebut) {
        this.moisdebut = moisdebut;
    }

    public int getMoisfin() {
        return moisfin;
    }

    public void setMoisfin(int moisfin) {
        this.moisfin = moisfin;
    }

    public String getMoisdebutlib() {
        return moisdebutlib;
    }

    public void setMoisdebutlib(String moisdebutlib) {
        this.moisdebutlib = moisdebutlib;
    }

    public String getMoisfinlib() {
        return moisfinlib;
    }

    public void setMoisfinlib(String moisfinlib) {
        this.moisfinlib = moisfinlib;
    }

    public ResultatEtSomme rechercherPage(String[] colInt, String[]valInt, int numPage, String apresWhere, String[]nomColSomme, Connection c, int npp) throws Exception {
        String moisdebut = "1";
        String moisfin = "12";
        if(valInt!=null&&valInt.length>1) {
            moisdebut=valInt[0].toString();
            moisfin=valInt[1].toString();
        }

        String req= "select id, compte, service, annee, "+Utilitaire.stringToInt(moisdebut)+" as moisdebut,moisdebutlib, "+Utilitaire.stringToInt(moisfin)+" as moisfin,moisfinlib, budget, montantfacture, paiement, resteapayer, ECARTFACTUREBUDGET, ECARTBUDGETPAIEMENT from\n" +
                "    (select ID,\n" +
                "            COMPTE,\n" +
                "            SERVICE,\n" +
                "            ANNEE,\n" +
                "            sum(nvl(BUDGET, 0)) as budget,\n" +
                "            sum(nvl(MONTANTFACTURE, 0)) as montantfacture,\n" +
                "            sum(nvl(PAIEMENT, 0)) as paiement,\n" +
                "            SUM(nvl(RESTEAPAYER, 0)) as resteapayer,\n" +
                "            sum(nvl(BUDGET, 0))-sum(nvl(MONTANTFACTURE, 0)) as ECARTFACTUREBUDGET,\n" +
                "            sum(nvl(BUDGET, 0))-sum(nvl(PAIEMENT, 0)) as ECARTBUDGETPAIEMENT,\n" +
                "            TO_CHAR(\n" +
                "                    TO_DATE(TO_CHAR("+Utilitaire.stringToInt(moisdebut)+", 'FM00'), 'MM'),\n" +
                "                    'FMMonth',\n" +
                "                    'NLS_DATE_LANGUAGE=FRENCH'\n" +
                "            ) AS moisdebutlib,\n" +
                "            TO_CHAR(\n" +
                "                    TO_DATE(TO_CHAR("+Utilitaire.stringToInt(moisfin)+", 'FM00'), 'MM'),\n" +
                "                    'FMMonth',\n" +
                "                    'NLS_DATE_LANGUAGE=FRENCH'\n" +
                "            ) AS moisfinlib\n" +
                "     from situation_budget_depenses where mois between "+Utilitaire.stringToInt(moisdebut)+" and "+Utilitaire.stringToInt(moisfin)+" AND compte like '6%' group by ID, COMPTE, SERVICE, ANNEE)";
        System.err.println(req);
        ResultatEtSomme rs= CGenUtil.rechercherPage(this,req,numPage,nomColSomme,apresWhere,c,npp);
        return rs;
    }
}
