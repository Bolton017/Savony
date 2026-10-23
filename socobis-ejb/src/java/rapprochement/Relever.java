package rapprochement;

import bean.CGenUtil;
import bean.ClassMAPTable;
import bean.ClassMere;
import utilitaire.UtilDB;

import java.sql.Connection;
import java.sql.Date;
import java.time.LocalDate;
import java.time.temporal.TemporalAdjusters;

public class Relever extends ClassMere {
    private String id;
    private Date daty;
    private String idCaisse;
    private Date datyDebut;
    private Date datyFin;

    public Date getDatyDebut() {
        return datyDebut;
    }

    public void setDatyDebut(Date datyDebut) {
        this.datyDebut = datyDebut;
    }

    public Date getDatyFin() {
        return datyFin;
    }

    public void setDatyFin(Date datyFin) {
        this.datyFin = datyFin;
    }

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

    public String getIdCaisse() {
        return idCaisse;
    }

    public void setIdCaisse(String idCaisse) {
        this.idCaisse = idCaisse;
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("REL", "getSeqRelever");
        this.setId(makePK(c));
    }

    public Relever() throws Exception {
        this.setNomTable("Relever");
        this.setLiaisonFille("idMere");
        this.setNomClasseFille("rapprochement.ReleverDetail");
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    public Relever [] getReleverDuMois() throws Exception {
        LocalDate localDate = this.getDaty().toLocalDate();
        LocalDate debutMois = localDate.withDayOfMonth(1);
        LocalDate finMois = localDate.with(TemporalAdjusters.lastDayOfMonth());
          String awhere = " AND ETAT=11"
        + " AND IDCAISSE='" + this.getIdCaisse() + "'"
        + " AND TRUNC(DATYDEBUT) <= DATE '" + this.getDatyFin() + "'"
        + " AND TRUNC(DATYFIN) >= DATE '" + this.getDatyDebut() + "'";
        Relever [] result = (Relever[]) CGenUtil.rechercher(new Relever(),null,null,null,awhere);
        return result;
    }

    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {
        Relever [] relevers = getReleverDuMois();
        if (relevers!=null && relevers.length>0) {
            throw new Exception("Une relever existe deja pour le mois du date "+this.getDaty().toString());
        }
        return super.createObject(u, c);
    }

    @Override
    public Object validerObject(String u, Connection c) throws Exception {
        Relever [] relevers = getReleverDuMois();
        if (relevers!=null && relevers.length>0) {
            throw new Exception("Une relever existe deja pour le mois du date "+this.getDaty().toString());
        }
        return super.validerObject(u, c);
    }

    public Relever getByIds(String[]ids, Connection c) throws Exception {
        if (ids == null || ids.length == 0) {
            throw new Exception("Aucun ID spécifié");
        }
        int verif = 0;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                verif = 1;
            }
            String awhere = " AND ID='"+ids[0]+"'";
            System.err.println("=====================>"+awhere);
            ReleverDetail[] releverArray = (ReleverDetail[]) CGenUtil.rechercher(new ReleverDetail(), null, null, null, awhere);
            System.err.println("=============TAIULLLL========>"+releverArray.length);
            if (releverArray == null || releverArray.length == 0) {
                return null;
            }
            return releverArray[0].getRelever(c);
        } catch (Exception ex) {
            throw ex;
        } finally {
            if (c != null && verif == 1) {
                c.close();
            }
        }
    }
}
