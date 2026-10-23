package besoin;

import java.sql.Date;

public class BesoinFabricationDetailsCPL extends BesoinFabricationDetails{

    String idProduitLib;
    String uniteLib;
    Date daty;
    int mois;
    String moisLib;
    int annee;
    String moisanneeLib;
    double qte_ordre,qte_fabrique;


    public String getMoisanneeLib() {
        return moisanneeLib;
    }

    public void setMoisanneeLib(String moisanneeLib) {
        this.moisanneeLib = moisanneeLib;
    }

    public int getMois() {
        return mois;
    }

    public void setMois(int mois) {
        this.mois = mois;
    }

    public String getMoisLib() {
        return moisLib;
    }

    public void setMoisLib(String moisLib) {
        this.moisLib = moisLib;
    }

    public int getAnnee() {
        return annee;
    }

    public void setAnnee(int annee) {
        this.annee = annee;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public String getUniteLib() {
        return uniteLib;
    }

    public void setUniteLib(String uniteLib) {
        this.uniteLib = uniteLib;
    }

    public String getIdProduitLib() {
        return idProduitLib;
    }

    public void setIdProduitLib(String idProduitLib) {
        this.idProduitLib = idProduitLib;
    }

    public BesoinFabricationDetailsCPL() throws Exception {
        this.setNomTable("BESOINFABRICATIONDETAILSCPL");
    }

    public double getQte_ordre() {
        return qte_ordre;
    }

    public void setQte_ordre(double qte_ordre) {
        this.qte_ordre = qte_ordre;
    }

    public double getQte_fabrique() {
        return qte_fabrique;
    }

    public void setQte_fabrique(double qte_fabrique) {
        this.qte_fabrique = qte_fabrique;
    }
}
