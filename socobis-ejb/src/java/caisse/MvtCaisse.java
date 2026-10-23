/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package caisse;

import avoir.AvoirFCLib;
import bean.*;
import chatbot.AiColDesc;
import chatbot.AiTabDesc;
import chatbot.ClassIA;
import client.Client;
import com.google.gson.Gson;
import constante.ConstanteEtat;
import change.TauxDeChange;

import facture.tr.Traite;
import faturefournisseur.FactureFournisseur;
import faturefournisseur.FactureFournisseurCpl;
import faturefournisseur.Fournisseur;
import magasin.Magasin;

import java.sql.Connection;
import java.sql.Date;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import mg.cnaps.compta.ComptaEcriture;
import mg.cnaps.compta.ComptaLettrage;
import mg.cnaps.compta.ComptaSousEcriture;
import mg.cnaps.compta.Journal;
import paiement.LiaisonPaiement;
import paramCompta.ParamComptaStatique;
import pertegain.PerteGainImprevueLib;
import pertegain.Tiers;
import prevision.MvtCaissePrevision;
import prevision.Prevision;
import prevision.PrevisionComplet;
import utilitaire.ConstanteCompta;
import utilitaire.ConstanteComptable;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;
import utils.ConstanteAsync;
import utils.ConstanteSocobis;
import utils.ConstanteStation;
import vente.FactureCF;
import vente.Vente;
import vente.VenteLib;

/**
 *
 * @author nouta
 */

@AiTabDesc("La table MOUVEMENTCAISSE représente les mouvements de caisses pour les caisse existant dans l'application")
public class MvtCaisse extends ClassEtat implements ClassIA{
    @AiColDesc("id du mouvement de caisse")
    private String id;
    private String designation,idVenteDetail,idVirement,idOp,idtraite,idTiers;
    @AiColDesc("l'id de la caisse créditer ou débiter")
    private String idCaisse;
    @AiColDesc("l'origine de l'encaissemnt qui peut être une vente ou un achat")
    private String idOrigine;
    protected String idDevise;
    @AiColDesc("l'argent entrée de la caisse en question")
    private double debit;
    @AiColDesc("l'argent sortie de la caisse")
    private double credit;
    private double taux;
    private Date daty, datycomptabilisation;
    private String idPrevision;
    private String compte;
    @AiColDesc("Mode de paiemment ou mode d'encaissement de l'argent")
    private String idModePaiement;
    private int etatversement;
    private Traite traite;
    private String idmvtcaissemere;
    private String reference;
    String heure;
    String idReport;
    double montantRetourner;
    String idCaissier;
    FactureCF[] factureCF;
    ComptaEcriture ecritureMvt=null;

    public ComptaEcriture getEcritureMvt() {
        return ecritureMvt;
    }

    public void setEcritureMvt(ComptaEcriture ecritureMvt) {
        this.ecritureMvt = ecritureMvt;
    }

    public String getIdReport() {
        return idReport;
    }

