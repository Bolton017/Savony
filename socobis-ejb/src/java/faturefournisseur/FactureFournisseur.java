/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package faturefournisseur;

import avoir.AvoirAchat;
import avoir.AvoirAchatFille;
import bean.*;
import caisse.Caisse;
import caisse.MvtCaisse;
import change.TauxDeChange;
import java.sql.Connection;
import java.sql.Date;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

import chatbot.FilleOcr;
import chatbot.MereOcr;
import historique.HistoInsert;
import magasin.Magasin;
import mg.cnaps.compta.ComptaEcriture;
import mg.cnaps.compta.ComptaSousEcriture;
import org.jsoup.select.Evaluator;
import prevision.Prevision;
import rapprochement.RapprochementBC;
import rapprochement.RapprochementDBMere;
import rapprochement.ReleverDetail;
import rapprochement.ReleverDetailCpl;
import stock.HistoriquePrix;
import stock.MvtStock;
import stock.MvtStockFille;
import utilitaire.ConstanteEtat;
import produits.Ingredients;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;
import utils.ConstanteSocobis;
import utils.ConstanteStation;
import vente.As_BondeLivraisonClient;
import vente.As_BondeLivraisonClientFille;
import vente.Vente;
import vente.VenteDetailsLib;

/**
 *
 * @author nouta
 */
public class FactureFournisseur extends vente.FactureCF{
    @LibelleAffichage("Fournisseur")
    protected String idFournisseur;

    @LibelleAffichage("Mode de paiement")
    protected String idModePaiement;

    @LibelleAffichage("R&eacute;f&eacute;rence")
    protected String reference;

    @LibelleAffichage("Bon de commande")
    protected String idBc;

    @LibelleAffichage("Magasin")
    protected String idMagasin;

    @LibelleAffichage("Fournisseur")
    protected String fournisseurlib;

    @LibelleAffichage("Date &eacute;ch&eacute;ance paiement")
    protected Date dateEcheancePaiement;

    @LibelleAffichage("Devise")
    protected String devise;

    @LibelleAffichage("Taux")
    protected double taux;

    @LibelleAffichage("Compte")
    protected String compte;

    @LibelleAffichage("Compte auxiliaire")
    protected String compteauxiliaire;

    @LibelleAffichage("Est pr&eacute;vu")
    int estPrevu;

    @LibelleAffichage("Montant perte/gain")
    private double montantPerteGain;

    @LibelleAffichage("Objet")
    private String idObjet;

    @LibelleAffichage("R&eacute;f&eacute;rence")
    private String idRef;

    @LibelleAffichage("Demande d'achat")
    private String idDmdAchat;

    @LibelleAffichage("Type de facture")
    private String idtypefacture;

    @LibelleAffichage("Num&eacute;ro")
    private String numero;

    @LibelleAffichage("Type d'achat")
    private String typeachat;

    @LibelleAffichage("Fournisseur")
    Fournisseur fournisseur;

    @LibelleAffichage("Facture principale")
    private String idfactureprincipale;

    @LibelleAffichage("Type de facture fournisseur")
    protected String typeFactureFournisseur;

    @LibelleAffichage("Remise")
    private double remise;

    @LibelleAffichage("Montant de la remise")
    private double remiseMontant;

    @LibelleAffichage("&Eacute;ch&eacute;ance de la facture")
    private double echeanceFacture;

    private String service;
    private String idDevise;

    public String getTypeFactureFournisseur() {
        return typeFactureFournisseur;
    }

    public void setTypeFactureFournisseur(String typeFactureFournisseur) {
        this.typeFactureFournisseur = typeFactureFournisseur;
    }

    public String getIdfactureprincipale() {
        return idfactureprincipale;
    }

    public void setIdfactureprincipale(String idfactureprincipale) {
        this.idfactureprincipale = idfactureprincipale;
    }

    public String getService() {
        return service;
    }

    public void setService(String service) {
        this.service = service;
    }

    public double getRemise() {
        return remise;
    }

    public void setRemise(double remise) {
        this.remise = remise;
    }

    public double getRemiseMontant() {
        return remiseMontant;
    }

    public void setRemiseMontant(double remiseMontant) {
        this.remiseMontant = remiseMontant;
    }

    public String getTypeachat() {
        return typeachat;
    }

    public void setTypeachat(String typeachat) {
        this.typeachat = typeachat;
    }

    public String getNumero() {
        return numero;
    }

    public void setNumero(String numero) {
        this.numero = numero;
    }

    public String getIdRef() {
        return idRef;
    }

    public void setIdRef(String idRef) {
        this.idRef = idRef;
    }

    public String getIdObjet() {
        return idObjet;
    }

    public void setIdObjet(String idObjet) {
        this.idObjet = idObjet;
    }

    public String getCompteauxiliaire() {
        return compteauxiliaire;
    }

    public void setCompteauxiliaire(String compteauxiliaire) {
        this.compteauxiliaire = compteauxiliaire;
    }

    public String getIdDmdAchat() {
        return idDmdAchat;
    }

    public void setIdDmdAchat(String idDmdAchat) {
        this.idDmdAchat = idDmdAchat;
    }

    public Fournisseur getFournisseur() {
        return fournisseur;
    }

    public void setFournisseur(Fournisseur fournisseur) {
        this.fournisseur = fournisseur;
    }

    public double getEcheanceFacture() {
        return echeanceFacture;
    }

    public void setEcheanceFacture(double echeanceFacture) {
        this.echeanceFacture = echeanceFacture;
    }

    public static FactureFournisseur fromOcr(MereOcr mere) throws Exception {
        FactureFournisseur f = new FactureFournisseur();
        f.setDesignation(mere.getDesignation());
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");

        LocalDate localDate = LocalDate.parse(mere.getDaty(), formatter);
        Date sqlDate = Date.valueOf(localDate);
        f.setDaty(sqlDate);

        Fournisseur fournisseur = new Fournisseur();
        Fournisseur[] fournisseurs = (Fournisseur[]) CGenUtil.rechercher(fournisseur,null,null," and upper(nom) like '%"+mere.getIdOrigine().toUpperCase()+"%'");
        if(fournisseurs!=null && fournisseurs.length>0){
            f.setIdFournisseur(fournisseurs[0].getId());
        }

        Magasin magasin = new Magasin();
        Magasin[] magasins = (Magasin[]) CGenUtil.rechercher(magasin,null,null," and upper(val) like '%"+mere.getIdMagasin().toUpperCase()+"%'");
        if(magasins!=null && magasins.length>0){
            f.setIdMagasin(magasins[0].getId());
        }

        FactureFournisseurDetails[] filles = fillesFromOcr(mere.getDetails().toArray(new FilleOcr[0]));
        f.setFille(filles);

        return f;
    }
    public static FactureFournisseurDetails[] fillesFromOcr(FilleOcr[] filles) throws Exception {
        FactureFournisseurDetails[] f = new FactureFournisseurDetails[filles.length];
        for (int i = 0; i < filles.length; i++) {
            f[i] = FactureFournisseurDetails.fromOcr(filles[i]);
        }
        return f;
    }
    @Override
    public String getLiaisonFille() {
        return "idFactureFournisseur";
    }
    @Override
    public String getNomClasseFille() {
        return "faturefournisseur.FactureFournisseurDetails";
    }
    @Override
    public String getSensPrev(){
        return "debit";
    }
    @Override
    public String getTiers(){
        return this.idFournisseur;
    }
    public int getEstPrevu() {
        return estPrevu;
    }

