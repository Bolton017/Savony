package calculBesoin;

import java.sql.Date;

public class CalculBesoinFilleLib extends CalculBesoinFille {
    private String idproduitLib;
    private String idMagasinLib;
    private String idMagasin;
    private String designation;
    private Date daty;

    public CalculBesoinFilleLib() throws Exception {
        setNomTable("CALCULBESOINFILLELIB");
    }


    public String getIdproduitLib() {
        return idproduitLib;
    }

    public void setIdproduitLib(String idproduitLib) {
        this.idproduitLib = idproduitLib;
    }

    public String getIdMagasinLib() {
        return idMagasinLib;
    }

    public void setIdMagasinLib(String idMagasinLib) {
        this.idMagasinLib = idMagasinLib;
    }

    public String getIdMagasin() {
        return idMagasin;
    }

    public void setIdMagasin(String idMagasin) {
        this.idMagasin = idMagasin;
    }

    public String getDesignation() {
        return designation;
    }

    public void setDesignation(String designation) {
        this.designation = designation;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }
}

