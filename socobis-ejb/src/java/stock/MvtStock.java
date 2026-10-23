/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package stock;

import bean.*;
import fabrication.Fabrication;
import fabrication.FabricationFille;
import fabrication.OfFille;
import faturefournisseur.As_BonDeLivraison;
import inventaire.Inventaire;
import inventaire.InventaireFille;
import inventaire.InventaireFilleCpl;
import java.sql.Connection;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

import magasin.CategorieIngredientMagasin;
import magasin.Magasin;
import mg.cnaps.compta.ComptaEcriture;
import mg.cnaps.compta.ComptaSousEcriture;
import mg.cnaps.compta.ConstanteCompta;
import paramCompta.ParamComptaStatique;
import produits.Ingredients;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;
import utils.ConstanteSocobis;
import java.sql.Statement;
import utils.ConstanteStation;
import vente.As_BondeLivraisonClient;
import java.text.SimpleDateFormat;


public class MvtStock extends ClassMere {

    private String id, designation, idMagasin, idVente, idTransfert, idTypeMvStock,idPoint,idobjet,fabPrecedent;
    private Date daty;
    EtatStock [] etatStock;
    EtatStockParEntree[] etatStockParEntree;
    String heure;
    String remarque;
    private String idCategorieStock;

    public String getIdCategorieStock() {
        return idCategorieStock;
    }

    public void setIdCategorieStock(String idCategorieStock)throws Exception {
        if((this.getMode().compareToIgnoreCase("modif")==0||this.getMode().compareToIgnoreCase("insert")==0)&&(idCategorieStock==null||idCategorieStock.equals(""))){
            throw new Exception("Champ categorie stock obligatoire");
        }
        this.idCategorieStock = idCategorieStock;
    }

    public String getHeure() {
        return heure;
    }

    public void setHeure(String heure) {
        if((this.getMode().compareToIgnoreCase("modif")==0||this.getMode().compareToIgnoreCase("insert")==0)&&(heure==null||heure.equals(""))){
            heure=Utilitaire.heureCouranteHMS();
        }
        this.heure = heure;
    }

    @Override
    public boolean isSynchro(){
        return true;
    }
    
    public MvtStock() throws Exception {
        this.setNomTable("MVTSTOCK");
        this.setNomClasseFille("stock.MvtStockFille");
        this.setLiaisonFille("idMvtStock");
    }

    public EtatStock[] getEtatStock() {
        return etatStock;
    }

    public void setEtatStock(EtatStock[] etatStock) {
        this.etatStock = etatStock;
    }

    public EtatStockParEntree[] getEtatStockParEntree() {
        return etatStockParEntree;
    }

    public void setEtatStockParEntree(EtatStockParEntree[] etatStockParEntree) {
        this.etatStockParEntree = etatStockParEntree;
    }

    public String getFabPrecedent() {
        return fabPrecedent;
    }

    public void setFabPrecedent(String fabPrecedent) {
        this.fabPrecedent = fabPrecedent;
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
        if (this.getMode().compareToIgnoreCase("modif")==0 && Utilitaire.champNull(idMagasin).compareTo("") == 0 ) {
            throw new Exception("Champ magasin obligatoire");
        }
        this.idMagasin = idMagasin;
    }

    public String getIdVente() {
        return idVente;
    }

    public void setIdVente(String idVente) {
        this.idVente = idVente;
    }

    public String getIdTransfert() {
        return idTransfert;
    }

    public void setIdTransfert(String idTransfert) {
        this.idTransfert = idTransfert;
    }

    public String getIdTypeMvStock() {
        return idTypeMvStock;
    }

