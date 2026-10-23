/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.conge;

import bean.ClassEtat;
import utilitaire.UtilDB;

import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author ASUS
 */

public class CongeDroit extends ClassEtat {

    private String id, idpersonnel,idpersonnellib, matricule, etatlib;
    private int annee;
    private double nombre, salaire_annuel;
    private int nombre_mois;
    private int mois;
    private double conge;

    public String getEtatlib() {
        return etatlib;
    }

    public void setEtatlib(String etatlib) {
        this.etatlib = etatlib;
    }

    public String getMatricule() {
        return matricule;
    }

    public void setMatricule(String matricule) {
        this.matricule = matricule;
    }
    
    public String getIdpersonnellib() {
        return idpersonnellib;
    }

    public CongeDroit(String idpersonnel, int annee, int mois, double conge) {
         setNomTable("conge_droit");
        this.setIdpersonnel(idpersonnel);
        this.setAnnee(annee);
        this.setMois(mois);
        this.setConge(conge);
    }
 
 

    public void setIdpersonnellib(String idpersonnellib) {
        this.idpersonnellib = idpersonnellib;
    }
    public CongeDroit() {
        setNomTable("conge_droit");
    }

    public double getNombre() {
        return nombre;
    }

    public void setNombre(double nombre) {
        this.nombre = nombre;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdpersonnel() {
        return idpersonnel;
    }

    public void setIdpersonnel(String idpersonnel) {
        this.idpersonnel = idpersonnel;
    }

    public int getMois() {
        return mois;
    }

    public void setMois(int mois) {
        this.mois = mois;
    }

    public int getAnnee() {
        return annee;
    }

    public void setAnnee(int annee) {
        this.annee = annee;
    }

    public double getConge() {
        return conge;
    }

    public void setConge(double conge) {
        this.conge = conge;
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("COND", "GET_SEQ_CONGEDROIT");
        this.setId(makePK(c));
    }

    public double getSalaire_annuel() {
        return salaire_annuel;
    }

    public void setSalaire_annuel(double salaire_annuel) {
        this.salaire_annuel = salaire_annuel;
    }

    public int getNombre_mois() {
        return nombre_mois;
    }

    public void setNombre_mois(int nombre_mois) {
        this.nombre_mois = nombre_mois;
    }

    public static  CongeDroit[] insertCongeDroit(double nbconge,int moisDeb,int moisFin,int annee,String[] personnel,String iduser,Connection c)throws Exception{
        int indice = 0;
        CongeDroit[] retour = null;
        List<CongeDroit> liste = null;
        try{
            if(c==null){
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
                indice = 1;
            }
            liste = new ArrayList<CongeDroit>();
            if(personnel!=null && personnel.length>0){
                for(int i = moisDeb;i<=moisFin;i++){
                    for(int j= 0;j<personnel.length;j++){
                        CongeDroit temp = new CongeDroit(personnel[j], annee, i, nbconge);
                        temp.construirePK(c);
                        temp.insertToTableWithHisto(iduser, c);
                        liste.add(temp);
                    }
                }
                retour = new CongeDroit[liste.size()];
                retour = liste.toArray(retour);
            }
            if(indice == 1)c.commit();
        }catch(Exception e){
            c.rollback();
            e.printStackTrace();
            throw e;
        }finally{
            if(c!=null && indice == 1)c.close();
        }
        return retour;
    }
   
    
}

