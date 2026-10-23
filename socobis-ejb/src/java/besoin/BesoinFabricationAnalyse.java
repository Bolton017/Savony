package besoin;

import bean.ClassMAPTable;
import java.sql.Connection;

public class BesoinFabricationAnalyse extends ClassMAPTable {
    private String idProduit;
    private String produitLib;
    private String uniteLib;
    private int annee;
    private int mois;
    private int total_Qte;
    private String mois_annee_lib;

    public String getMois_annee_lib() {
        return mois_annee_lib;
    }

    public void setMois_annee_lib(String mois_annee_lib) {
        this.mois_annee_lib = mois_annee_lib;
    }

    public String getIdProduit() {
        return idProduit;
    }

    public void setIdProduit(String idProduit) {
        this.idProduit = idProduit;
    }

    public String getProduitLib() {
        return produitLib;
    }

    public void setProduitLib(String produitLib) {
        this.produitLib = produitLib;
    }

    public String getUniteLib() {
        return uniteLib;
    }

    public void setUniteLib(String uniteLib) {
        this.uniteLib = uniteLib;
    }

    public int getAnnee() {
        return annee;
    }

    public void setAnnee(int annee) {
        this.annee = annee;
    }

    public int getMois() {
        return mois;
    }

    public void setMois(int mois) {
        this.mois = mois;
    }

    public int getTotal_Qte() {
        return total_Qte;
    }

    public void setTotal_Qte(int total_Qte) {
        this.total_Qte = total_Qte;
    }

    public BesoinFabricationAnalyse() throws Exception {
        this.setNomTable("BESOINFABRICATIONDETAILANALYSE");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("BFA","getSeqBesoinAnalyse");
    }

    @Override
    public String getTuppleID() {
        return "";
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }
}

