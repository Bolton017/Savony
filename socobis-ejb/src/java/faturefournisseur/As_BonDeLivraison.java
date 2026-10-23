/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package faturefournisseur;

import bean.AdminGen;
import bean.CGenUtil;
import bean.ClassMere;
import java.sql.Connection;
import java.sql.Date;
import java.util.Vector;

import avoir.AvoirFCLib;
import produits.IngredientsLib;
import stock.MvtStock;
import stock.MvtStockFille;
import transport.Course;
import transport.CourseFille;
import utilitaire.Utilitaire;
import utils.ConstanteEtatStation;
import utils.ConstanteSocobis;
import utils.ConstanteStation;
import vente.As_BondeLivraisonClient;
import utilitaire.UtilDB;   
import constante.ConstanteEtat;
import magasin.Magasin;
import produits.Ingredients;
/**
 *
 * @author Mirado
 */
public class As_BonDeLivraison extends ClassMere{
    
    String id,remarque,idbc;
    Date daty;
    int etat;
    String magasin;
    String idFournisseur;
    String idFactureFournisseur;

    public As_BonDeLivraison() throws Exception {
        this.setNomTable("AS_BONDELIVRAISON");
        this.setLiaisonFille("numbl");
	    // this.setNomClasseFille("faturefournisseur.As_BonDeLivraison_Fille");
       setNomClasseFille("faturefournisseur.As_BonDeLivraison_Fille");
    }
    
    public void construirePK(Connection c) throws Exception{
        this.preparePk("BL", "GETSEQBONDELIVRAISON");
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

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public void setIdFactureFournisseur(String idFactureFournisseur) {
        this.idFactureFournisseur = idFactureFournisseur;
    }

    public String getIdFactureFournisseur() {
        return idFactureFournisseur;
    }

    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }

    public String getIdbc() {
        return idbc;
    }

