/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package inventaire;

import bean.*;

import java.sql.Connection;
import java.sql.Date;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import com.google.gson.Gson;
import magasin.CategorieIngredientMagasin;
import magasin.Magasin;
import produits.Ingredients;
import stock.MvtStock;
import stock.MvtStockFille;
import stock.*;
import utilitaire.Utilitaire;
import utils.ConstanteStation;

public class Inventaire extends ClassMere{
    private String id, designation, idMagasin, remarque;
    private Date daty;
    private String idCategorie;
    String heure;
    public String getHeure() {
        return heure;
    }

    public void setHeure(String heure) {
        if((this.getMode().compareToIgnoreCase("modif")==0||this.getMode().compareToIgnoreCase("insert")==0)&&(heure==null||heure.equals(""))){
            heure=Utilitaire.heureCouranteHMS();
        }
        this.heure = heure;
    }

    public Inventaire(){
        this.setNomTable("inventaire");
        setLiaisonFille("idInventaire");
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

    public String getIdMagasin() {
        return idMagasin;
    }

    public void setIdMagasin(String idMagasin) throws Exception{
        if ((this.getMode().compareToIgnoreCase("modif")==0) && Utilitaire.champNull(idMagasin).compareTo("") == 0 ) {
            throw new Exception("Champ magasin obligatoire");
        }
        this.idMagasin = idMagasin;
    }

    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
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

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("IVT", "GETSEQinventaire");
        this.setId(makePK(c));
    }



    public Magasin getMagasin(Connection c) throws Exception {
        if (c ==null)
        {
            throw new Exception ("Connection non etablie");
        }
        Magasin magasin = new Magasin();
        magasin.setId(this.getIdMagasin());
        Magasin[] magasins = (Magasin[])CGenUtil.rechercher(magasin, null, null, c, " ");
        if (magasins.length > 0) {
            return magasins[0];
        }
        return null;
    }

    public InventaireFille generateInventaireFilleZero () throws Exception{
        InventaireFille invF=new InventaireFille();
        invF.setQuantite(0);
        invF.setQuantiteTheorique(0);
        invF.setIdInventaire(this.getId());
        invF.setExplication("inventaire 0");
        return invF;
    }

    public InventaireFille[] getInventaireFille(Connection c) throws Exception{
        InventaireFille search = new InventaireFille();
        search.setIdInventaire(this.getId());
        search.setNomTable("INVENTAIREFILLECOMPLET");
        return (InventaireFille[]) CGenUtil.rechercher(search,null,null,c,"");
    }

    public InventaireFilleComplet[] getInventaireFilleComplet(Connection c) throws Exception{
        InventaireFilleComplet search = new InventaireFilleComplet();
        search.setIdInventaire(this.getId());
        return (InventaireFilleComplet[]) CGenUtil.rechercher(search,null,null,c,"");
    }

    public void creerMouvementGenererPu(String u,Connection c) throws Exception{
        //Statement st =null;
        try {
        MvtStock m = new MvtStock();
        m.setDaty(daty);
        m.setDesignation("Mouvement pour ecart de l inventaire: "+this.getId());
        m.setIdMagasin(this.getIdMagasin());
        m.setIdTypeMvStock(ConstanteStation.TYPEMVTSTOCKINVENTAIRE);
        m.setIdobjet(this.getId());
        InventaireFille[] invf = getInventaireFille(c);
        List<MvtStockFille> mvtf = new ArrayList<>();
        for (int i = 0; i < invf.length; i++) {
            invf[i].setQuantiteTheorique(invf[i].getReste());
            invf[i].setMvtsrc(invf[i].getMvtentree());
            InventaireFille inv = (InventaireFille) invf[i];
            inv.setNomTable("INVENTAIREFILLE");
            double ecart = invf[i].getEcart();
            if (ecart!=0) {
                mvtf.addAll(invf[i].genererMvtStockFillesPu(c, m, ecart));
                //st=c.createStatement();
                inv.updateToTableWithHisto(u,c);
                //inv.updateToTableWithHistoBatch(u,st);
            }
        }
         //st.executeBatch();
        if (mvtf.size()==0) {
            return;
        }
        MvtStockFille[] fille = mvtf.toArray(new MvtStockFille[mvtf.size()]);
        m.setFille(fille);
        m.createObject(u, c);
        m.validerObject(u, c);
        }catch (Exception e){
            e.printStackTrace();
            throw e;
        }/*finally {
             if(st!=null) st.close();
        }*/
    }

