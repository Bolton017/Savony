package vente;

import bean.CGenUtil;
import bean.ClassMAPTable;
import bean.ClassMere;
import constante.ConstanteEtat;
import faturefournisseur.As_BonDeLivraison_Lib;
import magasin.Magasin;

import java.sql.Connection;
import java.sql.Date;

import produits.IngredientsLib;
import stock.MvtStock;
import stock.MvtStockFille;
import transport.CourseFille;
import utilitaire.Utilitaire;
import utils.ConstanteEtatStation;
import utils.ConstanteStation;
import utilitaire.UtilDB;   
import java.sql.Date;
import utils.ConstanteSocobis;
import utils.ConstanteEtatStation;

public class As_BondeLivraisonClient extends ClassMere{
    String id , remarque,idbc,magasin,idvente,idorigine, idclient;
    Date daty;
    int etat;
    String idClient,vehicule,chauffeur,description;
    String lieudelivraison;

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getVehicule() {
        return vehicule;
    }

    public void setVehicule(String vehicule) {
        this.vehicule = vehicule;
    }

    public String getChauffeur() {
        return chauffeur;
    }

    public void setChauffeur(String chauffeur) {
        this.chauffeur = chauffeur;
    }

    public String getIdClient() {
        return idClient;
    }

    public void setIdClient(String idClient) {
        this.idClient = idClient;
    }

    public String getLieudelivraison() {
        return lieudelivraison;
    }

    public void setLieudelivraison(String lieudelivraison) {
        this.lieudelivraison = lieudelivraison;
    }

    public As_BondeLivraisonClient() throws Exception{
        this.setNomTable("AS_BONDELIVRAISON_CLIENT");
	 setNomClasseFille("vente.As_BondeLivraisonClientFille");
	 setLiaisonFille("numbl");
    }

