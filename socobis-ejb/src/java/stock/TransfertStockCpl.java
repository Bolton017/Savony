/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package stock;

/**
 *
 * @author 26134
 */
public class TransfertStockCpl extends TransfertStock{
    String idMagasinDepartLib,idMagasinArriveLib,etatlib,compteLocalisationDepartLib, compteLocalisationArriveeib;
    String idDepartementLibDepart, idDepartementLibArrive, idDepartementDepart, idDepartementArrive;
    double montantQuantite;

    public double getMontantQuantite() {
        return montantQuantite;
    }

    public void setMontantQuantite(double montantQuantite) {
        this.montantQuantite = montantQuantite;
    }

    public String getIdDepartementArrive() {
        return idDepartementArrive;
    }

    public void setIdDepartementArrive(String idDepartementArrive) {
        this.idDepartementArrive = idDepartementArrive;
    }

    public String getIdDepartementDepart() {
        return idDepartementDepart;
    }

    public void setIdDepartementDepart(String idDepartementDepart) {
        this.idDepartementDepart = idDepartementDepart;
    }

    public String getIdDepartementLibArrive() {
        return idDepartementLibArrive;
    }

    public void setIdDepartementLibArrive(String idDepartementLibArrive) {
        this.idDepartementLibArrive = idDepartementLibArrive;
    }

    public String getIdDepartementLibDepart() {
        return idDepartementLibDepart;
    }

    public void setIdDepartementLibDepart(String idDepartementLibDepart) {
        this.idDepartementLibDepart = idDepartementLibDepart;
    }

    public String getIdMagasinDepartLib() {
        return idMagasinDepartLib;
    }

    public void setIdMagasinDepartLib(String idMagasinDepartLib) {
        this.idMagasinDepartLib = idMagasinDepartLib;
    }

    public String getIdMagasinArriveLib() {
        return idMagasinArriveLib;
    }

    public void setIdMagasinArriveLib(String idMagasinArriveLib) {
        this.idMagasinArriveLib = idMagasinArriveLib;
    }
    
    public TransfertStockCpl() throws Exception{
        this.setNomTable("TransfertStockCpl");
    }

    public String getEtatlib() {
        return etatlib;
    }

    public void setEtatlib(String etatlib) {
        this.etatlib = etatlib;
    }

    public String getCompteLocalisationDepartLib() {
        return compteLocalisationDepartLib;
    }

    public void setCompteLocalisationDepartLib(String compteLocalisationDepartLib) {
        this.compteLocalisationDepartLib = compteLocalisationDepartLib;
    }

    public String getCompteLocalisationArriveeib() {
        return compteLocalisationArriveeib;
    }

    public void setCompteLocalisationArriveeib(String compteLocalisationArriveeib) {
        this.compteLocalisationArriveeib = compteLocalisationArriveeib;
    }
}
