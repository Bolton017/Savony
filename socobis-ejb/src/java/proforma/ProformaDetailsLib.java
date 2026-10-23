package proforma;

import vente.BonDeCommandeFIlleCpl;

public class ProformaDetailsLib extends ProformaDetails{
    private String idProformaLib,idProduitLib;
    private double puTotal,remisemontant,montanttotal, montanttva, montantttc, montantristourne, fraislivraison, fraistransport;
    private String uniteLib,reference, categorieingredient;
    private double punet, montantht;
    private double calorie, poidsparkilo, poidstotal;

    public double getPunet() {
        return punet;
    }

    public void setPunet(double punet) {
        this.punet = punet;
    }

    public double getMontantht() {
        return montantht;
    }

    public void setMontantht(double montantht) {
        this.montantht = montantht;
    }

    public double getPoidsparkilo() {
        return poidsparkilo;
    }

    public void setPoidsparkilo(double poidsparkilo) {
        this.poidsparkilo = poidsparkilo;
    }

    public double getPoidstotal() {
        return poidstotal;
    }

    public void setPoidstotal(double poidstotal) {
        this.poidstotal = poidstotal;
    }
    public String getCategorieingredient() {
        return categorieingredient;
    }

    public void setCategorieingredient(String categorieingredient) {
        this.categorieingredient = categorieingredient;
    }

    private String idDevis, image;
    public ProformaDetailsLib()throws Exception {
        this.setNomTable("PROFORMADETAILS_CPL");
    }

    public double getMontantttc() {
        return montantttc;
    }

    public double getFraistransport() {
        return fraistransport;
    }

    public void setFraistransport(double fraistransport) {
        this.fraistransport = fraistransport;
    }

    public void setMontantttc(double montantttc) {
        this.montantttc = montantttc;
    }

    public double getMontanttva() {
        return montanttva;
    }

    public void setMontanttva(double montanttva) {
        this.montanttva = montanttva;
    }

    public double getMontanttotal() {
        return montanttotal;
    }

    public void setMontanttotal(double montanttotal) {
        this.montanttotal = montanttotal;
    }

    public double getRemisemontant() {
        return remisemontant;
    }

    public void setRemisemontant(double remisemontant) {
        this.remisemontant = remisemontant;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String getUniteLib() {
        return uniteLib;
    }

    public void setUniteLib(String uniteLib) {
        this.uniteLib = uniteLib;
    }

    public String getIdProformaLib() {
        return idProformaLib;
    }

    public void setIdProformaLib(String idProformaLib) {
        this.idProformaLib = idProformaLib;
    }

    public String getIdProduitLib() {
        return idProduitLib;
    }

    public void setIdProduitLib(String idProduitLib) {
        this.idProduitLib = idProduitLib;
    }

    public double getPuTotal() {
        return puTotal;
    }

    public void setPuTotal(double puTotal) {
        this.puTotal = puTotal;
    }

    public String getIdDevis() {
        return idDevis;
    }

    public void setIdDevis(String idDevis) {
        this.idDevis = idDevis;
    }

    public String getReference() {
        return reference;
    }

    public void setReference(String reference) {
        this.reference = reference;
    }

    public double getMontantristourne() {
        return montantristourne;
    }

    public void setMontantristourne(double montantristourne) {
        this.montantristourne = montantristourne;
    }

    public double getFraislivraison() {
        return fraislivraison;
    }

    public void setFraislivraison(double fraislivraison) {
        this.fraislivraison = fraislivraison;
    }

    public BonDeCommandeFIlleCpl createBonDeCommandeFilleLib() throws Exception {
        try {
            BonDeCommandeFIlleCpl ligne = new BonDeCommandeFIlleCpl();

            ligne.setProduit(this.getIdProduit());
            ligne.setQuantite(this.getQte());
            ligne.setPu(this.getPu());
            ligne.setTva(this.getTva());
            ligne.setIdDevise(this.getIdDevise());
            ligne.setUnite(this.getUnite());
            ligne.setUniteLib(this.getUniteLib());
            ligne.setDesignation(this.getDesignation());
            ligne.setRemise(this.getRemise());
            ligne.setMontantht((this.getPu() - (this.getPu() * this.getRemise() / 100)) * this.getQte());
            ligne.setPunet(this.getPu() - (this.getPu() * this.getRemise() / 100) + ((this.getPu() * this.getTva() / 100)));
            ligne.setMontantttc(this.getMontantttc());
            ligne.setRistourne(getRistourne());
            ligne.setIdDevise(this.getIdDevise());
            ligne.setTauxdechange(this.getTauxDeChange());
            return ligne;
        }catch(Exception ex) {
            ex.printStackTrace();
            throw ex;
        }

    }

    public double getCalorie() {
        return calorie;
    }

    public void setCalorie(double calorie) {
        this.calorie = calorie;
    }
}
