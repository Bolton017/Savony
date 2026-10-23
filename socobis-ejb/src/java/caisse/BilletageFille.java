package caisse;

import utilitaire.UtilDB;

import java.sql.Connection;

public class BilletageFille {

    private String id;
    private String idMere;
    private int billet;
    private int nombreBillet;

    public BilletageFille() {
    }

    public BilletageFille(String id, String idMere, int billet, int nombreBillet) {
        this.id = id;
        this.idMere = idMere;
        this.billet = billet;
        this.nombreBillet = nombreBillet;
    }

    public String save() throws Exception {
        try {
            if (this.id == null || this.id.isEmpty()) {
                this.id = generateBilletageFilleId();
            }
            Connection con = new UtilDB().GetConn();
            java.sql.PreparedStatement stmt = con.prepareStatement(
                "INSERT INTO BILLETAGE_FILLE (ID, ID_MERE, BILLET, NOMBRE_BILLET) VALUES (?, ?, ?, ?)"
            );
            stmt.setString(1, this.id);
            stmt.setString(2, this.idMere);
            stmt.setInt(3, this.billet);
            stmt.setInt(4, this.nombreBillet);
            stmt.executeUpdate();
            stmt.close();
            return this.id;
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
    }

    private String generateBilletageFilleId() throws Exception {
        Connection con = new UtilDB().GetConn();
        java.sql.PreparedStatement stmt = con.prepareStatement(
            "SELECT COUNT(*) as count FROM BILLETAGE_FILLE WHERE ID LIKE 'BLTF%'"
        );
        java.sql.ResultSet rs = stmt.executeQuery();
        int count = 0;
        if (rs.next()) {
            count = rs.getInt("count");
        }
        rs.close();
        stmt.close();

        // Generate ID in the format BLTFXXXXXX where XXXXXX is a 6-digit number
        String id = String.format("BLTF%06d", count + 1);
        return id;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdMere() {
        return idMere;
    }

    public void setIdMere(String idMere) {
        this.idMere = idMere;
    }

    public int getBillet() {
        return billet;
    }

    public void setBillet(int billet) {
        this.billet = billet;
    }

    public int getNombreBillet() {
        return nombreBillet;
    }

    public void setNombreBillet(int nombreBillet) {
        this.nombreBillet = nombreBillet;
    }

    public static BilletageFille[] getByIdMere(String idMere) throws Exception {
        try {
            Connection con = new UtilDB().GetConn();
            java.sql.PreparedStatement stmt = con.prepareStatement(
                "SELECT ID, ID_MERE, BILLET, NOMBRE_BILLET FROM BILLETAGE_FILLE WHERE ID_MERE = ? ORDER BY BILLET DESC"
            );
            stmt.setString(1, idMere);
            java.sql.ResultSet rs = stmt.executeQuery();

            // Use a List to collect results since we can't know the count in advance
            java.util.List<BilletageFille> resultsList = new java.util.ArrayList<>();

            while (rs.next()) {
                BilletageFille fille = new BilletageFille();
                fille.setId(rs.getString("ID"));
                fille.setIdMere(rs.getString("ID_MERE"));
                fille.setBillet(rs.getInt("BILLET"));
                fille.setNombreBillet(rs.getInt("NOMBRE_BILLET"));
                resultsList.add(fille);
            }

            rs.close();
            stmt.close();

            // Convert list to array
            return resultsList.toArray(new BilletageFille[0]);
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
    }
}
