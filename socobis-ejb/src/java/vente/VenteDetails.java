/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package vente;

import annexe.Produit;
import avoir.AvoirFCFille;
import bean.*;
import caisse.MvtCaisse;
import client.Client;
import encaissement.EncaissementDetails;
import java.sql.Connection;
import java.sql.Date;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;

import equivalenceproduit.EquivalenceProduit;
import faturefournisseur.FactureFournisseurDetails;
import prevision.Prevision;
import produits.IngredientVente;
import produits.Ingredients;
import produits.Recette;
import produits.TarifIngredients;
import rapprochement.ReleverDetailCpl;
import remise.RemiseFille;
import stock.EtatStock;
import stock.MvtStockFille;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;
import utils.ConstanteSavonnerie;
import utils.ConstanteStation;

import java.util.Arrays;
import java.util.stream.Collectors;
import java.util.Map;
import java.util.Collection;

/**
 *
 * @author Angela
 */
public class VenteDetails extends ClassFille {

    private String id;
    private String idVente;
    private String idProduit;
    private String idOrigine, compte, libelle;
    private String idDevise;
    @LibelleAffichage("Quantit&eacute;")
    private double qte;
    private double pu;
    protected double remise;
    protected double tva;
    protected double puAchat;
    protected double puVente;
    protected double montant;
    protected int etat;
    private double montantTTC, montantTva, montantHT,montantRemise;
    private double montantTTCAr, montantTvaAr, montantHTAr;
    private double tauxDeChange;
    private String designation;
    double puRevient;
    String idbcfille;
    String unite;
    private double poids, ristourne;
    private String idPrevision;
    protected double remiseMontant = 0.0;
    String photo;
    String reference;
    String catClient;
    String idRemise;
    Ingredients ingFille;

    public Ingredients getIngFille() {
        return ingFille;
    }

    public void setIngFille(Ingredients ingFille) {
        this.ingFille = ingFille;
    }

    public String getIdRemise() {
        return idRemise;
    }

    public void setIdRemise(String idRemise) {
        this.idRemise = idRemise;
    }

    public String getCatClient() {
        return catClient;
    }

    public void setCatClient(String catClient) {
        this.catClient = catClient;
    }

    public double getRemiseMontant() {
        return remiseMontant;
    }

    public void setRemiseMontant(double remiseMontant) {
        this.remiseMontant = remiseMontant;
    }

    public String getPhoto() {
        return photo;
    }

    public void setPhoto(String photo) {
        this.photo = photo;
    }

    public String getReference() {
        return reference;
    }

    public void setReference(String reference) {
        this.reference = reference;
    }

    public String getIdPrevision() {
        return idPrevision;
    }

    public void setIdPrevision(String idPrevision) {
        this.idPrevision = idPrevision;
    }

    public double getPoids() {
        return poids;
    }

    public void setPoids(double poids) {
        this.poids = poids;
    }

    public String getUnite() {
        return unite;
    }

    public void setUnite(String unite) {
        this.unite = unite;
    }

    public String getIdbcfille() {
        return idbcfille;
    }

    public void setIdbcfille(String idbcfille) {
        this.idbcfille = idbcfille;
    }

    public double getMontantRevient() {
        return montantRevient;
    }

    public void setMontantRevient(double montantRevient) {
        this.montantRevient = montantRevient;
    }
    public double getMargeBrute()
    {
        if(margeBrute>0) return margeBrute;
        return getMontant()-getMontantRevient();
    }
    public double getMargeBruteCalc()
    {
        return getMontant()-getMontantRevient();
    }
    public void setMargeBrute(double margeBrute) {
        this.margeBrute = margeBrute;
    }
    protected double margeBrute;

    double montantRevient;

    public double getPuRevient() {
        return puRevient;
    }

    public void setPuRevient(double puRevient) {
        this.puRevient = puRevient;
    }

    public double getMontantRemise() {
        return montantRemise;
    }

    public void setMontantRemise(double montantRemise) {
        this.montantRemise = montantRemise;
    }

    public double getMontantTTCAr() {
        return montantTTCAr;
    }

