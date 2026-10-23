package paie.categorie;

import bean.ClassMAPTable;

import java.sql.Connection;
import java.sql.Date;

public class SalaireCategorie extends ClassMAPTable{

    private String id;
    private String idCategorie;
    private String idQualification;
    private Date date_debut;
    private Date date_fin;
    private double montant;
    private String categorie_libelle;
    private String qualification_libelle;

    
    public SalaireCategorie() throws Exception{
        this.setNomTable("CATEGORIE_QUALIFICATION");
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
        this.preparePk("CATQLTIT", "GET_SEQ_CATEGORIE_QUALIF");
        this.setId(makePK(c));
    }
    public String getCategorie_libelle() {
        return this.categorie_libelle;
    }

    public void setCategorie_libelle(String categorie_libelle) {
        this.categorie_libelle = categorie_libelle;
    }

    public String getQualification_libelle() {
        return this.qualification_libelle;
    }

    public void setQualification_libelle(String qualification_libelle) {
        this.qualification_libelle = qualification_libelle;
    }

    public String getId() {
        return this.id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdCategorie() {
        return this.idCategorie;
    }

    public void setIdCategorie(String idCategorie) {
        this.idCategorie = idCategorie;
    }

    public String getIdQualification() {
        return this.idQualification;
    }

    public void setIdQualification(String idQualification) {
        this.idQualification = idQualification;
    }

    public Date getDate_debut() {
        return this.date_debut;
    }

    public void setDate_debut(Date date_debut) {
        this.date_debut = date_debut;
    }

    public Date getDate_fin() {
        return this.date_fin;
    }

    public void setDate_fin(Date date_fin) {
        this.date_fin = date_fin;
    }

    public double getMontant() {
        return this.montant;
    }

    public void setMontant(double montant) {
        this.montant = montant;
    }

    
}