    public void setIdTypeMvStock(String idTypeMvStock) throws Exception{
        if (this.getMode().compareToIgnoreCase("modif")==0 && (idTypeMvStock== null || idTypeMvStock.compareToIgnoreCase("") == 0)) {
            throw new Exception("Champ type du mouvement stock obligatoire");
        }
        this.idTypeMvStock = idTypeMvStock;
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

    public String getIdPoint() {
        return idPoint;
    }

    public void setIdPoint(String idPoint) {
        this.idPoint = idPoint;
    }

    public String getIdobjet() {
        return idobjet;
    }

    public void setIdobjet(String idobjet) {
        this.idobjet = idobjet;
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
        this.preparePk("MVTST", "GETSEQMVTSTOCK");
        this.setId(makePK(c));
    }

    public void checkCategorieProduit(Connection c) throws Exception{
        CategorieIngredientMagasin magasin = new CategorieIngredientMagasin();
        magasin.setIdMagasin(this.getIdMagasin());
        CategorieIngredientMagasin[] magasins = (CategorieIngredientMagasin[]) CGenUtil.rechercher(magasin,null,null,"");
        if(magasins != null && magasins.length>0){

            MvtStockFille[] mvtStockFille = (MvtStockFille[]) this.getFille();
            if(mvtStockFille!=null && mvtStockFille.length>0){
                for(int i = 0 ;i<mvtStockFille.length;i++){
                    Ingredients ing = new Ingredients();
                    ing = (Ingredients) ing.getById(mvtStockFille[i].getIdProduit(),"AS_INGREDIENTS",c);
                    CategorieIngredientMagasin[] mags = (CategorieIngredientMagasin[]) AdminGen.find(magasins,new String[]{"idCategorieIngredient"},new String[]{ing.getCategorieIngredient()});
                    if(mags == null || (mags != null && mags.length ==0)  ){
                        throw new Exception("Cat\u00E9gorie  du produit " + ing.getId()  + "( " + ing.getLibelle()  + " ) n est pas prise en compte dans ce magasin " );
                    }
                }
            }
        }
    }

    protected void controlerMvt(Connection c) throws Exception {
        if (this.getMode().compareToIgnoreCase("modif")==0 && (this.getIdMagasin()== null || this.getIdMagasin().compareToIgnoreCase("") == 0)) {
            throw new Exception("Champ magasin obligatoire");
        }
        checkCategorieProduit(c);
    }

    public Magasin getMagasin(Connection c) throws Exception {
        if (c == null) {
            throw new Exception("Connection non etablie");
        }
        Magasin magasin = new Magasin();
        magasin.setId(this.getIdMagasin());
        Magasin[] magasins = (Magasin[]) CGenUtil.rechercher(magasin, null, null, c, " ");
        if (magasins.length > 0) {
            return magasins[0];
        }
        return null;
    }

    public MvtStockFille[] getMvtStockFilles(Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
            }
            MvtStockFille msf = new MvtStockFille();
            msf.setIdMvtStock(this.getId());
            MvtStockFille[] msfs = (MvtStockFille[]) CGenUtil.rechercher(msf, null, null, c, " ");
            if (msfs.length > 0) {
                return msfs;
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

    public void createInventaireZero(String u, Connection c) throws Exception {
    if (this.getIdTypeMvStock() == ConstanteStation.TYPEMVTSTOCKENTREE) {
        MvtStockFille[] msfs = getMvtStockFilles(c);
        this.setFille(msfs);
        if (msfs != null && msfs.length > 0) {
            for (MvtStockFille mvf : msfs) {
                InventaireFilleCpl invFCpl = new InventaireFilleCpl();
                invFCpl.setIdMagasin(this.getIdMagasin());
                invFCpl.setIdProduit(mvf.getIdProduit());
                InventaireFilleCpl[] invFCpls = invFCpl.getInventaireFilles(c);
                if (invFCpls == null) {
                    Magasin m = getMagasin(c);
                    Inventaire inv = (Inventaire) m.generateInventaireMere().createObject(u, c);
                    InventaireFille invF = inv.generateInventaireFilleZero();
                    invF.setIdProduit(mvf.getIdProduit());
                    invF.createObject(u, c);
                    inv.validerObject(u, c);
                }
            }
        }
    }
}
    public OfFille[] getOfFilles(String nt,Connection c) throws Exception {
        String nomTable="fabricationOfFille";
        if(nt!=null&&nt.compareToIgnoreCase("")!=0) nomTable=nt;
        OfFille crt=new OfFille();
        crt.setNomTable(nomTable);
        crt.setIdFab(this.getIdobjet());
        return (OfFille[]) CGenUtil.rechercher(crt, null, null, c, "");
    }
    public FabricationFille[] getFabricationFilles(String nt,Connection c) throws Exception {
            String nomTable="FABRICATIONFILLE";
            if(nt!=null&&nt.compareToIgnoreCase("")!=0) nomTable=nt;
            FabricationFille crt=new FabricationFille();
            crt.setNomTable(nomTable);
            crt.setIdMere(this.getIdobjet());
            return (FabricationFille[]) CGenUtil.rechercher(crt, null, null, c, "");
    }
    public MvtStockFille[] getMvtStockPrecedent(String nt,Connection c) throws Exception {
           String nomTable="MVTSTOCKFille";
           if(nt!=null&&nt.compareToIgnoreCase("")!=0) nomTable=nt;
           MvtStockFille crt=new MvtStockFille();
           return null;
    }
    public static MvtStockFille[] getMvtStockEntree(MvtStockFille[] msfs) throws Exception {
            ArrayList<MvtStockFille> msfList = new ArrayList<MvtStockFille>();
            for (MvtStockFille msf : msfs) {
                if(msf.getEntree()>0) msfList.add(msf);
            }
            return msfList.toArray(new MvtStockFille[msfList.size()]);
    }
    public static MvtStockFille getMvtStockEntreeCorrespondantFabFille(MvtStockFille[] msfs,FabricationFille[] listeFab) throws Exception {
        MvtStockFille[] mvEntree=getMvtStockEntree(msfs);
        for (MvtStockFille msf : mvEntree) {
            for (FabricationFille fab : listeFab) {
                if(msf.getIdProduit().compareToIgnoreCase(fab.getIdIngredients())==0) return msf;
            }
        }
        return null;
    }

    /*@Override
    public Object validerObject(String u, Connection c) throws Exception {
        MvtStockFille[]fille=this.getMvtStockFilles(c);
        if (this.getIdTypeMvStock()!=null && this.getIdTypeMvStock().compareToIgnoreCase(ConstanteSocobis.TYPE_MVT_SORTIE)==0) {
            checkResteStock(c,fille, this);
            createGenerateMvt(u,c,fille);
        }
        for (int i = 0; i < fille.length; i++) {
            fille[i].updateQteIngredient(u, c);
        }
        super.validerObject(u, c);
        // createInventaireZero(u, c);
        if(this.getFabPrecedent()==null||this.getFabPrecedent().compareToIgnoreCase("")==0) return this;
        Fabrication precedent=new Fabrication();
        precedent.setId(this.getFabPrecedent());
        FabricationFille[] ofFille=(FabricationFille[])precedent.getFille(null, c,"");
        if(ofFille==null||ofFille==null) return this;
        Fabrication fab=new Fabrication();
        fab.setId(this.getFabPrecedent());
        //MvtStockFille[] mvtFilleFab=fab.getMvtStockFille(null,c);
        //if(MvtStock.getMvtStockEntreeCorrespondantFabFille(mvtFilleFab,ofFille)!=null) return this;
        for(int i=0;i<fille.length;i++){
            if(fille[i].getSortie()>0)
            {
                if(fille[i].getIdProduit().compareToIgnoreCase(ofFille[0].getIdIngredients())==0)
                {
                    MvtStock mvt=(MvtStock) this.dupliquerSansBase();
                    mvt.construirePK(c);
                    mvt.setIdobjet(this.getFabPrecedent());
                    mvt.setFabPrecedent(null);
                    mvt.setIdTypeMvStock(ConstanteStation.TYPEMVTSTOCKENTREE);
                    MvtStockFille nouveau=fille[i].contrer();
                    nouveau.setIdMvtStock(mvt.getId());
                    nouveau.construirePK(c);
                    MvtStockFille[]ln={nouveau};
                    mvt.setFille(ln);
                    mvt.createObject(u, c);
                    mvt.validerObject(u, c);
                }
            }
        }
        return this;
    }*/

    public MvtStockFilleGrp[]  getDetailGrp(Connection c)  throws Exception
    {
        MvtStockFilleGrp mg = new MvtStockFilleGrp();
        mg.setNomTable("mvtStockFilleCptStock");
        MvtStockFilleGrp[] grp = (MvtStockFilleGrp[]) CGenUtil.rechercher(mg,null, null, c , " And IDMVTSTOCK = '"+ this.getId() +"'");
        if (grp.length == 0) {
            throw new Exception("Stock details introuvable pour l'ID : " + id );
        }
        return grp;
    }

    public TransfertStock getTransfertStock(Connection c) throws Exception {
        TransfertStock transfertStock = new TransfertStock();
        transfertStock.setId(this.getIdTransfert());
        System.out.println("ID TRANSFERT DE STOCK ====> " + this.getIdTransfert() );
        return (TransfertStock) CGenUtil.getMereAvecFille(transfertStock, c, "TRANSFERTSTOCKDETAILS");
    }

//    public int[] comparerTransfertMvtStock(MvtStockFille[] grp, TransfertStock transfertStock) throws Exception {
//        TransfertStockDetails[] details = (TransfertStockDetails[]) transfertStock.getFille();
//        int[] ecarts = new int[grp.length];
//        for (int i = 0; i < grp.length; i++) {
//            TransfertStockDetails[] detailsTrouves = (TransfertStockDetails[]) AdminGen.find(details, new String[]{"id"}, new String[]{grp[i].getIdTransfertDetail()});
//            if (detailsTrouves == null || detailsTrouves.length == 0) {
//                throw new Exception("Détail de transfert introuvable : " + grp[i].getIdTransfertDetail());
//            }
//            ecarts[i] = (int) (grp[i].getEntree() - detailsTrouves[0].getQuantite());
//        }
//        return ecarts;
//    }

    public List<Double> comparerTransfertMvtStock(MvtStockFille[] mouvements, TransfertStock transfertStock) throws Exception {
        List<Double> ecarts = new ArrayList<>();
        if (mouvements == null || transfertStock == null) {
            return ecarts;
        }
        TransfertStockDetails[] details = (TransfertStockDetails[]) transfertStock.getFille();
        if (details == null) {
            return ecarts;
        }
        for (MvtStockFille mouvement : mouvements) {

            TransfertStockDetails[] detailsTrouves = (TransfertStockDetails[]) AdminGen.find(details, new String[]{"id"}, new String[]{mouvement.getIdTransfertDetail()});
            if (detailsTrouves == null || detailsTrouves.length == 0) {
                throw new Exception("Détail de transfert introuvable : " + mouvement.getIdTransfertDetail());
            }
            double ecart = mouvement.getEntree() - detailsTrouves[0].getQuantite();
            if (Double.compare(ecart, 0.0) != 0) {
                ecarts.add(ecart);
            }
        }
        return ecarts;
    }

    /*public ComptaSousEcriture[] genererSousEcriture(Connection c,MvtStockFille[] mvtFilles) throws Exception {
        ComptaSousEcriture[] compta = null;
        if(mvtFilles==null||mvtFilles.length==0) return null;
        boolean canClose = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                canClose = true;
            }

            MvtStockFilleGrp[] grp = this.getDetailGrp(c);
            compta = new ComptaSousEcriture[grp.length + mvtFilles.length];

            double montantEntreeTotal = 0;
            //double montantTvaTotal = getFactureFournisseur(c).getTVATotal(c);
            TransfertStock transfertStock = null;
            int[] ecart = null;
            if(this.getIdTransfert() != null&&this.getIdTransfert().compareToIgnoreCase("")!=0) {
                transfertStock = this.getTransfertStock(c);
                ecart = comparerTransfertMvtStock(grp, transfertStock);
            }
            int i = 0;
            for (; i < grp.length; i++)
            {
                MvtStockFilleGrp mvtStockFilleGrp = grp[i];
                double montantEntree = mvtStockFilleGrp.getMontantCalc();

                compta[i] = new ComptaSousEcriture();
                compta[i].setRemarque(this.getId());
                if(ecart!=null&&this.getIdTransfert()!=null) {
                    for (int j = 0; j < ecart.length; j++) {
                        if (this.getIdTransfert() != null && this.getIdTypeMvStock() == (ConstanteSocobis.getTypeMvtEntree)) {
                            if (ecart[i] > 0) {
                                TypeObjet paramCompta = ParamComptaStatique.getById(ConstanteSocobis.gainStock);
                                compta[i].setLibellePiece(paramCompta.getVal());
                                compta[i].setCompte(paramCompta.getDesce());
                            }
                            if (ecart[i] < 0) {
                                TypeObjet paramCompta = ParamComptaStatique.getById(ConstanteSocobis.perteStock);
                                compta[i].setLibellePiece(paramCompta.getVal());
                                compta[i].setCompte(paramCompta.getDesce());
                            }
                        }
                    }
                }
                if(this.getIdTypeMvStock().compareToIgnoreCase(ConstanteSocobis.stockTypeInventaire)!=0) {
                    compta[i].setLibellePiece("Variation de Stock du mouvement " + this.getId());
                    compta[i].setCompte(mvtStockFilleGrp.getCompte_sortie_stock());
                }
                else
                { //Cas de type inventaire
                    if(mvtStockFilleGrp.getEntree()>0) //Cas gain inventaire
                    {
                        compta[i].setLibellePiece("gain de Stock du mouvement " + this.getId()+" de l inventaire "+this.getIdobjet());
                        compta[i].setCompte(ConstanteSocobis.compteGainInvenatre);
                    }
                    else //Cas perte inventaire
                    {
                        compta[i].setLibellePiece("Perte de Stock du mouvement " + this.getId()+" de l inventaire "+this.getIdobjet());
                        compta[i].setCompte(ConstanteSocobis.comptePerteInvenatre);
                    }
                    //compta[i].setCompte(mvtStockFilleGrp.getCompte_sortie_stock());
                }
                if(mvtStockFilleGrp.getEntree()>0) compta[i].setCredit(montantEntree);
                else compta[i].setDebit(montantEntree);
            }
            for(int indCredi=i;indCredi<compta.length;indCredi++) {
                compta[indCredi]=new ComptaSousEcriture();
                compta[indCredi].setLibellePiece("Compte de sttock du mouvement "+this.getId());
                compta[indCredi].setRemarque(this.getId());
                compta[indCredi].setCompte(mvtFilles[indCredi- grp.length].getCompte_stock());
                if(mvtFilles[indCredi- grp.length].getEntree()>0) compta[indCredi].setDebit(mvtFilles[indCredi-grp.length].getMontantCalc());
                else compta[indCredi].setCredit(mvtFilles[indCredi-grp.length].getMontantCalc());
            }

            // Ligne pour la TVA (si applicable)
//            compta[i] = new ComptaSousEcriture();
//            compta[i].setLibellePiece("TVA entrée Stock");
//            compta[i].setRemarque("TVA entrée Stock");
//            compta[i].setCompte(ConstanteStation.compteTVACollecte);
//            compta[i].setDebit(montantTvaTotal);
//            i++;

            // Ligne récapitulative fournisseur
//            compta[i] = new ComptaSousEcriture();
//            compta[i].setLibellePiece("Entrée Stock Total");
//            compta[i].setRemarque("Entrée Stock Total");
//            compta[i].setCompte(getFournisseur(c).getCompte());
            //compta[i].setCredit(montantEntreeTotal + montantTvaTotal);

        } catch (Exception e) {
            throw e;
        } finally {
            if (canClose && c != null) {
                c.close();
            }
        }
        return compta;
    }*/


    public void genererEcritureBatch(String u, Statement st, MvtStockFille[]mvtFille) throws Exception{
        Connection c=st.getConnection();
        ComptaEcriture mere = new ComptaEcriture();
        Date dateDuJour = utilitaire.Utilitaire.dateDuJourSql();
        int exercice = utilitaire.Utilitaire.getAnnee(daty);
        mere.setDaty(dateDuJour);
        mere.setDesignation(this.getDesignation());
        mere.setExercice(""+exercice);
        mere.setDateComptable(this.getDaty());
        mere.setJournal(ConstanteCompta.journalOD);
        mere.setOrigine(this.getId());
        mere.setIdobjet(this.getId());

        ComptaSousEcriture[] filles = this.genererSousEcriture(c,mvtFille);
        for(int i=0; i<filles.length; i++){
            filles[i].setIdMere(mere.getId());
            filles[i].setExercice(exercice);
            filles[i].setDaty(this.getDaty());
            filles[i].setJournal(ConstanteCompta.journalOD);

            if(filles[i].getDebit()>0 || filles[i].getCredit()>0) mere.ajouterFille(filles[i]);
        }
        mere.createObjectBatch(u, st);
    }

    public void processUpdateStockEngageBatch(String u, Statement st) throws Exception {
        Connection c=st.getConnection();
        As_BondeLivraisonClient blAssocie = getBL(c);
        if (blAssocie == null) {
            throw new Exception("Bon de livraison associé intouvable");
        }

        String idVente = blAssocie.getIdvente();

        MvtStock mvtSearch = new MvtStock();
        mvtSearch.setIdVente(idVente);
        mvtSearch.setNomTable("stock_engage");

        MvtStock[] resultatRecherche = (MvtStock[]) CGenUtil.rechercher(mvtSearch, null, null, c, "");
        if (resultatRecherche.length == 0) {
            throw new Exception("Stock avec engagement introuvable pour le vente : " + idVente + " associé a la blc : " + getIdobjet());
        }

        MvtStock stockEngage = resultatRecherche[0];
        MvtStockFille[] stockEngageFilles = (MvtStockFille[]) stockEngage.getFille("STOCK_ENGAGE_FILLE", c, "");

        MvtStockFille[] stockFille = (MvtStockFille[]) getFille();
        for (MvtStockFille fille : stockFille) {
            boolean finded = false;
            for (MvtStockFille filleEngage : stockEngageFilles) {
                if (fille.getIdProduit().equals(filleEngage.getIdProduit())) {
                    filleEngage.setSortie(filleEngage.getSortie() - fille.getSortie());
                    if (filleEngage.getSortie() < 0) {
                        throw new Exception("Impossible de livrer une quantité superieure \u00E0 la quantité engagé");
                    }
                    filleEngage.setNomTable("STOCK_ENGAGE_FILLE");
                    filleEngage.updateToTableBatch(st);
                    finded = true;
                    break;
                }
            }

            if (!finded) {
                throw new Exception("Stock avec engagement introuvable pour le produit : " + fille.getIdProduit());
            }
        }
    }


    @Override
    public Object validerObjectBatch(String u, Statement st) throws Exception {
        Connection c = st.getConnection();
        try {
            MvtStockFille[] fille = (MvtStockFille[]) this.getFille("mvtStockFilleCptStock",c,"");

            this.genererEcritureBatch(u,st,fille);

            if (fille == null) fille = this.getMvtStockFilles(c);
            setFille(fille);
            if (this.getIdTypeMvStock() != null && this.getIdTypeMvStock().compareToIgnoreCase(ConstanteSocobis.TYPE_MVT_SORTIE) == 0) {
                checkResteStock(c, fille, this);
                //createGenerateMvt(u, c, fille);
            }
            //st=c.createStatement();
            /*for (int i = 0; i < fille.length; i++) {
                fille[i].updateQteIngredientBatch(u, st);
            }*/

//            Magasin magasin = new Magasin();
//            magasin.setNomTable("magasin2");
//            magasin.setId(this.getIdMagasin());
//
//            Magasin[] magasins = (Magasin[]) CGenUtil.rechercher(magasin, null, null, c, "");



            //st.executeBatch();
            this.setHeure(Utilitaire.heureCouranteHMS());
            this.setDaty(Utilitaire.dateDuJourSql());
            super.validerObjectBatch(u, st);
            this.setFille(fille);

            String idObjet = getIdobjet();
            if (idObjet != null && idObjet.startsWith("BLC")) {


                As_BondeLivraisonClient bl = (As_BondeLivraisonClient) new As_BondeLivraisonClient().getById(idObjet, null, c);

                if (bl == null)
                {

                    throw new Exception("BON DE LIVRAISON Client n'existe pas");
                }

                if (!bl.getRemarque().startsWith("POS")) {
                    processUpdateStockEngageBatch(u, st);
                }
            }

            // createInventaireZero(u, c);

            return this;
        }
        catch (Exception e)
        {
            e.printStackTrace();
            throw e;
        }
        finally {
//            if(st!=null) st.close();
        }
    }
    public ComptaSousEcriture[] genererSousEcriture(Connection c,MvtStockFille[] mvtFilles) throws Exception {
        ComptaSousEcriture[] compta = null;
        if(mvtFilles==null||mvtFilles.length==0) return null;
        boolean canClose = false;
        if(this.getIdTransfert()!=null&&this.getIdTransfert().equalsIgnoreCase("")==false&&this.getFille()!=null&&((MvtStockFille)this.getFille()[0]).getSortie()>0)
            return null;

        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                canClose = true;
            }
            MvtStockFilleGrp[] grp = this.getDetailGrp(c);
            compta = new ComptaSousEcriture[grp.length + mvtFilles.length];

            double montantEntreeTotal = 0;
            //double montantTvaTotal = getFactureFournisseur(c).getTVATotal(c);
            TransfertStock transfertStock = null;
            List<Double> ecart = null;
            if(this.getIdTransfert() != null&&this.getIdTransfert().compareToIgnoreCase("")!=0&&this.getIdTransfert().startsWith("TS")) {
                transfertStock = this.getTransfertStock(c);
                ecart = comparerTransfertMvtStock(grp, transfertStock);
            }
            if(ecart!=null&&ecart.size()>0&&this.getIdTransfert()!=null)
            {
                compta=new ComptaSousEcriture[ecart.size()*2];
                int j=0;
                for (; j < ecart.size(); j++) {
                    compta[j] = new ComptaSousEcriture();
                    compta[j].setRemarque(this.getId());
                    if (this.getIdTransfert() != null && grp[j].getEntree()>0) {
                        if (ecart.get(j) > 0) {
                            TypeObjet paramCompta = ParamComptaStatique.getById(ConstanteSocobis.gainStock);
                            compta[j].setLibellePiece(paramCompta.getVal());
                            compta[j].setCompte(paramCompta.getDesce());
                            compta[j].setCredit(ecart.get(j).doubleValue() *grp[j].getPu());
                        }
                        if (ecart.get(j) < 0) {
                            TypeObjet paramCompta = ParamComptaStatique.getById(ConstanteSocobis.perteStock);
                            compta[j].setLibellePiece(paramCompta.getVal());
                            compta[j].setCompte(paramCompta.getDesce());
                            compta[j].setDebit(ecart.get(j).doubleValue()*grp[j].getPu());
                        }
                    }
                }
                for(int indCredi=j;indCredi<compta.length;indCredi++) {
                    compta[indCredi]=new ComptaSousEcriture();
                    compta[indCredi].setLibellePiece("Compte de sttock du mouvement "+this.getId());
                    compta[indCredi].setRemarque(this.getId());
                    compta[indCredi].setCompte(mvtFilles[indCredi- ecart.size()].getCompte_stock());
                    if(ecart.get(indCredi- ecart.size()) > 0) compta[indCredi].setDebit(ecart.get(indCredi- ecart.size()).doubleValue()*grp[indCredi- ecart.size()].getPu());
                    else compta[indCredi].setCredit(ecart.get(indCredi- ecart.size()).doubleValue()*grp[indCredi- ecart.size()].getPu());
                }
                return compta;
            }

            int i = 0;
            for (; i < grp.length; i++) {
                MvtStockFilleGrp mvtStockFilleGrp = grp[i];
                double montantEntree = mvtStockFilleGrp.getMontantCalc();

                compta[i] = new ComptaSousEcriture();
                compta[i].setRemarque(this.getId());

                if(this.getIdTypeMvStock().compareToIgnoreCase(ConstanteSocobis.stockTypeInventaire)==0)  //Cas de type inventaire
                {
                    if(mvtStockFilleGrp.getEntree()>0) //Cas gain inventaire
                    {
                        compta[i].setLibellePiece("gain de Stock du mouvement " + this.getId()+" de l inventaire "+this.getIdobjet());
                        compta[i].setCompte(ConstanteSocobis.compteGainInvenatre);
                    }
                    else //Cas perte inventaire
                    {
                        compta[i].setLibellePiece("Perte de Stock du mouvement " + this.getId()+" de l inventaire "+this.getIdobjet());
                        compta[i].setCompte(ConstanteSocobis.comptePerteInvenatre);
                    }
                    //compta[i].setCompte(mvtStockFilleGrp.getCompte_sortie_stock());
                }
                else
                {
                    compta[i].setLibellePiece("Variation de Stock du mouvement " + this.getId());
                    compta[i].setCompte(mvtStockFilleGrp.getCompte_sortie_stock());
                }
                if(mvtStockFilleGrp.getEntree()>0) compta[i].setCredit(montantEntree);
                else compta[i].setDebit(montantEntree);
            }
            for(int indCredi=i;indCredi<compta.length;indCredi++) {
                compta[indCredi]=new ComptaSousEcriture();
                compta[indCredi].setLibellePiece("Compte de sttock du mouvement "+this.getId());
                compta[indCredi].setRemarque(this.getId());
                compta[indCredi].setCompte(mvtFilles[indCredi- grp.length].getCompte_stock());
                if(mvtFilles[indCredi- grp.length].getEntree()>0) compta[indCredi].setDebit(mvtFilles[indCredi-grp.length].getMontantCalc());
                else compta[indCredi].setCredit(mvtFilles[indCredi-grp.length].getMontantCalc());
            }

            // Ligne pour la TVA (si applicable)
            /*compta[i] = new ComptaSousEcriture();
            compta[i].setLibellePiece("TVA entrée Stock");
            compta[i].setRemarque("TVA entrée Stock");
            compta[i].setCompte(ConstanteStation.compteTVACollecte);
            compta[i].setDebit(montantTvaTotal);
            i++;*/

            // Ligne récapitulative fournisseur
            /*compta[i] = new ComptaSousEcriture();
            compta[i].setLibellePiece("Entrée Stock Total");
            compta[i].setRemarque("Entrée Stock Total");
            compta[i].setCompte(getFournisseur(c).getCompte());*/
            //compta[i].setCredit(montantEntreeTotal + montantTvaTotal);

        } catch (Exception e) {
            throw e;
        } finally {
            if (canClose && c != null) {
                c.close();
            }
        }
        return compta;
    }



