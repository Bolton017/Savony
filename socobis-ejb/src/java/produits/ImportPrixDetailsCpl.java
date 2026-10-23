package produits;

public class ImportPrixDetailsCpl extends ImportPrixDetails{
    private String libelle;
    private double grammage;
    private double quantiteParPack;
    private double poids;
    private double ptHT;
    private double ptTTC;
    private double puHtMorceau;
    private double puTTCMorceau;
    private String typeclientLib;
    private String unitemorceau;

    public String getUnitemorceau() {
        return unitemorceau;
    }

    public void setUnitemorceau(String unitemorceau) {
        this.unitemorceau = unitemorceau;
    }

    public String getTypeclientLib() {
        return typeclientLib;
    }

    public void setTypeclientLib(String typeclientLib) {
        this.typeclientLib = typeclientLib;
    }

    public String getLibelle() {
        return libelle;
    }

    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }

    public double getGrammage() {
        return grammage;
    }

    public void setGrammage(double grammage) {
        this.grammage = grammage;
    }

    public double getQuantiteParPack() {
        return quantiteParPack;
    }

    public void setQuantiteParPack(double quantiteParPack) {
        this.quantiteParPack = quantiteParPack;
    }

    public double getPoids() {
        return poids;
    }

    public void setPoids(double poids) {
        this.poids = poids;
    }

    public double getPtHT() {
        return ptHT;
    }

    public void setPtHT(double ptHT) {
        this.ptHT = ptHT;
    }

    public double getPtTTC() {
        return ptTTC;
    }

    public void setPtTTC(double ptTTC) {
        this.ptTTC = ptTTC;
    }

    public double getPuHtMorceau() {
        return puHtMorceau;
    }

    public void setPuHtMorceau(double puHtMorceau) {
        this.puHtMorceau = puHtMorceau;
    }

    public double getPuTTCMorceau() {
        return puTTCMorceau;
    }

    public void setPuTTCMorceau(double puTTCMorceau) {
        this.puTTCMorceau = puTTCMorceau;
    }

    public ImportPrixDetailsCpl() throws Exception {
        this.setNomTable("import_ing_details");
    }
}
