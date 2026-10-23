package vente;

import java.sql.Connection;
import java.sql.Date;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

import annexe.Unite;
import client.ForfaitZoneClient;
import client.ZoneClient;
import fabrication.Fabrication;
import fabrication.FabricationFille;
import fabrication.Of;
import fabrication.OfFille;
import produits.Ingredients;
import produits.Recette;
import chatbot.ClassIA;
import chatbot.FilleOcr;
import chatbot.MereOcr;
import client.Client;
import magasin.Magasin;
import proforma.Proforma;
import proforma.ProformaDetails;
import change.TauxDeChange;
import utilitaire.ConstanteEtat;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;
import bean.*;
import utils.ConstanteSavonnerie;

public class BonDeCommande extends ClassMere implements ClassIA {
    private String id;
    private String idClient;
    private Date daty, dateBesoin;
    private int etat;
    private String remarque;
    private String modepaiement;
    private String reference;
    private String designation;
    private String idDevise;
    private String idMagasin;
    private String idProforma;
    private int modelivraison;
    private String lieuLivraison;
    private Date dateLivraison;
    private double fraislivraison;
    private String idzoneclient,commercial;
    private int typefraistransport;
    private double montantLivraison;
    double montantHT,montantTTC,montantTtcAr,montantRemise,montantTva;


    public double getMontantHT() {
        return montantHT;
    }

    public void setMontantHT(double montantHT) {
        this.montantHT = montantHT;
    }

    public double getMontantTTC() {
        return montantTTC;
    }

    public void setMontantTTC(double montantTTC) {
        this.montantTTC = montantTTC;
    }

    public double getMontantTtcAr() {
        return montantTtcAr;
    }

    public void setMontantTtcAr(double montantTtcAr) {
        this.montantTtcAr = montantTtcAr;
    }

    public double getMontantRemise() {
        return montantRemise;
    }

    public void setMontantRemise(double montantRemise) {
        this.montantRemise = montantRemise;
    }
    @Override
    public boolean getEstIndexable() {
        return true;
    }

    public double getMontantTva() {
        return montantTva;
    }

    public void setMontantTva(double montantTva) {
        this.montantTva = montantTva;
    }


    public double getMontantLivraison() {
        return montantLivraison;
    }

    public void setMontantLivraison(double montantLivraison) {
        this.montantLivraison = montantLivraison;
    }


    public void setTypefraistransport(int typefraistransport) {
        this.typefraistransport = typefraistransport;
    }

    public String getCommercial() {
        return commercial;
    }