    public void genererEcriture(String u, Connection c,MvtStockFille[]mvtFille) throws Exception{
        ComptaEcriture mere = new ComptaEcriture();
        Date dateDuJour = utilitaire.Utilitaire.dateDuJourSql();
        int exercice = utilitaire.Utilitaire.getAnnee(daty);
        mere.setDaty(dateDuJour);
        mere.setDesignation("Variation de stock - " + Utilitaire.champNull(this.getDesignation()));
        mere.setExercice(""+exercice);
        mere.setDateComptable(this.getDaty());
        mere.setJournal(ConstanteCompta.journalOD);
        mere.setOrigine(this.getId());
        mere.setIdobjet(this.getId());
        ComptaSousEcriture[] filles = this.genererSousEcriture(c,mvtFille);
        if(filles==null) return;
        for(int i=0; i<filles.length; i++){
            filles[i].setIdMere(mere.getId());
            filles[i].setExercice(exercice);
            filles[i].setDaty(this.getDaty());
            filles[i].setJournal(ConstanteCompta.journalOD);
            filles[i].setRemarque(mere.getDesignation());
            filles[i].setLibellePiece(this.getId());

            if(filles[i].getDebit()>0 || filles[i].getCredit()>0) mere.ajouterFille(filles[i]);
        }
        mere.createObject(u, c);
    }

