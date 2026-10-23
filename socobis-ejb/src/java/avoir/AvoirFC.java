/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package avoir;

import bean.AdminGen;
import bean.CGenUtil;
import bean.ClassMAPTable;
import bean.ClassMere;
import client.Client;
import java.sql.Connection;
import java.sql.Date;
import java.util.Arrays;
import java.util.Map;
import java.util.stream.Collectors;

import mg.cnaps.compta.ComptaEcriture;
import mg.cnaps.compta.ComptaSousEcriture;
import prevision.Prevision;
import prevision.PrevisionComplet;
import ristourne.RistourneDetails;
import stock.MvtStock;
import stock.MvtStockFille;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;
import change.TauxDeChange;
import utils.ConstanteSavonnerie;
import utils.ConstanteSocobis;
import utils.ConstanteStation;
import vente.NumeroFacture;
import vente.Vente;
import vente.VenteDetails;
import vente.VenteLib;

/**
 *
 * @author randr
 */
public class AvoirFC extends ClassMere{

    String id;
    String designation;
    String idMagasin;
    Date daty;
    String remarque;
    int etat;
    String idOrigine;
    String idClient;
    String idVente;
    String idMotif;
    String idCategorie;
    String compte,compteauxiliaire;
    String idtypeavoir;
    String numavoir, idristourne;

    public String getIdristourne() {
        return idristourne;
    }

    public void setIdristourne(String idristourne) {
        this.idristourne = idristourne;
    }

    public double getPuFacture(String idProduit) throws Exception{
        try {
            if(this.getIdristourne()!=null){
                String awhere = " AND IDRISTOURNE='"+this.getIdristourne()+"' AND IDPRODUIT='"+idProduit+"'";
                RistourneDetails[] ristournes = (RistourneDetails[]) CGenUtil.rechercher(new RistourneDetails(), null,null,null,awhere);
                if(ristournes.length>0){
                    return ristournes[0].getPu();
                }
            }
            return 1;
        } catch (Exception e) {
            throw e;
        }
    }
    public String getNumavoir() {
        return numavoir;
    }

    public void setNumavoir(String numavoir) {
        this.numavoir = numavoir;
    }

    public String getCompteauxiliaire() {
        return compteauxiliaire;
    }

    public void setCompteauxiliaire(String compteauxiliaire) {
        this.compteauxiliaire = compteauxiliaire;
    }

    AvoirFCFille [] avoirDetails;
    
    public AvoirFC(){
        this.setNomTable("AvoirFC");
    }
    
    public AvoirFC(String nomtable){
        this.setNomTable(nomtable);
    }
    
    public String getId() {
        return id;
    }
    @Override
    public String getLiaisonFille() {
        return "idAvoirFC";
    } 
    @Override
    public  String getNomClasseFille() {
        return "avoir.AvoirFCFille";
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

    public void setIdMagasin(String idMagasin) {
        this.idMagasin = idMagasin;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }

    public int getEtat() {
        return etat;
    }

    public void setEtat(int etat) {
        this.etat = etat;
    }

    public String getIdOrigine() {
        return idOrigine;
    }

    public void setIdOrigine(String idOrigine) {
        this.idOrigine = idOrigine;
    }

    public String getIdClient() {
        return idClient;
    }

    public void setIdClient(String idClient) {
        this.idClient = idClient;
    }

    public String getIdVente() {
        return idVente;
    }

    public void setIdVente(String idVente) {
        this.idVente = idVente;
    }

    public String getIdMotif() {
        return idMotif;
    }

    public void setIdMotif(String idMotif) {
        this.idMotif = idMotif;
    }

    public String getIdCategorie() {
        return idCategorie;
    }

    public void setIdCategorie(String idCategorie) {
        this.idCategorie = idCategorie;
    }

    public String getCompte() {
        return compte;
    }

    public void setCompte(String compte) {
        this.compte = compte;
    }

    public AvoirFCFille[] getAvoirDetails() {
        return avoirDetails;
    }

    public void setAvoirDetails(AvoirFCFille[] avoirDetails) {
        this.avoirDetails = avoirDetails;
    }
    

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }
    public AvoirFCLib getAvoirComplet(Connection c)throws Exception
    {
        return (AvoirFCLib)new AvoirFCLib().getById(this.getId(), "AVOIRFCLIB_CPL_VISEE", c);
    }
    public PrevisionComplet[] getPrevisionCompletFactureAttache(Connection c)throws Exception
    {
        PrevisionComplet crt=new PrevisionComplet();
        crt.setIdFacture(this.getIdVente());
        return (PrevisionComplet[])CGenUtil.rechercher(crt, null,null, c, " order by daty asc");
    }
    public Prevision genererPrevision(String u, Connection c) throws Exception{
        PrevisionComplet prevFactRattache[]=this.getPrevisionCompletFactureAttache(c);
        if(prevFactRattache==null||prevFactRattache.length==0)return null;
        Prevision mere = new Prevision();
        AvoirFCLib avoirComplet = this.getAvoirComplet(c);
        mere.setDaty(prevFactRattache[prevFactRattache.length-1].getDaty());//Prendre la dernière echeance de la prevision
        mere.setDebit(avoirComplet.getMontantTTCAr());
        mere.setIdFacture(this.id);
        mere.setIdCaisse(ConstanteStation.idCaisse);
        mere.setIdDevise("AR");
        mere.setTaux(1);
        mere.setDesignation("Prevision rattach&eacute;e au Facture d avoir N"+this.getId());
        return ( Prevision ) mere.createObject(u, c);
    }