    public int isEstPrevu() {
        return estPrevu;
    }

    public void setEstPrevu(int estPrevu) {
        this.estPrevu = estPrevu;
    }



    public String getIdDevise() {
        return idDevise;
    }

    public void setIdDevise(String idDevise) {
        if (getMode().equalsIgnoreCase("modif")) {
            if (idDevise == null) {
                setIdDevise("AR");
            }
        }
        this.idDevise = idDevise;
    }

    public FactureFournisseur(String nomtable) {
        setNomTable(nomtable);
    }

    public String getIdMagasin() {
        return idMagasin;
    }
    public void setIdMagasin(String idMagasin) {
        this.idMagasin = idMagasin;
    }

    public String getDevise() {
        return devise;
    }
    public void setDevise(String devise) {
        this.devise = devise;
    }
    public double getTaux() {
        if(taux==0)return 1;
        return taux;
    }
    public void setTaux(double taux) {
        if(taux==0&this.getMode().compareToIgnoreCase("modif")==0)taux=1;
        this.taux = taux;
    }
    public FactureFournisseur() {
        super.setNomTable("FACTUREFOURNISSEUR");
    }
    public void construirePK(Connection c) throws Exception {
        this.preparePk("FCF", "GETSEQFACTUREFOURNISSEUR");
        this.setId(makePK(c));
    }


    public String getIdFournisseur() {
        return idFournisseur;
    }

    public void setIdFournisseur(String idFournisseur) {
        this.idFournisseur = idFournisseur;
    }

    public String getIdModePaiement() {
        return idModePaiement;
    }

    public void setIdModePaiement(String idModePaiement) {
        this.idModePaiement = idModePaiement;
    }



    public String getReference() {
        return reference;
    }

    public void setReference(String reference) {
        this.reference = reference;
    }

    public String getIdBc() {
        return idBc;
    }

    public void setIdBc(String idBc) {
        this.idBc = idBc;
    }



    public Date getDateEcheancePaiement() {
        return dateEcheancePaiement;
    }

    public void setDateEcheancePaiement(Date dateEcheancePaiement) {
        this.dateEcheancePaiement = dateEcheancePaiement;
    }

    public String getCompte() {
        return compte;
    }

    public void setCompte(String compte) {
        this.compte = compte;
    }

    public String getFournisseurlib() {
        return fournisseurlib;
    }

    public void setFournisseurlib(String fournisseurlib) {
        this.fournisseurlib = fournisseurlib;
    }
    public double getMontantPerteGain() {
        return montantPerteGain;
    }

    public void setMontantPerteGain(double montantPerteGain) {
        this.montantPerteGain = montantPerteGain;
    }
    

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    public Prevision[] genererPrevision(String u, Connection c) throws Exception{
        FactureFournisseurDetails[] fille = (FactureFournisseurDetails[]) this.getFille("FACTUREFOURNISSEURFILLE", c, "");
        List<Prevision> previsions = new ArrayList<>();

        for (FactureFournisseurDetails f : fille)
        {
            Prevision prev = f.genererPrevision();
            prev.setDebit(prev.getDebit()*(1-(this.getRemise()/100)));
            prev.setDaty(this.getDateEcheancePaiement());
            prev.setIdTiers(this.getIdFournisseur());
            Prevision newPrev = (Prevision) prev.createObject(u, c);

            previsions.add(newPrev);
        }

        return previsions.toArray(new Prevision[previsions.size()]);

    }

    public Prevision[] genererPrevisionPrevu(String u, Connection c) throws Exception {
        FactureFournisseurDetails[] details = (FactureFournisseurDetails[]) getFille("FACTUREFOURNISSEURFILLE", c, "");
        Prevision[] previsions = new Prevision[details.length];
        for (int i = 0; i < details.length; i++) {
            previsions[i] = details[i].genererPrevisionPrevu(u, c);
            previsions[i].setDebit(previsions[i].getDebit()*(1-(this.getRemise()/100)));
        }
        return  previsions;
    }

    public FactureFournisseur getFactureWithMontant(Connection c) throws Exception{
        return (FactureFournisseur)new FactureFournisseur().getById(this.getId(),"FACTUREFOURNISSEURCPL",c);
    }

    public void genererEcritureDecaissement(String u, Connection c) throws Exception{
        ComptaEcriture mere = new ComptaEcriture();
        Date dateDuJour = utilitaire.Utilitaire.dateDuJourSql();
        int exercice = utilitaire.Utilitaire.getAnnee(getDaty());
        mere.setDaty(dateDuJour);
        mere.setDesignation(this.getDesignation());
        mere.setExercice(""+exercice);
        mere.setDateComptable(this.getDaty());
        mere.setJournal(ConstanteStation.journalAchat);
        mere.setOrigine(this.getId());
        mere.setIdobjet(this.getId());
        mere.createObject(u, c);
        ComptaSousEcriture[] filles = this.genererSousEcritureDecaissement(c);
        for(int i=0; i<filles.length; i++){
            filles[i].setIdMere(mere.getId());
            filles[i].setExercice(exercice);
            filles[i].setDaty(this.getDaty());
            filles[i].setJournal(ConstanteStation.journalAchat);

            if(filles[i].getDebit()>0 || filles[i].getCredit()>0) filles[i].createObject(u, c);
        }
    }

    public ComptaSousEcriture[] genererSousEcritureDecaissement(Connection c) throws Exception{
        ComptaSousEcriture[] compta={};
        boolean canClose=false;
        try{
            if(c==null){
                c=new UtilDB().GetConn();
                canClose=true;
            }
            FactureFournisseur[] facturefournisseurs = (FactureFournisseur[]) CGenUtil.rechercher(new FactureFournisseur("FACTUREFOURNISSEUR_MERECMPT"), null, null, c, " and id = '"+this.getId()+"'");
            if(facturefournisseurs.length<1) throw new Exception("Facture mere Introuvable");
            this.setCompte(facturefournisseurs[0].getCompte());

            compta = new ComptaSousEcriture[2];

            compta[0]=new ComptaSousEcriture();
            compta[0].setLibellePiece(this.getDesignation());
            compta[0].setRemarque(this.getDesignation());
            compta[0].setCompte(getCaisse(c).getCompte());
            compta[0].setCredit(facturefournisseurs[0].getMontantttcAr());

            compta[1]=new ComptaSousEcriture();
            compta[1].setLibellePiece("Decaissement fournisseur "+facturefournisseurs[0].getFournisseurlib());
            compta[1].setRemarque("Decaissement fournisseur "+facturefournisseurs[0].getFournisseurlib());
            compta[1].setCompte(this.getCompte());
//            compta[i].setDebit((montantHT-retenue) * ((this.getTva()/100)));
            compta[1].setDebit(facturefournisseurs[0].getMontantttcAr());

        } catch(Exception e){
            throw e;
        } finally {
            if(canClose){
                c.close();
            }
        }
        return compta;
    }