    @Override
    public Object validerObject(String u, Connection c) throws Exception {
        Statement st =null;
        try {
            MvtStockFille[] fille = (MvtStockFille[]) this.getFille("mvtStockFilleCptStock",c,"");

            this.genererEcriture(u,c,fille);

//            if (fille == null) fille = this.getMvtStockFilles(c);
//            setFille(fille);
//            if (this.getIdTypeMvStock() != null && this.getIdTypeMvStock().compareToIgnoreCase(ConstanteSocobis.TYPE_MVT_SORTIE) == 0) {
//                checkResteStock(c, fille, this);
//                 createGenerateMvt(u, c, fille);
//            }
//            else {
//                Magasin magasin = new Magasin();
//                magasin.setNomTable("magasin2");
//                magasin.setId(this.getIdMagasin());
//                Magasin[] magasins = (Magasin[]) CGenUtil.rechercher(magasin, null, null, c, "");

//                for (MvtStockFille msf : fille)
//                {
//                    if (msf.getIdProduit().equalsIgnoreCase(ConstanteSocobis.gaz))
//                    {
//                        this.releverGaz(u, c, magasins[0].getIdLigne(), msf);
//                    }
//                }

//            }
            st=c.createStatement();
            for (int i = 0; i < fille.length; i++) {
                fille[i].updateQteIngredientBatch(u, st);
            }
            st.executeBatch();




            this.setHeure(Utilitaire.heureCouranteHMS());
            super.validerObject(u, c);
            this.setFille(fille);
            // creation inventaire vide lors de chaque saisie entree de stock
            /*
            if (this.getIdTypeMvStock().equalsIgnoreCase(ConstanteStation.TYPEMVTSTOCKENTREE)) {
                Inventaire inv = new Inventaire();
                inv.preparePk("IVTVIDE", "GETSEQINVENTAIRE");
                inv.setId(inv.makePK());
                inv.setDaty(this.getDaty());
                inv.setDesignation("Inventaire auto vide du mouvement de stock num "+this.getId());
                inv.setIdMagasin(this.getIdMagasin());
                inv.setRemarque("Inventaire auto vide");
                InventaireFille[] invfille = new InventaireFille[getFille().length];
                for (int i = 0; i < this.getFille().length; i++) {
                    invfille[i] = new InventaireFille();
                    invfille[i].setIdInventaire(inv.getId());
                    invfille[i].setDaty(this.getDaty());
                    invfille[i].setIdProduit(((MvtStockFille)this.getFille()[i]).getIdProduit());
                    invfille[i].setExplication(inv.getRemarque());
                    invfille[i].setQuantiteTheorique(0);
                    invfille[i].setQuantite(0);
                    invfille[i].setMvtsrc(((MvtStockFille)this.getFille()[i]).getMvtSrc());
                    invfille[i].setPu(((MvtStockFille)this.getFille()[i]).getPu());
                }
                inv.setFille(invfille);
                inv.createObject(u, c);
                inv.validerObject(u, c);
            }*/
            String idObjet = getIdobjet();
//            if (idObjet != null && idObjet.startsWith("BLC")) {
//                processUpdateStockEngage(u, c);
//            }

            // createInventaireZero(u, c);
            if (this.getFabPrecedent() == null || this.getFabPrecedent().compareToIgnoreCase("") == 0) return this;
            Fabrication precedent = new Fabrication();
            precedent.setId(this.getFabPrecedent());
            FabricationFille[] ofFille = (FabricationFille[]) precedent.getFille(null, c, "");
            if (ofFille == null || ofFille == null) return this;
            Fabrication fab = new Fabrication();
            fab.setId(this.getFabPrecedent());
            //MvtStockFille[] mvtFilleFab=fab.getMvtStockFille(null,c);
            //if(MvtStock.getMvtStockEntreeCorrespondantFabFille(mvtFilleFab,ofFille)!=null) return this;
            for (int i = 0; i < fille.length; i++) {
                if (fille[i].getSortie() > 0) {
                    if (fille[i].getIdProduit().compareToIgnoreCase(ofFille[0].getIdIngredients()) == 0) {
                        MvtStock mvt = (MvtStock) this.dupliquerSansBase();
                        mvt.construirePK(c);
                        mvt.setIdobjet(this.getFabPrecedent());
                        mvt.setFabPrecedent(null);
                        mvt.setIdTypeMvStock(ConstanteStation.TYPEMVTSTOCKENTREE);
                        MvtStockFille nouveau = fille[i].contrer();
                        nouveau.setIdMvtStock(mvt.getId());
                        nouveau.construirePK(c);
                        MvtStockFille[] ln = {nouveau};
                        mvt.setFille(ln);
                        mvt.createObject(u, c);
                        mvt.validerObject(u, c);
                    }
                }
            }
            return this;
        }
//            st=c.createStatement();
//            for (int i = 0; i < fille.length; i++) {
//                fille[i].updateQteIngredientBatch(u, st);
//            }
//            st.executeBatch();
//            this.setHeure(Utilitaire.heureCouranteHMS());
//            super.validerObject(u, c);
//            this.setFille(fille);
//            String idObjet = getIdobjet();
//            if (idObjet != null && idObjet.startsWith("BLC")) {
//                processUpdateStockEngage(u, c);
//            }
//
//            // createInventaireZero(u, c);
//            if (this.getFabPrecedent() == null || this.getFabPrecedent().compareToIgnoreCase("") == 0) return this;
//            Fabrication precedent = new Fabrication();
//            precedent.setId(this.getFabPrecedent());
//            FabricationFille[] ofFille = (FabricationFille[]) precedent.getFille(null, c, "");
//            if (ofFille == null || ofFille == null) return this;
//            Fabrication fab = new Fabrication();
//            fab.setId(this.getFabPrecedent());
//            //MvtStockFille[] mvtFilleFab=fab.getMvtStockFille(null,c);
//            //if(MvtStock.getMvtStockEntreeCorrespondantFabFille(mvtFilleFab,ofFille)!=null) return this;
//            for (int i = 0; i < fille.length; i++) {
//                if (fille[i].getSortie() > 0) {
//                    if (fille[i].getIdProduit().compareToIgnoreCase(ofFille[0].getIdIngredients()) == 0) {
//                        MvtStock mvt = (MvtStock) this.dupliquerSansBase();
//                        mvt.construirePK(c);
//                        mvt.setIdobjet(this.getFabPrecedent());
//                        mvt.setFabPrecedent(null);
//                        mvt.setIdTypeMvStock(ConstanteStation.TYPEMVTSTOCKENTREE);
//                        MvtStockFille nouveau = fille[i].contrer();
//                        nouveau.setIdMvtStock(mvt.getId());
//                        nouveau.construirePK(c);
//                        MvtStockFille[] ln = {nouveau};
//                        mvt.setFille(ln);
//                        mvt.createObject(u, c);
//                        mvt.validerObject(u, c);
//                    }
//                }
//            }
//            return this;
//        }
        catch (Exception e)
        {
            e.printStackTrace();
            throw e;
        }
        finally {
            if(st!=null) st.close();
        }
    }

