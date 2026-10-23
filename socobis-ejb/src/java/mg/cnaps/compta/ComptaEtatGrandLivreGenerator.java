package mg.cnaps.compta;

import java.sql.Connection;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;

import bean.AdminGen;
import bean.CGenUtil;
import bean.ClassMAPTable;
import bean.ResultatGroupe;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;

public class ComptaEtatGrandLivreGenerator extends ClassMAPTable {
    String id ;


    int exercice;
    String typeCompte;
    int moisDebut;
    int moisFin;
    String compteDebut;
    String compteFin;
    String compteDebutOriginal;
    String compteFinOriginal;
    int etat;
    int lettrage;
    String dateDebut ;
    String dateFin ;
    LinkedHashMap<String,ComptaCompte> comptes = new LinkedHashMap<String,ComptaCompte>();
    ComptaCompte[] compteArray;
    

    public String getId() {
        return id;
    }

    public String getDateDebut() {
        return "01/01/" + this.getExercice();
    }

    public String getDateFin() {
        return Utilitaire.formatterDaty(Utilitaire.getLastDayOfDate("01/" + Utilitaire.completerInt(2, this.getMoisFin()) + "/" + this.getExercice()));
    }

    public void setDateFin(String dateFin) {
        this.dateFin = dateFin;
    }
    public void setDateDebut(String dateDebut) {
        this.dateDebut = dateDebut;
    }
    public void setId(String id) {
        this.id = id;
    }
    public int getExercice() {
        return exercice;
    }

    public void setExercice(int exercice) {
        this.exercice = exercice;
    }

    public String getTypeCompte() {
        return typeCompte;
    }

    public void setTypeCompte(String typeCompte) {
        this.typeCompte = typeCompte;
    }

    public int getMoisDebut() {
        return moisDebut;
    }

    public void setMoisDebut(int moisDebut) {
        this.moisDebut = moisDebut;
    }

    public int getMoisFin() {
        return moisFin;
    }

    public void setMoisFin(int moisFin) {
        this.moisFin = moisFin;
    }

    public String getCompteDebut() {
        return compteDebut;
    }

    public void setCompteDebut(String compteDebut) {
        if (compteDebut!=null&&!compteDebut.isEmpty()){
            this.compteDebutOriginal = compteDebut;
            this.compteDebut = Utilitaire.completerIntFin(ConstanteCompta.constante_compte,compteDebut, 0);
            return;
        }
        this.compteDebut = compteDebut;
        this.compteDebutOriginal = compteDebut;
    }

    public String getCompteFin() {
        return compteFin;
    }

    public void setCompteFin(String compteFin) {
        if (compteFin!=null&&!compteFin.isEmpty()){
            this.compteFinOriginal = compteFin;
            this.compteFin = Utilitaire.completerIntFin(ConstanteCompta.constante_compte,compteFin,0);
            return;
        }
        this.compteFin = compteFin;
        this.compteFinOriginal = compteFin;
    }

    /**
     * Normalise les comptes : si debut == fin, utilise la valeur originale non formatée
     */
    public void normalizeComptes() {
        if (this.compteDebutOriginal != null && this.compteFinOriginal != null) {
            if (this.compteDebutOriginal.equals(this.compteFinOriginal)) {
                // Si les deux comptes originaux sont identiques, utiliser la valeur originale
                this.compteDebut = this.compteDebutOriginal;
                this.compteFin = this.compteFinOriginal;
            }
        }
    }

    public int getEtat() {
        return etat;
    }

    public void setEtat(int etat) {
        this.etat = etat;
    }

    public int getLettrage() {
        return lettrage;
    }

    public void setLettrage(int lettrage) {
        this.lettrage = lettrage;
    }

    public LinkedHashMap<String, ComptaCompte> getComptes() {
        return comptes;
    }

    public void setComptes(LinkedHashMap<String, ComptaCompte> comptes) {
        this.comptes = comptes;
    }

    public ComptaCompte[] getCompteArray() {
        return compteArray;
    }

    public void setCompteArray(ComptaCompte[] compteArray) {
        this.compteArray = compteArray;
    }


