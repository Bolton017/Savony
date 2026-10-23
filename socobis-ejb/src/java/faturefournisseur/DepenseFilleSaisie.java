package faturefournisseur;

import bean.ClassMAPTable;
import bean.LibelleAffichage;

import java.sql.Connection;

public class DepenseFilleSaisie extends FactureFournisseurDetails{
    private String intitule;
    private String libelle;
    private String compte, compteanalytique;
    private double debit;
    private double credit;
    private double montanttva, puht;
    @LibelleAffichage("Montant HT")
    protected double pu;
    @LibelleAffichage("Intitul&eacute;")
    protected String idProduit;
    @LibelleAffichage("TVA en %")
    protected double tva;



    public String getCompteanalytique() {
        return compteanalytique;
    }

    public void setCompteanalytique(String compteanalytique) {
        this.compteanalytique = compteanalytique;
    }

    public double getPuht() {
        return puht;
    }

    public void setPuht(double puht) {
        this.puht = puht;
    }

    public String getIntitule() {
        return intitule;
    }

    public void setIntitule(String intitule) {
        this.intitule = intitule;
    }

    public String getLibelle() {
        return libelle;
    }

    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }

    @Override
    public String getCompte() {
        return compte;
    }

    @Override
    public void setCompte(String compte) {
        this.compte = compte;
    }

    public double getDebit() {
        return debit;
    }

    public void setDebit(double debit) {
        this.debit = debit;
    }

    public double getCredit() {
        return credit;
    }

    public void setCredit(double credit) {
        this.credit = credit;
    }

    public double getMontanttva() {
        return montanttva;
    }

    public void setMontanttva(double montanttva) {
        this.montanttva = montanttva;
    }

    public DepenseFilleSaisie() throws Exception {
        this.setNomTable("DEPENSEFILLESAISIE");
    }

    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {
        this.setNomTable("FACTUREFOURNISSEURFILLE");
        double tva = this.getTva();
        double montantttc = this.getPu();
        this.setPu(montantttc/(1+tva/100));
        return super.createObject(u, c);
    }
}
