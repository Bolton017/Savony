/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package vente;

import bean.ClassMAPTable;
import java.sql.Date;

/**
 *
 * @author maroussia
 */
public class As_BonDeLivraisonClientFilleBc extends ClassMAPTable {

    String idBc, id, produit, idproduit;
    double quantite;
    Date daty;

    public String getIdBc() {
        return idBc;
    }

    public void setIdBc(String idBc) {
        this.idBc = idBc;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getProduit() {
        return produit;
    }

    public void setProduit(String produit) {
        this.produit = produit;
    }

    public String getIdproduit() {
        return idproduit;
    }

    public void setIdproduit(String idproduit) {
        this.idproduit = idproduit;
    }

    public double getQuantite() {
        return quantite;
    }

    public void setQuantite(double quantite) {
        this.quantite = quantite;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public As_BonDeLivraisonClientFilleBc() {
        setNomTable("BL_CLIENT_FILLE_BC ");
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
