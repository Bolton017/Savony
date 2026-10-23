package maintenance.planning;

import bean.CGenUtil;
import utilitaire.ConstanteEtat;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;

import java.sql.Connection;
import java.util.HashMap;
import java.util.Vector;

public class CalendrierMaintenance {
    String[] listeDate;
    HashMap<String, Vector> items;

    public CalendrierMaintenance(String idTypeDeMaintenance, String idMachine, String dtMin, String dtMax) throws Exception {
        Connection c=null;
        try {
            c = new UtilDB().GetConn();
            this.setListeDate(dtMin,dtMax);
            this.setItems(idTypeDeMaintenance,idMachine,dtMin,dtMax,c);
        }
        catch (Exception e) {
            throw e;
        }
        finally {
            if(c!=null)c.close();
        }
    }

    public String[] getListeDate() {
        return listeDate;
    }

    public void setListeDate(String dtMin,String dtMax) {
//        if(Utilitaire.diffJourDaty(dtMax,dtMin)<0)throw new Exception("Date sup inferieur a date Inf");
        int day = Utilitaire.diffJourDaty(dtMax, dtMin);
        String liste[]=new String[day];
        for (int i = 0; i < day; i++) {
            liste[i]=Utilitaire.formatterDaty(Utilitaire.ajoutJourDate(dtMin,i))  ;
//            System.out.println(liste[i]);
        }
        this.listeDate = liste;
    }

    public HashMap<String, Vector> getItems() {
        return items;
    }

    public void setItems(HashMap<String, Vector> items) {
        this.items = items;
    }

    public void setItems(String idTypeDeMaintenance,String idMachine, String dMin, String dMax, Connection c) throws Exception {
        PlanningCpl res = new PlanningCpl();
        if (idTypeDeMaintenance!=null && idTypeDeMaintenance.isEmpty()==false){
            res.setIdTypeMaintenance(idTypeDeMaintenance);
        }
        if (idMachine!=null && idMachine.isEmpty()==false){
            res.setIdMachine(idMachine);
        }
        if(dMin==null||dMin.compareToIgnoreCase("")==0)dMin=Utilitaire.formatterDaty(Utilitaire.getDebutSemaine(Utilitaire.dateDuJourSql())) ;
        String[] colInt={"datedebut"};
        String[] valInt={dMin,dMax};
        this.items = CGenUtil.rechercher2D(res,colInt,valInt,"datedebut",c,"");
    }


    public String getCodeCouleur(PlanningCpl reservationLib){
        String codeCouleur="";
        if (reservationLib!=null){
            boolean hasColor = false;

// etat validé
            if (reservationLib.getEtat() == ConstanteEtat.getEtatValider()) {
                codeCouleur="background:#E9F9F1;border-color:#1F9D5E;color:#1F9D5E;";
                hasColor = true;
            }

// efa manana ordre de travaux
//            if (reservationLib.getEtatDemandeTravaux() == 1) {
//                codeCouleur="background:#E9FAFD;border-color:#1DA7BE;color:#1DA7BE;";
//                hasColor = true;
//            }

// efa manana travaux
            if (reservationLib.getEtatTravaux() == 11) {
                codeCouleur="background:#E9FAFD;border-color:#1DA7BE;color:#1DA7BE;";
                hasColor = true;
            }

// efa entamé
            if (reservationLib.getEtatTravaux() == 21) {
                codeCouleur="background:#EAF0FB;border-color:#2B68D9;color:#2B68D9;";
                hasColor = true;
            }

// terminée
            if (reservationLib.getEtatTravaux() == 41) {
                codeCouleur="background:#EFE9FC;border-color:#8B6AD0;color:#8B6AD0;";
                hasColor = true;
            }

// si AUCUNE condition n’a été vraie
            if (!hasColor) {
                codeCouleur="background:#FDF7E9;border-color:#BC891C;color:#BC891C;";
            }
        }
        return codeCouleur;
    }

    public PlanningCpl [] getByDate(String date) throws Exception {
        if (this.getItems().get(date)!=null){
            return (PlanningCpl[]) this.getItems().get(date).toArray(new PlanningCpl[]{});
        }
        return new PlanningCpl[0];
    }
}
