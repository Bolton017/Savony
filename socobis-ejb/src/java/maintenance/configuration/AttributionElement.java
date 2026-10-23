package maintenance.configuration;

import bean.ClassEtat;
import bean.ClassMAPTable;
import bean.CGenUtil;
import maintenance.ressources.IngredientMaintenance;
import stock.MvtStock;
import stock.MvtStockFille;
import maintenance.utils.ConstanteMaintenance;
import utils.ConstanteSocobis;

import java.sql.Connection;
import java.sql.Date;

public class AttributionElement extends ClassEtat {
    String id, idIngredientMaintenance,idPersonnel;
    Date daty;
    String etatElement;
    int typeAttribution,qte;
    String idIngredient;

    public AttributionElement() {
        this.setNomTable("attributionElement");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("ATR", "getSeqAttributionelement");
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

    public String getIdIngredientMaintenance() {
        return idIngredientMaintenance;
    }

    public void setIdIngredientMaintenance(String idIngredientMaintenance) {
        this.idIngredientMaintenance = idIngredientMaintenance;
    }
    public MvtStock genererMouvementDeStock(String typeMouvement,String u,Connection c) throws Exception {
        MvtStock mvtStock = new MvtStock();
        mvtStock.setDesignation("Mouvement de stock due a attribution"+this.getIdIngredientMaintenance()+" avec "+this.getIdPersonnel());
        mvtStock.setIdMagasin(ConstanteMaintenance.STOCK_MAGASIN_MAINTENANCE);
        if(typeMouvement.equals("1")){
            mvtStock.setIdTypeMvStock(ConstanteSocobis.TYPE_MVT_ENTREE);
        }
        else{
            mvtStock.setIdTypeMvStock(ConstanteSocobis.TYPE_MVT_SORTIE);
        }
        MvtStockFille[] mvtStockFille = new MvtStockFille[1];
        mvtStockFille[0].setIdProduit(this.getIdIngredientMaintenance());
        mvtStockFille[0].setMvtSrc(this.getId());
        mvtStock.setFille(mvtStockFille);
        MvtStock mvt = (MvtStock)mvtStock.createObject(u,c);

        return mvt;
    }

    public String getIdPersonnel() {
        return idPersonnel;
    }

    public void setIdPersonnel(String idPersonnel) {
        this.idPersonnel = idPersonnel;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public String getEtatElement() {
        return etatElement;
    }

    public void setEtatElement(String etatElement) {
        this.etatElement = etatElement;
    }

    public int getTypeAttribution() {
        return typeAttribution;
    }

    public void setTypeAttribution(int typeAttribution) {
        this.typeAttribution = typeAttribution;
    }

    public int getQte() {
        return qte;
    }

    public void setQte(int qte) {
        this.qte = qte;
    }

    public String getIdIngredient() throws Exception {
        IngredientMaintenance im = (IngredientMaintenance)new IngredientMaintenance().getById(this.getIdIngredientMaintenance(),"",null);
        return im.getIdIngredient();
    }

    public void setIdIngredient(String idIngredient) {
        this.idIngredient = idIngredient;
    }

    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {

        AttributionElement att = new AttributionElement();
        att.setNomTable("dernierAttributionElement");
        att.setIdIngredientMaintenance(this.getIdIngredientMaintenance());

        AttributionElement[] attribution = (AttributionElement[]) 
            CGenUtil.rechercher(
                att, null, null, c,
                " and idIngredientMaintenance='" + att.getIdIngredientMaintenance() + "' "
            );
        if (attribution.length > 0) {
            att = attribution[0];
            if (att.getTypeAttribution() == 1) {
                throw new Exception("Element deja attribue");
            }
            else if (att.getTypeAttribution() == 0) {
                 return super.createObject(u, c);
            }
        }

        return super.createObject(u, c);
    }

}