    public As_BondeLivraisonClient getBL(Connection c) throws Exception {
        String idObjet = getIdobjet();
        if (idObjet != null && idObjet.startsWith("BLC")) {
            return (As_BondeLivraisonClient) new As_BondeLivraisonClient().getById(idObjet, null, c);
        }

        return null;
    }

    public void processUpdateStockEngage(String u, Connection c) throws Exception {
        As_BondeLivraisonClient blAssocie = getBL(c);
        if (blAssocie == null) {
            throw new Exception("Bon de livraison associé intouvable");
        }

        String idVente = blAssocie.getIdvente();

        MvtStock mvtSearch = new MvtStock();
        mvtSearch.setIdVente(idVente);
        mvtSearch.setNomTable("stock_engage");

        MvtStock[] resultatRecherche = (MvtStock[]) CGenUtil.rechercher(mvtSearch, null, null, c, "");
        if (resultatRecherche.length == 0) {
            throw new Exception("Stock avec engagement introuvable pour le vente : " + idVente + " associé a la blc : " + getIdobjet());
        }

        MvtStock stockEngage = resultatRecherche[0];
        MvtStockFille[] stockEngageFilles = (MvtStockFille[]) stockEngage.getFille("STOCK_ENGAGE_FILLE", c, "");

        MvtStockFille[] stockFille = (MvtStockFille[]) getFille();
        for (MvtStockFille fille : stockFille) {
            boolean finded = false;
            for (MvtStockFille filleEngage : stockEngageFilles) {
                if (fille.getIdProduit().equals(filleEngage.getIdProduit())) {
                    filleEngage.setSortie(filleEngage.getSortie() - fille.getSortie());
                    if (filleEngage.getSortie() < 0) {
                        throw new Exception("Impossible de livrer une quantit\u00E9 superieure \u00E0 la quantit\u00E9 engag\u00E9e");
                    }
                    filleEngage.setNomTable("STOCK_ENGAGE_FILLE");
                    filleEngage.updateToTable(c);
                    finded = true;
                    break;
                }
            }

            if (!finded) {
                throw new Exception("Stock avec engagement introuvable pour le produit : " + fille.getIdProduit());
            }
        }
    }

