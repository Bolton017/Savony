    /*
     * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
     * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
     */
    package vente;

    import affichage.PageInsertMultiple;
    import annexe.EquivalenceCarton;
    import annexe.Produit;
    import avoir.AvoirFC;
    import avoir.AvoirFCFille;
    import avoir.AvoirFCLib;
    import bean.*;

    import java.awt.*;
    import java.awt.image.BufferedImage;
    import java.io.ByteArrayInputStream;
    import java.io.ByteArrayOutputStream;
    import java.io.File;
    import java.sql.Connection;
    import java.sql.Date;
    import caisse.Caisse;
    import caisse.MouvementCaisseFille;
    import caisse.MvtCaisse;
    import client.Client;
    import client.ForfaitZoneClient;
    //import com.sun.org.apache.xml.internal.resolver.readers.ExtendedXMLCatalogReader;
    import client.ZoneClient;
    import constante.ConstanteEtat;
    import encaissement.Encaissement;
    import encaissement.EncaissementDetails;

    import historique.HistoInsert;
    import java.sql.SQLException;
    import java.sql.Statement;
    import java.time.LocalTime;
    import java.time.format.DateTimeFormatter;
    import java.util.*;
    import java.util.List;

    import magasin.Magasin;
import mg.cnaps.compta.ComptaEcriture;
import mg.cnaps.compta.ComptaSousEcriture;
    import org.krysalis.barcode4j.output.bitmap.BitmapCanvasProvider;
    import paiement.LiaisonPaiement;
import prevision.Prevision;
import produits.Ingredients;
    import produits.TarifIngredients;
    import proforma.ProformaDetails;
    import remise.RemiseFille;
    import ristourne.Ristourne;
import ristourne.RistourneDetails;
import rapprochement.RapprochementDBMere;
    import stock.*;
    import user.UserEJB;
    import utilitaire.ConstanteComptable;
    import utilitaire.UtilDB;
import utilitaire.Utilitaire;
import utils.*;

    import javax.imageio.ImageIO;

    /**
     *
     * @author Angela
     */
public class Vente extends FactureCF {
    protected String designation;
    protected String idMagasin;
    protected String remarque;
    protected String idOrigine;
    protected String idClient, clientlib;
    protected String compte;
    protected double  tauxdechange;
    protected VenteDetails[] venteDetails;
    int estPrevu;
    double montantRevient;
    double margeBrute;
    double echeancefacture;
    String modepaiement;
    double fraislivraison;
    int modelivraison;
    String referencefact;
    String numerofacture;
    private String lieuLivraison;
    private Date dateLivraison;
    private String idzoneclient,commercial;
    private int typefraistransport;
        private String nomClientDivers;
        int adeclarer;
        double remise,remiseMontant,montantDonne, montantReste;
        String heureSaisie;
        String idEcheancePaiement;
        String idCommercial;
        private Date dateEcheance;
        private String factureEchange;
        private String idResponsable, idModePaiement;
        private double montantLivraison;
        Ingredients[] listeIng = null;

        Client client;
        double montantRetourner;
        boolean isAppoint = false;
        String idMagasinVente;
        String userFacture;

        public double getMontantRetourner() {
            return montantRetourner;
        }

        public void setMontantRetourner(double montantRetourner) {
            this.montantRetourner = montantRetourner;
        }

        public Ingredients[] getListeIng() {
            return listeIng;
        }

        public void setListeIng(Ingredients[] listeIng) {
            this.listeIng = listeIng;
        }

        public String getFactureEchange() {
            return factureEchange;
        }

        public void setFactureEchange(String factureEchange) {
            this.factureEchange = factureEchange;
        }

        public boolean getIsAppoint() {
            return isAppoint;
        }

        public void setIsAppoint(boolean appoint) {
            isAppoint = appoint;
        }

        public String getIdMagasinVente() {
            return idMagasinVente;
        }

        public void setIdMagasinVente(String idMagasinVente) {
            this.idMagasinVente = idMagasinVente;
        }

        public String getUserFacture() {
            return userFacture;
        }

        public void setUserFacture(String userFacture) {
            this.userFacture = userFacture;
        }

        public Client getClient() {
            return client;
        }

        public void setClient(Client client) {
            this.client = client;
        }

        public String getNomClientDivers() {
            return nomClientDivers;
        }

        public void setNomClientDivers(String nomClientDivers) {
            this.nomClientDivers = nomClientDivers;
        }

        public double getMontantLivraison() {
            return montantLivraison;
        }


        public void setMontantLivraison(double montantLivraison) {
            this.montantLivraison = montantLivraison;
        }

        public String getIdCommercial() {
            return idCommercial;
        }

        public int getAdeclarer() {
            return adeclarer;
        }

        public double getMontantReste() {
            return montantReste;
        }

        public void setMontantReste(double montantReste) {
            this.montantReste = montantReste;
        }

        public void setIdCommercial(String idCommercial) {
            this.idCommercial = idCommercial;
        }

        public String getCommercial() {
        return commercial;
    }

    public void setCommercial(String commercial) {
        this.commercial = commercial;
    }

    public void setTypefraistransport(int typefraistransport) {
        this.typefraistransport = typefraistransport;
    }

    public int getTypefraistransport() {
        return typefraistransport;
    }

    public String getLieuLivraison() {
        return lieuLivraison;
    }

    public void setLieuLivraison(String lieuLivraison) {
        this.lieuLivraison = lieuLivraison;
    }

    public Date getDateLivraison() {
        return dateLivraison;
    }

    public void setDateLivraison(Date dateLivraison) {
        this.dateLivraison = dateLivraison;
    }

    public String getNumerofacture() {
        return numerofacture;
    }

    public void setNumerofacture(String numerofacture) {
        this.numerofacture = numerofacture;
    }

    public int getModelivraison() {
        return modelivraison;
    }

    public void setModelivraison(int modelivraison) {
        this.modelivraison = modelivraison;
    }

    public double getFraislivraison() {
        return fraislivraison;
    }

    public void setFraislivraison(double fraislivraison) {
        this.fraislivraison = fraislivraison;
    }

    public String getModepaiement() {
        return modepaiement;
    }

    public void setModepaiement(String modepaiement) {
        this.modepaiement = modepaiement;
    }

    public void setMargeBrute(double margeBrute) {
        this.margeBrute = margeBrute;
    }

    public double getMontantRevient() {
        return montantRevient;
    }

    public void setMontantRevient(double montantRevient) {
        this.montantRevient = montantRevient;
    }
    public String getReferencefact() {
        return referencefact;
    }

    public void setReferencefact(String referencefact) {
        this.referencefact = referencefact;
    }

    public double getMargeBrute()
    {
        return this.getMontantttc()-this.getMontantRevient();
    }

    public double getMontantTTCCalc()throws Exception
    {
            return AdminGen.calculSommeDouble(this.getFille(), "montantTTCCalc");
    }

    @Override
    public boolean isSynchro(){
        return true;
    }

    public void Vente(){
    }

        public double getAppoint(double montantPaye) throws Exception
        {
            double montantTTC = getMontantTTCCalc();
            return montantPaye - montantTTC;
        }

    @Override
    public boolean getEstIndexable() {
        return true;
    }

    @Override
    public String getTiers(){
        return this.getIdClient();
    }
    @Override
    public String getSensPrev(){
        return "credit";
    }

        @Override
        public ClassMAPTable createObjectBatch(String u, Statement st) throws Exception {
            boolean estOuvert=false;
            Connection c=null;
            try {
                if (st == null) {
                    c = new UtilDB().GetConn();
                    estOuvert = true;
                    st=c.createStatement();
                }
                else c = st.getConnection();
                if (this.getFactureEchange() != null && !this.getFactureEchange().trim().isEmpty()) {
                    Vente ancienneVente = this.getAncien(c);
                    if (ancienneVente.getMontantTTCCalcul() > this.getMontantTTCCalcul()) {
                        throw new Exception("La facture d'échange ne peut pas être supérieure à la facture initiale.");
                    }
                }
                String currentTime = LocalTime.now().format(DateTimeFormatter.ofPattern("HH:mm:ss"));
                this.setHeureSaisie(currentTime);
                //NumeroFacture[] numFact = (NumeroFacture[]) CGenUtil.rechercher(new NumeroFacture(), null, null, c, "");
                //this.setNumerofacture(numFact[0].getProchain_num_format());
                VenteDetails[] listeFille = (VenteDetails[]) this.getFille();
                RemiseFille[] listeRemise = this.getRemise(null, c);
                //Client cl = null;
                Ingredients[] listeIng = null;
                if (listeRemise != null && listeRemise.length > 0) {
                    //cl = this.getClient(c);
                    String apresW = " and id in (" + Utilitaire.tabToString(listeFille, "idProduit", "'", ",") + ")";
                    //listeIng=(Ingredients[])CGenUtil.rechercher(new Ingredients(),null,null,c,apresW);
                    listeIng = this.getListeIngredients(null, c);
                }
                Set<String> seen = new HashSet<>();

                if (this.getFille() == null) {
                    throw new Exception("Vente Detail is null");
                }

                for (VenteDetails vd : listeFille) {
                    String key = vd.getIdProduit();
                    String designation = vd.getDesignation();
//            vd.setCatClient(cl.getIdTypeClient());
                    RemiseFille rf = vd.estDansRemise(listeRemise, listeIng);
                    String idDevise = null;
                    if (vd.getIdDevise() != null || !vd.getIdDevise().trim().isEmpty()) {
                        idDevise = vd.getIdDevise().trim().toUpperCase();
                        vd.setIdDevise(idDevise);
                    }
                    //vd.setTva(20);
                    if (rf != null) {
                        vd.setRemise(rf.getRemise());
                        vd.setIdRemise(rf.getIdremise());
                    }
                    if (key == null || key.trim().isEmpty()) continue;

                    if (!seen.add(key)) {
                        throw new Exception("Doublon pour l'article : " + designation);
                    }
                }
//        CheckEtatStockVenteDetailsALaCreation(c);
                this.checkEtatStockGroupe(null,c);



                Vente createVente = (Vente) super.createObjectBatch(u, st);
                String codebarre = this.getId();

                this.genererCodeBarreWithName(createVente.getId(), ConstanteAsync.buildChemin(codebarre), codebarre, u);
                //if (estOuvert==true)st.executeBatch();
                return createVente;
            }
            catch (Exception e) {
                c.rollback();
                throw e;
            }
            finally{
                if(c!=null&&estOuvert==true)
                {
                    st.close();
                    c.close();
                }
            }
        }

        public MouvementCaisseFille creerAPpoint(double montant, String idCaisse) throws Exception {
            if(this.getIsAppoint()==false)return null;
            MouvementCaisseFille mvtAppoint = null;
            if(montant!=0) {
                mvtAppoint=new MouvementCaisseFille();
                mvtAppoint.setDaty(Utilitaire.dateDuJourSql());
                mvtAppoint.setDesignation("Appoint sur la vente " + this.getId());
                mvtAppoint.setIdDevise("AR");
                mvtAppoint.setTaux(1);
                mvtAppoint.setIdCassier(this.getUserFacture());
                mvtAppoint.setReference(this.getId());
                mvtAppoint.setIdCaisse(idCaisse);
                if (montant > 0) mvtAppoint.setCredit(+montant);
                else mvtAppoint.setDebit(-montant);
            }
            return mvtAppoint;
        }

        public MouvementCaisseFille creerAPpoint(double montant, String idCaisse, String idOrigine) throws Exception {
            if(this.getIsAppoint()==false)return null;
            MouvementCaisseFille mvtAppoint = null;
            if(montant!=0) {
                mvtAppoint=new MouvementCaisseFille();
                mvtAppoint.setDaty(Utilitaire.dateDuJourSql());
                mvtAppoint.setDesignation("Appoint sur la vente " + this.getId());
                mvtAppoint.setIdDevise("AR");
                mvtAppoint.setTaux(1);
                mvtAppoint.setIdCassier(this.getUserFacture());
                mvtAppoint.setReference(this.getId());
                mvtAppoint.setIdCaisse(idCaisse);
                mvtAppoint.setIdOrigine(idOrigine);
                mvtAppoint.setHeure(Utilitaire.getCurrentHeure());
                if (montant > 0) mvtAppoint.setCredit(+montant);
                else mvtAppoint.setDebit(-montant);
            }
            return mvtAppoint;
        }


        public MvtStock genererMvtStock(Connection c) throws Exception {
            boolean estOuvert = false;

            MvtStock var12;
            try {
                if (c == null) {
                    c = (new UtilDB()).GetConn();
                    estOuvert = true;
                }

                MvtStock mv = new MvtStock();
                MvtStock[] listeMv = (MvtStock[])CGenUtil.rechercher(mv, (String[])null, (String[])null, c, " AND idVente ='" + this.getId() + "'");
                if (listeMv.length > 0) {
                    throw new Exception("Un mouvement de stock a d\u00E9j\u00E0 \u00E9t\u00E9 g\u00E9n\u00E9r\u00E9 pour cette vente.");
                }

                mv.setDaty(this.getDaty());
                mv.setDesignation("Mouvement de stock relatif " + this.getId());
                mv.setIdMagasin(this.getIdMagasinVente());
                mv.setIdTypeMvStock("TPMVST000022");
                //mv.setIdTransfert(this.getId());
                mv.setIdVente(this.getId());
                mv.setIdobjet(this.getId());
                VenteDetails[] listeF = (VenteDetails[])this.getFille();
                MvtStockFille[] lf = new MvtStockFille[listeF.length];

                for(int i = 0; i < listeF.length; ++i) {
                    lf[i] = listeF[i].genererMvtStockFille(c);
                    if(lf[i]!=null) lf[i].setIdMvtStock(mv.getId());
                }

                mv.setFille(lf);
                var12 = mv;
            } catch (Exception e) {
                throw e;
            } finally {
                if (c != null && estOuvert) {
                    c.close();
                }

            }

            return var12;
        }

