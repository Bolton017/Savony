package faturefournisseur.proforma;

public class ProformaFournisseurCpl extends ProformaFournisseur{
    private String etatlib;
    private String modepaiementlib;
    private String fournisseurlib;
    private double montantTVA;
    private double montantHT;
    private double montantTTC;
    private double montantTTCARIARY;
    private String idDeviselib;

    public ProformaFournisseurCpl() throws Exception {
        this.setNomTable("proformafournisseur_merecpl");
    }

    public String getEtatlib() {
        return etatlib;
    }

    public void setEtatlib(String etatlib) {
        this.etatlib = etatlib;
    }

    public String getModepaiementlib() {
        return modepaiementlib;
    }

    public void setModepaiementlib(String modepaiementlib) {
        this.modepaiementlib = modepaiementlib;
    }

    public String getFournisseurlib() {
        return fournisseurlib;
    }

    public void setFournisseurlib(String fournisseurlib) {
        this.fournisseurlib = fournisseurlib;
    }

    public double getMontantTVA() {
        return montantTVA;
    }

    public void setMontantTVA(double montantTVA) {
        this.montantTVA = montantTVA;
    }

    public double getMontantHT() {
        return montantHT;
    }

    public void setMontantHT(double montantHT) {
        this.montantHT = montantHT;
    }

    public double getMontantTTC() {
        return montantTTC;
    }

    public void setMontantTTC(double montantTTC) {
        this.montantTTC = montantTTC;
    }

    public double getMontantTTCARIARY() {
        return montantTTCARIARY;
    }

    public void setMontantTTCARIARY(double montantTTCARIARY) {
        this.montantTTCARIARY = montantTTCARIARY;
    }

    public String getIdDeviselib() {
        return idDeviselib;
    }

    public void setIdDeviselib(String idDeviselib) {
        this.idDeviselib = idDeviselib;
    }
}
