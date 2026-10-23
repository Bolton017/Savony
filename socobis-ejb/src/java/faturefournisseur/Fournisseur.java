/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package faturefournisseur;

import bean.ClassMAPTable;
import java.sql.Connection;

import mg.cnaps.compta.ComptaCompte;
import mg.cnaps.compta.ConstanteCompta;
import pertegain.Tiers;
import utilitaire.Utilitaire;

/**
 *
 * @author nouta
 */
public class Fournisseur extends Tiers{
    protected String contact,codePostal, idTypeFournisseur,code;
    private double taxe, echeance;

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    @Override
    public boolean getEstIndexable() {
        return true;
    }

    public Fournisseur() {
        super.setNomTable("FOURNISSEUR");
    }

    public String getIdTypeFournisseur() {
        return idTypeFournisseur;
    }

    public void setIdTypeFournisseur(String idTypeFournisseur) {
        this.idTypeFournisseur = idTypeFournisseur;
    }

    public String getContact() {
        return contact;
    }

    public void setContact(String contact) {
        this.contact = contact;
    }

    public String getCodePostal() {
        return codePostal;
    }

    public void setCodePostal(String codePostal) {
        this.codePostal = codePostal;
    }

    public double getTaxe() {
        return taxe;
    }

    public void setTaxe(double taxe) {
        this.taxe = taxe;
    }

    public double getEcheance() {
        return echeance;
    }

    public void setEcheance(double echeance) {
        this.echeance = echeance;
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("FRN", "GETSEQFOURNISSEUR");
        this.setId(makePK(c));
    }
 
    @Override
    public String getValColLibelle() {
        return this.getNom();
    }
    @Override
    public String[] getMotCles() {
        return new String[]{"id","nom","code"};
    }
     @Override
    public String[] getValMotCles() {
        String[] valMotCles={"id","nom","code"};
        return valMotCles;
    }

    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {
        try {
            int maxSeq = Utilitaire.getMaxSeq("getseqCompteFournisseur", c);
            String nombre = Utilitaire.completerInt(5, maxSeq);
            if(this.getCompteauxiliaire()==null || this.getCompteauxiliaire().equals("")){
                this.setCompteauxiliaire(nombre);
            }
            ComptaCompte comptaCompte = new ComptaCompte();
            comptaCompte.setCompte(this.getCompteauxiliaire());
            comptaCompte.setLibelle(this.getNom().toUpperCase());
            comptaCompte.setClasse("1");
            comptaCompte.setTypeCompte("2");
            comptaCompte.setIdjournal(ConstanteCompta.journalFournisseur);
            comptaCompte.createObject(u,c);
            return super.createObject(u, c);
        }catch(Exception e){
            throw new Exception("Erreur Creation Fournisseur :"+e.getMessage());
        }
    }
  
}