    public String getqwery(String dateDebut,String compteDebut,String compteFin) {
        ReportSolde report = new ReportSolde();
        report.setNomTableSelonTypeCompte(Integer.valueOf(typeCompte));
        String qwery = "SELECT "
                    + "    COMPTE, "
                    + "    LIBELLE, "
                    + "    DEBIT, "
                    + "    CREDIT, "
                    + "    TYPECOMPTE, "
                    + "    DATY, "
                    + "    CHIFFRE3, "
                    + "    CHIFFRE2 "
                    + "FROM ( "
                    + "    SELECT "
                    + "        v.*, "
                    + "        ROW_NUMBER() OVER ( "
                    + "            PARTITION BY COMPTE "
                    + "            ORDER BY DATY ASC "
                    + "        ) AS rn "
                     + "    FROM " + report.getNomTable() + " v "
                    + "    WHERE DATY <= TO_DATE('" + dateDebut + "', 'YYYY-MM-DD') "
                    + "    AND COMPTE >=  '" + compteDebut + "' "
                    + "    AND COMPTE <='" + compteFin + "' "
                    + ") "
                    + "WHERE rn = 1"
                    + " ORDER BY COMPTE ASC ";
        return qwery;
    }



    // logique nalaina avany amn gallois graphyte
    public ReportSolde[] getReports(Connection c)throws Exception{
        try{
            ReportSolde report = new ReportSolde();
            report.setNomTableSelonTypeCompte(Integer.valueOf(typeCompte));
            
            String request = getqwery(dateDebut,compteDebut,compteFin);
            ReportSolde[] repports = (ReportSolde[])CGenUtil.rechercher(report,request,c);
            

            Map<String, ReportSolde> mapReports = new HashMap<>();
            if (repports != null) {
                for (ReportSolde r : repports) {
                    if (r.getCompte() != null) {
                        mapReports.put(r.getCompte(), r);
                    }
                }
            }


            ComptaSousEcriture ecritureFilter = new ComptaSousEcriture();
            ecritureFilter.setNomTableSelonEtatEtTypeCompte(etat, Integer.valueOf(typeCompte));
    
            String dateDebutExercice = "01/01/" + exercice;
            String awhere = " AND EXERCICE = " + exercice 
                        + " AND COMPTE >= '" + compteDebut + "' AND COMPTE <= '" + compteFin + "'"
                        + " AND DATY >= TO_DATE('" + dateDebutExercice + "', 'DD/MM/YYYY')"
                        + " AND DATY <= TO_DATE('" + dateDebut + "', 'YYYY-MM-DD')"
                        + " ORDER BY COMPTE ASC, DATY ASC";

            ComptaSousEcriture[] mouvements = (ComptaSousEcriture[]) CGenUtil.rechercher(ecritureFilter, null, null, c, awhere);

            LinkedHashMap<String, ClassMAPTable[]> mapMouvements = new LinkedHashMap<>();
            if (mouvements != null && mouvements.length > 0) {
                mapMouvements = (LinkedHashMap<String, ClassMAPTable[]>) AdminGen.toHashLinked(mouvements, "compte");
            }

            Set<String> comptetous = new TreeSet<>();
            comptetous.addAll(mapReports.keySet());
            comptetous.addAll(mapMouvements.keySet());

            List<ReportSolde> resultList = new ArrayList<>();

            for (String compte : comptetous) {
            ReportSolde lastReport = mapReports.get(compte);
            ClassMAPTable[] mouvementsCompte = mapMouvements.get(compte);

            double initialDebit = 0;
            double initialCredit = 0;
            java.util.Date dateDernierReport = null;

            if (lastReport != null) {
                initialDebit = lastReport.getDebit();
                initialCredit = lastReport.getCredit();
                dateDernierReport = lastReport.getDaty(); 
            }

            double sumDebitMouvements = 0;
            double sumCreditMouvements = 0;

            if (mouvementsCompte != null) {
                for (ClassMAPTable item : mouvementsCompte) {
                    ComptaSousEcriture mvt = (ComptaSousEcriture) item;
                    boolean inclureMouvement = false;

                    if (dateDernierReport != null) {
                        if (mvt.getDaty() != null && mvt.getDaty().after(dateDernierReport)) {
                            inclureMouvement = true;
                        }
                    } else {
                        inclureMouvement = true;
                    }

                    if (inclureMouvement) {
                        sumDebitMouvements += mvt.getDebit();
                        sumCreditMouvements += mvt.getCredit();
                    }
                }
            }

            double totalDebit = initialDebit + sumDebitMouvements;
            double totalCredit = initialCredit + sumCreditMouvements;
            double soldeNet = totalDebit - totalCredit;

            ReportSolde finalReport = new ReportSolde();
            finalReport.setCompte(compte);

            if (soldeNet > 0) {
                finalReport.setDebit(soldeNet);
                finalReport.setCredit(0);
            } else {
                finalReport.setDebit(0);
                finalReport.setCredit(-soldeNet);
            }

            resultList.add(finalReport);
        }

        return resultList.toArray(new ReportSolde[0]);
        }catch(Exception e){
            e.printStackTrace();
            throw e;
        }
    }




