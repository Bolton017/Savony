package produits;

import bean.ClassMAPTable;
import bean.ClassMere;
import java.sql.Connection;
import java.sql.Date;

public class ImportPrix extends ClassMere {
    private String id;
    private String desce;
    private Date daty;

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getDesce() {
        return desce;
    }

    public void setDesce(String desce) {
        this.desce = desce;
    }



    public ImportPrix() throws Exception {
        this.setNomTable("IMPORTPRIX");
        this.setNomClasseFille("produits.ImportPrixDetails");
        this.setLiaisonFille("idMere");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("IPM","GETseqimportprix");
        this.setId(makePK(c));
    }

    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {
        return super.createObject(u, c);
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

