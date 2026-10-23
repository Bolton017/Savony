package vente;

import bean.CGenUtil;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;
import utils.CalendarUtil;

import java.sql.Connection;
import java.time.LocalTime;
import java.util.HashMap;
import java.util.Vector;


public class EtatVentePaiementDetails {


        String[] listeDate;
        HashMap<String, Vector> reservations;

        public EtatVentePaiementDetails(String dtMin,String dtMax) throws Exception {
            Connection c=null;
            try {
                c = new UtilDB().GetConn();
                this.setListeDate(dtMin,dtMax);
                this.setReservations(dtMin,dtMax,c);
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

        public HashMap<String, Vector> getReservations() {
            return reservations;
        }

        public void setReservations(String dMin,String dMax,Connection c) throws Exception {
            VenteLib res = new VenteLib();
            res.setNomTable("ventecalendrier");
            if(dMin==null||dMin.compareToIgnoreCase("")==0)dMin=Utilitaire.formatterDaty(Utilitaire.getDebutSemaine(Utilitaire.dateDuJourSql())) ;
            String[] colInt={"datyPrevu"};
            String[] valInt={dMin,dMax};
            this.reservations= CGenUtil.rechercher2D(res,colInt,valInt,"datyPrevu",c,"");
        }

        public String getCodeCouleur(VenteLib venteLib){
            String codeCouleur="";
            if (venteLib!=null){
                if (venteLib.getEtat()>=11){
                    codeCouleur="background:rgba(255, 184, 6, 0.211);border-color: rgb(255, 184, 6);";
                }
                else {
                    codeCouleur="background:rgba(0, 166, 11, 0.211);border-color: rgb(0, 166, 11);";
                }
            }
            return codeCouleur;
        }

        public VenteLib [] getByDate(String date) throws Exception {
            if (this.getReservations().get(date)!=null){
                return (VenteLib[]) this.getReservations().get(date).toArray(new VenteLib[]{});
            }
            return new VenteLib[0];
        }

}
