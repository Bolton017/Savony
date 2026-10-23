package maintenance.travaux;

import produits.RecetteLib;

import java.sql.Connection;

public class TravauxFille extends OrdreTravauxFille{
    double pu;
    RecetteLib[] listeRecette;
    double prixRevient;
    double resteStock,fabEnCours,raf;
    int niveau;
    String idMachine;
    double nbPetris;

    public TravauxFille() throws Exception {
        super.setNomTable("TRAVAUXFILLE");
        setLiaisonMere("idMere");
        setNomClasseMere("travaux.Travaux");
    }
    public void construirePK(Connection c) throws Exception {
        this.preparePk("TRAF", "getseqTRAVAUXFILLE");
        this.setId(makePK(c));
    }

    public double getPu() {
        return pu;
    }

    public void setPu(double pu) {
        this.pu = pu;
    }

    public RecetteLib[] getListeRecette() {
        return listeRecette;
    }

    public void setListeRecette(RecetteLib[] listeRecette) {
        this.listeRecette = listeRecette;
    }

    public double getPrixRevient() {
        return prixRevient;
    }

    public void setPrixRevient(double prixRevient) {
        this.prixRevient = prixRevient;
    }

    public double getResteStock() {
        return resteStock;
    }

    public void setResteStock(double resteStock) {
        this.resteStock = resteStock;
    }

    public double getFabEnCours() {
        return fabEnCours;
    }

    public void setFabEnCours(double fabEnCours) {
        this.fabEnCours = fabEnCours;
    }

    public double getRaf() {
        return raf;
    }

    public void setRaf(double raf) {
        this.raf = raf;
    }

    public int getNiveau() {
        return niveau;
    }

    public void setNiveau(int niveau) {
        this.niveau = niveau;
    }

    public String getIdMachine() {
        return idMachine;
    }

    public void setIdMachine(String idMachine) {
        this.idMachine = idMachine;
    }

    public double getNbPetris() {
        return nbPetris;
    }

    public void setNbPetris(double nbPetris) {
        this.nbPetris = nbPetris;
    }
}
