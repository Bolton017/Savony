package stock;

import bean.ClassMere;
import bean.ClassEtat;
import utilitaire.UtilDB;
import bean.CGenUtil;
import bean.ClassMAPTable;

import faturefournisseur.FactureFournisseur;
import faturefournisseur.FactureFournisseurDetails;

import java.sql.Connection;
import java.sql.Date;

public class LivraisonInterne extends ClassMere{
    String id, idFournisseur, remarque, idFactureFournisseur;
    Date daty;

    public LivraisonInterne() {
        this.setNomTable("LIVRAISONINTERNE");
        this.setLiaisonFille("idLivraisonInterne");
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdFournisseur() {
        return idFournisseur;
    }

    public void setIdFournisseur(String idFournisseur) {
        this.idFournisseur = idFournisseur;
    }

    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }

    public String getIdFactureFournisseur() {
        return idFactureFournisseur;
    }

    public void setIdFactureFournisseur(String idFactureFournisseur) {
        this.idFactureFournisseur = idFactureFournisseur;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("LIV", "GETSEQLIVRAISONINTERNE");
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

    public FactureFournisseur genererFactureFournisseur() throws Exception {
        FactureFournisseur factureFournisseur = null;
        try {
            factureFournisseur = new FactureFournisseur();
            factureFournisseur.setId(this.getId());
            factureFournisseur.setIdFournisseur(this.getIdFournisseur());
            factureFournisseur.setIdBc(this.getIdFactureFournisseur());
            factureFournisseur.setDaty(this.getDaty());

            LivraisonInterneFille livraisonInterneFille = new LivraisonInterneFille();
            livraisonInterneFille.setIdMere(this.getId());

            LivraisonInterneFille[] livraisonInterneFilles = (LivraisonInterneFille[]) CGenUtil.rechercher(livraisonInterneFille, null, null, null, "");

            if(livraisonInterneFilles != null && livraisonInterneFilles.length > 0) {
                FactureFournisseurDetails[] factureFournisseurDetails = new FactureFournisseurDetails[livraisonInterneFilles.length];

                for (int i = 0; i < livraisonInterneFilles.length; i++) {
                    FactureFournisseurDetails factureFournisseurDetail = new FactureFournisseurDetails();
                    factureFournisseurDetail.setId(livraisonInterneFilles[i].getId());
                    factureFournisseurDetail.setIdFactureFournisseur(this.getIdFactureFournisseur());
                    factureFournisseurDetail.setIdProduit(livraisonInterneFilles[i].getIdIngredient());
                    factureFournisseurDetail.setQte(livraisonInterneFilles[i].getQte());
                    factureFournisseurDetails[i] = factureFournisseurDetail;
                }
                factureFournisseur.setFille(factureFournisseurDetails);
            }
        }catch (Exception e) {
            throw e;
        }
        return factureFournisseur;
    }

    public MvtStock genererMvtStock() throws Exception {
        MvtStock mvtStock = null;
        try {
            mvtStock = new MvtStock();
            mvtStock.setIdTransfert(this.getId());
            mvtStock.setIdMagasin(this.getIdFournisseur());
            mvtStock.setEtat(11);
            mvtStock.setDaty(this.getDaty());

            LivraisonInterneFille livraisonInterneFille = new LivraisonInterneFille();
            livraisonInterneFille.setIdMere(this.getId());

            LivraisonInterneFille[] livraisonInterneFilles = (LivraisonInterneFille[]) CGenUtil.rechercher(livraisonInterneFille, null, null, null, "");

            if(livraisonInterneFilles != null && livraisonInterneFilles.length > 0) {
                MvtStockFille[] mvtStockFilles = new MvtStockFille[livraisonInterneFilles.length];
                for (int i = 0; i < livraisonInterneFilles.length; i++) {
                    MvtStockFille mvtStockFille = new MvtStockFille();
                    mvtStockFille.setId(livraisonInterneFilles[i].getId());
                    mvtStockFille.setIdMvtStock(livraisonInterneFilles[i].getIdMere());
                    mvtStockFille.setIdProduit(livraisonInterneFilles[i].getIdIngredient());
                    mvtStockFille.setSortie(livraisonInterneFilles[i].getQte());
                    mvtStockFille.setEntree(livraisonInterneFilles[i].getQte());
                    mvtStockFilles[i] = mvtStockFille;
                }
                mvtStock.setFille(mvtStockFilles);
            }
        }catch (Exception e) {
            throw e;
        }
        return mvtStock;
    }

    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {
        FactureFournisseur factureFournisseur = this.genererFactureFournisseur();
        factureFournisseur.createObject(u, c);
        return super.createObject(u, c);
    }
}
