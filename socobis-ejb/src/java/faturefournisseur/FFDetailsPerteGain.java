package faturefournisseur;
import bean.LibelleAffichage;

import java.sql.Connection;

public class FFDetailsPerteGain extends FactureFournisseurDetails{
    @LibelleAffichage("Produit")
    private String libelleProduit;
    public FFDetailsPerteGain() throws Exception{
        super();
    }

    @Override
    public void controlerUpdate(Connection c){

    }

    @Override
    public int updateObject(String refUser, Connection c) throws Exception {
        RepartirionPG rp=new RepartirionPG();
        rp.setIdFactureFille(this.getId());
        rp.setMontant(this.getMontantPerteGain());
        rp.setIdPerte(this.getIdbcDetail());
        rp.createObject(refUser, c);
        rp.creerUsage(refUser,c);
        return 1;
    }

    public String getLibelleProduit() {
        return libelleProduit;
    }

    public void setLibelleProduit(String libelleProduit) {
        this.libelleProduit = libelleProduit;
    }
}