    public void construirePK(Connection c)throws Exception{
        this.preparePk("BLC","get_seqASBONDELIVRAISONCLIENT");
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
    public String getNomClasseFille() {
        return ("vente.As_BondeLivraisonClientFille");
    }

    @Override
    public String getLiaisonFille() {
        return "numbl"  ;
    }

    public String getId() {
        return id;
    }
    public void setId(String id) {
        this.id = id;
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
    public String getMagasin() {
        return magasin;
    }
    public void setMagasin(String magasin) {
        this.magasin = magasin;
    }
    public String getIdvente() {
        return idvente;
    }
    public void setIdvente(String idvente) {
        this.idvente = idvente;
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

    public String getIdorigine() {
        return idorigine;
    }

    public void setIdorigine(String idorigine) {
        this.idorigine = idorigine;
    }

    public String getIdclient() {
        return idclient;
    }

    public void setIdclient(String idclient) {
        this.idclient = idclient;
    }

    public MvtStock genererMvtStock(Connection c)throws Exception
    {
        boolean estOuvert=false;
        try
        {
            if(c==null)
            {
                c=new UtilDB().GetConn();
                estOuvert=true;
            }
            
            
            As_BondeLivraisonClient bl = (As_BondeLivraisonClient) this.getById(this.getId(),"AS_BONDELIVRAISON_CLIENT",c);           
            
            MvtStock mv=new MvtStock();
            mv.setIdobjet(bl.getId());
            mv.setDaty(bl.getDaty());
            mv.setDesignation("Mouvement de stock relatif "+this.getId());
            mv.setIdPoint(bl.getMagasin());
            mv.setIdTypeMvStock(ConstanteSocobis.TYPE_MVT_SORTIE);
            mv.setIdTransfert(bl.getId());
            mv.setIdVente(bl.getIdvente());
            
            mv.setIdMagasin(bl.getMagasin());
            As_BondeLivraisonClientFille_Cpl[] listeF=(As_BondeLivraisonClientFille_Cpl[]) this.getListeFilleCpl("rapprochement_bf_client",c);
            MvtStockFille[]lf=new MvtStockFille[listeF.length];
            for(int i=0;i<listeF.length;i++) {
                lf[i]=listeF[i].genererMvtStockFille();
		        lf[i].setIdMvtStock(mv.getId());
                IngredientsLib ing = new IngredientsLib();
                ing = (IngredientsLib) ing.getById(listeF[i].getProduit(),"ST_INGREDIENTSAUTO",c);
                lf[i].setIdUniteLib(ing.getUniteLib());
            }
            mv.setFille(lf);
            return mv;
        }
        catch(Exception e)
        {
            throw e;
        }
        finally
        {
            if(c!=null&&estOuvert==true)c.close();
        }
    }
    public VenteDetails[] getListeVenteDetails(String nTBLFille, Connection c)throws Exception{

        As_BondeLivraisonClientFille crt = new As_BondeLivraisonClientFille();
        crt.setNumbl(this.getId());
        if(nTBLFille!=null && nTBLFille.compareTo("")!=0){
            crt.setNomTable(nTBLFille);
        }
        As_BondeLivraisonClientFille[] blf = (As_BondeLivraisonClientFille[])CGenUtil.rechercher(crt, null,null,c,"");
        VenteDetails[] v = new VenteDetails[blf.length];
        for(int i =0; i<blf.length;i++){
            v[i]=blf[i].genererVenteDetails();
        }
        return v;
    }
    public void genererMvtStockPersist(String user)throws Exception
    {
	 boolean estOuvert=false;
	 Connection c=null;
        try
        {
            if(c==null){
                c=new UtilDB().GetConn();
                estOuvert=true;
            }
	     As_BondeLivraisonClient blc=(As_BondeLivraisonClient)this.getById(this.getId(),null,c);
	     MvtStock mvt=blc.genererMvtStock(c);
        //  mvt.setEtat(ConstanteEtat.getEtatValider());
        mvt.createObjectMultiple(user,c);
        mvt.validerObject(user, c);
	     /*MvtStockFille[] filles=(MvtStockFille[])mvt.getFille();
	     for( MvtStockFille lf:filles)
	     {
		  lf.setIdMvtStock(mvt.getId());
		  lf.createObject(user, c);
	     }*/
	 }
	 catch(Exception e){
            throw e;
        }
        finally
        {
            if(c!=null&&estOuvert==true)c.close();
        }
    }
    
    public static void controlerClient(As_BondeLivraisonClient[] bls)throws Exception{
        String idClient = "";
        for(As_BondeLivraisonClient item : bls){
            if(idClient.equals("") == false){
                if(idClient.equals(item.getIdClient()) == false){
                    throw new Exception("Tiers different");
                }
            }
            idClient = item.getIdClient();
        }
    }
    
    public static As_BondeLivraisonClient[] getAll(String[] ids, Connection co)throws Exception{
        As_BondeLivraisonClient bl = new As_BondeLivraisonClient();
        As_BondeLivraisonClient[] bls = (As_BondeLivraisonClient[]) CGenUtil.rechercher(bl, null, null,co, " and id in "+Utilitaire.tabToString(ids, "'", ","));
        return bls;
    }

    public As_BondeLivraisonClientFille_Cpl[] getListeFilleCpl(String nTBLFille, Connection c)throws Exception{
        As_BondeLivraisonClientFille_Cpl crt = new As_BondeLivraisonClientFille_Cpl();
        crt.setNumbl(this.getId());
        if(nTBLFille!=null && nTBLFille.compareTo("")!=0){
            crt.setNomTable(nTBLFille);
        }
        As_BondeLivraisonClientFille_Cpl[] blf = (As_BondeLivraisonClientFille_Cpl[])CGenUtil.rechercher(crt, null,null,c,"");
        return blf;
    }

    public void controleLivraison(Connection c) throws Exception{
        As_BondeLivraisonClientFille [] filles = (As_BondeLivraisonClientFille []) this.getFille();
        VenteDetailsLib vLib = new VenteDetailsLib();
        vLib.setNomTable("VENTE_DETAILS_RESTE");
        VenteDetailsLib[] details = (VenteDetailsLib[]) CGenUtil.rechercher(vLib,null,null,c," AND idVente='"+this.getIdvente()+"' AND reste > 0");
        for (int i = 0; i < details.length; i++) {
            for (int j = 0; j < filles.length; j++) {
                System.err.println(details[i].getIdProduit().compareToIgnoreCase(filles[j].getProduit())+"==============>"+filles[j].getQuantite()+">"+details[i].getReste());
                if(details[i].getIdUnite()!=null && filles[j].getUnite()!=null){
                    if(details[i].getIdProduit().compareToIgnoreCase(filles[j].getProduit())==0 && details[i].getIdUnite().compareToIgnoreCase(filles[j].getUnite())==0 && filles[j].getQuantite()>details[i].getReste()){
                        throw new Exception("Quantit\u00E9 \u00E0 livrer inf\u00E9rieur \u00E0 la quantit\u00E9 livr\u00E9e");
                    }
                }else {
                    throw new Exception("V&eacute;rifier les unit&eacute;s des produits");
                }
            }
        }
    }

    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {
        controleLivraison(c);
        if (this.getIdvente()!= null && !this.getIdvente().isEmpty()){
            Vente v = Vente.getById(c,this.getIdvente());
            if (v != null && v.getIdOrigine() != null) {
                this.setIdbc(v.getIdOrigine());
            }
        }
        return super.createObject(u, c);
    }
    public void validerPreparation(String u,Connection c) throws Exception{
            boolean estOuvert=false;
            try
                {
                    if(c==null){
                        c=new UtilDB().GetConn();
                        estOuvert=true;
                    }
                    if(this.getEtat() > ConstanteEtatStation.getEtatPreparer()){
                        throw new Exception("Impossible de preparer une bon de livraison d\\u00e9j\\u00E0 valid\\u00e9e");
                    }
                    else{
                        this.updateEtat(ConstanteEtatStation.getEtatPreparer(), this.getId(), c);
                    }
                }
                catch(Exception e){
                    throw e;
                }
                finally
                {
                    if(c!=null&&estOuvert==true)c.close();
            }
        
    }
    @Override
    public Object validerObject(String u, Connection c) throws Exception {
        As_BondeLivraisonClient o =
            (As_BondeLivraisonClient) super.validerObject(u, c);
        o.updateEtat(ConstanteEtat.getEtatValider(), o.getId(), c);
        // o.genererMvtStockBL(u,c);
        return o;
    }
    public void genererMvtStockBL(String u,Connection c)throws Exception
    {
        boolean estOuvert=false;
        try
        {
            if(c==null)
            {
                c=new UtilDB().GetConn();
                estOuvert=true;
            }
            As_BondeLivraisonClient bl = this;

            MvtStock mv=new MvtStock();
            mv.setIdobjet(bl.getId());
            mv.setDaty(bl.getDaty());
            mv.setDesignation("Mouvement de stock relatif "+bl.getId());
            Magasin p = (Magasin) new Magasin().getById(bl.getMagasin(),"magasin",c);
            if(p!=null){
                mv.setIdPoint(p.getIdPoint());
            }
            mv.setIdTypeMvStock(ConstanteSocobis.TYPE_MVT_SORTIE);
            mv.setIdTransfert(bl.getId());
            mv.setIdVente(bl.getIdvente());
            mv.setIdMagasin(bl.getMagasin());
            mv.insertToTableWithHisto(u, c);
            As_BondeLivraisonClientFille_Cpl[] listeF=
                (As_BondeLivraisonClientFille_Cpl[]) this.getListeFilleCpl("RAPPROCHEMENT_BF_CLIENT_2",c);

            MvtStockFille[] lf=new MvtStockFille[listeF.length];
            for(int i=0;i<listeF.length;i++) {
                lf[i]=listeF[i].genererMvtStockFille();
                lf[i].setIdMvtStock(mv.getId());
                lf[i].insertToTableWithHisto(u, c);
            }
            mv.updateEtat(ConstanteEtat.getEtatValider(), mv.getId(), c);
            //mv.setFille(lf);
        }
        finally
        {
            if(c!=null&&estOuvert==true)c.close();
        }
    }

    public CourseFille[] creeCourseFilles(String[] ids, Connection c) throws Exception{
        CourseFille[] courseFilles = new CourseFille[ids.length];
        for (int i = 0; i < ids.length; i++) {
            As_BondeLivraisonClient bonLivraison = (As_BondeLivraisonClient) new As_BondeLivraisonClient().getById(ids[i], "AS_BONDELIVRAISON_CLIENT", c);
            CourseFille courseFille = new CourseFille();
            courseFille.setIdobjet(bonLivraison.getId());
            courseFille.setRemarque(bonLivraison.getRemarque());
            courseFilles[i] = courseFille;
        }
        return courseFilles;
    }

}
