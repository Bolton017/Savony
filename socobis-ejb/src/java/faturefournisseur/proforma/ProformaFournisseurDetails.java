package faturefournisseur.proforma;

import bean.CGenUtil;
import bean.ClassFille;
import utilitaire.ConstanteEtat;
import utilitaire.UtilDB;

import java.sql.Connection;

public class ProformaFournisseurDetails extends ClassFille {
    private String id;
    private String produit;
    private String idMere;
    private double quantite;
    private double pu;
    private double montant;
    private double tva;
    private String unite;
    private double remise,remiseMontant;
    private String idDevise;
    private double tauxdechange;


    public ProformaFournisseurDetails() throws Exception {
        super.setNomTable("ProformaFournisseurDetails");
        this.setLiaisonMere("idMere");
        this.setNomClasseMere("faturefournisseur.proforma.ProformaFournisseur");
    }

    public void construirePK(Connection c) throws Exception {
        this.preparePk("PRFD", "getSeqProFNRDetails");
        this.setId(makePK(c));
    }


    @Override
    public String getNomClasseMere() {
        return "faturefournisseur.proforma.ProformaFournisseur";
    }
    @Override
    public String getLiaisonMere() {
        return "idMere";
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getProduit() {
        return produit;
    }

    public void setProduit(String produit) {
        this.produit = produit;
    }

    public String getIdMere() {
        return idMere;
    }

    public void setIdMere(String idMere) {
        this.idMere = idMere;
    }

    public double getQuantite() {
        return quantite;
    }

    public void setQuantite(double quantite) throws Exception {
        if(this.getMode().equals("modif")){
            if (quantite <= 0){
                throw new Exception("La quantit\u00E9 ne doit pas \u00EAtre inf\u00E9rieure ou \u00E9gale \u00E0 O");
            }
        }
        this.quantite = quantite;
    }

    public double getPu() {
        return pu;
    }

    public void setPu(double pu) throws Exception {
        if(this.getMode().equalsIgnoreCase("modif") && pu<=0){
            throw new Exception("pu non valide");
        }
        this.pu = pu;
    }

    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant) {
        this.montant = montant;
    }

    public double getTva() {
        return tva;
    }

    public void setTva(double tva) {
        this.tva = tva;
    }

    public String getUnite() {
        return unite;
    }

    public void setUnite(String unite) {
        this.unite = unite;
    }

    public double getRemise() {
        return remise;
    }

    public void setRemise(double remise) {
        this.remise = remise;
    }

    public String getIdDevise() {
        return idDevise;
    }

    public void setIdDevise(String idDevise) {
        this.idDevise = idDevise;
    }

    public double getTauxdechange() {
        return tauxdechange;
    }

    public void setTauxdechange(double tauxdechange) {
        this.tauxdechange = tauxdechange;
    }

    public double getRemiseMontant() {
        return remiseMontant;
    }

    public void setRemiseMontant(double remiseMontant) {
        this.remiseMontant = remiseMontant;
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    public void choisirPropotion(String u, int etat, String idDmdAchat)throws Exception{
        boolean canClose=false;
        Connection c = null;
        try{
            if(c==null){
                c=new UtilDB().GetConn();
                canClose=true;
            }
            ProformaFournisseurDetailsCpl ctr = new ProformaFournisseurDetailsCpl();
            ctr.setNomTable("comparaisonprixproforma");
            ctr.setIdOrigineMere(idDmdAchat);
            ctr.setProduit(this.getProduit());
            ProformaFournisseurDetailsCpl[] liste = (ProformaFournisseurDetailsCpl[]) CGenUtil.rechercher(ctr, null, null, c, "");
            for (ProformaFournisseurDetailsCpl detail : liste) {
                if (!detail.getId().equalsIgnoreCase(this.getId())) {
                    if (etat == ConstanteEtat.getEtatCreer()) {
                        ProformaFournisseurDetails dt = (ProformaFournisseurDetails) detail.dupliquerSansBase();
                        dt.setNomTable("PROFORMAFOURNISSEURDETAILS");
                        dt.setEtat(ConstanteEtat.getEtatCreer());
                        dt.updateToTableWithHisto(u, c);
                    }
                }
            }
            if (etat == ConstanteEtat.getEtatValider())
            {
                this.setEtat(ConstanteEtat.getEtatCreer());
                this.updateToTableWithHisto(u, c);
            }
            else{
                this.setEtat(ConstanteEtat.getEtatValider());
                this.updateToTableWithHisto(u, c);
            }

        } catch(Exception e){
            if(canClose){
                c.rollback();
            }
            throw e;
        } finally {
            if(canClose){
                c.close();
            }
        }
    }
}
