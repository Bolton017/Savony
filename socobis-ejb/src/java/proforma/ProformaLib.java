package proforma;

import bean.CGenUtil;
import utilitaire.UtilDB;
import vente.BonDeCommande;
import vente.BonDeCommandeFille;
import vente.VenteDetailsLib;

import java.sql.Connection;
import java.sql.Date;

public class ProformaLib extends Proforma{
    private String idMagasinLib,etatLib,idClientLib,adresse,contact,idDevise, codeclient;
    private double montantTotal,montantTva,montantTtc,montantTtcAr,montantPaye,montantreste,avoir,tauxDechange,montantRevient,margeBrute,montantremise,montant, montantristourne, fraistransport;
    private Date datedebut;
    private String idZoneClientLib;
    private String etatbc;

    public BonDeCommande[] getBC(Connection c) throws Exception {
        if (this.getId() == null) {
            throw new Exception("ID proforma null");
        }
        boolean estOuvert = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }
            BonDeCommande b = new BonDeCommande();
            b.setIdProforma(this.getId());

            return (BonDeCommande[]) CGenUtil.rechercher(b, null, null, c, "");
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        } finally {
            if (estOuvert && c != null) {
                c.close();
            }
        }
    }

    public String getEtatbc() throws Exception {
        return etatbc;
    }

    public void setEtatbc(String etatbc) {
        this.etatbc = etatbc;
    }

    public String getIdZoneClientLib() {
        return idZoneClientLib;
    }

    public void setIdZoneClientLib(String idZoneClientLib) {
        this.idZoneClientLib = idZoneClientLib;
    }

    public Date getDatedebut() {
        return datedebut;
    }

    public void setDatedebut(Date datedebut) {
        this.datedebut = datedebut;
    }
    
    public double getMontant() {
        return montant;
    }

    public double getMontantristourne() {
        return montantristourne;
    }

    public void setMontantristourne(double montantristourne) {
        this.montantristourne = montantristourne;
    }

    public String getCodeclient() {
        return codeclient;
    }

    public void setCodeclient(String codeclient) {
        this.codeclient = codeclient;
    }

    public void setMontant(double montant) {
        this.montant = montant;
    }

    public double getMontantremise() {
        return montantremise;
    }

    public void setMontantremise(double montantremise) {
        this.montantremise = montantremise;
    }

    public ProformaLib()throws Exception{
        this.setNomTable("PROFORMA_CPL");
    }

    public double getFraistransport() {
        return fraistransport;
    }

    public void setFraistransport(double fraistransport) {
        this.fraistransport = fraistransport;
    }

    public void setAvoir(double avoir) {
        this.avoir = avoir;
    }

    public void setIdMagasinLib(String idMagasinLib) {
        this.idMagasinLib = idMagasinLib;
    }

    public void setEtatLib(String etatLib) {
        this.etatLib = etatLib;
    }

    public void setIdClientLib(String idClientLib) {
        this.idClientLib = idClientLib;
    }

    public void setAdresse(String adresse) {
        this.adresse = adresse;
    }

    public void setContact(String contact) {
        this.contact = contact;
    }

    public void setMontantTotal(double montantTotal) {
        this.montantTotal = montantTotal;
    }

    public void setMontantTva(double montantTva) {
        this.montantTva = montantTva;
    }

    public void setMontantTtc(double montantTtc) {
        this.montantTtc = montantTtc;
    }

    public void setMontantTtcAr(double montantTtcAr) {
        this.montantTtcAr = montantTtcAr;
    }

    public void setMontantPaye(double montantPaye) {
        this.montantPaye = montantPaye;
    }

    public void setMontantreste(double montantreste) {
        this.montantreste = montantreste;
    }

    public void setTauxDechange(double tauxDechange) {
        this.tauxDechange = tauxDechange;
    }

    public void setMontantRevient(double montantRevient) {
        this.montantRevient = montantRevient;
    }

    public void setMargeBrute(double margeBrute) {
        this.margeBrute = margeBrute;
    }

    public double getMontantPaye() {
        return montantPaye;
    }

    public String getIdMagasinLib() {
        return idMagasinLib;
    }

    public String getEtatLib() {
        return etatLib;
    }

    public String getIdClientLib() {
        return idClientLib;
    }

    public String getAdresse() {
        return adresse;
    }

    public String getContact() {
        return contact;
    }

    public double getMontantTotal() {
        return montantTotal;
    }

    public double getMontantTva() {
        return montantTva;
    }

    public double getMontantTtc() {
        return montantTtc;
    }

    public double getMontantTtcAr() {
        return montantTtcAr;
    }

    public double getMontantreste() {
        return montantreste;
    }

    public double getAvoir() {
        return avoir;
    }

    public double getTauxDechange() {
        return tauxDechange;
    }

    public double getMontantRevient() {
        return montantRevient;
    }

    public double getMargeBrute() {
        return margeBrute;
    }

    public String getIdDevise() {
        return idDevise;
    }

    public void setIdDevise(String idDevise) {
        this.idDevise = idDevise;
    }

    public BonDeCommandeFille[] getBonDeCommandeFille() throws Exception {
        ProformaDetails[] proformaDetails = (ProformaDetails[])this.getFille("PROFORMA_DETAILS",null,"");
        BonDeCommandeFille[] bcFille = new  BonDeCommandeFille[proformaDetails.length];

        for (int i = 0; i < proformaDetails.length; i++) {
            bcFille[i] = new BonDeCommandeFille();
            bcFille[i].setProduit(proformaDetails[i].getIdProduit());
            bcFille[i].setPu(proformaDetails[i].getPu());
            bcFille[i].setQuantite(proformaDetails[i].getQte());
            bcFille[i].setTva(proformaDetails[i].getTva());
            bcFille[i].setIdDevise(proformaDetails[i].getIdDevise());
            bcFille[i].setUnite(proformaDetails[i].getUnite());
        }
        return bcFille;
    }
    
}
