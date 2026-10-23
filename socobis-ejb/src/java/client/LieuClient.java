package client;

import bean.TypeObjet;

import java.sql.Connection;

public class LieuClient extends TypeObjet {
    private String idZone;
    public LieuClient() {
        super.setNomTable("LIEUCLIENT");
    }
    public String getIdZone() {
        return idZone;
    }

    public void setIdZone(String idZone) {
        this.idZone = idZone;
    }

    public void construirePK(Connection c) throws Exception {
        this.preparePk("LCL", "GETSEQLIEUCLIENT");
        this.setId(makePK(c));
    }
}