        public RemiseFille[] getRemise(String nt, Connection c) throws Exception {
            RemiseFille crt = new RemiseFille();
            crt.setNomTable("remiseFilleMereVise");
            if(nt!=null&&nt.compareToIgnoreCase("")!=0)crt.setNomTable(nt);
            String apresWherePoint=" and (idpoint='"+this.getIdMagasin()+"' or idpoint is null) ";
            String apresWhereDaty=" and '"+Utilitaire.formatterDaty(this.getDaty())+"'>=dateDebut and '"+Utilitaire.formatterDaty(this.getDaty())+ "'<=dateFin order by daty desc";
            RemiseFille[] ret= (RemiseFille[]) CGenUtil.rechercher(crt,null,null, c,apresWherePoint+ apresWhereDaty);
            return ret;
        }

        public Ingredients[] getListeIngredients(String nt,Connection c) throws Exception {
            if(this.getListeIng()!=null&&(nt==null||nt.compareToIgnoreCase("")==0))return this.getListeIng();
            Ingredients crt=new Ingredients();
            VenteDetails[]fille=(VenteDetails[]) this.getFille();
            if(nt!=null&&nt.compareToIgnoreCase("")!=0)crt.setNomTable(nt);
            String apresW=" and id in ("+Utilitaire.tabToString(fille,"idProduit","'",",") +")";
            setListeIng ((Ingredients[]) CGenUtil.rechercher(crt,null,null, c,apresW));
            return listeIng;
        }

        public Vente getAncien(Connection c) throws Exception {
            Vente ancien = new Vente();
            ancien.setId(this.getFactureEchange());
            ancien = (Vente) CGenUtil.getMereAvecFille(ancien ,  c, null);
            return ancien;
        }

        public double getMontantTTCCalcul() {
            return AdminGen.calculSommeDouble((VenteDetails[])this.getFille(), "montantTTCCalc");
        }

    public Vente getVenteWithMontant(Connection c) throws Exception{
        return (Vente)new Vente().getById(this.getId(), "VENTE_CPL", c);
    }

    public String genererBonLivraison(String u) throws Exception{
        Connection c = null;
        try{
            c = new UtilDB().GetConn();
            c.setAutoCommit(false);
            Vente enBase = (Vente)this.getById(this.getId(), this.getNomTable(), c);
            VenteDetailsLib vLib = new VenteDetailsLib();
            vLib.setNomTable("VENTE_DETAILS_RESTE");
            VenteDetailsLib[] details = (VenteDetailsLib[]) CGenUtil.rechercher(vLib,null,null,c," AND idVente='"+this.getId()+"' AND reste > 0");
            if(details.length > 0){
                As_BondeLivraisonClient client = new As_BondeLivraisonClient();
                client.setMode("modif");
                client.setIdvente(this.getId());
                client.setEtat(1);
                client.setIdclient(enBase.getIdClient());
                client.setRemarque("Livraison de la facture numero "+this.getId());
                client.setDaty(Utilitaire.dateDuJourSql());
                client.createObject(u, c);
                for(VenteDetailsLib detail:details){
                    As_BondeLivraisonClientFille clientFille = new As_BondeLivraisonClientFille();
                    clientFille.setMode("modif");
                    clientFille.setProduit(detail.getIdProduit());
                    clientFille.setUnite(detail.getIdUnite());
                    clientFille.setQuantite(detail.getReste());
                    clientFille.setIdventedetail(detail.getId());
                    clientFille.setNumbl(client.getId());
                    clientFille.createObject(u, c);
                }
                c.commit();
                return client.getId();
            }
            throw new Exception("Plus aucun article à livrer");
        }
        catch(Exception e){
            if(c!=null) c.rollback();
            throw e;
        }
        finally{
            if(c!=null) c.close();
        }
    }

    public As_BondeLivraisonClient genererBonLivraison() throws Exception{
        Connection c = null;
        try{
            c = new UtilDB().GetConn();
            Vente enBase = (Vente)this.getById(this.getId(), this.getNomTable(), c);
            VenteDetailsLib vLib = new VenteDetailsLib();
            vLib.setNomTable("VENTE_DETAILS_RESTE");
            VenteDetailsLib[] details = (VenteDetailsLib[]) CGenUtil.rechercher(vLib,null,null,c," AND idVente='"+this.getId()+"' AND reste > 0");
            if(details.length > 0){
                As_BondeLivraisonClient client = new As_BondeLivraisonClient();
                client.setMode("modif");
                client.setIdvente(this.getId());
                client.setEtat(1);
                client.setIdclient(enBase.getIdClient());
                client.setRemarque("Livraison de la facture numero "+this.getId());
                client.setDaty(Utilitaire.dateDuJourSql());
                client.setIdorigine(this.getId());
                client.setIdbc(this.getIdOrigine());
                client.setLieudelivraison(enBase.getLieuLivraison());
                ArrayList<As_BondeLivraisonClientFille> fillesArrays = new ArrayList<>();

                boolean hasValidArticle = false;
                int i = 0;
                for(VenteDetailsLib detail:details){
                    if(detail.getIdProduit().compareToIgnoreCase(ConstanteSavonnerie.IngForfaitlivraison)==0||detail.getIdProduit().compareToIgnoreCase(ConstanteSavonnerie.IngFraislivraison)==0) continue;
                    hasValidArticle = true;
                    As_BondeLivraisonClientFille_Cpl clientFille = new As_BondeLivraisonClientFille_Cpl();
                    clientFille.setMode("modif");
                    clientFille.setProduit(detail.getIdProduit());
                    Ingredients ing = (Ingredients) new Ingredients().getById(detail.getIdProduit(),"AS_INGREDIENTS",c);
                    clientFille.setProduitlib(ing.getLibelle());
                    clientFille.setUnite(detail.getIdUnite());
                    clientFille.setUnitelib(detail.getUnitelib());
                    clientFille.setQuantite(detail.getReste());
                    clientFille.setIdventedetail(detail.getId());
                    clientFille.setNumbl(client.getId());
                    clientFille.setIdbc_fille(detail.getIdbcfille());
                    fillesArrays.add(clientFille);
                }
                if (!hasValidArticle) {
                    throw new Exception("Plus aucun article \\u00e1 livrer");
                }
                As_BondeLivraisonClientFille [] filles = fillesArrays.toArray(new As_BondeLivraisonClientFille[0]);
                client.setFille(filles);
                return client;
            }
            throw new Exception("Plus aucun article \\u00e1 livrer");
        }
        catch(Exception e){
            throw e;
        }
        finally{
            if(c!=null) c.close();
        }
    }

