package fabrication;

import annexe.Poste;
import bean.AdminGen;
import bean.ClassMere;
import demande.DemandeTransfert;
import demande.DemandeTransfertFille;
import fabrication.equipe.EquipeEmpCpl;
import magasin.Magasin;
import pertegain.Tiers;
import produits.Ingredients;
import produits.Recette;
import produits.RecetteFab;
import produits.RecetteLib;
import rh.QualificationPaie;
import stock.MvtStockEntreeAvecReste;
import stock.TransfertStockDetails;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;
import utils.ConstanteProcess;
import bean.CGenUtil;

import java.io.EOFException;
import java.sql.Connection;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Vector;

import stock.MvtStock;
import stock.MvtStockFille;
import utils.ConstanteSocobis;
import utils.ConstanteStation;
import fabrication.*;
import bean.ClassMAPTable;
import historique.MapUtilisateur;

public class Fabrication extends Of {

    String idOf;
    String idOffille;
    int niveau, estUnProjet, lanceur;
    String fabricationPrec;
    String fabricationSuiv;
    String equipe;
    double nbPetris;

    public int getEstUnProjet() {
        return estUnProjet;
    }

    public void setEstUnProjet(int estUnProjet) {
        this.estUnProjet = estUnProjet;
    }

    public int getLanceur() {
        return lanceur;
    }

    public void setLanceur(int lanceur) {
        this.lanceur = lanceur;
    }

    public double getNbPetris() {
        return nbPetris;
    }

    public void setNbPetris(double nbPetris) {
        this.nbPetris = nbPetris;
    }

    public String getFabricationSuiv() {
        return fabricationSuiv;
    }

    public void setFabricationSuiv(String fabricationSuiv) {
        this.fabricationSuiv = fabricationSuiv;
    }

    public int getNiveau() {
        return niveau;
    }

    public void setNiveau(int niveau) {
        this.niveau = niveau;
    }
      public String getEquipe() {
        return equipe;
    }

    public void setEquipe(String equipe) {
        this.equipe = equipe;
    }

    public String getFabricationPrec() {
        return fabricationPrec;
    }

    public void setFabricationPrec(String fabricationPrec) {
        this.fabricationPrec = fabricationPrec;
    }

    public Fabrication() throws Exception {
        super.setNomTable("FABRICATION");
        setLiaisonFille("idmere");
        setNomClasseFille("fabrication.FabricationFille");
    }
    public String[] getValMotCles() {
        String[] motCles={"id","libelle", "remarque"};
        return motCles;
    }
    public String getIdOffille() {
        return idOffille;
    }

    public void setIdOffille(String idOffille) {
        this.idOffille = idOffille;
    }

    public String getIdOf() {
        return idOf;
    }

    public void setIdOf(String idOf) {
        this.idOf = idOf;
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        if(this.estUnProjet==1){
            this.preparePk("PRJ", "getSeqPrj");
        }else{
            this.preparePk("FAB", "getSeqFab");
        }
        this.setId(makePK(c));
    }

    public  String getNomClasseFille()
    {
        return "fabrication.FabricationFille";
    }

    @Override
    public String getLiaisonFille() {
        return "idMere";
    }

    public Of getOf(String nt, Connection c) throws Exception{
        return null;
    }

