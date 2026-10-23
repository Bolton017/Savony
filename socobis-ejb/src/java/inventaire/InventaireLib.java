/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package inventaire;


public class InventaireLib extends Inventaire{
    private String idmagasinlib, etatlib, idCategorielib;
    private String idDepartement, idDepartementLib;
    private double montantQuantite;

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
    
    public InventaireLib(){
        this.setNomTable("InventaireLib");
    }

    public String getIdmagasinlib() {
        return idmagasinlib;
    }

    public void setIdmagasinlib(String idmagasinlib) {
        this.idmagasinlib = idmagasinlib;
    }

    public String getEtatlib() {
        return etatlib;
    }

    public void setEtatlib(String etatlib) {
        this.etatlib = etatlib;
    }

    public String getIdCategorielib() {
        return idCategorielib;
    }

    public void setIdCategorielib(String idCategorielib) {
        this.idCategorielib = idCategorielib;
    }

    public double getMontantQuantite() {
        return montantQuantite;
    }

    public void setMontantQuantite(double montantQuantite) {
        this.montantQuantite = montantQuantite;
    }
}
