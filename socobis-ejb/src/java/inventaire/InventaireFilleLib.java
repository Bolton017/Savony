/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package inventaire;


import java.sql.Date;

public class InventaireFilleLib extends InventaireFille{
    private String idproduitlib,libelleexacte, compteLocalisationLib;
    private double ecart;
    private String parfums;
    private String unite, idUniteLib;
    private double montantTheorique , montantReelle ,ecartMontant ;
    private Date dateInv;
    private String idMagasin, idMagasinLib, idDepartement, idDepartementLib, mvtSrc;

    public String getIdDepartement() {
        return idDepartement;
    }

    public void setIdDepartement(String idDepartement) {
        this.idDepartement = idDepartement;
    }

    public String getIdDepartementLib() {
        return idDepartementLib;
    }

    public void setIdDepartementLib(String idDepartementLib) {
        this.idDepartementLib = idDepartementLib;
    }

    public String getIdMagasin() {
        return idMagasin;
    }

    public void setIdMagasin(String idMagasin) {
        this.idMagasin = idMagasin;
    }

    public String getIdMagasinLib() {
        return idMagasinLib;
    }

    public void setIdMagasinLib(String idMagasinLib) {
        this.idMagasinLib = idMagasinLib;
    }

    public Date getDateInv() {
        return dateInv;
    }

    public void setDateInv(Date dateInv) {
        this.dateInv = dateInv;
    }

    public double getEcartMontant() {
        return ecartMontant;
    }

    public void setEcartMontant(double ecartMontant) {
        this.ecartMontant = ecartMontant;
    }

    public String getIdUniteLib() {
        return idUniteLib;
    }

    public void setIdUniteLib(String idUniteLib) {
        this.idUniteLib = idUniteLib;
    }

    public double getMontantReelle() {
        return montantReelle;
    }

    public void setMontantReelle(double montantReelle) {
        this.montantReelle = montantReelle;
    }

    public double getMontantTheorique() {
        return montantTheorique;
    }

    public void setMontantTheorique(double montantTheorique) {
        this.montantTheorique = montantTheorique;
    }

    public String getUnite() {
        return unite;
    }

    public void setUnite(String unite) {
        this.unite = unite;
    }

    public double getEcart() {
        return ecart;
    }

    public void setEcart(double ecart) {
        this.ecart = ecart;
    }

    public InventaireFilleLib() throws Exception{
        this.setNomTable("InventaireFilleLib");
    }

    public String getIdproduitlib() {
        return idproduitlib;
    }

    public void setIdproduitlib(String idproduitlib) {
        this.idproduitlib = idproduitlib;
    }

    public String getLibelleexacte() {
        return libelleexacte;
    }

    public void setLibelleexacte(String libelleexacte) {
        this.libelleexacte = libelleexacte;
    }

    public String getParfums() {
        return parfums;
    }

    public void setParfums(String parfums) {
        this.parfums = parfums;
    }

    public String getCompteLocalisationLib() {
        return compteLocalisationLib;
    }

    public void setCompteLocalisationLib(String compteLocalisationLib) {
        this.compteLocalisationLib = compteLocalisationLib;
    }

    public String getMvtSrc() {
        return mvtSrc;
    }

    public void setMvtSrc(String mvtSrc) {
        this.mvtSrc = mvtSrc;
    }
}
