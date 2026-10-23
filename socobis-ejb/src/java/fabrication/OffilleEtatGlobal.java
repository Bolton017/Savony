package fabrication;
import java.sql.Connection;
import java.util.Vector;
import java.util.List;
import java.util.HashMap;
import java.sql.Connection;

import bean.*;
import stock.*;
import utilitaire.UtilDB;

public class OffilleEtatGlobal{
    private String id;
    private OfFilleCpl offille;
    private HashMap<String, Vector> rapprochement;
    private MvtStockFilleTheorique[] rapprochementGlobal;

    public OffilleEtatGlobal() throws Exception
    {
    }
    public OffilleEtatGlobal(String id) throws Exception
    {
        Connection c = null;
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
            }

            OfFilleCpl ofL = new OfFilleCpl();
            ofL.setNomTable("OfFilleLibStock");
            ofL.setId(id);
            OfFilleCpl[] ofs = (OfFilleCpl[]) CGenUtil.rechercher(ofL, null, null, null, " ");
            if(ofs.length > 0) offille = ofs[0];
            else {
                throw new Exception("OF fille introuvable");
            }
            MvtStockFilleTheorique mvtStockFilleTheorique = new MvtStockFilleTheorique();
            rapprochement = mvtStockFilleTheorique.getRapprochementParCategorie(id, "STOCKETDEPENSEOFFILLEFABTHE", c);
            mvtStockFilleTheorique.setNomTable("STOCKETDEPOFFILLETHECATGROUPE");
            rapprochementGlobal = (MvtStockFilleTheorique[]) CGenUtil.rechercher(mvtStockFilleTheorique, null, null, null, " AND IDMERE='" + id + "'");
        } catch (Exception e) {
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public HashMap<String, Vector> getRapprochement() {
        return rapprochement;
    }

    public void setRapprochement(HashMap<String, Vector> rapprochement) {
        this.rapprochement = rapprochement;
    }

    public MvtStockFilleTheorique[] getRapprochementGlobal() {
        return rapprochementGlobal;
    }

    public void setRapprochementGlobal(MvtStockFilleTheorique[] rapprochementGlobal) {
        this.rapprochementGlobal = rapprochementGlobal;
    }

    public OfFilleCpl getOffille() {
        return offille;
    }

    public void setOffille(OfFilleCpl offille) {
        this.offille = offille;
    }
}