    public OfFille getOfabfille(String nt, Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
            }
            OfFille of = new OfFille();
            of.setNomTable(nt);
            of.setId(this.getIdOffille());
            OfFille[] ofs = (OfFille[]) CGenUtil.rechercher(of, null, null, c, " ");
            if (ofs.length > 0) {
                return ofs[0];
            }
            return null;
        } catch (Exception e) {
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }
    public void annulerVisa(String u,Connection c) throws Exception {
        int ouvert = 0;
        try{
            if(c == null){
                c=new UtilDB().GetConn();
                c.setAutoCommit(false);
                ouvert = 1;
            }
            RecetteFab fab = new RecetteFab();
            fab.setNomTable("AS_RECETTEFABRICATION");
            fab.deleteToTable(" IDPRODUITS='"+this.getId()+"'",c);
            super.annulerVisa(u,c);
            if(c!=null && ouvert ==1){
                c.commit();
            }
        }
        catch(Exception e){
            if(c!=null && ouvert ==1){
                c.rollback();
            }
            e.printStackTrace();
            throw e;
        }
        finally{
            if(c!=null && ouvert ==1){
                c.close();
            }
        }
    }

    @Override
    public void controler(Connection c) throws Exception {
        super.controler(c);
        OfFilleCpl filles = new OfFilleCpl();
        filles.setNomTable("OfFilleResteLib");
        /*FabricationFille [] ofFilleNew  = (FabricationFille[])this.getFille(null,c,"");
        OfFilleCpl [] ofFille = (OfFilleCpl[]) CGenUtil.rechercher(filles,null,null, " and IDMERE = '" +getIdOf()+ "'");
        
        if(ofFilleNew.length!=ofFille.length){
            throw new EOFException("On ne peut pa ajouter ou supprimer une ingredient si c'est une ordre de fabrication");
        }
        for(int i=0;i<ofFille.length;i++){
            if(ofFille[i].getQteReste()<ofFilleNew[i].getQte() || ofFilleNew[i].getQte()<=0){
                throw new EOFException("On ne peut pas augmenter la qunatité de l'engredient si c'est une ordre de fabrication");
            }
        }*/
    }


    @Override
    public void controlerUpdate(Connection c) throws Exception {
        
    }
    public void modifPuFille(String user,Connection c ) throws Exception {
        FabricationFille[] fille=(FabricationFille[]) this.getFille("fabricationFillePU",c,"");
        this.setFille(fille);
        calculerRevient(c);
        for(FabricationFille f:fille)
        {
            f.setNomTable("FabricationFille");
            f.setPu(f.getPuRevient());
            f.updateToTableWithHisto(user,c);
        }
    }
    public MvtStock[] getMvtStock(String nt,Connection c) throws Exception {
        MvtStock stock = new MvtStock();
        String nomTable="MVTSTOCK";
        if(nt!=null&&nt.compareToIgnoreCase("")!=0)nomTable=nt;
        stock.setNomTable(nomTable);
        stock.setIdobjet(this.getId());
        return (MvtStock[]) CGenUtil.rechercher(stock, null, null, c, " ");
    }
    public MvtStockFille[] getMvtStockFille(String nt,Connection c) throws Exception {
        MvtStockFille stock = new MvtStockFille();
        String nomTable="MvtStockFilleFab";
        if(nt!=null&&nt.compareToIgnoreCase("")!=0)nomTable=nt;
        stock.setNomTable(nomTable);
        stock.setIdFab(this.getId());
        return (MvtStockFille[]) CGenUtil.rechercher(stock, null, null, c, " ");
    }

    @Override
    public Object validerObject(String u, Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
            }
            // sortie 
            // entree


            this.modifPuFille(u,c);
            this.decomposerInserer(u,c);
            super.validerObject(u, c);

            c.commit();
            return this;

        } catch (Exception e) {
            if (c != null) {
                c.rollback();
            }
            e.printStackTrace();
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }

    public void sortieStock(){

    }

    public void entreeStock(){
        
    }

    public Recette[] decomposer(Connection c)throws Exception
    {
        Ingredients ing = new Ingredients();
        ing.setId(this.getId());
        return ing.decomposerBase("as_recetteFab", c);
    }
    public List<RecetteLib> decomposerPremier(String nt,Connection c) throws Exception
    {
        FabricationFille[] listeFille=(FabricationFille[])this.getFille(null,c,"");
        Recette[][] lr = new Recette[listeFille.length][];
        double[] listeRev=new double[listeFille.length];
        List<RecetteLib> finale = new ArrayList();
        for(int i=0;i<listeFille.length;i++)
        {
            Ingredients ing = new Ingredients();
            ing.setId(listeFille[i].getIdIngredients());
            listeFille[i].setListeRecette(ing.getRecetteavecPu(null,c));
            for(RecetteLib rec:listeFille[i].getListeRecette())
            {
                rec.setQteav(rec.getQteav()/rec.getQuantite());
                rec.setQuantite(rec.getQuantite()*listeFille[i].getQte());
            }
            finale.addAll(Arrays.asList(listeFille[i].getListeRecette()));
        }
        return finale;

    }
    public void decomposerInserer(String u,Connection c)throws Exception{
        Statement st = null;
        try {
            //Recette[] lc = this.decomposer(c);
            List<RecetteLib> listerc=this.decomposerPremier(u,c);
            //if(lc!=null)lc[0].setIdproduits(this.getId());
            for (int i = 0; i < listerc.size(); i++) {
                RecetteFab rf=new RecetteFab();
                rf.setIdingredients(listerc.get(i).getIdingredients());
                rf.setQteav(listerc.get(i).getQteav());
                rf.setQuantite(listerc.get(i).getQuantite());
                rf.setUnite(listerc.get(i).getUnite());
                rf.setIdproduits(this.getId());
                rf.setNomTable("as_recettefabrication");
                //st = c.createStatement();
                rf.createObject(u, c);
            }
            //st.executeBatch();
        }
        catch (Exception e) {
            c.rollback();
            throw e;
        }
        finally {
            if(st!=null)st.close();
        }
    }

    public Object entamerObject(String u, Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
            }
            this.setMode("modif");
            //Mettre controle si besoin
            this.setEtat(ConstanteProcess.entame);
            this.updateToTableWithHisto(u, c);
            return this;
        } catch (Exception e) {
            if (c != null) {
                c.rollback();
            }
            e.printStackTrace();
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }
    public Object bloquerObject(String u, Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
            }
            this.setMode("modif");
            //Mettre controle si besoin
            this.setEtat(ConstanteProcess.bloque);
            this.updateToTableWithHisto(u, c);
            return this;
        } catch (Exception e) {
            if (c != null) {
                c.rollback();
            }
            e.printStackTrace();
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }
    public Object terminerObject(String u, Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
            }
            this.setMode("modif");
            this.setEtat(ConstanteProcess.termine);
            this.updateToTableWithHisto(u, c);
            return this;
        } catch (Exception e) {
            if (c != null) {
                c.rollback();
            }
            e.printStackTrace();
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }

    public FabricationFilleCpl[] getFabricationFilleCpl (Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
            }
            FabricationFilleCpl ff = new FabricationFilleCpl();
            ff.setNomTable("FABRICATIONFILLECPL");
            ff.setIdMere(this.getId());
            FabricationFilleCpl[] ffs = (FabricationFilleCpl[]) CGenUtil.rechercher(ff, null, null, c, " ");
            if (ffs.length > 0) {
                return ffs;
            }
            return null;
        } catch (Exception e) {
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }
     public FabricationFille[] getFabricationFille (Connection c) throws Exception {
        if(getFille()!=null)return (FabricationFille[]) getFille();
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
            }
            FabricationFille ff = new FabricationFille();
            ff.setIdMere(this.getId());
            FabricationFille[] ffs = (FabricationFille[]) CGenUtil.rechercher(ff, null, null, c, " ");
            if (ffs.length > 0) {
                return ffs;
            }
            return null;
        } catch (Exception e) {
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }
    protected MvtStock createMvtStock(String action,String u,Connection c) throws Exception{
        MvtStock md=new MvtStock();
        md.setDaty(this.getDaty());
        md.setIdMagasin(this.getCible());
        md.setIdPoint(this.getCible());
        if (action.compareToIgnoreCase("entree")==0) {   
            md.setDesignation("Entree de stock relatif : fabrication de : "+ this.getId());
            md.setIdTypeMvStock(ConstanteStation.TYPEMVTSTOCKENTREE);
        }
         if (action.compareToIgnoreCase("sortie")==0) {
            md.setDesignation("Sortie de stock relatif : fabrication de : "+ this.getId());
            md.setIdTypeMvStock(ConstanteStation.TYPEMVTSTOCKSORTIE);
        }
        md.setIdobjet(this.id);
        md.createObject(u, c);
        md.validerObject(u, c);
        return md;
    }
    protected MvtStockFille[] createMvtSockFilleSortie(String u,MvtStock mere,Connection c) throws Exception{
        FabricationFille[] listeFille=this.getFabricationFille(c);
        
        for(FabricationFille fille:listeFille){
            MvtStockFille[] m = fille.createMvtSockFilleSortie(c);
            for (int i = 0; i < m.length; i++) {
                //m[i] = new MvtStockFille();
                m[i].setIdMvtStock(mere.getId());
                m[i].createObject(u,c);
            }
        }
        return null;
    }

    protected MvtStockFille[] createMvtSockFilleEntree(MvtStock mere,Connection c) throws Exception{
        FabricationFille[] ff = this.getFabricationFille(c);
        MvtStockFille[] m = new MvtStockFille[ff.length];
        for (int i = 0; i < ff.length; i++) {
           m[i] = new MvtStockFille();
           m[i].setIdMvtStock(mere.getId());
           m[i].setIdProduit(ff[i].getIdIngredients());
           m[i].setEntree(ff[i].getQte());
           m[i].setPu(ff[i].getPu());
        }
        return m;
    }
    protected void createSortieStock(String u,Connection c) throws Exception{
        MvtStock m=this.createMvtStock("sortie", u ,c);
        this.createMvtSockFilleSortie(u,m, c);
    }
    protected void createEntreeStock(String u,Connection c) throws Exception{
        MvtStock m=this.createMvtStock("entree", u, c);
        MvtStockFille[] filles = this.createMvtSockFilleEntree(m, c);
        for(int i=0;i<filles.length;i++){
            filles[i].createObject(u, c);
        } 
    }
    
    protected Of genererOf(){
        Of of = null;
        
        try {
            of = new Of();
            of.setLancePar(lancePar);
            of.setCible(cible);
            of.setRemarque(remarque);
            of.setLibelle(libelle);
            of.setIdBc(idBc);
            of.setBesoin(besoin);
            of.setDaty(daty);
            
            FabricationFille[] fabFilles = getFabricationFille(null);
            OfFille[] ofFilles =  new OfFille[fabFilles.length];
            for (int i = 0; i < ofFilles.length; i++) {
                ofFilles[i] = fabFilles[i].genererOfFille();
            }
            of.setOfFilles(ofFilles);
        } catch (Exception e) {
        }
        
        return of;
    }
    
    public MvtStock genererMvtStock(String typemvtstock, Connection c) throws Exception {
        String id = this.getId();
        try {
            c = new UtilDB().GetConn();
            Fabrication enbase = (Fabrication) this.getById(id, this.getNomTable(), c);
            FabricationFilleCpl[] details = enbase.getFabricationFilleCpl(c);
            enbase.setFille(details);
            if(details.length==0){return null;}
            MvtStock mvt = new MvtStock();
            mvt.setDesignation("Mouvement de stock de l'ordre de fabrication : " + this.getId());
            mvt.setIdobjet(this.getId());
            mvt.setIdTypeMvStock(typemvtstock);
            mvt.setIdMagasin(enbase.getCible());
            mvt.setIdCategorieStock(ConstanteSocobis.ID_CATEGORIESTOCK_NORMAL);
            mvt.setHeure(Utilitaire.heureCouranteHMS());
            if(typemvtstock.equalsIgnoreCase(ConstanteStation.TYPEMVTSTOCKENTREE))
            {
                MvtStockFille[] mvtstockdetails = new MvtStockFille[details.length];
                for (int i = 0; i < details.length; i++)
                {
                    mvtstockdetails[i] = new MvtStockFille();
                    details[i].setLibIngredients(details[i].getIdingredientsLib());
                    mvtstockdetails[i] = details[i].genererMvtStockFille(typemvtstock);
                }
                mvt.setFille(mvtstockdetails);
            }
            else {
                Recette crt=new Recette();
                crt.setNomTable("as_recetteFabLibSt");
                crt.setIdproduits(this.getId());
                Recette[] recettes = (Recette[])CGenUtil.rechercher(crt,null,null,c,"");
                FabricationFilleCpl[] detailsNouveau = new FabricationFilleCpl[recettes.length];
                List<MvtStockFille> mvtDetails = new ArrayList<MvtStockFille>();

                MvtStockEntreeAvecReste cibleCtr = new MvtStockEntreeAvecReste();
                cibleCtr.setNomTable("V_ETATSTOCK_ENTREE");
                cibleCtr.setIdMagasin(enbase.getCible());
                MvtStockEntreeAvecReste[] etatStock = (MvtStockEntreeAvecReste[])CGenUtil.rechercher(cibleCtr, null, null, c, "order by daty desc");

                Vector<MvtStockEntreeAvecReste> vect = new Vector<MvtStockEntreeAvecReste>(Arrays.asList(etatStock));

                for (int i = 0; i < recettes.length; i++) {
                    detailsNouveau[i] = new FabricationFilleCpl();
                    detailsNouveau[i].setIdIngredients(recettes[i].getIdingredients());
                    detailsNouveau[i].setLibIngredients(recettes[i].getLibIngredients());
                    if(recettes[i].getReste()>0)detailsNouveau[i].setQte(recettes[i].getReste());
                    detailsNouveau[i].setPu(recettes[i].getQteav());
                    if (recettes[i].getTypeStock() != null && recettes[i].getTypeStock().compareToIgnoreCase("") != 0&&detailsNouveau[i].getQte()>0) {
                        MvtStockFille mvtFille = new MvtStockFille();
                        double qteASortir = detailsNouveau[i].getQte();
                        while(qteASortir > 0){
                            MvtStockEntreeAvecReste stock = (MvtStockEntreeAvecReste) AdminGen.findUnique(vect,new String[]{"idProduit"},new String[]{detailsNouveau[i].getIdIngredients()});
                            if(stock != null && stock.getReste() > 0 ){
                                double qteTransferee = qteASortir;
                                qteTransferee = Math.min(qteASortir, stock.getReste());
                                stock.setReste(stock.getReste() - qteTransferee);
                                detailsNouveau[i].setQte(qteTransferee);
                                qteASortir -= qteTransferee;
                                mvtFille = detailsNouveau[i].genererMvtStockFille(typemvtstock);
                                mvtFille.setMvtSrc(stock.getId());
                                mvtFille.setPu(stock.getPu());
                                mvtDetails.add(mvtFille);
                                vect.remove(stock);
                            }else {
                                detailsNouveau[i].setQte(qteASortir);
                                mvtFille = detailsNouveau[i].genererMvtStockFille(typemvtstock);
                                mvtDetails.add(mvtFille);
                                break;
                            }


                        }
                    }
                }

                if (mvtDetails.isEmpty()) {
                    throw new Exception("Aucun ingr\\u00E9dient \\u00E0 sortir du stock pour cet ordre de fabrication");
                }
                mvt.ajouterFille(mvtDetails.toArray(new MvtStockFille[0]));

            }
            return mvt;
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception("Mouvement stock non generer "+e.getMessage());
        } finally {
            if (c != null) {
                c.close();
            }
        }
    }

    public MvtStock genererMvtStock(String cible, String typemvtstock, Connection c) throws Exception {
        String id = this.getId();
        boolean estOuvert=false;
        try {
            if(c==null) {
                c = new UtilDB().GetConn();
                estOuvert=true;
            }
            Fabrication enbase = (Fabrication) this.getById(id, this.getNomTable(), c);
            FabricationFilleCpl[] details = enbase.getFabricationFilleCpl(c);
            enbase.setFille(details);
            if(details.length==0){return null;}
            MvtStock mvt = new MvtStock();
            mvt.setDesignation("Mouvement de stock de l'ordre de fabrication : " + this.getId());
            mvt.setIdobjet(this.getId());
            mvt.setIdTypeMvStock(typemvtstock);
            mvt.setIdCategorieStock(ConstanteSocobis.ID_CATEGORIESTOCK_NORMAL);
            mvt.setHeure(Utilitaire.heureCouranteHMS());
            mvt.setIdMagasin(cible!=null ?cible : enbase.getCible());
            if(typemvtstock.equalsIgnoreCase(ConstanteStation.TYPEMVTSTOCKENTREE))
            {
                MvtStockFille[] mvtstockdetails = new MvtStockFille[details.length];
                for (int i = 0; i < details.length; i++)
                {
                    mvtstockdetails[i] = new MvtStockFille();
                    details[i].setLibIngredients(details[i].getIdingredientsLib());
                    mvtstockdetails[i] = details[i].genererMvtStockFille(typemvtstock);
                }
                mvt.setFille(mvtstockdetails);
            }
            else {
                Recette crt=new Recette();
                crt.setNomTable("as_recetteFabLibSt");
                crt.setIdproduits(this.getId());
                Recette[] recettes = (Recette[])CGenUtil.rechercher(crt,null,null,c,"");
                FabricationFilleCpl[] detailsNouveau = new FabricationFilleCpl[recettes.length];
                List<MvtStockFille> mvtDetails = new ArrayList<MvtStockFille>();

                MvtStockEntreeAvecReste cibleCtr = new MvtStockEntreeAvecReste();
                cibleCtr.setNomTable("V_ETATSTOCK_ENTREE");
                cibleCtr.setIdMagasin(cible!=null ?cible : enbase.getCible());
                MvtStockEntreeAvecReste[] etatStock = (MvtStockEntreeAvecReste[])CGenUtil.rechercher(cibleCtr, null, null, c, "order by daty desc");

                Vector<MvtStockEntreeAvecReste> vect = new Vector<MvtStockEntreeAvecReste>(Arrays.asList(etatStock));

                for (int i = 0; i < recettes.length; i++) {
                    detailsNouveau[i] = new FabricationFilleCpl();
                    detailsNouveau[i].setIdIngredients(recettes[i].getIdingredients());
                    detailsNouveau[i].setLibIngredients(recettes[i].getLibIngredients());
                    if(recettes[i].getReste()>0)detailsNouveau[i].setQte(recettes[i].getReste());
                    detailsNouveau[i].setPu(recettes[i].getQteav());
                    if (recettes[i].getTypeStock() != null && recettes[i].getTypeStock().compareToIgnoreCase("") != 0&&detailsNouveau[i].getQte()>0) {
                        MvtStockFille mvtFille = new MvtStockFille();
                        double qteASortir = detailsNouveau[i].getQte();
                        while(qteASortir > 0){
                            MvtStockEntreeAvecReste stock = (MvtStockEntreeAvecReste) AdminGen.findUnique(vect,new String[]{"idProduit"},new String[]{detailsNouveau[i].getIdIngredients()});
                            if(stock != null && stock.getReste() > 0 ){
                                double qteTransferee = qteASortir;
                                qteTransferee = Math.min(qteASortir, stock.getReste());
                                stock.setReste(stock.getReste() - qteTransferee);
                                detailsNouveau[i].setQte(qteTransferee);
                                qteASortir -= qteTransferee;
                                mvtFille = detailsNouveau[i].genererMvtStockFille(typemvtstock);
                                mvtFille.setMvtSrc(stock.getId());
                                mvtFille.setPu(stock.getPu());
                                mvtDetails.add(mvtFille);
                                vect.remove(stock);
                            }else {
                                detailsNouveau[i].setQte(qteASortir);
                                mvtFille = detailsNouveau[i].genererMvtStockFille(typemvtstock);
                                mvtDetails.add(mvtFille);
                                break;
                            }


                        }
                    }
                }

                if (mvtDetails.isEmpty()) {
                    throw new Exception("Aucun ingr\\u00E9dient \\u00E0 sortir du stock pour cet ordre de fabrication");
                }
                mvt.ajouterFille(mvtDetails.toArray(new MvtStockFille[0]));

            }
            return mvt;
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception("Mouvement stock non generer "+e.getMessage());
        } finally {
            if (c != null&&estOuvert==true) {
                c.close();
            }
        }
    }

    public FabricationFille[] genererFabricationFilleSuivante(Connection c) throws Exception {
        boolean estOuvert=false;
        try{
            if(c==null){
                c=new UtilDB().GetConn();
                estOuvert=true;
            }
            //Maka an le fabrication fille miaraka am niveau
            //
        }
        catch(Exception e){
            c.rollback();
            throw e;
        }
        finally {
            if(estOuvert&&c!=null){c.close();}
        }
        return null;
    }

    public MvtStock genererMvtStock(Connection c) throws Exception {
        String id = this.getId();
        try {
            c = new UtilDB().GetConn();
            Fabrication enbase = (Fabrication) this.getById(id, this.getNomTable(), c);
            FabricationFilleCpl[] details = enbase.getFabricationFilleCpl(c);
            enbase.setFille(details);
            if(details.length==0){return null;}
            MvtStock mvt = new MvtStock();
            mvt.setDesignation("Mouvement de stock de l'ordre de fabrication : " + this.getId());
            mvt.setIdobjet(this.getId());
            mvt.setHeure(Utilitaire.heureCouranteHMS());
            mvt.setIdCategorieStock(ConstanteSocobis.ID_CATEGORIESTOCK_NORMAL);
            Recette crt=new Recette();
            crt.setNomTable("as_recetteFabLibSt");
            crt.setIdproduits(this.getId());
            Recette[] recettes = (Recette[])CGenUtil.rechercher(crt,null,null,c,"");
            FabricationFilleCpl[] detailsNouveau = new FabricationFilleCpl[recettes.length];
            MvtStockFille[] mvtstockdetails = new MvtStockFille[recettes.length];
            for (int i = 0; i < recettes.length; i++) {
                detailsNouveau[i] = new FabricationFilleCpl();
                detailsNouveau[i].setIdIngredients(recettes[i].getIdingredients());
                detailsNouveau[i].setLibIngredients(recettes[i].getLibIngredients());
                detailsNouveau[i].setPu(recettes[i].getQteav());
                if (recettes[i].getTypeStock() != null && recettes[i].getTypeStock().compareToIgnoreCase("") != 0) {
                    mvtstockdetails[i] = new MvtStockFille();
                    mvtstockdetails[i] = detailsNouveau[i].genererMvtStockFille(ConstanteStation.TYPEMVTSTOCKENTREE);
                }
            }
            mvt.ajouterFille(mvtstockdetails);
            return mvt;
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception("Mouvement stock non generer "+e.getMessage());
        } finally {
            if (c != null) {
                c.close();
            }
        }
    }
    @Override
    public ClassMAPTable createObject(String user, Connection connection) throws Exception {
        try {
            if (this.getIdOffille() == null || this.getIdOffille().isEmpty()) {
                return super.createObject(user, connection);
            }

            return createObjectWithFilles(user, connection);
        } catch (Exception e) {
            throw new Exception("Erreur lors de la création de l'objet", e);
        }
    }

    /**
     * Crée un objet avec ses filles associées
     * @throws Exception en cas d'erreur lors du traitement
     */
    private ClassMAPTable createObjectWithFilles(String user, Connection connection) throws Exception {
        try {
            FabricationFille[] originalFilles = (FabricationFille[]) this.getFille();
            Fabrication[] fabrications = createFabricationsFromFilles(originalFilles,connection);

            // Fusion des fabrications par niveau
            //Fabrication[] mergedFabrications = mergeFabrications(fabrications);

            // Persistance des fabrications et de leurs filles
            persistFabrications(fabrications, user, connection);

            // Retourner l'objet OfFille associé
            OfFille ofFille = new OfFille();
            ofFille.setId(this.getIdOffille());
            return ofFille;
        } catch (Exception e) {
            throw new Exception("Erreur lors de la création de l'objet avec ses filles", e);
        }
    }

    /**
     * Crée des fabrications à partir des filles
     * @throws Exception en cas d'erreur lors de la duplication
     */
    private Fabrication[] createFabricationsFromFilles(FabricationFille[] filles,Connection c) throws Exception {
        try {
            Fabrication[] fabrications = new Fabrication[filles.length];

            for (int i = 0; i < filles.length; i++) {
                FabricationFille originalFille = filles[i];

                // Dupliquer la fabrication de base
                Fabrication fabrication = (Fabrication) this.dupliquerSansBase();
                //fabrication.setIdFournisseur(originalFille.getOperateur());
                fabrication.setNiveau(originalFille.getNiveau());
                fabrication.setLibelle(originalFille.getRemarque());
                fabrication.construirePK(c);
                if(i>0)
                {
                    fabrication.setFabricationPrec(fabrications[i-1].getTuppleID());
                    fabrications[i-1].setFabricationSuiv(fabrication.getId());
                }


                // Dupliquer la fille et l'associer
                FabricationFille cloneFille = (FabricationFille) originalFille.dupliquerSansBase();
                fabrication.setFille(new FabricationFille[]{ cloneFille });

                fabrications[i] = fabrication;
            }

            return fabrications;
        } catch (Exception e) {
            throw new Exception("Erreur lors de la création des fabrications à partir des filles", e);
        }
    }

    /**
     * Fusionne les fabrications par identifiant de fournisseur
     * @throws Exception en cas d'erreur lors de la fusion
     */
    private Fabrication[] mergeFabrications(Fabrication[] fabrications) throws Exception {
        try {
            ClassMere[] result = AdminGen.fusionnerMultiple((ClassMere[]) fabrications, "niveau");
            Fabrication[] mergedFabrications = new Fabrication[result.length];

            for (int i = 0; i < result.length; i++) {
                mergedFabrications[i] = (Fabrication) result[i];
            }

            return mergedFabrications;
        } catch (Exception e) {
            throw new Exception("Erreur lors de la fusion des fabrications", e);
        }
    }

    /**
     * Persiste les fabrications et leurs filles associées
     * @throws Exception en cas d'erreur lors de la persistance
     */
    private void persistFabrications(Fabrication[] fabrications, String user, Connection connection) throws Exception {
        try {
            for (Fabrication fabrication : fabrications) {
                fabrication.insertToTableWithHisto(user, connection);

                for (Object filleObj : fabrication.getFille()) {
                    FabricationFille fille = (FabricationFille) filleObj;
                    fille.setIdMere(fabrication.getId());
                    fille.setLibelle(fabrication.getLibelle());
                    fille.createObject(user, connection);
                }
            }
        } catch (Exception e) {
            throw new Exception("Erreur lors de la persistance des fabrications et de leurs filles", e);
        }
    }

    public RessourceParFabrication[] getRessourceFabrication(Connection c) throws Exception{
        String id = this.getId();
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
            }
            RessourceParFabrication crt=new RessourceParFabrication();
            crt.setNomTable("ressourceParFabricationComplet");
            crt.setIdFabrication(id);
            RessourceParFabrication[] rep = (RessourceParFabrication[])CGenUtil.rechercher(crt,null,null,c,"");
            return rep;
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception(e.getMessage());
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }

    public HeureSupFabricationCPL[] genererHeureSup(Connection c)throws Exception{
        String id = this.getId();
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
            }
            RessourceParFabrication[] crt = this.getRessourceFabrication(c);
            HeureSupFabricationCPL[] rep=new HeureSupFabricationCPL[crt.length];
            if(crt.length>0){
                for(int i=0;i<crt.length;i++){
                    rep[i]=new HeureSupFabricationCPL();
                    rep[i].setIdRessParFab(crt[i].getId());
                    rep[i].setIdClasseDefaut(crt[i].getIdQualification());
                    rep[i].setIdClasseEffective(crt[i].getIdQualificationEffective());
                    rep[i].setIdPersonne(crt[i].getIdRessource());
                    rep[i].setRemarque(crt[i].getIdRessourceLib());
                }
            }
            return rep;
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception(e.getMessage());
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }


    public RessourceParFabrication[] genererAttribution(Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if(c==null){
                estOuvert = true;
                c = new UtilDB().GetConn();
            }
            Fabrication fabrication = new Fabrication();
            fabrication.setId(this.getId());
            fabrication = (Fabrication) fabrication.getMereFille("fabrication", "fabricationfille", c);
            if(fabrication == null){
                throw new Exception("Fabrication non trouvée pour l'ID: " + this.getId());
            }

            FabricationFille[] fille = (FabricationFille[]) fabrication.getFille();
            if(fille == null || fille.length == 0){
                throw new Exception("Aucune fabrication fille trouvée pour l'ID: " + this.getId());
            }

            Ingredients p = new Ingredients();
            p.setId(fille[0].getIdIngredients());
            Recette[] recettesMO =  p.decomposerParNiveau("AS_RECETTECOMPOSE",c,String.format(" and ing.idcategorie = '%s'", ConstanteSocobis.CATEGORIE_MAINDOEUVRE));

            RessourceParFabrication[] resFab = new RessourceParFabrication[recettesMO.length];
            for(int i=0; i<recettesMO.length; i++){
                resFab[i] = new RessourceParFabrication();
                resFab[i].setIdFabrication(this.getId());
                resFab[i].setIdPoste(recettesMO[i].getRefpost());
                resFab[i].setIdQualification(recettesMO[i].getRefqualification());
                String remarque = "";
                Poste pcrt = new Poste();
                pcrt.setId(recettesMO[i].getRefpost());
                Poste[] postes = (Poste[]) CGenUtil.rechercher(pcrt, null, null, c, " ");
                if(postes.length>0){
                    remarque += "Poste: "+postes[0].getVal();
                }
                QualificationPaie qcrt = new QualificationPaie();
                qcrt.setId(recettesMO[i].getRefqualification());
                QualificationPaie[] qualif = (QualificationPaie[]) CGenUtil.rechercher(qcrt, null, null, c, " ");
                if(qualif.length>0){
                    remarque += " / Qualification: "+qualif[0].getVal();
                }
                resFab[i].setRemarque(remarque);

            }
            return resFab;

        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception(e.getMessage());
        }finally {
            if(estOuvert && c!=null){
                c.close();
            }
        }
    }
    @Override
    public ClassMAPTable createObject(MapUtilisateur u, Connection c)throws Exception{
        if((u.getIdrole().compareTo(ConstanteSocobis.CHEFFABR_RANG) != 0)){
            throw new Exception("Vous n’avez pas le droit de creer une fabrication");
        }
        return super.createObject(u,c);
    }

    @Override
    public Object validerObject(MapUtilisateur u, Connection c) throws Exception {
        if((u.getIdrole().compareTo(ConstanteSocobis.CHEFFABR_RANG) != 0) && (u.getIdrole().compareTo(ConstanteSocobis.CONTREMAITRE_RANG) != 0)){
            throw new Exception("Vous n’avez pas le droit de valider une fabrication");
        }
        return super.validerObject(u, c);
    }

    public HeureSupFabrication[] genererRessourceFab() throws Exception {
        Connection c = null;
        boolean isOpen = false;
        Fabrication fab = (Fabrication) this.getById(this.getId(), this.getNomTable(), c);
        HeureSupFabrication[] fille = null;
        try {
            c = new  UtilDB().GetConn();
            isOpen = true;

            EquipeEmpCpl equipe = new EquipeEmpCpl();
            equipe.setNomTable("EQUIPE_EMP_CPL");
            equipe.setIdEquipe(fab.getEquipe());

            EquipeEmpCpl[] list = (EquipeEmpCpl[]) CGenUtil.rechercher(equipe, null, null, c, "");
            if(list != null && list.length > 0) {
                fille = new HeureSupFabrication[list.length];
                for(int i=0; i < list.length; i++) {
                    HeureSupFabrication hs = new HeureSupFabrication();
                    hs.setIdRessParFab(list[i].getIdEmploye());
                    fille[i] = hs;
                }

//                fab.setFille(fille);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (c != null && isOpen == true) {
                c.close();
            }
        }
        return fille;
    }

    public DemandeTransfert genererDemandeTransfertFab(String idFab, String idcat, Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }
            Fabrication fab= new Fabrication();
            fab = (Fabrication) fab.getById(idFab, "FABRICATION", c);
            DemandeTransfert dm = new DemandeTransfert();
            dm.setNomTable("demandetransfert");
            dm.setIdMagasinDepart(fab.getLancePar());
            dm.setIdMagasinArrive(fab.getCible());
            dm.setIdFabrication(fab.getId());
            dm.setDesignation("Demande de transfert : " + fab.getId());
            Recette[] recettes = fab.decomposer(c);
            Vector<DemandeTransfertFille> vect = new Vector<DemandeTransfertFille>();
            for(int i=0; i<recettes.length; i++){
                if(idcat!=null && !idcat.equalsIgnoreCase(recettes[i].getCategorieingredient())){
                    System.out.println("Recette "+recettes[i].getCategorieingredient()+" n'appartient pas à la catégorie "+idcat);
                    continue;
                }
                DemandeTransfertFille data = new DemandeTransfertFille();
                data.setIdProduit(recettes[i].getIdingredients());
                data.setRemarque(recettes[i].getLibIngredients()+" "+recettes[i].getUnite());
                data.setQuantite(recettes[i].getQuantite());
                vect.add(data);
            }
            dm.setFille(vect.toArray(new DemandeTransfertFille[0]));
            return dm;
        } catch (Exception e) {
            throw e;
        } finally {
            if(estOuvert==true&&c!=null)c.close();
        }
    }
}
