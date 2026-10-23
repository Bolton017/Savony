/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package vente;

import bean.LibelleAffichage;

/**
 *
 * @author Angela
 */
public class VenteLib extends Vente{
    @LibelleAffichage("Magasin")
    private String idMagasinLib;
    private String idOrigine;
    private String etatLib;
    private double montanttotal;
    private String idDevise;
    @LibelleAffichage("Client")
    private String idClientLib;
    @LibelleAffichage("Montant pay&eacute;")
    private double montantpaye;
    @LibelleAffichage("Montant restant")
    private double montantreste;
    @LibelleAffichage("Montant TTC")
    private double montantttc;
    @LibelleAffichage("Montant pay&eacute; (AR)")
    private double montantpayeAr;
    @LibelleAffichage("Montant restant (AR)")
    private double montantresteAr;
    @LibelleAffichage("Montant TTC (AR)")
    private double montantttcAr;
    private double montantRetourner;
    double montantTtcAr;
    protected double avoir, montantremise,montant,poids;
    private String referencefacture,modepaiementlib,idResponsableLib;
    private int mois;
    @LibelleAffichage("Ann&eacute;e")
    private int annee;
    @LibelleAffichage("Province")
    private String provincelib;
    private String modelivraisonlib, idprovince, livraison,commercialLib;
    private double frais;
    private double colis, montantimpute;
    private String idZoneClientLib;
    private String idModePaiementLib;
    private String idEcriture;

    public String getIdEcriture() {
        return idEcriture;
    }

    public void setIdEcriture(String idEcriture) {
        this.idEcriture = idEcriture;
    }

    public String getIdModePaiementLib() {
        return idModePaiementLib;
    }

    public void setIdModePaiementLib(String idModePaiementLib) {
        this.idModePaiementLib = idModePaiementLib;
    }

    public String getIdZoneClientLib() {
            return idZoneClientLib;
        }

    public void setIdZoneClientLib(String idZoneClientLib) {
        this.idZoneClientLib = idZoneClientLib;
    }
    public String getCommercialLib() {
        return commercialLib;
    }

    public void setCommercialLib(String commercialLib) {
        this.commercialLib = commercialLib;
    }

    public void setMontantRetourner(double montantRetourner) {
        this.montantRetourner = montantRetourner;
    }

    public double getMontantRetourner() {
        return montantRetourner;
    }

    public String getIdResponsableLib() {
        return idResponsableLib;
    }

    public void setIdResponsableLib(String idResponsableLib) {
        this.idResponsableLib = idResponsableLib;
    }

    public String getLivraison() {
        return livraison;
    }

    public void setLivraison(String livraison) {
        this.livraison = livraison;
    }

    public double getFrais() {
        return frais;
    }

    public void setFrais(double frais) {
        this.frais = frais;
    }

    public String getModelivraisonlib() {
        return modelivraisonlib;
    }

    public void setModelivraisonlib(String modelivraisonlib) {
        this.modelivraisonlib = modelivraisonlib;
    }

    public String getModepaiementlib() {
        return modepaiementlib;
    }

    public void setModepaiementlib(String modepaiementlib) {
        this.modepaiementlib = modepaiementlib;
    }

    public double getPoids() {
        return poids;
    }

    public void setPoids(double poids) {
        this.poids = poids;
    }

    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant) {
        this.montant = montant;
    }

    public double getMontantremise() {
        return montantremise;
    }

    public void setMontantremise(double montantremise) {
        this.montantremise = montantremise;
    }

    public String getIdOrigine() {
        return idOrigine;
    }

    public void setIdOrigine(String idOrigine) {
        this.idOrigine = idOrigine;
    }
    

    public double getAvoir() {
        return avoir;
    }

    public void setAvoir(double avoir) {
        this.avoir = avoir;
    }

    public String getDesignation() {
        return designation;
    }

    public int getMois() {
        return mois;
    }

    public void setMois(int mois) {
        this.mois = mois;
    }

    public String getIdprovince() {
        return idprovince;
    }

    public void setIdprovince(String idprovince) {
        this.idprovince = idprovince;
    }

    public String getProvincelib() {
        return provincelib;
    }

    public void setProvincelib(String provincelib) {
        this.provincelib = provincelib;
    }

    public int getAnnee() {
        return annee;
    }

    public void setAnnee(int annee) {
        this.annee = annee;
    }

    public double getMontantTtcAr() {
        return montantTtcAr;
    }

    public void setMontantTtcAr(double montantTtcAr) {
        this.montantTtcAr = montantTtcAr;
    }

    public double getMontantttc() {
        return montantttc;
    }

    public void setMontantttc(double montantttc) {
        this.montantttc = montantttc;
    }
        

    public void setMontantpaye(double montantpaye) {
        this.montantpaye = montantpaye;
    }

    public double getMontantpaye() {
        return montantpaye;
    }

    public void setMontantreste(double montantreste) {
        this.montantreste = montantreste;
    }

    public double getMontantreste() {
        return montantreste;
    }

    public String getIdClientLib() {
        return idClientLib;
    }

    public void setIdClientLib(String idClientLib) {
        this.idClientLib = idClientLib;
    }

    public String getIdDevise() {
        return idDevise;
    }

    public void setIdDevise(String idDevise) {
        this.idDevise = idDevise;
    }

    public double getMontanttotal() {
        return montanttotal;
    }

    public void setMontanttotal(double montanttotal) {
        this.montanttotal = montanttotal;
    }

    public VenteLib() {
        this.setNomTable("VENTE_CPL");
    }

    public String getIdMagasinLib() {
        return idMagasinLib;
    }

    public void setIdMagasinLib(String idMagasinLib) {
        this.idMagasinLib = idMagasinLib;
    }

    public String getEtatLib() {
        return etatLib;
    }

    public String getChaineEtat(){
        return chaineEtat(this.getEtat());
    }

    public void setEtatLib(String etatLib) {
        this.etatLib = etatLib;
    }

    public String getReferencefacture() {
        return referencefacture;
    }

    public double getMontantimpute() {
        return montantimpute;
    }

    public void setMontantimpute(double montantimpute) {
        this.montantimpute = montantimpute;
    }

    public void setReferencefacture(String referencefacture) {
        this.referencefacture = referencefacture;
    }
    public double getColis() {
        return colis;
    }

    public void setColis(double colis) {
        this.colis = colis;
    }
}