    public void setMontantTTCAr(double montantTTCAr) {
        this.montantTTCAr = montantTTCAr;
    }

    public double getMontantTvaAr() {
        return montantTvaAr;
    }

    public void setMontantTvaAr(double montantTvaAr) {
        this.montantTvaAr = montantTvaAr;
    }

    public double getMontantHTAr() {
        return montantHTAr;
    }

    public void setMontantHTAr(double montantHTAr) {
        this.montantHTAr = montantHTAr;
    }

    public double getRistourne() {
        return ristourne;
    }

    public void setRistourne(double ristourne) throws Exception {
        if (this.getMode().equals("modif") && (ristourne > 100 || ristourne < 0)) {
            throw new Exception("Ristourne invalide : elle doit \\u00EAtre comprise entre 0 et 100");
        }
        this.ristourne = ristourne;
    }

    public String getDesignation() {
        return designation;
    }

    public void setDesignation(String designation) {
        this.designation = designation;
    }

    public String getIdDevise() {
        return idDevise;
    }

    public void setIdDevise(String idDevise) {
        if(this.getMode().equals("modif")){
            if(idDevise == null || idDevise.isEmpty()){
                this.setIdDevise("AR");
                return;
            }
        }
        this.idDevise = idDevise;
    }

    public double getTauxDeChange() {
        return tauxDeChange;
    }

    public void setTauxDeChange(double tauxDeChange) throws Exception{
        if(this.getMode().equals("modif")){
            if(tauxDeChange<=0){
                tauxDeChange=1;
            }
        }
        this.tauxDeChange = tauxDeChange;
    }
            
    @Override
    public boolean isSynchro(){
        return true;
    }
    
    public double getRemise() {
        return remise;
    }

    public void setRemise(double remise)throws Exception {
        if(this.getMode().compareToIgnoreCase("modif")==0)
        {
            if(remise>100||remise<0) throw new Exception("Remise invalide");
        }
        this.remise = remise;
    }

    public double getTva() {
        return tva;
    }

    public void setTva(double tva) throws Exception {
        if (this.getMode().equals("modif") && (tva > 100 || tva < 0)) {
            throw new Exception("TVA invalide : elle doit \\u00EAtre comprise entre 0 et 100");
        }
        this.tva = tva;
    }

    public double getPuAchat() {
        return puAchat;
    }

    public void setPuAchat(double puAchat) {
        this.puAchat = puAchat;
    }

    public double getPuVente() {
        return puVente;
    }

    public void setPuVente(double puVente) {
        this.puVente = puVente;
    }

    public VenteDetails(String nomtable){
        super.setNomTable(nomtable);
    }

