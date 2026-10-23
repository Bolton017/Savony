package equivalenceproduit;
import bean.ClassMAPTable;

import bean.ClassMAPTable;
import faturefournisseur.FactureFournisseurDetails;
import produits.Ingredients;
import utilitaire.UtilDB;
import utils.ConstanteSavonnerie;
import vente.BonDeCommandeFille;
import vente.VenteDetails;

import java.sql.Connection;
import java.sql.Date;

public class EquivalenceProduit extends ClassMAPTable {
    private String id;
    private String idProduitBase;
    private String idProduitEq;
    private double quantite;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdProduitBase() {
        return idProduitBase;
    }

    public void setIdProduitBase(String idProduitBase) {
        this.idProduitBase = idProduitBase;
    }

    public String getIdProduitEq() {
        return idProduitEq;
    }

    public void setIdProduitEq(String idProduitEq) {
        this.idProduitEq = idProduitEq;
    }

    public double getQuantite() {
        return quantite;
    }

    public void setQuantite(double quantite) {
        this.quantite = quantite;
    }

    public EquivalenceProduit() throws Exception {
        this.setNomTable("EQUIVALENCEPRODUIT");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("EQP","getSeqEQUIVALENCEPRODUIT");
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

    public static double getQteCarton(Ingredients ing, double qte, Connection c) throws Exception {
        double qteCarton = 0.0;
        if (ConstanteSavonnerie.UNITE_CARTON.equalsIgnoreCase(ing.getUnite())){
            return  (int) qte;
        }
        EquivalenceProduit equivalenceProduit = ing.findEquivalenceEnCarton(c);
        if (equivalenceProduit != null) {
            qteCarton = qte/ equivalenceProduit.getQuantite();
        }
        return (int) qteCarton;
    }

    public static double getQtePieceRestant(Ingredients ing, double qte, Connection c) throws Exception {
        if (ConstanteSavonnerie.UNITE_CARTON.equalsIgnoreCase(ing.getUnite())){
            return 0;
        }
        EquivalenceProduit equivalenceProduit = ing.findEquivalenceEnCarton(c);
        double qteCarton = getQteCarton(ing, qte, c);
        return qte - (qteCarton * equivalenceProduit.getQuantite())  ;
    }
}