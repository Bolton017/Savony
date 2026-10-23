package proforma;

import bean.AdminGen;
import bean.CGenUtil;
import bean.ClassMAPTable;
import bean.ClassMere;
import change.TauxDeChange;
import client.Client;
import client.ForfaitZoneClient;
import client.ZoneClient;
import produits.Ingredients;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;
import utils.ConstanteSavonnerie;
import vente.BonDeCommande;
import vente.BonDeCommandeFille;
import vente.EquivalenceVente;

import java.sql.Connection;
import java.sql.Date;

public class Proforma extends ClassMere{
    private String id,designation,idMagasin,remarque,idOrigine,idClient,idReservation,echeance,reglement, idDevise;
    private Date daty,datyPrevu, dateprevres, dateValidite;
    private int etat,estPrevu;
    private double tva,remise,caution, fraislivraison;
    private String lieulocation;
    private String idzoneclient;
    private int typefraistransport,nbJour;
    private String checkStock;
    private double montantLivraison;

    public double getMontantLivraison() {
        return montantLivraison;
    }

    public void setMontantLivraison(double montantLivraison) {
        this.montantLivraison = montantLivraison;
    }

    public boolean checkValide(Date date){
        if (this.getDateValidite() == null || date == null) {
            return false;
        }

        java.time.LocalDate dateValidite = this.getDateValidite().toLocalDate();
        java.time.LocalDate dateParam = date.toLocalDate();

        System.out.println("checkValide - dateValidite=" + dateValidite + ", date param=" + dateParam);
        return !dateValidite.isBefore(dateParam);
    }
    public int getNbJour() {
        return nbJour;
    }

    public void setNbJour(int nbJour) {
        this.nbJour = nbJour;
    }

    public String getCheckStock() {
        return checkStock;
    }

    public void setCheckStock(String checkStock) {
        this.checkStock = checkStock;
    }

    public String getIdDevise() {
        return idDevise;
    }

    public void setIdDevise(String idDevise) {
        this.idDevise = idDevise;
    }

    public double getCaution() {
        return caution;
    }
    public void setCaution(double caution) {
        this.caution = caution;
    }

    public String getLieulocation() {
        return lieulocation;
    }

    public void setLieulocation(String lieulocation) {
        this.lieulocation = lieulocation;
    }

    public double getRemise() {
        return remise;
    }

    public void setRemise(double remise) {
        this.remise = remise;
    }

