/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package avoir;

import bean.ClassFille;
import produits.Ingredients;

import java.sql.Connection;
/**
 *
 * @author randr
 */
public class AvoirFCFille extends ClassFille {

    String id;
    String idAvoirFC;
    String idProduit;
    String idOrigine;
    double qte;
    double pu;
    double remise;
    double tva;
    double puAchat;
    double puVente;
    String idDevise;
    double tauxDeChange;
    String designation;
    String idVenteDetails;
    String compte;
    double montantht, montanttva, montantttc;
    double montanthtar, montanttvaar, montantttcar;
    double taux;

    public double getTaux() {
        return taux;
    }

    public void setTaux(double taux) {
        this.taux = taux;
    }

    public AvoirFCFille() throws Exception{
        this.setNomTable("AvoirFCFille");
        this.setLiaisonMere("idAvoirFC");
        super.setNomClasseMere("avoir.AvoirFC");
    }

    public AvoirFCFille(String nomtable)throws Exception{
        this.setNomTable(nomtable);
        this.setLiaisonMere("idAvoirFC");
        super.setNomClasseMere("avoir.AvoirFC");
    }
    public  String getNomClasseMere() {
        return "avoir.AvoirFC";
    }



    /**
     * Avoir le champs de liaison entre fille et mère
     * @return le champs de liaison
     */
    public String getLiaisonMere() {
        return "idAvoirFC";
    }
    public String getIdAvoirFC() {
        return idAvoirFC;
    }

    public void setIdAvoirFC(String idAvoirFC) {
        this.idAvoirFC = idAvoirFC;
    }

    public String getIdProduit() {
        return idProduit;
    }

    public void setIdProduit(String idProduit) {
        this.idProduit = idProduit;
    }

    public String getIdOrigine() {
        return idOrigine;
    }

    public void setIdOrigine(String idOrigine) {
        this.idOrigine = idOrigine;
    }

    public double getQte() {
        return qte;
    }

    public void setQte(double qte) throws Exception {
        if (this.getMode().equals("modif") && qte <= 0) {
            throw new Exception("La quantit\\u00E9 doit \\u00EAtre sup\\u00E9rieure \\u00E0 0");
        }
        this.qte = qte;
    }

    public double getPu() {
        return pu;
    }

    public void setPu(double pu) throws Exception {
        if (this.getMode().equals("modif") && pu < 0) {
            throw new Exception("Pu ne peut pas &ecirc;tre inf&eacute;rieur &agrave; 0");
        }
        this.pu = pu;
    }

    public double getRemise() {
        return remise;
    }

    public void setRemise(double remise) throws Exception {
        if (this.getMode().equals("modif") && (remise > 100 || remise < 0)) {
            throw new Exception("Remise invalide : elle doit \\u00EAtre comprise entre 0 et 100");
        }
        this.remise = remise;
    }

    public double getTva() {
        return tva;
    }

    public void setTva(double tva) throws Exception {
        if (this.getMode().equals("modif") && (tva > 100 || tva < 0)) {
            throw new Exception("TVA invalide : elle doit \\u00EAtre comprise entre 0 et 100");
        }
        this.tva = tva;
    }

    public double getPuAchat() {
        return puAchat;
    }

    public void setPuAchat(double puAchat) {
        this.puAchat = puAchat;
    }

    public double getPuVente() {
        return puVente;
    }

    public void setPuVente(double puVente) {
        this.puVente = puVente;
    }

    public String getIdDevise() {
        return idDevise;
    }

    public void setIdDevise(String idDevise) {
        this.idDevise = idDevise;
    }

    public double getTauxDeChange() {
        return tauxDeChange;
    }

    public void setTauxDeChange(double tauxDeChange) {
        this.tauxDeChange = tauxDeChange;
    }

    public String getDesignation() {
        return designation;
    }

    public void setDesignation(String designation) {
        this.designation = designation;
    }

    public String getIdVenteDetails() {
        return idVenteDetails;
    }

    public void setIdVenteDetails(String idVenteDetails) {
        this.idVenteDetails = idVenteDetails;
    }

    public String getCompte() {
        return compte;
    }

    public String getCompteRistourne(Connection c) throws Exception {
        try {
            Ingredients ing = (Ingredients) new Ingredients().getById(this.getIdProduit(),"AS_INGREDIENTS",c);
            if(ing!=null && ing.getCompte_ristourne()!=null && !ing.getCompte_ristourne().trim().isEmpty()){
                return ing.getCompte_ristourne();
            }
        }catch (Exception ex){
            throw ex;
        }
        return compte;
    }

    public void setCompte(String compte) {
        this.compte = compte;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public double getMontantht() {
        return montantht;
    }

    public void setMontantht(double montantht) {
        this.montantht = montantht;
    }

    public double getMontanttva() {
        return montanttva;
    }

    public void setMontanttva(double montanttva) {
        this.montanttva = montanttva;
    }

    public double getMontantttc() {
        return montantttc;
    }

    public void setMontantttc(double montantttc) {
        this.montantttc = montantttc;
    }

    public double getMontanthtar() {
        return montanthtar;
    }

    public void setMontanthtar(double montanthtar) {
        this.montanthtar = montanthtar;
    }

    public double getMontanttvaar() {
        return montanttvaar;
    }

    public void setMontanttvaar(double montanttvaar) {
        this.montanttvaar = montanttvaar;
    }

    public double getMontantttcar() {
        return montantttcar;
    }

    public void setMontantttcar(double montantttcar) {
        this.montantttcar = montantttcar;
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
        this.preparePk("AVRFCF", "GETSEQAVOIRFCFILLE");
        this.setId(makePK(c));
    }
}
