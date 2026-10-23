package paie.pointage;

import bean.ClassEtat;

import java.sql.Connection;
import java.sql.Date;

public class PointageCantine extends ClassEtat{

    String id, idpersonnel;
    Date daty;
    double nombre;

    public PointageCantine() throws Exception{
        this.setNomTable("POINTAGECANTINE");
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("PTGCAN", "getseqptgcantine");
        this.setId(makePK(c));
    }

    public double getNombre() {
        return nombre;
    }

    public void setNombre(double nombre) {
        this.nombre = nombre;
    }

    public String getId() {
        return this.id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdpersonnel() {
        return this.idpersonnel;
    }

    public void setIdpersonnel(String idpersonnel) {
        this.idpersonnel = idpersonnel;
    }

    public Date getDaty() {
        return this.daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }
}