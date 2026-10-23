package stock;

import bean.ClassFille;
import faturefournisseur.FactureFournisseurDetails;
import java.sql.Connection;
import vente.As_BondeLivraisonClient;

public class LivraisonInterneFille extends ClassFille {
    private String id, idMere, idIngredient;
    private double qte;

    public LivraisonInterneFille() throws Exception {
        setNomTable("LIVRAISONINTERNEFILLE");
        this.setLiaisonMere("idMere");
        this.setNomClasseMere("stock.LivraisonInterne");
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

    public String getIdIngredient() {
        return idIngredient;
    }

    public void setIdIngredient(String idIngredient) {
        this.idIngredient = idIngredient;
    }

    public double getQte() {
        return qte;
    }

    public void setQte(double qte) throws Exception {
        if(getMode().compareTo("modif")==0 && qte<=0)throw new Exception("Valeur du quantité invalide");
        this.qte = qte;
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("LVIF", "GETLIVRAISONINTERNEFILLE");
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

    @Override
    public void setLiaisonMere(String liaisonMere) {
        super.setLiaisonMere("idMere");
    }

    @Override
    public void controlerUpdate(Connection c) throws Exception {
        super.setNomClasseMere("stock.LivraisonInterne");
        super.controlerUpdate(c);
    }
    public FactureFournisseurDetails  genererFactureFournisseurFille() throws Exception{
        FactureFournisseurDetails fd = new FactureFournisseurDetails();
        fd.setIdProduit(this.getIdIngredient());
        fd.setQte(this.getQte());
        fd.setIdbcDetail(this.getIdMere());
        return fd;
    }
    public MvtStockFille genererMvtStockFille(Connection c)throws Exception{
        As_BondeLivraisonClient m=(As_BondeLivraisonClient)this.findMere(null,c);
        MvtStockFille msf=new MvtStockFille();
        msf.setIdMvtStock(m.getId());
        msf.setIdProduit(this.getIdIngredient());
        msf.setEntree(this.getQte());
        return msf;
    }
}
