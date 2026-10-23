package maintenance.planning;

import bean.CGenUtil;
import utilitaire.ConstanteEtat;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;

import java.sql.Connection;
import java.util.HashMap;
import java.util.Vector;

public class CalendrierDemandeTravaux {
    String[] listeDate;
    HashMap<String, Vector> items;

    public CalendrierDemandeTravaux(String idEntite, String idMachine, String idSituation, String priorite, String dtMin, String dtMax) throws Exception {
        Connection c=null;
        try {
            c = new UtilDB().GetConn();
            this.setListeDate(dtMin,dtMax);
            this.setItems(idEntite,idMachine,idSituation,priorite,dtMin,dtMax,c);
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

    public void setItems(String idEntite,String idMachine,String idSituation,String priorite, String dMin, String dMax, Connection c) throws Exception {
        DemandeTravauxCpl res = new DemandeTravauxCpl();
        if (idEntite!=null && idEntite.isEmpty()==false){
            res.setIdEntite(idEntite);
        }
        if (idMachine!=null && idMachine.isEmpty()==false){
            res.setIdMachine(idMachine);
        }
        if (idSituation!=null && idSituation.isEmpty()==false){
            res.setIdSituation(idSituation);
        }
        if (priorite!=null && priorite.isEmpty()==false){
            res.setPriorite(priorite);
        }
        if(dMin==null||dMin.compareToIgnoreCase("")==0)dMin=Utilitaire.formatterDaty(Utilitaire.getDebutSemaine(Utilitaire.dateDuJourSql())) ;
        String[] colInt={"dateBesoin"};
        String[] valInt={dMin,dMax};
        this.items = CGenUtil.rechercher2D(res,colInt,valInt,"dateBesoin",c,"");
    }


    public String getCodeCouleur(DemandeTravauxCpl reservationLib){
        String codeCouleur="";
        if (reservationLib!=null){
            if (reservationLib.getEtat()== ConstanteEtat.getEtatValider()){
                codeCouleur="background:#E9F9F1;border-color: #1F9D5E;color: #1F9D5E;";
            }
            else {
                codeCouleur="background:#FDF7E9;border-color: #BC891C;color: #BC891C;";
            }
        }
        return codeCouleur;
    }

    public DemandeTravauxCpl [] getByDate(String date) throws Exception {
        if (this.getItems().get(date)!=null){
            return (DemandeTravauxCpl[]) this.getItems().get(date).toArray(new DemandeTravauxCpl[]{});
        }
        return new DemandeTravauxCpl[0];
    }
}
