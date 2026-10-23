package paiement;

import java.sql.Date;

public class LiaisonPaiementVente extends LiaisonPaiement{
    String idvente, designation;
    Date daty;



    public LiaisonPaiementVente() {
        this.setNomTable("V_LIAISONPAIEMENT_VENTE");
    }

    public String getIdvente() {
        return idvente;
    }

    public void setIdvente(String idvente) {
        this.idvente = idvente;
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
