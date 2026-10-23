    /*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.service;

import bean.CGenUtil;
import java.sql.Connection;
import javax.servlet.http.HttpServletRequest;

import historique.MapUtilisateur;
import paie.pointage.Pointage;
import user.UserEJB;
import utilitaire.Utilitaire;
import utilitaire.UtilDB;
import utilitaire.ConstanteEtat;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
/**
 *
 * @author Tsiky
 */
public class PointageService {
    
    public static Pointage[] getPointageVises(String mois, String annee, String matricule, String direction,String awere) throws Exception {
  Connection c = null;
        PreparedStatement prstmt = null;
        List<Pointage> ret = new ArrayList<Pointage>();
        try {
          c = new UtilDB().GetConn();
            System.out.println("AVANT OOO");
            java.sql.Date datedebut = Utilitaire.stringDate("01/" + Utilitaire.completerInt(2, mois) + "/" + annee);
            java.sql.Date datefin = Utilitaire.getLastDayOfDateSQL(datedebut);
          String where1 = "SELECT null as id, info.id as idpersonnel, info.matricule, info.nom, info.prenom,info.direction, "
                    + " null as mois, null as annee, "
                    + "173.33 as heurenormal,0 as heuresupnormal,0 as heuresupnuit,0 as heuresupferie,0 as heuresupweekend,0 as absence "
                    + "FROM LOG_PERSONNEL_INFOPOINTAGE info "
                    + "where (info.date_depart is null "
                    + "or info.date_depart >= to_date('"+datedebut+"','YYYY-MM-DD')) AND info.dateembauche <= to_date('"+datefin+"','YYYY-MM-DD') and info.id!='1002067' "
                    + "AND info.direction = '" + direction + "' "
                    + " "+awere +" "
                    + "and info.matricule like '%" + matricule + "%' "
                    + "AND not exists "
                    + "   (select * from pointage "
                    + "     where idpersonnel = info.id and mois = ? and annee = ?)";
          
            System.out.println("where1 = " + where1);
          
          String where2 = "SELECT pt.id as id, pt.idpersonnel, info.matricule, info.nom, info.prenom,info.direction,"
                    + "pt.mois, pt.annee, "
                    + "pt.heurenormal, pt.heuresupnormal, pt.heuresupnuit, pt.heuresupferie, pt.heuresupweekend, pt.absence "
                    + "FROM pointage pt, LOG_PERSONNEL_INFOPOINTAGE info "
                    + "where (info.date_depart is null "
                    + "or info.date_depart >= to_date('"+datedebut+"','YYYY-MM-DD')) AND info.dateembauche <= to_date('"+datefin+"','YYYY-MM-DD') AND pt.IDPERSONNEL = info.ID and info.id!='1002067' "
                    + "AND info.direction = '" + direction + "' "
                    + "AND info.matricule like '%" + matricule + "%' "
                    + " "+awere +" "
                    + "AND pt.mois = ? and pt.annee = ?";
            System.out.println("where2 = " + where2);
            //System.out.println("REQUET = "+"SELECT * FROM ((" + where1 + ") UNION (" + where2 + ")) order by matricule asc");
          prstmt = c.prepareStatement("SELECT * FROM ((" + where1 + ") UNION (" + where2 + ")) order by matricule asc");
            prstmt.setString(1, mois);
            prstmt.setString(2, annee);
            prstmt.setString(3, mois);
            prstmt.setString(4, annee);
            ResultSet rst = prstmt.executeQuery();
            System.out.println("APRES OOOO");
          while (rst.next()) {
              System.out.println("ato manombok 1");
                Pointage tmp = new Pointage();
                tmp.setId(rst.getString("id"));
                tmp.setIdPersonnel(rst.getString("idpersonnel"));
                tmp.setDirection(rst.getString("direction"));
                tmp.setMatricule(rst.getString("matricule"));
                tmp.setNom(rst.getString("nom"));
                tmp.setPrenom(rst.getString("prenom"));
                tmp.setMois(rst.getInt("mois"));
                tmp.setAnnee(rst.getInt("annee"));
                tmp.setHeureNormal(rst.getDouble("heurenormal"));
                tmp.setHeureSupNormal(rst.getDouble("heuresupnormal"));
                tmp.setHeureSupFerie(rst.getDouble("heuresupferie"));
                tmp.setHeureSupNuit(rst.getDouble("heuresupnuit"));
                tmp.setHeureSupWeekend(rst.getDouble("heuresupweekend"));
                tmp.setAbsence(rst.getDouble("absence"));
                System.out.println("ato mifarana 2");
                ret.add(tmp);
            }
          Pointage[] li = ret.toArray(new Pointage[0]);
          return li;
        }catch(Exception e){
          e.printStackTrace();
          throw e;
        }finally {
            if (c != null) {
                c.close();
            }
        }
    }
    
