/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.archive;

import bean.ClassMAPTable;

import java.sql.Connection;
import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author Finaritra
 */

public class PaieArchive extends ClassMAPTable {

    private String id, idPersonnel, fonction;
    private int mois, annee;
    private double montant;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdPersonnel() {
        return idPersonnel;
    }

    public void setIdPersonnel(String idPersonnel) {
        this.idPersonnel = idPersonnel;
    }

    public String getFonction() {
        return fonction;
    }

    public void setFonction(String fonction) {
        this.fonction = fonction;
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

    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant) {
        this.montant = montant;
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
        this.preparePk("ARCH", "GETSEQPAIE_Archive");
        this.setId(makePK(c));
    }

    public PaieArchive() {
        this.setNomTable("paie_archive");
    }
    
    //MAP <Ann�e , Droit>
    public static Map<Integer,PaieArchive> convertTabPaieArchiveToMap(PaieArchive[] tab)throws Exception{
        Map<Integer,PaieArchive> retour = null;
        try{
            retour = new HashMap<Integer,PaieArchive>();
            if(tab.length>0){
                for(int i = 0;i<tab.length;i++){
                    retour.put(tab[i].getAnnee(), tab[i]);
                }
            }
        }catch(Exception e){
            e.printStackTrace();
            throw e;
        }
        return retour;
    }
}

