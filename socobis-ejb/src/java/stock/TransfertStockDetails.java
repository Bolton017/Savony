/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package stock;

import bean.AdminGen;
import bean.CGenUtil;
import bean.ClassFille;
import faturefournisseur.Fournisseur;
import produits.Ingredients;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;

import java.sql.Connection;
import java.sql.Date;

/**
 *
 * @author 26134
 */
public class TransfertStockDetails extends ClassFille{
    String id,idTransfertStock,idProduit,remarque, idSource,compteLocalisationDepart,compteLocalisationArrivee;;
    double quantite, pu;
    private String idFournisseur;
    private EtatStockParEntree etatStock;
    private Date daty;

    public TransfertStockDetails(){
        try {
            this.setLiaisonMere("idTransfertStock");
            this.setNomTable("TRANSFERTSTOCKDETAILS");
            this.setNomClasseMere("stock.TransfertStock");
        } catch (Exception e) {
            System.out.println("error stock.TransfertStockDetails.<init>()");
        }
    }

    public String getCompteLocalisationDepart(){
        return compteLocalisationDepart;
    }

    public void setCompteLocalisationDepart(String compteLocalisationDepart)  throws Exception{
        this.compteLocalisationDepart = compteLocalisationDepart;
    }

    public String getCompteLocalisationArrivee() {
        return compteLocalisationArrivee;
    }

    public void setCompteLocalisationArrivee(String compteLocalisationArrivee) throws Exception{
        if (this.getMode().equals("modif") && Utilitaire.champNull(compteLocalisationArrivee).compareTo("") == 0 ) {
            throw new Exception("champ localisation d' arriv\u00E9 obligatoire");
        }
        this.compteLocalisationArrivee = compteLocalisationArrivee;
    }


    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public String getIdFournisseur() {
        return idFournisseur;
    }

    public void setIdFournisseur(String idFournisseur) {
        this.idFournisseur = idFournisseur;
    }

    public EtatStockParEntree getEtatStock() {
        return etatStock;
    }

    public void setEtatStock(EtatStockParEntree etatStock) {
        this.etatStock = etatStock;
    }

    public double getPu() {
        return pu;
    }

    public void setPu(double pu) throws Exception{
        if (this.getMode().equals("modif") && pu < 0) {
            throw new Exception("Pu ne peut pas &ecirc;tre inf\u00E9rieur &agrave; 0");
        }
        this.pu = pu;
    }

    public String getIdTransfertStock() {
        return idTransfertStock;
    }

    public void setIdTransfertStock(String idTransfertStock) {
        this.idTransfertStock = idTransfertStock;
    }

    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
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

    public void setIdProduit(String idProduit)  throws Exception{
        if(getMode().compareTo("modif")==0 && (idProduit==null || idProduit.isEmpty()))throw new Exception("Veuillez entrer un produit");
        this.idProduit = idProduit;
    }

    public double getQuantite() {
        return quantite;
    }

    public void setQuantite(double quantite) throws Exception{
        if (this.getMode().equals("modif") && quantite < 0) {
            throw new Exception("Quantit\u00E9 invalide");
        }
        this.quantite = quantite;
    }

    public String getIdSource() {
        return idSource;
    }

    public void setIdSource(String idSource) {
        this.idSource = idSource;
    }

    public MvtStockFille createMvtStockFille(boolean isEntree) throws Exception {
        MvtStockFille msf=new MvtStockFille();
        msf.setIdProduit(this.getIdProduit());
        msf.setIdTransfertDetail(this.getId());
        if (isEntree) {
            msf.setEntree(quantite);
            msf.setCompteLocalisation(this.getCompteLocalisationArrivee());
        }else{
            msf.setMode("modif");
            msf.setSortie(quantite);
            msf.setMvtSrc(this.idSource);
        }
        msf.setPu(this.getPu());
        return msf;
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("TSD", "GETSEQTRANSFERTSTOCKDETAILS");
        this.setId(makePK(c));
    }
    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getLiaisonMere() {
        return "idTransfertStock";
    }
    @Override
    public String getAttributIDName() {
        return "id";
    }
    @Override
    public String getNomClasseMere() {
        return "stock.TransfertStock";
    }

