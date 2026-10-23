/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.edition;

import bean.CGenUtil;
import bean.TypeObjet;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import configuration.Configuration;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import paie.conge.MouvementAbsence;
import paie.employe.AdminPaieInfoPers;
import paie.employe.PaieRubrique;
import paie.generique.DetFormu;
import utilitaire.ConstanteEtatPaie;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;


/**
 *
 * @author ASUS
 */
public class EditionCalcul {

    public static void reinitialiserElementpaieAnterieur(String idpersonnel, java.sql.Date datefin, Connection con) throws Exception {
        Statement statement = null;
        try {
            statement = con.createStatement();
            statement.executeUpdate("UPDATE PAIE_PERSONNEL_ELEMENTPAIE SET DATE_FIN = '" + Utilitaire.formatterDaty(datefin) + "' WHERE IDPERSONNEL = '" + idpersonnel + "' AND DATE_FIN IS NULL");
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
    }

    public static PeriodePaie getPeriodePaie(Connection connection,String mois,String annee,String categorie) throws Exception {   
    try {
            PeriodePaie periode= new PeriodePaie();
            periode.setNomTable("periodepaie");
            PeriodePaie[] pp = (PeriodePaie[]) CGenUtil.rechercher(periode, null, null, connection," and mois='"+mois+"' and annee="+Integer.parseInt(annee)+" and idcategoriepaie='"+categorie+"'" );
            if(pp.length==0){
                throw new Exception("Ce periode de paie existe pas encore veuillez inserer ");
            }
            periode = pp[0];
            return periode;
        } catch (Exception ex) {
            ex.printStackTrace();
            connection.rollback();
            throw ex;
        }
    }

    public static String  genererEditionPLSQLTahina(int mois, int annee, String direction, String iduser,String idpersonnel, String categorie) throws Exception {   
        Connection connection = null;
        PreparedStatement prstmt = null;
        CallableStatement deleteEdition = null;
        PaieEditionmoisannee idEdition = null;
        
        try {
            connection = new UtilDB().GetConn();
            connection.setAutoCommit(false);
            String procedureDelete = "{call DELETEEDITIONWITHPERIODE(?)}";         
            PeriodePaie periode =  getPeriodePaie(connection,String.valueOf(mois),String.valueOf(annee),categorie);
            String condition = " and idperiodepaie='" + periode.getId() + "'";
            if(idpersonnel!=null) condition+= " and idpersonnel='"+idpersonnel+"'";

            PaieEditionmoisannee[] tab = (PaieEditionmoisannee[]) CGenUtil.rechercher(new PaieEditionmoisannee(),null,null,connection,condition);
            if (tab.length > 0) { 
                if (tab[0].getEtat() > 1) throw new Exception("Edition deja vise");
                deleteEdition = connection.prepareCall(procedureDelete);
                deleteEdition.setString(1, periode.getId());
                deleteEdition.executeUpdate();
            }
            PaieRubrique[] tPaieRubrique = (PaieRubrique[]) CGenUtil.rechercher(new PaieRubrique(), null, null, connection, " ");
            HashMap<String, Integer> tabRub = new HashMap<String, Integer>();
            for (int i = 0; i < tPaieRubrique.length; i++) {
                tabRub.put(tPaieRubrique[i].getId(), tPaieRubrique[i].getRegroupement());
            }
            
            TypeObjet rubriquemanuel = new TypeObjet();
            rubriquemanuel.setNomTable("rubriquemanuel");
            TypeObjet[] tabRubriqueCalcul = (TypeObjet[]) CGenUtil.rechercher(rubriquemanuel, null, null, connection, "");
            List<String> mandeGain = new ArrayList<String>();
            List<String> mandeRetenue = new ArrayList<String>();
            for (int i = 0; i < tabRubriqueCalcul.length; i++) {
                if (tabRubriqueCalcul[i].getDesce().equals("+")) {
                    mandeGain.add(tabRubriqueCalcul[i].getVal());
                }
                if (tabRubriqueCalcul[i].getDesce().equals("-")) {
                    mandeRetenue.add(tabRubriqueCalcul[i].getVal());
                }
            }
            
            Configuration conf = new Configuration();
            conf.setNomTable("configuration");
            Configuration[] config = (Configuration[]) CGenUtil.rechercher(conf, null, null, connection, "");
            
            idEdition = insertPaieEditionMoisAnnee(mois, annee, direction, 0, 0, connection, iduser,"paie_editionmoisannee",idpersonnel,periode.getId());            
            Date datedebut = periode.getDatedebut();
            Date datefin = periode.getDatefin();
            String condition_elp ="";

            String sql_select = "select p.*,'" + idEdition.getId() + "' as mere "+
                                "FROM PAIEINFOPERSELTPAIECOMPLET4 p " +
                                    "WHERE p.etat = 11 " +
                                      "AND p.etat_element = 11 " +
                                      "AND ( " +
                                        "p.date_debut <= TO_DATE('" + datefin   + "', 'YYYY/MM/DD') " +
                                        "AND ( " +
                                          "(p.date_fin >= TO_DATE('" + datedebut + "', 'YYYY/MM/DD') " +
                                           "AND p.date_fin <= TO_DATE('" + datefin + "', 'YYYY/MM/DD')) " +
                                          "OR p.date_fin IS NULL " +
                                        ") " +
                                      ") " +
                                    condition_elp + " " +
                                    "ORDER BY p.IDPERSONNEL ASC, p.rang ASC, p.imposable ASC, p.typerubrique ASC";            
            
            System.out.println("request global------>"+  sql_select);
            prstmt = connection.prepareStatement(sql_select);
            ResultSet rst = prstmt.executeQuery();
            PaieRubrique[] listRub = (PaieRubrique[]) CGenUtil.rechercher(new PaieRubrique(), null, null, connection, " order by rang ASC");
            AdminPaieInfoPers admin = new AdminPaieInfoPers(null, mois,annee, direction, idpersonnel, connection, datedebut, datefin);
            admin.ajouterElement(rst, mois, annee);
            DetFormu crtDet = new DetFormu();
            DetFormu[] listeDF = (DetFormu[]) CGenUtil.rechercher(crtDet, null, null, connection, "and etat=11 order by mere asc,min asc");
            admin.attacherInfo(config, listeDF, listRub);
            admin.executeTous(connection,idEdition,periode.getId());
            connection.commit();        
            return idEdition.getId();
        } catch (Exception ex) {
            ex.printStackTrace();
            connection.rollback();
            throw ex;
        } finally {
            if (connection != null) {
                connection.close();
            }
        }
    }
    
    /* 
    public static void  genererEditionStc(int mois, int annee, String direction, String iduser,String type_edition,String idpersonnel, Date dateOuverture, Date dateFermeture) throws Exception {

        System.out.println(" --- debut generer --- ");
   
        
        String procedureDelete = "{call DELETEEDITIONWITHSTC(?,?,?,?)}";      
        CallableStatement deleteEdition = null;
        Connection connection = null;
        PreparedStatement prstmt = null;
        PaieEditionmoisannee idEdition = null;
        String tab_edition="paie_edition_stc";
        String tab_editionmoisannee="paie_editionmoisannee_stc";
        Paie_edition[] tabCnaps = null;
        Paie_edition cnaps = new Paie_edition();
        cnaps.setNomTable("vue_cnaps");
        String condition =" and idpersonnel='"+idpersonnel+"'";
        try {
            connection = new UtilDB().GetConn();
            connection.setAutoCommit(false);
            PaieEditionmoisannee a = new PaieEditionmoisannee();
            a.setNomTable(tab_editionmoisannee);
            PaieEditionmoisannee[] tab = (PaieEditionmoisannee[]) CGenUtil.rechercher(a, null, null, connection, condition);
            if (tab.length > 0) { 
                if (tab[0].getEtat() > 1) throw new Exception("Edition deja vise");
                deleteEdition = connection.prepareCall(procedureDelete);
                deleteEdition.setInt(1, mois);
                deleteEdition.setInt(2, annee);
                deleteEdition.setString(3, direction);
                deleteEdition.setString(4, idpersonnel);
                deleteEdition.executeUpdate();
            }
           
            
            //CGenUtil.executeReq("insert into paie_personnel_elementpaie  (select 'PEP' || getseqpaie_personnel_elementpaie(),a.idtypeavance,(r.annee || '-' || r.mois ||'-01') :: date,end_of_month((r.annee || '-' || r.mois ||'-01') :: date) as fin,0,r.montant,'' ,a.idpersonnel ,11,'','1060',r.mois,r.annee,null,null,20,null,null  from remboursement r left join avance a on a.id = r.idavance where r.mois='"+
            //String.valueOf(mois)+"' and r.annee='"+String.valueOf(annee)+"')", connection);
            PaieRubrique[] tPaieRubrique = (PaieRubrique[]) CGenUtil.rechercher(new PaieRubrique(), null, null, connection, " ");

            System.out.println(" PaieRubrique---------> "+ tPaieRubrique.length  );
            
            HashMap<String, Integer> tabRub = new HashMap<String, Integer>();
            for (int i = 0; i < tPaieRubrique.length; i++) {
                tabRub.put(tPaieRubrique[i].getId(), tPaieRubrique[i].getRegroupement());
            }
            
            TypeObjet rubriquemanuel = new TypeObjet();
            rubriquemanuel.setNomTable("rubriquemanuel");
            TypeObjet[] tabRubriqueCalcul = (TypeObjet[]) CGenUtil.rechercher(rubriquemanuel, null, null, connection, "");
            List<String> mandeGain = new ArrayList<String>();
            List<String> mandeRetenue = new ArrayList<String>();
            for (int i = 0; i < tabRubriqueCalcul.length; i++) {
                if (tabRubriqueCalcul[i].getDesce().equals("+")) {
                    mandeGain.add(tabRubriqueCalcul[i].getVal());
                }
                if (tabRubriqueCalcul[i].getDesce().equals("-")) {
                    mandeRetenue.add(tabRubriqueCalcul[i].getVal());
                }
            }
            
            Configuration conf = new Configuration();
            conf.setNomTable("configuration");
            
            Configuration[] config = (Configuration[]) CGenUtil.rechercher(conf, null, null, connection, "");//(Configuration[]) CGenUtil.rechercher(new Configuration(), null, null, connection, "");
            idEdition = insertPaieEditionMoisAnneeStc(mois, annee, direction, 0, 0, connection, iduser,idpersonnel);            

            Date datedebut = Utilitaire.stringDate("01/"+Utilitaire.completerInt(2, mois)+"/"+annee);
            Date datefin = Utilitaire.stringDate(Utilitaire.getLastJourInMonth(datedebut)+"/"+Utilitaire.completerInt(2, mois)+"/"+annee);         
            
            String condition_elp ="";
            if(type_edition.equals("stc")) condition_elp+= " and p.idpersonnel='"+idpersonnel+"' ";
         String sql_select =
                        "SELECT p.*, '" + idEdition.getId() + "' AS mere " +
                        "FROM PAIEINFOPERSELTPAIECOMPLET2 p " +
                        "WHERE "+
                          " p.etat_element = 11 " +
                          "AND ( " +
                            // cas usuel de recouvrement des dates
                            "( p.date_debut <= TO_DATE('" + datefin + "', 'YYYY/MM/DD') " +
                              "AND ( " +
                                "(p.date_fin >= TO_DATE('" + datedebut + "', 'YYYY/MM/DD') " +
                                 "AND p.date_fin <= TO_DATE('" + datefin + "', 'YYYY/MM/DD')) " +
                                "OR p.date_fin IS NULL " +
                              ") " +
                            ")" +
                            // on ajoute un OU pour le code_rubrique + date_debut > 2025-06-30
                            " OR ( p.code_rubrique IN('PRU0453','PRU0447') " +
                                 "AND p.date_debut > TO_DATE('2025-06-30','YYYY/MM/DD') )" +
                          ") " +
                            condition_elp + " " +
                                    "ORDER BY p.IDPERSONNEL ASC, p.rang ASC, p.imposable ASC, p.typerubrique ASC";
            
            System.out.println("request stc------>"+  sql_select);
            prstmt = connection.prepareStatement(sql_select);
            ResultSet rst = prstmt.executeQuery();
            PaieRubrique[] listRub = (PaieRubrique[]) CGenUtil.rechercher(new PaieRubrique(), null, null, connection, " order by rang ASC");
            AdminPaieInfoPers admin = new AdminPaieInfoPers(null, mois,annee, direction, idpersonnel, connection, type_edition, dateOuverture, dateFermeture);
            admin.ajouterElement(rst, mois, annee);
            DetFormu crtDet = new DetFormu();
            DetFormu[] listeDF = (DetFormu[]) CGenUtil.rechercher(crtDet, null, null, connection, "and etat=11 order by mere asc,min asc");
            admin.attacherInfo(config, listeDF, listRub);
            admin.executeTous(connection,idEdition,tab_edition);
            
            
            connection.commit();

        } catch (Exception ex) {
            ex.printStackTrace();
            connection.rollback();
            throw ex;
        } finally {
            if (connection != null) {
                connection.close();
            }
        }
    }
    
    
    
    public double getSoldeCongeStc(String idpersonnel,Date daty){
        double solde=0.0;
        MouvementAbsence mouv = new MouvementAbsence();
        mouv.setIdPersonnel(idpersonnel);
        try {
            mouv.getSoldeCongePers(daty);
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return solde;
    }
    
    public static void solderCongerStc(String idpersonnel,String iduser,Connection connection) throws Exception{
        int con=0;
        try{
            if(connection ==null){
                connection = new UtilDB().GetConn();
                con=1;
            }
            MouvementAbsence data = new MouvementAbsence();
            data.SoldeCongeStc(idpersonnel,iduser,connection);
        }catch (Exception ex) {
            ex.printStackTrace();
            connection.rollback();
            throw ex;
        } finally {
            if (connection != null && con==1) {
                connection.close();
            }
        }
    }
    
    
   


    public static void copierStcVersPaieEdition(int mois, int annee, String idEdition, String idDirection, String u, Connection c) throws Exception {
        boolean open = false;

        try {
            if(c == null && open == false) {
                c = new UtilDB().GetConn();
                open = true;
            }
            Paie_edition tmp = new Paie_edition();
            tmp.setNomTable("PAIE_EDITION_STC");
            tmp.setAnnee(annee);
            tmp.setMois(mois);
            String aWhere = " and idpersonnel in (select * from vue_id_matricule where iddirection= '"+ idDirection + "')";
            Paie_edition[] stc = (Paie_edition[]) CGenUtil.rechercher(tmp, null, null, c, aWhere);
            if(stc != null && stc.length > 0) {
                for(int i = 0; i < stc.length; i++) {
                    stc[i].setNomTable("PAIE_EDITION");
                    stc[i].setIdedition(idEdition);
                    stc[i].createObject(u, c);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if(c != null && open == true) {
                c.close();
            }
        }

    }
    
    public static String validerStc(String idpersonnel,String iduser,Connection c) throws SQLException{
            boolean open = false;
            String idedition="";
        try {
            if(c == null && open == false) {
                c = new UtilDB().GetConn();
                open = true;
            }
            //solder conger
            solderCongerStc(idpersonnel,iduser,c);
            
            System.out.println("idpersonnel========>"+idpersonnel);

            Paie_edition p = new Paie_edition();
            PaieEditionmoisannee pm = new PaieEditionmoisannee();
            p.setNomTable("paie_edition_stc");
            p.setIdpersonnel(idpersonnel);
            pm.setNomTable("PAIE_EDITIONMOISANNEE_STC");
            pm.setIdpersonnel(idpersonnel);
            Paie_edition[] tab_edition = (Paie_edition[]) CGenUtil.rechercher(p, null, null, c, "");
            PaieEditionmoisannee[] tab_editionma = (PaieEditionmoisannee[]) CGenUtil.rechercher(pm, null, null, c, "");

            if (tab_edition.length>0){
                for(int i = 0; i < tab_edition.length; i++) {
                    tab_edition[i].setNomTable("paie_edition_stc");
                    tab_edition[i].setEtat(11);
                    tab_edition[i].updateToTableWithHisto(iduser, c);
                }
                    tab_editionma[0].setNomTable("PAIE_EDITIONMOISANNEE_STC");
                    tab_editionma[0].setEtat(11);   
                    tab_editionma[0].updateToTableWithHisto(iduser, c);
                    idedition =  tab_editionma[0].getId();
                    System.out.println("idedition=====>"+idedition);
            }
            
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if(c != null && open == true) {
                c.close();
            }
        }
        return idedition;
    }
 */


   public static String genererEditionRegulCnaps(int mois, int annee, String direction, double taux_cnaps) throws Exception {
    String idedition = "";
    String request = "{ call function_regulcnaps(?, ?, ?) }"; 
    String get_edition = "{ call get_edition(?, ?) }"; 
    try (Connection connection = new UtilDB().GetConn();
         CallableStatement stmt = connection.prepareCall(request);
         CallableStatement stmt2 = connection.prepareCall(get_edition)) {
        connection.setAutoCommit(false);
        try {
            stmt.setInt(1, mois);
            stmt.setInt(2, annee);
            stmt.setDouble(3, taux_cnaps);
            stmt.execute(); 
            connection.commit();

            stmt2.setInt(1, mois);
            stmt2.setInt(2, annee);
            try (ResultSet rs = stmt2.executeQuery()) {
                if (rs.next()) {
                    idedition = rs.getString(1); 
                }
            }
            connection.commit();
        } catch (Exception e) {
            connection.rollback();
            throw e;
        }
    } catch (Exception ex) {
        
        ex.printStackTrace();
        throw ex;
    }   
    return idedition; 
}
        
    public static PaieEditionmoisannee insertPaieEditionMoisAnnee(int mois, int annee, String direction, double sommegain, double sommeretenue, Connection connection, String iduser,String idpersonnel) throws Exception {
        PaieEditionmoisannee editionMoisAnnee = new PaieEditionmoisannee();
        String idpers= idpersonnel!=null?idpersonnel:"-";
        editionMoisAnnee.setNomTable("paie_editionmoisannee");
        editionMoisAnnee.setMois(mois);
        editionMoisAnnee.setAnnee(annee);
        editionMoisAnnee.setIdpersonnel(idpers);
        editionMoisAnnee.setIddirection(direction);
        editionMoisAnnee.setEtat(ConstanteEtatPaie.getEtatCreer());
        editionMoisAnnee.construirePK(connection);
        editionMoisAnnee.insertToTableWithHisto(iduser, connection);
        System.out.println("AVANT RETURN ______ "+editionMoisAnnee.getId());
        return editionMoisAnnee;
    }
    
    /*
        public static PaieEditionmoisannee insertPaieEditionMoisAnneeStc(int mois, int annee, String direction, double sommegain, double sommeretenue, Connection connection, String iduser,String idpersonnel,String idperiodepaie) throws Exception {
        PaieEditionmoisannee editionMoisAnnee = new PaieEditionmoisannee();
        String idpers= idpersonnel!=null?idpersonnel:"-";
        editionMoisAnnee.setNomTable("paie_editionmoisannee_stc");
        editionMoisAnnee.setMois(mois);
        editionMoisAnnee.setAnnee(annee);
        editionMoisAnnee.setIdpersonnel(idpers);
        editionMoisAnnee.setIddirection(direction);
        editionMoisAnnee.setEtat(ConstanteEtatPaie.getEtatCreer());
        editionMoisAnnee.setIdperiodepaie(idperiodepaie);
        editionMoisAnnee.construirePK(connection);
        editionMoisAnnee.insertToTableWithHisto(iduser, connection);
        System.out.println("AVANT RETURN ______ "+editionMoisAnnee.getId());
        return editionMoisAnnee;
    }*/
    
        public static PaieEditionmoisannee insertPaieEditionMoisAnnee(int mois, int annee, String direction, double sommegain, double sommeretenue, Connection connection, String iduser,String nomtable,String idpersonnel,String idperiodepaie) throws Exception {
        PaieEditionmoisannee editionMoisAnnee = new PaieEditionmoisannee();
        String idpers= idpersonnel!=null?idpersonnel:"-";
        editionMoisAnnee.setNomTable(nomtable);
        editionMoisAnnee.setMois(mois);
        editionMoisAnnee.setAnnee(annee);
        editionMoisAnnee.setIdpersonnel(idpers);
        editionMoisAnnee.setIddirection(direction);
        editionMoisAnnee.setEtat(ConstanteEtatPaie.getEtatCreer());
        editionMoisAnnee.setIdperiodepaie(idperiodepaie);
        editionMoisAnnee.construirePK(connection);
        editionMoisAnnee.insertToTableWithHisto(iduser, connection);
        System.out.println("AVANT RETURN ______ "+editionMoisAnnee.getId());
        return editionMoisAnnee;
    }
        

}