    public void checkMontant(Connection c) throws Exception{
        try{
            VenteLib vente = (VenteLib) new VenteLib().getById(this.getIdOrigine(),"VENTE_CPL",c);
            AvoirFCLib avoir = (AvoirFCLib) new AvoirFCLib().getById(this.getId(),"avoirFCLib",c);
            String awhere = " AND ID!='"+this.getId()+"' AND IDORIGINE='"+this.getIdOrigine()+"' AND ETAT>=11";
            AvoirFCLib [] avoirs = (AvoirFCLib []) CGenUtil.rechercher(new AvoirFCLib(), null, null,c, awhere);
            double montantavoirs = AdminGen.calculSommeDouble(avoirs, "MontantTTCAr");
            if(vente==null){
                throw new Exception("Vente "+this.getIdVente()+" n'existe pas");
            }
            double montantFacture = vente.getMontantTtcAr();
            double montantAvoir = avoir.getMontantTTCAr()+montantavoirs;
            if(montantFacture<montantAvoir){
                throw new Exception("Montant avoir doit \u00EAtre inf\u00E9rieur ou \u00E9gal au montant factur\u00E9.");
            }
        }catch(Exception e){
            e.printStackTrace();
            throw e;
        }
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
            checkMontant(c);
            //CheckEtatStockVenteDetails(c);
            super.validerObject(u, c);
            this.genererPrevision(u, c);
            genererEcriture(u, c);
            //createMvtStockSortie(u, c);
            if(estOuvert==true)c.commit();
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
    
    public void genererEcriture(String u, Connection c) throws Exception{
        ComptaEcriture mere = new ComptaEcriture();
        Date dateDuJour = utilitaire.Utilitaire.dateDuJourSql();
        int exercice = utilitaire.Utilitaire.getAnnee(daty);
        mere.setDaty(dateDuJour);
        mere.setDesignation(this.getDesignation());
        mere.setExercice(""+exercice);
        mere.setDateComptable(this.getDaty());
        mere.setJournal(ConstanteStation.JOURNALVENTE);
        mere.setOrigine(this.getId());
        mere.setIdobjet(this.getId());
        mere.createObject(u, c);

        ComptaSousEcriture[] filles = this.genererSousEcriture(c);
        for(int i=0; i<filles.length; i++){
            filles[i].setIdMere(mere.getId());
            filles[i].setExercice(exercice);
            filles[i].setDaty(this.getDaty());
            filles[i].setJournal(ConstanteStation.JOURNALVENTE);
            
            if(filles[i].getDebit()>0 || filles[i].getCredit()>0) filles[i].createObject(u, c);
        }
    }
    
    public ComptaSousEcriture[] genererSousEcriture(Connection c) throws Exception{
        ComptaSousEcriture[] compta={};
        boolean canClose=false;
        try{
            if(c==null){
                c=new UtilDB().GetConn();
                canClose=true;
            }
            AvoirFCLib[] avoirs = (AvoirFCLib[]) CGenUtil.rechercher(new AvoirFCLib("AVOIRFC_MERE_MONTANT"), null, null, c, " and id = '"+this.getId()+"'");
            if(avoirs.length<1) throw new Exception("Avoir Introuvable");
            Client cli = getClient(c);
            this.setCompte(cli.getCompte());
            AvoirFCFille [] details = this.getDetails(c);
            double montantTva = AdminGen.calculSommeDouble(details,"montantTVAAr");
            double montantTTC = AdminGen.calculSommeDouble(details,"montantTTCAr");
            int taille = details.length;
            compta = new ComptaSousEcriture[taille+2];
            int i=0;
            for(i=i;i<taille;i++){ 
                compta[i]=new ComptaSousEcriture();
                compta[i].setLibellePiece(this.getDesignation());
                compta[i].setRemarque(details[i].getDesignation());
                compta[i].setCompte(details[i].getCompte());
                if(this.getIdtypeavoir().compareToIgnoreCase(ConstanteSavonnerie.ID_AVOIR_RISTOURNE)==0){
                    compta[i].setCompte(details[i].getCompteRistourne(c));
                }
                compta[i].setDebit(details[i].getMontanthtar());
            }
            
            compta[i]=new ComptaSousEcriture();
            compta[i].setLibellePiece("TVA Collectee");
            compta[i].setRemarque("TVA Collectee");
            compta[i].setCompte(ConstanteStation.compteTVACollecte);
//            compta[i].setDebit((montantHT-retenue) * ((this.getTva()/100)));
            compta[i].setDebit(montantTva);
            i++;
            
            compta[i]=new ComptaSousEcriture();
            compta[i].setLibellePiece("Avoir Client "+avoirs[0].getClientlib());
            compta[i].setRemarque("Avoir Client "+avoirs[0].getClientlib());
            compta[i].setCompte(this.getCompte());
            compta[i].setCredit(montantTTC);
            compta[i].setCompte_aux(cli.getCompteauxiliaire());
        } catch(Exception e){
            throw e;
        } finally {
            if(canClose){
                c.close();
            }
        }
        return compta;
    }
    
    public AvoirFCFille[] getDetails(Connection c) throws Exception{           
        AvoirFCFille[] avoirfcFille = null;        
           try{
            String awhere = " and IDAVOIRFC = '"+this.getId()+"'";
            avoirfcFille = (AvoirFCFille[]) CGenUtil.rechercher(new AvoirFCFille("AVOIRFC_GRP_VISEE"), null, null, c, awhere);
        }catch(Exception e){
            e.printStackTrace();
            throw e;
        }
        return avoirfcFille;
    }
    
    public Client getClient(Connection c) throws Exception{
        Client client = new Client();
        Client[] clients = (Client[]) CGenUtil.rechercher(client,null,null,c, " and id = '"+this.getIdClient()+"'");
        if(clients.length > 0){
            return clients[0];
        }
        throw new Exception("Le client n'existe pas");
    }
    
    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("AVRFC", "GETSEQAVOIRFC");
        this.setId(makePK(c));
    }
    
