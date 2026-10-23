package mg.cnaps.compta;

import bean.CGenUtil;
import bean.TypeObjet;
import utilitaire.UtilDB;

import java.sql.Connection;

public class Journal extends TypeObjet {
    private String compte;

    public String getCompte() {
        return compte;
    }

    public void setCompte(String compte) {
        this.compte = compte;
    }

    public Journal() {
        this.setNomTable("compta_journal");
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("COMP", "GET_SEQ_COMPTA_JOURNAL");
        this.setId(makePK(c));
    }
    @Override
    public void controler(Connection c) throws Exception {
        if(this.val==null || this.val.isEmpty()){
            throw new Exception("Code de Journal Obligatoire");
        }
        Journal[] listejournal = null;
        boolean verif = false;
        try {
            if (!verif) {
                c = new UtilDB().GetConn();
                verif=true;
            }
            listejournal = (Journal[]) CGenUtil.rechercher(this, null, null, c, "");
            if (listejournal.length > 0)
                throw new Exception("Impossible d' ajouter Journal existant");

        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        } finally {
            if (verif && c != null)
                c.close();
        }
    }

    public Journal getJournalByVal(Connection c, String val) throws Exception {
        boolean canClose = false;
        try {
            if (c == null) {
                canClose = true;
                c = new UtilDB().GetConn();
            }

            Journal journal = new Journal();
            Journal[] journals  = (Journal[]) CGenUtil.rechercher(journal, null, null, c, " and val = '" + val + "'");
            if (journals.length > 0) {
                journal = journals[0];
                return journal;
            }
            throw new Exception("Valeur de Journal Invalid");
        } finally {
            if (canClose && c != null) {
                c.close();
            }
        }
    }
}