    public void saveMvtStockFille(String u, Connection c) throws Exception {
        MvtStockFille[] mvtf = (MvtStockFille[]) this.getFille();
        for (int i = 0; i < mvtf.length; i++) {
            mvtf[i].setId(null);
            mvtf[i].setIdMvtStock(this.getId());
            mvtf[i].createObject(u, c);
        }
    }

    @Override
    public void controler(Connection c) throws Exception {
        super.controler(c);
        this.controlerMvt(c);
    }

    @Override
    public void controlerUpdate(Connection c) throws Exception {
        super.controlerUpdate(c);
        this.controlerMvt(c);
    }

    //    public void checkResteStock(Connection c, MvtStockFille[] fille, MvtStock mere) throws Exception {
//        for (MvtStockFille mvtFille : fille) {
//            if (mvtFille.estSuffisant(c, mere)==false) {
//                throw new Exception(String.format("quantite en stock insuffisante pour le produit %s dans le magasin", mvtFille.getIdProduit()));
//            }
//        }
//    }

    /*public void checkResteStock(Connection c, MvtStockFille[] fille, MvtStock mere) throws Exception {
        EtatStock crt=new EtatStock();
        crt.setIdMagasin(mere.getIdMagasin());
        String apresWhere=Utilitaire.tabToString(fille,"idProduit", "'",",");
        EtatStock[] etat=(EtatStock[]) CGenUtil.rechercher(crt,null,null,c," and idProduit in ("+apresWhere+")");
        String[]colEt={"idProduit"};
        String []valEt=new String[1];
        for (MvtStockFille mvtFille : fille) {

            if (!"APP".equalsIgnoreCase(mvtFille.getIdProduit()))
            {
                valEt[0]=mvtFille.getIdProduit();
                EtatStock[] filtre=(EtatStock[]) AdminGen.find(etat,colEt,valEt);
                if(filtre==null) throw new Exception("Stock inexistant");
                if (mvtFille.getSortie()>filtre[0].getReste()) {
                    throw new Exception(String.format("quantite en stock insuffisante pour le produit %s dans le magasin", mvtFille.getIdProduit()));
                }
            }

        }
    }*/
    public void checkResteStock(Connection c, MvtStockFille[] fille, MvtStock mere) throws Exception {
        for (MvtStockFille mvtFille : fille) {
            if (mvtFille.estSuffisant(c, mere) == false) {
                throw new Exception(String.format(
                        "Quantit\u00e9 en stock insuffisante pour le produit n\u00b0 %s (%s) dans le magasin.",
                        mvtFille.getIdProduit(), mvtFille.getDesignation()));
            }
        }
    }

    
    public void createGenerateMvt(String refuser, Connection c, MvtStockFille [] mvf) throws Exception{
        List<MvtStockFille[]> mvtstockfillenew= new ArrayList<MvtStockFille[]>();
        for (int i = 0; i < mvf.length; i++) {
            String apres = "";
            apres += "AND IDPRODUIT = '"+mvf[i].getIdProduit()+"' AND IDMAGASIN='"+this.getIdMagasin()+"'";
            Ingredients ing = mvf[i].getIngredient(c);
            if (ing.getTypeStock().compareToIgnoreCase("FIFO")==0) {
                apres+=" order by daty asc,id asc "; 
            }else if (ing.getTypeStock().compareToIgnoreCase("LIFO")==0){
                apres += " order by daty desc,id desc ";
            } else{
                return;
            }
            MvtStockEntreeAvecReste[] liste=this.getMvtSelonType(c, apres);
            mvtstockfillenew.add(mvf[i].genererNouveauMvt(liste));
        }
        this.deleteObjectAncien(c,mvf);
        for (MvtStockFille[] mvtStockFilles : mvtstockfillenew) {
            this.createNewSortie(refuser, mvtStockFilles, c);
        }
    }