    public void creerMouvementGenerer(String u,Connection c) throws Exception{
        //Statement st =null;
        try {
            MvtStock m = new MvtStock();
            m.setDaty(daty);
            m.setDesignation("Mouvement pour ecart de l inventaire: "+this.getId());
            m.setIdMagasin(this.getIdMagasin());
            m.setIdTypeMvStock(ConstanteStation.TYPEMVTSTOCKINVENTAIRE);
            m.setIdobjet(this.getId());
            InventaireFille[] invf = (InventaireFille[]) getFille("INVENTAIREFILLE",c,"");
            //EtatStockParEntree[] etatStockParEntrees = findEtatStockEntree(c);
            List<MvtStockFille> mvtf = new ArrayList<>();
            for (int i = 0; i < invf.length; i++) {
                //invf[i].findEtatStockEntree(etatStockParEntrees);
                //invf[i].setQuantiteTheorique(invf[i].getEtatStock().getReste());
                if (invf[i].getEcart()!=0) {
                    mvtf.addAll(invf[i].genererMvtStockFilles(m));
                    //st=c.createStatement();
                    //invf[i].updateToTableWithHisto(u,c);
                    //inv.updateToTableWithHistoBatch(u,st);
                }
            }
            //st.executeBatch();
            if (mvtf.size()==0) {
                return;
            }
            MvtStockFille[] fille = mvtf.toArray(new MvtStockFille[mvtf.size()]);
            m.setFille(fille);
            m.createObject(u, c);
            m.validerObject(u, c);
        }catch (Exception e){
            e.printStackTrace();
            throw e;
        }/*finally {
             if(st!=null) st.close();
        }*/
    }
    @Override
    public void controler(Connection c) throws Exception {
        super.controler(c);
        checkCategorieProduit(c);
    }

    @Override
    public void controlerUpdate(Connection c) throws Exception {
        super.controlerUpdate(c);
        checkCategorieProduit(c);
    }

    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {
        findEntreeFilles(c);
        return super.createObject(u, c);
    }
    @Override
    public Object validerObject(String u, Connection c) throws Exception {
        creerMouvementGenerer(u, c);
        InventaireFille[] listeInvFille=(InventaireFille[])this.getFille();
        MvtStockFille[] lfille=this.getMvtSourceFille(c,"");
        String[] attrEt={"mvtsrc"};
        for (MvtStockFille fille : lfille) {
            if(fille.getEntree()<=0) continue;
            fille.setDateInventaire(this.getDaty());
            String[] valEt={fille.getId()};
            InventaireFille[] invRecherche=(InventaireFille[]) AdminGen.find(listeInvFille,attrEt,valEt);
            if (invRecherche==null) {continue;}
            fille.setQteInventaire(invRecherche[0].getQuantite());
            fille.updateToTableWithHisto(u,c);
        }
        this.setHeure(Utilitaire.heureCouranteHMS());
        this.setDaty(Utilitaire.dateDuJourSql());
        super.validerObject(u, c);
        return this;
    }

    public MvtStockFille[] getMvtSourceFille(Connection c,String nt) throws Exception {
        InventaireFille[] listeFille=(InventaireFille[]) this.getFille();
        String idSource=Utilitaire.tabToString(listeFille,"mvtsrc","'",",");
        MvtStockFille crt=new MvtStockFille();
        if(nt!=null&&nt!=""){crt.setNomTable(nt);}
        MvtStockFille[] mvtSourceFille=(MvtStockFille[])  CGenUtil.rechercher(crt,null,null,c," and id in ("+idSource+")");
        return mvtSourceFille;
    }


    @Override
    public String getLiaisonFille(){
        return "idInventaire";
    }

    @Override
    public String getNomClasseFille(){
        return "inventaire.InventaireFille";
    }

    EtatStockLocalisation[] findEtatStockLocalisation(Connection c) throws Exception {
        EtatStockLocalisation stock = new EtatStockLocalisation();
        stock.setIdMagasin(this.getIdMagasin());
        InventaireFille[] invFille=(InventaireFille[]) this.getFille();
        String listeWhere=" and idProduit in ("+ Utilitaire.tabToString(invFille,"idProduit","'",",")+")";
        String requete = EtatStockLocalisation.getRequeteEtatStockLocalisation(Utilitaire.dateDuJour());
        return (EtatStockLocalisation[]) CGenUtil.rechercherReq(new EtatStockLocalisation(),requete,c,listeWhere);
    }

