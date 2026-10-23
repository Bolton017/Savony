/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package mg.cnaps.compta.ecriture;

import mg.cnaps.compta.ComptaEcriture;

/**
 *
 * @author Kanto
 */
public class ComptaEcritureLib extends ComptaEcriture{
    private double montant;
    private String journalLib,etatlib;
    private String lien;
    private String idModificateurlib;
    private String journalcode;
    private String tierslib;
    private String piece,reference,journalDesce;
    private String source;

    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }

    public String getPiece() {
        return piece;
    }

    public void setPiece(String piece) {
        this.piece = piece;
    }

    public String getJournalcode() {
        return journalcode;
    }

    public void setJournalcode(String journalcode) {
        this.journalcode = journalcode;
    }

    public String getEtatlib() {
        return etatlib;
    }

    public void setEtatlib(String etatlib) {
        this.etatlib = etatlib;
    }

    public String getLien() {
        return lien;
    }

    public void setLien(String lien) {
        this.lien = lien;
    }

    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant) {
        this.montant = montant;
    }

    public String getJournalLib() {
        return journalLib;
    }

    public void setJournalLib(String journalLib) {
        this.journalLib = journalLib;
    }

    public String getIdModificateurlib() {
        return idModificateurlib;
    }

    public void setIdModificateurlib(String idModificateurlib) {
        this.idModificateurlib = idModificateurlib;
    }

    public String getReference() {
        return reference;
    }

    public void setReference(String reference) {
        this.reference = reference;
    }

    public ComptaEcritureLib() throws Exception
    {
        this.setNomTable("compta_exercice_lib");
    }

    public String getJournalDesce() {
        return journalDesce;
    }

    public void setJournalDesce(String journalDesce) {
        this.journalDesce = journalDesce;
    }

    public String getTierslib() {
        return tierslib;
    }

    public void setTierslib(String tierslib) {
        this.tierslib = tierslib;
    }
    
}
