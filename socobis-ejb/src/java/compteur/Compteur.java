package compteur;

import bean.CGenUtil;
import bean.ClassEtat;
import bean.ClassMAPTable;
import charge.Charge;
import fabrication.Fabrication;
import fabrication.FabricationFille;
import fabrication.ProcessFab;
import faturefournisseur.As_BonDeLivraison;
import magasin.Magasin;
import produits.Ingredients;
import produits.IngredientsLib;
import stock.MvtStock;
import stock.MvtStockFille;
import utilitaire.ConstanteEtat;
import utilitaire.UtilDB;
import utils.ConstanteProcess;

import java.util.ArrayList;
import java.util.List;
import utils.ConstanteSocobis;
import vente.As_BondeLivraisonClient;

import java.sql.Connection;
import java.sql.Date;

public class Compteur extends ClassEtat {
    private String id, idFabrication, idMachine, heure, idOrigine;
    private double nombre, debut;
    private Date daty;

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
        this.preparePk("COMPT", "getseqCOMPTEUR");
        this.setId(makePK(c));
    }

    public Compteur(){
        this.setNomTable("COMPTEUR");
    }

    public String getId() {
        return id;
    }

    public String getIdOrigine() {
        return idOrigine;
    }

    public void setIdOrigine(String idOrigine) {
        this.idOrigine = idOrigine;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdFabrication() {
        return idFabrication;
    }

    public void setIdFabrication(String idFabrication) {
        this.idFabrication = idFabrication;
    }

    public String getIdMachine() {
        return idMachine;
    }

    public void setIdMachine(String idMachine) {
        this.idMachine = idMachine;
    }

    public String getHeure() {
        return heure;
    }

    public void setHeure(String heure) {
        this.heure = heure;
    }

    public double getNombre() {
        return nombre;
    }

    public void setNombre(double nombre) {
        this.nombre = nombre;
    }

    public double getDebut() {
        return debut;
    }

    public void setDebut(double debut) {
        this.debut = debut;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public Compteur getCompteurLast(Connection c, String idMachine)throws Exception{
        boolean estOuvert = false;
        try {
            if(c==null){
                estOuvert = true;
                c = new UtilDB().GetConn();
            }
            Compteur rep= null;
            Compteur cmp = new Compteur();
            cmp.setNomTable("COMPTEUR");
            cmp.setIdMachine(idMachine);
            Compteur[] list = (Compteur[]) CGenUtil.rechercher(cmp, null, null,c, " AND ETAT >= 11 ORDER BY ID, DATY ASC");
            if(list != null && list.length > 0) {
                rep = (Compteur) list[0];
            }else{
                return this;
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

    /*public Fabrication[] getListeFabricationMachine(Connection c)throws Exception{
        boolean estOuvert = false;
        try {
            if(c==null){
                estOuvert = true;
                c = new UtilDB().GetConn();
            }
            Compteur compteurLast= this.getCompteurLast(c, this.getIdMachine());
            Fabrication map = new Fabrication();
            String awh = "and daty >= TO_DATE('"+ compteurLast.getDaty() +"','YYYY-MM-DD') and daty <= TO_DATE('"+ this.getDaty() +"','YYYY-MM-DD')";
            Fabrication[] list = (Fabrication[]) CGenUtil.rechercher(map, null, null, awh);
            return list;
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception(e.getMessage());
        } finally {
            if(estOuvert && c!=null){
                c.close();
            }
        }
    }*/

    public String[] getListeIDFabricationMachine(Connection c)throws Exception{
        boolean estOuvert = false;
        try {
            if(c==null){
                estOuvert = true;
                c = new UtilDB().GetConn();
            }
            Compteur compteurLast= this.getCompteurLast(c, this.getIdMachine());
            ProcessFab map = new ProcessFab();
            map.setNomTable("PROCESSFABPETRI");
            String awh = "and datehistorique >= TO_DATE('"+ compteurLast.getDaty() +"','YYYY-MM-DD') and datehistorique <= TO_DATE('"+ this.getDaty() +"','YYYY-MM-DD') and action='"+ConstanteProcess.termineLib+"'";
            ProcessFab[] list = (ProcessFab[]) CGenUtil.rechercher(map, null, null, c, awh);
            String[] rep = new String[list.length];
            for(int i = 0; i < list.length; i++) {
                rep[i] = list[i].getRefObjet();
            }
            return rep;
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception(e.getMessage());
        } finally {
            if(estOuvert && c!=null){
                c.close();
            }
        }
    }

    public double calculerNombrePetrisFAB(String idFab, Connection c)throws Exception{
        boolean estOuvert = false;
        try {
            if(c==null){
                estOuvert = true;
                c = new UtilDB().GetConn();
            }
            double rep = 0;
            FabricationFille fille = new FabricationFille();
            fille.setIdMere(idFab);
            fille.setIdMachine(this.getIdMachine());
            FabricationFille[] list = (FabricationFille[]) CGenUtil.rechercher(fille, null, null,c, "");
            if(list != null && list.length > 0) {
                for(int i=0; i<list.length; i++) {
                    rep += list[i].getNombrePetrisFABFILLE(idFab, c);
                }
            }else {
                throw new Exception("Vérifier la machine dans la fabrication détails pour IDFAB : "+ idFab);
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

    public double getSommePetrisFab(Connection c, String[] liste)throws Exception{
        boolean estOuvert = false;
        try {
            if(c==null){
                estOuvert = true;
                c = new UtilDB().GetConn();
            }
            double rep = 0;
            for(int i=0;i<liste.length;i++){
                rep += this.calculerNombrePetrisFAB(liste[i], c);
            }
            return rep;
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception(e.getMessage());
        } finally {
            if(estOuvert && c!=null){
                c.close();
            }
        }
    }

    public List<MvtStock> genererRepartitionConso(Connection c, Magasin magasin)throws Exception{
        boolean estOuvert = false;
        try {
            if(c==null){
                estOuvert = true;
                c = new UtilDB().GetConn();
            }
            Compteur compteurLast= this.getCompteurLast(c, this.getIdMachine());
            IngredientsLib ing= new IngredientsLib();
            ing = (IngredientsLib) ing.getById(magasin.getIdProduit(),"AS_INGREDIENTS_LIB",c);
            String[] liste = this.getListeIDFabricationMachine(c);
            double sommePetris = this.getSommePetrisFab(c, liste);
            List<MvtStock> mouvementsList = new ArrayList<>();
            if(liste.length>0){
                for(int i=0;i<liste.length;i++) {
                    MvtStock mouvement = new MvtStock();
                    mouvement.setIdobjet(liste[i]);
                    mouvement.setDaty(this.getDaty());
                    mouvement.setDesignation("Mouvement de Stock pour Compteur : " + this.getId());
                    mouvement.setIdMagasin(this.getIdOrigine());
                    mouvement.setIdTypeMvStock(ConstanteSocobis.TYPE_MVT_SORTIE);
                    double nbPetrisFAB = this.calculerNombrePetrisFAB(liste[i], c);
                    double sortie = (nbPetrisFAB/sommePetris) * (this.getNombre() - compteurLast.getNombre());
                    MvtStockFille[] mouvements = new MvtStockFille[1];
                    mouvements[0] = new MvtStockFille();
                    mouvements[0].setIdMvtStock(mouvement.getId());
                    mouvements[0].setIdProduit(ing.getId());
                    mouvements[0].setSortie(sortie);
                    mouvements[0].setPu(ing.getPu());
                    mouvements[0].setDesignation("Sortie de "+ sortie +" "+ing.getLibelle() + " (en "+ing.getUnite()+")");
                    mouvement.setFille(mouvements);
                    mouvementsList.add(mouvement);
                }
            }
            return mouvementsList;
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception(e.getMessage());
        } finally {
            if(estOuvert && c!=null){
                c.close();
            }
        }
    }

    public List<Charge> genererRepartitionJIRAMA(Connection c, Magasin magasin)throws Exception{
        boolean estOuvert = false;
        try {
            if(c==null){
                estOuvert = true;
                c = new UtilDB().GetConn();
            }
            Compteur compteurLast= this.getCompteurLast(c, this.getIdMachine());
            IngredientsLib ing= new IngredientsLib();
            ing = (IngredientsLib) ing.getById(magasin.getIdProduit(),"AS_INGREDIENTS_LIB",c);
            String[] liste = this.getListeIDFabricationMachine(c);
            double sommePetris = this.getSommePetrisFab(c, liste);
            List<Charge> chargeList = new ArrayList<>();
            if(liste.length>0){
                for(int i=0;i<liste.length;i++) {
                    Charge mouvement = new Charge();
                    double nbPetrisFAB = this.calculerNombrePetrisFAB(liste[i], c);
                    double sortie = (nbPetrisFAB/sommePetris) * (this.getNombre() - compteurLast.getNombre());
                    mouvement.setDaty(this.getDaty());
                    mouvement.setLibelle("Charge de "+ sortie +" "+ing.getLibelle() + " (en "+ing.getUnite()+")");
                    mouvement.setPu(ing.getPu());
                    mouvement.setType("1");
                    mouvement.setIdfabrication(liste[i]);
                    mouvement.setQte(sortie);
                    mouvement.setIdingredients(ing.getId());
                    chargeList.add(mouvement);
                }
            }
            return chargeList;
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception(e.getMessage());
        } finally {
            if(estOuvert && c!=null){
                c.close();
            }
        }
    }

    public void genererRepartitionPersistConso(Connection c, String user, Magasin magasin) throws Exception{
        boolean estOuvert = false;
        try {
            if(c==null){
                estOuvert = true;
                c = new UtilDB().GetConn();
            }
            List<MvtStock> mouvementsList = this.genererRepartitionConso(c, magasin);
            for (MvtStock mvt : mouvementsList) {
                mvt.createObjectMultiple(user,c);
                mvt.validerObject(user, c);
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        } finally {
            if(estOuvert && c!=null){
                c.close();
            }
        }
    }

    public void genererRepartitionPersistJIRAMA(Connection c, String user, Magasin magasin) throws Exception{
        boolean estOuvert = false;
        try {
            if(c==null){
                estOuvert = true;
                c = new UtilDB().GetConn();
            }
            List<Charge> chargeList = this.genererRepartitionJIRAMA(c, magasin);
            for (Charge mvt : chargeList) {
                mvt.createObject(user, c);
                mvt.validerObject(user, c);
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception(e.getMessage());
        } finally {
            if(estOuvert && c!=null){
                c.close();
            }
        }
    }

    public void validerCompteur(Connection c, String u) throws Exception{
        Magasin magasin = new Magasin();
        magasin =(Magasin) magasin.getById(this.getIdOrigine(),"MAGASIN2",c);
        if(magasin!=null){
            if(magasin.getIdTypeMagasin()!=null && magasin.getIdTypeMagasin().compareToIgnoreCase(ConstanteSocobis.TYPE_MAG_JIRAMA)==0){
                this.genererRepartitionPersistJIRAMA(c,u, magasin);
            }else{
                this.genererRepartitionPersistConso(c,u, magasin);
            }
        }
    }

    @Override
    public Object validerObject(String u, Connection c) throws Exception {
        this.validerCompteur(c, u);
        return super.validerObject(u,c);
    }

    public void controllerCompteurValue(Connection c) throws Exception{
        Compteur compteurLast= this.getCompteurLast(c, this.getIdMachine());
        if(compteurLast != null){
            if(this.getNombre() <= compteurLast.getNombre()){
                throw new Exception("La valeur du compteur doit etre superieur à celle du dernier compteur : " + compteurLast.getNombre());
            }
        }
    }

    @Override
    public ClassMAPTable createObject(String user, Connection connection) throws Exception {
        this.controllerCompteurValue(connection);
        return super.createObject(user, connection);
    }
}