    public ComptaSousEcriture[] getMouvements(Connection c)throws Exception{
        try{
            ComptaSousEcritureLib ecriture = new ComptaSousEcritureLib();
            ecriture.setNomTableSelonEtatEtTypeCompte(etat, Integer.valueOf(typeCompte));
           // String dateMin = Utilitaire.moisEtAnneeToDate2(moisDebut-1,exercice,"min");
           // String dateMax = Utilitaire.moisEtAnneeToDate2(moisFin-1,exercice,"max");
            String filtreLettrage = "";
            if (lettrage == 1) {
                filtreLettrage = " AND LETTRAGE IS NOT NULL";
            } else if (lettrage == 2) {
                filtreLettrage = " AND LETTRAGE IS NULL";
            }
            String ordre =  " AND COMPTE BETWEEN '" + compteDebutOriginal + "' AND '" + compteFinOriginal + "' and  daty>= TO_DATE('"+dateDebut+"', 'YYYY-MM-DD') and daty<= TO_DATE('"+dateFin+"', 'YYYY-MM-DD')" + filtreLettrage + " ORDER BY compte ASC";
            ComptaSousEcriture[] val = (ComptaSousEcriture[])CGenUtil.rechercher(ecriture,null,null,c,ordre);          
            return val;
        }catch(Exception e){
            e.printStackTrace();
            throw e;
        }
    }

    public LinkedHashMap<String,ComptaCompte> getComptes(Connection c)throws Exception{
        try{
            ComptaCompteCpl compte = new ComptaCompteCpl();
            compte.setNomTable("v_compta_compte");
            String[] colInt = {"compteInt"};
            String[] valInt = {compteDebut,compteFin};
            String ordre =  " AND COMPTE BETWEEN '" + compteDebutOriginal + "' AND '" + compteFinOriginal + "' ORDER BY compte ASC";

            setCompteArray((ComptaCompte[])CGenUtil.rechercher(compte,null,null,c,ordre));


            for(int i=0;i<compteArray.length;i++){
                this.comptes.put(((ComptaCompteCpl)compteArray[i]).getCompte(),compteArray[i]);
            }

            return this.comptes;
        }catch(Exception e){
            e.printStackTrace();
            throw e;
        }
    }

    public void fillComptesWithMouvementAndReport(Connection c)throws Exception{
        int verif=0;
        try{
            if(c==null){
                c = new UtilDB().GetConn();
                verif = 1;
            }
            getComptes(c);
            ReportSolde[] report = getReports(c);
            ComptaSousEcriture[] mouvements = getMouvements(c);
            for(int i=0;i<report.length;i++){
                String compte = report[i].getCompte();
                ComptaCompte comptacompte = this.comptes.get(compte);
                if(comptacompte != null){
                    comptacompte.addReport(report[i]);
                }
            }
            for(int i=0;i<mouvements.length;i++){
                String compte = mouvements[i].getCompte();
                ComptaCompte comptacompte = this.comptes.get(compte);
                if(comptacompte != null){
                    comptacompte.addMouvement(mouvements[i]);
                }
            }
        }catch(Exception e){
            e.printStackTrace();
            throw e;
        }finally{
            if(c!=null && verif==1)c.close();
        }
    }

    public double getTotalDebit(){
        return AdminGen.calculSommeDouble(compteArray,"mouvementDebit");
    }

    public double getTotalCredit(){
        return AdminGen.calculSommeDouble(compteArray,"mouvementCredit");
    }

    public double getSoldeCredit(){
        return Math.max(getTotalCredit()-getTotalDebit(),0);
    }

    public double getSoldeDebit(){
        return Math.max(getTotalDebit()-getTotalCredit(),0);
    }

    @Override
    public String getTuppleID() {
        // TODO Auto-generated method stub
        return getId();
    }

    @Override
    public String getAttributIDName() {
        // TODO Auto-generated method stub
        return "id";
    }
}
