/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package stock;

import bean.ClassFille;
import bean.CGenUtil;
import bean.ClassMAPTable;
import java.sql.Connection;
import java.sql.Date;
import java.util.*;
import bean.*;
import fabrication.Fabrication;
import lot.Lot;
import produits.Ingredients;
import java.sql.Statement;

import utilitaire.UtilDB;
import utilitaire.Utilitaire;
import utils.ConstanteSocobis;
import utils.ConstanteStation;
import vente.As_BondeLivraisonClientFille_Cpl;
import chatbot.AiColDesc;


public class MvtStockFille extends ClassFille{
    @AiColDesc("id du ordre de fabrication fille, commence par OFF")
    private String id;
    private String idMvtStock, idProduit, idVenteDetail, idTransfertDetail,designation,idFab,idOf,categorieIngredient,idOff,autocompl,idunite, idUniteLib;
    private double entree, sortie,pu,montant;
    private String mvtSrc;
    private double reste;
    private String idinventairefille;
//    public String idLot;
    private String compteLocalisation;
    java.sql.Date dateInventaire;
    double qteInventaire;
    String compte_stock;
    String compte_sortie_stock;
    Ingredients ingredients;

    public Ingredients getIngredients() {
        return ingredients;
    }

    public void setIngredients(Ingredients ingredients) {
        this.ingredients = ingredients;
    }

    public String getCompte_stock() {
        return compte_stock;
    }

    public void setCompte_stock(String compte_stock) {
        this.compte_stock = compte_stock;
    }

    public String getCompte_sortie_stock() {
        return compte_sortie_stock;
    }

    public void setCompte_sortie_stock(String compte_sortie_stock) {
        this.compte_sortie_stock = compte_sortie_stock;
    }

    public double getMontantCalc()
    {
        return this.getPu()*(this.getEntree()+this.getSortie());
    }

    public Date getDateInventaire() {
        return dateInventaire;
    }

    public void setDateInventaire(Date dateInventaire) {
        this.dateInventaire = dateInventaire;
    }

    public double getQteInventaire() {
        return qteInventaire;
    }

    public void setQteInventaire(double qteInventaire)throws Exception {
        if ((this.getMode().compareToIgnoreCase("modif")==0) && qteInventaire < 0) {
            throw new Exception("Quantit\u00E9 ne peut pas \u00EAtre inf\u00E9rieur \u00E0 0");
        }
        this.qteInventaire = qteInventaire;
    }

    public String getCompteLocalisation() {
        return compteLocalisation;
    }

    public void setCompteLocalisation(String compteLocalisation) throws Exception{
        this.compteLocalisation = compteLocalisation;
    }

    public String getIdunite() {
        return idunite;
    }

    public void setIdunite(String idunite) {
        this.idunite = idunite;
    }

    public String getIdUniteLib() {
        return idUniteLib;
    }

    public void setIdUniteLib(String idUniteLib) {
        this.idUniteLib = idUniteLib;
    }

    public String getIdinventairefille() {
        return idinventairefille;
    }

    public String getAutocompl() {
        return autocompl;
    }

    public void setAutocompl(String autocompl) {
        this.autocompl = autocompl;
    }

    public void setIdinventairefille(String idinventairefille) {
        this.idinventairefille = idinventairefille;
    }

    public String getIdFab() {
        return idFab;
    }

    public String getIdOff() {
        return idOff;
    }

    public void setIdOff(String idOff) {
        this.idOff = idOff;
    }

    public String getIdOf() {
        return idOf;
    }

    public void setIdOf(String idOf) {
        this.idOf = idOf;
    }

    public String getCategorieIngredient() {
        return categorieIngredient;
    }

    public void setCategorieIngredient(String categorieIngredient) {
        this.categorieIngredient = categorieIngredient;
    }

    public void setIdFab(String idFab) {
        this.idFab = idFab;
    }

    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant) throws Exception {
        if ((this.getMode().compareToIgnoreCase("modif")==0) && montant < 0) {
            throw new Exception("Montant ne peut pas \u00EAtre inf\u00E9rieur \u00E0 0");
        }
        this.montant = montant;
    }

    public double getPu() {
        return pu;
    }

    public void setPu(double pu) throws Exception {
        if ((this.getMode().compareToIgnoreCase("modif")==0) && pu < 0) {
            throw new Exception("Prix unitaire ne peut pas \u00EAtre inf\u00E9rieur \u00E0 0");
        }
        this.pu = pu;
    }

