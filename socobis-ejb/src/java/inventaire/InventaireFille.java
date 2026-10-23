/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package inventaire;

import bean.AdminGen;
import bean.CGenUtil;
import bean.ClassFille;
import bean.ClassMAPTable;
import caisse.EtatCaisse;
import java.sql.Connection;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

import com.google.gson.Gson;
import faturefournisseur.Fournisseur;
import magasin.Magasin;
import produits.Ingredients;
import stock.EtatStock;
import stock.EtatStockParEntree;
import stock.MvtStock;
import stock.MvtStockFille;
import utilitaire.Utilitaire;
import utils.ConstanteStation;

public class InventaireFille extends ClassFille {

    private String id, idInventaire, idProduit, explication,idJauge, mvtsrc,idFournisseur , typeStock,compteLocalisation;
    private Date daty;
    private EtatStockParEntree etatStock;
    private double quantiteTheorique, quantite, pu;

    public String getCompteLocalisation() {
        return compteLocalisation;
    }

    public void setCompteLocalisation(String compteLocalisation) throws Exception{
        this.compteLocalisation = compteLocalisation;
    }

    public String getTypeStock() {
        return typeStock;
    }

    public void setTypeStock(String typeStock) {
        this.typeStock = typeStock;
    }
    
    public String getMvtsrc() {
        return mvtsrc;
    }

    public void setMvtsrc(String mvtsrc) {
        this.mvtsrc = mvtsrc;
    }

    public double getPu() {
        return pu;
    }

    public void setPu(double pu) throws Exception{
        if (this.getMode().equals("modif") && pu < 0) {
            throw new Exception("Pu ne peut pas &ecirc;tre inf&eacute;rieur &agrave; 0");
        }
        this.pu = pu;
    }

    public InventaireFille() throws Exception {
        this.setNomTable("InventaireFille");
        this.setLiaisonMere("idInventaire");
        this.setNomClasseMere("inventaire.Inventaire");
    }

