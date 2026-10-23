/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie;

import bean.CGenUtil;
import bean.ClassEtat;
import bean.ClassMAPTable;
import java.sql.Connection;
import java.sql.Date;
import paie.employe.PaieInfoPersonnel;
/**
 *
 * @author Sanda
 */
public class CategorieQualification extends ClassEtat {
    private String id,idcategorie,idqualification,remarque;
    private double montant;
    private Date date_debut, date_fin;
    private String etatlibelle,etatval;
    private String matricule;
    private String prenom;
    public int avenant;
    private String nomCpl;

    public int getAvenant() {
        return avenant;
    }

    public void setAvenant(int avenant) {
        this.avenant = avenant;
    }
    
    
    public String getPrenom() {
        return prenom;
    }
    
    public void setPrenom(String prenom) {
        this.prenom = prenom;
    }
    

    public String getEtatval() {
        return etatval;
    }

    public void setEtatval(String etatval) {
        this.etatval = etatval;
    }
    
        public String getMatricule() {
        return matricule;
    }

    public void setMatricule(String matricule) {
        this.matricule = matricule;
    }

    public Date getDate_debut() {
        return date_debut;
    }

    public void setDate_debut(Date date_debut) {
        this.date_debut = date_debut;
    }

    public Date getDate_fin() {
        return date_fin;
    }

    public void setDate_fin(Date date_fin) {
        this.date_fin = date_fin;
    }

    public String getEtatlibelle() {
        return etatlibelle;
    }

    public void setEtatlibelle(String etatlibelle) {
        this.etatlibelle = etatlibelle;
    }
    
    
    
    
    public Date GetDate_debut() {
        return this.date_debut;
    }
    
    public void SetDate_debut(Date date_debut){
        this.date_debut=date_debut;
    }
    
    
    public Date GetDate_fin() {
        return this.date_fin;
    }

        public void SetDate_fin(Date date_fin){
        this.date_fin=date_fin;
    }
    
    
    
    @Override
    public String getValColLibelle(){
        return this.getIdcategorie() + " " + this.getIdqualification();
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
        this.preparePk("CQ", "get_seq_categorie_qualif");
        this.setId(makePK(c));
    }
    public CategorieQualification(){
        super.setNomTable("categorie_qualification");
    }
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdcategorie() {
        return idcategorie;
    }

    public void setIdcategorie(String idcategorie) {
        this.idcategorie = idcategorie;
    }

    public String getIdqualification() {
        return idqualification;
    }

    public void setIdqualification(String idqualification) {
        this.idqualification = idqualification;
    }

    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }

     @Override
    public String[] getMotCles() {
        String[] motCles={"id","IDCATEGORIE","IDQUALIFICATION"};
        return motCles;
    }

    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {
        try {
            PaieInfoPersonnel info = new PaieInfoPersonnel();
            info.setNomTable("paie_info_personnel");
            info.setIdpersonnel(this.getRemarque());
            PaieInfoPersonnel[] pinfo = (PaieInfoPersonnel[]) CGenUtil.rechercher(info, null, null, c, "");
            this.setIdcategorie(pinfo[0].getIdcategorie_paie());
            this.setIdqualification(pinfo[0].getIdqualification());
        } catch (Exception e) {
            e.printStackTrace();
            if (c != null) {
                c.rollback();
            }
        }
        return super.createObject(u, c);
    }


    public String getNomCpl() {
        return nomCpl;
    }

    public void setNomCpl(String nomCpl) {
        this.nomCpl = nomCpl;
    }
}