    public void findEtatLocalisationFilles(Connection c) throws Exception {
        InventaireFille[] filles = (InventaireFille[]) getFille();
        EtatStockLocalisation [] etatStocks = findEtatStockLocalisation(c);
        for (InventaireFille fille : filles) {
            String[] col = {"idProduit", "idMagasin", "compteLocalisation"};
            String[] val = {fille.getIdProduit(), this.getIdMagasin(), fille.getCompteLocalisation()};
            if (!Utilitaire.champNull(fille.getCompteLocalisation()).isEmpty()) {
                EtatStockLocalisation[] listeStock = (EtatStockLocalisation[]) AdminGen.find(etatStocks, col, val);
                if (listeStock != null && listeStock.length > 0) {
                    fille.setQuantiteTheorique(listeStock[0].getReste());
                    fille.setPu(listeStock[0].getPu());
                }
            } else {
                throw new Exception("champ localisation obligatoire. Produit : "+fille.getIdProduit());
            }
        }
    }

    EtatStock[] findEtatStockGlobale(Connection c) throws Exception
    {
        EtatStock crt=new EtatStock();
        crt.setIdMagasin(this.getIdMagasin());
        InventaireFille[] invFille=(InventaireFille[]) this.getFille();
        String listeWhere=" and idProduit in ("+ Utilitaire.tabToString(invFille,"idProduit","'",",")+")";
        EtatStock[] retour= (EtatStock[]) CGenUtil.rechercherReq(new EtatStock(),EtatStock.getReqEtatStock(Utilitaire.dateDuJour()),c,listeWhere);
        return retour;
    }



    public void findEntreeFilles(Connection c) throws Exception{
        InventaireFille[] filles = (InventaireFille[]) getFille();
        EtatStockParEntree [] etatStocks = findEtatStockEntree(c);
        EtatStockLocalisation[] etatStockLocalisations = findEtatStockLocalisation(c);
        Ingredients[] ingredients = (Ingredients[]) CGenUtil.rechercher(new Ingredients(),null,null,c,"");
        for (int i = 0; i < filles.length; i++) {
            String []col={"idProduit","idMagasin","compteLocalisation"};
            String[] val={filles[i].getIdProduit(),this.getIdMagasin(),filles[i].getCompteLocalisation()};
            Ingredients ing = filles[i].getIngredient(ingredients);
            //System.out.println("TAILLE DE ETAT "+listeStock.length+" id produit "+listeStock[0].getIdProduit()+" TYPE DE STOCK "+listeStock[0].getTypeStock());
            if((filles[i].getMvtsrc()==null||filles[i].getMvtsrc().compareToIgnoreCase("")==0))//&& listeStock!=null&&listeStock.length>0 &&listeStock[0].getTypeStock()!=null&&listeStock[0].getTypeStock().compareToIgnoreCase("CUMP")==0)
            {
                if(ing.getTypeStock().compareToIgnoreCase("CUMP")==0 && Utilitaire.champNull(filles[i].getCompteLocalisation()).isEmpty() ) {
                    throw new Exception("champ localisation obligatoire. Produit : "+filles[i].getIdProduit()+ " (CUMP)");
                }
                if(ing.getTypeStock().compareToIgnoreCase("FIFO")==0||ing.getTypeStock().compareToIgnoreCase("LIFO")==0
                    ||ing.getTypeStock().compareToIgnoreCase("LOT")==0) throw new Exception("Mouvement source obligatoire pour les produits en FIFO, LIFO ou par Lot");

                EtatStockLocalisation[] listeGlobale=(EtatStockLocalisation[])AdminGen.find(etatStockLocalisations,col,val);
                if(listeGlobale!=null&&listeGlobale.length>0) {
                    filles[i].setQuantiteTheorique(listeGlobale[0].getReste());
                    filles[i].setPu(listeGlobale[0].getPu());
                }
                //return;
            }
            if (filles[i].getMvtsrc()!=null && !filles[i].getMvtsrc().isEmpty()) {
                if(ing.getTypeStock().compareToIgnoreCase("CUMP")==0) {
                    throw new Exception("Impossible de renseigner une Source pour le produit " + ing.getLibelle() + " : il est g\u00E9r\u00E9 en CUMP.");
                }
                String []colEntree={"idProduit","idMagasin","id"};
                String[] valEntree={filles[i].getIdProduit(),this.getIdMagasin(),filles[i].getMvtsrc()};
                EtatStockParEntree[] listeStock=(EtatStockParEntree[])AdminGen.find(etatStocks,colEntree,valEntree);
                if(listeStock!=null&&listeStock.length>0) {
                    filles[i].setQuantiteTheorique(listeStock[0].getReste());
                    filles[i].setMvtsrc(listeStock[0].getId());
                    filles[i].setMvtentree(listeStock[0].getId());
                    filles[i].setCompteLocalisation(listeStock[0].getCompteLocalisation());
                    filles[i].setPu(listeStock[0].getPu());
                }
                //return;
            }
        }

    }

