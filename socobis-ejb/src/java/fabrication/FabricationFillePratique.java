package fabrication;

import bean.AdminGen;
import bean.CGenUtil;
import bean.ClassMere;
import chatbot.ClassIA;
import produits.Ingredients;
import produits.Recette;
import stock.MvtStockFille;

import java.sql.Connection;

public class FabricationFillePratique extends FabricationFille {
    String idoffille;
    double montant;
    String idunitelib;

    public String getIdoffille() {
        return idoffille;
    }

    public void setIdoffille(String idoffille) {
        this.idoffille = idoffille;
    }

    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant) {
        this.montant = montant;
    }

    public String getIdunitelib() {
        return idunitelib;
    }

    public void setIdunitelib(String idunitelib) {
        this.idunitelib = idunitelib;
    }

    public FabricationFillePratique() throws Exception {
        super.setNomTable("FABRICATIONFILLEPRATIQUE");
    }

}
