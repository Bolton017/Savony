/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package vente;

import bean.LibelleAffichage;
import chatbot.AiTabDesc;
import chatbot.ClassIA;
import encaissement.EncaissementDetails;
import utils.ConstanteAsync;

import java.sql.Date;

/**
 *
 * @author Angela
 */
@AiTabDesc("La structure de ma table de vente est comme ceci: ")
public class VenteDetailsLib  extends VenteDetails implements ClassIA {

    @LibelleAffichage("Produit")protected String idProduitLib;
    protected String idCategorie;
    @LibelleAffichage("Cat&eacute;gorie")
    protected String idCategorieLib;
    protected double puRevient;
    protected  double puTotal;
    @LibelleAffichage("Date")
    protected Date daty;
    protected String idMagasin;
    @LibelleAffichage("Magasin")
    protected String idMagasinLib;
    protected String idPoint;
    @LibelleAffichage("Point")
    protected String idPointLib;
    protected double reste,montant;
    protected String idUnite;
    @LibelleAffichage("Devise")
    protected String idDeviseLib;
    protected String unitelib;
    private String categorieproduitlib;
    private String idclientlib;
    protected Date datyprevu;
    private double punet, montantht,montantttc,montantremise,poids,frais;
    private double pvTva;

    public double getPvTva() {
        return pvTva;
    }

    public void setPvTva(double pvTva) {
        this.pvTva = pvTva;
    }

    public String getIdclientlib() {
        return idclientlib;
    }

    public void setIdclientlib(String idclientlib) {
        this.idclientlib = idclientlib;
    }
    public String getCategorieproduitlib() {
        return categorieproduitlib;
    }

    public void setCategorieproduitlib(String categorieproduitlib) {
        this.categorieproduitlib = categorieproduitlib;
    }
     public Date getDatyprevu() {
        return datyprevu;
    }
    public void setDatyprevu(Date datyprevu) {
        this.datyprevu = datyprevu;
    }
    public double getFrais() {
        return frais;
    }

    public void setFrais(double frais) {
        this.frais = frais;
    }

    public double getPoids() {
        return poids;
    }

    public void setPoids(double poids) {
        this.poids = poids;
    }

    public double getMontantremise() {
        return montantremise;
    }

    public void setMontantremise(double montantremise) {
        this.montantremise = montantremise;
    }

    public String getUnitelib() {
        return unitelib;
    }

    public void setUnitelib(String unitelib) {
        this.unitelib = unitelib;
    }

    public double getPunet() {
        return punet;
    }

    public void setPunet(double punet) {
        this.punet = punet;
    }

    public double getMontantht() {
        return montantht;
    }

    public void setMontantht(double montantht) {
        this.montantht = montantht;
    }

    public double getMontantttc() {
        return montantttc;
    }

    public void setMontantttc(double montantttc) {
        this.montantttc = montantttc;
    }

    @Override
    public String getNomTableIA() {
        return "VENTE_DETAILS_CPL_2_VISEE";
    }
    @Override
    public String getUrlListe() {
        return "/savonnerie/pages/module.jsp?but=vente/vente-liste.jsp&currentMenu=MNDN000000007";
    }
    @Override
    public String getUrlAnalyse() {
        return "/savonnerie/pages/module.jsp?but=vente/vente-analyse.jsp&currentMenu=MNDN0000000111";
    }
    @Override
    public String getUrlSaisie() {
        return "/savonnerie/pages/module.jsp?but=vente/vente-saisie.jsp&currentMenu=MNDN000000006";
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
    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant) {
        this.montant = montant;
    }
    
    public double getReste() {
        return reste;
    }

    public void setReste(double reste) {
        this.reste = reste;
    }

    public String getIdUnite() {
        return idUnite;
    }

    public void setIdUnite(String idUnite) {
        this.idUnite = idUnite;
    }

    public String getIdDeviseLib() {
        return idDeviseLib;
    }

    public void setIdDeviseLib(String idDeviseLib) {
        this.idDeviseLib = idDeviseLib;
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

    public double getPuRevient() {
        return puRevient;
    }

    public void setPuRevient(double puRevient) {
        this.puRevient = puRevient;
    }

    public VenteDetailsLib() {
        this.setNomTable("VENTE_DETAILS_LIB");
    }
    
    

    public String getIdProduitLib() {
        return idProduitLib;
    }

    public void setIdProduitLib(String idProduitLib) {
        this.idProduitLib = idProduitLib;
    }

    public double getPuTotal() {
        return puTotal;
    }

    public void setPuTotal(double puTotal) {
        this.puTotal = puTotal;
    }

    
        public EncaissementDetails generateEncaissementDetails()throws Exception{
        EncaissementDetails encaissementDetails = new EncaissementDetails();
        encaissementDetails.setMontant(montant);
        encaissementDetails.setIdOrigine(this.getId());
        encaissementDetails.setIdDevise(this.getIdDevise());
        encaissementDetails.setRemarque("Encaissement Vente "+this.getIdProduitLib());
        
        return encaissementDetails;
    }

    public double getMargeBrute() {
        return margeBrute;
    }


}
