package faturefournisseur;

import bean.ClassMAPTable;
import bean.TypeObjet;

import java.sql.Connection;

public class RepartirionPG extends ClassMAPTable {
    String id,idFactureFille,idPerte;
    double montant;
    public RepartirionPG()
    {
        super.setNomTable("RepartirionPG");
    }
    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("RPG","getseq_EntretienRH");
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

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdFactureFille() {
        return idFactureFille;
    }

    public void setIdFactureFille(String idFactureFille) {
        this.idFactureFille = idFactureFille;
    }

    public String getIdPerte() {
        return idPerte;
    }

    public void setIdPerte(String idPerte) {
        this.idPerte = idPerte;
    }

    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant) {
        this.montant = montant;
    }
    public TypeObjet[] creerUsage(String u,Connection c) throws Exception
    {
        String [] idPgSplite=this.getIdPerte().split(";;");
        TypeObjet[] ret=new TypeObjet[idPgSplite.length];
        for(int i=0;i<idPgSplite.length;i++)
        {
            ret[i]=new TypeObjet();
            ret[i].setNomTable("perteGainUtilise");
            ret[i].preparePk("USA","getseq_EntretienRH");
            ret[i].setVal(idPgSplite[i]);
            ret[i].insertToTableWithHisto(u,c);
        }
        return ret;
    }
}
