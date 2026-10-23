package stock;

import java.sql.Connection;
import java.sql.Date;

import bean.CGenUtil;

public class MvtStockEntreeAvecReste extends MvtStockFille {
    private double quantite;
    private String idMagasin, idMagasinLib;
    private String idProduitLib;
    private String unite,compteLocalisationLib;
    private Date daty;


    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public String getIdMagasinLib() {
        return idMagasinLib;
    }

    public void setIdMagasinLib(String idMagasinLib) {
        this.idMagasinLib = idMagasinLib;
    }

    public String getCompteLocalisationLib() {
        return compteLocalisationLib;
    }

    public void setCompteLocalisationLib(String compteLocalisationLib) {
        this.compteLocalisationLib = compteLocalisationLib;
    }

    public String getUnite() {
        return unite;
    }

    public void setUnite(String unite) {
        this.unite = unite;
    }

    public String getIdProduitLib() {
        return idProduitLib;
    }

    public void setIdProduitLib(String idProduitLib) {
        this.idProduitLib = idProduitLib;
    }

    public MvtStockEntreeAvecReste() throws Exception {
        setNomTable("MvtStockEntreeAvecReste2");
    }

    public void setNomTable(String nomTable) {
        super.setNomTable(nomTable);
    }

    public double getQuantite() {
        return quantite;
    }

    public void setQuantite(double quantite) throws Exception {
        if (this.getMode().equals("modif") && quantite < 0) {
            throw new Exception("Quantite ne peut pas etre negatif");
        }
        this.quantite = quantite;
    }

    public String getIdMagasin() {
        return idMagasin;
    }

    public void setIdMagasin(String idMagasin) {
        this.idMagasin = idMagasin;
    }
    @Override
    public String[] getMotCles() {
        String[] motCles={"id","idProduitLib","idproduit","pu","idMagasinLib","unite","quantite", "daty"};
        return motCles;
    }

    @Override
    public String[] getValMotCles() {
        String[] motCles={"id","idProduitLib","idMagasinLib","reste","idUniteLib","compteLocalisationLib"};
        return motCles;
    }
}