    public Caisse getCaisse(Connection c) throws Exception {
        if (c == null) {
            throw new Exception("Connection non etablie");
        }
        Caisse caisse = new Caisse();
        Caisse[] caisses = (Caisse[]) CGenUtil.rechercher(caisse, null, null, c, " and idMagasin = '"+this.getIdMagasin()+"'");
        if (caisses.length > 0) {
            return caisses[0];
        }
        return null;
    }
    public Fournisseur getFournisseur(Connection c) throws Exception
    {
        Fournisseur crt=new Fournisseur();
        crt.setId(this.getIdFournisseur());
        Fournisseur[] liste=(Fournisseur[])CGenUtil.rechercher(crt, null, null, c, "");
        if(liste.length==0)return null;
        return liste[0];
    }
    public void genererEcriture(String u, Connection c) throws Exception{
        Date dateDuJour = Utilitaire.dateDuJourSql();
        int exercice = Utilitaire.getAnnee(this.getDaty());
        ComptaEcriture mere = new ComptaEcriture();
        //System.out.println("Daty "+this.getDaty().getYear()+" designation "+this.getDesignation()+" id "+this.getId());
        mere.setDaty(this.getDaty());
        mere.setDesignation(Utilitaire.champNull(this.getDesignation()));
        mere.setExercice(""+exercice);
        mere.setDateComptable(this.getDaty());
        mere.setJournal(ConstanteStation.journalAchat);
        mere.setIdobjet(this.getId());
        mere.setOrigine(this.getId());
        mere.createObject(u, c);
        ComptaSousEcriture[] filles = this.genererSousEcriture(c);
        for(int i=0; i<filles.length; i++){
            System.out.printf("COMPTE FILLE "+filles[i].getCompte());
            filles[i].setIdMere(mere.getId());
            filles[i].setExercice(exercice);
            filles[i].setDaty(this.getDaty());
            filles[i].setJournal(ConstanteStation.journalAchat);
            filles[i].setRemarque(mere.getDesignation());
            filles[i].setLibellePiece(this.getNumero());
            filles[i].createObject(u, c);
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
            //FactureFournisseur[] facturefournisseur = (FactureFournisseur[]) CGenUtil.rechercher(new FactureFournisseur("FACTUREFOURNISSEUR_MERECMPT"), null, null, c, " and id = '"+this.getId()+"'");
            //if(facturefournisseur.length<1) throw new Exception("Facture Fournisseur mère Introuvable");
            FactureFournisseurDetails details [] = this.getDetails(c);
            //this.setCompte(facturefournisseur[0].getCompte());
            double montantTva = AdminGen.calculSommeDouble(details,"montantTvaAr");
            double montantHT = AdminGen.calculSommeDouble(details,"montantHtAr");
            double montantTTC = AdminGen.calculSommeDouble(details,"montantTtcAr");
            int taille = details.length;
            compta = new ComptaSousEcriture[taille+(montantTva>0?2:1)];
            int i=0;
            for(i=i;i<taille;i++){

                compta[i]=new ComptaSousEcriture();
                compta[i].setLibellePiece(this.getDesignation());
                compta[i].setRemarque(this.getDesignation());
                //System.out.println("COMPTE = "+details[i].getCompte()+" mo");
                compta[i].setCompte(details[i].getCompte());
                compta[i].setDebit(details[i].getMontantHtAr());
            }
            if(montantTva > 0){
                compta[i]=new ComptaSousEcriture();
                compta[i].setLibellePiece("TVA Deductible");
                compta[i].setRemarque("TVA Deductible");
                compta[i].setCompte(ConstanteStation.compteTVADeductible);
    //            compta[i].setDebit((montantHT-retenue) * ((this.getTva()/100)));
                compta[i].setDebit(montantTva);
                i++;
            }

            Fournisseur fo=this.getFournisseur(c);
            compta[i]=new ComptaSousEcriture();
            compta[i].setLibellePiece("Achat Fournisseur "+fo.getNom());
            compta[i].setRemarque("Achat Fournisseur "+fo.getNom());
            compta[i].setCompte(fo.getCompte());
            compta[i].setCredit(montantTTC);
            compta[i].setCompte_aux(fo.getId());

        }
        catch(Exception e){
            throw e;
        }
       finally{
            if(canClose){
                c.close();
            }

        }
        return compta;
    }
    public FactureFournisseurDetails[] getDetails(Connection c) throws Exception{
        FactureFournisseurDetails[] ffdetails = null;
           try{
            FactureFournisseurDetails details = new FactureFournisseurDetails();
            details.setNomTable("FACTUREFOURNISSEUR_FILLE_VISE");
            String awhere = " and IDFACTUREFOURNISSEUR = '"+this.getId()+"'";
            ffdetails = (FactureFournisseurDetails[]) CGenUtil.rechercher(details, null, null, c, awhere);
        }catch(Exception e){
            e.printStackTrace();
        }
        return ffdetails;
    }

