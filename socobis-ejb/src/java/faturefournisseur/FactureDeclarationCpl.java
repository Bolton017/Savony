/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package faturefournisseur;

/**
 *
 * @author nouta
 */
public class FactureDeclarationCpl extends FactureDeclaration{
    protected String idModePaiementLib,idFournisseurLib,idMagasinLib , etatlib,idPrevision;
    protected double montantTTCAriary, montantpaye , montantreste;
    private String idDevise;
    protected double  tauxdechange;
    protected String idObjetLib,idEntite,idRefLib,idLigne,idLigneLib, typefacture;

    private String idTravaux;

    public String getIdRefLib() {
        return idRefLib;
    }

    public void setIdRefLib(String idRefLib) {
        this.idRefLib = idRefLib;
    }

    public String getIdEntite() {
        return idEntite;
    }

    public void setIdEntite(String idEntite) {
        this.idEntite = idEntite;
    }

    public String getIdObjetLib() {
        return idObjetLib;
    }

    public void setIdObjetLib(String idObjetLib) {
        this.idObjetLib = idObjetLib;
    }

    public double getTauxdechange() {
        return tauxdechange;
    }

    public void setTauxdechange(double tauxdechange) {
        this.tauxdechange = tauxdechange;
    }
    public String getIdDevise() {
        return idDevise;
    }

    public void setIdDevise(String idDevise) {
        this.idDevise = idDevise;
    }

    public String getIdPrevision() {
        return idPrevision;
    }

    public void setIdPrevision(String idPrevision) {
        this.idPrevision = idPrevision;
    }


    public double getMontantTTCAriary() {
        return montantTTCAriary;
    }

    public void setMontantTTCAriary(double montantTTCAriary) {
        this.montantTTCAriary = montantTTCAriary;
    }

    public double getMontantpaye() {
        return montantpaye;
    }

    public void setMontantpaye(double montantpaye) {
        this.montantpaye = montantpaye;
    }

    public double getMontantreste() {
        return montantreste;
    }

    public void setMontantreste(double montantreste) {
        this.montantreste = montantreste;
    }

    protected double montant , montantPayer , montantReste ;
    public String getEtatlib() {
        return etatlib;
    }

    public void setEtatlib(String etatlib) {
        this.etatlib = etatlib;
    }
    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant) {
        this.montant = montant;
    }

    public double getMontantPayer() {
        return montantPayer;
    }

    public void setMontantPayer(double montantPayer) {
        this.montantPayer = montantPayer;
    }

    public double getMontantReste() {
        return montantReste;
    }

    public void setMontantReste(double montantReste) {
        this.montantReste = montantReste;
    }

    public String getIdMagasinLib() {
        return idMagasinLib;
    }

    public void setIdMagasinLib(String idMagasinLib) {
        this.idMagasinLib = idMagasinLib;
    }

    public FactureDeclarationCpl() {
        super.setNomTable("FACTUREDECLARATIONCPL");
    }

    public String getTypefacture() {
        return typefacture;
    }

    public void setTypefacture(String typefacture) {
        this.typefacture = typefacture;
    }

    public String getIdModePaiementLib() {
        return idModePaiementLib;
    }

    public void setIdModePaiementLib(String idModePaiementLib) {
        this.idModePaiementLib = idModePaiementLib;
    }

    public String getIdFournisseurLib() {
        return idFournisseurLib;
    }

    public void setIdFournisseurLib(String idFournisseurLib) {
        this.idFournisseurLib = idFournisseurLib;
    }

    public String getIdLigne() {
        return idLigne;
    }

    public void setIdLigne(String idLigne) {
        this.idLigne = idLigne;
    }

    public String getIdLigneLib() {
        return idLigneLib;
    }

    public void setIdLigneLib(String idLigneLib) {
        this.idLigneLib = idLigneLib;
    }

    public String getIdTravaux() {
        return idTravaux;
    }

    public void setIdTravaux(String idTravaux) {
        this.idTravaux = idTravaux;
    }
}
