package paie.avancement;

import bean.ClassMAPTable;
import java.sql.Connection;
import java.sql.Date;

/**
 *
 * @author JESSI
 */
public class Avancement extends ClassMAPTable{
    private String id,idtravaux,remarque;
    private double pkdebut,pkfin;
    private Date Daty;
    private int niveau;

    public Avancement() {
        this.setNomTable("avancement");
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdtravaux() {
        return idtravaux;
    }

    public void setIdtravaux(String idtravaux) {
        this.idtravaux = idtravaux;
    }

    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }

    public double getPkdebut() {
        return pkdebut;
    }

    public void setPkdebut(double pkdebut) {
        this.pkdebut = pkdebut;
    }

    public double getPkfin() {
        return pkfin;
    }

    public void setPkfin(double pkfin) {
        this.pkfin = pkfin;
    }

    public Date getDaty() {
        return Daty;
    }

    public void setDaty(Date Daty) {
        this.Daty = Daty;
    }

    public int getNiveau() {
        return niveau;
    }

    public void setNiveau(int niveau) {
        this.niveau = niveau;
    }

    @Override
    public String getTuppleID() {
       return id;
    }

    @Override
    public String getAttributIDName() {
      return "id";
    }
       public void construirePK(Connection c) throws Exception {
        this.setNomTable("avancement");
        this.preparePk("AVC", "GETavancement");
        this.setId(makePK(c));
    }
}
