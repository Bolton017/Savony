/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package stock;


public class MvtStockLib extends MvtStock{
    private String idMagasinlib, idVentelib, idTransfertlib, idTypeMvStocklib, etatlib;
    double montantEntree,montantSortie;
    private String idDepartement, idDepartementLib, idCategorieStockLib;

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

    public double getMontantEntree() {
        return montantEntree;
    }
    public double getMontantTot()
    {
        double retour=this.getMontantSortie();
        if(retour==0) return this.getMontantEntree();
        return retour;
    }

    public void setMontantEntree(double montantEntree) {
        this.montantEntree = montantEntree;
    }

    public double getMontantSortie() {
        return montantSortie;
    }

    public void setMontantSortie(double montantSortie) {
        this.montantSortie = montantSortie;
    }

    public MvtStockLib() throws Exception{
        setNomTable("mvtstocklib");
    }

    public String getIdMagasinlib() {
        return idMagasinlib;
    }

    public void setIdMagasinlib(String idMagasinlib) {
        this.idMagasinlib = idMagasinlib;
    }

    public String getIdVentelib() {
        return idVentelib;
    }

    public void setIdVentelib(String idVentelib) {
        this.idVentelib = idVentelib;
    }

    public String getIdTransfertlib() {
        return idTransfertlib;
    }

    public void setIdTransfertlib(String idTransfertlib) {
        this.idTransfertlib = idTransfertlib;
    }

    public String getIdTypeMvStocklib() {
        return idTypeMvStocklib;
    }

    public void setIdTypeMvStocklib(String idTypeMvStocklib) {
        this.idTypeMvStocklib = idTypeMvStocklib;
    }

    public String getEtatlib() {
        return etatlib;
    }

    public void setEtatlib(String etatlib) {
        this.etatlib = etatlib;
    }

    public String getIdCategorieStockLib() {
        return idCategorieStockLib;
    }

    public void setIdCategorieStockLib(String idCategorieStockLib) {
        this.idCategorieStockLib = idCategorieStockLib;
    }
}
