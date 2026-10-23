/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.conge;

import bean.CGenUtil;
import bean.ClassEtat;
import bean.ClassMAPTable;
import java.sql.Connection;
import java.sql.Date;
import java.sql.SQLException;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;

/**
 *
 * @author Tsiky
 */
public class Conge  extends ClassEtat {
    String id;
    String matricule;
    String nom;
    String prenom;
    Date dateembauche;
    Date date_depart;
    double conge_2023;
    double congedroit;
    double congepris;
    double congereste;
    Date daty;

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }
    
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getMatricule() {
        return matricule;
    }

    public void setMatricule(String matricule) {
        this.matricule = matricule;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getPrenom() {
        return prenom;
    }

    public void setPrenom(String prenom) {
        this.prenom = prenom;
    }

    public Date getDateembauche() {
        return dateembauche;
    }

    public void setDateembauche(Date dateembauche) {
        this.dateembauche = dateembauche;
    }

    public Date getDate_depart() {
        return date_depart;
    }

    public void setDate_depart(Date date_depart) {
        this.date_depart = date_depart;
    }

    public double getConge_2023() {
        return conge_2023;
    }

    public void setConge_2023(double conge_2023) {
        this.conge_2023 = conge_2023;
    }

    public double getCongedroit() {
        return congedroit;
    }

    public void setCongedroit(double congedroit) {
        this.congedroit = congedroit;
    }

    public double getCongepris() {
        return congepris;
    }

    public void setCongepris(double congepris) {
        this.congepris = congepris;
    }

    public double getCongereste() {
        return congereste;
    }

    public void setCongereste(double congereste) {
        this.congereste = congereste;
    }

    public Conge() {
        setNomTable("demande");
    }
    
    @Override
    public String getTuppleID() {
        return getId();
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }
    
    
    public Conge[] getCongeByDate(String idpers) throws SQLException, Exception{
        int verif =0;
        String request ="";
        Connection con = null;
        try{
            con =new UtilDB().GetConn();
            request = this.requestConge(this.getDaty(),idpers);
            Conge[] liste = (Conge[]) CGenUtil.rechercher(this,request, con);
            return liste;  
        }catch(Exception e){
            throw e;
        }finally{
           con.close();
        }
    }
    
    public String requestConge(Date recherche,String idpersonnel){
        String pers = (idpersonnel != null) ? " where cd.id = '" + idpersonnel + "'" : "";
        recherche=  (recherche!= null) ? recherche : Utilitaire.dateDuJourSql();
        String request = "SELECT cd.*, lp.nom AS nom, lp.prenom AS prenom, " +
                "ROUND(((MONTHS_BETWEEN(TO_DATE('" + recherche + "', 'YYYY/MM/DD'), NVL(cd.date_depart, cd.dateembauche)) * 2.5) + cd.conge_2023), 2) AS congedroit, " +
                "ROUND(NVL(cm.duree, 0), 2) AS congepris, " +
                "ROUND(((MONTHS_BETWEEN(TO_DATE('" + recherche + "', 'YYYY/MM/DD'), NVL(cd.date_depart, cd.dateembauche)) * 2.5) + cd.conge_2023 - NVL(cm.duree, 0)), 2) AS congereste " +
                "FROM conge_fin2023 cd " +
                "LEFT JOIN (SELECT idpersonnel, matricule, SUM(duree) AS duree " +
                "           FROM demande_libcomplet_final dlf " +
                "           WHERE datedepart <= TO_DATE('" + recherche + "', 'YYYY/MM/DD') " +
                "           GROUP BY idpersonnel, matricule) cm ON cm.idpersonnel = cd.id " +
                "LEFT JOIN log_personnel lp ON lp.id = cd.id " + pers + " " +
                "ORDER BY cm.matricule ASC";
        System.out.println("request==>"+request);
        return request;
    }
    
}