    public void setCommercial(String commercial) {
        this.commercial = commercial;
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

    public int getModelivraison() {
        return modelivraison;
    }

    public void setModelivraison(int modelivraison) {
        this.modelivraison = modelivraison;
    }

    public String getIdProforma() {
        return idProforma;
    }

    public void setIdProforma(String idProforma) {
        this.idProforma = idProforma;
    }

    public double getFraislivraison() {
        return fraislivraison;
    }

    public void setFraislivraison(double fraislivraison) {
        this.fraislivraison = fraislivraison;
    }

    @Override
    public String getNomTableIA() {
        return "BONDECOMMANDE_CLIENT_FILLE_CPL";
    }

    @Override
    public String getUrlSaisie() {
        return "/savonnerie/pages/module.jsp?but=vente/bondecommande/bondecommande-saisie.jsp&currentMenu=MNDN000000001071";
    }
    @Override
    public ClassIA getClassSaisie() {
        return this;
    }

    public BonDeCommande getBonDeCommande(Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }
            if (this.getId() == null || this.getId().isEmpty()) {
                throw new Exception("L'identifiant de la bon de commande est obligatoire.");
            }
            BonDeCommande bc = (BonDeCommande) this.getById(this.getId(), "BONDECOMMANDE_CLIENT", c);
            if (bc == null) {
                throw new Exception("Aucune bon de commande trouvée avec l'identifiant : " + this.getId());
            }
            return bc;
        } finally {
            if (estOuvert && c != null) {
                c.close();
            }
        }
    }

    public static BonDeCommande fromOcr(MereOcr mere) throws Exception {
        BonDeCommande f = new BonDeCommande();
        f.setDesignation(mere.getDesignation());
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");

        LocalDate localDate = LocalDate.parse(mere.getDaty(), formatter);
        Date sqlDate = Date.valueOf(localDate);
        f.setDaty(sqlDate);

        Client client = new Client();
        Client[] clients = (Client[]) CGenUtil.rechercher(client, null, null,
                " and upper(nom) like '%" + mere.getIdOrigine().toUpperCase() + "%'");
        if (clients != null && clients.length > 0) {
            f.setIdClient(clients[0].getId());
        }

        Magasin magasin = new Magasin();
        Magasin[] magasins = (Magasin[]) CGenUtil.rechercher(magasin, null, null,
                " and upper(val) like '%" + mere.getIdMagasin().toUpperCase() + "%'");
        if (magasins != null && magasins.length > 0) {
            f.setIdMagasin(magasins[0].getId());
        }

        BonDeCommandeFille[] filles = fillesFromOcr(mere.getDetails().toArray(new FilleOcr[0]));
        f.setFille(filles);

        return f;
    }

    public static BonDeCommandeFille[] fillesFromOcr(FilleOcr[] filles) throws Exception {
        BonDeCommandeFille[] f = new BonDeCommandeFille[filles.length];
        for (int i = 0; i < filles.length; i++) {
            f[i] = BonDeCommandeFille.fromOcr(filles[i]);
        }
        return f;
    }

    public String getIdMagasin() {
        return idMagasin;
    }

    public void setIdMagasin(String idMagasin) {
        this.idMagasin = idMagasin;
    }

    public String getIdDevise() {
        return idDevise;
    }

    public void setIdDevise(String idDevise) {
        if(this.getMode().equals("modif")&&(idDevise==null||idDevise.equals(""))){idDevise="AR";}
        this.idDevise = idDevise;
    }

    public String genererFacture(String u) throws Exception {
        Connection c = null;
        try {
            c = new UtilDB().GetConn();
            c.setAutoCommit(false);
            String idFacture = genererFacture(u, c);
            c.commit();
            return idFacture;
        } catch (Exception e) {
            if (c != null)
                c.rollback();
            throw e;
        } finally {
            if (c != null)
                c.close();
        }
    }

    public void controlerFacturer(Connection c) throws Exception {
        Vente[] ventesAnterieur = (Vente[]) CGenUtil.rechercher(new Vente(), null, null, c,
                " AND idOrigine='" + this.getId() + "' and etat >0");
        if (ventesAnterieur.length > 0) {
            throw new Exception("Facture existante");
        }

    }

    public String genererFacture(String u, Connection c) throws Exception {
        BonDeCommande enBase = (BonDeCommande) this.getById(this.getId(), this.getNomTable(), c);
        BonDeCommandeFille vLib = new BonDeCommandeFille();
        vLib.setNomTable("BONDECOMMANDE_CLIENTF_taux");
        BonDeCommandeFille[] details = (BonDeCommandeFille[]) CGenUtil.rechercher(vLib, null, null, c,
                " AND idBc='" + this.getId() + "'");
        if (details.length > 0) {
            Vente vente = new Vente();
            vente.setIdClient(enBase.getIdClient());
            vente.setDesignation("Facture de la BC " + this.getId());
            vente.setDaty(Utilitaire.dateDuJourSql());
            vente.setIdOrigine(enBase.getId());
            vente.setIdMagasin(enBase.getIdMagasin());
            vente.setEtat(1);
            vente.createObject(u, c);
            for (BonDeCommandeFille detail : details) {
                VenteDetails detailVente = new VenteDetails();
                detailVente.setIdOrigine(detail.getId());
                detailVente.setIdProduit(detail.getProduit());
                detailVente.setQte(detail.getQuantite());
                detailVente.setPu(detail.getPu());
                detailVente.setTva(detail.getTva());
                detailVente.setIdVente(vente.getId());
                detailVente.setIdDevise(detail.getIdDevise());
                detailVente.setTauxDeChange(detail.getTaux());
                detailVente.createObject(u, c);
            }
            return vente.getId();
        }
        throw new Exception("Plus aucun article à facturer");
    }

    public Recette[] decomposer(Connection c) throws Exception {
        return decomposer("AS_RECETTEBC", c);
    }

    public Recette[] decomposer(String nT, Connection c) throws Exception {
        boolean estOuvert = false;
        Ingredients ing = new Ingredients();
        ing.setId(this.getId());
        return ing.decomposerBase(nT, c);
    }

    public String genererBonLivraison(String u) throws Exception {
        Connection c = null;
        try {
            c = new UtilDB().GetConn();
            c.setAutoCommit(false);
            BonDeCommande enbase = (BonDeCommande) this.getById(this.getId(), this.getNomTable(), c);
            BonDeCommandeFille vLib = new BonDeCommandeFille();
            vLib.setNomTable("BC_DETAILS_RESTE");
            BonDeCommandeFille[] details = (BonDeCommandeFille[]) CGenUtil.rechercher(vLib, null, null, c,
                    " AND idBc='" + this.getId() + "' AND reste > 0");
            if (details.length > 0) {
                As_BondeLivraisonClient client = new As_BondeLivraisonClient();
                client.setMode("modif");
                client.setIdbc(this.getId());
                client.setEtat(1);
                client.setIdclient(enbase.getIdClient());
                client.setRemarque("Livraison du bon de commande numero " + this.getId());
                client.setDaty(Utilitaire.dateDuJourSql());
                client.createObject(u, c);
                for (BonDeCommandeFille detail : details) {
                    As_BondeLivraisonClientFille clientFille = new As_BondeLivraisonClientFille();
                    clientFille.setMode("modif");
                    clientFille.setProduit(detail.getProduit());
                    clientFille.setUnite(detail.getUnite());
                    clientFille.setQuantite(detail.getReste());
                    clientFille.setIdbc_fille(detail.getId());
                    clientFille.setNumbl(client.getId());
                    clientFille.createObject(u, c);
                }
                c.commit();
                return client.getId();
            }
            throw new Exception("Plus aucun article à livrer");
        } catch (Exception e) {
            if (c != null)
                c.rollback();
            throw e;
        } finally {
            if (c != null)
                c.close();
        }
    }

    public As_BondeLivraisonClient genererLivraison(String id) throws Exception {
        BonDeCommande bc = new BonDeCommande();
        bc.setId(id);
        return bc.genererLivraison();
    }

    public As_BondeLivraisonClient genererLivraison() throws Exception {
        Connection c = null;
        String id = this.getId();
        try {
            c = new UtilDB().GetConn();
            return genererLivraison(c);
        } catch (Exception e) {
            throw e;
        } finally {
            if (c != null) {
                c.close();
            }
        }
    }

    public As_BondeLivraisonClient genererLivraison(Connection c) throws Exception {
        String id = this.getId();
        System.out.println("tafiditra ato");
        
        BonDeCommande enbase = (BonDeCommande) this.getById(id, this.getNomTable(), c);

        BonDeCommandeFille vLib = new BonDeCommandeFille();
        vLib.setNomTable("BC_DETAILS_RESTE");
        BonDeCommandeFille[] details = (BonDeCommandeFille[]) CGenUtil.rechercher(
                vLib, null, null, c, " AND idBc='" + id + "'");
         System.out.println("id = "+id);
          System.out.println("details.length = "+details.length);
        if (details.length > 0) {
            As_BondeLivraisonClient client = new As_BondeLivraisonClient();
            client.setMode("modif");
            client.setIdbc(id);
            client.setEtat(enbase.getEtat());
            client.setIdclient(enbase.getIdClient());
            client.setRemarque("Livraison du bon de commande numero " + id);
//            client.setDaty(enbase.getDaty());

            As_BondeLivraisonClientFilleInsertion[] clientFilles = new As_BondeLivraisonClientFilleInsertion[details.length];
            for (int i = 0; i < details.length; i++) {
                As_BondeLivraisonClientFilleInsertion a = new As_BondeLivraisonClientFilleInsertion();
                
                System.out.println("Details[i].getProduit()====>"+details[i].getProduit());
                
                Ingredients ing = (Ingredients) new Ingredients().getById(details[i].getProduit(), "AS_INGREDIENTS", c);
               
                a.setProduit(details[i].getProduit());
                a.setProduitLib(details[i].getProduit().concat(" - ").concat(ing.getLibelle()));
                a.setQuantite(details[i].getReste());
                a.setUnite(details[i].getUnite());
                a.setIdbc_fille(details[i].getId());
                Unite u =(Unite) new Unite().getById(details[i].getUnite(), "AS_UNITE", c);
                a.setUniteLib(u.getVal());
                clientFilles[i] = a;
            }
            client.setFille(clientFilles);

            return client;
        } else {
            throw new Exception("Plus aucun article à livrer");
        }
    }
    public void calculerRevient(Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }
            BonDeCommandeFille[] liste=(BonDeCommandeFille[]) this.getFille();
            if(liste==null) liste = (BonDeCommandeFille[]) this.getFille(null, c, "");
            for (BonDeCommandeFille f : liste) {
                f.calculerRevient(c);
            }
        }
        catch (Exception e) {
            throw e;
        }
        finally {
            if(estOuvert==true&&c!=null)c.close();
        }
    }

    public Of genererOf() throws Exception {
        Connection c = null;
        String id = this.getId();
        try {
            c = new UtilDB().GetConn();
            BonDeCommande enbase = (BonDeCommande) this.getById(id, this.getNomTable(), c);

            BonDeCommandeFille vLib = new BonDeCommandeFille();
            vLib.setNomTable("");
            BonDeCommandeFille[] details = (BonDeCommandeFille[]) CGenUtil.rechercher(
                    vLib, null, null, c, " AND idBc='" + id + "' AND reste > 0");

            if (details.length > 0) {
                Of client = new Of();
                client.setRemarque("OF du bon de commande numero : " + id);
                client.setDaty(enbase.getDaty());
                OfFille[] clientFilles = new OfFille[details.length];
                for (int i = 0; i < details.length; i++) {
                    clientFilles[i] = details[i].genererOfFille();
                }
                client.setOfFilles(clientFilles);

                return client;
            } else {
                throw new Exception("Plus aucun article à livrer");
            }
        } catch (Exception e) {
            throw e;
        } finally {
            if (c != null) {
                c.close();
            }
        }
    }

    public OfFille[] getBondeCommandeFille() throws Exception {
        Connection c = null;
        try {
            c = new UtilDB().GetConn();
            BonDeCommandeFille vLib = new BonDeCommandeFille();
            vLib.setNomTable("BONDECOMMANDE_CLIENT_FILLE_CPL");
            vLib.setIdbc(this.getId());
            BonDeCommandeFille[] bcf = (BonDeCommandeFille[]) CGenUtil.rechercher(
                    vLib, null, null, c, "");

            OfFille[] rep = new OfFille[bcf.length];

            if (bcf == null || bcf.length == 0) {
                throw new Exception("Aucun bon de Commande trouvé!");
            }

            for (int i = 0; i < bcf.length; i++) {
                rep[i] = bcf[i].genererOfFille();
            }
            return rep;
        } catch (Exception e) {
            throw e;
        } finally {
            if (c != null) {
                c.close();
            }
        }
    }

    public CartonFille[] getCartonFille()throws Exception{                    
        Connection c = null;
        try {
            
            c = new UtilDB().GetConn();
            BonDeCommandeFille vLib = new BonDeCommandeFille();
            vLib.setNomTable("BONDECOMMANDE_CLIENT_FILLE_CPL");
            vLib.setIdbc(this.getId());
            BonDeCommandeFille[] bcf = (BonDeCommandeFille[]) CGenUtil.rechercher(
                    vLib, null, null, c, "");

            CartonFille[] rep = new CartonFille[bcf.length];

            if (bcf == null || bcf.length == 0) {
                throw new Exception("Aucun bon de Commande trouvé!");
            }

            for (int i = 0; i < bcf.length; i++) {
                rep[i] = bcf[i].genererCartonFille();
            }
            return rep;
        } catch (Exception e) {
            throw e;
        } finally {
            if (c != null) {
                c.close();
            }
        }
    }

        public CartonFille[] getCartonFille(String[]idbcf)throws Exception{                    
        Connection c = null;
        try {            
            c = new UtilDB().GetConn();            
            CartonFille[] cretour= new CartonFille[idbcf.length];
            
                for (int i = 0; i < idbcf.length; i++) {            
                    BonCommandeDetailsCarton_Cpl bcff = new BonCommandeDetailsCarton_Cpl();
                    bcff.setId(idbcf[i]);                    
                    BonCommandeDetailsCarton_Cpl[] bcf = (BonCommandeDetailsCarton_Cpl[]) CGenUtil.rechercher(bcff, null, null, c, "");                    
                    if(bcf.length>0){
                        if(bcf[0].getRestecf()>0){
                            CartonFille cf = new CartonFille();
                            System.out.println(bcf[0].getRestecf()+" ii = "+i +" ; produit = "+bcf[0].getProduit()+" ="+bcf[0].getId());
                            
                            cf.setQuantite(bcf[0].getRestecf());
                            cf.setIdIngredient(bcf[0].getProduit());
                            cf.setIdBcFille(bcf[0].getId());                            
                            cretour[i] = cf;                        
                        }
                        else{
                            throw new Exception("Un ou plusieurs produits dont le reste à mettre dans le carton est 0, Veuillez le deselectionner.");
                        }
                    }
                    else{
                        throw new Exception("Le bon de commande fille "+idbcf[i]+" n'existe pas.");
                    }
                }
            return cretour;
        } catch (Exception e) {
            throw e;
        } finally {
            if (c != null) {
                c.close();
            }
        }
    }

    
    public FabricationFille[] getFabFille() throws Exception {
        Connection c = null;
        try {
            c = new UtilDB().GetConn();
            BonDeCommandeFille vLib = new BonDeCommandeFille();
            vLib.setNomTable("BONDECOMMANDE_CLIENT_FILLE_CPL");
            vLib.setIdbc(this.getId());
            BonDeCommandeFille[] bcf = (BonDeCommandeFille[]) CGenUtil.rechercher(
                    vLib, null, null, c, "");

            FabricationFille[] rep = new FabricationFille[bcf.length];

            if (bcf == null || bcf.length == 0) {
                throw new Exception("Aucun bon de Commande trouvé!");
            }

            for (int i = 0; i < bcf.length; i++) {
                rep[i] = bcf[i].genererFabFille();
            }
            return rep;
        } catch (Exception e) {
            throw e;
        } finally {
            if (c != null) {
                c.close();
            }
        }
    }

    public Fabrication genererFabrication(String id) throws Exception {
        Connection c = null;
        try {
            c = new UtilDB().GetConn();
            Fabrication fabrication = (Fabrication) this.getById(id, "Fabrication", c);
            if (fabrication == null) {
                throw new Exception("Aucune fabrication trouvée avec l'ID spécifié");
            }

            FabricationFille vLib = new FabricationFille();
            vLib.setNomTable("FabricationFille");
            FabricationFille[] fabricationFilles = (FabricationFille[]) CGenUtil.rechercher(
                    vLib, null, null, c, " AND idMere='" + id + "'");

            if (fabricationFilles == null || fabricationFilles.length == 0) {
                throw new Exception("Aucun détail de fabrication trouvé pour l'ID spécifié");
            }

            fabrication.setFille(fabricationFilles);

            return fabrication;
        } catch (Exception e) {
            throw e;
        } finally {
            if (c != null) {
                c.close();
            }
        }
    }

    public BonDeCommande() {
        setNomTable("BONDECOMMANDE_CLIENT");
        this.setLiaisonFille("idbc");
    }

    public void construirePK(Connection c) throws Exception {
        this.preparePk("FCBC", "getseqBONDECOMMANDE_CLIENT");
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

    public Date getDaty() {
        return this.daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public int getEtat() {
        return this.etat;
    }

    public void setEtat(int etat) {
        this.etat = etat;
    }

    public String getRemarque() {
        return this.remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }

    public String getDesignation() {
        return Utilitaire.champNull(designation);
    }

    public void setDesignation(String designation) {
        this.designation = designation;
    }

    public String getModepaiement() {
        return Utilitaire.champNull(modepaiement);
    }

    public void setModepaiement(String modepaiement) {
        this.modepaiement = modepaiement;
    }

    public String getReference() {
        return this.reference;
    }

    public void setReference(String reference) {
        this.reference = reference;
    }

    public String getIdClient() {
        return idClient;
    }

    public Date getDateBesoin() {
        return dateBesoin;
    }

    public void setDateBesoin(Date dateBesoin) {
        this.dateBesoin = dateBesoin;
    }

    public void setIdClient(String idClient) throws Exception {
        if (this.getMode().equals("modif")) {
            if (idClient == null || idClient.isEmpty()) {
                throw new Exception("Le client est obligatoire");
            }
        }
        this.idClient = idClient;
    }

    protected void lierDeviseFille() {
        BonDeCommandeFille[] filles = (BonDeCommandeFille[]) this.getFille();
        for (BonDeCommandeFille bcf : filles) {
            bcf.setIdDevise(this.getIdDevise());
        }
    }

    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {

        lierDeviseFille();
        double taux=1;
        if(this.getIdDevise()!=null&&this.getIdDevise().compareToIgnoreCase("AR")!=0)taux=TauxDeChange.getLastTaux(c,Utilitaire.formatterDaty(this.getDaty()),this.getIdDevise());
        BonDeCommandeFille[] filles = (BonDeCommandeFille[]) this.getFille();
        for (BonDeCommandeFille bcf : filles) {
            bcf.setIdDevise(this.getIdDevise());
            if(bcf.getIdDevise()!=null&&bcf.getIdDevise().compareToIgnoreCase("AR")!=0&&bcf.getTauxdechange()<=1) bcf.setTauxdechange(taux);
        }
        BonDeCommande createdObject = (BonDeCommande) super.createObject(u, c);
        this.setId(createdObject.getId());
//        if (this.getIdProforma() == null || this.getIdProforma().isEmpty()) {
            genererFraisTransport(u, c);
//        }
        if(this.getIdProforma()!=null&&!this.getIdProforma().isEmpty()){
            Proforma p = (Proforma) new Proforma().getById(this.getIdProforma(),"PROFORMA",c);
            boolean valide = p.checkValide(this.getDaty());
            if(!valide)throw new Exception("Date de validit\u00E9 expir\u00E9");
        }
        return createdObject;
    }

    private BonDeCommandeFille genererFraisTransport(String u, Connection c) throws  Exception {
//        double fraisLivraison = ForfaitZoneClient.calculerFraisTransport(this.getTypefraistransport(), this.getIdzoneclient(), this.getQteCarton(c), c);
//        // mannuelle debut
//        double fraisLivraison = this.getMontantLivraison();
//        if (fraisLivraison > 0) {
////            setFraislivraison(fraisLivraison);
//            BonDeCommandeFille fraisLivraisonFille = genererFraisTransportDetails(fraisLivraison, c);
//            fraisLivraisonFille.setIdbc(this.getId());
//            return (BonDeCommandeFille) fraisLivraisonFille.createObject(u, c);
//        }
//        // mannuelle fin

        // automatique debut
        if(this.getTypefraistransport()==1){
            BonDeCommandeFille [] fille = (BonDeCommandeFille []) CGenUtil.rechercher(new BonDeCommandeFille(), null,null,c, "AND IDBC='"+this.getId()+"'");
            //BonDeCommandeFille [] fille = (BonDeCommandeFille [])this.getFille("BONDECOMMANDE_CLIENT_FILLE",c,"");
            deleteFrais(c,fille);
            BonDeCommandeFille [] fille2 = (BonDeCommandeFille []) CGenUtil.rechercher(new BonDeCommandeFille(), null,null,c, "AND IDBC='"+this.getId()+"'");
            ZoneClient zcl = (ZoneClient) new ZoneClient().getById(this.getIdzoneclient(),"ZONECLIENT",c);
            double fraisLivraison = zcl.calculerFraisLivraison(getNbCarton(c,fille2))+this.getMontantLivraison();
            if (fraisLivraison > 0) {
                //setFraislivraison(fraisLivraison);
                BonDeCommandeFille fraisLivraisonFille = genererFraisTransportDetails(fille2[0],fraisLivraison, c);
                fraisLivraisonFille.setIdbc(this.getId());
                return (BonDeCommandeFille) fraisLivraisonFille.createObject(u, c);
            }
        }
        // automatique fin
        return null;
    }

    public BonDeCommandeFille genererFraisTransportDetails(BonDeCommandeFille vd, double frais, Connection c) throws Exception {
        Client client = getClient(c);
        Ingredients ing = (Ingredients) new Ingredients().getById(ConstanteSavonnerie.ING_FRAIS_LIVRAISON, "AS_INGREDIENTS", c);
        if(ing==null){
            throw new Exception("Produit frais de livraison n'existe pas!");
        }
        BonDeCommandeFille fraisLivraisonFille = new BonDeCommandeFille();
        fraisLivraisonFille.setQuantite(1);
        fraisLivraisonFille.setPu(frais/vd.getTauxdechange());
        fraisLivraisonFille.setUnite(ConstanteSavonnerie.ID_UNITE_SIMPLE);
        fraisLivraisonFille.setTaux(1);
        fraisLivraisonFille.setTauxdechange(vd.getTauxdechange());
        fraisLivraisonFille.setTva(ing.getTva());
        fraisLivraisonFille.setProduit(ConstanteSavonnerie.ING_FRAIS_LIVRAISON);
        fraisLivraisonFille.setDesignation("Frais de transport");
        fraisLivraisonFille.setIdDevise(this.getIdDevise());
        return fraisLivraisonFille;
    }

    public Client getClient(Connection c) throws Exception {
        if (this.getIdClient() != null) {
            Client client = new Client();
            client.setId(this.getIdClient());
            Client[] clients = (Client[]) CGenUtil.rechercher(client, null, null, c, "");
            if (clients.length > 0) {
                return clients[0];
            }
        }
        return null;
    }

    public double getQteCarton(Connection c) throws Exception {
        BonDeCommandeFille[] details = (BonDeCommandeFille[]) this.getFille();
        double qteCartonTotal = 0;
        for (BonDeCommandeFille detail : details) {
            double qteCarton = detail.getQteCarton(c);
            double qtePieceRestant = detail.getQtePieceRestant(c);
            if (qtePieceRestant > 0) {
                qteCarton += 1;
            }
            qteCartonTotal += qteCarton;
        }
        return qteCartonTotal;
    }

    @Override
    public String[] getMotCles() {
        String[] motCles={"id", "designation","dateBesoin"};
        return motCles;
    }

    @Override
    public String[] getValMotCles() {
        String[] motCles={"designation","dateBesoin"};
        return motCles;
    }
    public InsertionVente createVente()throws Exception{
        try {
            BonDeCommande bc = new BonDeCommande();
            bc.setId(this.getId());
            BonDeCommande[] resultats = (BonDeCommande[]) CGenUtil.rechercher(bc, null, null, "");
            if(resultats.length > 0) {
                bc = resultats[0];
                InsertionVente bd = new InsertionVente();
                Client cli = (Client) new Client().getById(bc.getIdClient(),"CLIENT",null);
                bd.setEcheancefacture(cli.getEcheance());
                if (bc.getIdClient() != null) {
                    bd.setIdClient(bc.getIdClient());
                }
                if (bc.getIdMagasin() != null) {
                    bd.setIdMagasin(bc.getIdMagasin());
                }
                if (bc.getIdDevise() != null) {
                    bd.setIdDevise(bc.getIdDevise());
                }
                if (bc.getIdzoneclient() != null) {
                    bd.setIdzoneclient(bc.getIdzoneclient());
                }
                if (bc.getCommercial() != null) {
                    bd.setCommercial(bc.getCommercial());
                }
                bd.setTypefraistransport(bc.getTypefraistransport());
                bd.setModepaiement(bc.getModepaiement());
                bd.setModelivraison(bc.getModelivraison());
                bd.setDesignation("Facture de la Bon de commande Num "+bc.getId());
                bd.setRemarque("Facture de la Bon de commande Num "+bc.getId());
                bd.setDateLivraison(bc.getDateLivraison());
                bd.setLieuLivraison(bc.getLieuLivraison());
                bd.setDatyPrevu(Utilitaire.ajoutJourDate(bd.getDatyPrevu(), (int)cli.getEcheance()));
                bd.setIdOrigine(bc.getId());
                bd.setFraislivraison(bc.getFraislivraison());
                return bd;
            }else {
                throw new Exception("La proforma n'existe pas");
            }
        }catch(Exception e){
            throw e;
        }
    }
     public BonDeCommandeFIlleCpl[] getFilleBCLib()throws Exception{
        BonDeCommandeFIlleCpl profD = new BonDeCommandeFIlleCpl();
        profD.setIdbc(this.getId());
        BonDeCommandeFIlleCpl[] val= (BonDeCommandeFIlleCpl[])CGenUtil.rechercher(profD, null, null, "");
        return val;
    }
     @Override
    public String getNomClasseFille() {
        return ("vente.BonDeCommandeFille");
    }

    @Override
    public String getLiaisonFille() {
        return "idbc"  ;
    }

    public String getIdzoneclient() {
        return idzoneclient;
    }

    public void setIdzoneclient(String idzoneclient) {
        this.idzoneclient = idzoneclient;
    }

    //@Override
    //public int updateObject(String u, Connection c) throws Exception {
    //    return this.updateToTableWithHisto(u, c);
    //}

    public double getNbCarton(Connection c, BonDeCommandeFille [] fille) throws Exception{
        double nb = 0;
        for(int i=0;i< fille.length;i++){
            if(fille[i].getUnite().compareToIgnoreCase(ConstanteSavonnerie.UNITE_CARTON)==0){
                nb+= fille[i].getQuantite();
            }
            else {
                double qte = Math.ceil( fille[i].getQuantite() / 15.0);
                nb += qte;
            }
        }

//        EquivalenceVente[] ev = (EquivalenceVente[]) CGenUtil.rechercher(new EquivalenceVente(), null, null,  c, " and IDPRODUIT1 in ("+Utilitaire.tabToString(fille, "produit","'",",") +")");
//        if (ev != null) {
//            for (int i = 0; i < ev.length; i++) {
//                String[] attribut = {"produit"};
//                String[] val = {ev[i].getIdproduit1()};
//
//                BonDeCommandeFille temp = (BonDeCommandeFille) AdminGen.findUnique(fille,attribut, val );
//                double qte = Math.ceil(temp.getQuantite() / ev[i].getQuantite());
//
//                nb += qte;
//            }
//        }

        return nb;
    }

    public void deleteFrais(Connection c, BonDeCommandeFille [] pr) throws Exception{
        for (int i = 0; i < pr.length; i++) {
            if(pr[i].getProduit().compareToIgnoreCase(ConstanteSavonnerie.ING_FRAIS_LIVRAISON)==0){
                pr[i].deleteToTable(c);
            }
        }
    }

    public int updateObject(String u,Connection c)throws Exception
    {
        this.getFille(null,c,"");
        genererFraisTransport(u, c);
        return super.updateObject(u, c);
    }
}
