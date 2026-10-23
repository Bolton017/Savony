package client;

import bean.CGenUtil;
import bean.ClassMAPTable;
import utilitaire.UtilDB;

import java.sql.Connection;
import java.sql.Date;

public class ReleverClientOpt extends ClassMAPTable {
    private Date daty;
    private String compte_aux;
    private String libelle;
    private double solde_initial;
    private double debit;
    private double credit;
    private double solde_final;
    private String idclient, journal, lettre,idMere;

    public String getIdMere() {
        return idMere;
    }

    public void setIdMere(String idMere) {
        this.idMere = idMere;
    }
    public boolean estRAN()throws Exception
    {
        if(this.getIdMere()!=null&&this.getIdMere().startsWith("RAN")) return true;
        return false;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public String getCompte_aux() {
        return compte_aux;
    }

    public void setCompte_aux(String compte_aux) {
        this.compte_aux = compte_aux;
    }

    public String getLibelle() {
        return libelle;
    }

    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }

    public double getSolde_initial() {
        return solde_initial;
    }

    public void setSolde_initial(double solde_initial) {
        this.solde_initial = solde_initial;
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

    public double getSolde_final() {
        return solde_final;
    }

    public void setSolde_final(double solde_final) {
        this.solde_final = solde_final;
    }

    public String getIdclient() {
        return idclient;
    }

    public void setIdclient(String idclient) {
        this.idclient = idclient;
    }

    public String getJournal() {
        return journal;
    }

    public void setJournal(String journal) {
        this.journal = journal;
    }

    public String getLettre() {
        return lettre;
    }

    public void setLettre(String lettre) {
        this.lettre = lettre;
    }

    public ReleverClientOpt() throws Exception {
        this.setNomTable("RELEVER_CLIENT_OPT");
    }

    @Override
    public String getTuppleID() {
        return compte_aux;
    }

    @Override
    public String getAttributIDName() {
        return "compte_aux";
    }

    public ReleverClientOpt[] getReleverClientOpt(String idClient, Connection c) throws Exception {
        boolean canClose = false;
        try {
            if (c == null){
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
                canClose = true;
            }
            String aWhere = " and idclient = '" + idClient + "' ORDER BY daty ASC";
            ReleverClientOpt[] releverClientOpts = (ReleverClientOpt[]) CGenUtil.rechercher(new ReleverClientOpt(), null, null, c, aWhere);

            if (releverClientOpts != null) {
                double soldeInitial=0;
                double soldeFinal = 0;

                for (int i = 0; i < releverClientOpts.length; i++) {
                    ReleverClientOpt ligne = releverClientOpts[i];

                    if (i == 0) {
                        soldeInitial = 0;
//                        soldeFinal = Math.abs(ligne.getCredit() - ligne.getDebit());
                        soldeFinal = ligne.getCredit() - ligne.getDebit();
                    } else {
                        if(ligne.estRAN()==false)soldeInitial = soldeFinal;
                        else soldeInitial=0;
                        soldeFinal = soldeInitial + (ligne.getCredit() - ligne.getDebit());
                    }

                    ligne.setSolde_initial(soldeInitial);
                    ligne.setSolde_final(soldeFinal);
                }
            }

            return releverClientOpts;
        } catch (Exception e) {
            if (canClose && c != null){
                c.rollback();
            }
            throw new Exception(e);
        } finally {
            if (c != null && !c.isClosed() && canClose){
                c.commit();
                c.close();
            }
        }
    }
}