    public void setIdbc(String idbc) {
        this.idbc = idbc;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public int getEtat() {
        return etat;
    }

    public void setEtat(int etat) {
        this.etat = etat;
    }

    public String getMagasin() {
        return magasin;
    }

    public void setMagasin(String magasin) {
        this.magasin = magasin;
    }
    @Override
    public String getLiaisonFille() {
        return "numbl";
    }
    @Override
    public String getNomClasseFille() {
        return "faturefournisseur.As_BonDeLivraison_Fille";
    }

    public As_BonDeLivraison_Fille[] getBonDeLivraisonFille(Connection c) throws Exception {
        As_BonDeLivraison_Fille abfCrt=new As_BonDeLivraison_Fille();
        abfCrt.setNumbl(this.getId());
        As_BonDeLivraison_Fille[] abf=(As_BonDeLivraison_Fille[]) CGenUtil.rechercher(abfCrt , null, null, c, " ");
        return abf;
    }

    public As_BonDeLivraison_Fille[] getBonDeLivraisonFille(Connection c, String nt) throws Exception {
        As_BonDeLivraison_Fille abfCrt=new As_BonDeLivraison_Fille();
        abfCrt.setNumbl(this.getId());
        if (!Utilitaire.champNull(nt).isEmpty()) {
            abfCrt.setNomTable(nt);
        }
        return (As_BonDeLivraison_Fille[]) CGenUtil.rechercher(abfCrt , null, null, c, "");
    }

    public MvtStock createMvtStock() throws Exception{
        MvtStock ms=new MvtStock();
        ms.setDesignation("livraison "+this.getRemarque());
        ms.setIdTypeMvStock(ConstanteStation.TYPEMVTSTOCKENTREE);
        ms.setIdMagasin(this.getMagasin());
        ms.setDaty(Utilitaire.dateDuJourSql());
        ms.setIdTransfert(this.getId());
        return ms;
    }

    public MvtStockFille[] createMvtStockFille(Connection c,String idMere)throws Exception{
        boolean estOuvert = false;
        try {
            if(c==null){
                c = new UtilDB().GetConn();
                estOuvert = true;
            }
            As_BonDeLivraison_Fille[] fille = getBonDeLivraisonFille(c);
            MvtStockFille[] mvtStockFilles = new MvtStockFille[fille.length];
            int index=0;
            for (As_BonDeLivraison_Fille bLivraison_Fille : fille) {
                MvtStockFille f = new MvtStockFille();
                f.setIdProduit(bLivraison_Fille.getProduit());
                f.setEntree(bLivraison_Fille.getQuantite());
                f.setSortie(0);
                f.setIdTransfertDetail(bLivraison_Fille.getId());
                f.setIdMvtStock(idMere);
                mvtStockFilles[index]= f;
                index++;
            }
            return mvtStockFilles;
        } catch (Exception e) {
            throw e;
        }finally{
            if(estOuvert) c.close();
        }
    }

    public String getIdFournisseur() {
        return idFournisseur;
    }

    public void setIdFournisseur(String idFournisseur) throws Exception {
        if( this.getMode().equals("modif") && idFournisseur!=null && idFournisseur.isEmpty() ){
            throw new Exception("Le Fournisseur ne doit pas etre null");
        }
        this.idFournisseur = idFournisseur;
    }
    
    public MvtStock genereMvtStock( Connection c ) throws Exception{
        boolean connectionWasOpenedInside = false;
        try{
            if( c == null ){
                c = new UtilDB().GetConn();
                connectionWasOpenedInside = true;
            }

            As_BonDeLivraison_Fille_Cpl[] filles = (As_BonDeLivraison_Fille_Cpl[]) this.getBonDeLivraisonFilleCpl("rapprochement_bf_fournisseur", c);
            MvtStock mouvement = new MvtStock();
            mouvement.setIdobjet(this.getId());
            mouvement.setDaty(this.getDaty());
            mouvement.setDesignation("Mouvement de Stock pour " + this.getId());
            Magasin mg=(Magasin) new Magasin().getById(this.getMagasin(), "Magasin2", c);
            mouvement.setIdPoint(mg.getIdPoint());
            mouvement.setIdMagasin(this.getMagasin());
            mouvement.setIdTypeMvStock(ConstanteSocobis.TYPE_MVT_ENTREE);
            mouvement.setIdTransfert(this.getId());
            mouvement.setHeure(Utilitaire.heureCouranteHMS());
            mouvement.setIdCategorieStock(ConstanteSocobis.ID_CATEGORIESTOCK_NORMAL);
            // Maintenant micreer mouvement fille hoan 'ireo'

            MvtStockFille[] mouvements = new MvtStockFille[filles.length];
            for( int i = 0; i < filles.length ; i++ ){
                mouvements[i] = filles[i].createMvtStockFille();
                mouvements[i].setIdMvtStock(mouvement.getId());
                IngredientsLib ing = new IngredientsLib();
                ing = (IngredientsLib) ing.getById(filles[i].getProduit(),"ST_INGREDIENTSAUTO",c);
                mouvements[i].setIdUniteLib(ing.getUniteLib());
            }
            mouvement.setFille(mouvements);
            return mouvement;

        }catch(Exception e){
            throw e;
        }finally{
            if( connectionWasOpenedInside ){
                c.close();
            }
        }
    }

    public void genererMvtStockPersist( String refUser ) throws Exception{
        Connection connection = null;
        boolean isOpened = false;
        try{
            if( connection == null ){
                connection = new UtilDB().GetConn();
                isOpened = true;
            }
            As_BonDeLivraison blc=(As_BonDeLivraison) this.getById(this.getId(),null,connection);
            blc.setNomClasseFille("faturefournisseur.As_BonDeLivraison_Fille");
	        MvtStock mvt = blc.genereMvtStock(connection);

        }catch(Exception e){
            throw e;
        } finally {
            if (isOpened)
                connection.close();
        }
    }

    public static As_BonDeLivraison[] getAll(String[] ids, Connection co) throws Exception {
        As_BonDeLivraison bl = new As_BonDeLivraison();
        As_BonDeLivraison[] bls = (As_BonDeLivraison[]) CGenUtil.rechercher(bl, null, null, co,
                " and id in (" + Utilitaire.tabToString(ids, "'", ",")+ ")");
        return bls;
    }

    public static void controlerFournisseur(As_BonDeLivraison[] bls) throws Exception {
        String idFournisseur = "";
        for (As_BonDeLivraison item : bls) {
            if (idFournisseur.equals("") == false) {
                if (idFournisseur.equals(item.getIdFournisseur()) == false) {
                    throw new Exception("Tiers different");
                }
            }
            idFournisseur = item.getIdFournisseur();
        }
    }

    public FactureFournisseurDetails[] getDetailsFacturePrest(String idBL, Connection c) throws Exception {
        Vector<FactureFournisseurDetails> allDetails = new Vector<>();
        boolean connectionWasOpenedInside = false;

        try {
            if (c == null) {
                c = new utilitaire.UtilDB().GetConn();
                connectionWasOpenedInside = true;
            }

            this.setId(idBL);
            As_BonDeLivraison[] searchBL = (As_BonDeLivraison[]) CGenUtil.rechercher(this, null, null, c,"");
            if (searchBL == null || searchBL.length == 0) return new FactureFournisseurDetails[0];

            As_BonDeLivraison bl = searchBL[0];
            As_BonDeLivraison_Fille[] blFilles = bl.getBonDeLivraisonFille(c);

            for (As_BonDeLivraison_Fille blFille : blFilles) {
                FactureFournisseurDetails[] detailsFille = blFille.toFactureFournisseurPrestataire(c);
                if (detailsFille != null) {
                    for (FactureFournisseurDetails d : detailsFille) {
                        allDetails.add(d);
                    }
                }
            }

            FactureFournisseurDetails[] result = new FactureFournisseurDetails[allDetails.size()];
            allDetails.copyInto(result);
            return result;

        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        } finally {
            if (connectionWasOpenedInside && c != null) {
                try {
                    c.close();
                } catch (Exception ce) {
                    ce.printStackTrace();
                }
            }
        }
    }

    public FactureFournisseurDetails[] getDetailsFacture(String idBL, Connection c) throws Exception {
        boolean connectionWasOpenedInside = false;

        try {
            if (c == null) {
                c = new utilitaire.UtilDB().GetConn();
                connectionWasOpenedInside = true;
            }

            this.setId(idBL);
            As_BonDeLivraison[] searchBL = (As_BonDeLivraison[]) CGenUtil.rechercher(this, null, null,c, "");
            if (searchBL == null || searchBL.length == 0) return new FactureFournisseurDetails[0];

            As_BonDeLivraison bl = searchBL[0];
            Fournisseur fournisseur = new Fournisseur();
            fournisseur.setId(bl.getIdFournisseur());

            Fournisseur[] searchFournisseur = (Fournisseur[]) CGenUtil.rechercher(fournisseur, null, null, c,"");
            if (searchFournisseur == null || searchFournisseur.length == 0) return new FactureFournisseurDetails[0];

            fournisseur = searchFournisseur[0];
            As_BonDeCommande_Fille[] bcFilles = null;

            String deviseFacture = "AR";
            if (bl.getIdbc() != null && !bl.getIdbc().isEmpty()) {
                As_BonDeCommande bonDeCommande = new As_BonDeCommande();
                As_BonDeCommande bc = (As_BonDeCommande) bonDeCommande.getById(bl.getIdbc(), "AS_BONDECOMMANDE", null);
                if (bc != null && bc.getIdDevise() != null) {
                    deviseFacture = bc.getIdDevise();
                }
            }

            if (searchBL[0].getIdbc() != null) {
                As_BonDeCommande_Fille bcFille = new As_BonDeCommande_Fille();
                bcFille.setIdbc(searchBL[0].getIdbc());
                bcFilles = (As_BonDeCommande_Fille[]) CGenUtil.rechercher(bcFille,null,null,c,"");
            }

            if ("TPF002".equalsIgnoreCase(fournisseur.getIdTypeFournisseur())) {
                return getDetailsFacturePrest(idBL, c);
            } else {
                As_BonDeLivraison_Fille[] blFilles = bl.getBonDeLivraisonFille(c,"AS_BL_FILLE_AUTOCOMPLETE");
                FactureFournisseurDetails[] detailsFille = new FactureFournisseurDetails[blFilles.length];
                for (int i = 0; i < blFilles.length; i++) {
                    detailsFille[i] = blFilles[i].toFactureFournisseurDetails();
                    detailsFille[i].setIdDevise(deviseFacture);

                    String idProduit = blFilles[i].getProduit();
                    if (idProduit != null && idProduit.contains("---")) {
                        idProduit = idProduit.split("---")[0];
                    }
                    Ingredients produit = (Ingredients) new Ingredients().getById(idProduit, "AS_INGREDIENTS", c);
                    if (produit != null) {
                        detailsFille[i].setCompte(produit.getCompte_achat());
                    }

                    if (bcFilles != null && bcFilles.length > 0) {
                        String[] attribut = {"id"};
                        String[] val = {blFilles[i].getIdbc_fille()};
                        As_BonDeCommande_Fille bcFille = (As_BonDeCommande_Fille) AdminGen.findUnique(bcFilles,attribut,val);
                        if (bcFille != null) {
                            detailsFille[i].setPu(bcFille.getPu());
                            detailsFille[i].setTva(bcFille.getTva());
                            detailsFille[i].setRemise(bcFille.getRemise());
                            detailsFille[i].setMontantRemise(bcFille.getRemiseMontant());
                            if (bcFille.getTauxDeChange() > 0) {
                                detailsFille[i].setTauxDeChange(bcFille.getTauxDeChange());
                            }
                        }
                    }
                }
                return detailsFille;
            }


        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        } finally {
            if (connectionWasOpenedInside && c != null) {
                try {
                    c.close();
                } catch (Exception ce) {
                    ce.printStackTrace();
                }
            }
        }

    }
    public As_BonDeLivraison_Fille_Cpl[] getBonDeLivraisonFilleCpl(String nTBLFille, Connection c) throws Exception {
        As_BonDeLivraison_Fille_Cpl abfCrt = new As_BonDeLivraison_Fille_Cpl();
        abfCrt.setNumbl(this.getId());
        if(nTBLFille!=null && nTBLFille.compareTo("")!=0){
            abfCrt.setNomTable(nTBLFille);
        }
        As_BonDeLivraison_Fille_Cpl[] abf = (As_BonDeLivraison_Fille_Cpl[]) CGenUtil.rechercher(abfCrt, null, null, c, " ");
        return abf;
    }
    public MvtStock genererMvtStockPersist1( String refUser ) throws Exception{
        Connection connection = null;
        boolean isOpened = false;
        try{
            if( connection == null ){
                connection = new UtilDB().GetConn();
                isOpened = true;
            }
            As_BonDeLivraison blc=(As_BonDeLivraison) this.getById(this.getId(),null,connection);
            blc.setNomClasseFille("faturefournisseur.As_BonDeLivraison_Fille");
	        MvtStock mvt = blc.genereMvtStock(connection);
            mvt.setEtat(ConstanteEtat.getEtatCreer());
	        return mvt;

        }catch(Exception e){
            throw e;
        } finally {
            if (isOpened)
                connection.close();
        }
    }
    
    public FactureFournisseur genererFacture() throws Exception {
        FactureFournisseur fact = new FactureFournisseur();
        fact.setDesignation("Facturation de la commande num "+this.getId());
        fact.setIdFournisseur(this.getIdFournisseur());
        fact.setDaty(this.getDaty());
        fact.setIdMagasin(this.getMagasin());
        fact.setIdObjet(this.getId());
        fact.setIdDevise("AR");

        if (this.getIdbc() != null && !this.getIdbc().isEmpty()) {
            As_BonDeCommande  bonDeCommande = new As_BonDeCommande();
            As_BonDeCommande bc = (As_BonDeCommande) bonDeCommande.getById(this.getIdbc(),"AS_BONDECOMMANDE",null);
            fact.setIdDevise(bc.getIdDevise());
        }

        return fact;
    }

    public CourseFille[] creeCourseFilles(String[] ids, Connection c) throws Exception{
        CourseFille[] courseFilles = new CourseFille[ids.length];
        for (int i = 0; i < ids.length; i++) {
            As_BonDeLivraison_Lib bonLivraison = (As_BonDeLivraison_Lib) new As_BonDeLivraison_Lib().getById(ids[i], "AS_BONDELIVRAISON_lib", c);
            if(bonLivraison!=null) {
                CourseFille courseFille = new CourseFille();
                courseFille.setIdobjet(bonLivraison.getId());
                courseFille.setRemarque(bonLivraison.getRemarque());
                courseFilles[i] = courseFille;
            }
        }
        return courseFilles;
    }

    public boolean isgenerateStock() throws Exception {
        MvtStock[] mvt = (MvtStock[]) CGenUtil.rechercher(new MvtStock(), null, null, null, " and IDOBJET ='" + this.getId() + "'");
        if (mvt.length > 0) {
            return true;
        }
        return false;
    }

}