    public void setIdReport(String idReport) {
        this.idReport = idReport;
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

    public MvtCaisse() {
        super.setNomTable("MOUVEMENTCAISSE");
    }
    public void construirePK(Connection c) throws Exception {
        this.preparePk("MTC", "GETSEQMOUVEMENTCAISSE");
        this.setId(makePK(c));
    }
    public String getId() {
        return id;
    }

    public int getEtatversement() {
        return etatversement;
    }

    public void setEtatversement(int etatversement) {
        this.etatversement = etatversement;
    }

    public Traite getTraite() {
        return traite;
    }

    public void setTraite(Traite traite) {
        this.traite = traite;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdtraite() {
        return idtraite;
    }

    public void setIdtraite(String idtraite) {
        this.idtraite = idtraite;
    }

    public String getIdOp() {
        return idOp;
    }

    public void setIdOp(String idOp) {
        this.idOp = idOp;
    }

    public String getIdmvtcaissemere() {
        return idmvtcaissemere;
    }
    public void setIdmvtcaissemere(String idmvtcaissemere) {
        this.idmvtcaissemere = idmvtcaissemere;
    }

    @Override
    public String getNomTableIA() {
        return "MOUVEMENTCAISSECPL";
    }
    @Override
    public String getUrlListe() {
        return "/socobis/pages/module.jsp?but=caisse/mvt/mvtCaisse-liste.jsp&currentMenu=MENUDYN0020002";
    }
    @Override
    public String getUrlAnalyse() {
        return "/socobis/pages/module.jsp?but=caisse/mvt/mvtCaisse-liste.jsp&currentMenu=MENUDYN0020003";
    }
    @Override
    public String getUrlSaisie() {
        return "/socobis/pages/module.jsp?but=caisse/mvt/mvtCaisse-saisie-entree.jsp&currentMenu=MENUDYN0020001";
    }
    @Override
    public ClassIA getClassListe() {
        return this;
    }
    @Override
    public ClassIA getClassAnalyse() {
        return this;
    }

    @Override
    public ClassIA getClassSaisie() {
        return this;
    }

    public String getReference() {
        return reference;
    }
    public void setReference(String reference) {
        this.reference = reference;
    }
    public String getIdOrigine() {
        return idOrigine;
    }

    public void setIdOrigine(String idOrigine) {
        this.idOrigine = idOrigine;
    }

    public String getDesignation() {
        return designation;
    }

    public void setDesignation(String designation) {
        this.designation = designation;
    }

    public String getIdCaisse() {
        return idCaisse;
    }

    public void setIdCaisse(String idCaisse) {
        this.idCaisse = idCaisse;
    }

    public String getIdVenteDetail() {
        return idVenteDetail;
    }

    public void setIdVenteDetail(String idVenteDetail) {
        this.idVenteDetail = idVenteDetail;
    }

    public String getIdVirement() {
        return idVirement;
    }

    public void setIdVirement(String idVirement) {
        this.idVirement = idVirement;
    }

    public double getDebit() {
        return debit;
    }

    public void setDebit(double debit) throws Exception {
        if(debit < 0&& this.getMode().compareToIgnoreCase("modif")==0) throw new Exception("Le montant doit \u00EAtre positif");
        this.debit = debit;
    }

    public double getCredit() {
        return credit;
    }

    public void setCredit(double credit) throws Exception {
        if(credit < 0&& this.getMode().compareToIgnoreCase("modif")==0) throw new Exception("Le montant doit \u00EAtre positif");
        this.credit = credit;
    }

    public Date getDaty() {
        return daty;
    }

    public String getIdModePaiement() {
        return idModePaiement;
    }

    public void setIdModePaiement(String idModePaiement) {
        this.idModePaiement = idModePaiement;
    }

    public void setDaty(Date daty) throws Exception{
        if(this.getMode().compareTo("modif")==0)
        {
            if(daty==null)
                throw new Exception("Date invalide");
        }
        this.daty = daty;
    }

    public String getIdPrevision() {
        return idPrevision;
    }

    public void setIdPrevision(String idPrevision) {
        this.idPrevision = idPrevision;
    }    

    public String getCompte() {
        return compte;
    }

    public void setCompte(String compte) {
        this.compte = compte;
    }

    public Date getDatycomptabilisation() {
        return datycomptabilisation;
    }

    public void setDatycomptabilisation(Date datycomptabilisation) {
        this.datycomptabilisation = datycomptabilisation;
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    public ReportCaisse getReportCaisse(Connection c) throws Exception {
        boolean estOuvert=false;
        try
        {
            if (c == null) {
                c=new UtilDB().GetConn();
                estOuvert=true;
            }
            ReportCaisse[] reports = (ReportCaisse[]) CGenUtil.rechercher(new ReportCaisse(), null, null, c, "and idCaisse='"+this.getIdCaisse()+"'");
             if (reports.length > 0) {
                return reports[0];
            }
            return null;
        }
        catch(Exception e)
        {
            throw e;
        }
        finally
        {
            if(estOuvert) c.close();
        }
    }
    public void appliquerTauxDeChangeDefaut(Connection c) throws Exception {
        if (this.getIdDevise() != null && !this.getIdDevise().equalsIgnoreCase("AR") && this.getTaux() <= 1) {
            double dernierTaux = TauxDeChange.getLastTaux(c, Utilitaire.formatterDaty(this.getDaty()), this.getIdDevise());
            if (dernierTaux > 0) {
                this.setTaux(dernierTaux);
            }
        }
    }

    public ClassMAPTable createObjectSF(String u,Connection c)throws Exception
    {
        appliquerTauxDeChangeDefaut(c);
        return super.createObject(u, c);
    }

    public MvtCaisse validerSimple(String u, Connection c) throws Exception {
        boolean estOuvert=false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
                estOuvert = true;
            }
            MvtCaisse caisse = (MvtCaisse) new MvtCaisse().getById(getId(), null, c);
            double montant = caisse.getMontantMouvement();
            if (caisse.getIdOrigine() != null) {
                String[] origines = caisse.getIdOrigine().split(";;");
                if (origines.length > 0) {
                    for (int i = 0; i < origines.length; i++) {
                        if(caisse.getIdOrigine()!=null && caisse.getIdOrigine().compareToIgnoreCase("")!=0)
                        {
                            MvtCaissePrevision[] lienMvtPrev = caisse.attacherPrevisionAutomatique(u, c);
                            for(MvtCaissePrevision mvt:lienMvtPrev)
                            {
                                mvt.createObject(u, c);
                            }
                        }
                        if (caisse.getIdOrigine().startsWith("VNT")) {
                            VenteLib vt = (VenteLib) new VenteLib().getById(origines[i], "VENTE_CPL", c);
                            LiaisonPaiement paiement = new LiaisonPaiement();
                            if (montant > vt.getMontantreste()) {
                                paiement.setId1(caisse.getId());
                                paiement.setId2(origines[i]);
                                paiement.setMontant(vt.getMontantreste());
                                paiement.createObject(u, c);
                                paiement.validerObject(u, c);
                                montant -= vt.getMontantreste();
                            } else if (montant <= vt.getMontantreste()) {
                                paiement.setId1(caisse.getId());
                                paiement.setId2(origines[i]);
                                paiement.setMontant(montant);
                                paiement.createObject(u, c);
                                paiement.validerObject(u, c);
                                break;
                            }
                        } else if (caisse.getIdOrigine().startsWith("FCF")) {
                            FactureFournisseurCpl fc = (FactureFournisseurCpl) new FactureFournisseurCpl().getById(origines[i], "FACTUREFOURNISSEURCPL", c);
                            montant -= fc.getMontantreste();
                            LiaisonPaiement paiement = new LiaisonPaiement();
                            paiement.setId1(caisse.getId());
                            paiement.setId2(origines[i]);
                            if (montant <= 0) {
                                paiement.setMontant(fc.getMontantreste() + montant);
                                paiement.createObject(u, c);
                                paiement.validerObject(u, c);
                                break;
                            } else {
                                paiement.setMontant(fc.getMontantreste());
                                paiement.createObject(u, c);
                                paiement.validerObject(u, c);
                            }
                        } else if (caisse.getIdOrigine().startsWith("TR") && caisse.getTraite() != null) {
                            montant = caisse.traite.getMontant();
                            LiaisonPaiement paiement = new LiaisonPaiement();
                            paiement.setId1(caisse.getId());
                            paiement.setId2(origines[i]);
                            paiement.setMontant(montant);
                            paiement.createObject(u, c);
                            paiement.validerObject(u, c);
                            break;
                        }
                    }
                }
            }
            caisse.setEtat(ConstanteEtat.getEtatProforma());
            caisse.updateToTableWithHisto(u, c);
            if(estOuvert) c.commit();
            return caisse;
        } catch (Exception e) {
            if(estOuvert) c.rollback();
            throw e;
        } finally {
            if(estOuvert) c.close();
        }
    }


    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception{
        if (getIdCaisse() == null || getIdCaisse().trim().isEmpty()) {
            setIdCaisse(ConstanteAsync.CAISSE_DEFAUT);
        }

        ReportCaisse report = this.getReportCaisse(c);
        if( report == null ){
            report=new ReportCaisse();
            Caisse caisse = new Caisse();
            caisse.setId(this.getIdCaisse());
            LocalDateTime localDateTime = this.getDaty().toLocalDate().atStartOfDay().minusDays(1);
            Date datehier = Date.valueOf(localDateTime.toLocalDate());
            report = new ReportCaisse();
            report.setDaty(datehier);
            report.setIdCaisse(this.getIdCaisse());
            report.createObject(u,c);
            report.validerObject(u,c);
        }

        if (getDebit() <= 0 && getCredit() <= 0) {
            throw new Exception("Le Montant ne doit pas inf\u00E9rieur ou \u00E9gale 0 !");
        }

        if (getDebit() > 0) {
            controleMontantRestant(c);
        }
        appliquerTauxDeChangeDefaut(c);

        Caisse caisse = (Caisse) new Caisse().getById(this.getIdCaisse(), "CAISSE", c);
        if(caisse!=null){
            if(caisse.getIdDevise()!=null && caisse.getIdDevise().equals("AR") && this.getTaux()!=0){
                this.setCredit(this.getCredit()*this.getTaux());
                this.setDebit(this.getDebit()*this.getTaux());
            }
        }

        MvtCaisse mvt = (MvtCaisse)super.createObject(u, c);
        //(u, c);
        return mvt;
    }

    public void controleMontantRestant(Connection c) throws Exception {
        if(this.getIdOrigine() != null) {
            if (this.getIdOrigine().startsWith("FCF")) {
                FactureFournisseurCpl factureFournisseurCpl = (FactureFournisseurCpl) new FactureFournisseurCpl().getById(this.getIdOrigine(), "FACTUREFOURNISSEURCPL", c);
                if (factureFournisseurCpl == null) {
                    throw  new Exception("Facture fournisseur introuvable");
                }
                if (getDebit() > factureFournisseurCpl.getMontantreste()) {
                    throw new Exception("Le montant ne doit pas superieur au montant restant du facture !");
                }
            }
        }
    }
    
    public Prevision getPrevision(Connection c) throws Exception {
        Prevision prevision = new Prevision();
        Prevision[] previsions = (Prevision[]) CGenUtil.rechercher(prevision, null, null, c, "and ID = '"+this.getIdPrevision()+"'");
        return previsions[0];
    }
    public PrevisionComplet getPrevision(String nomtable,Connection c) throws Exception {
        PrevisionComplet prevision = new PrevisionComplet();
        if(nomtable!=null&&nomtable.compareToIgnoreCase("")!=0) prevision.setNomTable(nomtable);
        prevision.setId(this.getIdPrevision());
        PrevisionComplet[] previsions = (PrevisionComplet[]) CGenUtil.rechercher(prevision, null, null, c, "");
        return previsions[0];
    }
    public boolean estMemeSens(Prevision autre)
    {
        if((this.isDepense()&&autre.isDepense())||(this.isRecette()&&autre.isRecette()))return true;
        return false;
    }

    public MvtCaissePrevision[] attacherPrevision(PrevisionComplet[] listePrevision ,String u,Connection c)throws Exception {
        
        ArrayList<MvtCaissePrevision> attachements = new ArrayList<MvtCaissePrevision>();
        double reste = this.getMontantMouvement();
        double valeur=reste;
        int i=0;
        for(PrevisionComplet prevision : listePrevision){
            if(prevision.getEcart()>0&&i<listePrevision.length-1){
                valeur=Math.min(reste,prevision.getEcart());
            }
            MvtCaissePrevision attachement = new MvtCaissePrevision();
            attachement.setId1(this.getId());
            attachement.setId2(prevision.getId());
            attachement.setMontant(valeur,prevision);
            attachement.setEtat(this.getEtat());
            attachement.setDevise("AR");
            attachement.setTaux(1);
            attachements.add(attachement);
            reste = Math.max(0, reste-valeur);
            valeur=reste;
            if(reste<= 0) break;
            
            i++;
        }
        return attachements.toArray(new MvtCaissePrevision[attachements.size()]);
    }

    public boolean isDepense()
    {
        if(this.getDebit()>0&&this.getCredit()<=0) return true;
        return false;
    }

    public boolean isRecette()
    {
        if(this.getCredit()==0)return false;
        return !isDepense();
    }



    public double getMontantMouvement() throws Exception{
        if(this.isDepense()) return this.getDebit()*this.getTaux();
        return this.getCredit()*this.getTaux();
    }


    public MvtCaisse attacherPrevision(String idPrevision ,String u,Connection c)throws Exception {
        MvtCaisse[] mvtCaisseBase = (MvtCaisse[]) CGenUtil.rechercher(new MvtCaisse(), null, null, c, "and ID = '"+this.getId()+"'");
        if (mvtCaisseBase[0].getIdPrevision()!= null) {
            throw new Exception("Mouvement de Caisse a déjà un Prevision");
        }
        mvtCaisseBase[0].setIdPrevision(idPrevision);
        mvtCaisseBase[0].attacherPrevision(u,c);
        return mvtCaisseBase[0];
    }
    
    public MvtCaisse attacherPrevision(String u ,Connection c)throws Exception {
        Prevision prevision = this.getPrevision(c);
        Prevision[] previsionBase = (Prevision[]) CGenUtil.rechercher(prevision, null, null, c, " and ( IDFACTURE = '"+prevision.getIdFacture()+"' or IDORIGINE = '"+this.getIdOrigine()+"' ) ");
        if (previsionBase.length > 0) {
            throw new Exception("la Prevision n'existe pas");
        }
        this.updateToTableWithHisto(u, c);
        return this;
    }
    
    public static MvtCaisse[] getAll(String[] ids, Connection co)throws Exception{
        MvtCaisse mvtCaisse = new MvtCaisse();
        MvtCaisse[] bls = (MvtCaisse[]) CGenUtil.rechercher(mvtCaisse, null, null,co, " and id in ("+Utilitaire.tabToString(ids, "'", ",")+" ) ");
        return bls;
    }
    
    public PrevisionComplet[] getPrevisionLie(String nomT,Connection c) throws Exception
    {
        PrevisionComplet prevision = new PrevisionComplet();
        if(nomT!=null&&nomT.compareToIgnoreCase("")!=0)prevision.setNomTable(nomT);
        //Prevision[] previsions = (Prevision[]) CGenUtil.rechercher(prevision, null, null, c, " and IDFACTURE  = '"+this.getIdOrigine()+"'");
        PrevisionComplet[] previsionComplets = (PrevisionComplet[]) CGenUtil.rechercher(prevision, null, null, c, " and IDFACTUREMERE  = '"+this.getIdOrigine()+"' order by daty ASC");
        return previsionComplets;
    }
    
    
    public MvtCaissePrevision[] attacherPrevisionAutomatique(String u,Connection c) throws Exception{
        PrevisionComplet prevision = new PrevisionComplet();
        //Prevision[] previsions = (Prevision[]) CGenUtil.rechercher(prevision, null, null, c, " and IDFACTURE  = '"+this.getIdOrigine()+"'");
        PrevisionComplet[] previsionComplets =  this.getPrevisionLie("PREVISION_COMPLET_CPLPOSITIF", c);
        MvtCaissePrevision[] lien=this.attacherPrevision(previsionComplets, u, c);
        return lien;
    }
    public MvtCaissePrevision[] attacherPrevisionAutomatique(String[]id, String u,Connection c) throws Exception{
        PrevisionComplet prevision = new PrevisionComplet();
        if(this.getEtat()<=ConstanteEtat.getEtatValider())throw new Exception("Mvt Caisse non validé");
        //Prevision[] previsions = (Prevision[]) CGenUtil.rechercher(prevision, null, null, c, " and IDFACTURE  = '"+this.getIdOrigine()+"'");
        String aWhere=Utilitaire.getAWhereIn(id,"id");
        PrevisionComplet[] previsionComplets = (PrevisionComplet[]) CGenUtil.rechercher(prevision, null, null, c, aWhere+" order by daty ASC");
        MvtCaissePrevision[] lien=this.attacherPrevision(previsionComplets, u, c);
        return lien;
    } 
    
    @Override
    public ClassMAPTable validerObject(String u, Connection c) throws Exception{

        if(this.getIdCaisse().compareToIgnoreCase(ConstanteAsync.CAISSE_DEFAUT)!=0 && this.getDatycomptabilisation()!=null && this.getIdModePaiement()!=null){
            this.setReference(generereReference(c));
            this.updateObject(u,c);
        }

        //MvtCaisse[] mvtCaisse67 = (MvtCaisse[])CGenUtil.rechercher(new MvtCaisse(),null,null, c," and id ='"+this.getId()+"'");
        //if(mvtCaisse67[0].getDatycomptabilisation() != null ) {
            if (this.getIdOrigine() != null && this.getIdOrigine().startsWith("VNT") && this.getIdOrigine().split(";;").length <= 1) {
                VenteLib vente = getVenteLib(c);
                //if (vente.getMontantreste() < this.getCredit())
                //    throw new Exception("Le montant saisi ne doit pas etre superieur au montant reste de la facture client!");
            } else if (this.getIdOrigine() != null && this.getIdOrigine().startsWith("AVRFC")) {
                AvoirFCLib avoirFC = this.getAvoirFC(c);
                if (avoirFC.getResteapayer() < this.getDebit())
                    throw new Exception("Le montant saisi ne doit pas etre superieur au montant reste de la facture Avoir!");
            } else if (this.getIdOrigine() != null && this.getIdOrigine().startsWith("VNT") && this.getIdOrigine().split(";;").length > 1) {
                String[] ids = this.getIdOrigine().split(";;");
                VenteLib vente = Vente.genererVenteClient(ids, c);
                assert vente != null;
                if (vente.getMontantreste() < this.getCredit())
                    throw new Exception("Le montant saisi ne doit pas etre superieur au montant reste de la facture client!");
            }
        //}
        double montant = this.getMontantMouvement();
        LiaisonPaiement [] liaisonPaiements = (LiaisonPaiement[]) CGenUtil.rechercher(new LiaisonPaiement(), null, null, c, " and id1 = '"+this.getId()+"'");
        if(this.getIdOrigine()!=null && this.getIdOrigine().compareToIgnoreCase("")!=0 && liaisonPaiements.length<=0){
            String [] origines = this.getIdOrigine().split(";;");
            if(origines.length>0){
                for (int i = 0; i < origines.length; i++) {
                    if(this.getIdOrigine().startsWith("VNT")){
                        VenteLib vente = (VenteLib) new VenteLib().getById(origines[i],"VENTE_CPL",c);
                        montant -= vente.getMontantreste();
                        LiaisonPaiement paiement = new LiaisonPaiement();
                        paiement.setId1(this.getId());
                        paiement.setId2(origines[i]);
                        if(montant<=0){
                            paiement.setMontant(vente.getMontantreste()+montant);
                            paiement.createObject(u,c);
                            paiement.validerObject(u,c);
                            break;
                        }else{
                            paiement.setMontant(vente.getMontantreste());
                            paiement.createObject(u,c);
                            paiement.validerObject(u,c);
                        }
                    }else if(this.getIdOrigine().startsWith("FCF")){
                        FactureFournisseurCpl fc = (FactureFournisseurCpl) new FactureFournisseurCpl().getById(origines[i],"FACTUREFOURNISSEURCPL",c);
                        montant -= fc.getMontantreste();
                        LiaisonPaiement paiement = new LiaisonPaiement();
                        paiement.setId1(this.getId());
                        paiement.setId2(origines[i]);
                        if(montant<=0){
                            paiement.setMontant(fc.getMontantreste()+montant);
                            paiement.createObject(u,c);
                            paiement.validerObject(u,c);
                            break;
                        }else{
                            paiement.setMontant(fc.getMontantreste());
                            paiement.createObject(u,c);
                            paiement.validerObject(u,c);
                        }
                    } else if(this.getIdOrigine().startsWith("TR") && this.getTraite()!=null){
                        montant = this.traite.getMontant();
                        LiaisonPaiement paiement = new LiaisonPaiement();
                        paiement.setId1(this.getId());
                        paiement.setId2(origines[i]);
                        paiement.setMontant(montant);
                        paiement.createObject(u,c);
                        paiement.validerObject(u,c);
                        break;
                    }else if(this.getIdOrigine().startsWith("AVRFC")){
                        LiaisonPaiement p = new LiaisonPaiement();
                        p.setId1(this.getIdOrigine());
                        p.setMontant(this.getDebit());
                        p.createObject(u,c);
                        p.validerObject(u,c);
                        break;
                    }
                }
            }
        }
        Caisse[]caisse = (Caisse[])CGenUtil.rechercher(new Caisse(), null, null, c, " and id = '"+this.getIdCaisse()+"'");
        if(this.getDatycomptabilisation() == null) this.setDatycomptabilisation(Utilitaire.dateDuJourSql());
        if(caisse.length>0) this.setDesignation(this.getDesignation()+" "+caisse[0].getDesce()+" du "+this.getDatycomptabilisation());
        this.setHeure(Utilitaire.heureCouranteHMS());
        super.validerObject(u, c);
        if(this.getIdOrigine()!=null&&this.getIdOrigine().compareToIgnoreCase("")!=0&&this.getIdOrigine().startsWith("VNT"))
        {
            String [] ids = this.getIdOrigine().split(";;");
            VenteLib vente = Vente.genererVenteClient(ids,c);
            LiaisonPaiement li = new LiaisonPaiement();
            LiaisonPaiement[] bls = (LiaisonPaiement[]) CGenUtil.rechercher(li, null, null,c, " and id2 in ("+Utilitaire.tabToString(ids, "'", ",")+" ) ");
            for (int i = 0; i < bls.length; i++) {
                bls[i].validerObject(u, c);
            }
        }
        if(this.getIdOrigine() != null && this.getIdOrigine().compareToIgnoreCase("") != 0)
        {
            MvtCaissePrevision[] lienMvtPrev = this.attacherPrevisionAutomatique(u, c);
            for(MvtCaissePrevision mvt:lienMvtPrev)
            {
                mvt.createObject(u, c);
            }
        }
        if(this.getDebit()>0){
            genererEcritureDecaissement(u, c);
        }else if(this.getCredit()>0){
            genererEcritureEncaissement(u, c);
        }
        if (this.getIdOrigine() != null && !this.getIdOrigine().isEmpty()) {
            if (this.getIdOrigine().startsWith("FCF") || this.getIdOrigine().startsWith("VNT") || this.getIdOrigine().startsWith("AVR")) {
                this.genererLettrage(this.getIdOrigine(),u,c);
            }
        }
        return this;
    }
    public ComptaLettrage genererLettrage(String idOrigine,String u,Connection c) throws Exception
    {
        if(idOrigine==null||idOrigine.equalsIgnoreCase(""))return null;
        ComptaEcriture gauche=FactureCF.getEcritureAvecFille(idOrigine,null,null,c);
        if(gauche==null)return null;
        List<ComptaSousEcriture> resultats = Arrays.stream((ComptaSousEcriture[])gauche.getFille())
                .filter(se -> se.getCompte_aux () != null&&se.getCompte_aux().equalsIgnoreCase("")==false)
                .collect(Collectors.toList());
        if(resultats==null || resultats.size()==0)return null;
        ComptaSousEcriture seGauche= resultats.get(0);
        List<ComptaSousEcriture> resultatsDroite = Arrays.stream((ComptaSousEcriture[])this.getEcritureMvt().getFille())
                .filter(se -> se.getCompte_aux () != null&&se.getCompte_aux().equalsIgnoreCase("")==false)
                .collect(Collectors.toList());
        if(resultatsDroite==null || resultatsDroite.size()==0)return null;
        ComptaSousEcriture seDroite=resultatsDroite.get(0);
        return new ComptaLettrage().createLettrageCSEMF(new String[]{seGauche.getId(),seDroite.getId()},null,u,c);

    }
    public void genererEcritureDecaissement(String u, Connection c) throws Exception{
        String journal = getJournal(c);
        ComptaEcriture mere = new ComptaEcriture();
        Date dateDuJour = utilitaire.Utilitaire.dateDuJourSql();
        int exercice = utilitaire.Utilitaire.getAnnee(daty);
        mere.setDaty(this.getDatycomptabilisation());
        mere.setDesignation(this.getDesignation());
        mere.setExercice(""+exercice);
        mere.setDateComptable(this.getDatycomptabilisation());
        mere.setJournal(journal);
//        if(this.getIdOrigine()!=null&&this.getIdOrigine().startsWith("AVRFC")){
//            mere.setJournal(journal);
//        }
        mere.setOrigine(this.getId());
        mere.setIdobjet(this.getId());

        ComptaSousEcriture[] filles = this.genererSousEcritureDecaissement(c);
        for(int i=0; i<filles.length; i++){
            filles[i].setIdMere(mere.getId());
            filles[i].setExercice(exercice);
            filles[i].setDaty(this.getDaty());
            filles[i].setJournal(journal);
            filles[i].setLibellePiece(Utilitaire.champNull(this.getReference()));
            
            if(filles[i].getDebit()>0 || filles[i].getCredit()>0) mere.ajouterFille(filles[i]);
        }
        mere.createObject(u, c);
        this.setEcritureMvt(mere);
    }
    
    public ComptaSousEcriture[] genererSousEcritureDecaissement(Connection c) throws Exception{
        ComptaSousEcriture[] compta={};
        boolean canClose=false;
        try{
            if(c==null){
                c=new UtilDB().GetConn();
                canClose=true;
            }
            String compte2 = "";
            String compte_aux = "";
            String designation2 = "";
            if(this.getIdOrigine()!=null&&this.getIdOrigine().startsWith("FCF")){
                FactureFournisseur ff = getFactureFournisseur(c);
                compte2 = ff.getCompte();
                designation2 = "FF "+ff.getFournisseurlib();
                this.setCredit(this.getCredit()*this.getTaux());
                compte_aux = ff.getCompteauxiliaire();
            } else if(this.getIdOrigine()!=null&&this.getIdOrigine().startsWith("PGI")){
                PerteGainImprevueLib perteGainImprevue = getPerteGainImprevue(c);
                compte2 = perteGainImprevue.getTierscompte();
                designation2 = "Perte "+perteGainImprevue.getTiers();
                compte_aux = perteGainImprevue.getCompteauxiliaire();
            } else if(this.getIdOrigine()!=null&&this.getIdOrigine().startsWith("AVRFC")){
                AvoirFCLib avoir = this.getAvoirFC(c);
                compte2 = avoir.getCompte();
                designation2 = "Avoir "+avoir.getClientlib();
                compte_aux = avoir.getCompteauxiliaire();
            }
            else if(this.getIdReport()!=null&&this.getIdReport().compareToIgnoreCase("")!=0){
                compte2= ParamComptaStatique.getById(ConstanteSocobis.idComptaPerteReport).getDesce();
                designation2="Perte liee au report "+this.getIdReport();
            }
            else{
                Tiers tr=this.getTiers(null, c);
                if(tr==null)throw new Exception("Tiers vide");
                compte2 = tr.getCompte();
                compte_aux = tr.getCompteauxiliaire();
            }
            
            //this.setCompte(facturefournisseurs[0].getCompte());

            compta = new ComptaSousEcriture[2];
            
            compta[0]=new ComptaSousEcriture();
            compta[0].setLibellePiece(this.getDesignation());
            compta[0].setRemarque(this.getDesignation());
            compta[0].setCompte(getCaisse(c).getCompte());
            compta[0].setCredit(this.getDebit()*this.getTaux());

            compta[1]=new ComptaSousEcriture();
            compta[1].setLibellePiece("Decaissement "+designation2);
            compta[1].setRemarque("Decaissement "+designation2);
            compta[1].setCompte(compte2);
//            compta[i].setDebit((montantHT-retenue) * ((this.getTva()/100)));
            compta[1].setDebit(this.getDebit()*this.getTaux());
            compta[1].setCompte_aux(this.getIdTiers());
            
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
        Caisse[] caisses = (Caisse[]) CGenUtil.rechercher(caisse, null, null, c, " and id = '"+this.getIdCaisse()+"'");
        if (caisses.length > 0) {
            return caisses[0];
        }
        return null;
    }

    public Caisse getCaisse() throws Exception {
        Connection c = null;
        try{
            if(c==null){
                c=new UtilDB().GetConn();
            }
            Caisse caisse = new Caisse();
            Caisse[] caisses = (Caisse[]) CGenUtil.rechercher(caisse, null, null, c, " and id = '"+this.getIdCaisse()+"'");
            if (caisses.length > 0) {
                return caisses[0];
            }
            return null;
        } catch(Exception e){
            throw e;
        } finally {
            c.close();
        }
    }
    
    public Vente getVente(Connection c) throws Exception {
        if (c == null) {
            throw new Exception("Connection non etablie");
        }
        Vente vente = new Vente("VENTE_MERE_MONTANT");
        vente.setId(this.getIdOrigine());
        Vente[] ventes = (Vente[]) CGenUtil.rechercher(vente, null, null, c, "");
        if (ventes.length > 0) {
            return ventes[0];
        }
        return null;
    }
    
    public VenteLib getVenteLib(Connection c) throws Exception {
        if (c == null) {
            throw new Exception("Connection non etablie");
        }
        VenteLib vente = new VenteLib();
        vente.setNomTable("vente_cpl");
        vente.setId(this.getIdOrigine());
        VenteLib[] ventes = (VenteLib[]) CGenUtil.rechercher(vente, null, null, c, "");
        if (ventes.length > 0) {
            return ventes[0];
        }
        return null;
    }
    
    public FactureFournisseur getFactureFournisseur(Connection c) throws Exception {
        if (c == null) {
            throw new Exception("Connection non etablie");
        }
        FactureFournisseur ff = new FactureFournisseur("FACTUREFOURNISSEUR_MERECMPT");
        ff.setId(this.getIdOrigine());
        FactureFournisseur[] ffs = (FactureFournisseur[]) CGenUtil.rechercher(ff, null, null, c, "");
        if (ffs.length > 0) {
            return ffs[0];
        }
        return null;
    }
    
    
    public PerteGainImprevueLib getPerteGainImprevue(Connection c) throws Exception {
        if (c == null) {
            throw new Exception("Connection non etablie");
        }
        PerteGainImprevueLib pertegain = new PerteGainImprevueLib();
        pertegain.setId(this.getIdOrigine());
        PerteGainImprevueLib[] pertegains = (PerteGainImprevueLib[]) CGenUtil.rechercher(pertegain, null, null, c, "");
        if (pertegains.length > 0) {
            return pertegains[0];
        }
        return null;
    }
    
    public AvoirFCLib getAvoirFC(Connection c) throws Exception {
        if (c == null) {
            throw new Exception("Connection non etablie");
        }
        AvoirFCLib avoir = new AvoirFCLib();
        avoir.setNomTable("AVOIRFCLIB_CPL");
        avoir.setId(this.getIdOrigine());
        AvoirFCLib[] avoirs = (AvoirFCLib[]) CGenUtil.rechercher(avoir, null, null, c, "");
        if (avoirs.length > 0) {
            return avoirs[0];
        }
        return null;
    }
    
    public void genererEcritureEncaissement(String u, Connection c) throws Exception{
        ComptaEcriture mere = new ComptaEcriture();
        String journal = getJournal(c);
        Date dateDuJour = this.getDaty();
        int exercice = utilitaire.Utilitaire.getAnnee(daty);
        mere.setDaty(this.getDatycomptabilisation());
        mere.setDesignation(this.getDesignation());
        mere.setExercice(""+exercice);
        mere.setDateComptable(this.getDatycomptabilisation());
        mere.setJournal(journal);
        mere.setOrigine(this.getId());
        mere.setIdobjet(this.getId());
        ComptaSousEcriture[] filles = this.genererSousEcritureEncaissement(u,c);
        for(int i=0; i<filles.length; i++){
            filles[i].setIdMere(mere.getId());
            filles[i].setExercice(exercice);
            filles[i].setDaty(this.getDaty());
            filles[i].setJournal(journal);
            filles[i].setLibellePiece(Utilitaire.champNull(this.getReference()));
            if(filles[i].getDebit()>0 || filles[i].getCredit()>0) mere.ajouterFille(filles[i]);
        }
        mere.createObject(u, c);
        this.setEcritureMvt(mere);
    }
    
    public ComptaSousEcriture[] genererSousEcritureEncaissement(String refUser,Connection c) throws Exception{
        ComptaSousEcriture[] compta={};
        boolean canClose=false;
        try{
            if(c==null){
                c=new UtilDB().GetConn();
                canClose=true;
            }
//            String nt=new Client().getNomTable();
//            if(this.getDebit()>0)nt=new Fournisseur().getNomTable();
//            System.out.println("NIM TABLEEEE "+nt);
            Tiers tr=this.getTiers("TIERS", c);
            if(tr==null)throw new Exception("Tiers vide");
            String compte2 = tr.getCompte();
            String designation2 = "";
            if(this.getIdOrigine()!=null &&this.getIdOrigine().startsWith("VNT")){
                String [] ids = this.getIdOrigine().split(";;");
                VenteLib vente = Vente.genererVenteClient(ids,c);
                
                designation2 = "Vente "+vente.getIdClientLib();
                this.setCredit(this.getCredit()*vente.getTauxdechange());
            } else if(this.getIdOrigine()!=null &&this.getIdOrigine().startsWith("PGI")){
                PerteGainImprevueLib perteGainImprevue = getPerteGainImprevue(c);
                
                designation2 = "Gain "+perteGainImprevue.getTiers();
            }
            else if(this.getIdReport()!=null&&this.getIdReport().compareToIgnoreCase("")!=0){
                compte2= ParamComptaStatique.getById(ConstanteSocobis.idComptaGainReport).getDesce();
                designation2="Gain liee au report "+this.getIdReport();
            }
            
            

            compta = new ComptaSousEcriture[2];
            Caisse caisse = getCaisse(c);
            compta[0]=new ComptaSousEcriture();
            compta[0].setLibellePiece(this.getDesignation());
            compta[0].setRemarque(this.getDesignation());
            compta[0].setCompte(caisse.getCompte());
            compta[0].setDebit(this.getCredit()*this.getTaux());

            compta[1]=new ComptaSousEcriture();
            compta[1].setLibellePiece("Encaissement "+designation2);
            compta[1].setRemarque("Encaissement "+designation2);
            compta[1].setCompte(compte2);
            compta[1].setCredit(this.getCredit()*this.getTaux());
            compta[1].setCompte_aux(this.getIdTiers());
            
        } catch(Exception e){
            throw e;
        } finally {
            if(canClose){
                c.close();
            }
        }
        return compta;
    }

    public String getIdDevise() {
        return idDevise;
    }

    public void setIdDevise(String idDevise) throws Exception {
        if(this.getMode().compareTo("modif")==0)
        {
            if(idDevise==null||idDevise.isEmpty())
                throw  new Exception ("Devise obligatoire");
        }
        this.idDevise = idDevise;
    }

    public double getTaux() {
        if(taux==0) return 1;
        return taux;
    }

    public void setTaux(double taux) throws Exception {
        if(this.getMode().compareTo("modif")==0)
        {
            if(taux==0)
                this.taux=1;
        }
        this.taux = taux;
    }

    public String getIdTiers() {
        return idTiers;
    }
    public Tiers getTiers(String nT,Connection c) throws Exception
    {
        Tiers crt=new Tiers();
        crt.setNomTable(nT);
        crt.setId(this.getIdTiers());
        Tiers[] retour=(Tiers[])CGenUtil.rechercher(crt, null, null, c, "");
        if(retour.length==0) return null;
        return retour[0];
    }

    public void setIdTiers(String idTiers) throws Exception {
        if(this.getMode().compareTo("modif")==0)
        {
            if(idTiers==null||idTiers.compareToIgnoreCase("")==0)
                throw new Exception("Tiers obligatoire");
        }
        this.idTiers = idTiers;
    }

    public void attacherPrevision(String[] ids, String u, Connection c) throws Exception {
        boolean canClose=false;
        try{
            if(c==null){
                c=new UtilDB().GetConn();
                canClose=true;
            }
        MvtCaisse mvtcaisse = (MvtCaisse) this.getById(this.getId(), this.getNomTable(), c);
        PrevisionComplet[] previsionComplets = PrevisionComplet.getAll(ids, c);
        MvtCaissePrevision[] mvt = mvtcaisse.attacherPrevision(previsionComplets, u, c);
        for (int i = 0; i < mvt.length; i++) {
            mvt[i].createObject(u, c);
        }
        } catch(Exception e){
            throw e;
        } finally {
            if(canClose){
                c.close();
            }
        }
    }

    public String getJournalByCompte(Connection c, String compte) throws Exception{
        Journal[] journal =  (Journal[]) CGenUtil.rechercher(new Journal(),null,null,c," AND COMPTE='"+compte+"'");
        if(journal.length>0){
            return journal[0].getId();
        }
        return null;
    }

    public String getJournal(Connection c) throws Exception{
        Caisse caisse = (Caisse) new Caisse().getById(this.getIdCaisse(),"CAISSE",c);
        if(caisse!=null){
            String typeCaisse = caisse.getIdTypeCaisse();
            if(typeCaisse.compareToIgnoreCase(ConstanteComptable.typeBanque)==0){
                String journal = getJournalByCompte(c,caisse.getCompte());
                if(journal!=null){
                    return journal;
                }
                return ConstanteComptable.journalBanque;
            }else {
                return ConstanteComptable.journalCaisse;
            }
        }
        throw new Exception("Pas de caisse");
    }


    public double getMontantRetourner() {
        return montantRetourner;
    }

    public void setMontantRetourner(double montantRetourner) {
        this.montantRetourner = montantRetourner;
    }

    public String getIdCaissier() {
        return idCaissier;
    }

    public void setIdCaissier(String idCaissier) {
        this.idCaissier = idCaissier;
    }

    public String generereReference(Connection c) throws Exception{
        Caisse caisse = (Caisse) new Caisse().getById(this.getIdCaisse(),"CAISSE",c);
        this.getIdModePaiement();
        String ref = "";
        if(this.getCredit()>0){
            ref = "V/";
        }else {
            ref = "N/";
        }
        if(this.getIdModePaiement().compareToIgnoreCase(ConstanteAsync.PAIEMENT_CHEQUE)==0){
            ref = ref+"chq";
        }
        else if(this.getIdModePaiement().compareToIgnoreCase(ConstanteAsync.PAIEMENT_CARTE)==0){
            ref = ref+"vrmt";
        }
        else if(this.getIdModePaiement().compareToIgnoreCase(ConstanteAsync.PAIEMENT_ESPECE)==0){
            ref = ref+"esp";
        }

        Tiers t = (Tiers) new Tiers().getById(this.getIdTiers(),"TIERS",c);

        ref = ref+" "+caisse.getVal()+ " "+ this.getReference() + " - "+this.getIdOrigine()+" - "+t.getNom();
        return ref;
    }

    public FactureCF[] getFactureCF() {
        return factureCF;
    }

    public void setFactureCF(FactureCF[] factureCF) {
        this.factureCF = factureCF;
    }
    public FactureCF[] getFactureCF(Connection c) throws Exception {
        boolean canClose = false;
        if(this.getFactureCF()!=null){
            return this.getFactureCF(c);
        }
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                canClose = true;
            }
            
            if (this.getIdOrigine().startsWith("FCF")) {
                FactureFournisseur ff = new FactureFournisseur();
                ff.setId(this.getIdOrigine());
                FactureFournisseur[] tab = (FactureFournisseur[]) CGenUtil.rechercher(ff, null, null, c, "");
                if (tab.length > 0) {
                    this.setFactureCF(tab);
                }
            } else if (this.getIdOrigine().startsWith("VNT")) {
                Vente v = new Vente();
                v.setId(this.getIdOrigine());
                Vente[] tab = (Vente[]) CGenUtil.rechercher(v, null, null, c, "");
                if (tab.length > 0) {
                    this.setFactureCF(tab);
                }
            }
            return this.getFactureCF();

           
        } finally {
            if (canClose) c.close();
        }
    }

   
    
    
}