    public MvtStockEntreeAvecReste[] getMvtSelonType(Connection c,String apres) throws Exception {
        MvtStockEntreeAvecReste search = new MvtStockEntreeAvecReste();
        search.setIdMagasin(this.getIdMagasin());
        return  (MvtStockEntreeAvecReste[]) CGenUtil.rechercher(search,null, null, apres);
    }
    
    public void deleteObjectAncien(Connection c,MvtStockFille [] mvt) throws Exception {
        for (MvtStockFille fille : mvt) {
            fille.deleteToTable(c);
        }
    }

    public void createNewSortie(String refUser, MvtStockFille[] listeMvtFille, Connection c) throws Exception {
        for (MvtStockFille fille : listeMvtFille) {
            fille.createObject(refUser,c);
        }
    }

    public Fabrication getFab(Connection c) throws Exception {
        if (this.getIdobjet() != null && this.getIdobjet().startsWith("FAB")) {
            return (Fabrication) new Fabrication().getById(this.getIdobjet(), null, c);
        }
        return null;
    }
    MvtStock contrer(Connection c) throws Exception
    {
        MvtStock retour=(MvtStock) this.dupliquerSansBase();
        MvtStockFille[] lFille=this.getMvtStockFilles(c);
        this.getMvtStockFilles(c);
        MvtStockFille[] filleAret=new MvtStockFille[lFille.length];
        retour.construirePK(c);
        for(int i=0;i<lFille.length;i++)
        {
            filleAret[i]=lFille[i].contrer();
            filleAret[i].construirePK(c);
            filleAret[i].setIdMvtStock(retour.getId());
        }
        retour.setFille(filleAret);
        if(retour.getIdTypeMvStock()!=null&&retour.getIdTypeMvStock().compareToIgnoreCase(ConstanteSocobis.TYPE_MVT_SORTIE)==0)
        {
            retour.setIdTypeMvStock(ConstanteSocobis.TYPE_MVT_ENTREE);
        }
        else if(retour.getIdTypeMvStock()!=null&&retour.getIdTypeMvStock().compareToIgnoreCase(ConstanteSocobis.TYPE_MVT_ENTREE)==0) retour.setIdTypeMvStock(ConstanteSocobis.TYPE_MVT_SORTIE);
        return retour;
    }
    EtatStock[] findEtatStockGlobale(Connection c) throws Exception
    {
        if(this.getEtatStock()!=null)return this.getEtatStock();
        EtatStock crt=new EtatStock();
        crt.setIdMagasin(this.getIdMagasin());
        MvtStockFille[] invFille=(MvtStockFille[]) this.getFille();
        String listeWhere=" and idProduit in ("+ Utilitaire.tabToString(invFille,"idProduit","'",",")+")";
        EtatStock[] retour= (EtatStock[]) CGenUtil.rechercherReq(new EtatStock(),EtatStock.getReqEtatStock(Utilitaire.dateDuJour()),c,listeWhere);
        this.setEtatStock(retour);
        return retour;
    }
    EtatStockParEntree[] findEtatStockEntree(Connection c) throws Exception{
        if(this.getEtatStockParEntree()!=null) return this.getEtatStockParEntree();
        EtatStockParEntree crt=new EtatStockParEntree();
        crt.setIdMagasin(this.getIdMagasin());
        MvtStockFille[] invFille=(MvtStockFille[]) this.getFille();
        String listeWhere=" and idProduit in ("+ Utilitaire.tabToString(invFille,"idProduit","'",",")+")";
        EtatStockParEntree[] retour= (EtatStockParEntree[]) CGenUtil.rechercherReq(crt,EtatStockParEntree.getRequeteEtatStockEntree(Utilitaire.dateDuJour()),c,listeWhere);
        this.setEtatStockParEntree(retour);
        return retour;
    }

    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }
}
