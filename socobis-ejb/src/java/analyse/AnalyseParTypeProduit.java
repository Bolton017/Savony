package analyse;

import bean.ClassMAPTable;

public class AnalyseParTypeProduit extends ClassMAPTable {
    private String idTypeProduit;
    private String idTypeProduitLib;
    private int nombreAnalyses;

    public AnalyseParTypeProduit() {
        setNomTable("ANALYSES_TYPE_PRODUIT");
    }

    public String getIdTypeProduit() {
        return idTypeProduit;
    }

    public void setIdTypeProduit(String idTypeProduit) {
        this.idTypeProduit = idTypeProduit;
    }

    public String getIdTypeProduitLib() {
        return idTypeProduitLib;
    }

    public void setIdTypeProduitLib(String idTypeProduitLib) {
        this.idTypeProduitLib = idTypeProduitLib;
    }

    public int getNombreAnalyses() {
        return nombreAnalyses;
    }

    public void setNombreAnalyses(int nombreAnalyses) {
        this.nombreAnalyses = nombreAnalyses;
    }

    @Override
    public String getTuppleID() {
        return getIdTypeProduit();
    }

    @Override
    public String getAttributIDName() {
        return "idTypeProduit";
    }
}
