package paiement;

import java.sql.Date;

public class LiaisonPaiementAchat extends LiaisonPaiement{
    String idfacturefournisseur, designation;
    Date daty;

    public LiaisonPaiementAchat() {
        this.setNomTable("V_LIAISONPAIEMENT_FACTUREFOURN");
    }

    public String getIdfacturefournisseur() {
        return idfacturefournisseur;
    }

    public void setIdfacturefournisseur(String idfacturefournisseur) {
        this.idfacturefournisseur = idfacturefournisseur;
    }

    public String getDesignation() {
        return designation;
    }

    public void setDesignation(String designation) {
        this.designation = designation;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }
}
