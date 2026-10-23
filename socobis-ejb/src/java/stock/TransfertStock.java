/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package stock;

import bean.*;

import java.net.ConnectException;
import java.sql.Connection;
import java.sql.Date;
import java.text.SimpleDateFormat;

import historique.MapUtilisateur;
import inventaire.InventaireFille;
import magasin.CategorieIngredientMagasin;
import produits.Ingredients;
import utilitaire.Utilitaire;
import utils.ConstanteSocobis;
import utils.ConstanteStation;
import constante.ConstanteEtat;
import vente.EquivalenceVente;

/**
 *
 * @author 26134
 */
public class TransfertStock extends ClassMere{
    String id,designation,idMagasinDepart,idMagasinArrive, idOf, idFabrication,idDemande;
    Date daty;
    int isvente;

    public int getIsvente() {
        return isvente;
    }

    public void setIsvente(int isvente) {
        this.isvente = isvente;
    }
    public TransfertStock() throws Exception {
        this.setNomTable("TransfertStock");
        this.setLiaisonFille("idTransfertStock");
        this.setNomClasseFille("stock.TransfertStockDetails");
    }

    public String getIdFabrication() {
        return idFabrication;
    }

    public void setIdFabrication(String idFabrication) {
        this.idFabrication = idFabrication;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getDesignation() {
        return designation;
    }

    public void setDesignation(String designation) {
        this.designation = designation;
    }

    public String getIdMagasinDepart() {
        return idMagasinDepart;
    }

    public void setIdMagasinDepart(String idMagasinDepart)throws Exception{
        if (this.getMode().equals("modif") && Utilitaire.champNull(idMagasinDepart).compareTo("") == 0 ) {
            throw new Exception("Champ magasin de depart obligatoire");
        }
        this.idMagasinDepart = idMagasinDepart;
    }

    public String getIdMagasinArrive() {
        return idMagasinArrive;
    }

    public void setIdMagasinArrive(String idMagasinArrive) throws Exception{
        if (this.getMode().equals("modif") && Utilitaire.champNull(idMagasinArrive).compareTo("") == 0 ) {
            throw new Exception("Champ magasin d' arriv&eacute;e obligatoire");
        }
        this.idMagasinArrive = idMagasinArrive;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        if((this.getMode().compareToIgnoreCase("modif")==0||this.getMode().compareToIgnoreCase("insert")==0)&&(daty==null||daty.equals(""))){
            daty=Utilitaire.dateDuJourSql();
        }
        this.daty = daty;
    }

    public String getIdOf() {
        return idOf;
    }

    public void setIdOf(String idOf) {
        this.idOf = idOf;
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("TS", "getseqTransfertStock");
        this.setId(makePK(c));
    }
    @Override
    public String getTuppleID() {
        return this.id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }
    @Override
    public String getLiaisonFille() {
        return "idTransfertStock";
    }
    @Override
    public String getNomClasseFille() {
        return "stock.TransfertStockDetails";
    }
    
    public TransfertStockDetails[] getTransfertStockDetails(Connection c) throws Exception{
        TransfertStockDetails[] tsd=(TransfertStockDetails[]) CGenUtil.rechercher(new TransfertStockDetails(), null, null, c, " and idTransfertStock='"+this.getId()+"' ");
        return tsd;
    }
    
    protected MvtStock createMvtStock(boolean isEntree) throws Exception{
        MvtStock md=new MvtStock();
        md.setDaty(this.getDaty());
        md.setIdTransfert(this.getId());
        if (isEntree) {    
            md.setIdMagasin(this.getIdMagasinArrive());
            md.setIdTypeMvStock(ConstanteStation.TYPEMVTSTOCKENTREE);
            md.setDesignation("transfert "+this.getDesignation()+" (entree)");
        }else{
            md.setIdMagasin(this.getIdMagasinDepart());
            md.setIdTypeMvStock(ConstanteStation.TYPEMVTSTOCKSORTIE);
            md.setDesignation("transfert "+this.getDesignation()+" (sortie)");
        }
        return md;
    }
    /*protected MvtStockFille[] createMvtStockFilles(boolean isEntree,Connection c) throws Exception{
        TransfertStockDetails[] tsd=this.getTransfertStockDetails(c);
        MvtStockFille[] mvtf=new MvtStockFille[tsd.length];
        for (int i = 0; i < tsd.length; i++) {
            mvtf[i] = tsd[i].createMvtStockFille(isEntree);
        }
        return mvtf;
    }*/

    protected MvtStockFille[] createMvtStockFilles(boolean isEntree,Connection c) throws Exception{
        TransfertStockDetails[] tsd=this.getTransfertStockDetails(c);
        MvtStockFille[] mvtf=new MvtStockFille[tsd.length];
        for (int i = 0; i < tsd.length; i++) {
            mvtf[i] = tsd[i].createMvtStockFille(isEntree);
//            if(this.getIsvente()==1 && isEntree==true){
//                double qtePiece  = 0;
//                double puPiece = 0;
//                String idproduit2 = "";
//                EquivalenceVente equivalence = Ingredients.getEquivalenceVente(tsd[i].getIdProduit(), null, c);
//                System.err.println(equivalence+"=====================");
//                if(equivalence != null){
//                    qtePiece = tsd[i].getQuantite() * equivalence.getQuantite();
//                    //  puPiece = tsd[i].getPu() / equivalence.getQuantite();
//                    idproduit2 = equivalence.getIdproduit1();
//                    Ingredients ing = new Ingredients();
//                    ing.setId(idproduit2);
//                    ing = ing.getIngredient(c);
//                    if(ing!=null){
//                        puPiece= ing.getPu();
//                    }
//                }
//                mvtf[i].setMvtSrc(null);
//                mvtf[i].setEntree(qtePiece);
//                mvtf[i].setPu(puPiece);
//                mvtf[i].setIdProduit(idproduit2);
//            }
        }
        return mvtf;
    }

    public void checkCategorieProduit(Connection c,String idmagasin) throws Exception{
        CategorieIngredientMagasin magasin = new CategorieIngredientMagasin();
        magasin.setIdMagasin(idmagasin);
        CategorieIngredientMagasin[] magasins = (CategorieIngredientMagasin[]) CGenUtil.rechercher(magasin,null,null,"");
        if(magasins != null && magasins.length>0){
            TransfertStockDetails[] Fille = (TransfertStockDetails[]) this.getFille();
            if(Fille!=null && Fille.length>0){
                for(int i = 0 ;i<Fille.length;i++){
                    Ingredients ing = new Ingredients();
                    ing = (Ingredients) ing.getById(Fille[i].getIdProduit(),"AS_INGREDIENTS",c);
                    CategorieIngredientMagasin[] mags = (CategorieIngredientMagasin[]) AdminGen.find(magasins,new String[]{"idCategorieIngredient"},new String[]{ing.getCategorieIngredient()});
                    if(mags == null || mags.length == 0){
                        throw new Exception("Cat\u00E9gorie  du produit " + ing.getId()  + "( " + ing.getLibelle()  + " ) n est pas prise en compte dans ce magasin " );
                    }
                }
            }
        }
    }

    @Override
    public void controlerUpdate(Connection c) throws Exception {
        if (this.getIdMagasinDepart() == null || this.getIdMagasinArrive() == null ||
                this.getIdMagasinDepart().trim().isEmpty() || this.getIdMagasinArrive().trim().isEmpty()) {
            throw new Exception("Les identifiants des magasins ne doivent pas être null ou vides.");
        }
        super.controlerUpdate(c);
        checkCategorieProduit(c,this.getIdMagasinDepart());
        checkCategorieProduit(c,this.getIdMagasinArrive());
    }

    @Override
    public void controler(Connection c) throws Exception {
        if (this.getIdMagasinDepart() == null || this.getIdMagasinArrive() == null ||
                this.getIdMagasinDepart().trim().isEmpty() || this.getIdMagasinArrive().trim().isEmpty()) {
            throw new Exception("Les identifiants des magasins ne doivent pas être null ou vides.");
        }

        if (this.getIdMagasinDepart().equals(this.getIdMagasinArrive())) {
            throw new Exception("Le magasin de départ doit être différent du magasin d’arrivée.");
        }
        checkCategorieProduit(c,this.getIdMagasinDepart());
        checkCategorieProduit(c,this.getIdMagasinArrive());
    }

    protected MvtStock createMvtStockEntree(String u, Connection c) throws Exception{
        MvtStock me=this.createMvtStock(true);
        me.setFille(this.createMvtStockFilles(true, c));
        me.createObject(u, c);
        //me.saveMvtStockFille(u, c);
        //me.validerObject(u, c);
        return me;
    }
    
    protected MvtStock createMvtStockSortie(String u, Connection c) throws Exception{
        MvtStock ms=this.createMvtStock(false);
        ms.setFille(this.createMvtStockFilles(false, c));
        ms.createObject(u, c);
        //ms.saveMvtStockFille(u, c);
        ms.validerObject(u, c);
        return ms;
    }
    
    @Override
    public Object validerObject(String u, Connection c) throws Exception {
        this.createMvtStockEntree(u, c);
        this.createMvtStockSortie(u, c);
        //MvtStock msortie= this.createMvtStockSortie(u, c);
        //this.createMvtStockEntree(msortie,u, c);
        return super.validerObject(u, c);
    }

    @Override
    public ClassMAPTable createObject(MapUtilisateur u, Connection c)throws Exception{
        if(u.getIdrole().compareTo(ConstanteSocobis.MAGCENTRAL_RANG) != 0){
            throw new Exception("Vous n'avez pas le droit de creer un transfert de stock!");
        }
        return super.createObject(u,c);
    }

    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception{
        System.out.println("Id DEMANDE="+this.getIdDemande());
        findEntreeFilles(c);
        return super.createObject(u,c);
    }

    EtatStock[] findEtatStockGlobale(Connection c) throws Exception
    {
        EtatStock crt=new EtatStock();
        crt.setIdMagasin(this.getIdMagasinDepart());
        TransfertStockDetails[] invFille=(TransfertStockDetails[]) this.getFille();
        String listeWhere=" and idProduit in ("+ Utilitaire.tabToString(invFille,"idProduit","'",",")+")";
        EtatStock[] retour= (EtatStock[]) CGenUtil.rechercherReq(new EtatStock(),EtatStock.getReqEtatStock(Utilitaire.dateDuJour()),c,listeWhere);
        return retour;
    }

    EtatStockLocalisation[] findEtatStockLocalisation(Connection c) throws Exception {
        EtatStockLocalisation stock = new EtatStockLocalisation();
        stock.setIdMagasin(this.getIdMagasinDepart());
        TransfertStockDetails[] invFille=(TransfertStockDetails[]) this.getFille();
        String listeWhere=" and idProduit in ("+ Utilitaire.tabToString(invFille,"idProduit","'",",")+")";
        String requete = EtatStockLocalisation.getRequeteEtatStockLocalisation(Utilitaire.dateDuJour());
        return (EtatStockLocalisation[]) CGenUtil.rechercherReq(new EtatStockLocalisation(),requete,c,listeWhere);
    }



    public void findEntreeFilles(Connection c) throws Exception{
        TransfertStockDetails[] filles = (TransfertStockDetails[]) getFille();
        EtatStockParEntree [] etatStocks = findEtatStockEntree(c);
        EtatStockLocalisation[] etatStockLocalisations = findEtatStockLocalisation(c);
        EtatStock[] etatGlobal = findEtatStockGlobale(c);
        Ingredients[] ingredients = (Ingredients[]) CGenUtil.rechercher(new Ingredients(),null,null,c,"");
        for (int i = 0; i < filles.length; i++) {
            String []col={"idProduit","idMagasin","compteLocalisation"};
            String[] val={filles[i].getIdProduit(),this.getIdMagasinDepart(),filles[i].getCompteLocalisationArrivee()};
            Ingredients ing = filles[i].getIngredient(ingredients);
            if(ing.getTypeStock().compareToIgnoreCase("FIFO")==0||ing.getTypeStock().compareToIgnoreCase("LIFO")==0
                || ing.getTypeStock().compareToIgnoreCase("CUMP")==0) {
                filles[i].setIdSource(null);
            }
            //System.out.println("TAILLE DE ETAT "+listeStock.length+" id produit "+listeStock[0].getIdProduit()+" TYPE DE STOCK "+listeStock[0].getTypeStock());
            if((filles[i].getIdSource()==null||filles[i].getIdSource().compareToIgnoreCase("")==0))//&& listeStock!=null&&listeStock.length>0 &&listeStock[0].getTypeStock()!=null&&listeStock[0].getTypeStock().compareToIgnoreCase("CUMP")==0)
            {
                EtatStock[] listeGlobale = null;
                if (ing.getTypeStock().compareToIgnoreCase("CUMP")==0) {
                    if (Utilitaire.champNull(filles[i].getCompteLocalisationDepart()).isEmpty()) {
                        throw new Exception("champ localisation de d\u00E9part obligatoire. Produit : "+filles[i].getIdProduit()+ " (CUMP)");
                    }
                    listeGlobale=(EtatStockLocalisation[])AdminGen.find(etatStockLocalisations,col,val);
                } else {
                    col=new String[]{"idProduit","idMagasin"};
                    val=new String[]{filles[i].getIdProduit(),this.getIdMagasinDepart()};
                    listeGlobale=(EtatStock[])AdminGen.find(etatGlobal,col,val);
                }
                if(listeGlobale!=null&&listeGlobale.length>0) {
                    if (filles[i].getQuantite()>listeGlobale[0].getReste()) {
                        throw new Exception(String.format("ingredient %s insuffisant", filles[i].getIdProduit()));
                    }
                    filles[i].setPu(listeGlobale[0].getPu());
                }
            }
            if (filles[i].getIdSource()!=null && !filles[i].getIdSource().isEmpty()) {
                String []colEntree={"idProduit","idMagasin","id"};
                String[] valEntree={filles[i].getIdProduit(),this.getIdMagasinDepart(),filles[i].getIdSource()};
                EtatStockParEntree[] listeStock=(EtatStockParEntree[])AdminGen.find(etatStocks,colEntree,valEntree);
                if(listeStock!=null&&listeStock.length>0) {
                    if (filles[i].getQuantite()>listeStock[0].getReste()) {
                        throw new Exception(String.format("ingredient %s insuffisant", filles[i].getIdProduit()));
                    }
                    filles[i].setIdSource(listeStock[0].getId());
                    filles[i].setPu(listeStock[0].getPu());
                }
            }
        }

    }

//    public void findEntreeFilles(Connection c) throws Exception{
//        TransfertStockDetails[] filles = (TransfertStockDetails[]) getFille();
//        EtatStockParEntree [] etatStocks = findEtatStockEntree(c);
//        for (int i = 0; i < filles.length; i++) {
//            filles[i].setDaty(this.getDaty());
//            if (filles[i].getIdSource()!=null && !filles[i].getIdSource().isEmpty()) {
//                return;
//            }
//            if (filles[i].getIdFournisseur()==null || filles[i].getIdFournisseur().isEmpty()){
//                filles[i].findFournisseur(c);
//            }
//            filles[i].findEtatStockEntree(etatStocks);
//            filles[i].setIdSource(filles[i].getEtatStock().getId());
//        }
//
//    }

    EtatStockParEntree[] findEtatStockEntree(Connection c) throws Exception{
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        String daty = sdf.format(getDaty());
        return (EtatStockParEntree[]) CGenUtil.rechercher(new EtatStockParEntree(),EtatStockParEntree.getRequeteEtatStockEntree(daty),c);
    }

    @Override
    public Object validerObject(MapUtilisateur u, Connection c) throws Exception{
        return super.validerObject(u,c);
    }
    public Object superValider(String u, Connection c)throws Exception {
        return super.validerObject(u, c);
    }
    public Object superValider(MapUtilisateur u, Connection c)throws Exception {
        return super.validerObject(u, c);
    }


    public ClassMAPTable superCreateObject(MapUtilisateur u, Connection c)throws Exception {
        return super.createObject(u,c);
    }

    public ClassMAPTable superCreateObject(String u, Connection c)throws Exception {
        return super.createObject(u,c);
    }

    public String getIdDemande() {
        return idDemande;
    }

    public void setIdDemande(String idDemande) {
        this.idDemande = idDemande;
    }
     protected MvtStock createMvtStockEntree(MvtStock sortie, String u, Connection c) throws Exception{
        MvtStock me=sortie.contrer(c);
        me.setIdMagasin(this.getIdMagasinArrive());
        me.createObject(u, c);
        me.setEtat(ConstanteEtat.getEtatCreer());
        //me.saveMvtStockFille(u, c);
        me.validerObject(u, c);
        return me;
    }
}