        public void setAdeclarer(int adeclarer) {
            this.adeclarer = adeclarer;
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

        public String getHeureSaisie() {
            return heureSaisie;
        }

        public void setHeureSaisie(String heureSaisie) {
            this.heureSaisie = heureSaisie;
        }

        public String getIdEcheancePaiement() {
            return idEcheancePaiement;
        }

        public void setIdEcheancePaiement(String idEcheancePaiement) {
            this.idEcheancePaiement = idEcheancePaiement;
        }

        public Date getDateEcheance() {
            return dateEcheance;
        }

        public void setDateEcheance(Date dateEcheance) {
            this.dateEcheance = dateEcheance;
        }

        public String getIdResponsable() {
            return idResponsable;
        }

        public void setIdResponsable(String idResponsable) {
            this.idResponsable = idResponsable;
        }

        public String getIdModePaiement() {
            return idModePaiement;
        }

        public void setIdModePaiement(String idModePaiement) {
            this.idModePaiement = idModePaiement;
        }

        public double getMontantDonne() {
            return montantDonne;
        }

        public void setMontantDonne(double montantDonne) {
            this.montantDonne = montantDonne;
        }

        public String getCompte() {
            return compte;
        }


        public void setCompte(String compte) {
            this.compte = compte;
        }

        public String getIdClient() {
            return idClient;
        }

        public void setIdClient(String idClient) throws Exception {
            if(this.getMode().compareTo("modif")==0)
            {
                if(idClient==null||idClient.compareToIgnoreCase("")==0)
                    throw new Exception("Client obligatoire");
            }
            this.idClient = idClient;
        }

        public Vente() {
            this.setNomTable("VENTE");
        }

        public Vente(String nomtable) {
            setNomTable(nomtable);
        }

        public int getEstPrevu() {
            return estPrevu;
        }

        public void setEstPrevu(int estPrevu) {
            this.estPrevu = estPrevu;
        }







        public String getIdMagasin() {
            return idMagasin;
        }

        public void setIdMagasin(String idMagasin) {
            this.idMagasin = idMagasin;
        }



        public boolean isPaye(){
            if(this.getEtat()== ConstanteEtatCustom.PAYE_LIVRE  || this.getEtat()==ConstanteEtatCustom.PAYE_NON_LIVRE){
                return true;
            }
            return false;
        }

        public boolean isLivre(){
            if(this.getEtat()== ConstanteEtatCustom.LIVRE_NON_PAYE || this.getEtat()==ConstanteEtatCustom.PAYE_LIVRE){
                return true;
            }
            return false;
        }



        public String getClientlib() {
            return clientlib;
        }

        public void setClientlib(String clientlib) {
            this.clientlib = clientlib;
        }

        public double getTauxdechange() {
            return tauxdechange;
        }

        public void setTauxdechange(double tauxdechange) {
            this.tauxdechange = tauxdechange;
        }

        public void payer(String u,Connection c) throws Exception{
            if(this.getEtat() < ConstanteEtat.getEtatValider()){
                throw new Exception("Impossible d encaisser une vente non validée");
            }
            if(isLivre()){
                this.updateEtat(ConstanteEtatCustom.PAYE_LIVRE, this.getId(), c);
            }
            else{
                this.updateEtat(ConstanteEtatCustom.PAYE_NON_LIVRE, this.getId(), c);
            }
            genererEcritureEncaissement(u, c);
        }

        public void livrer(String u,Connection c) throws Exception{
            if(this.getEtat() < ConstanteEtat.getEtatValider()){
                throw new Exception("Impossible de livrer une vente non validée");
            }
            if(isPaye()){
                this.updateEtat(ConstanteEtatCustom.PAYE_LIVRE, this.getId(), c);
            }
            else{
                this.updateEtat(ConstanteEtatCustom.LIVRE_NON_PAYE, this.getId(), c);
            }
        }

        public void lierLivraisons(String u, String [] idLivraison) throws Exception{
            Connection c = null;
            try {
                c = new UtilDB().GetConn();
                VenteDetails[] venteDetails = getVenteDetails(c);
                As_BondeLivraisonClient [] blcs = As_BondeLivraisonClient.getAll(idLivraison,c);
                As_BondeLivraisonClient.controlerClient(blcs);
                for (As_BondeLivraisonClient blcTemp : blcs) {
                    blcTemp.setIdvente(this.getId());
                    blcTemp.updateToTableWithHisto(u, c);
                    As_BondeLivraisonClientFille [] blcfs = (As_BondeLivraisonClientFille[]) CGenUtil.rechercher(new As_BondeLivraisonClientFille(), null, null, c, " and NUMBL = '"+ blcTemp.getId() +"'");
                    for (int i = 0; i < venteDetails.length; i++) {
                        for (As_BondeLivraisonClientFille as_BondeLivraisonClientFilleTemp: blcfs) {
                            if(venteDetails[i].getIdProduit().equals(as_BondeLivraisonClientFilleTemp.getProduit())){
                                as_BondeLivraisonClientFilleTemp.setIdventedetail(venteDetails[i].getId());
                                as_BondeLivraisonClientFilleTemp.updateToTableWithHisto(u, c);
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

        @Override
        public void changeState(String acte, String u,Connection con)throws Exception{
            if(acte.equals("livrer")){
                this.livrer(u, con);
            }
            else if(acte.equals("payer")){
                this.payer(u, con);
            }
        }

        public String getRemarque() {
            return remarque;
        }

        public void setRemarque(String remarque) {
            this.remarque = remarque;
        }

        @Override
        public String getTuppleID() {
            return this.getId();
        }

        @Override
        public String getAttributIDName() {
            return "id";
        }

        public String getIdOrigine() {
            return idOrigine;
        }

        public void setIdOrigine(String idOrigine) {
            this.idOrigine = idOrigine;
        }


        @Override
        public void construirePK(Connection c) throws Exception {
            this.preparePk("VNT", "getSeqVente");
            this.setId(makePK(c));
        }

        public Caisse getCaisse(Connection c) throws Exception {
            Caisse caisse = new Caisse();
            Caisse[] caisses = (Caisse[]) CGenUtil.rechercher(caisse, null, null, c, " and idMagasin = '"+this.getIdMagasin()+"'");
            if (caisses.length > 0) {
                return caisses[0];
            }
            return null;
        }

        public Magasin getMagasin(Connection c) throws Exception {
            Magasin magasin = new Magasin();
            magasin.setId(this.getIdMagasin());
            Magasin[] magasins = (Magasin[]) CGenUtil.rechercher(magasin, null, null, c, " ");
            if (magasins.length > 0) {
                return magasins[0];
            }
            return null;
        }

        public VenteDetails[] getVenteDetails() {
            return venteDetails;
        }

        public void setVenteDetails(VenteDetails[] venteDetails) {
            this.venteDetails = venteDetails;
        }

        @Override
        public void controler(Connection c) throws Exception {
            super.controler(c);
        }

        @Override
        public void controlerUpdate(Connection c) throws Exception {
            super.controlerUpdate(c);

        }

        public void createMvtCaisses(String u, Connection c) throws Exception {
            VenteDetailsCpl vdc = new VenteDetailsCpl();
            vdc.setIdVente(this.getId());
            VenteDetailsCpl[] vdcs = (VenteDetailsCpl[]) CGenUtil.rechercher(vdc, null, null, c, " ");
            for (int i = 0; i < vdcs.length; i++) {
                MvtCaisse mc = vdcs[i].createMvtCaisse();
                mc.createObject(u, c);
            }
        }

        public VenteDetailsLib[] getVenteDetails(Connection c) throws Exception {
            VenteDetailsLib obj = new VenteDetailsLib();
            obj.setNomTable("VENTE_DETAILS_CPL");
            obj.setIdVente(this.getId());
            VenteDetailsLib[] objs = (VenteDetailsLib[]) CGenUtil.rechercher(obj, null, null, c, " ");
            if (objs.length > 0) {
                return objs;
            }
            return null;
        }
        protected EncaissementDetails [] generateDetailsEncaissements (Connection c ) throws Exception{
            VenteDetailsLib[] vd= this.getVenteDetails(c);
            EncaissementDetails[] ed=new EncaissementDetails [vd.length];
            for(int i=0;i<ed.length;i++){
                ed[i]=vd[i].generateEncaissementDetails();
            }
            return ed;
        }

        @Override
        public Object payerObject(String u,Connection con) throws Exception{
            super.payerObject(u, con);
            Encaissement enc=this.genererEncaissement();
            enc=(Encaissement) enc.createObject(u, con);
            EncaissementDetails [] ed=generateDetailsEncaissements ( con );
            for(int i=0;i<ed.length;i++){
                ed[i].setIdEncaissement(enc.getId());
                ed[i].createObject(u,con);
            }
            return enc;
        }



        protected MvtStockFille[] createMvtStockFilles(Connection c) throws Exception {
            VenteDetails[] tsd = this.getVenteDetails(c);
            MvtStockFille[] mvtf = new MvtStockFille[tsd.length];
            for (int i = 0; i < tsd.length; i++) {
                mvtf[i] = tsd[i].createMvtStockFille();
            }
            return mvtf;
        }

        protected MvtStock createMvtStock() throws Exception {
            MvtStock md = new MvtStock();
            md.setDaty(this.getDaty());
            md.setDesignation("Vente lubrifiant : " + this.getDesignation());
            md.setIdTransfert(this.getId());
            md.setIdTypeMvStock(ConstanteStation.TYPEMVTSTOCKSORTIE);
            md.setIdMagasin(this.getIdMagasin());
            return md;
        }

        protected MvtStock createMvtStockSortie(String u, Connection c) throws Exception {
            MvtStock ms = this.createMvtStock();
            ms.setFille(this.createMvtStockFilles(c));
            ms.createObject(u, c);
            ms.saveMvtStockFille(u, c);
            ms.validerObject(u, c);
            return ms;
        }
        public TarifIngredients[] getTarifIngreDient(Connection c ,String nomTable)throws Exception{
            VenteDetails[] listeDet=(VenteDetails[]) this.getFille();
            String listeId=Utilitaire.tabToString(listeDet,"idProduit","'",",");
            Client cl=this.getClient(c);
            TarifIngredients crt=new TarifIngredients();
            if(nomTable!=null&&nomTable!="")crt.setNomTable(nomTable);
            if(cl==null) throw new Exception("Client inexistant");
            if(cl.getIdTypeClient()!=null) crt.setIdTypeClient(cl.getIdTypeClient());
            return (TarifIngredients[]) CGenUtil.rechercher(crt,null,null,c," and idIngredient in ("+listeId+")");
        }

        public void genererTarifInExistant(String u,Connection c) throws Exception{
            VenteDetails[] listeDet=(VenteDetails[]) this.getFille();
            TarifIngredients [] listeTarif=getTarifIngreDient(c,null);
            String attrEt[]={"idIngredient","idTypeClient"};
            String valEt[]={"",this.getClient(c).getIdTypeClient()};
            for(int i=0;i<listeDet.length;i++){
                valEt[0]=listeDet[i].getIdProduit();
                TarifIngredients[] valiny=(TarifIngredients[])AdminGen.find(listeTarif,attrEt,valEt);
                if(valiny==null||valiny.length==0||valiny[0]==null){
                    TarifIngredients t=listeDet[i].genererTarifIngredients(c);
                    if(t!=null) t.createObject(u,c);
                }
            }
        }


        @Override
        public Object validerObject(String u, Connection c) throws Exception {
            boolean estOuvert = false;
            try {
                if (c == null) {
                    estOuvert = true;
                    c = new UtilDB().GetConn();
                }
                Client kil = this.getClient(c);
                if (kil.getIdTypeClient()!=null&&kil.getIdTypeClient().compareToIgnoreCase (ConstanteVente.clientPersonnelSalarie)==0 &&(kil.getCin() == null || kil.getCin().isEmpty() || kil.getCin().equals("")) ) {
                    throw new Exception("Veuillez ajouter le CIN du client dans sa fiche avant de valider cette vente");
                }
                CheckEtatStockVenteDetails(c);
                VenteDetails[] listeFille=(VenteDetails[]) this.getFille(null,c,"");
                this.genererTarifInExistant(u,c);
                for(int i=0;i<listeFille.length;i++){
                    if(listeFille[i].getIdProduit()==null||listeFille[i].getIdProduit().equals(""))continue;
                    Ingredients ingredients = null;
                    ingredients =  (Ingredients) CGenUtil.rechercher(new Ingredients(), null, null, c, " and id = '"+listeFille[i].getIdProduit()+"'" )[0];
                    listeFille[i].setPoids(ingredients.getCalorie());
                    listeFille[i].calculerRevient(c);
                    listeFille[i].updateToTableWithHisto(u,c);
                }

                NumeroFacture[] numFact = (NumeroFacture[]) CGenUtil.rechercher(new NumeroFacture(), null, null, c, "");
                this.setNumerofacture(numFact[0].getProchain_num_format());
                super.validerObject(u, c);
                Client cl = this.getClient(c);
                if (cl != null && cl.getNom() != null) {
                    HistoInsert.ajoutRemarque(this.getId(), cl.getNom(), c);
                }
                setFille(listeFille);
                genererEcriture(u, c);
                //MvtStock stockEngage = genererStockEngage(listeFille, c);
                //if (stockEngage != null) {
                //    stockEngage.createObject(u, c);
                //}

                Ristourne ristourne = genererRistourne();
                if (ristourne != null) {
                    ristourne.createObject(u, c);
                    ristourne.validerObject(u, c);
                }

//            createMvtStockSortie(u, c);
                if(this.getEstPrevu() == 0){
                    genererPrevision(u, c);
                }
                else if (this.getEstPrevu() == 1){
                    genererPrevisionPrevu(u, c);
                }
                if(idClient.equals(ConstanteSavonnerie.CLIENT_APPRO_VENTE)){
                    //genererTransfertStock(listeFille, u, c);
                }
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

        public TransfertStock genererTransfertStock(VenteDetails[] listeFille, String u, Connection c) throws Exception {
            TransfertStock st = new TransfertStock();
            st.setDaty(this.getDaty());
            st.setDesignation("Transfert de stock pour vente en details"+this.getId());
            st.setIdMagasinArrive(ConstanteSavonnerie.MAGASIN_APPRO);
            st.setIdMagasinDepart(this.getIdMagasin());
            st.setIsvente(1);
            st.setFille(new TransfertStockDetails[0]);
            st.createObject(u,c);
            TransfertStockDetails[] transfertFille =  genererTransfertStockFilleParPiece(listeFille, st, u, c);
            //st.validerObject(u, c);
            return st;
        }

        public TransfertStockDetails[] genererTransfertStockFilleParPiece(VenteDetails[] listeFille, TransfertStock mere, String u, Connection c) throws Exception {
            if (listeFille == null || listeFille.length == 0) {
                listeFille = (VenteDetails[]) this.getFille(null,c,"");
            }
            TransfertStockDetailsAppro[] fille = new TransfertStockDetailsAppro[listeFille.length];
            for (int i = 0; i < listeFille.length; i++) {
                double qtePiece = listeFille[i].getQte();
                double puPiece =  listeFille[i].getPu();
                String idproduit1 = null;
                EquivalenceCarton equivalence = Ingredients.getEquivalenceCarton(listeFille[i].getIdProduit() , c);
                if(equivalence != null){
                    qtePiece = listeFille[i].getQte()*equivalence.getNbcarton();
                    puPiece = listeFille[i].getPu() / equivalence.getNbcarton();
                    idproduit1 = equivalence.getIdPetris();
                }else{
                    idproduit1 = listeFille[i].getIdProduit();
                    qtePiece = listeFille[i].getQte();
                    puPiece = listeFille[i].getPu();
                }
                fille[i] = new TransfertStockDetailsAppro();
                fille[i].setQuantitesource(listeFille[i].getQte());
                fille[i].setPusource(listeFille[i].getPu());
                fille[i].setIdProduit(idproduit1);
                fille[i].setDaty(listeFille[i].getDatesaisie());
                fille[i].setPu(puPiece);
                fille[i].setQuantite(qtePiece);
                fille[i].setIdTransfertStock(mere.getId());
                fille[i].setEstapprodv(1);
                fille[i].createObject(u,c);
            }
            mere.setFille(fille);
            return  fille;
        }
        public TransfertStock genererTransfertStock(Connection c) throws Exception {
            VenteDetails[] listeFille=(VenteDetails[]) this.getFille(null,c,"");
            Vente vente = (Vente) new Vente().getById(this.getId(),"VENTE",c);
            TransfertStock st = new TransfertStock();
            st.setDaty(vente.getDaty());
            st.setDesignation("Transfert de stock pour vente "+this.getId());
            st.setIdMagasinArrive(ConstanteSavonnerie.MAGASIN_APPRO);
            st.setIdMagasinDepart(vente.getIdMagasin());
            st.setIsvente(1);
            st.setFille(new TransfertStockDetails[0]);
            //st.createObject(u,c);
            TransfertStockDetails[] transfertFille =  vente.genererTransfertFilleParPiece(listeFille, st, c);
            st.setFille(transfertFille);
            //st.validerObject(u, c);
            return st;
        }

        public TransfertStockDetails[] genererTransfertFilleParPiece(VenteDetails[] listeFille, TransfertStock mere, Connection c) throws Exception {
            if (listeFille == null || listeFille.length == 0) {
                listeFille = (VenteDetails[]) this.getFille(null,c,"");
            }
            TransfertStockDetailsAppro[] fille = new TransfertStockDetailsAppro[listeFille.length];
            for (int i = 0; i < listeFille.length; i++) {

                double qtePiece = listeFille[i].getQte();
                double puPiece =  listeFille[i].getPu();
                String idproduit1 = "";
            /*EquivalenceVente equivalence = Ingredients.getEquivalenceVente(listeFille[i].getIdProduit(), ConstanteSocobis.UNITE_PIECE, c);
            if(equivalence != null){
                qtePiece = listeFille[i].getQte() * equivalence.getQuantite();
                puPiece = listeFille[i].getPu() / equivalence.getQuantite();
                idproduit1 = equivalence.getIdproduit1();
            }*/
                fille[i] = new TransfertStockDetailsAppro();
                fille[i].setQuantitesource(listeFille[i].getQte());
                fille[i].setPusource(listeFille[i].getPu());
                fille[i].setIdProduit(listeFille[i].getIdProduit());
                fille[i].setDaty(listeFille[i].getDatesaisie());
                fille[i].setPu(listeFille[i].getPu());
                fille[i].setQuantite(listeFille[i].getQte());
                fille[i].setIdTransfertStock(mere.getId());
                fille[i].setEstapprodv(1);
                //fille[i].createObject(u,c);
            }
            mere.setFille(fille);
            return  fille;
        }


        public Ristourne genererRistourne() throws Exception {
            Ristourne ristourne = new Ristourne();
            ristourne.setEstLiaisonPaiement(1);
            ristourne.setDesignation("Ristourne ...");
            ristourne.setIdClient(getIdClient());
            ristourne.setIdOrigine(this.getId());
            ristourne.setDaty(Utilitaire.dateDuJourSql());
            ristourne.setMois(Utilitaire.getMois(getDaty()));
            ristourne.setAnnee(Utilitaire.getAnnee(getDaty()));
            ristourne.setIdVente(getId());
            ristourne.setDateDebutRistourne(null);
            ristourne.setDateFinRistourne(null);

            List<RistourneDetails> ristourneDetails = getRistourneDetails();

            if (ristourneDetails.isEmpty()) {
                return null;
            }

            ristourne.setFille(ristourneDetails.toArray(new RistourneDetails[]{}));
            return ristourne;
        }

        private List<RistourneDetails> getRistourneDetails() throws Exception {
            VenteDetails[] listeFille= (VenteDetails[]) this.getFille();
            List<RistourneDetails> ristourneDetails = new ArrayList<>();
            for (VenteDetails venteFille : listeFille) {
                if (venteFille.getRistourne() != 0) {
                    RistourneDetails ristourneFille = new RistourneDetails();
                    ristourneFille.setIdProduit(venteFille.getIdProduit());
                    ristourneFille.setIdOrigine(venteFille.getIdOrigine());
                    ristourneFille.setTaux1(venteFille.getRistourne());

                    ristourneDetails.add(ristourneFille);
                }
            }
            return ristourneDetails;
        }

        public MvtStock genererStockEngage(VenteDetails[] listeFille, Connection c) throws Exception {
            MvtStock mvtf = new MvtStock();
            mvtf.setNomTable("stock_engage");
            mvtf.setDesignation("Engagement du vente " + this.getId());
            mvtf.setIdMagasin(this.getIdMagasin());
            mvtf.setIdVente(this.getId());
            mvtf.setIdTypeMvStock(ConstanteStation.TYPEMVTSTOCKSORTIE);
            mvtf.setIdobjet(this.getId());
            mvtf.setDaty(this.getDaty());
            mvtf.setEtat(ConstanteEtat.getEtatValider());

            List<MvtStockFille> mvtStockFilles = new ArrayList<>();
            for (VenteDetails vd : listeFille) {
                if(vd.getIdProduit()==null||vd.getIdProduit().compareToIgnoreCase("")==0)continue;
                Ingredients [] ings = (Ingredients[]) CGenUtil.rechercher(new Ingredients(), null, null, c, " and id = '"+vd.getIdProduit()+"'");
                if(ings[0].getCategorieIngredient().compareToIgnoreCase(ConstanteStation.idProduitAutre)!=0 && ings[0].getCategorieIngredient().compareToIgnoreCase(ConstanteStation.idProduitService) != 0){
                    MvtStockFille mvtFille = new MvtStockFille();
                    mvtFille.setNomTable("stock_engage_fille");

                    Produit produit = vd.getProduitAs(c);

                    mvtFille.setIdProduit(produit.getId());
                    mvtFille.setIdVenteDetail(vd.getId());
                    mvtFille.setDesignation("Engagement detail : " + vd.getId());
                    mvtFille.setCategorieIngredient(produit.getIdCategorie());
                    mvtFille.setEntree(0);
                    mvtFille.setSortie(vd.getQte());
                    mvtFille.setPu(vd.getPu());
                    mvtFille.setMontant(vd.getMontant());
                    mvtFille.setEtat(ConstanteEtat.getEtatValider());

                    mvtStockFilles.add(mvtFille);
                }
            }

            mvtf.setFille(mvtStockFilles.toArray(new MvtStockFille[]{}));

            return mvtf;
        }

        public void CheckEtatStockVenteDetails(Connection c) throws Exception {
            VenteDetailsLib[] vds = getVenteDetails(c);
            if (vds != null) {
                for (VenteDetailsLib v : vds) {
                    if(v.getIdProduit()==null)continue;
                    Ingredients [] ings = (Ingredients[]) CGenUtil.rechercher(new Ingredients(), null, null, c, " and id = '"+v.getIdProduit()+"'");
                    if(ings[0].getCategorieIngredient().compareToIgnoreCase(ConstanteStation.idProduitAutre)!=0){
                        v.CheckEtatStock(c);
                    }
                }
            }
        }
        public void checkEtatStockGroupe(String ntStock, Connection c) throws Exception {
            Ingredients[] ids = this.getListeIngredients(null, c);
            VenteDetails[] listeFille = (VenteDetails[]) this.getFille();
            if (ids == null || ids.length == 0 || listeFille == null || listeFille.length == 0) return;

            // Indexer les ingredients par id pour acces rapide
            Map<String, Ingredients> mapIng = new HashMap<String, Ingredients>();
            for (Ingredients ing : ids) {
                if (ing != null && ing.getId() != null) mapIng.put(ing.getId(), ing);
            }

            // Collecter les ids des produits stockables demandes
            Set<String> idsProdStockables = new LinkedHashSet<String>();
            for (VenteDetails vd : listeFille) {
                if (vd == null || vd.getIdProduit() == null || vd.getIdProduit().trim().isEmpty()) continue;
                Ingredients ing = mapIng.get(vd.getIdProduit());
                if (ing != null && ing.isService()) continue;
                idsProdStockables.add(vd.getIdProduit());
            }
            if (idsProdStockables.isEmpty()) return;

            // Charger et indexer le stock disponible
            Map<String, EtatStock> mapStock = chargerEtatStock(ntStock, idsProdStockables, c);

            // Controler chaque ligne de vente
            StringBuilder erreurs = new StringBuilder();
            for (VenteDetails vd : listeFille) {
                if (vd == null || vd.getIdProduit() == null || vd.getIdProduit().trim().isEmpty()) continue;
                Ingredients ing = mapIng.get(vd.getIdProduit());
                if (ing != null && ing.isService()) continue;

                EtatStock es = mapStock.get(vd.getIdProduit());
                double stockDispo = (es != null) ? es.getReste() : 0.0;
                if (stockDispo < vd.getQte()) {
                    String libelle = (es != null && es.getIdProduitLib() != null && !es.getIdProduitLib().trim().isEmpty())
                            ? es.getIdProduitLib()
                            : (vd.getDesignation() != null ? vd.getDesignation() : vd.getIdProduit());
                    erreurs.append("- ").append(libelle)
                            .append(" : Stock ").append(stockDispo)
                            .append(" < Demande ").append(vd.getQte()).append("\n");
                }
            }

            if (erreurs.length() > 0) {
                throw new Exception("Stock insuffisant :\n" + erreurs.toString());
            }
        }

        private Map<String, EtatStock> chargerEtatStock(String ntStock, Set<String> idsProduits, Connection c) throws Exception {
            EtatStock etat = new EtatStock();
            etat.setNomTable("V_ETATSTOCK_ING_eng");
            if (ntStock != null && ntStock.compareToIgnoreCase("") != 0) etat.setNomTable(ntStock);

            StringBuilder valIn = new StringBuilder();
            int idx = 0;
            for (String id : idsProduits) {
                if (idx > 0) valIn.append(",");
                valIn.append("'").append(id).append("'");
                idx++;
            }

            String awhere = " and idProduit in(" + valIn.toString() + ") and idmagasin='" + this.getIdMagasin() + "' ";
            EtatStock[] et = (EtatStock[]) CGenUtil.rechercher(etat, null, null, c, awhere);
            if (et == null) et = new EtatStock[0];

            Map<String, EtatStock> map = new HashMap<String, EtatStock>();
            for (EtatStock es : et) {
                if (es != null && es.getIdProduit() != null) map.put(es.getIdProduit(), es);
            }
            return map;
        }

        public void CheckEtatStockVenteDetailsALaCreation(Connection c) throws Exception {
            VenteDetails[] vds = (VenteDetails[])this.getFille();
            if (vds != null) {
                for (VenteDetails v : vds) {
                    v.CheckEtatStockALaCreation(c, this.getIdMagasin());
                }
            }
        }

        public void genererEcritureEncaissement(String u, Connection c) throws Exception{
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
            ComptaSousEcriture[] filles = this.genererSousEcritureEncaissement(u,c);
            for(int i=0; i<filles.length; i++){
                filles[i].setIdMere(mere.getId());
                filles[i].setExercice(exercice);
                filles[i].setDaty(this.getDaty());
                filles[i].setJournal(ConstanteStation.JOURNALVENTE);

                if(filles[i].getDebit()>0 || filles[i].getCredit()>0) filles[i].createObject(u, c);
            }
        }

        public ComptaSousEcriture[] genererSousEcritureEncaissement(String refUser,Connection c) throws Exception{
            ComptaSousEcriture[] compta={};
            boolean canClose=false;
            try{
                if(c==null){
                    c=new UtilDB().GetConn();
                    canClose=true;
                }
                Vente[] ventes = (Vente[]) CGenUtil.rechercher(new Vente("VENTE_MERE_MONTANT"), null, null, c, " and id = '"+this.getId()+"'");
                if(ventes.length<1) throw new Exception("Facture mere Introuvable");
                this.setCompte(getClient(c).getCompte());

                compta = new ComptaSousEcriture[2];

                compta[0]=new ComptaSousEcriture();
                compta[0].setLibellePiece(this.getDesignation());
                compta[0].setRemarque(this.getDesignation());
                compta[0].setCompte(getCaisse(c).getCompte());
                compta[0].setDebit(ventes[0].getMontantttc());
                MvtCaisse mvt= new MvtCaisse();
                mvt.setCredit(ventes[0].getMontantttc());
                mvt.setIdCaisse(getCaisse(c).getId());
                mvt.setDaty(utilitaire.Utilitaire.dateDuJourSql());
                mvt.setDesignation( "mvt pour"+ this.getDesignation());
                mvt.setIdOrigine(this.getId());
                mvt.createObject(refUser, c);
                mvt.validerObject(refUser, c);

                compta[1]=new ComptaSousEcriture();
                compta[1].setLibellePiece("Encaissement Client "+ventes[0].getClientlib());
                compta[1].setRemarque("Encaissement Client "+ventes[0].getClientlib());
                compta[1].setCompte(this.getCompte());
                //            compta[i].setDebit((montantHT-retenue) * ((this.getTva()/100)));
                compta[1].setCredit(ventes[0].getMontantttc());

            } catch(Exception e){
                throw e;
            } finally {
                if(canClose){
                    c.close();
                }
            }
            return compta;
        }

        public void genererEcriture(String u, Connection c) throws Exception{
            ComptaEcriture mere = new ComptaEcriture();
//            Date dateDuJour = utilitaire.Utilitaire.dateDuJourSql();
            int exercice = utilitaire.Utilitaire.getAnnee(daty);
            mere.setDaty(this.getDaty());
            mere.setDesignation("Fa " + Utilitaire.champNull(this.getNumerofacture()) + " - " +Utilitaire.champNull(this.getClient(c).getNom()) + " - " + Utilitaire.champNull(this.getDesignation()));
            mere.setExercice(""+exercice);
            mere.setDateComptable(this.getDaty());
            mere.setJournal(ConstanteStation.JOURNALVENTE);
            mere.setOrigine(this.getId());
            mere.setIdobjet(this.getId());

            ComptaSousEcriture[] filles = this.genererSousEcriture(c);
            for(int i=0; i<filles.length; i++){
                filles[i].setIdMere(mere.getId());
                filles[i].setExercice(exercice);
                filles[i].setDaty(this.getDaty());
                filles[i].setJournal(ConstanteStation.JOURNALVENTE);
                filles[i].setRemarque(mere.getDesignation());
                filles[i].setLibellePiece(this.getNumerofacture());
                //if(filles[i].getDebit()>0 || filles[i].getCredit()>0) filles[i].createObject(u, c);
            }
            mere.setFille(filles);
            mere.createObject(u, c);
//            mere.validerObject(u, c);
        }

        public Client getClient(Connection c) throws Exception{
            if(this.getClient()!=null) return getClient();
            Client client = new Client();
            Client[] clients = (Client[]) CGenUtil.rechercher(client,null,null,c, " and id = '"+this.getIdClient()+"'");
            if(clients.length > 0){
                this.setClient(clients[0]);
                return clients[0];
            }
            throw new Exception("Le client n'existe pas");
        }
        public double getPoidsTotal(Connection c) throws Exception{
            double poidsTotal =0;
            VenteDetails[] details = (VenteDetails[]) this.getFille();
            for (VenteDetails detail : details) {
                poidsTotal += detail.getPoids() * detail.getQte();
            }
            return poidsTotal;
        }


        public ComptaSousEcriture[] genererSousEcriture(Connection c) throws Exception{
            ComptaSousEcriture[] compta={};
            boolean canClose=false;
            try{
                if(c==null){
                    c=new UtilDB().GetConn();
                    canClose=true;
                }
                String magasin = this.getIdMagasin();
                //Vente[] ventes = (Vente[]) CGenUtil.rechercher(new Vente("VENTE_MERE_MONTANT"), null, null, c, " and id = '"+this.getId()+"'");
                //if(ventes.length<1) throw new Exception("Facture mere Introuvable");
                Client client = getClient(c);
                this.setCompte(client.getCompte());
//                VenteDetails [] details =(VenteDetails[]) this.getFille();
//                double montantTva = AdminGen.calculSommeDouble(details,"montantTVACalc")*details[0].getTauxDeChange();
//                double montantTTC = AdminGen.calculSommeDouble(details,"montantTTCCalc")*details[0].getTauxDeChange();
                VenteDetails [] details = this.getDetails(c);
                double montantHT = AdminGen.calculSommeDouble(details, "montantHTAr");
                double montantTva = AdminGen.calculSommeDouble(details,"montantTvaAr");
                double montantTTC = AdminGen.calculSommeDouble(details,"montantTTCAr");

                int taille = details.length;
                compta = new ComptaSousEcriture[taille+2];
                if(montantTva==0)compta=new ComptaSousEcriture[taille+1];
                Ingredients ing = null;
                int i=0;
                double poidsTotal = getPoidsTotal(c);
                if(poidsTotal==0)poidsTotal=1;
                for(i=i;i<taille;i++){
                    //ing = details[i].getIngFille();
                    compta[i]=new ComptaSousEcriture();
                    compta[i].setLibellePiece(this.getDesignation());
                    compta[i].setRemarque(details[i].getLibelle());
                    if(magasin.compareToIgnoreCase(ConstanteComptable.magasinVD) == 0){
                        compta[i].setCompte(ConstanteComptable.CompteMagasinVD);
                    }else {
                        compta[i].setCompte(details[i].getCompte());
                    }
                    double fraisdetails = poidsTotal * this.getFraislivraison();
//                    compta[i].setCredit((details[i].getMontantHTCalcule() * details[i].getTauxDeChange()) - fraisdetails);
                    compta[i].setCredit((details[i].getMontantHTAr()) - fraisdetails);
                }
                if(montantTva>0){
                    compta[i]=new ComptaSousEcriture();
                    compta[i].setLibellePiece("TVA Collectee");
                    compta[i].setRemarque("TVA Collectee");
                    //if(ing.getCompte_tva()!=null){
                    //compta[i].setCompte(ing.getCompte_tva());
                    //}else{
                    compta[i].setCompte(ConstanteStation.compteTVACollecte);
                    //}
                    //            compta[i].setDebit((montantHT-retenue) * ((this.getTva()/100)));
                    compta[i].setCredit(montantTva);
                    i++;
                }

                compta[i]=new ComptaSousEcriture();
                compta[i].setLibellePiece("Vente Client numereo "+this.getTuppleID());
                compta[i].setRemarque("Vente Client numero "+this.getId());
                compta[i].setCompte(this.getCompte());
                compta[i].setCompte_aux(this.getIdClient());
                compta[i].setDebit(montantTTC- (fraislivraison* poidsTotal)) ;
            } catch(Exception e){
                throw e;
            } finally {
                if(canClose){
                    c.close();
                }
            }
            return compta;
        }



        public VenteDetails[] getDetails(Connection c) throws Exception{
            VenteDetails[] venteDetails = null;
            try{
                String awhere = " and IDVENTE = '"+this.getId()+"'";
                venteDetails = (VenteDetails[]) CGenUtil.rechercher(new VenteDetails("VENTE_GRP_VISER"), null, null, c, awhere);
            }catch(Exception e){
                e.printStackTrace();
                throw e;
            }
            return venteDetails;
        }

        public VenteDetails[] getDetailsLib(Connection c) throws Exception{
            VenteDetails[] venteDetails = null;
            try{
                String awhere = " and IDVENTE = '"+this.getId()+"'";
                venteDetails = (VenteDetails[]) CGenUtil.rechercher(new VenteDetails("Vente_Details"), null, null, c, awhere);
            }catch(Exception e){
                e.printStackTrace();
                throw e;
            }
            return venteDetails;
        }


        public Encaissement genererEncaissement(){
            Encaissement enc = new Encaissement();
            enc.setIdOrigine(this.getId());
            enc.setDaty(utilitaire.Utilitaire.dateDuJourSql());
            enc.setDesignation("Encaissement vente du "+ this.getDaty()+ " de la facture numéro "+this.getId());
            enc.setIdTypeEncaissement(ConstanteStation.TYPE_ENCAISSEMENT_ENTREE);
            return enc;
        }

        public void genererAPartirLivraison(String[]ids, String u, Connection c)throws Exception{
            boolean canClose=false;
            try{
                if(c==null){
                    c=new UtilDB().GetConn();
                    canClose=true;
                }
                As_BondeLivraisonClient[] bls = As_BondeLivraisonClient.getAll(ids, c);
                As_BondeLivraisonClient.controlerClient(bls);

                this.setDesignation("Facturation de Bon de Livraison");
                this.setIdClient(bls[0].getIdclient());
                this.setIdMagasin(bls[0].getMagasin());
                this.setDaty(Utilitaire.dateDuJourSql());
                this.createObject(u, c);
                for(As_BondeLivraisonClient bl : bls){
                    bl.setIdvente(this.getId());
                    bl.updateToTableWithHisto(u, c);
                }
                As_BondeLivraisonClientFille blf = new As_BondeLivraisonClientFille();
                String[] somGr = {"quantite"};
                String[] gr = {"produit"};
                String[] tabvide = {};
                ResultatEtSomme rs =  CGenUtil.rechercherGroupe(blf, gr, somGr, null, null, " and numbl in "+Utilitaire.tabToString(ids, "'", ","), tabvide, "", c);
                As_BondeLivraisonClientFille[] blfs = (As_BondeLivraisonClientFille[]) rs.getResultat();
                for(As_BondeLivraisonClientFille item : blfs){
                    VenteDetails vd = item.toVenteDetails();
                    vd.setIdVente(this.getId());
                    vd.setIdDevise("AR");
                    vd.createObject(u, c);
                }
            } catch(Exception e){
                throw e;
            } finally {
                if(canClose){
                    c.close();
                }
            }
        }

    public static AvoirFC genererAvoir(String u, Connection c, String idVente) throws SQLException, Exception{
        AvoirFC avoirFC = null;
        boolean estOuvert = false;
        if(c==null){
            c = new UtilDB().GetConn();
            estOuvert = true;
            c.setAutoCommit(false);
        }
        try {

            Vente vente = Vente.getById(c, idVente);
            vente.getVenteDetailsNonGrp(c);

            int tailleFilles = vente.venteDetails.length;
            avoirFC = Vente.transformerFactureToAvoir(vente);
            avoirFC.createObject(u, c);
            AvoirFCFille[] avoirFCFilles = new AvoirFCFille[tailleFilles];
            for(int i = 0; i < tailleFilles; i++){
                avoirFCFilles[i] = Vente.transformerFactureToAvoirFille(vente.venteDetails[i]);
                avoirFCFilles[i].setIdAvoirFC(avoirFC.getId());
                avoirFCFilles[i].createObject(u, c);
            }
            avoirFC.setAvoirDetails(avoirFCFilles);
            c.commit();
        } catch (Exception e) {
            if(estOuvert) c.rollback();
            throw e ;
        } finally {
            if(estOuvert) c.close();
        }

        return avoirFC;
    }

        public static AvoirFC transformerFactureToAvoir(Vente vente){
            AvoirFC valeur = new AvoirFC();
            valeur.setDesignation(vente.getDesignation());
            valeur.setIdMagasin(vente.getIdMagasin());
            valeur.setRemarque(vente.getRemarque());
            valeur.setIdOrigine(vente.getIdOrigine());
            valeur.setIdClient(vente.getIdClient());
            valeur.setIdVente(vente.getId());
            valeur.setCompte(vente.getCompte());
            valeur.setDaty(vente.getDaty());
            valeur.setEtat(1);
            return valeur;
        }

        public static AvoirFCFille transformerFactureToAvoirFille(VenteDetails venteDetails) throws Exception{
            AvoirFCFille valeur = new AvoirFCFille();
            //        valeur.setIdAvoirFC(venteDetails.get());
            valeur.setIdProduit(venteDetails.getIdProduit());
            //valeur.setIdOrigine(venteDetails.getIdOrigine());
            valeur.setQte(1);
            valeur.setPu(0);
            valeur.setTva(0);
            valeur.setPuAchat(0);
            valeur.setPuVente(0);
            valeur.setIdDevise(venteDetails.getIdDevise());
            valeur.setTauxDeChange(1);
            valeur.setDesignation(venteDetails.getIdProduit());
            //valeur.setIdVenteDetails(venteDetails.getId());
            valeur.setEtat(11);
            return valeur;
        }

        public static Vente getById(Connection c, String id) throws Exception{
            Vente vtn = new Vente();
            try{
                vtn.setId(id);
                vtn = ((Vente[]) CGenUtil.rechercher(vtn, null, null, c, "")).length > 0 ? (Vente)((Vente[]) CGenUtil.rechercher(vtn, null, null, c, ""))[0] : null;
            }catch(Exception e){
                e.printStackTrace();
                throw e;
            }
            return vtn;
        }

        public VenteDetails [] getVenteDetailsNonGrp(Connection c) throws Exception{
            VenteDetails[] venteDetails = null;
            try{
                String awhere = " and IDVENTE = '"+this.getId()+"'";
                venteDetails = (VenteDetails[]) CGenUtil.rechercher(new VenteDetails(), null, null, c, awhere);
                this.setVenteDetails(venteDetails);
            }catch(Exception e){
                e.printStackTrace();
                throw e;
            }
            return venteDetails;
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
        public Vente[] controllerVentePaiementMultiple(String[] ids)throws Exception{
            String aWhere=Utilitaire.getAWhereIn(ids,"id");
            Vente[] ventes = (Vente[]) CGenUtil.rechercher(new Vente(), null, null, null, aWhere);
            String firstClientId = ventes[0].getIdClient();
            for (int i = 0; i < ventes.length; i++) {
                if (!ventes[i].getIdClient().equalsIgnoreCase(firstClientId))throw new Exception("Clients differents!");
                if (ventes[i].getEtat() < 11)throw new Exception("Presence de facture non visee!");
            }
            return ventes;
        }

        public String getDesignation() {
            return designation;
        }

        public void setDesignation(String designation) {
            this.designation = designation;
        }


        public static VenteLib genererVenteClient(String [] ids, Connection c) throws Exception{
            boolean estOuvert = false;
            try{
                if(c==null){
                    c = new UtilDB().GetConn();
                    estOuvert=true;
                }
                VenteLib[] liste =(VenteLib[])CGenUtil.rechercher(new VenteLib(), null, null,c," AND ID IN ("+ Utilitaire.tabToString(ids, "'", ",")+")");
                if(liste.length<=0){
                    return null;
                }
                String idClient = liste[0].getIdClient();
                double montant = liste[0].getMontantreste();
                for (int i = 1; i < liste.length; i++) {
                    if(liste[i].getIdClient().compareToIgnoreCase(idClient)!=0){
                        throw new Exception("Client different pour ces ventes");
                    }
                    montant += liste[i].getMontantreste();
                }
                liste[0].setMontantreste(montant);
                return liste[0];
            } catch (Exception e) {
                throw e;
            } finally {
                if(estOuvert)c.close();
            }
        }
        public static LiaisonPaiement genererPaiementFactureParAvoir(String u, Connection c, String idVente) throws SQLException, Exception{
            LiaisonPaiement pFacture = null;
            boolean estOuvert = false;
            if(c==null){
                c = new UtilDB().GetConn();
                estOuvert = true;
                c.setAutoCommit(false);
            }
            try {

                Vente vente = Vente.getById(c, idVente);
                AvoirFCLib t = new AvoirFCLib();
                t.setNomTable("AVOIRFCLIB_CPL");
                AvoirFCLib[] details = (AvoirFCLib[]) CGenUtil.rechercher(t,null,null,c," AND idClient='"+vente.getIdClient()+"' order by id asc");
                StringBuilder sb = new StringBuilder();
                if(details.length>0){
                    for(int i=0;i<details.length;i++){
                        if (i > 0) sb.append(";");
                        sb.append(details[i].getId());
                    }
                }
                double montantTotalReste = AdminGen.calculSommeDouble(details,"resteapayerar");
                pFacture = new LiaisonPaiement();
                pFacture.setId2(idVente);
                //pFacture.setId1(sb.toString());
                //pFacture.setDaty(vente.getDaty());
                pFacture.setMontant(montantTotalReste);
                c.commit();
            } catch (Exception e) {
                if(estOuvert) c.rollback();
                throw e ;
            } finally {
                if(estOuvert) c.close();
            }

            return pFacture;
        }

        public double getEcheancefacture() {
            return echeancefacture;
        }

        public void setEcheancefacture(double echeancefacture) {
            this.echeancefacture = echeancefacture;
        }
        public static MvtCaisse genererPaiementFacture(String[] ids,Connection c) throws Exception{
            System.out.println("ids = "+ids.length);
            String requete = null;
            boolean ifconnnull = false;
            MvtCaisse mvt = new MvtCaisse();
            try {
                if (c == null) {
                    c = new UtilDB().GetConn();
                    ifconnnull = true;
                    VenteLib ff = new VenteLib();
                    ff.setNomTable("VENTE_CPL");
                    requete = "SELECT * FROM " + ff.getNomTable() + " WHERE id IN (";
                    requete += Utilitaire.tabToString(ids, "'", ",") + ")";
                    System.out.println(requete);
                    VenteLib[] liste = (VenteLib[]) CGenUtil.rechercher(ff, requete, c);
                    Set<String> clients = new HashSet<>();
                    for (VenteLib v : liste) {
                        clients.add(v.getIdClient());
                    }
                    if (clients.size() > 1) {
                        throw new Exception("Client different pour ces ventes !");
                    }

                    double montantTotal = AdminGen.calculSommeDouble(liste,"montantreste");
                    mvt.setIdOrigine(String.join(";;", ids));
                    mvt.setCredit(montantTotal);
                    mvt.setIdDevise("Ar");
                    mvt.setIdTiers(liste[0].getIdClient());
                    mvt.setDesignation("Paiement facture  par "+liste[0].getIdClientLib());
                }
            } catch (Exception x) {
                x.printStackTrace();
                throw x;
            } finally {
                if (ifconnnull && c != null) {
                    c.close();
                }
            }
            return mvt;
        }

        public Vente reglerReleverCredit(String u, Connection c, String[] ids) throws Exception{
            boolean canClose=false;
            try {
                if (c == null) {
                    c = new UtilDB().GetConn();
                    canClose = true;
                    c.setAutoCommit(false);
                }
                Vente facture = (Vente) super.createObject(u,c);
                VenteDetails[] filles = (VenteDetails[]) facture.getFille();
                double montant = 0;
                for (VenteDetails fille : filles ) {
                    //fille.createObject(u,c);
                    fille.validerObject(u,c);
                    montant += fille.getPu() * fille.getQte();
                }
                facture.validerObject(u,c);

                MvtCaisse mvt = new MvtCaisse();
                mvt.setIdCaisse(facture.getReferencefact());
                mvt.setDesignation("Paiement de la facture de règlement : "+facture.getId());
                mvt.setIdTiers(facture.getIdClient());
                mvt.setDaty(facture.getDaty());
                mvt.setIdOrigine(facture.getId());
                mvt.setCredit(montant);
                mvt.setDebit(0);
                MvtCaisse val = (MvtCaisse) mvt.createObject(u,c);
                mvt.validerObject(u,c);

                ComptaEcriture ce = new ComptaEcriture();
                ce.setIdobjet(val.getId());
                ComptaEcriture[] ecriture = (ComptaEcriture[]) CGenUtil.rechercher(ce,null,null,c,"");
                System.err.println("==============================================IDS"+ids.length);
                System.err.println("==============================================ecriture"+ecriture.length);
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

        public String getIdzoneclient() {
            return idzoneclient;
        }

        public void setIdzoneclient(String idzoneclient) {
            this.idzoneclient = idzoneclient;
        }

        private VenteDetails genererFraisTransport(String u, Connection c) throws  Exception {
//            double fraisLivraison = ForfaitZoneClient.calculerFraisTransport(this.getTypefraistransport(), this.getIdzoneclient(), this.getQteCarton(c), c);
//            // mannuelle debut
//            double fraisLivraison = this.getMontantLivraison();
//            if (fraisLivraison > 0&& contienDejaLivraison()==false) {
////                setFraislivraison(fraisLivraison);
//                VenteDetails fraisLivraisonFille = genererFraisTransportDetails(fraisLivraison, c);
//                fraisLivraisonFille.setIdVente(this.getId());
//                return (VenteDetails) fraisLivraisonFille.createObject(u, c);
//            }
//            // mannuelle fin

            // automatique debut
            if(this.getTypefraistransport()==1){
                //VenteDetails [] fille = (VenteDetails []) this.getFille("Vente_Details",c,"");
                VenteDetails [] fille = (VenteDetails []) CGenUtil.rechercher(new VenteDetails(), null,null,c, "AND IDVENTE='"+this.getId()+"'");
                deleteFrais(c,fille);
                VenteDetails [] fille2 = (VenteDetails []) CGenUtil.rechercher(new VenteDetails(), null,null,c, "AND IDVENTE='"+this.getId()+"'");
                ZoneClient zcl = (ZoneClient) new ZoneClient().getById(this.getIdzoneclient(),"ZONECLIENT",c);
                double fraisLivraison = zcl.calculerFraisLivraison(getNbCarton(c,fille2))+this.getMontantLivraison();
                if (fraisLivraison > 0) {
                    //setFraislivraison(fraisLivraison);
                    VenteDetails fraisLivraisonFille = genererFraisTransportDetails(fille2[0],fraisLivraison, c);
                    fraisLivraisonFille.setIdVente(this.getId());
                    return (VenteDetails) fraisLivraisonFille.createObject(u, c);
                }
            }
            // automatique fin
            return null;
        }
        public boolean contienDejaLivraison()throws Exception {
            VenteDetails[] fille=(VenteDetails[]) this.getFille();
            for(VenteDetails f : fille) {
                if(f.getIdProduit().compareToIgnoreCase(ConstanteVente.idFraisLivraons)==0) return true;
            }
            return false;
        }

        public VenteDetails genererFraisTransportDetails(VenteDetails vd, double frais, Connection c) throws Exception {
            Client client = getClient(c);
            Ingredients ing = (Ingredients) new Ingredients().getById(ConstanteSavonnerie.ING_FRAIS_LIVRAISON, "AS_INGREDIENTS", c);
            if(ing==null){
                throw new Exception("Produit frais de livraison n'existe pas!");
            }
            VenteDetails fraisLivraisonFille = new VenteDetails();
            fraisLivraisonFille.setQte(1);
            fraisLivraisonFille.setTauxDeChange(vd.getTauxDeChange());
            fraisLivraisonFille.setPu(frais/vd.getTauxDeChange());
            fraisLivraisonFille.setUnite(ConstanteSavonnerie.ID_UNITE_SIMPLE);
            fraisLivraisonFille.setTva(ing.getTva());
            fraisLivraisonFille.setIdProduit(ing.getId());
            fraisLivraisonFille.setDesignation("Frais de transport");
            fraisLivraisonFille.setIdDevise(ConstanteSavonnerie.ID_DEVISE_AR);
            fraisLivraisonFille.setCompte(ing.getCompte_vente());
            return fraisLivraisonFille;
        }

        public double getQteCarton(Connection c) throws Exception {
            VenteDetails[] details = (VenteDetails[]) this.getFille();
            double qteCartonTotal = 0;
            for (VenteDetails detail : details) {
                double qteCarton = detail.getQteCarton(c);
                double qtePieceRestant = detail.getQtePieceRestant(c);
                if (qtePieceRestant > 0) {
                    qteCarton += 1;
                }
                qteCartonTotal += qteCarton;
            }
            return qteCartonTotal;
        }

        public Prevision[] genererPrevision(String u, Connection c) throws Exception{
            VenteDetails[] fille = (VenteDetails[]) this.getFille("Vente_Details", c, "");
            List<Prevision> previsions = new ArrayList<>();


            for(VenteDetails f : fille)
            {
                Prevision prev = f.genererPrevision();
                prev.setDaty(this.getDatyPrevu());
                prev.setIdTiers(this.getIdClient());
                Prevision newPrev = (Prevision) prev.createObject(u, c);
                previsions.add(newPrev);
                System.out.println("Prevision created: " + newPrev.getId());

            }

            return previsions.toArray(new Prevision[previsions.size()]);

        }

        public Prevision[] genererPrevisionPrevu(String u, Connection c) throws Exception {
            VenteDetails[] details = (VenteDetails[]) getFille("VENTE_DETAILS",c,"");
            Prevision[] previsions = new Prevision[details.length];
            for (int i = 0; i < details.length; i++) {
                previsions[i] = details[i].genererPrevisionPrevu(u, c);
            }
            return  previsions;
        }

        public String genererBonLivraisonAvecMvtStock(String u,Connection c) throws Exception{
            try{
                VenteDetailsLib vLib = new VenteDetailsLib();
                vLib.setNomTable("VENTE_DETAILS_RESTE");
                VenteDetailsLib[] details = (VenteDetailsLib[]) CGenUtil.rechercher(vLib,null,null,c," AND idVente='"+this.getId()+"' AND reste > 0");

                if(details.length > 0){
                    As_BondeLivraisonClient client = new As_BondeLivraisonClient();
                    client.setMode("modif");
                    client.setIdvente(this.getId());
                    client.setMagasin(this.getIdMagasin());
                    client.setEtat(1);
                    client.setIdclient(this.getIdClient());
                    client.setRemarque("Livraison de la facture numero "+this.getId());
                    client.setDaty(Utilitaire.dateDuJourSql());
                    client.createObject(u, c);
                    client.setEtat(11);
                    client.updateToTableWithHisto(u,c);
                    for(VenteDetailsLib detail:details){
                        As_BondeLivraisonClientFille clientFille = new As_BondeLivraisonClientFille();
                        clientFille.setMode("modif");
                        clientFille.setProduit(detail.getIdProduit());
                        clientFille.setUnite(detail.getIdUnite());
                        clientFille.setQuantite(detail.getReste());
                        clientFille.setIdventedetail(detail.getId());
                        clientFille.setNumbl(client.getId());
                        clientFille.createObject(u, c);
                    }
                    MvtStock mvt = client.genererMvtStock(c);
                    mvt = (MvtStock) mvt.createObject(u,c);
                    mvt.validerObject(u,c);
                    return client.getId();
                }
                throw new Exception("Plus aucun article à livrer");
            }
            catch(Exception e){
                throw e;
            }
        }

        protected MvtStock createMvtStockVenteDirecte() throws Exception {
            MvtStock md = new MvtStock();
            md.setDaty(this.getDaty());
            md.setDesignation("Vente directe Num : " + this.getId() );
            md.setIdTypeMvStock(ConstanteStation.TYPEMVTSTOCKSORTIE);
            md.setIdMagasin(this.getIdMagasin());
            md.setIdVente(this.getId());
            md.setIdobjet(this.getId());
            return md;
        }

        public static String enregistrerViserLivrer(UserEJB u, PageInsertMultiple p, String nomtable, String colonneMere, String modePaiement, String reference) throws Exception {
            Connection c = null;
            try {
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);

                ClassMAPTable cmere = p.getObjectAvecValeur();
                VenteDetails[] cfille = (VenteDetails[]) p.getObjectFilleAvecValeur();
                Vente mere = ((Vente) cmere);

                // --- CORRECTION : Attacher les filles ---
                mere.setFille(cfille);

                if (mere.getIdMagasin() == null || mere.getIdMagasin().isEmpty()) {
                    mere.setIdMagasin(ConstanteAsync.MAGAGIN);
                }
                mere.setDaty(Utilitaire.dateDuJourSql());

                mere.createObject("" + u.getUser().getRefuser(), c);
                u.createObjectMultiple(cfille, colonneMere, mere.getTuppleID(), c);

                mere.validerObject("" + u.getUser().getRefuser(), c);
                mere.genererBonLivraisonAvecMvtStock("" + u.getUser().getRefuser(), c);

                c.commit();
                return mere.getId();
            } catch (Exception e) {
                if (c != null) c.rollback();
                throw e;
            } finally {
                if (c != null) c.close();
            }
        }

        public VenteDetails creerAPpoint(double montant) throws Exception {
            VenteDetails venteDetails = new VenteDetails();
            venteDetails.setIdProduit("APP");
            venteDetails.setQte(1);
            venteDetails.setPu(montant);
            venteDetails.setTva(0);
            venteDetails.setIdVente(this.getId());
            return venteDetails;
        }

        public static synchronized String enregistrerViserLivrerEncaisser(UserEJB u, PageInsertMultiple p, String nomtable, String colonneMere, String modePaiement, String reference, String[] estEnGrosListe, String aretourner, double montantPaye) throws Exception {
            Connection c = null;
            try {
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);

                Vente mere = (Vente) p.getObjectAvecValeur();
                VenteDetails[] cfilleArray = (VenteDetails[]) p.getObjectFilleAvecValeur();

                if (cfilleArray == null || cfilleArray.length == 0) throw new Exception("La liste des produits est vide.");

                // 1. Initialisation de la mère
                if (mere.getIdMagasin() == null || mere.getIdMagasin().isEmpty()) {
                    mere.setIdMagasin(u.getPointEncours() != null ? u.getPointEncours().getId() : "MAGAPPRO1");
                }
                mere.setDaty(Utilitaire.dateDuJourSql());
                mere.setEtat(11);

                // 2. Préparation et calcul des lignes (Détails)
                // Utilisation d'une liste pour pouvoir ajouter l'appoint si besoin
                //List<VenteDetails> totalDetails = new ArrayList<>();

                //for (int j = 0; j < cfilleArray.length; j++) {
                //    VenteDetails detail = cfilleArray[j];
                //    detail.setNomTable(nomtable);
                //    detail.setId(null);

                    // Ty mila modifiena
                //    Ingredients ing = detail.getIngredientPrixGMS();
                    //boolean isGros = (estEnGrosListe != null && j < estEnGrosListe.length && "1".equals(estEnGrosListe[j]));

                    //if (ing.getUnite() != null && ing.getUnite().equalsIgnoreCase("UNT00004")) {
                    //    detail.setQte(detail.getQte() / 1000.0);
                    //    detail.setPu(isGros ? ing.getPvgros() : ing.getPv());
                    //} else {
                    //    detail.setPu(ing.getPv());
                    //}
                //    detail.calculerRevient(c);
                //    totalDetails.add(detail);
                //}

                // 3. Gestion de l'appoint (Ajout à la liste au lieu d'une insertion séparée)

//                if (Math.abs(appoint) > 0.1) {
//                    VenteDetails app = mere.creerAPpoint(appoint);
//                    app.setNomTable(nomtable);
//                    totalDetails.add(app); // On ajoute simplement l'appoint à la liste
//                }
                //VenteDetails[] details = totalDetails.toArray(new VenteDetails[0]);
                // 4. INSERTION UNIQUE : Mère puis TOUS les détails d'un coup
                //mere.setFille(details);
                mere.setFille(cfilleArray);
                mere.createObject("" + u.getUser().getRefuser(), c);
                //u.createObjectMultiple(details, colonneMere, mere.getId(), c);
                VenteLib vt = (VenteLib)new VenteLib().getById(mere.getTuppleID(),"VENTE_CPL",c);
                double montantTTC = vt.getMontantTtcAr();
                double montantArrondi =Utilitaire.arrondir(montantTTC / 100.0, 0) * 100.0;
                double appoint = montantArrondi - montantTTC;
                if (appoint != 0) mere.creerAPpoint(appoint).createObject(""+u.getUser().getRefuser(),c);

                // 5. Sortie de Stock
                MvtStock mvtStockMere = mere.createMvtStockVenteDirecte();
                mvtStockMere.setDaty(mere.getDaty());
                mvtStockMere.setEtat(11);
                mvtStockMere.setIdVente(mere.getId());
                mvtStockMere.createObject(String.valueOf(u.getUser().getRefuser()), c);

                List<MvtStockFille> mvtStockFilles = new ArrayList<>();
                //for (VenteDetails line : totalDetails) {
                for (VenteDetails line : cfilleArray) {
                    if(line.getIdProduit().equals("APP")) continue; // Ne pas sortir de stock pour l'appoint
                    MvtStockFille mvtFille = new MvtStockFille();
                    mvtFille.setIdProduit(line.getIdProduit());
                    mvtFille.setSortie(line.getQte());
                    mvtFille.setIdMvtStock(mvtStockMere.getId());
                    mvtFille.setPu(line.getPu());
                    mvtFille.setMontant(line.getQte() * line.getPu());
                    mvtFille.setDesignation("Sortie directe POS");
                    mvtStockFilles.add(mvtFille);
                }
                u.createObjectMultiple(mvtStockFilles.toArray(new MvtStockFille[0]), "idMvtStock", mvtStockMere.getId(), c);

                // 6. Comptabilité
                try { mere.genererEcriture("" + u.getUser().getRefuser(), c); } catch (Exception e) {}

                // 7. Encaissement
                mere.genererEncaissementVente(modePaiement, reference, u, c, estEnGrosListe, aretourner);

                c.commit();
                return mere.getId();

            } catch (Exception e) {
                if (c != null) c.rollback();
                throw e;
            } finally {
                if (c != null) c.close();
            }
        }

        public void genererEncaissementVente(String modePaiement, String reference, UserEJB u, Connection c, String[] estEnGrosListe, String aretourner) throws Exception {
            MvtCaisse mvt = new MvtCaisse();
            VenteDetails vd = new VenteDetails();
            vd.setIdVente(this.getId());
            VenteDetails[] res = (VenteDetails[]) CGenUtil.rechercher(vd, null, null, c, "");
            VenteLib vt = (VenteLib)new VenteLib().getById(this.getId(),"VENTE_CPL",c);
            double montantTotal = vt.getMontantTtcAr();
            // Sélection de la caisse (Utilisez des IDs valides de votre base)
            String idCaisse = "CAIS001";
            String idPoint = (u.getPointEncours() != null) ? u.getPointEncours().getId() : "PNT000084";

            if (modePaiement != null) {
                if (modePaiement.equalsIgnoreCase("virement") || modePaiement.equalsIgnoreCase("mvola")) {
                    idCaisse = getCaisseMvola(c, idPoint);
                } else if (modePaiement.equalsIgnoreCase("cheque")) {
                    idCaisse = getCaisseCheque(c, idPoint);
                } else {
                    idCaisse = (u.getCaisseEspeceDefaut() != null) ? u.getCaisseEspeceDefaut().getId() : "CAIS001";
                }
            }

            mvt.setIdCaisse(idCaisse);
            mvt.setReference(reference);
            mvt.setDaty(this.getDaty());
            mvt.setCredit(montantTotal);
            mvt.setIdOrigine(this.getId());
            mvt.setDesignation("Encaissement POS N°: " + this.getId());
            mvt.setIdTiers(this.getIdClient());
            mvt.setMontantRetourner(Utilitaire.stringToDouble(aretourner));
            mvt.setIdCaissier(u.getUser().getTuppleID());

            System.out.println("Paiement vita ah " + mvt.getId());
            MvtCaisse mvtC = (MvtCaisse) mvt.createObject(u.getUser().getTuppleID(), c);
            mvtC.validerObject(u.getUser().getTuppleID(),c);
        }

        public static String getCaisseMvola(Connection c, String idPoint)throws Exception {
            Caisse crt=new Caisse();
            crt.setIdPoint(idPoint);
            crt.setIdCategorieCaisse(ConstanteAsync.caisseCategMvola);
            Caisse[] listeCaisse=(Caisse[]) CGenUtil.rechercher(crt, null, null, c, " ");

            if(listeCaisse!=null&&listeCaisse.length>0){
                return listeCaisse[0].getId();
            }
            else{
                return ConstanteAsync.CAISSE_MVOLA;
            }
        }

        public static String getCaisseOrange(Connection c, String idPoint)throws Exception {
            Caisse crt=new Caisse();
            crt.setIdPoint(idPoint);
            crt.setIdCategorieCaisse(ConstanteAsync.caisseCategOrange);
            Caisse[] listeCaisse=(Caisse[]) CGenUtil.rechercher(crt, null, null, c, " ");

            if(listeCaisse!=null&&listeCaisse.length>0){
                return listeCaisse[0].getId();
            }
            else{
                return ConstanteAsync.CAISSE_ORANGE;
            }
        }

        public static String getCaisseAirtel(Connection c, String idPoint)throws Exception {
            Caisse crt=new Caisse();
            crt.setIdPoint(idPoint);
            crt.setIdCategorieCaisse(ConstanteAsync.caisseCategAirtel);
            Caisse[] listeCaisse=(Caisse[]) CGenUtil.rechercher(crt, null, null, c, " ");

            if(listeCaisse!=null&&listeCaisse.length>0){
                return listeCaisse[0].getId();
            }
            else{
                return ConstanteAsync.CAISSE_AIRTEL;
            }
        }

        public static String getCaisseTpe(Connection c, String idPoint)throws Exception {
            Caisse crt=new Caisse();
            crt.setIdPoint(idPoint);
            crt.setIdCategorieCaisse(ConstanteAsync.caisseCategTpe);
            Caisse[] listeCaisse=(Caisse[]) CGenUtil.rechercher(crt, null, null, c, " ");

            if(listeCaisse!=null&&listeCaisse.length>0){
                return listeCaisse[0].getId();
            }
            else{
                return ConstanteAsync.CAISSE_TPE;
            }
        }

        public static String getCaisseCheque(Connection c, String idPoint)throws Exception {
            Caisse crt=new Caisse();
            crt.setIdPoint(idPoint);
            crt.setIdCategorieCaisse(ConstanteAsync.caisseCategCheque);
            Caisse[] listeCaisse=(Caisse[]) CGenUtil.rechercher(crt, null, null, c, " ");

            if(listeCaisse!=null&&listeCaisse.length>0){
                return listeCaisse[0].getId();
            }
            else{
                return ConstanteAsync.CAISSE_CHEQUE;
            }
        }


        public static String enregistrerViserLivrerEncaisserMultiple(UserEJB u, PageInsertMultiple p, String nomtable, String colonneMere, Map<String, PaiementInfo> paiements, String[] estEnGrosListe, String aretourner, double montantPaye) throws Exception {
            Connection c = null;
            try {
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);

                // 1. Vérification de l'utilisateur
                if (u == null || u.getUser() == null) {
                    throw new Exception("Session utilisateur invalide ou expirée.");
                }

                Vente mere = (Vente) p.getObjectAvecValeur();
                VenteDetails[] cfille = (VenteDetails[]) p.getObjectFilleAvecValeur();

                if (cfille == null || cfille.length == 0) {
                    throw new Exception("La liste des produits ne peut pas être vide.");
                }

                mere.setFille(cfille);

                // 2. Détermination du point de vente et magasin
                String idPoint = (u.getPointEncours() != null) ? u.getPointEncours().getId() : "MAGAPPRO1"; // Valeur par défaut si null
                if (mere.getIdMagasin() == null || mere.getIdMagasin().isEmpty()) {
                    mere.setIdMagasin(idPoint);
                }

                mere.setDaty(Utilitaire.dateDuJourSql());
                mere.setIdModePaiement(ConstanteAsync.PAIEMENT_MULTIPLE);
                mere.setMontantDonne(montantPaye);

                // 3. Création de la facture (Mère)
                mere.createObject("" + u.getUser().getRefuser(), c);
                VenteLib vt = (VenteLib)new VenteLib().getById(mere.getTuppleID(),"VENTE_CPL",c);
                double montantTTC = vt.getMontantTtcAr();
                double montantArrondi =Utilitaire.arrondir(montantTTC / 100.0, 0) * 100.0;
                double appoint = montantArrondi - montantTTC;
                if (appoint != 0) mere.creerAPpoint(appoint).createObject(""+u.getUser().getRefuser(),c);

//                // 4. Création des détails (Filles)
//                for (VenteDetails detail : cfille) {
//                    detail.setIdVente(mere.getId());
//                    detail.createObject("" + u.getUser().getRefuser(), c);
//                }

                // 5. Validation de la facture
                mere.setEtat(11);
                mere.updateToTableWithHisto("" + u.getUser().getRefuser(), c);

                // 6. Gestion des encaissements multiples
                if (paiements == null || paiements.isEmpty()) {
                    throw new Exception("Aucun mode de paiement sélectionné.");
                }
                MvtStock mvtStockMere = mere.createMvtStockVenteDirecte();
                mvtStockMere.setDaty(mere.getDaty());
                mvtStockMere.setEtat(11);
                mvtStockMere.setIdVente(mere.getId());
                mvtStockMere.createObject(String.valueOf(u.getUser().getRefuser()), c);
                List<MvtStockFille> mvtStockFilles = new ArrayList<>();
                for (VenteDetails line : cfille) {
                    MvtStockFille mvtFille = new MvtStockFille();
                    mvtFille.setIdProduit(line.getIdProduit());
                    mvtFille.setSortie(line.getQte());
                    mvtFille.setIdMvtStock(mvtStockMere.getId());
                    mvtFille.setPu(line.getPu());
                    mvtFille.setMontant(line.getQte() * line.getPu());
                    mvtFille.setDesignation("Sortie directe POS");
                    mvtStockFilles.add(mvtFille);
                }
                u.createObjectMultiple(mvtStockFilles.toArray(new MvtStockFille[0]), "idMvtStock", mvtStockMere.getId(), c);
                String userRef = String.valueOf(u.getUser().getRefuser());
                idPoint = (u.getPointEncours() != null) ? u.getPointEncours().getId() : "PNT000084";
                for (Map.Entry<String, PaiementInfo> entry : paiements.entrySet()) {
                    String mode = entry.getKey();
                    PaiementInfo pi = entry.getValue();
                    String targetCaisse = "";

                    if (mode.equalsIgnoreCase("especes")) {
                        if (u.getCaisseEspeceDefaut() != null) {
                            targetCaisse = u.getCaisseEspeceDefaut().getId();
                        } else {
                            targetCaisse = "CAIS001";
                        }
                    }
                    else if (mode.equalsIgnoreCase("virement") || mode.equalsIgnoreCase("tpe")) {
                        targetCaisse = getCaisseTpe(c, idPoint);
                    }
                    else if (mode.equalsIgnoreCase("mvola")) {
                        targetCaisse = getCaisseMvola(c, idPoint);
                    }
                    else if (mode.equalsIgnoreCase("airtel") ) {
                        targetCaisse = getCaisseAirtel(c, idPoint);
                    }
                    else if (mode.equalsIgnoreCase("orange")) {
                        targetCaisse = getCaisseOrange(c, idPoint);
                    }
                    else {
                        targetCaisse = getCaisseCheque(c, idPoint);
                    }

                    mere.genererEncaissementMultiple(targetCaisse, pi.getReference(), userRef, c, pi.getMontant(), aretourner);
                }

                c.commit();
                return mere.getId();
            } catch (Exception e) {
                if (c != null) c.rollback();
                e.printStackTrace();
                throw e;
            } finally {
                if (c != null) c.close();
            }
        }

        private File genererCodeBarreWithName(String id, String chemin, String nomPersonne, String u) throws Exception {
            File fichier = new File(chemin);

            File parentDir = fichier.getParentFile();
            if (parentDir != null && !parentDir.exists() && !parentDir.mkdirs()) {
                parentDir = new File("/tmp/vente");
                parentDir.mkdirs();
                fichier = new File(parentDir, fichier.getName());
                System.out.println("➡ Fichier redirigé vers : " + fichier.getAbsolutePath());
            }

            if (fichier.exists()) {
                System.out.println("ℹ Code-barre déjà généré : " + fichier.getAbsolutePath());
                return fichier;
            }

            ConstanteAsync.CODE128_BEAN.setFontSize(0);

            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            BitmapCanvasProvider canvas = new BitmapCanvasProvider(
                    baos, "image/png", ConstanteAsync.DPI, BufferedImage.TYPE_BYTE_BINARY, false, 0);
            ConstanteAsync.CODE128_BEAN.generateBarcode(canvas, id);
            canvas.finish();

            BufferedImage barcodeImage = ImageIO.read(new ByteArrayInputStream(baos.toByteArray()));

            int extraHeight = 30;
            BufferedImage combined = new BufferedImage(
                    barcodeImage.getWidth(), barcodeImage.getHeight() + extraHeight,
                    BufferedImage.TYPE_INT_RGB);

            Graphics2D g = combined.createGraphics();

            g.setColor(Color.WHITE);
            g.fillRect(0, 0, combined.getWidth(), combined.getHeight());

            g.setColor(Color.BLACK);
            g.setFont(new Font("Arial", Font.BOLD, 14));

            FontMetrics fm = g.getFontMetrics();
            int textWidth = fm.stringWidth(nomPersonne);
            int x = (combined.getWidth() - textWidth) / 2;
            int y = fm.getAscent() + 5;
            g.drawString(nomPersonne, x, y);

            g.drawImage(barcodeImage, 0, extraHeight, null);

            g.dispose();
//        System.out.println("avant updateeeee ");
//
            ImageIO.write(combined, "png", fichier);
//        System.out.println("avant updateeeee 2222 ");
//        Ingredients ing = (Ingredients) new Ingredients().getById(this.getId(), "AS_INGREDIENTS", null);
//        System.out.println(" andeha hanao updateeeee ");
//        ing.setCodeBarre(nomPersonne);
//
//        ing.updateToTableWithHisto(u);

            return fichier;
        }


        public void genererEncaissementMultiple(String idCaisse, String reference, String u, Connection c, double montant, String aretourner) throws Exception {
            try {
                if(c == null) {
                    c = new UtilDB().GetConn();
                }

                MvtCaisse mvt = new MvtCaisse();
                mvt.setReference(reference);
                mvt.setIdCaisse(idCaisse);
                mvt.setDaty(this.getDaty());
                mvt.setCredit(montant);
                mvt.setIdOrigine(this.getId());
                mvt.setDesignation("Encaissement multiple de la facture Num : " + this.getId());
                mvt.setTaux(1);
                mvt.setIdDevise("AR");
                mvt.setIdTiers(this.getIdClient());
                mvt.setCompte(ConstanteAsync.COMPTE_REGROUPEMENT);
                mvt.setIdCaissier(u);
                mvt.setMontantRetourner(Double.parseDouble(aretourner));
                mvt.createObject(u, c);
                mvt.validerObject(u, c);

            } catch (Exception e) {
                e.printStackTrace();
                throw e;
            }
        }


        /*public void genererEncaissementVente(String modePaiement,String reference, UserEJB u, Connection c) throws Exception {
            genererEncaissementVente(modePaiement, reference, u, c, null);
        }*/

        public String livrerSortieStock(UserEJB u,String id)throws Exception{
            Connection c = null;
            try {
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
                Vente mere = new Vente();
                mere = (Vente) this.getById(this.getId(),null,c);
                String idBL = mere.genererBonLivraisonAvecMvtStock(""+u.getUser().getRefuser(),c);
                c.commit();
                return mere.getId();
            } catch (Exception e) {
                e.printStackTrace();
                c.rollback();
                throw e;
            }finally {
                if (c != null) {
                    c.close();
                }
            }
        }


        public static double arrondir(double nombre) {
            return Math.round(nombre / 100.0) * 100.0;
        }

        public As_BondeLivraisonClient genererBondeLivraisonDirecte(String u, Connection c) throws Exception
        {
            As_BondeLivraisonClient blc = new As_BondeLivraisonClient();
            blc.setDaty(Utilitaire.dateDuJourSql());
            blc.setIdvente(this.getId());
            blc.setEtat(ConstanteEtat.getEtatValider());
            blc.setMagasin(this.getIdMagasin());
            blc.setIdclient(this.getIdClient());
            blc.setRemarque("Livraison vente directe");
            blc = (As_BondeLivraisonClient) blc.createObject(u, c);
            String numbl = blc.getId();
            As_BondeLivraisonClientFille[] blcf = new As_BondeLivraisonClientFille[this.getFille().length];
            for (int i = 0; i < this.getFille().length; i++) {
                VenteDetails vt = (VenteDetails) this.getFille()[i];
                blcf[i] = new As_BondeLivraisonClientFille();
                blcf[i].setNumbl(numbl);
                blcf[i].setProduit(vt.getIdProduit());
                blcf[i].setIdventedetail(vt.getId());
                blcf[i].setQuantite(vt.getQte());
                blcf[i].setUnite(vt.getUnite());
                blcf[i] = (As_BondeLivraisonClientFille) blcf[i].createObject(u, c);
            }
            blc.setFille(blcf);
            return blc;
        }

        public int updateObject(String u,Connection c)throws Exception
        {
            this.getFille(null,c,"");
            genererFraisTransport(u, c);
            return super.updateObject(u, c);
        }

        public AvoirFC genereAvoirReste() throws Exception {
            AvoirFC avoirAVnt = new AvoirFC();

            avoirAVnt.setDesignation("Retour vente");
            avoirAVnt.setIdMagasin(this.getIdMagasin());
            avoirAVnt.setDaty(this.getDaty());
            avoirAVnt.setIdOrigine(this.getIdOrigine());
            avoirAVnt.setIdVente(this.getId());
            avoirAVnt.setIdClient(this.getIdClient());
            avoirAVnt.setIdMotif(ConstanteSavonnerie.ID_MTF_AVOIR_RET);
            avoirAVnt.setIdtypeavoir(ConstanteSavonnerie.ID_TYPE_AVOIR);

            VenteDetails[] details = (VenteDetails[]) this.getFille();

            AvoirFCFille[] avoirFCFilles = new AvoirFCFille[details.length];
            for (int j = 0; j < details.length; j++) {
                VenteDetails ancienDetail = details[j];
                avoirFCFilles[j] = ancienDetail.genereAvoirReste();
            }

            avoirAVnt.setFille(avoirFCFilles);

            return avoirAVnt;
        }

        public void echanger(String u, Connection c) throws Exception {

            if (this.getFactureEchange() == null || this.getFactureEchange().isEmpty()) {
                return;
            }

            LiaisonPaiement[] paiements = (LiaisonPaiement[]) CGenUtil.rechercher(new LiaisonPaiement(), null, null, c, " AND id2='" + this.getFactureEchange() + "'");
            for (int j = 0; j < paiements.length; j++) {
                LiaisonPaiement paiement = paiements[j];
                paiement.setId2(this.getId());
                paiement.updateToTableWithHisto(u,c);
            }


            AvoirFC[] avoirs = (AvoirFC[]) CGenUtil.rechercher(new AvoirFC(), null, null, c, " AND idVente ='" + this.getFactureEchange() + "'");
            for (int j = 0; j < avoirs.length; j++) {
                AvoirFC avoir = avoirs[j];
                avoir.setIdVente(this.getId());
                avoir.setIdOrigine(this.getId());
                avoir.updateToTableWithHisto(u,c);
            }


            Vente ancienVente = getAncien(c);
            AvoirFC avoirReste = ancienVente.genereAvoirReste();
            avoirReste.createObject(u, c);
            avoirReste.validerObject(u, c);
//        avoirReste.sortieStock(u, c);

            MvtStock mvtStock = avoirReste.genereEntre(ancienVente);
            mvtStock.createObject(u, c);
            mvtStock.validerObject(u, c);

        }

        @Override
        public ClassMAPTable createObject(String u, Connection c) throws Exception {
            // NumeroFacture[] numFact = (NumeroFacture[]) CGenUtil.rechercher(new NumeroFacture(), null, null, c, "");
            // this.setNumerofacture(numFact[0].getProchain_num_format());


            VenteDetails[] listeFille = (VenteDetails[]) this.getFille();
            Set<String> seen = new HashSet<>();
            boolean nonConformeBC = false;
            BonDeCommande bc = null;
            BonDeCommandeFille[] bcFille = null;

            if (this.getIdOrigine() != null && !this.getIdOrigine().isEmpty()) {
                bc = this.getBc(c);
                bcFille = (BonDeCommandeFille[])CGenUtil.rechercher(new BonDeCommandeFille(), null, null, c, " and idbc = '"+bc.getId()+"'");
                if (bcFille.length != this.getFille().length) {
                    nonConformeBC = true;
                }
            }

            Map<String, BonDeCommandeFille> bcFilleParId = new HashMap<>();
            if (bcFille != null) {
                for (BonDeCommandeFille f : bcFille) {
                    bcFilleParId.put(f.getId(), f);
                }
            }
            for (VenteDetails vd : listeFille) {
                String key = vd.getIdProduit();
                String designation = vd.getDesignation();

                if (key == null || key.trim().isEmpty()) continue;
                if (nonConformeBC == false && this.getIdOrigine() != null && !this.getIdOrigine().isEmpty()) {
                    //BonDeCommandeFille bdf = ((BonDeCommandeFille)AdminGen.findUnique(bcFille, new String[]{"id"}, new String[]{vd.getIdbcfille()}));
                    BonDeCommandeFille bdf = bcFilleParId.get(vd.getIdbcfille());
                    if (bdf.getQuantite() != vd.getQte()){
                        nonConformeBC = true;
                    }
                }
//                if (!seen.add(key)) {
//                    throw new Exception("Doublon pour l'article : " + designation);
//                }
            }
            //CheckEtatStockVenteDetailsALaCreation(c);
            this.checkEtatStockGroupe(null,c);
            if (nonConformeBC == true){
                // état commande à refaire car qte bcf != qte vente fille
                bc.setEtat(12);
                bc.updateToTableWithHisto(u,c);
            }
            Vente createdVente = (Vente) super.createObject(u, c);
            setId(createdVente.getId());
            genererFraisTransport(u, c);
            String currentTime = Utilitaire.heureCouranteHMS();
            this.setHeureSaisie(currentTime);
            return createdVente;
        }

        public VenteLib[] getFactureNonPayer() throws Exception {
            Connection c = null;
            boolean estOuvert = false;

            try {
                if (c == null) {
                    c = new UtilDB().GetConn();
                    estOuvert = true;
                }

                VenteLib v = new VenteLib();
                String condition = " AND idClient = '" + this.getIdClient() + "' and id != '" + this.getId() + "'"
                        + " AND montantreste > 0";
                VenteLib[] result = (VenteLib[]) CGenUtil.rechercher(v, null, null, c, condition);
                return result;

            } catch (Exception e) {
                throw e;
            } finally {
                if (estOuvert && c != null) {
                    c.close();
                }
            }
        }

        public BonDeCommande getBc(Connection c) throws Exception {
            BonDeCommande bc = new BonDeCommande();
            bc = (BonDeCommande) bc.getById(this.getIdOrigine(), bc.getNomTable(), c);
            return bc;
        }

        public double getNbCarton(Connection c, VenteDetails [] fille) throws Exception{
            double nb = 0;
            for(int i=0;i< fille.length;i++){
                if(fille[i].getUnite().compareToIgnoreCase(ConstanteSavonnerie.UNITE_CARTON)==0){
                    nb+= fille[i].getQte();
                }
                else {
                    double qte = Math.ceil( fille[i].getQte() / 15.0);
                    nb += qte;
                }
            }

//            EquivalenceVente[] ev = (EquivalenceVente[]) CGenUtil.rechercher(new EquivalenceVente(), null, null,  c, " and IDPRODUIT1 in ("+Utilitaire.tabToString(fille, "idProduit","'",",") +")");
//            if (ev != null) {
//                for (int i = 0; i < ev.length; i++) {
//                    String[] attribut = {"idproduit"};
//                    String[] val = {ev[i].getIdproduit1()};
//                    VenteDetails temp = (VenteDetails) AdminGen.findUnique(fille,attribut, val );
//                    double qte = Math.ceil((double) temp.getQte() / ev[i].getQuantite());
//                    nb += qte;
//                }
//            }

            return nb;
        }

        public void deleteFrais(Connection c, VenteDetails [] pr) throws Exception{
            for (int i = 0; i < pr.length; i++) {
                if(pr[i].getIdProduit().compareToIgnoreCase(ConstanteSavonnerie.ING_FRAIS_LIVRAISON)==0){
                    pr[i].deleteToTable(c);
                }
            }
        }
        
        public void genererEcritureBatch(String u, Statement st) throws Exception{
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
            mere.construirePK(st.getConnection());

            ComptaSousEcriture[] filles = this.genererSousEcriture(st.getConnection());
            for(int i=0; i<filles.length; i++){
                filles[i].setIdMere(mere.getId());
                filles[i].setExercice(exercice);
                filles[i].setDaty(this.getDaty());
                filles[i].setJournal(ConstanteStation.JOURNALVENTE);

//                if(filles[i].getDebit()>0 || filles[i].getCredit()>0) filles[i].createObjectBatch(u, st);
            }
            mere.setFille(filles);
            mere.createObjectBatch(u, st);

        }

        public Prevision[] genererPrevisionPrevuBatch(String u, Statement st) throws Exception {
            VenteDetails[] details = (VenteDetails[]) getFille("VENTE_DETAILS",st.getConnection(),"");
            Prevision[] previsions = new Prevision[details.length];
            for (int i = 0; i < details.length; i++) {
                previsions[i] = details[i].genererPrevisionPrevuBatch(u, st);
            }
            return  previsions;
        }

        public Prevision[] genererPrevisionBatch(String u, Statement st) throws Exception{
//        Prevision mere = new Prevision();
//        Vente venteComplet = this.getVenteWithMontant(c);
//        mere.setDaty(datyPrevu);
//        mere.setCredit(venteComplet.getMontantttcAr());
//        mere.setIdFacture(this.id);
//        mere.setIdCaisse(ConstanteStation.idCaisse);
//        mere.setIdDevise("AR");
//        mere.setDesignation("Prevision rattachée au vente N : "+this.getId());
//        mere.setIdTiers(this.getIdClient());
//        return ( Prevision ) mere.createObject(u, c);
            //Connection c=st.getConnection();
            VenteDetails[] fille = (VenteDetails[])this.getFille();
            List<Prevision> previsions = new ArrayList<>();


            for(VenteDetails f : fille)
            {
                Prevision prev = f.genererPrevision();
                prev.setDaty(this.getDatyPrevu());
                prev.setIdTiers(this.getIdClient());
                Prevision newPrev = (Prevision) prev.createObjectBatch(u, st);
                previsions.add(newPrev);
            }

            return previsions.toArray(new Prevision[previsions.size()]);

        }

        @Override
        public Object validerObjectBatch(String u, Statement st) throws Exception {
            Connection c = st.getConnection();
            Statement st2=c.createStatement();
            boolean estOuvert = false;
            try {
                if (c == null) {
                    estOuvert = true;
                    c = new UtilDB().GetConn();
                }
//            CheckEtatStockVenteDetails(c);
                VenteDetails[] listeFille=(VenteDetails[]) this.getFille();
                Ingredients[] listeIng=this.getListeIngredients(null,c);
                this.setListeIng(listeIng);
                for(int i=0;i<listeFille.length;i++){
                    Ingredients ingredients = null;
                    if(listeFille[i].getIdProduit()!=null&&!listeFille[i].getIdProduit().trim().isEmpty())
                    {
                        String []col={"id"};
                        String []val={listeFille[i].getIdProduit()};
                        ingredients=(Ingredients)AdminGen.find(listeIng,col,val)[0];
                        listeFille[i].setIngFille(ingredients);
                        listeFille[i].setPoids(ingredients.getCalorie());
                        listeFille[i].calculerRevient(c);
                        listeFille[i].updateToTableWithHistoBatch(u,st);
                    }
                }
                st.executeBatch();
                super.validerObjectBatch(u, st);
                Client cl = this.getClient(st.getConnection());
                if (cl != null && cl.getNom() != null) {
                    HistoInsert.ajoutRemarqueBatch(this.getId(), cl.getNom(), st);
                }
                echanger(u,c);
                setFille(listeFille);
                genererEcritureBatch(u, st);
                MvtStock stockEngage = genererStockEngage(listeFille, c);
                if (stockEngage != null) {
                    stockEngage.createObjectBatch(u, st);
                }
                Ristourne ristourne = genererRistourne();
                if (ristourne != null) {
                    ristourne.createObjectBatch(u, st);
                    ristourne.validerObjectBatch(u, st);
                }
                //createMvtStockSortie(u, c);
                if(this.getEstPrevu() == 0){
                    genererPrevisionBatch(u, st);
                }
                else if (this.getEstPrevu() == 1){
                    genererPrevisionPrevuBatch(u, st);
                }
                boolean estAppro = false;
                String[] clientsAppro = ConstanteSocobis.CLIENT_APPRO_VENTE;
                for (String idClientListe : clientsAppro) {
                    if (this.getIdClient().equals(idClientListe)) {
                        estAppro = true;
                        break;
                    }
                }
                if(estAppro == true){
                    //genererApprovisionnement(listeFille, u, c);
                }
                st.executeBatch();

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
    }
