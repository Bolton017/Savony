/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package faturefournisseur;

import bean.CGenUtil;
import bean.ClassFille;
import chatbot.FilleOcr;
import prevision.Prevision;
import produits.Ingredients;
import rapprochement.ReleverDetailCpl;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;
import utils.ConstanteStation;
import vente.VenteDetails;

import java.sql.Connection;
import java.util.logging.Level;
import java.util.logging.Logger;

public class FactureDeclarationDetails extends ClassFille{
    protected String id,idFactureFournisseur,idProduit,idbcDetail, compte,idDevise;
    protected double qte,pu,tva,remises, montantTva, montantTTC, montantHT, montant,taux,montantRemise;
    protected int etat;
    protected int mois, annee;
    protected double tauxDeChange;
    private double montantPerteGain;
    private String designation;
    private String idPrevision;

    public String getIdPrevision() {
        return idPrevision;
    }

    public void setIdPrevision(String idPrevision) {
        this.idPrevision = idPrevision;
    }

    public String getDesignation() {
        return designation;
    }

    public void setDesignation(String designation) {
        this.designation = designation;
    }

    public int getMois() {
        return mois;
    }

    public void setMois(int mois) {
        this.mois = mois;
    }

    public int getAnnee() {
        return annee;
    }

    public void setAnnee(int annee) {
        this.annee = annee;
    }

    public static FactureDeclarationDetails fromOcr(FilleOcr filleOcr) throws Exception {
        FactureDeclarationDetails details = new FactureDeclarationDetails();
        details.setQte(filleOcr.getQte());
        details.setPu(filleOcr.getPu());
        Ingredients ing = new Ingredients();
        Ingredients[] filles = (Ingredients[]) CGenUtil.rechercher(ing,null,null," and upper(libelle) like '%"+filleOcr.getIdProduit().toUpperCase()+"%'");
        if (filles!=null && filles.length>0) {
            details.setIdProduit(filles[0].getId());
        }
        return details;
    }
    public double getMontantRemise() {
        return montantRemise;
    }

    public void setMontantRemise(double montantRemise) {
        this.montantRemise = montantRemise;
    }

    public double getTauxDeChange() {
        if(tauxDeChange==0)return 1;
        return tauxDeChange;
    }

    public void setTauxDeChange(double tauxDeChange)throws  Exception{
        if (this.getMode().equals("modif")) {
            if (tauxDeChange < 0) {
                throw new Exception("elle ne peut pas etre negatif");
            }
        }
        this.tauxDeChange = tauxDeChange;
    }

    public String getIdDevise() {
        return idDevise;
    }

    public void setIdDevise(String idDevise)throws Exception {
        if (this.getMode().equals("modif")) {
            if (idDevise == null) {
                this.setIdDevise("AR");
            }
        }
        this.idDevise = idDevise;
    }

    public double getTaux() {
        return taux;
    }

    public void setTaux(double taux) throws Exception{
         if (this.getMode().equals("modif")) {
            if (taux <=0) {
               taux=1;
            }
        }
        this.taux = taux;
    }

    @Override
    public String getLiaisonMere() {
        return "idFactureFournisseur";
    }

    @Override
    public String getNomClasseMere() {
        return "faturefournisseur.FactureDeclaration";
    }

    public FactureDeclarationDetails() throws Exception {
        super.setNomTable("FACTUREDECLARATIONFILLE");
        this.setLiaisonMere("idFactureFournisseur");
        this.setNomClasseMere("faturefournisseur.FactureDeclaration");
    }
    public void construirePK(Connection c) throws Exception {
        this.preparePk("FFD", "GETSEQ_FACTUREDECLARATIONFILLE");
        this.setId(makePK(c));
    }

    public String getIdFactureFournisseur() {
        return idFactureFournisseur;
    }

    public void setIdFactureFournisseur(String idFactureFournisseur) {
        this.idFactureFournisseur = idFactureFournisseur;
    }
    
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdProduit() {
        return idProduit;
    }

    public void setIdProduit(String idProduit) {
        this.idProduit = idProduit;
    }

    public String getIdbcDetail() {
        return idbcDetail;
    }

    public void setIdbcDetail(String idbcDetail) {
        this.idbcDetail = idbcDetail;
    }

