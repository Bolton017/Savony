package faturefournisseur.proforma;

import bean.CGenUtil;
import stock.MvtStockFilleTheorique;
import utilitaire.UtilDB;

import java.sql.Connection;
import java.sql.Date;
import java.util.HashMap;
import java.util.Vector;
import java.util.concurrent.ExecutionException;

public class ProformaFournisseurDetailsCpl extends ProformaFournisseurDetails{
    public ProformaFournisseurDetailsCpl() throws Exception {
        this.setNomTable("proformafournisseurdetailscpl");
    }
    private Date daty;
    private String remarque;
    private String designation;
    private String produitlib;
    private String unitelib;
    private String modepaimenetlib;
    private String fournisseurlib;
    private double montantTVA;
    private double montantTTC;
    private double montantHT;
    private String idOrigineMere;
    private String etatLib;
    private Date dateEcheance;

    public Date getDateEcheance() {
        return dateEcheance;
    }

    public void setDateEcheance(Date dateEcheance) {
        this.dateEcheance = dateEcheance;
    }

    

    public String getEtatLib() {
        return etatLib;
    }

    public void setEtatLib(String etatLib) {
        this.etatLib = etatLib;
    }

    public String getIdOrigineMere() {
        return idOrigineMere;
    }

    public void setIdOrigineMere(String idOrigineMere) {
        this.idOrigineMere = idOrigineMere;
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

    public String getDesignation() {
        return designation;
    }

    public void setDesignation(String designation) {
        this.designation = designation;
    }

    public String getProduitlib() {
        return produitlib;
    }

    public void setProduitlib(String produitlib) {
        this.produitlib = produitlib;
    }

    public String getUnitelib() {
        return unitelib;
    }

    public void setUnitelib(String unitelib) {
        this.unitelib = unitelib;
    }

    public String getModepaimenetlib() {
        return modepaimenetlib;
    }

    public void setModepaimenetlib(String modepaimenetlib) {
        this.modepaimenetlib = modepaimenetlib;
    }

    public String getFournisseurlib() {
        return fournisseurlib;
    }

    public void setFournisseurlib(String fournisseurlib) {
        this.fournisseurlib = fournisseurlib;
    }

    public double getMontantTVA() {
        return montantTVA;
    }

    public void setMontantTVA(double montantTVA) {
        this.montantTVA = montantTVA;
    }

    public double getMontantTTC() {
        return montantTTC;
    }

    public void setMontantTTC(double montantTTC) {
        this.montantTTC = montantTTC;
    }

    public double getMontantHT() {
        return montantHT;
    }

    public void setMontantHT(double montantHT) {
        this.montantHT = montantHT;
    }

    public HashMap<String, Vector> comparaisonPrixParProduit(String idDmdAchat, String nt, Connection c) throws Exception{
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
            }
            ProformaFournisseurDetailsCpl ctr = new ProformaFournisseurDetailsCpl();
            if(nt == null || nt.trim().isEmpty()) {
                nt = "proformafournisseurdetailscpl";
            }
            ctr.setNomTable(nt);
            ctr.setIdOrigineMere(idDmdAchat);
            HashMap<String, Vector> rep = new HashMap<>();
            ProformaFournisseurDetailsCpl[] liste = (ProformaFournisseurDetailsCpl[]) CGenUtil.rechercher(ctr, null, null, c, "");
            for(ProformaFournisseurDetailsCpl o : liste){
                if(o.getProduitlib()!=null && !o.getProduitlib().equals("")){
                    Vector v = rep.get(o.getProduitlib());
                    if(v == null){
                        v = new Vector();
                        rep.put(o.getProduitlib(),v);
                    }
                    v.add(o);
                }
            }
            return rep;
        } catch (Exception e) {
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }
}