    public VenteDetails() {
        super.setNomTable("Vente_Details");
        try {
            this.setNomClasseMere("vente.Vente");
            this.setLiaisonMere("idVente");
        } catch (Exception ex) {
            Logger.getLogger(VenteDetails.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdVente() {
        return idVente;
    }

    public void setIdVente(String idVente) {
        this.idVente = idVente;
    }

    public String getIdProduit() {
        return idProduit;
    }

    public void setIdProduit(String idProduit) throws Exception {
        if (this.getMode().equals("modif")) {
            if (idProduit == null || idProduit.trim().isEmpty()) {
                throw new Exception("Produit obligatoire");
            }
        }
        this.idProduit = idProduit;
    }

    public String getIdOrigine() {
        return idOrigine;
    }

    public void setIdOrigine(String idOrigine) {
        this.idOrigine = idOrigine;
    }

    public String getCompte() {
        return compte;
    }

    public void setCompte(String compte) throws Exception{
        if(this.getMode().equals("modif") && compte.isEmpty()){
            throw new Exception("Compte obligatoire pour les details");
        }
        this.compte = compte;
    }

    public String getLibelle() {
        return libelle;
    }

    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }

    public double getQte() {
        return qte;
    }

    public void setQte(double qte) throws Exception{
        if(this.getMode().equals("modif")){
            if(qte <= 0){
                throw new Exception("Qte insuffisant pour une ligne");
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

    public double getMontantTTCLocal(){
        calculerTTC();
        return montantTTC;
    }
    public double getMontantTTC() {
        return montantTTC;
    }

    public void setMontantTTC(double montantTTC) {
        this.montantTTC = montantTTC;
    }

    public double getMontantTvaLocal(){
        calculerTva();
        return montantTva;
    }

    public double getMontantTva() {
        return montantTva;
    }

    public void setMontantTva(double montantTva) {
        this.montantTva = montantTva;
    }
    
    public double getMontantHTLocal(){
        calculerHT();
        return montantHT;
    }
    public double getMontantHT() {
        return montantHT;
    }

    public void setMontantHT(double montantHT) {
        this.montantHT = montantHT;
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

    @Override
    public String getTuppleID() {
        return this.getId();
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("VTD", "getSeqVenteDetails");
        this.setId(makePK(c));
    }

    @Override
    public void setLiaisonMere(String liaisonMere) {
        super.setLiaisonMere("idVente");
    }
    @Override
    public String getNomClasseMere() {
        return "vente.Vente";
    }
    @Override
    public String getLiaisonMere() {
        return "idVente";
    }

    public double getMontantRemiseCalc(){
//             return this.getPu()* this.getQte() * (1 - this.getRemise() / 100) - this.getRemiseMontant();
        return this.getPu()* this.getQte() * (1 - this.getRemise() / 100);
    }

    public double getMontantTTCCalc() {
        return this.getMontantRemiseCalc() * (1 + (this.getTva()/100.00));
    }

    public Produit getProduit(Connection c) throws Exception {


        Produit produit = new Produit();
        produit.setId(this.getIdProduit());

        Produit[] produits = (Produit[]) CGenUtil.rechercher(produit, null, null, c, " ");
        if (produits.length > 0) {
            return produits[0];
        }
        return null;
    }

    public Produit getProduitAs(Connection c) throws Exception {
        return (Produit) new Produit().getById(getIdProduit(), "AS_INGREDIENTS", c);
    }

    public double getMontantTVACalc() {
        return this.getMontantRemiseCalc()*this.getTva()/100;
    }

    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {
        //Produit produit = getProduit(c);
       // this.setPu(produit.getPuVente());
        return super.createObject(u, c);
    }

    public MvtStockFille createMvtStockFille() throws Exception {
        MvtStockFille msf = new MvtStockFille();
        msf.setIdProduit(this.getIdProduit());
        msf.setSortie(this.getQte());
        return msf;
    }

    public RemiseFille estDansRemise(RemiseFille[] listeRemise, Ingredients[] listeIng)throws Exception{
        if(listeRemise==null)return null;
        for(int i=0;i<listeRemise.length;i++){
            String[]col={"id"};
            String[] val={this.getIdProduit()};
            Ingredients[] ing=(Ingredients[]) AdminGen.find(listeIng,col,val);

            if(listeRemise[i].getIdcategorieclient()!=null&&listeRemise[i].getIdcategorieclient().equals(this.getCatClient())==false)
            {
                continue;
            }
             /*if(listeRemise[i].getIdpoint()!=null&&listeRemise[i].getIdpoint().equals(this.getIdPoint())==false)
             {
                 continue;
             }*/

            if(ing!=null&&listeRemise[i].getCategorieproduit()!=null&&listeRemise[i].getCategorieproduit().equals(ing[0].getCategorieIngredient())==false)
            {
                continue;
            }
            if(listeRemise[i].getIdproduit()!=null&&listeRemise[i].getIdproduit().equals(this.getIdProduit())==false)
            {
                continue;
            }
            return listeRemise[i];
        }
        return null;
    }

    @Override
    public void controler(Connection c) throws Exception {
       super.controler(c);
       //CheckEtatStock( c);
    }

    public MvtStockFille genererMvtStockFille(Connection c) throws Exception {
        if(this.getIdProduit()!=null) {
            MvtStockFille mf = new MvtStockFille();
            mf.setIdProduit(this.getIdProduit());
            mf.setSortie(this.getQte());
            mf.setIdVenteDetail(this.getId());
            mf.setDesignation(this.getDesignation());
            return mf;
        }
        return null;
    }

    public TarifIngredients genererTarifIngredients(Connection c) throws Exception {
        TarifIngredients tarifIngredients = new TarifIngredients();
        tarifIngredients.setIdIngredient(this.getIdProduit());
        tarifIngredients.setUnite(this.getUnite());
        tarifIngredients.setPrixUnitaire(this.getPu());
        tarifIngredients.setDaty(Utilitaire.dateDuJourSql());
        Vente v=(Vente)this.getMere();
        Client cl=v.getClient(c);
        if(v.getClient(c).getIdTypeClient()==null)return null;
        tarifIngredients.setIdTypeClient(v.getClient(c).getIdTypeClient());
        return tarifIngredients;
    }

    public void CheckEtatStock(Connection c) throws Exception {
        Ingredients ing = getIngredientById();
        if (ing.getCategorieIngredient().equalsIgnoreCase(ConstanteSavonnerie.CATEGORIE_SERVICES)){
            return;
        }
        Vente[] ventes = (Vente[]) CGenUtil.rechercher(new Vente(), null, null, c, " and id='" + this.getIdVente() + "' ");
        if (ventes.length != 1 || ventes==null) {
            throw new Exception("Vente introuvable");
        }
        EtatStock etat = new EtatStock();
        etat.setNomTable("V_ETATSTOCK_ING_eng");
        EtatStock[] et = (EtatStock[]) CGenUtil.rechercher(etat, null, null, c, " and idProduit ='" + this.getIdProduit() + "' and idmagasin='" + ventes[0].getIdMagasin() + "' ");
        if (et.length != 1) {
            throw new Exception("produit introuvable dans stock "+this.getIdProduit());
        }
        if (et[0].getReste()< this.getQte()) {
            throw new Exception("produit insuffisant car  Stock  :"+et[0].getReste()+"< Demande: "+this.getQte());
        }

    }

    public void CheckEtatStockALaCreation(Connection c, String idmagasin) throws Exception {
        if(this.getIdProduit()==null||this.idProduit.compareToIgnoreCase("")==0)return;
        Ingredients ing = getIngredientById();
        if (ing.getCategorieIngredient().equalsIgnoreCase(ConstanteSavonnerie.CATEGORIE_SERVICES)){
            return;
        }
        EtatStock etat = new EtatStock();
        etat.setNomTable("V_ETATSTOCK_ING_eng");
        String awhere = " and idProduit ='" + this.getIdProduit() + "' and idmagasin='" + idmagasin + "' ";
        EtatStock[] et = (EtatStock[]) CGenUtil.rechercher(etat, null, null, c, awhere);
        System.err.println(etat.getNomTable()+"===================="+awhere);
        if (et.length != 1) {
            throw new Exception("produit introuvable dans stock "+this.getIdProduit());
        }
        if (et[0].getReste()< this.getQte()) {
            throw new Exception("produit insuffisant car  Stock  :"+et[0].getReste()+"< Demande: "+this.getQte());
        }

    }

    public void calculerRevient(Connection c) throws Exception {
        Ingredients ing = new Ingredients();
        ing.setId(this.getIdProduit());
        Recette[] rct = ing.decomposerBase(c);
        double montantTotal = AdminGen.calculSommeDouble(rct, "qtetotal");
        this.setPuRevient(montantTotal);
    }
    
    public double calculerTva(){
        double montantTvaC = (this.getMontant() * this.getTva()) / 100;
        this.setMontantTva(montantTvaC);
        return montantTvaC;
    }
    
    public double calculerHT(){
        double montantHTC = this.getMontant();
        this.setMontantHT(montantHTC);
        return montantHTC;
    }
    
    public double calculerTTC(){
        double montantTTCC = this.getMontantHT() + this.getMontantTva();
        this.setMontantTTC(montantTTCC);
        return montantTTCC;
    }
    
    public int lierBonDeLivraisonDetails(String[] idMere, Connection c)throws Exception{
        Statement cmd = null;
        As_BondeLivraisonClientFille bl = new As_BondeLivraisonClientFille();
        try {
            String req = "update " + bl.getNomTable() + " set idventedetails='" + this.getId() + "' where numbl in "+Utilitaire.tabToString(idMere, "'", ",")+" and idproduit='"+this.getIdProduit()+"'";
            cmd = c.createStatement();
            return cmd.executeUpdate(req);
        } catch (Exception ex) {
            if( c != null ){c.rollback();}
            throw ex;
        } finally {
            cmd.close();
        }
    }
    public VenteDetailsLib[] getDistinctProduit(String[] ids)throws Exception{
        VenteDetailsLib[] venteDetails = null;
        String aWhere=Utilitaire.getAWhereIn(ids,"idvente");
        venteDetails = (VenteDetailsLib[]) CGenUtil.rechercher(new VenteDetailsLib(), null, null, null, aWhere+" ");
        VenteDetailsLib[] distinct = Arrays.stream(venteDetails)
        .collect(Collectors.toMap(
                VenteDetails::getIdProduit,
                vd -> vd,
                (vd1, vd2) -> vd1
        ))
        .values()
        .toArray(new VenteDetailsLib[0]);

        return distinct;
    }

    public VenteDetailsLib[] getByIdsRelever(String[] ids, Connection c) throws Exception {
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

            VenteDetailsLib[] details=new VenteDetailsLib[releverDetailCpls.length];
            for (int i=0;i<releverDetailCpls.length;i++) {
                details[i] = new VenteDetailsLib();
                details[i].setDesignation(releverDetailCpls[i].getDesignation());
                details[i].setIdDevise("AR");
                details[i].setTauxDeChange(1);
                details[i].setPu(releverDetailCpls[i].getDebit()>0?releverDetailCpls[i].getDebit():releverDetailCpls[i].getCredit());
            }
            return details;
        } finally {
            if(canClose) c.close();
        }
    }

    public Ingredients getIngredientById() throws Exception {
        Ingredients ing = new Ingredients();
        ing.setId(this.getIdProduit());

        Ingredients[] res = (Ingredients[]) CGenUtil.rechercher(ing, null, null, "");
        if (res != null && res.length > 0) return res[0];
        else return null;
    }

    public IngredientVente getIngredientPrixGMS() throws Exception {
        IngredientVente ing = new IngredientVente();
        ing.setNomTable("AS_INGREDIENT_VENTE_LIB_PRX");
        ing.setId(this.getIdProduit());

        IngredientVente[] res = (IngredientVente[]) CGenUtil.rechercher(ing, null, null, " AND ID='"+this.getIdProduit()+"' AND IDTYPECLIENT='TYPE001' and (daty+0) <= SYSDATE and rownum = 1 ORDER BY daty desc");
        if (res != null && res.length > 0) return res[0];
        else return null;
    }

    public Prevision genererPrevisionPrevuBatch(String u, Statement st) throws Exception {
        Prevision prev = findPrevision(st.getConnection());
        if (prev == null) {
            throw  new Exception("Aucune prévision trouvée rattachée au produit " + this.getDesignation());
        }
        return prev.scinderPrevuBatch(this.getId(), getMontantTTCCalc(), u, st);
    }

    public double getMontantHTCalcule() {
        return this.getPu()*this.getQte()*(1-(this.getRemise()/100));
    }

    public double getQteCarton(Connection c) throws Exception{
        Ingredients ing = getIngredientById();
        return EquivalenceProduit.getQteCarton(ing, this.getQte(), c);
    }

    public double getQtePieceRestant(Connection c) throws Exception{
        Ingredients ing = getIngredientById();
        return EquivalenceProduit.getQtePieceRestant(ing, this.getQte(), c);
    }

//    public double getPrixTTCRemise() throws Exception {
//        double prixUnitaireApresRemise = getPu() - (getPu() * getRemise() / 100.0);
//        return prixUnitaireApresRemise * getQte() * (1 + getTva() / 100.0);
//    }

//    public Prevision genererPrevision() throws Exception
//    {
//        Prevision prevision = new Prevision();
//        prevision.setCredit(this.getPrixTTCRemise());
//        prevision.setIdFacture(this.getId());
//        prevision.setIdDevise(this.getIdDevise());
//        prevision.setCompte(getCompte().substring(0, 3));
//        prevision.setIdCaisse(ConstanteSavonnerie.idCaisse);
//        prevision.setDesignation(" Prevision rattachée au vente N : " + this.getId());
//
//        return prevision;
//    }

//    public double getPrixTTCRemise(Connection c) throws Exception {
//        boolean estOuvert = false;
//        try {
//            if (c == null) {
//                c = new UtilDB().GetConn();
//                estOuvert = true;
//            }
//
//            double prixUnitaireApresRemise = getPu() * (1 - (getRemise() / 100.0));
//
//            String critere = " AND id = '" + this.getIdVente() + "'";
//            Vente[] v = (Vente[]) CGenUtil.rechercher(new Vente(), null, null, c, critere);
//
//            if (v == null || v.length == 0) {
//                throw new Exception("Vente introuvable pour l'ID : " + this.getIdVente());
//            }
//
//            double totalHT = prixUnitaireApresRemise * getQte();
//            double totalTTC = totalHT * (1 + (getTva() / 100.0));
//            double frais = v[0].getFraislivraison() * (this.getPoids()*this.getQte());
//            System.out.println("montant TTC tokony alohany " + frais);
//
//            return totalTTC - frais;
//        } catch (Exception e) {
//            throw e;
//        } finally {
//            if (estOuvert && c != null) {
//                c.close();
//            }
//        }
//    }

    public double getPrixTTCRemise(Connection c) throws Exception {
        boolean estOuvert = false;
        try {

            double prixUnitaireApresRemise = getPu() * (1 - (getRemise() / 100.0));

            String critere = " AND id = '" + this.getIdVente() + "'";
            //Vente[] v = (Vente[]) CGenUtil.rechercher(new Vente(), null, null, c, critere);
            Vente[] v={(Vente)this.getMere()};
            if (v == null || v.length == 0) {
                throw new Exception("Vente introuvable pour l'ID : " + this.getIdVente());
            }

            double totalHT = prixUnitaireApresRemise * getQte();
            double totalTTC = totalHT * (1 + (getTva() / 100.0));
            double frais = v[0].getFraislivraison() * (this.getPoids()*this.getQte());

            return totalTTC - frais;
        }
        catch (Exception e) {
            throw e;
        }
    }

    public Prevision genererPrevision() throws Exception
    {
        Prevision prevision = new Prevision();
        prevision.setCredit(this.getPrixTTCRemise(null));
        prevision.setIdFacture(this.getId());
        prevision.setCompte(getCompte().substring(0,3));
        prevision.setIdDevise("AR");
        prevision.setDesignation("Prevision rattach&eacute;e au vente N : " + this.getId());

        return prevision;
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

//    public Prevision genererPrevisionPrevu(String u, Connection c) throws Exception {
//        Prevision prev = findPrevision(c);
//        if (prev == null) {
//            throw  new Exception("Aucune prévision trouvée rattachée au produit " + this.getDesignation());
//        }
//        return prev.scinderPrevu(this.getId(), getPrixTTCRemise(), u, c);
//    }

    public Prevision genererPrevisionPrevu(String u, Connection c) throws Exception {
        Prevision prev = findPrevision(c);
        if (prev == null) {
            throw  new Exception("Aucune prévision trouvée rattachée au produit " + this.getDesignation());
        }
        return prev.scinderPrevu(this.getId(), getPrixTTCRemise(null), u, c);
    }

    public AvoirFCFille genereAvoirReste() throws Exception {
        AvoirFCFille avoir = new AvoirFCFille();
        avoir.setIdProduit(this.getIdProduit());
        avoir.setQte(this.getQte());
        avoir.setPu(this.getPu());
        avoir.setRemise(this.getRemise());
        avoir.setTva(this.getTva());
        avoir.setTauxDeChange(this.getTauxDeChange());
        avoir.setDesignation(this.getDesignation());
        avoir.setIdDevise(this.getIdDevise());

        return avoir;
    }

}