//    public String getIdlot() {
//        return idLot;
//    }
//
//    public void setIdlot(String idlot) {
//        this.idLot = idlot;
//    }

    @Override
    public boolean isSynchro(){
        return true;
    }
    
    public MvtStockFille() throws Exception{
        setNomTable("MvtStockFille");
        this.setLiaisonMere("idMvtStock");
        this.setNomClasseMere("stock.MvtStock");
    }

    public String getNomClasseMere(){
      return "stock.MvtStock";
    }

    public String getLiaisonMere(){
      return "idMvtStock";
    }

    public MvtStockFille contrer()throws Exception{
        MvtStockFille stockFille = (MvtStockFille)this.dupliquerSansBase();
        if(this.getEntree()>0)
        {
            stockFille.setSortie(this.getEntree());
            stockFille.setEntree(0);
        }
        else if(this.getSortie()>0){
            stockFille.setEntree(this.getSortie());
            stockFille.setSortie(0);
        }
        return stockFille;
    }

    public String getDesignation() {
        if(designation==null&&this.getMode().compareToIgnoreCase("select")==0) return "";
        return designation;
    }

    public void setDesignation(String designation) {
        this.designation = designation;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) throws Exception{
        this.id = id;
    }

    public String getIdMvtStock() {
        return idMvtStock;
    }

    public void setIdMvtStock(String idMvtStock) {
        this.idMvtStock = idMvtStock;
    }

    public String getIdProduit() {
        return idProduit;
    }

    public void setIdProduit(String idProduit) throws Exception{
        if((this.getMode().compareToIgnoreCase("modif")==0) && (idProduit==null || idProduit.isEmpty()==true))throw new Exception("Veuillez entrer un produit");
        this.idProduit = idProduit;
    }

    public String getIdVenteDetail() {
        return idVenteDetail;
    }

    public void setIdVenteDetail(String idVenteDetail) {
        this.idVenteDetail = idVenteDetail;
    }

    public String getIdTransfertDetail() {
        return idTransfertDetail;
    }

    public void setIdTransfertDetail(String idTransfertDetail) {
        this.idTransfertDetail = idTransfertDetail;
    }

    public double getEntree() {
        return entree;
    }

    public void setEntree(double entree) throws Exception {
        if(getMode().compareTo("modif")==0 && entree<0)throw new Exception("Valeur de l'entree invalide");
        this.entree = entree;
    }

    public double getSortie() {
        return sortie;
    }

    public void setSortie(double sortie) throws Exception {
        if(getMode().compareTo("modif")==0 && sortie<0)throw new Exception("Valeur de la sortie invalide");
        this.sortie = sortie;
    }



    public MvtStockFille[] getMvtFromSrc(MvtStockFille mvtF)throws Exception{
        Connection c=null;
        boolean canClose=false;
        try {
            c=new UtilDB().GetConn();
            canClose=true;
            MvtStockFille mvtfille = new MvtStockFille();
            mvtfille.setMvtSrc(mvtF.getId());
            MvtStockFille[] lmvt=(MvtStockFille[]) CGenUtil.rechercher(mvtfille, null, null, c, "");
            return lmvt;
        } catch (Exception e) {
            throw e;
        }
        finally {
            if(canClose){
                c.close();
            }
        }
    }
    public void updatePrice(MvtStockFille[] lmvtFille, MvtStockFille mvtFille, double price)throws Exception{
        Connection c=null;
        boolean canClose=false;
        try {
            c=new UtilDB().GetConn();
            canClose=true;
            lmvtFille = getMvtFromSrc(mvtFille);
            for (int i = 0; i < lmvtFille.length; i++) {
                lmvtFille[i].setPu(price);
                lmvtFille[i].updateToTable(c);
            }
            mvtFille.setPu(price);
            mvtFille.updateToTable(c);
        } catch (Exception e) {
            throw e;
        }
        finally {
            if(canClose){
                c.close();
            }
        }
    }


    
    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("MVTSFI", "GETSEQMVTSTOCKFILLE");
        this.setId(makePK(c));
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
        super.setLiaisonMere("idMvtStock");
    }

    @Override
    public void controlerUpdate(Connection c) throws Exception {
        super.setNomClasseMere("stock.MvtStock");
        this.controlerSaisie();
        controllerMvtSortieCump(c,null);
        this.controllerMvtSrc(c);
        super.controlerUpdate(c);
    }

    @Override
    public void controler(Connection c) throws Exception{
        this.controlerSaisie();
        controllerMvtSortieCump(c,null);
        this.controllerMvtSrc(c);
        /**if( this.getSortie() > 0 && this.getEntree() == 0 ){
            EtatStock[] etats = (EtatStock[])CGenUtil.rechercher( new EtatStock(), null,null, c, " and id='" + this.getIdProduit() + "' and idMagasin='"+((MvtStock)this.getMere()).getIdMagasin()+"'");
            EtatStock etat = etats[0];
            if( etat.getReste() <= 0 || etat.getReste() < this.getSortie() ){
                throw new Exception("Veuillez rentrez le produit " + this.getIdProduit() + " : stock insuffisant");
            }
        }*/
        Ingredients ing=this.getIngredient(c);
        if (ing.getTypeStock()==null || ing.getTypeStock()=="") {
            throw new Exception(String.format("Ce produit %s ne peut pas generer un mouvement de stock.Veuillez verifier le type de stock du produit",ing.getId()));
        }
        if(this.getSortie()>0 && this.getEntree() == 0)
        {   
            /*EtatStock e = new EtatStock();
            e.setNomTable("V_ETATSTOCK_ING");
            e.setId(this.getIdProduit());
            MvtStock mere = this.getMereMvtStock(c);
            e.setIdMagasin(mere.getIdMagasin());
            EtatStock[] etats=null;// = (EtatStock[])CGenUtil.rechercher(e, null,null, c,"");
            EtatStock etat=null;
            if(etats!=null) etat= etats[0];*/
            /*if( etat.getReste() <= 0 || etat.getReste() < this.getSortie() ){
                throw new Exception("Stock de "+etat.getIdProduitLib()+" insuffisant: "+etat.getReste());
            }*/
            
        }
        //controllerQteLivraison(c);
    }
    public As_BondeLivraisonClientFille_Cpl getBondeLivraisonClientFille(Connection c) throws Exception{
        As_BondeLivraisonClientFille_Cpl blf= new As_BondeLivraisonClientFille_Cpl();
        blf.setIdventedetail(this.getIdVenteDetail());
        As_BondeLivraisonClientFille_Cpl[] As_BondeLivraisonClientFille= (As_BondeLivraisonClientFille_Cpl[]) CGenUtil.rechercher(blf,null,null,c, "");
        if(As_BondeLivraisonClientFille.length>0 || blf!=null){
            return As_BondeLivraisonClientFille[0];
        }
        return null;
    }
    public void controllerQteLivraison(Connection c) throws Exception{
        As_BondeLivraisonClientFille_Cpl blf=getBondeLivraisonClientFille(c);
        if(this.sortie>blf.getQteResteALivrer()){
            throw new Exception( blf.getIdproduitlib()+ " : quantit\u00E9 supérieure au reste à livrer");
            }
    }
    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {
        lierAvecLot(u,c);
        return super.createObject(u, c);
    }

    public void lierAvecLot(String u, Connection c) throws Exception{
//        MvtStock mere = getMereMvtStock(c);
//        if (entree > 0 && idLot == null && estIngredientProduitFini(c) && mere != null){
//            Lot lot = this.genererLot(c);
//            lot.createObject(u, c);
//            this.setIdlot(lot.getId());
//        }
//        checkLot(c);
    }

    @Override
    public ClassMAPTable createObjectBatch(String u, Statement st) throws Exception {
        Connection c = st.getConnection();
        lierAvecLot(u,c);
        return super.createObjectBatch(u, st);
    }

    public void controlerSaisie() throws Exception{
        if(this.getIdProduit() == null || this.getIdProduit().isEmpty()){
            throw new Exception("Veuillez entrer un produit");
        }
        if(this.getEntree() <= 0 && this.getSortie() <=0){
            throw new Exception("Verifier la quantite sur entree et sortie!");
        }
        if (this.getEntree() > 0) {
            this.setMvtSrc(null);
            if (Utilitaire.champNull(this.getCompteLocalisation()).compareTo("") == 0) {
                throw new Exception("Localisation obligatoire pour effectuer une entr\u00E9e de stock");
            }
        }
    }

     public MvtStock getMereMvtStock(Connection c) throws Exception {
        /*if (c == null) {
            throw new Exception("Connection non etablie");
        }*/
        MvtStock m = new MvtStock();
        m.setId(this.getIdMvtStock());
        MvtStock[] listes = (MvtStock[]) CGenUtil.rechercher(m, null, null, c, "");
        if (listes.length > 0) {
            return listes[0];
        }
        return null;
    }

    public Ingredients getIngredient(Connection c) throws Exception {
        if(this.getIngredients()!=null)return this.getIngredients();
        Ingredients search = new Ingredients();
        search.setId(this.getIdProduit());
        Ingredients[] result = (Ingredients[]) CGenUtil.rechercher(search,null,null,c,"");
        if (result.length == 0) {
            throw new Exception("Ingredients avec id : " + this.getIdProduit() + " introuvable");
        }
        this.setIngredients(result[0]);
        return result[0];
    }

    public void updateQteIngredient(String u, Connection c)throws Exception{
        Ingredients ing = this.getIngredient(c);
        ing.setReste(ing.getReste()+this.getEntree());
        ing.setReste(ing.getReste()-this.getSortie());
        ing.updateToTableWithHisto(u, c);
    }

    public double getReste() {
        return reste;
    }

    public void setReste(double reste) {
        this.reste = reste;
    }

    public String getMvtSrc() {
        return mvtSrc;
    }

    public void setMvtSrc(String mvtSrc) {
        this.mvtSrc = mvtSrc;
    }

    public double getQuantite(Connection c, MvtStock mere) throws Exception {
        EtatStockParEntree search = new EtatStockParEntree();
        search.setId(this.getIdProduit());
        search.setIdMagasin(mere.getIdMagasin());
        if(mere.getIdTypeMvStock().compareTo(ConstanteStation.TYPEMVTSTOCKINVENTAIRE)==0){
            search.setNomTable("V_ETATSTOCK_ING_ALL");
        }else if(this.getMvtSrc() != null && !this.getMvtSrc().isEmpty()){
            search.setNomTable("V_ETATSTOCK_ENTREE");
            search.setId(this.getMvtSrc());
            search.setIdProduit(this.getIdProduit());
        }
        else
        {
            EtatStock crt=new EtatStock();
            crt.setIdProduit(this.getIdProduit());
            crt.setIdMagasin(mere.getIdMagasin());
            EtatStock[] etat=(EtatStock[]) CGenUtil.rechercher(crt,null,null,c,"");
            if(etat.length>0&&etat[0]!=null){
                double retour= etat[0].getReste();
                return retour;
            }
            return 0;
        }

        EtatStockParEntree[] retour = (EtatStockParEntree[]) CGenUtil.rechercher(search,null,null, c,"");
        if (retour.length == 0) {
            throw new Exception("Mouvement Stock Entree avec id produit : " + this.getIdProduit() + " introuvable");
        }
        return retour[0].getReste();
    }

    public boolean estSuffisant(Connection c, MvtStock mere) throws Exception {
        if (this.getSortie()>this.getQuantite(c, mere)) {
            return false;
        }
        return true;
    }

    public MvtStockFille[] genererNouveauMvt(MvtStockEntreeAvecReste[] stockReste) throws Exception {
        List<MvtStockFille> retourList = new ArrayList<>();
        double quantite = this.getSortie();
            for (int i = 0; i < stockReste.length && quantite>0; i++) {
                double reste = stockReste[i].getQuantite() - quantite;
                if (reste < 0) {
                    reste = 0;
                }
                double sortie= stockReste[i].getQuantite() - reste;
                MvtStockFille mvtFille = new MvtStockFille();
                mvtFille.setIdMvtStock(this.getIdMvtStock());
                mvtFille.setIdProduit(this.getIdProduit());
                mvtFille.setSortie(sortie);
                mvtFille.setMvtSrc(stockReste[i].getId());
                mvtFille.setPu(stockReste[i].getPu());
                quantite = quantite - mvtFille.getSortie();
                retourList.add(mvtFille);
            }
        return retourList.toArray(new MvtStockFille[0]);
    }

    public void updateQteIngredientBatch(String u, Statement st)throws Exception{
        Ingredients ing = this.getIngredient(st.getConnection());
        ing.setReste(ing.getReste()+this.getEntree());
        ing.setReste(ing.getReste()-this.getSortie());
        ing.updateToTableWithHistoBatch(u, st);
    }