    protected void checkQuantiteProduit(Connection c) throws Exception{
        TransfertStock[] tsd=(TransfertStock[]) CGenUtil.rechercher(new TransfertStock(), null, null, c, " and id='"+this.getIdTransfertStock()+"' ");
        if (tsd.length!=1) {
            throw new Exception("transfertStock introuvable");
        }
        EtatStock es = new EtatStock();
        es.setNomTable("V_ETATSTOCK_ING");
        EtatStock[] et=(EtatStock[]) CGenUtil.rechercher(es, null, null, c, " and id='"+this.getIdProduit()+"' and idmagasin='"+tsd[0].getIdMagasinDepart()+"' ");
        if (et.length==0) {
            throw new Exception(String.format("ingredient %s introuvable dans stock", this.getIdProduit()));
        }
        if ( et[0].getReste()< this.getQuantite()) {
            throw new Exception(String.format("ingredient %s insuffisant", this.getIdProduit()));
        }
    }

    protected void checkMVTSource() throws Exception{
        if(this.getIdSource() == null || this.getIdSource().isEmpty()){
            throw new Exception("Vous devez choisir une source!");
        }
    }

    protected void controllerMvtSrc(Connection c) throws Exception{
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
            }
            if(this.getIdSource() != null && !this.getIdSource().isEmpty()){
                MvtStockEntreeAvecReste map = new MvtStockEntreeAvecReste();
                MvtStockEntreeAvecReste rep = (MvtStockEntreeAvecReste) map.getById(this.getIdSource(), "V_ETATSTOCK_ENTREE", c);
                if(rep != null) {
                    if(this.getIdProduit().compareToIgnoreCase(rep.getIdProduit()) != 0){
                        throw new Exception("Le produit dans le mouvement source "+ rep.getId()+" ne correspondant pas au produit dans " + this.getIdSource());
                    }
                }
            }
        } catch (Exception e) {
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }

    public void findEtatStockEntree(EtatStockParEntree[] etatStocks) throws Exception {
        String[] col = new String[]{"id"};
        String[] val = new String[]{this.getIdSource()};
        String exception ="Le produit "+this.getIdProduit()+" avec le mouvement source "+this.getIdSource()+" n'a pas d'entr\u00E9e en stock. Veuillez v\u00E9rifier.";

        if (getIdSource()==null || getIdSource().isEmpty()){

            col  = new String[]{"idProduit","idFournisseur","daty"};
            val = new String[]{this.getIdProduit(),this.getIdFournisseur(), String.valueOf(this.getDaty())};
            exception="Le produit "+this.getIdProduit()+" avec la date d'entr\u00E9e en stock du "+this.getDaty()+" avec le fournisseur "+this.getIdFournisseur()+" n'a pas d'entr\u00E9e en stock. Veuillez v\u00E9rifier.";
        }
        EtatStockParEntree[] result = (EtatStockParEntree[]) AdminGen.find(etatStocks,col,val);
        if (result.length==0) {
            throw new Exception(exception);
        }
        setEtatStock(result[0]);

    }

    public void findFournisseur(Connection c) throws Exception {
        String awhere= " and id ='"+getIdFournisseur()+"' or upper(nom) like upper('%"+getIdFournisseur()+"%')";
        Fournisseur[] fournisseurs = (Fournisseur[]) CGenUtil.rechercher(new Fournisseur(),null,null,c,awhere);
        if (fournisseurs.length>0) {
            setIdFournisseur(fournisseurs[0].getId());
        }
        else  {
            throw new Exception("Le fournisseur "+getIdFournisseur()+" n'existe pas");
        }
    }

    @Override
    public void controler(Connection c) throws Exception {
        //this.checkQuantiteProduit(c);
        //this.checkMVTSource();
        if (this.getCompteLocalisationArrivee().equals(this.getCompteLocalisationDepart())) {
            throw new Exception("Le localisation de départ doit être différent du localisation d’arrivée.");
        }
        this.controllerMvtSrc(c);
    }

    public Ingredients getIngredient(Ingredients[] ingredients) throws Exception {
        Ingredients ing = (Ingredients) AdminGen.findUnique(ingredients,new String[]{"id"},new String[]{this.getIdProduit()});
        if (ing == null) {
            throw new Exception("Ingredients avec id : " + this.getIdProduit() + " introuvable");
        }
        return ing;
    }

}
