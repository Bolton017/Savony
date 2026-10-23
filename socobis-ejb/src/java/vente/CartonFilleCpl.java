package vente;

public class CartonFilleCpl extends CartonFille {

    private String produitLib , idbc;

    public CartonFilleCpl()
        throws Exception
    {
        super();
        this.setNomTable("CARTONFILLE_CPL");
    }

    public String getProduitLib() {
        return produitLib;
    }

    public void setProduitLib(String produitLib) {
        this.produitLib = produitLib;
    }

    public String getIdbc() {
        return idbc;
    }

    public void setIdbc(String idbc) {
        this.idbc = idbc;
    }
    
} 