//    public void controllerMvtSrc(Connection c)throws Exception{
//        boolean estOuvert = false;
//        try {
//            if (c == null) {
//                estOuvert = true;
//                c = new UtilDB().GetConn();
//            }
//            if(this.getMvtSrc() != null && !this.getMvtSrc().isEmpty()){
//                MvtStockEntreeAvecReste map = new MvtStockEntreeAvecReste();
//                MvtStockEntreeAvecReste rep = (MvtStockEntreeAvecReste) map.getById(this.getMvtSrc(), "V_ETATSTOCK_ENTREE", c);
//                if(rep != null) {
//                    if(this.getIdProduit().compareToIgnoreCase(rep.getIdProduit()) != 0){
//                        throw new Exception("Le produit dans le mouvement source "+ rep.getId()+" ne correspondant pas au produit dans " + this.getMvtSrc());
//                    }
//                }
//            }else{
//                MvtStock mere = this.getMereMvtStock(c);
//                if(mere!=null && mere.getIdTypeMvStock().compareTo(ConstanteSocobis.TYPE_MVT_SORTIE) == 0){
//                    Ingredients ingredients = this.getIngredient(c);
//                    if(ingredients!=null && !ingredients.getCategorieIngredient().equalsIgnoreCase(ConstanteSocobis.CATEGORIE_CONSOMMABLE) && !ingredients.getCategorieIngredient().equalsIgnoreCase(ConstanteSocobis.CATEGORIE_PRODUIT_FINI) && !ingredients.getCategorieIngredient().equalsIgnoreCase(ConstanteSocobis.CATEGORIE_MAINTENANCE)){
//                        throw new Exception("Le mouvement source ne peut pas \u00EAtre vide");
//                    }
//                }
//            }
//        } catch (Exception e) {
//            throw e;
//        } finally {
//            if (c != null && estOuvert == true) {
//                c.close();
//            }
//        }
//    }
    EtatStockLocalisation findEtatStockLocalisation(Connection c) throws Exception {
        MvtStock mere = (MvtStock) this.getMere();
        EtatStockLocalisation stock = new EtatStockLocalisation();
        stock.setIdMagasin(mere.getIdMagasin());
        stock.setIdProduit(this.getIdProduit());
        stock.setCompteLocalisation(this.getCompteLocalisation());
        String requete = EtatStockLocalisation.getRequeteEtatStockLocalisation(Utilitaire.dateDuJour());
        EtatStockLocalisation[] etatStock = (EtatStockLocalisation[]) CGenUtil.rechercherReq(stock,requete,c,"");
        if (etatStock.length > 0) {
            return etatStock[0];
        }
        return stock;
    }

    public void controllerMvtSortieCump(Connection c, Ingredients ing) throws Exception{
        if (ing == null) {
            ing = this.getIngredient(c);
        }
        if (ing.getTypeStock().compareToIgnoreCase("CUMP")!=0) {
            return;
        }
        if (!Utilitaire.champNull(this.getCompteLocalisation()).isEmpty()) {
            if (this.getSortie() > 0) {
                EtatStockLocalisation etatStock = findEtatStockLocalisation(c);
                if (etatStock.getReste() < this.getSortie()) {
                    throw new Exception(
                        "Impossible d'effectuer la sortie pour le produit " + this.getIdProduit() +
                            " : quantit\u00E9 demand\u00E9e = " + this.getSortie() +
                            ", reste disponible = " + etatStock.getReste()
                    );
                }
            }
        } else {
            throw new Exception("champ localisation obligatoire. Produit : "+this.getIdProduit());
        }
    }

    public void controllerMvtSrc(Connection c)throws Exception{
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
            }
            Ingredients ing = this.getIngredient(c);

            if((ing.getTypeStock().compareToIgnoreCase("FIFO")==0 || ing.getTypeStock().compareToIgnoreCase("LIFO")==0 || ing.getTypeStock().compareToIgnoreCase("CUMP")==0)
                && this.getMode().compareToIgnoreCase("modif")==0 && this.getSortie() > 0 && !Utilitaire.champNull(this.getMvtSrc()).isEmpty()) {
                this.setMvtSrc(null);
            }

            if (ing.getTypeStock().compareToIgnoreCase("LOT")==0 && Utilitaire.champNull(this.getMvtSrc()).isEmpty()
                && this.getSortie() > 0 && this.getEntree() == 0) {
                throw new Exception("Mouvement source obligatoire pour effectuer une sortie de stock d'un produit g\u00E9r\u00E9 par LOT");
            }

            if(this.getMvtSrc() != null && !this.getMvtSrc().isEmpty()){
                MvtStockEntreeAvecReste map = new MvtStockEntreeAvecReste();
                MvtStockEntreeAvecReste rep = (MvtStockEntreeAvecReste) map.getById(this.getMvtSrc(), "V_ETATSTOCK_ENTREE", c);
                if(rep != null) {
                    this.setCompteLocalisation(rep.getCompteLocalisation());
                    if(this.getIdProduit().compareToIgnoreCase(rep.getIdProduit()) != 0){
                        throw new Exception("Le produit dans le mouvement source "+ rep.getId()+" ne correspondant pas au produit dans " + this.getMvtSrc());
                    }
//                    MvtStockFilleLib dejaSorti = new MvtStockFilleLib();
//                    dejaSorti.setNomTable("MVTSTOCKFILLEFABVISE");
//                    dejaSorti.setMvtsrc(this.getMvtSrc());
//                    MvtStockFilleLib[] dejaSortiListe = (MvtStockFilleLib[]) CGenUtil.rechercher(dejaSorti,null,null,c,"");
//                    double quantiteSorti = AdminGen.calculSommeDouble(dejaSortiListe,"sortie");
//                    quantiteSorti= Utilitaire.arrondir(quantiteSorti,2);
                    if (Utilitaire.arrondir(this.getSortie(),2) > rep.getReste()) {
                        throw new Exception(
                                "Impossible d'effectuer la sortie : la quantit\u00E9 demand\u00E9e (" + this.getSortie() +
//                                        ") ajout\u00E9e \u00E0 la quantit\u00E9 d\u00E9j\u00E0 sortie (" +  quantiteSorti +
                                        ") du produit "+ this.getIdProduit()+ " - " + rep.getIdProduitLib()  +" d\u00E9passe la quantit\u00E9 disponible du mouvement source (" + rep.getEntree() + ")."
                        );
                    }
                }
            }
