package caisse;

import utilitaire.UtilDB;

import java.sql.Connection;
import java.util.Date;

public class BilletageMere {

    private String id;
    private Date daty;
    private String remarque;

    public BilletageMere() {
    }

    public BilletageMere(String id, Date daty, String remarque) {
        this.id = id;
        this.daty = daty;
        this.remarque = remarque;
    }

    public String save() throws Exception {
        try {
            if (this.id == null || this.id.isEmpty()) {
                this.id = generateBilletageMereId();
            }
            Connection con = new UtilDB().GetConn();
            java.sql.PreparedStatement stmt = con.prepareStatement(
                "INSERT INTO BILLETAGE_MERE (ID, DATY, REMARQUE) VALUES (?, ?, ?)"
            );
            stmt.setString(1, this.id);
            stmt.setDate(2, new java.sql.Date(this.daty.getTime()));
            stmt.setString(3, this.remarque);
            stmt.executeUpdate();
            stmt.close();
            return this.id;
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
    }

    private String generateBilletageMereId() throws Exception {
        Connection con = new UtilDB().GetConn();
        java.sql.PreparedStatement stmt = con.prepareStatement(
            "SELECT COUNT(*) as count FROM BILLETAGE_MERE WHERE ID LIKE 'BLTM%'"
        );
        java.sql.ResultSet rs = stmt.executeQuery();
        int count = 0;
        if (rs.next()) {
            count = rs.getInt("count");
        }
        rs.close();
        stmt.close();

        String id = String.format("BLTM%06d", count + 1);
        return id;
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

    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }
}