    public double getQte() {
        return qte;
    }

    public void setQte(double qte) throws Exception {
        if(this.getMode().equals("modif")){
            if(qte < 0){
                throw new Exception("Veuillez verifier, presence de quantite nulle ou negative");
            }
        }
        this.qte = qte;
    }

    public double getPu() {
        return pu;
    }

    public void setPu(double pu) throws Exception {
        if (this.getMode().equals("modif") && pu < 0) {
            throw new Exception("Pu ne peut pas &ecirc;tre inf&eacute;rieur &agrave; 0");
        }
        this.pu = pu;
    }

    public double getTva() {
        return tva;
    }

    public void setTva(double tva) {
        this.tva = tva;
    }

    public double getRemises() {
        return remises;
    }

    public void setRemises(double remises)throws Exception {
        if(this.getMode().compareToIgnoreCase("modif")==0)
        {
            if(remises>100||remises<0) throw new Exception("Remise invalide");
        }
        this.remises = remises;
    }

    public double getMontantTva() {
        return montantTva;
    }

    public void setMontantTva(double montantTva) {
        this.montantTva = montantTva;
    }

    public double getMontantTTC() {
        return montantTTC;
    }

    public void setMontantTTC(double montantTTC) {
        this.montantTTC = montantTTC;
    }

    public double getMontantHT() {
        return montantHT;
    }

    public void setMontantHT(double montantHT) {
        this.montantHT = montantHT;
    }

    public String getCompte() {
        return compte;
    }

