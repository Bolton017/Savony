/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package stock;


import java.sql.Date;

public class MvtStockFilleLib extends MvtStockFille{
    private String idProduitlib, idVenteDetaillib, idTransfertDetaillib , libelleexacte, idMagasinLib, idMagasin, mvtsrc,compteLocalisationLib;
    private String libelle , idObjet , idLot;
    private String daty;
    private Date dateSql;
    private String iddepartement,departementlib;
    private String etatLib;
    private String idDepartementLib;


    public String getIdDepartementLib() {
        return idDepartementLib;
    }

    public void setIdDepartementLib(String idDepartementLib) {
        this.idDepartementLib = idDepartementLib;
    }

    public String getEtatLib() {
        return etatLib;
    }

    public void setEtatLib(String etatLib) {
        this.etatLib = etatLib;
    }

    public MvtStockFilleLib() throws Exception{
        setNomTable("mvtstockfillelib");
    }

    public String getIddepartement() {
        return iddepartement;
    }

    public void setIddepartement(String iddepartement) {
        this.iddepartement = iddepartement;
    }

    public String getDepartementlib() {
        return departementlib;
    }

    public void setDepartementlib(String departementlib) {
        this.departementlib = departementlib;
    }

    public String getCompteLocalisationLib() {
        return compteLocalisationLib;
    }

    public void setCompteLocalisationLib(String compteLocalisationLib) {
        this.compteLocalisationLib = compteLocalisationLib;
    }

    public String getIdObjet() {
        return idObjet;
    }

    public void setIdObjet(String idObjet) {
        this.idObjet = idObjet;
    }

    public String getIdLot() {
        return idLot;
    }

    public void setIdLot(String idLot) {
        this.idLot = idLot;
    }

    public Date getDateSql() {
        return dateSql;
    }

    public void setDateSql(Date dateSql) {
        this.dateSql = dateSql;
    }

    public String getMvtsrc() {
        return mvtsrc;
    }

    public void setMvtsrc(String mvtsrc) {
        this.mvtsrc = mvtsrc;
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

    public String getDaty() {
        return daty;
    }

    public void setDaty(String daty) {
        this.daty = daty;
    }

    public String getIdProduitlib() {
        return idProduitlib;
    }

    public void setIdProduitlib(String idProduitlib) {
        this.idProduitlib = idProduitlib;
    }

    public String getIdVenteDetaillib() {
        return idVenteDetaillib;
    }

    public void setIdVenteDetaillib(String idVenteDetaillib) {
        this.idVenteDetaillib = idVenteDetaillib;
    }

    public String getIdTransfertDetaillib() {
        return idTransfertDetaillib;
    }

    public void setIdTransfertDetaillib(String idTransfertDetaillib) {
        this.idTransfertDetaillib = idTransfertDetaillib;
    }

    public String getLibelleexacte() {
        return libelleexacte;
    }

    public void setLibelleexacte(String libelleexacte) {
        this.libelleexacte = libelleexacte;
    }


    public String getLibelle() {
        return libelle;
    }

    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }

    @Override
    public String[] getMotCles() {
        String[] motCles={"id","libelleexacte","pu","daty"};
        return motCles;
    }

    @Override
    public String[] getValMotCles() {
        String[] valMotCles={"id","libelleexacte","daty"};
        return valMotCles;
    }
}