    public String getLiaisonMere() {
        return "idInventaire";
    }
    public String getNomClasseMere() {
        return "inventaire.Inventaire";
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdInventaire() {
        return idInventaire;
    }

    public void setIdInventaire(String idInventaire) {
        this.idInventaire = idInventaire;
    }

    public String getIdProduit() {
        return idProduit;
    }

    public void setIdProduit(String idProduit) throws Exception{
        if(getMode().compareTo("modif")==0 && (idProduit==null || idProduit.isEmpty()==true))throw new Exception("Veuillez entrer un produit");
        this.idProduit = idProduit;
    }

    public String getExplication() {
        return explication;
    }

    public void setExplication(String explication) {
        this.explication = explication;
    }

    public double getQuantiteTheorique() {
        return quantiteTheorique;
    }

    public void setQuantiteTheorique(double quantiteTheorique) throws Exception{
        if(getMode().compareTo("modif")==0 && quantite<0) throw new Exception("Quantit&eacute; invalide");
        this.quantiteTheorique = quantiteTheorique;
    }

    public double getQuantite() {
        return quantite;
    }

    public void setQuantite(double quantite) throws Exception{
        if(getMode().compareTo("modif")==0 && quantite<0) throw new Exception("Quantit&eacute; invalide");
        this.quantite = quantite;
    }

    public String getIdFournisseur() {
        return idFournisseur;
    }

    public void setIdFournisseur(String idFournisseur) {
        this.idFournisseur = idFournisseur;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("IVTFI", "GETSEQinventairefille");
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
        super.setLiaisonMere("idInventaire");
    }

    public String getIdJauge() {
        return idJauge;
    }

    public void setIdJauge(String idJauge) {
        this.idJauge = idJauge;
    }

    public EtatStockParEntree getEtatStock() {
        return etatStock;
    }

    public void setEtatStock(EtatStockParEntree etatStock) {
        this.etatStock = etatStock;
    }

    @Override
    public void controlerUpdate(Connection c) throws Exception {
        super.setNomClasseMere("inventaire.Inventaire");
//        super.controlerUpdate(c);
    }

    public Inventaire geInventaire(Connection c) throws Exception {
        if (c == null) {
            throw new Exception("Connection non etablie");
        }
        Inventaire inventaire = new Inventaire();
        inventaire.setId(this.getIdInventaire());
        Inventaire[] inventaires = (Inventaire[]) CGenUtil.rechercher(inventaire, null, null, c, " ");
        if (inventaires.length > 0) {
            return inventaires[0];
        }
        return null;
    }

    protected void  controlerDuplicationInventaire(Connection c) throws Exception {
        if (c == null) {
            throw new Exception("Connection non etablie");
        }
        Inventaire inv=geInventaire(c);
        InventaireFilleCpl invf = new InventaireFilleCpl();
        invf.setNomTable("INVENTAIRE_FILLE_CPL_VALIDE");
        invf.setIdProduit(getIdProduit());
        invf.setMvtsrc(getMvtsrc());
        //invf.setIdMagasin(inv.getIdMagasin());
        InventaireFilleCpl[] invfcpl = (InventaireFilleCpl[]) CGenUtil.rechercher(invf, null, null, c, " AND daty = TO_DATE('"+inv.getDaty()+"', 'YYYY-MM-DD') ");
        if (invfcpl.length > 0) {
            throw new Exception("Un inventaire pour le produit "+invfcpl[0].getIdproduitlib()+" a d\u00E9j\u00E0 \u00E9t\u00E9 valid\u00E9e pour la m\u00EAme date");
        }
    }

    protected void  controlerMagasTypeReservoir(Connection c) throws Exception {
        if (c == null) {
            throw new Exception("Connection non etablie");
        }
        Inventaire inv=geInventaire(c);
        Magasin magasin = inv.getMagasin(c);
        if (magasin.getIdTypeMagasin().compareToIgnoreCase(ConstanteStation.idTypeReservoir) == 0) {
            if (magasin.getIdProduit().compareToIgnoreCase(this.getIdProduit()) != 0) {
                throw new Exception("Un ou plusieurs produits filles ne correspondent pas au produit du magasin choisi");
            }
        }
    }

    public void checkEtatEntree(Connection c) throws Exception {
        EtatStockParEntree e = new EtatStockParEntree();
        e.setIdProduit(this.getIdProduit());
        Inventaire inv=geInventaire(c);
        e.setIdMagasin(inv.getIdMagasin());
        EtatStockParEntree[] etatstock = (EtatStockParEntree[]) CGenUtil.rechercher(e,null,null,c," and pu="+this.getPu());
        if (etatstock.length == 0) {
            throw new Exception("Le produit "+this.getIdProduit()+" avec le prix unitaire "+this.getPu()+" n'a pas d'entr\u00E9e en stock. Veuillez v\u00E9rifier.");
        }
    }

    @Override
    public void controler(Connection c) throws Exception {
        //this.checkEtatEntree(c);
        this.controlerDuplicationInventaire(c);
        // this.modifQuantiteTheorique(c);
        super.controler(c);
    }

    protected void calculateQuantiteTheorique(Connection c) throws Exception{
        Inventaire inv=geInventaire(c);
        Date daty=inv.getDaty();
        EtatStock et=new EtatStock();
        Inventaire[] mere=(Inventaire[])CGenUtil.rechercher(new Inventaire(), null, null, c, " and id ='"+idInventaire+"' ");
        if (mere.length!=1) {
            throw new Exception("Inventaire introuvable");
        }
        String query=et.generateQueryCore(daty, daty)+" and inv.idProduit='"+this.idProduit+"' and inv.idmagasin='"+mere[0].getIdMagasin()+"' ";
        // System.out.println("-+ query= "+query);
        EtatStock[] listetat=(EtatStock[]) CGenUtil.rechercher(et, query, c);
        double mt=0;
        if (listetat.length==1) {
            mt=listetat[0].getReste();
        }
        this.setQuantiteTheorique(mt);
    }

    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {
        return super.createObject(u, c);
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
    public void modifQuantiteTheorique(Connection c) throws Exception{
        EtatStock e = new EtatStock();
        Inventaire mere = (Inventaire) this.findMere("INVENTAIRE", c);
        e.setNomTable("V_ETATSTOCK_PU");
        e.setId(this.getIdProduit());
        e.setIdMagasin(mere.getIdMagasin());
        EtatStock[] etatstock = (EtatStock[]) CGenUtil.rechercher(e,null,null," and pu="+this.getPu());
        if (etatstock==null || etatstock.length==0) {
            this.setQuantiteTheorique(0);
        }else{
            this.setQuantiteTheorique(etatstock[0].getReste());
            this.setMvtsrc(etatstock[0].getMvtsrc());
        }
    }

    public double getEcart() throws Exception{
        double ecart = this.getQuantite() - this.getQuantiteTheorique();
        return ecart;
    }

    public MvtStockFille getMvtSource(Connection c, String nt) throws Exception{
        MvtStockFille crt=new MvtStockFille();
        crt.setId(this.getMvtsrc());
        if(nt!=null&&nt.equals("")==false)
        {
            crt.setNomTable(nt);
        }
        MvtStockFille[] tab=(MvtStockFille[]) CGenUtil.rechercher(crt,null,null,c,"");
        if(tab!=null&&tab.length>0)return tab[0];
        return null;
    }


    public void findEtatStockEntree(EtatStockParEntree[] etatStocks) throws Exception {
        String[] col = new String[]{"id"};
        String[] val = new String[]{this.getMvtsrc()};
        String exception ="Le produit "+this.getIdProduit()+" avec le mouvement source "+this.getMvtsrc()+" n'a pas d'entr\u00E9e en stock. Veuillez v\u00E9rifier.";

        if (getMvtsrc()==null || getMvtsrc().isEmpty()){

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

    public List<MvtStockFille> genererMvtStockFilles(MvtStock mere) throws Exception{
        List<MvtStockFille> retour = new ArrayList<>();

        if (getEcart()>0) {

            MvtStockFille mvtStockFille = new MvtStockFille();
            mvtStockFille.setIdMvtStock(mere.getId());
            mvtStockFille.setIdProduit(this.getIdProduit());
            mvtStockFille.setEntree(getEcart());
            mvtStockFille.setSortie(0);
            mvtStockFille.setDesignation(this.getExplication());
            mvtStockFille.setPu(this.getPu());
            mvtStockFille.setReste(0);
            mvtStockFille.setCompteLocalisation(this.getCompteLocalisation());
            mvtStockFille.setIdinventairefille(getId());
            retour.add(mvtStockFille);
        }else if (getEcart()<0) {
            double qteASortir = Math.abs(getEcart());
//            System.out.println("Ecart "+qteASortir);
            MvtStockFille mvtStockFille = new MvtStockFille();
            mvtStockFille.setIdMvtStock(mere.getId());
            mvtStockFille.setIdProduit(this.getIdProduit());
            mvtStockFille.setSortie(qteASortir);
            mvtStockFille.setEntree(0);
            mvtStockFille.setDesignation(this.getExplication());
            mvtStockFille.setPu(this.getPu());
            mvtStockFille.setReste(0);
            mvtStockFille.setCompteLocalisation(this.getCompteLocalisation());
            mvtStockFille.setIdinventairefille(getId());
            retour.add(mvtStockFille);
        }

        return retour;
    }
    public List<MvtStockFille> genererMvtStockFillesPu(Connection c, MvtStock mere,double ecart) throws Exception{
        List<MvtStockFille> retour = new ArrayList<>();
        EtatStockParEntree ref = new EtatStockParEntree();
        ref.setIdProduit(this.getIdProduit());
        ref.setIdMagasin(mere.getIdMagasin());
        EtatStockParEntree [] etatStocks = (EtatStockParEntree[]) CGenUtil.rechercher(ref,null,null,c," and PU="+this.getPu()+" ORDER BY DATY ASC");
        if (ecart>0) {
            MvtStockFille mvtStockFille = new MvtStockFille();
            mvtStockFille.setIdMvtStock(mere.getId());
            mvtStockFille.setIdProduit(this.getIdProduit());
            mvtStockFille.setEntree(ecart);
            mvtStockFille.setSortie(0);
            mvtStockFille.setDesignation(this.getExplication());
            mvtStockFille.setPu(this.getPu());
            mvtStockFille.setReste(0);
            retour.add(mvtStockFille);
            // manampy id mvtsrc izay id max
        }else if (ecart<0) {
            double qteASortir = Math.abs(ecart);
            System.out.println("Ecart "+qteASortir);
            for (int i = 0; i < etatStocks.length && qteASortir>0; i++) {
                MvtStockFille mvtStockFille = new MvtStockFille();
                mvtStockFille.setIdMvtStock(mere.getId());
                mvtStockFille.setIdProduit(this.getIdProduit());
                if (qteASortir<=etatStocks[i].getReste()){
                    mvtStockFille.setSortie(qteASortir);
                    qteASortir = 0;
                }else {
                    mvtStockFille.setSortie(etatStocks[i].getReste());
                }
                System.out.println(etatStocks[i].getId()+" Sortie "+mvtStockFille.getSortie());
                mvtStockFille.setEntree(0);
                mvtStockFille.setMvtSrc(etatStocks[i].getId());
                mvtStockFille.setDesignation(this.getExplication());
                mvtStockFille.setPu(etatStocks[i].getPu());
                mvtStockFille.setReste(0);
                retour.add(mvtStockFille);
                qteASortir -= etatStocks[i].getReste();
            }
            if (qteASortir>0){
                MvtStockFille mvtStockFille = new MvtStockFille();
                mvtStockFille.setIdMvtStock(mere.getId());
                mvtStockFille.setIdProduit(this.getIdProduit());
                mvtStockFille.setSortie(qteASortir);
                System.out.println(" Sortie "+mvtStockFille.getSortie());

                mvtStockFille.setEntree(0);
                mvtStockFille.setMvtSrc(this.getMvtsrc());
                mvtStockFille.setDesignation(this.getExplication());
                mvtStockFille.setPu(this.getPu());
                mvtStockFille.setReste(0);
                retour.add(mvtStockFille);
            }
        }

        return retour;
    }

    public MvtStockFille genererMvtStockFille(Connection c, MvtStock mere,double ecart) throws Exception{
        MvtStockFille retour = new MvtStockFille();
        retour.setIdMvtStock(mere.getId());
        retour.setIdProduit(this.getIdProduit());
        if (ecart>0) {
            retour.setEntree(ecart);
            retour.setSortie(0);
            // manampy id mvtsrc izay id max
        }else if (ecart<0) {
            retour.setSortie(Math.abs(ecart));
            retour.setEntree(0);
            retour.setMvtSrc(this.getMvtsrc());
        }
        retour.setDesignation(this.getExplication());
        retour.setPu(this.getPu());
        retour.setReste(0);
        return retour;
    }
    private String mvtentree;
    private double reste;
    public String getMvtentree() {
        return mvtentree;
    }

    public void setMvtentree(String mvtentree) {
        this.mvtentree = mvtentree;
    }

    public double getReste() {
        return reste;
    }

    public void setReste(double reste) {
        this.reste = reste;
    }

    public int updateToTable(String refUser,Connection c) throws Exception {
        int inv = super.updateToTableWithHisto(refUser);
        return inv;
    }

    @Override
    public int updateObject(String u, Connection c) throws Exception {
        int i =  updateToTable(u, c);
        this.setId(this.getIdInventaire());
        return i;
    }

    public Ingredients getIngredient(Ingredients[] ingredients) throws Exception {
        Ingredients ing = (Ingredients) AdminGen.findUnique(ingredients,new String[]{"id"},new String[]{this.getIdProduit()});
        if (ing == null) {
            throw new Exception("Ingredients avec id : " + this.getIdProduit() + " introuvable");
        }
        return ing;
    }


}
