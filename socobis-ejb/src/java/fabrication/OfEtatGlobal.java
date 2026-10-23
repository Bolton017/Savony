package fabrication;
import java.sql.Connection;
import java.util.Vector;
import java.util.List;
import java.util.HashMap;
import java.sql.Connection;

import bean.*;
import stock.*;
import utilitaire.UtilDB;

public class OfEtatGlobal{
    private String id;
    private Of of;
    private OfFilleCpl[] details;
    private HashMap<String, Vector> rapprochement;
    private MvtStockFilleTheorique[] rapprochementGlobal;

    public OfEtatGlobal() throws Exception
    {
    }
    public OfEtatGlobal(String id) throws Exception
    {
        Connection c = null;
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
            }
            of = new Of();
            of.setId(id);
            Of[] ofs = (Of[]) CGenUtil.rechercher(of, null, null, null, " ");
            if (ofs.length > 0) of = ofs[0];
            OfFilleCpl ofL = new OfFilleCpl();
            ofL.setNomTable("OfFilleLibStock");
            ofL.setIdMere(id);
            details = (OfFilleCpl[]) CGenUtil.rechercher(ofL, null, null, null, "");
            MvtStockFilleTheorique mvtStockFilleTheorique = new MvtStockFilleTheorique();
            rapprochement = mvtStockFilleTheorique.getRapprochementParCategorie(id, null, c);
            mvtStockFilleTheorique.setNomTable("stockEtDepOfFabTheCatGroupe");
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

    public Of getOf() {
        return of;
    }

    public void setOf(Of of) {
        this.of = of;
    }

    public OfFilleCpl[] getDetails() {
        return details;
    }

    public void setDetails(OfFilleCpl[] details) {
        this.details = details;
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
}