    public void validerFactureFraisAccessoire(String u,Connection c) throws Exception{
        boolean canClose = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                canClose = true;
            }
            LiaisonIntraTable l = new LiaisonIntraTable();
            l.setId1(this.getIdfactureprincipale());
            l.setId2(this.getId());
            LiaisonIntraTable[] liaisons = (LiaisonIntraTable[]) CGenUtil.rechercher(l,null,null,c,"");
            for (LiaisonIntraTable liaison : liaisons) {
                liaison.validerObject(u,c);
            }
        } catch (Exception e){
            if (canClose) c.rollback();
            throw e;
        } finally {
            if (canClose) c.close();
        }
    }

    @Override
    public Object validerObject(String u, Connection c) throws Exception {
        this.setNumeroNext(c);
        this.attacherBL(u, c);
        super.validerObject(u, c);
        genererEcriture(u, c);
        Fournisseur fr = this.getFournisseur(c);
        if (fr != null && fr.getNom() != null) {
            HistoInsert.ajoutRemarque(this.getId(), fr.getNom(), c);
        }
        if(estPrevu == 0){
            genererPrevision(u, c);
        }
        else if (this.getEstPrevu() == 1){
            genererPrevisionPrevu(u, c);
        }
        FactureFournisseurDetails[] ffD=(FactureFournisseurDetails[]) this.getFille(null,c,"");
        for(int i=0;i<ffD.length;i++){
            ffD[i].modifPuIngredientsNew(u,c);
        }
        if(this.getIdObjet()!=null && this.getIdObjet().startsWith("BL")){
            updateBcFactureViaBL(this.getIdObjet(),u,c);
        }
        if(this.getIdtypefacture()!=null && this.getIdtypefacture().equalsIgnoreCase(ConstanteSocobis.TYPE_FRAIS_ACCESSOIRE)){
            validerFactureFraisAccessoire(u,c);
        }
        return this;
    }

    @Override
    public boolean getEstIndexable() {
        return true;
    }

    public int updateObject(String u,Connection c)throws Exception
    {
        return super.updateToTableWithHisto(u, c);
    }

    public void updateBcFactureViaBL(String idBL,String u, Connection c)throws Exception{
        As_BonDeLivraison bl = (As_BonDeLivraison)new As_BonDeLivraison().getById(idBL, "AS_BONDELIVRAISON", null);
        this.setIdBc(bl.getIdbc());
        this.updateToTableWithHisto(u,c);
    }

    public void setNumeroNext(Connection c) throws Exception {

        FactureFournisseurCpl crit = new FactureFournisseurCpl();
        crit.setNomTable("FACTUREFOURNISSEURCPL");
        crit.setId(this.getId());
        FactureFournisseurCpl[] fournisseurs = (FactureFournisseurCpl[]) CGenUtil.rechercher(crit, null, null, c, "");

        if (fournisseurs.length == 0) {
            throw new Exception("Aucun fournisseur trouvé pour la facture : " + this.getId());
        }

        String libFournisseur = fournisseurs[0].getIdFournisseurLib();
        String initial = (libFournisseur != null && !libFournisseur.isEmpty())
                ? libFournisseur.substring(0, 1).toUpperCase()
                : "";

        String typeAchat = this.getTypeachat();
        Date dateFacture = this.getDaty();

        if (dateFacture == null) {
            throw new Exception("Date de facture obligatoire pour générer le numéro");
        }
        String prefixe = typeAchat + "-" + initial;

        NumeroFacture numCrit = new NumeroFacture();
        String next_num ="01";
        java.sql.Date datyfact = new java.sql.Date(dateFacture.getTime());
        String condition =
        " AND PREFIXE = '" + prefixe + "'" +
        " AND DATE_FACTURE = DATE '" + datyfact + "'";

        NumeroFacture[] nums = (NumeroFacture[]) CGenUtil.rechercher(numCrit, null, null, c, condition);

        if (nums.length > 0) next_num = nums[0].getNextnum();  
        
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        String dateStr = sdf.format(dateFacture);

        String numeroFinal = prefixe + "-"+ dateStr + "-"+ next_num;
        this.setNumero(numeroFinal);
    }


    public FactureFournisseurCpl getFactureFournisseurCpl(Connection c) throws Exception {
        if (c == null) {
            throw new Exception("Connection non etablie");
        }
        FactureFournisseurCpl fact = new FactureFournisseurCpl();
	 fact.setNomTable("FACTUREFOURNISSEURCPL_MONTANT");
        fact.setId(this.getId());
        FactureFournisseurCpl[] epts = (FactureFournisseurCpl[]) CGenUtil.rechercher(fact, null, null, c, " ");
        if (epts.length > 0) {
            return epts[0];
        }
        return null;
    }

    public String genererLivraison(String u,Connection c)throws Exception{
        boolean estOuvert = false;
        try {
            if(c==null){
                c = new UtilDB().GetConn();
                estOuvert=true;
            }

            FactureFournisseur ff = (FactureFournisseur)this.getById(this.getId(), this.getNomTable(), c);

            //  CGenUtil.rechercher(f,null,null,c,"");
            return ff.genererBL(u, c).getId();
        } catch (Exception e) {
            throw e;
        }finally{
            if(estOuvert) c.close();
        }
    }

    private As_BonDeLivraison genererBL(String u,Connection c)throws Exception{
        boolean estOuvert = false;
        try {
            if(c==null){
                c = new UtilDB().GetConn();
                estOuvert=true;
            }
            As_BonDeLivraison bl = createBL();
            bl =(As_BonDeLivraison) bl.createObject(u,c);
            generateBLFille(bl,c,u);
            return bl;
        } catch (Exception e) {
            throw e;
        }finally{
            if(estOuvert)c.close();
        }
    }

    public void lierFactureFraisAccessoire(String u,Connection c) throws Exception{
        boolean canClose = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                canClose = true;
                c.setAutoCommit(false);
            }
            FactureFournisseur f = (FactureFournisseur)new FactureFournisseur().getById(this.getId(),"FACTUREFOURNISSEURCPL",c);
            LiaisonIntraTable l = new LiaisonIntraTable();
            l.setId1(f.getIdfactureprincipale());
            l.setId2(f.getId());
            l.setMontant(f.getMontantttc());
            l.createObject(u,c);