    public void setCompte(String compte) throws Exception {
        if(this.getMode().equals("modif") && compte.isEmpty()){
            throw new Exception("Compte obligatoire pour les details");
        }
        this.compte = compte;
    }

    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant) {
        this.montant = montant;
    }

    public int getEtat() {
        return etat;
    }

    public void setEtat(int etat) {
        this.etat = etat;
    }
     public double getMontantPerteGain() {
        return montantPerteGain;
    }

    public void setMontantPerteGain(double montantPerteGain) {
        this.montantPerteGain = montantPerteGain;
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }
    @Override
    public void setLiaisonMere(String liaisonMere) {
        super.setLiaisonMere("idFactureDeclaration");
    }

    @Override
    public void controlerUpdate(Connection c) throws Exception {
        super.setNomClasseMere("faturefournisseur.FactureDeclaration");
        super.controlerUpdate(c);
    }
    public double calculerTva(){
        double montantTva = (this.getPu() * this.getQte() * this.getTva()) / 100;
        this.setMontantTva(montantTva);
        return montantTva;
    }
    
    public double calculerHT(){
        double montantHT = this.getPu() * this.getQte();
        this.setMontantHT(montantHT);
        return montantHT;
    }
    
    public double calculerTTC(){
        double montantTTC = this.getMontantHT() + this.getMontantTva();
        this.setMontantTTC(montantTTC);
        return montantTTC;
    }
    public void modifPuIngredients(String user,Connection c) throws Exception {
        Ingredients i=this.getIngedients(null,c);
        i.setMode("modif");
        i.setPu(this.getPu());
        i.updateToTableWithHisto(user);
    }

    public double getPrixTTCRemise() throws Exception {
        double prixUnitaireApresRemise = getPu() - (getPu() * getRemises() / 100.0);
        return prixUnitaireApresRemise * getQte() * (1 + getTva() / 100.0);
    }

    public Prevision genererPrevision() throws Exception
    {
        Prevision prevision = new Prevision();
        prevision.setDebit(this.getPrixTTCRemise());
        prevision.setIdFacture(this.getId());
        prevision.setIdDevise("AR");
        prevision.setIdCaisse(ConstanteStation.idCaisse);
        prevision.setDesignation("Pr&eacute;vision rattach&eacute;e au FF N : " + this.getId());

        return prevision;
    }

    public void modifPuIngredientsNew(String u, Connection c) throws Exception {
        Ingredients ing = this.getIngedients("AS_INGREDIENTS", c);
        boolean isChangePu=false;
        if (ing.getTypeStock()!=null) {
            double newPu = ((ing.getPu() * ing.getReste()) + (this.getPu() * this.getQte())) / (ing.getReste() + this.getQte());
            ing.setPu(newPu);
            isChangePu=true;
        }
        if(ing.getTypeStock()==null)
        {
            ing.setPu(this.getPu());
            isChangePu=true;
        }
        if(isChangePu==true){
            ing.updateToTableWithHisto(u,c);
        }
    }

    public Ingredients getIngedients(String nT, Connection c) throws Exception {
        boolean estOuvert=false;
        try
        {
            if(c==null)
            {
                c=new UtilDB().GetConn();
                estOuvert=true;
            }
            Ingredients retour=(Ingredients) new Ingredients().getById(this.getIdProduit(),nT,c);
            return retour;
        }
        catch(Exception e)
        {
            throw e;
        }
        finally {
            if(estOuvert==true&&c!=null)c.close();
        }
    }

    public FactureDeclarationDetails[] getByIdsRelever(String[] ids, Connection c) throws Exception {
        boolean canClose=false;
        try {
            if(c==null) {
                c=new UtilDB().GetConn();
                canClose=true;
            }
            ReleverDetailCpl releverDetail = new ReleverDetailCpl();
            releverDetail.setNomTable("ReleverDetailNR");
            String awhereIdRelever = " and id in (" + Utilitaire.tabToString(ids, "'", ",") + ")";
            ReleverDetailCpl[] releverDetailCpls=(ReleverDetailCpl[]) CGenUtil.rechercher(releverDetail,null,null,c,awhereIdRelever);

            FactureDeclarationDetails[] details=new FactureDeclarationDetails[releverDetailCpls.length];
            for (int i=0;i<releverDetailCpls.length;i++) {
                details[i] = new FactureDeclarationDetails();
                details[i].setDesignation(releverDetailCpls[i].getDesignation());
                details[i].setIdDevise("AR");
                details[i].setTauxDeChange(1);
                details[i].setPu(releverDetailCpls[i].getDebit()>0?releverDetailCpls[i].getDebit():releverDetailCpls[i].getCredit());
                details[i].setTaux(1);
            }
            return details;
        } finally {
            if(canClose) c.close();
        }
    }

    @Override
    public void controler(Connection c) throws Exception{
        FactureDeclaration mere =(FactureDeclaration)new FactureDeclaration().getById(this.getIdFactureFournisseur(),"FACTUREDECLARATION",c);
        this.setMois(Utilitaire.getMois(mere.getDaty()));
        this.setAnnee(Utilitaire.getAnnee(mere.getDaty()));
        As_BonDeLivraison_Fille fille =(As_BonDeLivraison_Fille)new As_BonDeLivraison_Fille().getById(this.getIdbcDetail(),"AS_BONDELIVRAISON_FILLE",c);
        if(fille!=null && mere.getIdBc()!=null && !mere.getIdBc().startsWith("DMDA")){
            if(fille.getQuantite()!=this.getQte()){
                throw new Exception("La quantit\u00E9 saisie est diff\u00E9rente de celle indiqu\u00E9e sur le bon de livraison.");
            }
        }
        super.controler(c);
    }
    public Prevision findPrevision(Connection c){
        try {
            Prevision prevision = new Prevision();
            if (getIdPrevision() != null && !getIdPrevision().isEmpty()) {
                prevision = (Prevision) prevision.getById(getIdPrevision(), prevision.getNomTable() ,c);
                return prevision;
            }
            String comptePrefix = this.getCompte().substring(0, 3);
            Prevision[] previsions = (Prevision[]) CGenUtil.rechercher(prevision, null, null, c, " AND COMPTE LIKE '" +comptePrefix+"%' AND IDFACTURE IS NULL");
            if (previsions.length == 0) {
                return null;
            }
            return previsions[0];
        } catch (Exception ex) {
            Logger.getLogger(VenteDetails.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }
    /*
    public Prevision genererPrevisionPrevu(String u, Connection c) throws Exception {
        Prevision prev = findPrevision(c);
        if (prev == null) {
            throw  new Exception("Aucune prévision trouvée rattachée au produit " + this.getDesignation());
        }
        return prev.scinderPrevu(this.getId(), getPrixTTCRemise(), u, c);
    }
     */
}
