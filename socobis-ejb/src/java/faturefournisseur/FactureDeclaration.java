/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package faturefournisseur;

import bean.AdminGen;
import bean.CGenUtil;
import bean.ClassMAPTable;
import bean.ResultatEtSomme;
import caisse.Caisse;
import caisse.MvtCaisse;
import chatbot.FilleOcr;
import chatbot.MereOcr;
import magasin.Magasin;
import mg.cnaps.compta.ComptaEcriture;
import mg.cnaps.compta.ComptaSousEcriture;
import mg.cnaps.compta.ConstanteCompta;
import prevision.Prevision;
import rapprochement.RapprochementDBMere;
import stock.HistoriquePrix;
import stock.MvtStock;
import stock.MvtStockFille;
import utilitaire.ConstanteEtat;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;
import utils.ConstanteStation;
import vente.FactureCF;

import java.sql.Connection;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

public class FactureDeclaration extends FactureCF{
    protected String idFournisseur,idModePaiement,reference,idBc,idMagasin, fournisseurlib;
    protected Date dateEcheancePaiement;
    protected String devise;
    protected double taux;
    protected String idDevise;
    protected String compte,compteauxiliaire;
    int estPrevu;
     private double montantPerteGain;
    private String idObjet;
    private String idRef;

    private String idDmdAchat;
    private String idtypefacture;
    private String numero;
    private String typeachat;


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

    public static FactureDeclaration fromOcr(MereOcr mere) throws Exception {
        FactureDeclaration f = new FactureDeclaration();
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

        FactureDeclarationDetails[] filles = fillesFromOcr(mere.getDetails().toArray(new FilleOcr[0]));
        f.setFille(filles);

        return f;
    }
    public static FactureDeclarationDetails[] fillesFromOcr(FilleOcr[] filles) throws Exception {
        FactureDeclarationDetails[] f = new FactureDeclarationDetails[filles.length];
        for (int i = 0; i < filles.length; i++) {
            f[i] = FactureDeclarationDetails.fromOcr(filles[i]);
        }
        return f;
    }
    @Override
    public String getLiaisonFille() {
        return "idFactureFournisseur";
    }
    @Override
    public String getNomClasseFille() {
        return "faturefournisseur.FactureDeclarationDetails";
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
        this.idDevise = idDevise;
    }

