/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package faturefournisseur;

import bean.LibelleAffichage;
import caisse.MvtCaisse;
import java.sql.Connection;
import utilitaire.UtilDB;

/**
 *
 * @author nouta
 */
public class FactureFournisseurCpl extends FactureFournisseur{
    @LibelleAffichage("Mode de paiement")
    protected String idModePaiementLib;

    @LibelleAffichage("Fournisseur")
    protected String idFournisseurLib;

    @LibelleAffichage("Magasin")
    protected String idMagasinLib;

    @LibelleAffichage("&eacute;tat")
    protected String etatlib;

    @LibelleAffichage("Pr&eacute;vision")
    protected String idPrevision;

    @LibelleAffichage("Montant TTC en Ariary")
    protected double montantTTCAriary;

    @LibelleAffichage("Montant pay&eacute;")
    protected double montantpaye;

    @LibelleAffichage("Montant restant")
    protected double montantreste;

    @LibelleAffichage("Devise")
    private String idDevise;

    @LibelleAffichage("Taux de change")
    protected double tauxdechange;

    @LibelleAffichage("Objet")
    protected String idObjetLib;

    @LibelleAffichage("Entit&eacute;")
    protected String idEntite;

    @LibelleAffichage("R&eacute;f&eacute;rence")
    protected String idRefLib;

    @LibelleAffichage("Ligne")
    protected String idLigne;

    @LibelleAffichage("Libell&eacute; ligne")
    protected String idLigneLib;

    @LibelleAffichage("Type de facture")
    protected String typefacture;

    @LibelleAffichage("&eacute;tat prix")
    String etatPrix;

    @LibelleAffichage("&eacute;criture")
    private String idEcriture;

    @LibelleAffichage("Type de facture fournisseur")
    private String typeFactureFournisseurLib;

    @LibelleAffichage("Type d'achat")
    protected String typeAchatLib;

    public String getTypeAchatLib() {
        return typeAchatLib;
    }

    public void setTypeAchatLib(String typeAchatLib) {
        this.typeAchatLib = typeAchatLib;
    }

    public String getIdEcriture() {
        return idEcriture;
    }

    public void setIdEcriture(String idEcriture) {
        this.idEcriture = idEcriture;
    }

    public String getTypeFactureFournisseurLib() {
        return typeFactureFournisseurLib;
    }

    public void setTypeFactureFournisseurLib(String typeFactureFournisseurLib) {
        this.typeFactureFournisseurLib = typeFactureFournisseurLib;
    }

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

    public FactureFournisseurCpl() {
        super.setNomTable("FACTUREFOURNISSEURCPL");
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