    public Proforma getProforma(Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }
            if (this.getId() == null || this.getId().isEmpty()) {
                throw new Exception("L'identifiant de la proforma est obligatoire.");
            }
            Proforma p = (Proforma) this.getById(this.getId(), "PROFORMA", c);
            if (p == null) {
                throw new Exception("Aucune proforma trouvée avec l'identifiant : " + this.getId());
            }
            return p;
        } finally {
            if (estOuvert && c != null) {
                c.close();
            }
        }
    }

    public Date getDateprevres() {
        return dateprevres;
    }

    public void setDateprevres(Date dateprevres) {
        this.dateprevres = dateprevres;
    }

    public Proforma()throws Exception{
        this.setNomTable("PROFORMA");
        this.setLiaisonFille("idProforma");
        this.setNomClasseFille("proforma.ProformaDetails");
    }
    @Override
    public String getTuppleID() {
        return this.id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("PROF", "getSeqProforma");
        this.setId(makePK(c));
    }

    public double getFraislivraison() {
        return fraislivraison;
    }

    public void setFraislivraison(double fraislivraison) {
        this.fraislivraison = fraislivraison;
    }

    public String getId() {
        return id;
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

    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
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

    public String getIdReservation() {
        return idReservation;
    }

    public void setIdReservation(String idReservation) {
        this.idReservation = idReservation;
    }

    public String getEcheance() {
        return echeance;
    }

    public void setEcheance(String echeance) {
        this.echeance = echeance;
    }

    public String getReglement() {
        return reglement;
    }

    public void setReglement(String reglement) {
        this.reglement = reglement;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public Date getDatyPrevu() {
        return datyPrevu;
    }

    public void setDatyPrevu(Date datyPrevu) {
        this.datyPrevu = datyPrevu;
    }

    public int getEtat() {
        return etat;
    }

    public void setEtat(int etat) {
        this.etat = etat;
    }

    public int getEstPrevu() {
        return estPrevu;
    }

    public void setEstPrevu(int estPrevu) {
        this.estPrevu = estPrevu;
    }

    public double getTva() {
        return tva;
    }

    public void setTva(double tva) {
        this.tva = tva;
    }

    public Date getDateValidite() {
        return dateValidite;
    }

    public void setDateValidite(Date dateValidite) {
        this.dateValidite = dateValidite;
    }

    @Override
    public String getNomClasseFille() {
        return ("proforma.ProformaDetails");
    }

    @Override
    public String getLiaisonFille() {
        return "idProforma"  ;
    }
    public ProformaDetails[] getFilleProforma()throws Exception{
        ProformaDetails profD = new ProformaDetails();
        profD.setIdProforma(this.getId());
        ProformaDetails[] val= (ProformaDetails[])CGenUtil.rechercher(profD, null, null, "");
        return val;
    }
    public ProformaDetailsLib[] getFilleProformaLib()throws Exception{
        ProformaDetailsLib profD = new ProformaDetailsLib();
        profD.setIdProforma(this.getId());
        ProformaDetailsLib[] val= (ProformaDetailsLib[])CGenUtil.rechercher(profD, null, null, "");
        return val;
    }
    public BonDeCommande createBonDeCommande()throws Exception{
        try {
            Proforma proforma = new Proforma();
            proforma.setId(this.getId());
            Proforma[] resultats = (Proforma[]) CGenUtil.rechercher(proforma, null, null, "");
            if(resultats.length > 0) {
                Date jours30 = Utilitaire.ajoutJourDate(resultats[0].getDaty(), 30);
                if (jours30.before(Utilitaire.dateDuJourSql())) {
                    throw new Exception("La date de la proforma a d\\u00E9j\\u00E0  plus de 30 jours!!!");
                }
                //if (resultats[0].getDateValidite().before(Utilitaire.dateDuJourSql())) {
                //    throw new Exception("La date de validit\\u00E9 de la proforma est d\\u00E9j\\u00E0 d\\u00E9pass\\u00E9e!!!");
                //}
                proforma = resultats[0];
                BonDeCommande bd = new BonDeCommande();
                if (proforma.getIdClient() != null) {
                    bd.setIdClient(proforma.getIdClient());
                }
                if (proforma.getIdMagasin() != null) {
                    bd.setIdMagasin(proforma.getIdMagasin());
                }
                if (proforma.getIdDevise() != null) {
                    bd.setIdDevise(proforma.getIdDevise());
                }
                if (proforma.getIdzoneclient() != null) {
                    bd.setIdzoneclient(proforma.getIdzoneclient());
                }
                bd.setTypefraistransport(proforma.getTypefraistransport());
                bd.setIdProforma(proforma.getId());
                bd.setFraislivraison(proforma.getFraislivraison());
                bd.setMontantLivraison(proforma.getMontantLivraison());
                bd.setDesignation("Bon de commande de la proforma Num "+proforma.getId());
                bd.setRemarque("Bon de commande de la proforma Num "+proforma.getId());
                return bd;
            }else {
                throw new Exception("La proforma n'existe pas");
            }
        }catch(Exception e){
            throw e;
        }
    }

    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {
        System.err.println("==============================1="+this.getDateValidite());
        this.setDateValidite(new java.sql.Date(this.getDateValidite().getTime() + (long) this.getNbJour() * 24 * 60 * 60 * 1000));
        System.err.println("==============================2="+this.getDateValidite());
        CheckEtatStockVenteDetailsALaCreation(c);
        double taux= TauxDeChange.getLastTaux(c,Utilitaire.formatterDaty(this.getDaty()),this.getIdDevise());
        ProformaDetails[] det=(ProformaDetails[])this.getFille();
        for(ProformaDetails d:det)
        {
            if(d.getIdDevise()!=null&&d.getIdDevise().compareToIgnoreCase("AR")!=0&&d.getTauxDeChange()<=1)d.setTauxDeChange(taux);
        }
        Proforma createdProforma = (Proforma) super.createObject(u, c);
        setId(createdProforma.getId());
        genererFraisTransport(u, c);
        return createdProforma;
    }





    public void CheckEtatStockVenteDetailsALaCreation(Connection c) throws Exception {
        if ("1".equals(this.getCheckStock())) {
            ProformaDetails[] vds = (ProformaDetails[]) this.getFille();

            if (vds != null) {
                StringBuilder errors = new StringBuilder();
                int num = 1;
                for (ProformaDetails v : vds) {
                    String erreur = v.CheckEtatStockALaCreationString(c, this.getIdMagasin());

                    if (erreur != null && !erreur.isEmpty()
                    ) {
                        errors.append(num).append("- ").append(erreur).append(". ");
                        num++;
                    }
                }

                if (errors.length() > 0) {
                    throw new Exception("Erreur de stock : " + errors);
                }
            }
        }
    }

    public String getIdzoneclient() {
        return idzoneclient;
    }

    public void setIdzoneclient(String idzoneclient) {
        this.idzoneclient = idzoneclient;
    }

    public int getTypefraistransport() {
        return typefraistransport;
    }

    public void setTypefraistransport(int typefraistransport) {
        this.typefraistransport = typefraistransport;
    }


    public double getQteCarton(Connection c) throws Exception {
        ProformaDetails[] details = (ProformaDetails[]) this.getFille();
        double qteCartonTotal = 0;
        for (ProformaDetails detail : details) {
            double qteCarton = detail.getQteCarton(c);
            double qtePieceRestant = detail.getQtePieceRestant(c);
            if (qtePieceRestant > 0) {
                qteCarton += 1;
            }
            qteCartonTotal += qteCarton;
        }
        return qteCartonTotal;
    }

    public double getNbCarton(Connection c, ProformaDetails [] fille) throws Exception{
        double nb = 0;
        for(int i=0;i< fille.length;i++){
            if(fille[i].getUnite().compareToIgnoreCase(ConstanteSavonnerie.UNITE_CARTON)==0){
                nb+= fille[i].getQte();
            }else {
                double qte = Math.ceil( fille[i].getQte() / 15.0);
                nb += qte;
            }
        }

//        EquivalenceVente[] ev = (EquivalenceVente[]) CGenUtil.rechercher(new EquivalenceVente(), null, null,  c, " and IDPRODUIT1 in ("+Utilitaire.tabToString(fille, "idProduit","'",",") +")");
//        if (ev != null) {
//            for (int i = 0; i < ev.length; i++) {
//                String[] attribut = {"produit"};
//                String[] val = {ev[i].getIdproduit1()};
//
//                ProformaDetails temp = (ProformaDetails) AdminGen.findUnique(fille,attribut, val );
//                double qte = Math.ceil((double) temp.getQte() / ev[i].getQuantite());
//                nb += qte;
//            }
//        }

        return nb;
    }

    private void genererFraisTransport(String u, Connection c) throws  Exception {
//        double fraisLivraison = ForfaitZoneClient.calculerFraisTransport(this.getTypefraistransport(), this.getIdzoneclient(), this.getQteCarton(c), c);
//        // mannuelle debut
//        double fraisLivraison = this.getMontantLivraison();
//        if (fraisLivraison > 0) {
//            setFraislivraison(fraisLivraison);
//            ProformaDetails proformaDetails = genererFraisTransportDetails(fraisLivraison, c);
//            proformaDetails.setIdProforma(this.getId());
//            proformaDetails.createObject(u, c);
//        }
//        // mannuelle fin

        // automatique debut
        if(this.getTypefraistransport()==1){
            //ProformaDetails [] fille = (ProformaDetails []) this.getFille("PROFORMA_DETAILS",c,"");
            ProformaDetails[] fille = (ProformaDetails []) CGenUtil.rechercher(new ProformaDetails(), null,null,c, "AND IDPROFORMA='"+this.getId()+"'");
            deleteFrais(c,fille);
            ProformaDetails[] fille2 = (ProformaDetails []) CGenUtil.rechercher(new ProformaDetails(), null,null,c, "AND IDPROFORMA='"+this.getId()+"'");
            ZoneClient zcl = (ZoneClient) new ZoneClient().getById(this.getIdzoneclient(),"ZONECLIENT",c);
            double fraisLivraison = zcl.calculerFraisLivraison(getNbCarton(c,fille2))+this.getMontantLivraison();
            if (fraisLivraison > 0) {
                //setFraislivraison(fraisLivraison);
                ProformaDetails proformaDetails = genererFraisTransportDetails(fille2[0],fraisLivraison, c);
                proformaDetails.setIdProforma(this.getId());
                proformaDetails.createObject(u, c);
            }
        }
        // automatique fin
    }

    public ProformaDetails genererFraisTransportDetails(ProformaDetails vd, double puCarton, Connection c) throws Exception {
        Client client = getClient(c);
        Ingredients ing = (Ingredients) new Ingredients().getById(ConstanteSavonnerie.ING_FRAIS_LIVRAISON, "AS_INGREDIENTS", c);
        if(ing==null){
            throw new Exception("Produit frais de livraison n'existe pas!");
        }
        ProformaDetails proformaDetails = new ProformaDetails();
        proformaDetails.setQte(1);
        proformaDetails.setPu(puCarton/vd.getTauxDeChange());
        proformaDetails.setUnite(ConstanteSavonnerie.ID_UNITE_SIMPLE);
        proformaDetails.setTva(ing.getTva());
        proformaDetails.setTauxDeChange(vd.getTauxDeChange());
        proformaDetails.setIdProduit(ing.getId());
        proformaDetails.setDesignation("Frais de transport");
        proformaDetails.setIdDevise(this.getIdDevise());
        proformaDetails.setCompte(ing.getCompte_vente());
        return proformaDetails;
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

    public void deleteFrais(Connection c, ProformaDetails [] pr) throws Exception{
        for (int i = 0; i < pr.length; i++) {
            if(pr[i].getIdProduit().compareToIgnoreCase(ConstanteSavonnerie.ING_FRAIS_LIVRAISON)==0){
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