    public FactureDeclaration(String nomtable) {
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
    public FactureDeclaration() {
        super.setNomTable("FACTUREDECLARATION");
    }
    public void construirePK(Connection c) throws Exception {
        this.preparePk("FCD", "GETSEQ_FACTUREDECLARATION");
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
        FactureDeclarationDetails[] fille = (FactureDeclarationDetails[]) this.getFille("FACTUREDECLARATIONFILLE", c, "");
        List<Prevision> previsions = new ArrayList<>();

        for (FactureDeclarationDetails f : fille)
        {
            Prevision prev = f.genererPrevision();
            prev.setDaty(this.getDateEcheancePaiement());
            prev.setIdTiers(this.getIdFournisseur());
            Prevision newPrev = (Prevision) prev.createObject(u, c);

            previsions.add(newPrev);
            System.out.println("Prevision created from Facture declarer: " + newPrev.getId());
        }

        return previsions.toArray(new Prevision[previsions.size()]);

    }

    public FactureDeclaration getFactureWithMontant(Connection c) throws Exception{
        return (FactureDeclaration)new FactureDeclaration().getById(this.getId(),"FACTUREDECLARATIONCPL",c);
    }

    public void genererEcritureDecaissement(String u, Connection c) throws Exception{
        ComptaEcriture mere = new ComptaEcriture();
        Date dateDuJour = Utilitaire.dateDuJourSql();
        int exercice = Utilitaire.getAnnee(getDaty());
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
            FactureDeclaration[] factureDeclaration = (FactureDeclaration[]) CGenUtil.rechercher(new FactureDeclaration("FACTUREDECLARATION_MERECMPT"), null, null, c, " and id = '"+this.getId()+"'");
            if(factureDeclaration.length<1) throw new Exception("Facture mere Introuvable");
            this.setCompte(factureDeclaration[0].getCompte());

            compta = new ComptaSousEcriture[2];

            compta[0]=new ComptaSousEcriture();
            compta[0].setLibellePiece(this.getDesignation());
            compta[0].setRemarque(this.getDesignation());
            compta[0].setCompte(getCaisse(c).getCompte());
            compta[0].setCredit(factureDeclaration[0].getMontantttc());

            compta[1]=new ComptaSousEcriture();
            compta[1].setLibellePiece("Decaissement fournisseur "+factureDeclaration[0].getFournisseurlib());
            compta[1].setRemarque("Decaissement fournisseur "+factureDeclaration[0].getFournisseurlib());
            compta[1].setCompte(this.getCompte());
//            compta[i].setDebit((montantHT-retenue) * ((this.getTva()/100)));
            compta[1].setDebit(factureDeclaration[0].getMontantttc());

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
        int exercice = this.getDaty().getYear()+1900;
        ComptaEcriture mere = new ComptaEcriture();
        //System.out.println("Daty "+this.getDaty().getYear()+" designation "+this.getDesignation()+" id "+this.getId());
        mere.setDaty(this.getDaty());
        mere.setDesignation("Ecriture liee a la facture "+this.getDesignation()+ " ref : "+this.getId());
        mere.setExercice(""+exercice);
        mere.setDateComptable(this.getDaty());
        mere.setJournal(ConstanteStation.journalAchat);
        mere.setIdobjet(this.getId());
        mere.setOrigine(this.getId());
        mere.createObject(u, c);
        ComptaSousEcriture[] filles = this.genererSousEcriture(c);
        for(int i=0; i<filles.length; i++){
            System.out.println("fille ==  = = = " + filles[i].getCompte());
            filles[i].setIdMere(mere.getId());
            filles[i].setExercice(exercice);
            filles[i].setDaty(this.getDaty());
            filles[i].setJournal(ConstanteStation.journalAchat);
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
            FactureDeclarationDetails details [] = this.getDetails(c);
            double montantTva = AdminGen.calculSommeDouble(details,"montantTva")*details[0].getTauxDeChange();
            double montantHT = AdminGen.calculSommeDouble(details,"montantHT")*details[0].getTauxDeChange();
            double montantTTC = AdminGen.calculSommeDouble(details,"montantTTC")*details[0].getTauxDeChange();
            int taille = details.length;
            compta = new ComptaSousEcriture[taille+(montantTva>0?2:1)];
            int i=0;
            for(i=i;i<taille;i++){
                compta[i]=new ComptaSousEcriture();
                compta[i].setLibellePiece(this.getDesignation());
                compta[i].setRemarque(this.getDesignation());
                System.out.println("COMPTE = "+details[i].getCompte()+" mo");
                compta[i].setCompte(details[i].getCompte());
                compta[i].setDebit(details[i].getMontantHT()*details[0].getTauxDeChange());
            }


            Fournisseur fo=this.getFournisseur(c);
            compta[i]=new ComptaSousEcriture();
            compta[i].setLibellePiece("Achat Fournisseur "+fo.getNom());
            compta[i].setRemarque("Achat Fournisseur "+fo.getNom());
            compta[i].setCompte(fo.getCompte());
            compta[i].setCredit(montantTTC);
            compta[i].setCompte_aux(fo.getCompteauxiliaire());

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
    public FactureDeclarationDetails[] getDetails(Connection c) throws Exception{
        FactureDeclarationDetails[] ffdetails = null;
           try{
               FactureDeclarationDetails details = new FactureDeclarationDetails();
            details.setNomTable("FACTUREDECLARATION_FILLE_VISE");
            String awhere = " and IDFACTUREFOURNISSEUR = '"+this.getId()+"'";
            ffdetails = (FactureDeclarationDetails[]) CGenUtil.rechercher(details, null, null, c, awhere);
        }catch(Exception e){
            e.printStackTrace();
        }
        return ffdetails;
    }

    @Override
    public Object validerObject(String u, Connection c) throws Exception {
        this.setNumeroNext(c);
        super.validerObject(u, c);
        //genererEcriture(u, c);
        //if(estPrevu == 0){
        //    genererPrevision(u, c);
        //}
        //else if (this.getEstPrevu() == 1){
        //    genererPrevisionPrevu(u, c);
        //}
        return this;
    }
    public void updateBcFactureViaBL(String idBL,String u, Connection c)throws Exception{
        As_BonDeLivraison bl = (As_BonDeLivraison)new As_BonDeLivraison().getById(idBL, "AS_BONDELIVRAISON", null);
        this.setIdBc(bl.getIdbc());
        this.updateToTableWithHisto(u,c);
    }

    public void setNumeroNext(Connection c) throws Exception {

        FactureDeclarationCpl crit = new FactureDeclarationCpl();
        crit.setNomTable("FACTUREDECLARATIONCPL");
        crit.setId(this.getId());
        FactureDeclarationCpl[] fournisseurs = (FactureDeclarationCpl[]) CGenUtil.rechercher(crit, null, null, c, "");

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
        Date datyfact = new Date(dateFacture.getTime());
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


    public FactureDeclarationCpl getFactureDeclarationCpl(Connection c) throws Exception {
        if (c == null) {
            throw new Exception("Connection non etablie");
        }
        FactureDeclarationCpl fact = new FactureDeclarationCpl();
        fact.setNomTable("FACTUREDECLARATIONCPL_MONTANT");
        fact.setId(this.getId());
        FactureDeclarationCpl[] epts = (FactureDeclarationCpl[]) CGenUtil.rechercher(fact, null, null, c, " ");
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

            FactureDeclaration ff = (FactureDeclaration)this.getById(this.getId(), this.getNomTable(), c);

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

    @Override
    public ClassMAPTable createObject(String u,Connection c) throws Exception{
        FactureDeclaration facture = (FactureDeclaration) super.createObject(u, c);
        if(this.getIdObjet().startsWith("BL")){
             As_BonDeLivraison bl = (As_BonDeLivraison)new As_BonDeLivraison().getById(this.getIdObjet(), "AS_BONDELIVRAISON", null);
             bl.setIdFactureFournisseur(facture.getId());
             bl.updateToTableWithHisto(u,c);
        }
        return facture;
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
            ffdetails = (FactureFournisseurDetailResteALivrerLib[]) CGenUtil.rechercher(details, null, null, c, " and idfacturedeclaration = '"+this.getId()+"' and qte > 0");
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
        ffdetails = (FactureFournisseurDetailResteALivrerLib[]) CGenUtil.rechercher(details, null, null, c, " and idfacturedeclaration = '"+this.getId()+"'");
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

    public FactureDeclarationDetailsCpl[] getFactureDeclarationDetails(Connection c) throws Exception {
        FactureDeclarationDetailsCpl obj = new FactureDeclarationDetailsCpl();
        obj.setNomTable("FACTUREDECLARATIONFILLECPL");
        obj.setIdFactureFournisseur(this.getId());
        FactureDeclarationDetailsCpl[] objs = (FactureDeclarationDetailsCpl[]) CGenUtil.rechercher(obj, null, null, c, " ");
        if (objs.length > 0) {
            return objs;
        }
        return null;
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

    public FactureDeclarationDetails[] getFactureFF(String idFCF, Connection c)throws Exception{
        boolean estOuvert = false;
        try {
            if(c==null){
                c = new UtilDB().GetConn();
                estOuvert=true;
            }
            FactureDeclarationDetails mapping = new FactureDeclarationDetails();
            mapping.setNomTable("FFFILLERESTEALIVRER");
            mapping.setIdFactureFournisseur(idFCF);
            FactureDeclarationDetails[] tab = (FactureDeclarationDetails[]) CGenUtil.rechercher(mapping,null,null,"");
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

    public void insertAndUpdateHistoriquePrix(FactureDeclarationDetails[] ff, As_BonDeLivraison_Fille_Cpl[] bf, MvtStockFille[] mvt, String u, Connection c) throws Exception{
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
                    mapping.setDaty(Utilitaire.dateDuJourSql());
                    mapping.setPv(this.getPriceUpdated(bf, bf[i].getProduit()));
                    mapping.setIdProduit(bf[i].getProduit());
                    mapping.setIdFacturefournisseurfille(bf[i].getIddetailsfacturefournisseur());
                    mapping.setRemarque(this.getId()+" : Prix du "+bf[i].getProduit()+" le "+ Utilitaire.dateDuJourSql());
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
    public FactureDeclaration reglerReleverDebit(String u, Connection c, String[] ids) throws Exception{
        boolean canClose=false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                canClose = true;
                c.setAutoCommit(false);
            }
            FactureDeclaration facture = (FactureDeclaration) super.createObject(u,c);
            FactureDeclarationDetails[] filles = (FactureDeclarationDetails[]) facture.getFille();
            double montant = 0;
            for (FactureDeclarationDetails fille : filles ) {
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

    public FactureDeclaration creerValiderPayer(String u, Connection c) throws Exception {
        boolean canClose = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                canClose = true;
                c.setAutoCommit(false);
            }
            FactureDeclaration facture = (FactureDeclaration) super.createObject(u,c);
            FactureDeclarationDetails[] filles = (FactureDeclarationDetails[]) facture.getFille();
            double montant = 0;
            for (FactureDeclarationDetails fille : filles ) {
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

    /*
    public Prevision[] genererPrevisionPrevu(String u, Connection c) throws Exception {
        FactureFournisseurDetails[] details = (FactureFournisseurDetails[]) getFille("FACTUREDECLARATIONFILLE", c, "");
        Prevision[] previsions = new Prevision[details.length];
        for (int i = 0; i < details.length; i++) {
            previsions[i] = details[i].genererPrevisionPrevu(u, c);
        }
        return  previsions;
    }
     */

    public FactureDeclarationDetails getDetailsDeclaration(Connection c) throws Exception{
        boolean canClose = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                canClose = true;
                c.setAutoCommit(false);
            }
            FactureDeclarationDetails [] det = (FactureDeclarationDetails[]) CGenUtil.rechercher(new FactureDeclarationDetails(),null,null,c,"");
            if(det.length>0){
                return det[0];
            }
            throw new Exception("Pas de d&eacute;tail pour cette facture");
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

}
