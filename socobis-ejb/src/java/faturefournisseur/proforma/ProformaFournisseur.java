package faturefournisseur.proforma;

import bean.ClassMere;
import faturefournisseur.DmdAchat;
import historique.MapUtilisateur;
import ordonnerpaiement.OrdonnerPaiementDetailLib;
import constante.ConstanteEtat;
import faturefournisseur.As_BonDeCommande;
import faturefournisseur.As_BonDeCommande_Fille;
import bean.*;
import change.TauxDeChange;
import utilitaire.Utilitaire;
import java.sql.Connection;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

public class ProformaFournisseur extends ClassMere {
    private String id;
    private Date daty , dateEcheance ;
    private String remarque;
    private String designation;
    private String modepaiement;
    private String fournisseur;
    private String reference;
    private String idDevise;
    private String idMagasin;
    private String idOrigine;
    private double remiseMontant,remise;
    private int echeance ;
    

    public ProformaFournisseur() throws Exception {
        this.setNomTable("PROFORMAFOURNISSEUR");
        this.setLiaisonFille("idMere");
        this.setNomClasseFille("faturefournisseur.proforma.ProformaFournisseurDetails");
    }

    public void construirePK(Connection c) throws Exception {
        this.preparePk("PRF", "getSeqProformaFournisseur");
        this.setId(makePK(c));
    }

    @Override
    public String getLiaisonFille() {
        return "idMere";
    }
    @Override
    public String getNomClasseFille() {
        return "faturefournisseur.proforma.ProformaFournisseurDetails";
    }

    public Date getDateEcheance() {
        return dateEcheance;
    }

    public void setDateEcheance(Date dateEcheance) {
        this.dateEcheance = dateEcheance;
    }

    public int getEcheance() {
        return echeance;
    }

    public void setEcheance(int echeance) {
        this.echeance = echeance;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
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

    public String getModepaiement() {
        return modepaiement;
    }

    public void setModepaiement(String modepaiement) {
        this.modepaiement = modepaiement;
    }

    public String getFournisseur() {
        return fournisseur;
    }

    public void setFournisseur(String fournisseur) {
        this.fournisseur = fournisseur;
    }

    public String getReference() {
        return reference;
    }

    public void setReference(String reference) {
        this.reference = reference;
    }

    public String getIdDevise() {
        return idDevise;
    }

    public void setIdDevise(String idDevise) {
        this.idDevise = idDevise;
    }

    public String getIdMagasin() {
        return idMagasin;
    }

    public void setIdMagasin(String idMagasin) {
        this.idMagasin = idMagasin;
    }

    public String getIdOrigine() {
        return idOrigine;
    }

    public void setIdOrigine(String idOrigine) {
        this.idOrigine = idOrigine;
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    /*@Override
    public String[] getRoleValidation() {
        return new String[]{"respachat", "cheffab", "dg"};
    }*/

    @Override
    public Object validerObject(String u, Connection c) throws Exception {
        /*String role = u.getIdrole();
        switch (role) {
            case "respachat":
                this.setEtat(3);
                break;
            case "cheffab":
                this.setEtat(4);
                break;
            case "dg":
                this.setEtat(11);
                break;
        }*/
        ProformaFournisseurDetails[] filles = this.getDetails(c);
        this.setFille(filles);
        return super.validerObject(u, c);
    }
    public ProformaFournisseurDetails[] getDetails(Connection c) throws Exception {
            ProformaFournisseurDetails opl = new ProformaFournisseurDetails();
            opl.setIdMere(this.getId());
            ProformaFournisseurDetails[] opls = (ProformaFournisseurDetails[]) CGenUtil.rechercher(opl, null, null, c, " ");
            if (opls.length > 0) {
                return opls;
            }
            return null;
    }
    public As_BonDeCommande genererBc(Connection c, ProformaFournisseurDetails[] proDetails) throws Exception {

        DmdAchat[] ds = (DmdAchat[]) CGenUtil.rechercher(new DmdAchat(), null, null, c, " AND ID = '" + this.getIdOrigine() + "' ");

        As_BonDeCommande bc = new As_BonDeCommande();
        bc.setDaty(getDaty());
        bc.setDesignation("BC DE LA PROFORMA " + getId());
        bc.setModepaiement(getModepaiement());
        bc.setRemarque(getRemarque());
        bc.setFournisseur(getFournisseur());
        bc.setReference(getReference());
        bc.setIdDevise(getIdDevise());
        bc.setIdMagasin(getIdMagasin());
        bc.setIdOrigine(getIdOrigine());
        if(ds!=null && ds.length!=0){
            bc.setService(ds[0].getService());
        }
        bc.setEtat(ConstanteEtat.getEtatCreer());

        List<As_BonDeCommande_Fille> liste = new ArrayList<>();
        for (ProformaFournisseurDetails proFille : proDetails) {
            if (proFille.getEtat() != ConstanteEtat.getEtatValider()) {
                continue;
            }

            As_BonDeCommande_Fille bcFille = new As_BonDeCommande_Fille();
            bcFille.setProduit(proFille.getProduit());
            bcFille.setQuantite(proFille.getQuantite());
            bcFille.setPu(proFille.getPu());
            bcFille.setMontant(proFille.getMontant());
            bcFille.setTva(proFille.getTva());
            bcFille.setUnite(proFille.getUnite());
            bcFille.setIdunite(proFille.getUnite());
            bcFille.setRemise(proFille.getRemise());
            if (proFille.getRemise() == 0 && proFille.getRemiseMontant() > 0) {
                double remise = (proFille.getRemiseMontant() * 100)/(proFille.getQuantite() * proFille.getPu());
                bcFille.setRemise(remise);
            }
            bcFille.setIdDevise(proFille.getIdDevise());
            bcFille.setTauxDeChange(proFille.getTauxdechange());

            liste.add(bcFille);
        }

        if (liste.isEmpty()) {
            throw new Exception("Aucun proforma detail valide");
        }

        bc.setFille(liste.toArray(liste.toArray(new As_BonDeCommande_Fille[]{})));
        return bc;
    }

    public As_BonDeCommande genererBc(Connection c) throws Exception {
        ProformaFournisseurDetails[] proDetails = (ProformaFournisseurDetails[]) this.getDetails(c);
        As_BonDeCommande as = this.genererBc(c, proDetails);
        return as;
    }

    public double getRemiseMontant() {
        return remiseMontant;
    }

    public void setRemiseMontant(double remiseMontant) {
        this.remiseMontant = remiseMontant;
    }

    public double getRemise() {
        return remise;
    }

    public void setRemise(double remise) {
        this.remise = remise;
    }

    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {
        double taux = 1;
        if (this.getIdDevise() != null && this.getIdDevise().compareToIgnoreCase("AR") != 0) {
            taux = TauxDeChange.getLastTaux(c, Utilitaire.formatterDaty(this.getDaty()), this.getIdDevise());
        }

        ProformaFournisseurDetails[] ps = (ProformaFournisseurDetails[]) this.getFille();
        if (ps != null) {
            for (int i = 0; i < ps.length; i++) {
                ps[i].setEtat(1);
                if (this.getIdDevise() != null) {
                    ps[i].setIdDevise(this.getIdDevise());
                }
                if (ps[i].getIdDevise() != null && ps[i].getIdDevise().compareToIgnoreCase("AR") != 0 && ps[i].getTauxdechange() <= 1) {
                    ps[i].setTauxdechange(taux);
                }
            }
        }
        return super.createObject(u, c);
    }
}