    public static void enregistrerPointageVisee(HttpServletRequest request, UserEJB u)throws Exception{
      Connection c = null;
      try{
        c = new UtilDB().GetConn();
        c.setAutoCommit(false);
        
        int taille = Integer.valueOf(request.getParameter("taille"));
        int mois = Integer.valueOf(request.getParameter("moisp"));
        int annee = Integer.valueOf(request.getParameter("annee"));
        String direction = request.getParameter("direction");
        
        for (int i = 0; i < taille; i++) {
            String idpersonnel = request.getParameter("idPersonnel" + i);
            String heurenormal = request.getParameter("heurenormal" + i);
            String heuresupnormal = request.getParameter("heuresupnormal" + i);
            String heuresupnuit = request.getParameter("heuresupnuit" + i);
            String heuresupferie = request.getParameter("heuresupferie" + i);
            String heuresupweekend = request.getParameter("heuresupweekend" + i);
            String absence = request.getParameter("absence" + i);
            
            Pointage pv = new Pointage();
            pv.setMois(mois);
            pv.setAnnee(annee);
            pv.setIdPersonnel(idpersonnel);
            pv.setDirection(direction);
            
            
            System.out.println("idpersonnel = " + idpersonnel);
            System.out.println("mois = " + mois);
            System.out.println("annee = " + annee);
            System.out.println("direction = " + direction);

            System.out.println("heurenormal = " + heurenormal);
            System.out.println("heuresupnormal = " + heuresupnormal);
            System.out.println("heuresupnuit = " + heuresupnuit);
            System.out.println("heuresupferie = " + heuresupferie);
            System.out.println("heuresupweekend = " + heuresupweekend);
            System.out.println("absence = " + absence);
      
            Pointage[] liste = (Pointage[])CGenUtil.rechercher(new Pointage(), null, null, c, " and idpersonnel = '"+idpersonnel+"' and mois=" + mois + " and annee=" + annee + " and direction='" + direction + "'");
            if(liste.length>0){
                System.out.println("nahita");
                pv=liste[0];
                pv.setHeureNormal(Double.valueOf(heurenormal));
                pv.setHeureSupNormal(Double.valueOf(heuresupnormal));
                pv.setHeureSupNuit(Double.valueOf(heuresupnuit));
                pv.setHeureSupFerie(Double.valueOf(heuresupferie));
                pv.setHeureSupWeekend(Double.valueOf(heuresupweekend));
                pv.setAbsence(Double.valueOf(absence));
                System.out.println(" --------------------- " + liste.length + " " + pv.getId() + " " + pv.getIdPersonnel() +  " " + mois + " " + annee);
                pv.updateToTable(c);
            }else{
                System.out.println("tsy nahita");
                pv.setHeureNormal(Double.valueOf(heurenormal));
                pv.setHeureSupNormal(Double.valueOf(heuresupnormal));
                pv.setHeureSupNuit(Double.valueOf(heuresupnuit));
                pv.setHeureSupFerie(Double.valueOf(heuresupferie));
                pv.setHeureSupWeekend(Double.valueOf(heuresupweekend));
                pv.setAbsence(Double.valueOf(absence));
                pv.setEtat(ConstanteEtat.getEtatCreer());
                pv.construirePK(c);
                pv.insertToTableWithHisto(u.getUser().getTuppleID(), c);
            }
        }
        c.commit();
      } catch (Exception e) {
          e.printStackTrace();
          throw e;
      } finally{
        if(c!=null){
          c.close();
        }
      }
    }
    
    public void viserPointageVisee(String[] idobjet) throws Exception {
        Connection conn = null;
        try {
            conn = new UtilDB().GetConn();
            conn.setAutoCommit(false);

            for (int a = 0; a < idobjet.length; a++) {
                viserPointageVisee(idobjet[a], conn);
            }
            conn.commit();
        } catch (Exception e) {
            e.printStackTrace();
            if (conn != null) {
                conn.rollback();
            }
            throw e;
        } finally {
            if (conn != null) {
                conn.close();
            }
        }
    }
    
        public void viserPointageVisee(String id, Connection connection) throws Exception {
        try {
            Pointage p = new Pointage();
            Pointage[] rec = (Pointage[]) CGenUtil.rechercher(p, null, null, connection," and ID = '" + id + "' and etat=1");
            System.out.println("----------ID A VISER: " + id);
            if (rec == null || rec.length == 0) {
                throw new Exception("PointageVisee non existante");
            }

            for (int i = 0; i < rec.length; i++) {
                Pointage pointage_personnel = rec[i];
                pointage_personnel.setEtat(ConstanteEtat.getEtatValider());
                pointage_personnel.updateToTable(connection);
            }

        } catch (Exception e) {
            connection.rollback();
            throw e;
        }
    }
}
