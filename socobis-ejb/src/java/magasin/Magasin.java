/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package magasin;

import annexe.Produit;
import bean.CGenUtil;
import bean.ClassMAPTable;
import inventaire.Inventaire;
import inventaire.InventaireFille;
import java.sql.Connection;
import java.sql.Date;
import java.time.LocalDateTime;
import utilitaire.Utilitaire;
import utils.ConstanteStation;
import utils.ConstanteEtatCustom;


public class Magasin extends ClassMAPTable{
    
    private String id, val, desce, idPoint,idPointlib, idTypeMagasin,idTypeMagasinlib, idProduit,idProduitlib, idMagasinMere,idMagasinMereLib,idDepartement, idDepartementLib;
    public  static Magasin magasinDefaut;
    private double capacite, compteur;
    private int isVente;

    public String getIdDepartement() {
        return idDepartement;
    }

    public void setIdDepartement(String idDepartement) {
        this.idDepartement = idDepartement;
    }

    public int getIsVente() {
        return isVente;
    }

    public void setIsVente(int isVente) {
        this.isVente = isVente;
    }

    public String getIdMagasinMereLib() {
        return idMagasinMereLib;
    }

    public void setIdMagasinMereLib(String idMagasinMereLib) {
        this.idMagasinMereLib = idMagasinMereLib;
    }

    public Magasin(){
        this.setNomTable("magasin2");
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdMagasinMere() {
        return idMagasinMere;
    }

    public void setIdMagasinMere(String idMagasinMere) {
        this.idMagasinMere = idMagasinMere;
    }

    public double getCapacite() {
        return capacite;
    }

    public void setCapacite(double capacite) {
        this.capacite = capacite;
    }

    public double getCompteur() {
        return compteur;
    }

    public void setCompteur(double compteur) {
        this.compteur = compteur;
    }

    public String getVal() {
        return val;
    }

    public void setVal(String val) {
        this.val = val;
    }

    public String getDesce() {
        return desce;
    }

    public void setDesce(String desce) {
        this.desce = desce;
    }

    public String getIdPoint() {
        return idPoint;
    }

    public void setIdPoint(String idPoint) {
        this.idPoint = idPoint;
    }

    public String getIdTypeMagasin() {
        return idTypeMagasin;
    }

    public void setIdTypeMagasin(String idTypeMagasin) {
        this.idTypeMagasin = idTypeMagasin;
    }

    public String getIdProduit() {
        return idProduit;
    }

    public void setIdProduit(String idProduit) {
        this.idProduit = idProduit;
    }

    public String getIdPointlib() {
        return idPointlib;
    }

    public void setIdPointlib(String idPointlib) {
        this.idPointlib = idPointlib;
    }

    public String getIdTypeMagasinlib() {
        return idTypeMagasinlib;
    }

    public void setIdTypeMagasinlib(String idTypeMagasinlib) {
        this.idTypeMagasinlib = idTypeMagasinlib;
    }

    public String getIdProduitlib() {
        return idProduitlib;
    }

    public void setIdProduitlib(String idProduitlib) {
        this.idProduitlib = idProduitlib;
    }


    public String getIdDepartementLib() {
        return idDepartementLib;
    }

    public void setIdDepartementLib(String idDepartementLib) {
        this.idDepartementLib = idDepartementLib;
    }

    public Magasin[] getMagasinDefaut()throws Exception{
        Magasin magasin = new Magasin();
        Magasin[] listeMagasin=new Magasin[0];
        if(magasinDefaut == null ){
            listeMagasin = (Magasin[])CGenUtil.rechercher(magasin, "and etat = " + ConstanteEtatCustom.PAYE_NON_LIVRE);
        } 
        return listeMagasin;
    }
    @Override
    public String getTuppleID() {
        return id;
    }
    
    
    @Override
    public String getValColLibelle() {
        return this.val;
    }
     @Override
    public String[] getMotCles() {
        return new String[]{"id","val"};
    }
     @Override
    public String[] getValMotCles() {
        String[] valMotCles={"id","val"};
        return valMotCles;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("MAG", "GETSEQMAGASIN");
        this.setId(makePK(c));
    }
    protected void controlerMagasin(Connection c) throws Exception {
        if (this.getIdTypeMagasin().compareToIgnoreCase(ConstanteStation.idTypeReservoir) == 0) {
            if (!this.getIdProduit().isEmpty()) { 
                Produit[] produit = (Produit[]) CGenUtil.rechercher(new Produit(), null, null, c, " and id='" + this.getIdProduit() + "'");
                if (produit.length > 0) {
                    if (produit[0].getIdTypeProduit().compareToIgnoreCase(ConstanteStation.idTypeCarburant) != 0)
                        throw new Exception("Le type du produit est un carburant");
                } 
            }
        }
    }
    
    @Override
    public void controler(Connection c) throws Exception {
         super.controler(c);
         this.controlerMagasin(c);
    }
    
    @Override
    public void controlerUpdate(Connection c) throws Exception {
        super.controlerUpdate(c);
        this.controlerMagasin(c);
    }
    
    
    
    public void createInventaireZero (String u, Connection c) throws Exception
    {
        if (this.getIdTypeMagasin().compareToIgnoreCase(ConstanteStation.idTypeReservoir) == 0)
        {
            Inventaire inv =(Inventaire)this.generateInventaireMere().createObject(u, c);
            InventaireFille invF=inv.generateInventaireFilleZero();
            invF.setIdProduit(this.getIdProduit()); 
            invF.createObject(u, c);  
            inv.validerObject(u, c);
        }
       
    }
    
    
    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {
        Magasin m=(Magasin)super.createObject(u, c);
        m.createInventaireZero(u, c);
        return m;
        
        
    }
    
    public Inventaire generateInventaireMere () throws Exception
    {
        Inventaire inv =new Inventaire();
        Date datedujour = Utilitaire.dateDuJourSql();
        LocalDateTime localDateTime = datedujour.toLocalDate().atStartOfDay().minusDays(1);
        Date datehier = Date.valueOf(localDateTime.toLocalDate());
        inv.setDaty(datehier);
        inv.setIdMagasin(this.getId());
        inv.setDesignation("inventaire zero");
        inv.setRemarque("inventaire zero");
        return inv;
    }
    
  
   
    
    
}