//                l.validerObject(u, c);
            if (canClose) {
                c.commit();
            }
        } catch (Exception e){
            if (canClose) {
                c.rollback();
            }
            throw e;
        } finally {
            if (canClose) {
                c.close();
            }
        }
    }

    @Override
    public ClassMAPTable createObject(String u,Connection c) throws Exception{
        //this.setTaux(((FactureFournisseurDetails[])this.getFille())[0].getTaux());
        double montantTTCCalc=AdminGen.calculSommeDouble(this.getFille(),"montantTTCCalc");
        double proportion=0;
        if(montantTTCCalc>0) proportion= this.getRemiseMontant()*100/montantTTCCalc;
        if(proportion>0){
            this.setRemise(proportion);
            this.setRemiseMontant(0);
        }
        // Application du dernier taux de change quand la devise n'est pas AR
        double taux = 1;
        if(this.getIdDevise() != null && this.getIdDevise().compareToIgnoreCase("AR") != 0) {
            taux = TauxDeChange.getLastTaux(c, Utilitaire.formatterDaty(this.getDaty()), this.getIdDevise());
        }

        FactureFournisseurDetails[] filles = (FactureFournisseurDetails[]) this.getFille();
        if(filles != null) {
            for (FactureFournisseurDetails ffd : filles) {
                if(this.getIdDevise() != null) {
                    ffd.setIdDevise(this.getIdDevise());
                }
                if(ffd.getIdDevise() != null && ffd.getIdDevise().compareToIgnoreCase("AR") != 0 && ffd.getTauxDeChange() <= 1) {
                    ffd.setTauxDeChange(taux);
                }
            }
        }

        FactureFournisseur facture = (FactureFournisseur) super.createObject(u, c);

        controleQuantiteFille(c);

        if(this.getIdObjet().startsWith("BL")){
             As_BonDeLivraison bl = (As_BonDeLivraison)new As_BonDeLivraison().getById(this.getIdObjet(), "AS_BONDELIVRAISON", null);
             bl.setIdFactureFournisseur(facture.getId());
             bl.updateToTableWithHisto(u,c);
        }

        if(this.getIdtypefacture()!=null && this.getIdtypefacture().equalsIgnoreCase(ConstanteSocobis.TYPE_FRAIS_ACCESSOIRE)){
            lierFactureFraisAccessoire(u, c);
        }
        return facture;
    }

    private void controleQuantiteFille(Connection c) throws Exception {
        if (this.getIdObjet() != null && !this.getIdObjet().isEmpty()) {
            if (this.getIdObjet().startsWith("BC")) {
                controleQuantiteFilleBC(c);
            } else if (this.getIdObjet().startsWith("BL")) {
                controleQuantiteFilleBL(c);
            }
        }
    }

    private void controleQuantiteFilleBC(Connection c) throws Exception {
        FactureFournisseurDetails[] factureFournisseurDetails = (FactureFournisseurDetails[]) getFille();

        As_BonDeCommande_Fille_CPL temp = new As_BonDeCommande_Fille_CPL();
        temp.setNomTable("AS_BONDECOMMANDE_CPL_RECEPT");
        As_BonDeCommande_Fille_CPL[] asBonDeCommandeFilleCpls = (As_BonDeCommande_Fille_CPL[]) CGenUtil.rechercher(temp, null, null, c, " and idbc = '" + this.getIdObjet() + "'");

        for (As_BonDeCommande_Fille_CPL asBonDeCommandeFilleCpl : asBonDeCommandeFilleCpls) {
            FactureFournisseurDetails[] temps = (FactureFournisseurDetails[]) AdminGen.find(factureFournisseurDetails, new String[]{"idProduit"}, new String[]{asBonDeCommandeFilleCpl.getProduit()});

            double sumQte = AdminGen.calculSommeDouble(temps, "qte");
            if (sumQte > asBonDeCommandeFilleCpl.getQtelivrer()) {
                throw new Exception("Le quantite du produit : " + asBonDeCommandeFilleCpl.getProduit() + " ne doit pas superieur a la quantite qui ete livre dans le bon de commande");
            }
        }
    }

    private void controleQuantiteFilleBL(Connection c) throws Exception {
        FactureFournisseurDetails[] factureFournisseurDetails = (FactureFournisseurDetails[]) getFille();

        As_BonDeLivraison_Fille_Cpl[] asBonDeLivraisonFilleCpls = (As_BonDeLivraison_Fille_Cpl[]) CGenUtil.rechercher(new As_BonDeLivraison_Fille_Cpl(), null, null, c, " and numbl = '" + getIdObjet() + "'");

        for (As_BonDeLivraison_Fille_Cpl asBonDeLivraisonFilleCpl : asBonDeLivraisonFilleCpls) {
            FactureFournisseurDetails[] temps = (FactureFournisseurDetails[]) AdminGen.find(factureFournisseurDetails, new String[]{"idProduit"}, new String[]{asBonDeLivraisonFilleCpl.getProduit()});

            double sumQte = AdminGen.calculSommeDouble(temps, "qte");
            if (sumQte > asBonDeLivraisonFilleCpl.getQuantite()) {
                throw new Exception("Le quantite du produit : " + asBonDeLivraisonFilleCpl.getProduit() + " ne doit pas superieur a la quantite dans le bon de livraison !");
            }
        }
    }

    private void generateBLFille(As_BonDeLivraison bl, Connection c, String u) throws Exception{
        FactureFournisseurDetailResteALivrerLib[] details = getDetailsResteALivrer(c,"FFFILLERESTEALIVRER");
        for (FactureFournisseurDetailResteALivrerLib d : details) {
            As_BonDeLivraison_Fille blf = d.createBLFille(bl.getId());
            blf.createObject(u,c);
        }
    }

    public FactureFournisseurDetailResteALivrerLib[] getDetailsResteALivrer(Connection c, String nomtable) throws Exception{
        FactureFournisseurDetailResteALivrerLib[] ffdetails = null;

            if(nomtable==null){
                nomtable = "FFFILLERESTEALIVRERLIB";
            }

            FactureFournisseurDetailResteALivrerLib details = new FactureFournisseurDetailResteALivrerLib();
            details.setNomTable(nomtable);
            ffdetails = (FactureFournisseurDetailResteALivrerLib[]) CGenUtil.rechercher(details, null, null, c, " and idfacturefournisseur = '"+this.getId()+"' and qte > 0");
            if (ffdetails.length == 0 ) {
                throw new Exception("Aucune livraison possible");
            }
            for(int i=0; i<ffdetails.length; i++){
                ffdetails[i].calculerTva();
                ffdetails[i].calculerHT();
                ffdetails[i].calculerTTC();
            }

        return ffdetails;
    }

    public FactureFournisseurDetailResteALivrerLib[] getDetailsFacture(Connection c, String nomtable) throws Exception{
        FactureFournisseurDetailResteALivrerLib[] ffdetails = null;

        if(nomtable==null){
            nomtable = "FFFILLERESTEALIVRER";
        }

        FactureFournisseurDetailResteALivrerLib details = new FactureFournisseurDetailResteALivrerLib();
        details.setNomTable(nomtable);
        ffdetails = (FactureFournisseurDetailResteALivrerLib[]) CGenUtil.rechercher(details, null, null, c, " and idfacturefournisseur = '"+this.getId()+"'");
        for(int i=0; i<ffdetails.length; i++){
            ffdetails[i].calculerTva();
            ffdetails[i].calculerHT();
            ffdetails[i].calculerTTC();
        }

        return ffdetails;
    }

    public As_BonDeLivraison createBL() throws Exception {
        As_BonDeLivraison bl = new As_BonDeLivraison();
        bl.setDaty(Utilitaire.dateDuJourSql());
        //bl.setIdbc(this.getId());
        bl.setMagasin(this.getIdMagasin());
        bl.setIdFournisseur(this.getIdFournisseur());
        bl.setIdFactureFournisseur(this.getId());
        bl.setRemarque(this.getDesignation());
        bl.setEtat(ConstanteEtat.getEtatCreer());
        return bl;
    }

    public FactureFournisseurDetailsCpl[] getFactureFournisseurDetails(Connection c) throws Exception {
        FactureFournisseurDetailsCpl obj = new FactureFournisseurDetailsCpl();
        obj.setNomTable("FACTUREFOURNISSEURFILLECPL");
        obj.setIdFactureFournisseur(this.getId());
        FactureFournisseurDetailsCpl[] objs = (FactureFournisseurDetailsCpl[]) CGenUtil.rechercher(obj, null, null, c, " ");
        if (objs.length > 0) {
            return objs;
        }
        return null;
    }

    public void genererAPartirLivraison(String[] ids, String u, Connection c) throws Exception {
        boolean canClose = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                canClose = true;
            }
            As_BonDeLivraison[] bls = As_BonDeLivraison.getAll(ids, c);
            As_BonDeLivraison.controlerFournisseur(bls);

            this.setDesignation("Facturation de Bon de Livraison");
            this.setIdFournisseur(bls[0].getIdFournisseur());
            this.setIdMagasin(bls[0].getMagasin());
            this.setDaty(Utilitaire.dateDuJourSql());
            this.setIdDevise("AR");
            this.createObject(u, c);
            for (As_BonDeLivraison bl : bls) {
                bl.setIdFactureFournisseur(this.getId());
                bl.setEtat(1);
                bl.updateToTableWithHisto(u, c);
            }
            As_BonDeLivraison_Fille blf = new As_BonDeLivraison_Fille();
            String[] somGr = { "quantite" };
            String[] gr = { "produit" };
            String[] tabvide = {};
            ResultatEtSomme rs = CGenUtil.rechercherGroupe(blf, gr, somGr, null, null,
                    " and numbl in " + Utilitaire.tabToString(ids, "'", ","), tabvide, "", c);
            As_BonDeLivraison_Fille[] blfs = (As_BonDeLivraison_Fille[]) rs.getResultat();
            for (As_BonDeLivraison_Fille item : blfs) {
                FactureFournisseurDetails vd = item.toFactureFournisseurDetails();
                vd.setIdFactureFournisseur(this.getId());
                vd.setIdDevise("AR");
                vd.createObject(u, c);
            }
        } catch (Exception e) {
            throw e;
        } finally {
            if (canClose) {
                c.close();
            }
        }
    }

    public Prevision[] getPrevisions(Connection c) throws Exception{
        Boolean estOuvert = false;
        try{
            if(c==null){
                c = new UtilDB().GetConn();
                estOuvert=true;
            }
            Prevision prevision = new Prevision();
            prevision.setIdFacture(this.getId());
            Prevision[] prev = (Prevision[]) CGenUtil.rechercher(prevision, null, null, c, " ");
            return prev;
        } catch (Exception e) {
            throw e;
        } finally {
            if(estOuvert)c.close();
        }
    }

    public void lierLivraisons(String u, String [] idLivraison) throws Exception{
        Connection c = null;
        try {
            c = new UtilDB().GetConn();
            FactureFournisseurDetails[] factDetails = getFactureFournisseurDetails(c);
            As_BonDeLivraison [] blcs = As_BonDeLivraison.getAll(idLivraison,c);
            As_BonDeLivraison.controlerFournisseur(blcs);
            for (As_BonDeLivraison blcTemp : blcs) {
                blcTemp.setIdFactureFournisseur(this.getId());
                blcTemp.updateToTableWithHisto(u, c);
                As_BonDeLivraison_Fille [] blcfs = (As_BonDeLivraison_Fille[]) CGenUtil.rechercher(new As_BonDeLivraison_Fille(), null, null, c, " and NUMBL = '"+ blcTemp.getId() +"'");
                    for (int i = 0; i < factDetails.length; i++) {
                        for (As_BonDeLivraison_Fille as_BonDeLivraisonFilleTemp: blcfs) {
                            if(factDetails[i].getIdProduit().equals(as_BonDeLivraisonFilleTemp.getProduit())){
                                as_BonDeLivraisonFilleTemp.setIdFactureFournisseur(factDetails[i].getId());
                                as_BonDeLivraisonFilleTemp.updateToTableWithHisto(u, c);
                            }
                        }
                    }
            }

        } catch (Exception e) {
            throw e;
        } finally {
            if (c != null) {
                c.close();
            }
        }
    }
    public As_BonDeLivraison createBLN()throws Exception{
        FactureFournisseur ff = (FactureFournisseur)this.getById(this.getId(), this.getNomTable(), null);
        As_BonDeLivraison bl = ff.createBL();
        //bl =(As_BonDeLivraison) bl.createObject(u,c);
        //generateBLFille(bl,c,u);

        return bl;
    }
    public As_BonDeLivraison_Fille_Cpl[] generateBLFilles(As_BonDeLivraison bl, Connection c) throws Exception{
        boolean estOuvert = false;
        try {
            if(c==null){
                c = new UtilDB().GetConn();
                estOuvert=true;
            }

            FactureFournisseurDetailResteALivrerLib[] details = getDetailsResteALivrer(c,"FFFILLERESTEALIVRER");
            return getAsBonDeLivraisonFilleCpls(bl, details);
        } catch (Exception e) {
            throw e;
        }finally{
            if(estOuvert)c.close();
        }
    }

    public As_BonDeLivraison_Fille_Cpl[] generateBLFillesSansException(As_BonDeLivraison bl, Connection c) throws Exception{
        boolean estOuvert = false;
        try {
            if(c==null){
                c = new UtilDB().GetConn();
                estOuvert=true;
            }

            FactureFournisseurDetailResteALivrerLib[] details = getDetailsFacture(c,null);
            return getAsBonDeLivraisonFilleCpls(bl, details);
        } catch (Exception e) {
            throw e;
        }finally{
            if(estOuvert)c.close();
        }
    }

    private As_BonDeLivraison_Fille_Cpl[] getAsBonDeLivraisonFilleCpls(As_BonDeLivraison bl, FactureFournisseurDetailResteALivrerLib[] details) throws Exception {
        As_BonDeLivraison_Fille_Cpl[] values = new As_BonDeLivraison_Fille_Cpl[details.length];
        int indice = 0;
        for (FactureFournisseurDetailResteALivrerLib d : details) {
            values[indice] = new As_BonDeLivraison_Fille_Cpl();
            values[indice] = d.createBLFille(bl.getId());
            //blf.createObject(u,c);
            indice ++;
        }
        return values;
    }

    public FactureFournisseurDetails[] getFactureFF(String idFCF, Connection c)throws Exception{
        boolean estOuvert = false;
        try {
            if(c==null){
                c = new UtilDB().GetConn();
                estOuvert=true;
            }
            FactureFournisseurDetails mapping = new FactureFournisseurDetails();
            mapping.setNomTable("FFFILLERESTEALIVRER");
            mapping.setIdFactureFournisseur(idFCF);
            FactureFournisseurDetails[] tab = (FactureFournisseurDetails[]) CGenUtil.rechercher(mapping,null,null,"");
            if(tab.length>0){
                return tab;
            }else{
                throw new Exception("Aucune Facture Fille rattach&eacute; pour cette Facture : "+ idFCF);
            }
        } catch (Exception e) {
            throw e;
        }finally{
            if(estOuvert)c.close();
        }
    }

    public void attacherBL(String u, Connection c) throws Exception {
        As_BonDeLivraison[] bonDeLivraisons = this.gettBondelivraisons(c, null);
        for (As_BonDeLivraison bl : bonDeLivraisons) {
            if(bl.getIdFactureFournisseur()==null||bl.getIdFactureFournisseur().equals("")){
                bl.setIdFactureFournisseur(this.getId());
                bl.updateToTableWithHisto(u, c);
            }
        }
    }

    private As_BonDeLivraison[] gettBondelivraisons(Connection c, String nomtable) throws Exception {
        return Objects.requireNonNull(getBC(c, null)).getBondelivraisons(c, nomtable);
    }

    private As_BonDeCommande getBC(Connection c, String nomtable) throws Exception {
        As_BonDeCommande crt = new As_BonDeCommande();
        if(nomtable==null){
            crt.setNomTable(nomtable);
        }
        crt.setId(this.getIdBc());
        As_BonDeCommande[] values = (As_BonDeCommande[]) CGenUtil.rechercher(crt, null, null, c, "");
        if(values.length>0)return values[0];
        return null;
    }



    public String getBLMere(String idFCF, Connection c) throws Exception{
        boolean estOuvert = false;
        try {
            if(c==null){
                c = new UtilDB().GetConn();
                estOuvert=true;
            }
            As_BonDeLivraison mapping = new As_BonDeLivraison();
            mapping.setIdFactureFournisseur(idFCF);
            mapping.setNomTable("AS_BONDELIVRAISON");
            As_BonDeLivraison[] tab = (As_BonDeLivraison[]) CGenUtil.rechercher(mapping,null,null,"");
            if(tab.length>0){
                return tab[0].getId();
            }else{
                throw new Exception("Aucun BL rattach&eacute; pour cette Facture!" + idFCF);
            }
        } catch (Exception e) {
            throw e;
        }finally{
            if(estOuvert)c.close();
        }
    }

    public String getIdMvtStockMere(String idFCF, Connection c) throws Exception{
        boolean estOuvert = false;
        try {
            if(c==null){
                c = new UtilDB().GetConn();
                estOuvert=true;
            }
            String idBLMere = this.getBLMere(idFCF, c);
            MvtStock mapping = new MvtStock();
            mapping.setNomTable("MVTSTOCK");
            mapping.setIdobjet(idBLMere);
            MvtStock[] fille = (MvtStock[]) CGenUtil.rechercher(mapping,null,null,"");
            if(fille.length>0){
                return fille[0].getId();
            }
            return null;
        } catch (Exception e) {
            throw e;
        }finally{
            if(estOuvert)c.close();
        }
    }

    public MvtStockFille[] getMvtStockFille(String idFCF, Connection c) throws Exception{
        boolean estOuvert = false;
        try {
            if(c==null){
                c = new UtilDB().GetConn();
                estOuvert=true;
            }
            String idMvtStock = this.getIdMvtStockMere(idFCF, c);
            MvtStockFille mapping = new MvtStockFille();
            mapping.setNomTable("MvtStockFille");
            mapping.setIdMvtStock(idMvtStock);
            MvtStockFille[] fille = (MvtStockFille[]) CGenUtil.rechercher(mapping,null,null,"");
            if(fille.length>0){
                return fille;
            }
            return null;
        } catch (Exception e) {
            throw e;
        }finally{
            if(estOuvert)c.close();
        }
    }

    public double getPriceUpdated(As_BonDeLivraison_Fille_Cpl[] ff, String idProduit) throws Exception {
        if (ff == null || ff.length == 0 || idProduit == null) {
            return 0;
        }
        for (int i = 0; i < ff.length; i++) {
            if (ff[i].getProduit() != null && ff[i].getProduit().equals(idProduit)) {
                return ff[i].getPu();
            }
        }
        return 0;
    }

    public int checkPrix(double prix1, double prix2){
        int rep = 0;
        if(prix1 == prix2){
            rep = 1;
        }
        return rep;


    }

    public String getReferenceByID(String id) throws Exception
    {
        Connection c = null;

        try{

            c = new UtilDB().GetConn();
            FactureFournisseur f = (FactureFournisseur) getById(id, "FACTUREFOURNISSEUR", c);
            return f.getReference();

        } catch (Exception e)
        {
            throw new Exception("Facture fournisseur introuvable avec ID: " + id, e);
        } finally {
            if (c != null)
            {
                c.close();
            }
        }
    }

    public void updatePrixMVTFilleSRC(MvtStockFille src, As_BonDeLivraison_Fille_Cpl[] bf, MvtStockFille[] mvt, Connection c)throws Exception{
        boolean estOuvert = false;
        try {
            if(c==null){
                c = new UtilDB().GetConn();
                estOuvert=true;
            }
            MvtStockFille mapping = new MvtStockFille();
            mapping.setNomTable("MvtStockFille");
            mapping.setMvtSrc(src.getId());
            MvtStockFille[] fille = (MvtStockFille[]) CGenUtil.rechercher(mapping,null,null,"");
            if(fille.length>0){
                for(int i=0; i<fille.length; i++){
                    int isCheck = this.checkPrix(fille[i].getPu() ,this.getPriceUpdated(bf, mvt[i].getIdProduit()));
                    if(isCheck == 0){
                        fille[i].setPu(this.getPriceUpdated(bf, mvt[i].getIdProduit()));
                        fille[i].updateToTable(c);
                    }else{
                        continue;
                    }
                }
            }
        } catch (Exception e) {
            throw e;
        }finally{
            if(estOuvert)c.close();
        }
    }

    public void insertAndUpdateHistoriquePrix(FactureFournisseurDetails[] ff, As_BonDeLivraison_Fille_Cpl[] bf, MvtStockFille[] mvt, String u, Connection c) throws Exception{
        boolean estOuvert = false;
        try {
            if(c==null){
                c = new UtilDB().GetConn();
                estOuvert=true;
            }
            for(int i=0; i<bf.length;i++){
                // update Prix MVTSTOCKFILLE avec SRC
                this.updatePrixMVTFilleSRC(mvt[i], bf, mvt, c);

                // update Prix MVTSTOCKFILLE
                int isCheck = this.checkPrix(mvt[i].getPu(),this.getPriceUpdated(bf, mvt[i].getIdProduit()));
                if(isCheck == 0){
                    mvt[i].setPu(this.getPriceUpdated(bf, mvt[i].getIdProduit()));
                    mvt[i].updateToTable(c);

                    // Ajout dans HISTORIQUEPRIX
                    HistoriquePrix mapping = new HistoriquePrix();
                    mapping.setDaty(utilitaire.Utilitaire.dateDuJourSql());
                    mapping.setPv(this.getPriceUpdated(bf, bf[i].getProduit()));
                    mapping.setIdProduit(bf[i].getProduit());
                    mapping.setIdFacturefournisseurfille(bf[i].getIddetailsfacturefournisseur());
                    mapping.setRemarque(this.getId()+" : Prix du "+bf[i].getProduit()+" le "+utilitaire.Utilitaire.dateDuJourSql());
                    mapping.createObject(u, c);
                }else{
                    continue;
                }
            }
        } catch (Exception e) {
            throw e;
        }finally{
            if(estOuvert)c.close();
        }
    }

    public void updatePriceMvtStockFille(String idFCF, String u,Connection c)throws Exception{
        boolean estOuvert = false;
        try {
            if(c==null){
                c = new UtilDB().GetConn();
                estOuvert=true;
            }
            MvtStockFille[] mvtStockFille = this.getMvtStockFille(idFCF, c);
            FactureFournisseurDetails[] ff = this.getFactureFF(idFCF, c);
            As_BonDeLivraison asBL = new As_BonDeLivraison();
            asBL.setId(this.getBLMere(idFCF, c));
            As_BonDeLivraison_Fille_Cpl[] bl = this.generateBLFillesSansException(asBL ,c);
            this.insertAndUpdateHistoriquePrix(ff, bl, mvtStockFille, u, c);
        } catch (Exception e) {
            throw e;
        }finally{
            if(estOuvert)c.close();
        }
    }

    @Override
    public int updateToTableWithHisto(String refUser, Connection c) throws Exception {
//        updatePriceMvtStockFille(getId(), refUser, c);
        return super.updateToTableWithHisto(refUser, c);
    }

    public String getIdtypefacture() {
        return idtypefacture;
    }

    public void setIdtypefacture(String idtypefacture) {
        this.idtypefacture = idtypefacture;
    }
    public FactureFournisseur reglerReleverDebit(String u, Connection c, String[] ids) throws Exception{
        boolean canClose=false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                canClose = true;
                c.setAutoCommit(false);
            }
            FactureFournisseur facture = (FactureFournisseur) super.createObject(u,c);
            FactureFournisseurDetails[] filles = (FactureFournisseurDetails[]) facture.getFille();
            double montant = 0;
            for (FactureFournisseurDetails fille : filles ) {
                //fille.createObject(u,c);
                fille.validerObject(u,c);
                montant += fille.getPu() * fille.getQte();
            }
            facture.validerObject(u,c);

            MvtCaisse mvt = new MvtCaisse();
            mvt.setIdCaisse(facture.getReference());
            mvt.setDesignation("Paiement de la facture de règlement : "+facture.getId());
            mvt.setIdTiers(facture.getIdFournisseur());
            mvt.setDaty(facture.getDaty());
            mvt.setIdOrigine(facture.getId());
            mvt.setDebit(montant);
            mvt.setCredit(0);
            MvtCaisse val = (MvtCaisse) mvt.createObject(u,c);
            mvt.validerObject(u,c);

            ComptaEcriture ce = new ComptaEcriture();
            ce.setIdobjet(val.getId());
            ComptaEcriture[] ecriture = (ComptaEcriture[]) CGenUtil.rechercher(ce,null,null,c,"");
            if (ecriture.length > 0) {
                ecriture[0].validerObject(u,c);
                ComptaSousEcriture sousEcriture = new ComptaSousEcriture();
                ComptaSousEcriture[] sousEcritures = (ComptaSousEcriture[]) CGenUtil.rechercher(sousEcriture,null,null,c," AND IDMERE='"+ecriture[0].getId()+"' AND COMPTE like '5%'");
                String[] idEcritures = new String[1];
                //for (int i = 0; i < sousEcritures.length; i++) {
                idEcritures[0] = sousEcritures[0].getId();
                sousEcritures[0].validerObject(u,c);
                //}
                RapprochementDBMere rp = new RapprochementDBMere().rapprochement(u,idEcritures,ids,c);
                rp.validerObject(u,c);
            }
            c.commit();
            return facture;
        }catch (Exception e){
            if(canClose) c.rollback();
            throw e;
        } finally {
            if(canClose) c.close();
        }
    }

    public FactureFournisseur creerValiderPayer(String u,Connection c) throws Exception {
        boolean canClose = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                canClose = true;
                c.setAutoCommit(false);
            }
            FactureFournisseur facture = (FactureFournisseur) super.createObject(u,c);
            FactureFournisseurDetails[] filles = (FactureFournisseurDetails[]) facture.getFille();
            double montant = 0;
            for (FactureFournisseurDetails fille : filles ) {
                fille.validerObject(u,c);
                montant += fille.getPu() * fille.getQte();
            }
            facture.validerObject(u,c);
