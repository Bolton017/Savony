package paie.permission;

import java.sql.Connection;
import java.sql.Date;

import bean.CGenUtil;
import bean.ClassMAPTable;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;

/**
 *
 * @author Estcepoire
 */

public class Permission extends ClassMAPTable {
    String id;
    double solde;
    double pris;
    double reste;
    Date daty;

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public double getSolde() {
        return solde;
    }

    public void setSolde(double solde) {
        this.solde = solde;
    }

    public double getPris() {
        return pris;
    }

    public void setPris(double pris) {
        this.pris = pris;
    }

    public double getReste() {
        return reste;
    }

    public void setReste(double reste) {
        this.reste = reste;
    }

    public Permission() {
        this.setNomTable("permission_vide");
    }

    // calcule permission
    public Permission[] getPermission(String idpersonnel) throws Exception {
        String request = "";
        Connection con = null;
        try {

            con = new UtilDB().GetConn();
            request = this.qweryPermission(this.getDaty(), idpersonnel);
            Permission[] permissions = (Permission[]) CGenUtil.rechercher(new Permission(), request, con);
            return permissions;
        } catch (Exception e) {
            throw e;
        } finally {
            con.close();
        }
    }

    public String qweryPermission(Date daty, String idpersonnel) {
        // Définir le filtre pour idpersonnel si fourni
        String pers = (idpersonnel != null && !idpersonnel.isEmpty())
                ? " WHERE ps.id = '" + idpersonnel + "'"
                : "";
        int annee = Utilitaire.getAnnee(daty);
        daty = (daty != null) ? daty : Utilitaire.dateDuJourSql();

        String qwery = "SELECT ps.id, " +
                "CAST(SUM(ps.solde) AS NUMBER(10, 2)) AS solde, " +
                "CAST(SUM(NVL(d.reste_conge, 0)) AS NUMBER(10, 2)) AS pris, " +
                "CAST((SUM(ps.solde) - SUM(NVL(d.reste_conge, 0))) AS NUMBER(10, 2)) AS reste " +
                "FROM permission_solde ps " +
                "LEFT JOIN demande d ON ps.id = d.idpersonnel " +
                "AND d.idtypedemande = 'TYP000006' " +
                "AND d.etat >= 9 " +
                "AND d.daty BETWEEN TO_DATE('" + annee + "-01-01', 'YYYY-MM-DD') " +
                "AND TO_DATE('" + annee + "-12-31', 'YYYY-MM-DD') " +
                (pers != null ? pers : "") + " " +
                "GROUP BY ps.id";

        System.out.println("Requête Permission =============> " + qwery);

        return qwery;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

}