    EtatStockParEntree[] findEtatStockEntree(Connection c) throws Exception{
         SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        String daty = sdf.format(getDaty());
        EtatStockParEntree crt=new EtatStockParEntree();
        crt.setIdMagasin(this.getIdMagasin());
        InventaireFille[] invFille=(InventaireFille[]) this.getFille();
        String listeWhere=" and idProduit in ("+ Utilitaire.tabToString(invFille,"idProduit","'",",")+")";
        EtatStockParEntree[] retour= (EtatStockParEntree[]) CGenUtil.rechercherReq(crt,EtatStockParEntree.getRequeteEtatStockEntree(daty),c,listeWhere);
        return retour;
    }

    public String getIdCategorie() {
        return idCategorie;
    }

    public void setIdCategorie(String idCategorie) {
        this.idCategorie = idCategorie;
    }

    public Inventaire genererInventaire (EtatStockParEntree [] etatStocks) throws Exception{
        Inventaire inventaire = null;
        if (etatStocks.length>0) {
            inventaire = new Inventaire();
            inventaire.setIdMagasin(etatStocks[0].getIdMagasin());
            inventaire.setDaty(Utilitaire.dateDuJourSql());
            inventaire.setDesignation("Inventaire : "+inventaire.getDaty());
            List<InventaireFille> list = new ArrayList<>();
            for (EtatStockParEntree etatStock : etatStocks) {
                InventaireFille invF = new InventaireFille();
                invF.setIdProduit(etatStock.getIdProduit());
                invF.setQuantite(etatStock.getQuantite());
                invF.setQuantiteTheorique(etatStock.getReste());
                invF.setPu(etatStock.getPu());
                list.add(invF);
            }
            inventaire.setFille(list.toArray(new InventaireFille[]{}));
        }
        return inventaire;
    }

    public void annulerMvtStock(Connection c, String u) throws Exception{
        MvtStock m = new MvtStock();
        m.setIdTypeMvStock(ConstanteStation.TYPEMVTSTOCKINVENTAIRE);
        m.setIdMagasin(this.getIdMagasin());
        m.setDesignation(this.getId());
        MvtStock[] mvtStocks = (MvtStock[]) CGenUtil.rechercher(m, null, null, c, "");
        for(int i=0; i< mvtStocks.length; i++){
            mvtStocks[i].annuler(u, c);
        }
    }

    public void annulerVisaMvtStock(Connection c, String u) throws Exception{
        MvtStock m = new MvtStock();
        m.setIdTypeMvStock(ConstanteStation.TYPEMVTSTOCKINVENTAIRE);
        m.setIdMagasin(this.getIdMagasin());
        m.setDesignation(this.getId());
        MvtStock[] mvtStocks = (MvtStock[]) CGenUtil.rechercher(m, null, null, c, "");
        for(int i=0; i< mvtStocks.length; i++){
            mvtStocks[i].annulerVisa(u, c);
            mvtStocks[i].annuler(u, c);
        }
    }

    @Override
    public int annuler(String u, Connection c) throws Exception {
        annulerMvtStock(c, u);
        return super.annuler(u, c);
    }

    @Override
    public void annulerVisa(String u, Connection c) throws Exception {
        annulerVisaMvtStock(c, u);
        super.annulerVisa(u, c);
        super.annuler(u, c);
    }


    public void checkCategorieProduit(Connection c) throws Exception{
        CategorieIngredientMagasin magasin = new CategorieIngredientMagasin();
        magasin.setIdMagasin(this.getIdMagasin());
        CategorieIngredientMagasin[] magasins = (CategorieIngredientMagasin[]) CGenUtil.rechercher(magasin,null,null,"");
        if(magasins != null && magasins.length>0){

            InventaireFille[] Fille = (InventaireFille[]) this.getFille();
            if(Fille!=null && Fille.length>0){
                for(int i = 0 ;i<Fille.length;i++){
                    Ingredients ing = new Ingredients();
                    ing = (Ingredients) ing.getById(Fille[i].getIdProduit(),"AS_INGREDIENTS",c);
                    CategorieIngredientMagasin[] mags = (CategorieIngredientMagasin[]) AdminGen.find(magasins,new String[]{"idCategorieIngredient"},new String[]{ing.getCategorieIngredient()});
                    if(mags == null || (mags != null && mags.length ==0)  ){
                        throw new Exception("Cat\u00E9gorie  du produit " + ing.getId()  + "( " + ing.getLibelle()  + " ) n est pas prise en compte dans ce magasin " );
                    }
                }
            }
        }
    }


}