//            else{
//                MvtStock mere = this.getMereMvtStock(c);
//                if(mere!=null &&  mere.getIdTypeMvStock() != null && mere.getIdTypeMvStock().compareTo(ConstanteSocobis.TYPE_MVT_SORTIE) == 0){
//                    TransfertStock trans = null;
//                    if (mere.getIdTransfert() != null) {
//                        trans = (TransfertStock) new TransfertStock().getById(mere.getIdTransfert(), "transfertstock", c);
//                    }
//
//                    Ingredients ingredients = this.getIngredient(c);
//                    if ((trans == null || trans.getIsvente() != 1)
//                            && ingredients != null
//                            && ingredients.getCategorieIngredient() != null
//                            && !ingredients.getCategorieIngredient().equalsIgnoreCase(ConstanteSocobis.CATEGORIE_CONSOMMABLE)
//                            && !ingredients.getCategorieIngredient().equalsIgnoreCase(ConstanteSocobis.CATEGORIE_PRODUIT_FINI)
//                            && !ingredients.getCategorieIngredient().equalsIgnoreCase(ConstanteSocobis.CATEGORIE_MAINTENANCE)) {
//
//                        throw new Exception("Le mouvement source ne peut pas être vide");
//                    }
//                }
//            }
        } catch (Exception e) {
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }


    public static Map<String, Double> getDataChartCheese() throws Exception {
        Map<String, Double> dataChart = new HashMap<String, Double>();
        String req = "select sum(ENTREE) as entree, sum(SORTIE) as sortie from MVTSTOCKFILLELIB where IDPRODUIT = 'ING000T0108'";
        MvtStockFille[] etat = (MvtStockFille[]) CGenUtil.rechercher(new MvtStockFille(), req);
        dataChart.put("Entree", (double) etat[0].getEntree());
        dataChart.put("Sortie", (double) etat[0].getSortie());
        return dataChart;
    }

    public static Map<String, Double> getDataChartBar() throws Exception {
        Map<String, Double> dataChart = new LinkedHashMap<>();
        String req = "SELECT *\n" +
                "FROM (\n" +
                "    SELECT IDPRODUIT, IDPRODUITLIB, SUM(SORTIE) AS sortie\n" +
                "    FROM MVTSTOCKFILLELIB\n" +
                "    GROUP BY IDPRODUIT, IDPRODUITLIB\n" +
                ")\n" +
                "WHERE ROWNUM <= 50";
        MvtStockFilleLib[] etat = (MvtStockFilleLib[]) CGenUtil.rechercher(new MvtStockFilleLib(), req);
        for (MvtStockFilleLib charge : etat) {
            dataChart.put(charge.getIdProduitlib(), charge.getSortie());
        }

        return dataChart;
    }

    public Lot genererLot(Connection c) throws Exception {
//        MvtStock mere = this.getMereMvtStock(c);
//        if(mere == null) {
//            throw new Exception("Mouvement stock mere introuvable");
//        }
        Lot lot = new Lot();
//        lot.setIdProduit(this.getIdProduit());
//
//        Fabrication fab = mere.getFab(c);
//        Date daty = mere.getDaty();
////        if (fab == null) {
////            throw new Exception("Fabrication introuvable pour le mouvement stock mere");
////        }
//        if (fab != null) {
//            daty = fab.getDaty();
//            lot.setIdEquipe(fab.getEquipe());
//        }
//        lot.setDaty(daty);
        return lot;
    }

    public void checkLot(Connection c) throws Exception {
//        if (estIngredientProduitFini(c) && sortie > 0 && (idLot == null || idLot.isEmpty())) {
//            throw new Exception("Le lot doit être spécifié");
//        }
    }

    public boolean estIngredientProduitFini(Connection c) throws Exception {
        Ingredients ing = getIngredient(c);
        return ing.getCategorieIngredient().equalsIgnoreCase(ConstanteSocobis.CATEGORIE_PRODUIT_FINI);
    }
    public MvtStockEntreeAvecReste[] getMvtSelonType(Connection c,String apres) throws Exception {
        MvtStockEntreeAvecReste search = new MvtStockEntreeAvecReste();
        search.setNomTable("V_ETATSTOCK_ENTREE");
        MvtStock mere=(MvtStock)this.getMere();
        search.setIdMagasin(mere.getIdMagasin());
        search.setIdProduit(this.getIdProduit());
        return  (MvtStockEntreeAvecReste[]) CGenUtil.rechercher(search,null, null, apres);
    }
    public EtatStock getMonEtatStock(Connection c) throws Exception
    {
        MvtStock mer=(MvtStock) this.getMere();
        EtatStock[] etatStock=mer.findEtatStockGlobale(c);
        String[] col={"idProduit"};
        String[] val={this.getIdProduit()};
        EtatStock[] monEtatStock=(EtatStock[]) AdminGen.find(etatStock,col,val);
        if(monEtatStock!=null&&monEtatStock.length>0)return monEtatStock[0];
        return null;
    }
    public EtatStockParEntree getMonEtatStockParEntree(Connection c) throws Exception
    {
        MvtStock mer=(MvtStock) this.getMere();
        EtatStockParEntree[] etatStock=mer.findEtatStockEntree(c);
        String[] col={"id"};
        String[] val={this.getMvtSrc()};
        EtatStockParEntree[] monEtatStock=(EtatStockParEntree[]) AdminGen.find(etatStock,col,val);
        if(monEtatStock!=null&&monEtatStock.length>0)return monEtatStock[0];
        return null;
    }

    public Object validerObject(String u, Connection c) throws Exception
    {
        Ingredients ing = this.getIngredient(c);
        if(ing.getTypeStock().compareToIgnoreCase("FIFO")!=0&&ing.getTypeStock().compareToIgnoreCase("LIFO")!=0) {
            controllerMvtSortieCump(c,ing);
            return null;
        };
        if(this.getEntree()>0&&this.getSortie()==0)
            return validerObjectEntree(u,c);
        return validerObjectSortie(u,c);
    }
    public Object validerObjectEntree(String u, Connection c) throws Exception
    {
        this.setReste(this.getEntree());
        return this.getMere();
    }
    public Object validerObjectSortie(String u, Connection c) throws Exception
    {
//        if(this.getMvtSrc()!=null&&this.getMvtSrc().compareToIgnoreCase("")!=0)
//        {
//            return this.getMere();
//        }
        Ingredients ing=this.getIngredient(c);
        String apres=" order by daty asc,id asc ";
        MvtStock mere=(MvtStock) this.getMere();
        if(ing.getTypeStock().compareToIgnoreCase("LIFO")==0) apres=" order by daty desc,id desc ";;
        validerObjectSortieFIFOLIFO(u,c,apres);
        return mere;
    }
    public void validerObjectSortieFIFOLIFO(String u, Connection c, String ordre) throws Exception
    {
        List<MvtStockFille> mvtstockfillenew= new ArrayList<MvtStockFille>();
        if(ordre==null||ordre.compareToIgnoreCase("")==0) ordre=" order by daty asc,id asc ";
        MvtStockEntreeAvecReste[] listeMvt=getMvtSelonType(c,ordre);
        double sommeReste= AdminGen.calculSommeDouble(listeMvt,"reste");
        if (this.getSortie() > sommeReste) {
            String produit = (listeMvt != null && listeMvt.length >0) ? listeMvt[0].getIdProduitLib() : "";
            throw new Exception(
                "Stock insuffisant pour le produit " + produit
                    + " : quantit\u00E9 demand\u00E9e = " + this.getSortie()
                    + ", reste disponible = " + sommeReste
            );
        }
        double reste=this.getSortie();
        for(int i=0;reste>0;i++)
        {
            MvtStockFille temp=(MvtStockFille) this.dupliquerSansBase();
            temp.setMode("select");
            temp.setSortie(Math.min(listeMvt[i].getReste(),reste));
            temp.construirePK(c);
            temp.setMvtSrc(listeMvt[i].getId());
            temp.setCompteLocalisation(listeMvt[i].getCompteLocalisation());
            temp.setPu(listeMvt[i].getPu());
            temp.createObject(u,c);
            reste=reste-temp.getSortie() ;
            mvtstockfillenew.add(temp);
        }
        this.deleteToTableWithHisto(u,c);
        MvtStockFille[]lf=new MvtStockFille[mvtstockfillenew.size()];
        mvtstockfillenew.toArray(lf);
        this.getMere().setFille(lf);
    }
    public double getReste(Connection c,MvtStock mere) throws Exception {
        if(this.getMvtSrc()==null||this.getMvtSrc().compareToIgnoreCase("")==0) {
            /*EtatStockParEntree search = new EtatStockParEntree();
            search.setNomTable("ETATSTOCKSIMPLE");
            search.setIdProduit(this.getIdProduit());
            search.setIdMagasin(mere.getIdMagasin());
            EtatStockParEntree[] retour = (EtatStockParEntree[]) CGenUtil.rechercher(search, null, null, c, "");
            if (retour == null || retour.length == 0) return 0;
            return retour[0].getReste();*/
            EtatStock es=this.getMonEtatStock(c);
            if(es!=null) return es.getReste();
        }
        else
        {
            EtatStockParEntree esp=this.getMonEtatStockParEntree(c);
            if(esp!=null)return esp.getReste();
        }
        return 0;
    }


}
