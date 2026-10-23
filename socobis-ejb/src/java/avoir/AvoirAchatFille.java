package avoir;

import bean.ClassFille;
import java.sql.Connection;

public class AvoirAchatFille extends ClassFille {

    String id;
    String idMere;
    String idProduit;
    double qte;
    double pu;
    double remise;
    double tva;
    String idDevise;
    double taux;
    String designation;
    String idFactureDetails;
    String compte;

    @Override
    public String getLiaisonMere() {
        return "idMere";
    }

    @Override
    public String getNomClasseMere() {
        return "avoir.AvoirAchat";
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    public AvoirAchatFille() throws Exception {
        this.setNomTable("AVOIRACHATFILLE");
        this.setLiaisonMere("idMere");
        this.setNomClasseMere("avoir.AvoirAchat");
    }
    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("AVRACF", "GETSEQ_AVOIRACHATFILLE");
        this.setId(makePK(c));
    }

    public AvoirAchatFille(String nomTable) {
        setNomTable(nomTable);
    }

    public double getTaux() {
        return taux;
    }

    public void setTaux(double taux) {
        this.taux = taux;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
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

    public double getRemise() {
        return remise;
    }

    public void setRemise(double remise) {
        this.remise = remise;
    }

    public double getTva() {
        return tva;
    }

    public void setTva(double tva) {
        this.tva = tva;
    }

    public String getDesignation() {
        return designation;
    }

    public void setDesignation(String designation) {
        this.designation = designation;
    }

    public String getIdMere() {
        return idMere;
    }

    public void setIdMere(String idMere) {
        this.idMere = idMere;
    }

    public String getIdProduit() {
        return idProduit;
    }

    public void setIdProduit(String idProduit) {
        this.idProduit = idProduit;
    }

    public String getIdDevise() {
        return idDevise;
    }

    public void setIdDevise(String idDevise) {
        this.idDevise = idDevise;
    }

    public String getIdFactureDetails() {
        return idFactureDetails;
    }

    public void setIdFactureDetails(String idFactureDetails) {
        this.idFactureDetails = idFactureDetails;
    }

    public String getCompte() {
        return compte;
    }

    public void setCompte(String compte) {
        this.compte = compte;
    }
}
