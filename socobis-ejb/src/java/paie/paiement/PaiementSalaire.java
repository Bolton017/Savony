package paie.paiement;

import bean.ClassEtat;
import java.sql.Connection;
import java.sql.Date;

public class PaiementSalaire  extends ClassEtat {
    private String id;
    private String idEdition;
    private String idPersonnel;
    private double montant;
    private String idModePaiement;
    private Date daty;
    private Date datepaiement;
    private String numeroCompte;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdEdition() {
        return idEdition;
    }

    public void setIdEdition(String idEdition) {
        this.idEdition = idEdition;
    }

    public String getIdPersonnel() {
        return idPersonnel;
    }

    public void setIdPersonnel(String idPersonnel) {
        this.idPersonnel = idPersonnel;
    }

    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant) {
        this.montant = montant;
    }

    public String getIdModePaiement() {
        return idModePaiement;
    }

    public void setIdModePaiement(String idModePaiement) {
        this.idModePaiement = idModePaiement;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public Date getDatepaiement() {
        return datepaiement;
    }

    public void setDatepaiement(Date datepaiement) {
        this.datepaiement = datepaiement;
    }



    public PaiementSalaire () throws Exception {
        this.setNomTable("PAIEMENT_SALAIRE");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("PTS","GETSEQPAIEMENTSALAIRE");
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

    public String getNumeroCompte() {
        return numeroCompte;
    }

    public void setNumeroCompte(String numeroCompte) {
        this.numeroCompte = numeroCompte;
    }
}