//            MvtCaisse mvt = new MvtCaisse();
//            mvt.setIdCaisse(facture.getReference());
//            mvt.setDesignation("Paiement de la facture : "+facture.getId());
//            mvt.setIdTiers(facture.getIdFournisseur());
//            mvt.setDaty(facture.getDaty());
//            mvt.setIdOrigine(facture.getId());
//            mvt.setDebit(montant);
//            mvt.setCredit(0);
//            mvt.createObject(u,c);
//            mvt.validerObject(u,c);
            if (canClose) {
                c.commit();
            }
            return facture;
        } catch (Exception e){
            if (canClose) {
                c.rollback();
            }
            throw e;
        } finally {
            if (canClose) {
                c.close();
            }
        }
    }

    public AvoirAchat genererAvoirAchatMereFille(Connection c) throws Exception {
        boolean canClose = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                canClose = true;
            }
            FactureFournisseur facture = (FactureFournisseur) new FactureFournisseur().getById(this.getId(),null,c);
            if (facture == null) return null;
            FactureFournisseurDetailsCpl detail = new FactureFournisseurDetailsCpl();
            detail.setIdFactureFournisseur(facture.getId());
            FactureFournisseurDetailsCpl[] details = (FactureFournisseurDetailsCpl[])CGenUtil.rechercher(detail,null,null,c,"");
            AvoirAchat avoir = new AvoirAchat();
