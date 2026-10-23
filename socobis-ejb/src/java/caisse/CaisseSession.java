package caisse;

import bean.CGenUtil;
import bean.ClassEtat;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;

import java.sql.Connection;
import java.sql.Date;

public class CaisseSession extends ClassEtat {
    private String id;
    private String idCaisse;
    private String idPoint;
    private Date dateOuverture;
    private String heureOuverture;
    private Date dateFermeture;
    private String heureFermeture;
    private String idUserOuverture;
    private String idUserFermeture;

    public CaisseSession() {
        super.setNomTable("CAISSESESSION");
    }

    public void construirePK(Connection c) throws Exception {
        this.preparePk("CES", "GETSEQ_CAISSESSION");
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

    public int checkIfSessionOuverteExistePourPoint() throws Exception {
        return this.checkIfSessionOuverteExistePourPoint(null);
    }

    public int checkIfSessionOuverteExistePourPoint(Connection c) throws Exception {

        boolean closeConnection = false;

        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                closeConnection = true;
            }
            Date dateOuverture = Utilitaire.dateDuJourSql();

            CaisseSession session = new CaisseSession();
            session.setIdPoint(this.getIdPoint());
            session.setIdCaisse(this.getIdCaisse());
            String condition =
                    " AND TRUNC(DATEOUVERTURE) = TO_DATE('" +
                            new java.text.SimpleDateFormat("yyyy-MM-dd").format(dateOuverture) +
                            "', 'YYYY-MM-DD')" +
                            " AND DATEFERMETURE IS NULL";

            CaisseSession[] sessionOuverte =
                    (CaisseSession[]) CGenUtil.rechercher(session, null, null, c, condition);
            if (sessionOuverte != null && sessionOuverte.length > 0) {
                return 1;
            }

            return 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdCaisse() {
        return idCaisse;
    }

    public void setIdCaisse(String idCaisse) {
        this.idCaisse = idCaisse;
    }

    public Date getDateOuverture() {
        return dateOuverture;
    }

    public void setDateOuverture(Date dateOuverture) {
        this.dateOuverture = dateOuverture;
    }

    public String getHeureOuverture() {
        return heureOuverture;
    }

    public void setHeureOuverture(String heureOuverture) {
        this.heureOuverture = heureOuverture;
    }

    public Date getDateFermeture() {
        return dateFermeture;
    }

    public void setDateFermeture(Date dateFermeture) {
        this.dateFermeture = dateFermeture;
    }

    public String getHeureFermeture() {
        return heureFermeture;
    }

    public void setHeureFermeture(String heureFermeture) {
        this.heureFermeture = heureFermeture;
    }

    public String getIdUserOuverture() {
        return idUserOuverture;
    }

    public void setIdUserOuverture(String idUserOuverture) {
        this.idUserOuverture = idUserOuverture;
    }

    public String getIdUserFermeture() {
        return idUserFermeture;
    }

    public void setIdUserFermeture(String idUserFermeture) {
        this.idUserFermeture = idUserFermeture;
    }

    public String getIdPoint() {
        return idPoint;
    }

    public void setIdPoint(String idPoint) {
        this.idPoint = idPoint;
    }
}
