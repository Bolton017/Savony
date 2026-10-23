package calculBesoin;

import bean.ClassMere;
import java.sql.Connection;
import java.sql.Date;

public class CalculBesoin extends ClassMere {
    private String id;
    private Date daty;
    private String idMagasin;
    private String designation;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public String getDesignation() {
        return designation;
    }

    public void setDesignation(String designation) {
        this.designation = designation;
    }



    public CalculBesoin() throws Exception {
        this.setNomTable("CALCULBESOIN");
        this.setNomClasseFille("calculBesoin.CalculBesoinFille");
        this.setLiaisonFille("idMere");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("CBM","getSeqCalculBesoin");
        this.setId(makePK(c));
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    public String getIdMagasin() {
        return idMagasin;
    }

    public void setIdMagasin(String idMagasin) {
        this.idMagasin = idMagasin;
    }
}

