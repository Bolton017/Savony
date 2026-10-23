package calculBesoin;

import bean.ClassMAPTable;
import java.sql.Connection;

public class ResultatCalculBesoins extends ClassMAPTable {
    private String idmere;
    private String idingredients;
    private String libelle;
    private String unite;
    private double pu;
    private double qte;
    private double qteStock;
    private double qteAchete;
    private double montant;
    private double montantStock;
    private double montantAchete;

    public String getIdmere() {
        return idmere;
    }

    public void setIdmere(String idmere) {
        this.idmere = idmere;
    }

    public String getIdingredients() {
        return idingredients;
    }

    public void setIdingredients(String idingredients) {
        this.idingredients = idingredients;
    }

    public String getLibelle() {
        return libelle;
    }

    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }

    public String getUnite() {
        return unite;
    }

    public void setUnite(String unite) {
        this.unite = unite;
    }

    public double getQte() {
        return qte;
    }

    public void setQte(double qte) {
        this.qte = qte;
    }

    public double getPu() {
        return pu;
    }

    public void setPu(double pu) {
        this.pu = pu;
    }

    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant) {
        this.montant = montant;
    }



    public ResultatCalculBesoins() throws Exception {
        this.setNomTable("RESULTATCALCULBESOINS");
    }



    @Override
    public String getTuppleID() {
        return idmere;
    }

    @Override
    public String getAttributIDName() {
        return "idmere";
    }

    public double getMontantAchete() {
        return montantAchete;
    }

    public void setMontantAchete(double montantAchete) {
        this.montantAchete = montantAchete;
    }

    public double getMontantStock() {
        return montantStock;
    }

    public void setMontantStock(double montantStock) {
        this.montantStock = montantStock;
    }

    public double getQteAchete() {
        return qteAchete;
    }

    public void setQteAchete(double qteAchete) {
        this.qteAchete = qteAchete;
    }

    public double getQteStock() {
        return qteStock;
    }

    public void setQteStock(double qteStock) {
        this.qteStock = qteStock;
    }
}

