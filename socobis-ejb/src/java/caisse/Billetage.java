package caisse;

import bean.CGenUtil;
import bean.ClassMAPTable;

import java.sql.Connection;

public class Billetage extends ClassMAPTable {
    private String id, desce;
    int nombre;
    private String idCloture;

    public Billetage() {
        super.setNomTable("BILLETAGE");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("BIL", "getseqbilletage");
        this.setId(makePK());
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    public Billetage[] getAllBilletage() throws Exception {
        Billetage billet = new Billetage();
        billet.setNomTable("BILLETAGE");
        Billetage[] res = (Billetage[]) CGenUtil.rechercher(billet, null, null, null, "");
        if(res != null && res.length > 0) {
            return res;
        }
        return null;
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

    public int getNombre() {
        return nombre;
    }

    public void setNombre(int nombre) {
        this.nombre = nombre;
    }

    public String getIdCloture() {
        return idCloture;
    }

    public void setIdCloture(String idCloture) {
        this.idCloture = idCloture;
    }
}
