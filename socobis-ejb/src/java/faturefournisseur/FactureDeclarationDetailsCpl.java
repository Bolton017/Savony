/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package faturefournisseur;

import chatbot.AiTabDesc;
import chatbot.ClassIA;

import java.sql.Date;

@AiTabDesc("La structure de ma table d'achat et depesnes est comme ceci: ")
public class FactureDeclarationDetailsCpl extends FactureDeclarationDetails implements ClassIA {
    protected String idProduitLib;
    protected String idMagasin;
    protected String idMagasinLib;
    protected String idPoint;
    protected String idPointLib;
    protected double montanttotal, montantavecfraisaccessoire, puavecfraisaccessoire;
    protected String idCategorie;
    protected String idCategorieLib;
    protected Date daty;
    String libelleexacte;

    @Override
    public String getNomTableIA() {
        return "FFFILLECPL_VISEE";
    }
    @Override
    public String getUrlListe() {
        return "/socobis/pages/module.jsp?but=facturefournisseur/facturedeclaration-liste.jsp&currentMenu=MNDN000000007";
    }
    @Override
    public String getUrlAnalyse() {
        return "/socobis/pages/module.jsp?but=facturefournisseur/achat-analyse.jsp";
    }
    @Override
    public String getUrlSaisie() {
        return "/socobis/pages/module.jsp?but=facturefournisseur/facturedeclaration-saisie.jsp&currentMenu=MNDN000000014";
    }
    @Override
    public ClassIA getClassListe() {
        return this;
    }
    @Override
    public ClassIA getClassAnalyse() {
        return this;
    }

    @Override
    public ClassIA getClassSaisie() {
        return this;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public String getIdCategorie() {
        return idCategorie;
    }

    public void setIdCategorie(String idCategorie) {
        this.idCategorie = idCategorie;
    }

    public String getIdCategorieLib() {
        return idCategorieLib;
    }

    public void setIdCategorieLib(String idCategorieLib) {
        this.idCategorieLib = idCategorieLib;
    }

    public double getMontantavecfraisaccessoire() {
        return montantavecfraisaccessoire;
    }

    public void setMontantavecfraisaccessoire(double montantavecfraisaccessoire) {
        this.montantavecfraisaccessoire = montantavecfraisaccessoire;
    }

    public double getPuavecfraisaccessoire() {
        return puavecfraisaccessoire;
    }

    public void setPuavecfraisaccessoire(double puavecfraisaccessoire) {
        this.puavecfraisaccessoire = puavecfraisaccessoire;
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

    public String getIdPoint() {
        return idPoint;
    }

    public void setIdPoint(String idPoint) {
        this.idPoint = idPoint;
    }

    public String getIdPointLib() {
        return idPointLib;
    }

    public void setIdPointLib(String idPointLib) {
        this.idPointLib = idPointLib;
    }

    public double getMontanttotal() {
        return montanttotal;
    }

    public void setMontanttotal(double montanttotal) {
        this.montanttotal = montanttotal;
    }

    public FactureDeclarationDetailsCpl()throws Exception{
        super.setNomTable("FACTUREDECLARATIONFILLECPL");
    }

    public String getIdProduitLib() {
        return idProduitLib;
    }

    public void setIdProduitLib(String idProduitLib) {
        this.idProduitLib = idProduitLib;
    }
    public String getLibelleexacte() {
        return libelleexacte;
    }
    public void setLibelleexacte(String libelleexacte) {
        this.libelleexacte = libelleexacte;
    }
    
    
}