    @Override
    public void controlerUpdate(Connection c) throws Exception {
        if(this.etat<1) this.setEtat(1);
    }

    public String getIdtypeavoir() {
        return idtypeavoir;
    }

    public void setIdtypeavoir(String idtypeavoir) {
        this.idtypeavoir = idtypeavoir;
    }

    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {
        NumeroFacture numFactF = new NumeroFacture();
        numFactF.setNomTable("V_NUMEROAVOIR_EN_COURS");
        NumeroFacture[] numFact = (NumeroFacture[]) CGenUtil.rechercher(numFactF, null, null, c, "");
        this.setNumavoir(numFact[0].getProchain_num_format());

        if(this.getIdtypeavoir().compareToIgnoreCase(ConstanteSavonnerie.ID_AVOIR_RISTOURNE)==0){
            return super.createObject(u, c);
        }
        AvoirFCFille [] filles = (AvoirFCFille[]) this.getFille();
        VenteDetails v = new VenteDetails();
        v.setIdVente(this.getIdVente());
        VenteDetails [] venteDetails = (VenteDetails[]) CGenUtil.rechercher(v,null,null,c,"");
        if (venteDetails.length > 0) {
            Map<String, Double> qteParProduit = Arrays.stream(venteDetails)
                    .collect(Collectors.toMap(
                            vd -> vd.getIdProduit().toLowerCase(),
                            VenteDetails::getQte,
                            Double::sum
                    ));
            for (AvoirFCFille fille : filles) {
                Double qteVente = qteParProduit.get(
                        fille.getIdProduit().toLowerCase()
                );
                if (qteVente != null) {
                    fille.setQte(fille.getQte());
                    //fille.setQte(qteVente - fille.getQte());
                }
            }
        }
        if (filles != null) {
            for (AvoirFCFille fille : filles) {
                if (fille.getIdDevise() != null && !fille.getIdDevise().equalsIgnoreCase("AR") && fille.getTauxDeChange() <= 1) {
                    double taux = TauxDeChange.getLastTaux(c, Utilitaire.formatterDaty(this.getDaty()), fille.getIdDevise());
                    if (taux > 0) {
                        fille.setTauxDeChange(taux);
                    }
                }
            }
        }
        return super.createObject(u, c);
    }

    public MvtStock genereEntre(Vente vente) throws Exception {
        MvtStock md=new MvtStock();
        md.setDaty(vente.getDaty());
        md.setIdMagasin(vente.getIdMagasin());
//        md.setIdPoint(this.getCible());

        md.setDesignation("Entree de stock retour du : "+ vente.getId());
        md.setIdTypeMvStock(ConstanteStation.TYPEMVTSTOCKENTREE);
        md.setIdCategorieStock(ConstanteSocobis.ID_CATEGORIESTOCK_RETOUR);
        // md.setIdTransfert(vente.getId());
        md.setIdobjet(vente.getId());

        AvoirFCFille[] fille = (AvoirFCFille[]) this.getFille();
        MvtStockFille[] mvtStockFilles =  new MvtStockFille[fille.length];

        for (int i = 0; i < fille.length; i++) {
            MvtStockFille  mvtStockFille = new MvtStockFille();

            mvtStockFille.setIdProduit(fille[i].getIdProduit());
            mvtStockFille.setEntree(fille[i].getQte());
            mvtStockFille.setPu(fille[i].getPu());

            mvtStockFilles[i] = mvtStockFille;
        }

        md.setFille(mvtStockFilles);
        return md;
    }
    
}
