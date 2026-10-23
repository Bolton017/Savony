package paie.edition;

import bean.ClassFille;

import java.sql.Connection;

public class TraitementPaie extends ClassFille {

    private String id;
    private String nomPersonnel;
    private String matricule;
    private double netapayer;
    private String modepaiement;
    private String numeroCompte;
    private String idPersonnel;
    private String idEdition;
    private String modepaiementLib,etatLib,moisLib;
    private int annee;

    public TraitementPaie() throws Exception{
        super.setNomTable("TRAITEMENT_PAIE");
        super.setNomClasseMere("paie.edition.PaieEditionmoisannee");
        super.setLiaisonMere("idEdition");
    }

    @Override
    public String getNomClasseMere() {
        return "paie.edition.PaieEditionmoisannee";
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("TRP", "getseq_traitementpaie");
        this.setId(makePK(c));
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getNomPersonnel() {
        return nomPersonnel;
    }

    public void setNomPersonnel(String nomPersonnel) {
        this.nomPersonnel = nomPersonnel;
    }

    public String getMatricule() {
        return matricule;
    }

    public void setMatricule(String matricule) {
        this.matricule = matricule;
    }

    public double getNetapayer() {
        return netapayer;
    }

    public void setNetapayer(double netapayer) {
        this.netapayer = netapayer;
    }

    public String getModepaiement() {
        return modepaiement;
    }

    public void setModepaiement(String modepaiement) {
        this.modepaiement = modepaiement;
    }

    public String getNumeroCompte() {
        return numeroCompte;
    }

    public void setNumeroCompte(String numeroCompte) {
        this.numeroCompte = numeroCompte;
    }

    public String getIdPersonnel() {
        return idPersonnel;
    }

    public void setIdPersonnel(String idPersonnel) {
        this.idPersonnel = idPersonnel;
    }

    public String getIdEdition() {
        return idEdition;
    }

    public void setIdEdition(String idEdition) {
        this.idEdition = idEdition;
    }

    public String getModepaiementLib() {
        return modepaiementLib;
    }

    public void setModepaiementLib(String modepaiementLib) {
        this.modepaiementLib = modepaiementLib;
    }

    public String getEtatLib() {
        return etatLib;
    }

    public void setEtatLib(String etatLib) {
        this.etatLib = etatLib;
    }

    public String getMoisLib() {
        return moisLib;
    }

    public void setMoisLib(String moisLib) {
        this.moisLib = moisLib;
    }

    public int getAnnee() {
        return annee;
    }

    public void setAnnee(int annee) {
        this.annee = annee;
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }
}