//            avoir.setDaty(Utilitaire.dateDuJourSql());
            avoir.setIdFacture(facture.getId());
//            avoir.setIdMagasin(facture.getIdMagasin());
            avoir.setIdFournisseur(facture.getIdFournisseur());
            avoir.setDesignation("Avoir sur facture : "+facture.getId());

            AvoirAchatFille[] filles = new AvoirAchatFille[details.length];
            for (int i = 0; i < filles.length; i++) {
                filles[i] = new AvoirAchatFille();
                filles[i].setIdProduit(details[i].getIdProduit());
                filles[i].setPu(details[i].getPu());
                filles[i].setDesignation(details[i].getIdProduitLib());
                filles[i].setQte(details[i].getQte());
                filles[i].setIdFactureDetails(details[i].getId());
                filles[i].setIdDevise(details[i].getIdDevise());
                filles[i].setTaux(details[i].getTauxDeChange()  );
            }
            avoir.setFille(filles);
            return avoir;
        } finally {
            if (canClose) c.close();
        }
    }

    public FactureFournisseur getFactureFournisseurById(String id, String nt, Connection c) throws  Exception {
        boolean canClose = false;
        try {
            if (c == null) {
                canClose = true;
                c = (new UtilDB()).GetConn();
            }
            return (FactureFournisseur) getById(id, nt, c);
        } finally {
            if (canClose) {
                if (c != null) c.close();
            }
        }
    }
}
