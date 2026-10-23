package magasin;

import bean.ClassMAPTable;
import java.sql.Connection;

public class DirectionMagasin extends ClassMAPTable {
    private String id;
    private String idMagasin;
    private String idDirection;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdMagasin() {
        return idMagasin;
    }

    public void setIdMagasin(String idMagasin) {
        this.idMagasin = idMagasin;
    }

    public String getIdDirection() {
        return idDirection;
    }

    public void setIdDirection(String idDirection) {
        this.idDirection = idDirection;
    }

    public DirectionMagasin() throws Exception {
        this.setNomTable("directionmagasin");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("DMG", "GETSEQDIRECTIONMAGASIN");
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
}
