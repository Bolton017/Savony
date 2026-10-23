package fabrication;

import bean.AdminGen;
import bean.CGenUtil;
import bean.ClassMere;
import chatbot.ClassIA;
import faturefournisseur.FactureFournisseurDetails;
import produits.Ingredients;
import produits.Recette;
import produits.RecetteLib;
import stock.MvtStockFille;
import utilitaire.UtilDB;
import utils.ConstanteProcess;
import utils.ConstanteSocobis;

import java.sql.Connection;

public class FabricationFille extends OfFille implements ClassIA {
    double pu;
    RecetteLib[] listeRecette;
    double prixRevient;
    double resteStock,fabEnCours,raf;
    int niveau;
    String idMachine;
    double nbPetris;

    public double getNbPetris() {
        return nbPetris;
    }

    public void setNbPetris(double nbPetris) {
        this.nbPetris = nbPetris;
    }

    public String getIdMachine() {
        return idMachine;
    }

    public void setIdMachine(String idMachine) {
        this.idMachine = idMachine;
    }

    public int getNiveau() {
        return niveau;
    }

    public void setNiveau(int niveau) {
        this.niveau = niveau;
    }

    public double getResteStock() {
        return resteStock;
    }

    public void setResteStock(double resteStock) {
        this.resteStock = resteStock;
    }

    public double getFabEnCours() {
        return fabEnCours;
    }

    public void setFabEnCours(double fabEnCours) {
        this.fabEnCours = fabEnCours;
    }

    public double getRaf() {
        return raf;
    }

    public void setRaf(double raf) {
        this.raf = raf;
    }
    public double getPrixRevient() {
        return prixRevient;
    }

    public void setPrixRevient(double prixRevient) {
        this.prixRevient = prixRevient;
    }

    public RecetteLib[] getListeRecette() {
        return listeRecette;
    }

    public void setListeRecette(RecetteLib[] listeRecette) {
        this.listeRecette = listeRecette;
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
    public FabricationFille() throws Exception {
        super.setNomTable("FABRICATIONFILLE");
        setLiaisonMere("idmere");
        setNomClasseMere("fabrication.Fabrication");
    }
    public void construirePK(Connection c) throws Exception {
        this.preparePk("FABF", "getSeqFabF");
        this.setId(makePK(c));
    }
    @Override
    public String getNomClasseMere()
    {
        return "fabrication.Fabrication";
    }

    @Override
    public String getLiaisonMere() {
        return "idMere";
    }

    @Override
    public String getUrlSaisie() {
        return "/savonnerie/pages/module.jsp?but=fabrication/fabrication-saisie.jsp&currentMenu=MENUDYN0304008";
    }

    @Override
    public void controler(Connection c) throws Exception {

        /*Fabrication mere = (Fabrication) this.findMere(null,c);

        OfFilleCpl [] ofFille = (OfFilleCpl[]) CGenUtil.rechercher(new OfFilleCpl(),null,null, " and IDMERE = '" +mere.getIdOf()+ "'");
        if(AdminGen.estDedans(ofFille,new String[]{"idIngredients"},new String[]{this.getIdIngredients()})) {
            OfFilleCpl of = (OfFilleCpl) AdminGen.findUnique(ofFille,new String[]{"idIngredients"},new String[]{this.getIdIngredients()});
            if(of.getQteReste()<this.getQte()){
                throw new Exception("La quantité de fabrication dépasse la quantite de l'ordre de Fabrication");
            }
        }
        else throw new Exception("Cette fabrication ne corréspond pas a l'ordre de Fabrication");*/
    }
    public MvtStockFille[] createMvtSockFilleSortie(Connection c) throws Exception{
        Ingredients ing = new Ingredients();
        ing.setId(this.getIdIngredients());
        Recette[] rct = ing.decomposerBase(c);
        MvtStockFille[] m=null;
        if (rct.length > 0) {
            m = new MvtStockFille[rct.length];
            for (int i = 0; i < rct.length; i++) {
                m[i] = new MvtStockFille();
                //m[i].setIdMvtStock(mere.getId());
                m[i].setIdProduit(rct[i].getIdingredients());
                m[i].setSortie(rct[i].getQuantite()*this.getQte());
                m[i].setPu(rct[i].getQteav());
            }
        }
        else {
            m=new MvtStockFille[1];
            m[0] = new MvtStockFille();
            ing=(Ingredients) new Ingredients().getById(ing.getId(),null,c);
            //m[i].setIdMvtStock(mere.getId());
            m[0].setIdProduit(ing.getId());
            m[0].setSortie(this.getQte());
            m[0].setPu(ing.getPu());
        }
        return m;
    }
    
    public OfFille genererOfFille(){
        OfFille ofFille = null;
        
        try {
            ofFille = new OfFille();
            ofFille.setIdIngredients(idIngredients);
            ofFille.setRemarque(remarque);
            ofFille.setLibelle(libelle);
            ofFille.setIdunite(idunite);
            ofFille.setLibIngredients(libIngredients);
            ofFille.setIdBcFille(idBcFille);
            ofFille.setQte(qte);
            ofFille.setDatyBesoin(datyBesoin);
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return ofFille;
    }

    public String getOperateur() {
        return operateur;
    }

    public void setOperateur(String operateur) {
        this.operateur = operateur;
    }

    public MvtStockFille genererMvtStockFille(String typemvtstock){
        MvtStockFille mvtStockFille = null;
        try {
            mvtStockFille = new MvtStockFille();
            mvtStockFille.setIdProduit(idIngredients);
            mvtStockFille.setDesignation(libIngredients);
            mvtStockFille.setPu(this.getPu());
            if (typemvtstock.equalsIgnoreCase("TPMVST000001")) mvtStockFille.setEntree(this.getQte());
            if (typemvtstock.equalsIgnoreCase("TPMVST000022")) mvtStockFille.setSortie(this.getQte());
        } catch (Exception e) {
            e.printStackTrace();
        }

        return mvtStockFille;
    }

    public double getNombrePetrisFABFILLE(String idFab, Connection c)throws Exception{
        boolean estOuvert = false;
        try {
            if(c==null){
                estOuvert = true;
                c = new UtilDB().GetConn();
            }
            FabricationFille map = new FabricationFille();
            map.setNomTable("FabricationFILLEPETRI");
            map.setIdMere(idFab);
            FabricationFille[] list = (FabricationFille[]) CGenUtil.rechercher(map, null, null,c, "");
            double rep = 0;
            for(int i=0;i<list.length;i++){
                rep += list[i].getQte();
            }
            return rep;
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception(e.getMessage());
        }finally {
            if(estOuvert && c!=null){
                c.close();
            }
        }
    }

}
